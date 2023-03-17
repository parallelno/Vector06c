#!/usr/bin/env python3
import struct
import sys
import os
from pathlib import Path

#from utils import *
import lhafile      # pip3 install lhafile
import io

from collections import Counter
import heapq

def lzss_compress(data, window_size=4096, min_match_len=3):
	compressed_data = []
	index = 0
	data_len = len(data)

	while index < data_len:
		# Search for the longest match in the sliding window
		best_offset = -1
		best_length = 0

		for offset in range(1, min(window_size, index + 1)):
			length = 0
			while (index + length < data_len and
				   data[index - offset + length] == data[index + length] and
				   length < 18):
				length += 1

			if length >= min_match_len and length > best_length:
				best_offset = offset
				best_length = length

		if best_length >= min_match_len:
			# Store the length-offset pair as a tuple
			compressed_data.append((best_offset, best_length))
			#compressed_data.append(best_offset)
			#compressed_data.append(best_length)
			index += best_length
		else:
			# Store the literal byte
			compressed_data.append(data[index])
			index += 1

	return compressed_data

def lzss_compress2(data, preceding_data=None, window_size=4096, min_match_len=3):
	compressed_data = []
	index = 0
	data_len = len(data)

	if preceding_data is None:
		preceding_data = []#b''

	while index < data_len:
		# Search for the longest match in the sliding window
		best_offset = -1
		best_length = 0

		for offset in range(1, min(window_size, index + 1 + len(preceding_data))):
			length = 0

			while (index + length < data_len and
				   (index - offset + length < 0 or
					data[index - offset + length] == data[index + length]) and
				   length < 18):
				if index - offset + length < 0:
					window_byte = preceding_data[index - offset + length + len(preceding_data)]
				else:
					window_byte = data[index - offset + length]

				if window_byte == data[index + length]:
					length += 1
				else:
					break

			if length >= min_match_len and length > best_length:
				best_offset = offset
				best_length = length

		if best_length >= min_match_len:
			# Store the length-offset pair as a tuple
			compressed_data.append((best_offset, best_length))
			index += best_length
		else:
			# Store the literal byte
			compressed_data.append(data[index])
			index += 1

	return compressed_data

def lzss_compress3(data, preceding_data=None, window_size=4096, min_match_len=3):
	compressed_data = []
	index = 0
	data_len = len(data)

	if preceding_data is None:
		preceding_data = b''

	while index < data_len:
		best_offset = -1
		best_length = 0

		for offset in range(1, min(window_size, index + 1 + len(preceding_data))):
			length = 0

			while (index + length < data_len and
				   (index - offset + length < 0 or
					(index - offset + length >= len(preceding_data) and
					 data[index - offset + length - len(preceding_data)] == data[index + length]) or
					(index - offset + length < len(preceding_data) and
					 preceding_data[index - offset + length] == data[index + length])) and
				   length < 18):

				length += 1

			if length >= min_match_len and length > best_length:
				best_offset = offset
				best_length = length

		if best_length >= min_match_len:
			compressed_data.append((best_offset, best_length))
			index += best_length
		else:
			compressed_data.append(data[index])
			index += 1

	return compressed_data

def lzss_compress4(data, preceding_data=None, window_size=4096, min_match_len=3):
	compressed_data = []
	index = 0
	data_len = len(data)

	if preceding_data is None:
		preceding_data = b''

	while index < data_len:
		best_offset = -1
		best_length = 0

		for offset in range(1, min(window_size, index + 1 + len(preceding_data))):
			length = 0

			while (index + length < data_len and
				   (index - offset + length < 0 or
					(index - offset + length >= len(preceding_data) and
					 data[index - offset + length - len(preceding_data)] == data[index + length]) or
					(index - offset + length < len(preceding_data) and
					 preceding_data[index - offset + length] == data[index + length])) and
				   length < 18):

				length += 1

			if length >= min_match_len and length > best_length:
				best_offset = offset
				best_length = length

		if best_length >= min_match_len and index - best_offset + best_length - 1 >= len(preceding_data):
			compressed_data.append((best_offset, best_length))
			index += best_length
		else:
			compressed_data.append(data[index])
			index += 1

	return compressed_data

def lzss_compress5(data, preceding_data=None, window_size=4096, min_match_len=3):
	compressed_data = []
	index = 0
	data_len = len(data)

	if preceding_data is None:
		preceding_data = b''

	while index < data_len:
		best_offset = -1
		best_length = 0

		for offset in range(1, min(window_size, index + 1 + len(preceding_data))):
			length = 0

			while (index + length < data_len and
				   (index - offset + length < 0 or
					(index - offset + length >= len(preceding_data) and
					 data[index - offset + length - len(preceding_data)] == data[index + length]) or
					(index - offset + length < len(preceding_data) and
					 preceding_data[index - offset + length] == data[index + length])) and
				   length < 18):

				length += 1

			if length >= min_match_len and length > best_length:
				best_offset = offset
				best_length = length

		if best_length >= min_match_len and index - best_offset + best_length - 1 >= len(preceding_data):
			compressed_data.append((best_offset, best_length))
			index += best_length
		else:
			compressed_data.append(data[index])
			index += 1

	return compressed_data

def lzss_decompress5(compressed_data, preceding_data=None):
	decompressed_data = bytearray()

	if preceding_data is None:
		preceding_data = b''

	for item in compressed_data:
		if isinstance(item, tuple):
			offset, length = item
			for i in range(length):
				if len(decompressed_data) - offset + i < len(preceding_data):
					decompressed_data.append(preceding_data[len(decompressed_data) - offset + i])
				else:
					decompressed_data.append(decompressed_data[len(decompressed_data) - offset + i - len(preceding_data)])
		else:
			decompressed_data.append(item)

	return bytes(decompressed_data)

def lzss_decompress2(compressed_data, preceding_data=None):
	decompressed_data = []#bytearray()
	
	if preceding_data is None:
		preceding_data = []#b''

	for item in compressed_data:
		if isinstance( item, tuple):
			offset, length = item
			start_index = len( decompressed_data) - offset

			if start_index < 0:
				decompressed_data.extend( preceding_data[ start_index + len(preceding_data): ] + preceding_data[len(preceding_data):start_index + len(preceding_data) + length])
			else:
				decompressed_data.extend( decompressed_data[ start_index : start_index + length])
		else:
			decompressed_data.append( item)

	return decompressed_data

def lzss_compress6(data, preceding_data=None, window_size=4096, min_match_len=3):
	compressed_data = []
	index = 0
	data_len = len(data)

	if preceding_data is None:
		preceding_data = b''

	while index < data_len:
		best_offset = -1
		best_length = 0

		for offset in range(1, min(window_size, index + 1)):
			length = 0

			while (index + length < data_len and
				(index - offset + length >= len(preceding_data) and
				data[index - offset + length - len(preceding_data)] == data[index + length]) or
				(index - offset + length < len(preceding_data) and
				preceding_data[index - offset + length] == data[index + length])) and length < 18:
				
				length += 1

			if length >= min_match_len and length > best_length:
				best_offset = offset
				best_length = length

		if best_length >= min_match_len:
			compressed_data.append((best_offset, best_length))
			index += best_length
		else:
			compressed_data.append(data[index])
			index += 1

	return compressed_data


def lzss_decompress6(compressed_data, preceding_data=None):
	decompressed_data = bytearray()

	if preceding_data is None:
		preceding_data = b''

	for item in compressed_data:
		if isinstance(item, tuple):
			offset, length = item
			for i in range(length):
				if len(decompressed_data) - offset + i < len(preceding_data):
					decompressed_data.append(preceding_data[len(decompressed_data) - offset + i])
				else:
					decompressed_data.append(decompressed_data[len(decompressed_data) - offset + i - len(preceding_data)])
		else:
			decompressed_data.append(item)

	return bytes(decompressed_data)

def lzss_compress7(text, max_length=255, min_length=3):
	compressed = []
	i = 0

	while i < len(text):
		best_offset = -1
		best_length = -1

		for offset in range(1, min(i + 1, max_length + 1)):
			length = 0
			while (i + length < len(text) and
				   length < offset and
				   length < max_length and
				   text[i - offset + length] == text[i + length]):
				length += 1

			if length >= min_length and length > best_length:
				best_offset = offset
				best_length = length

		if best_length >= min_length:
			compressed.append((-best_offset, best_length))
			i += best_length
		else:
			compressed.append(text[i])
			i += 1

	return compressed


def lzss_decompress7(compressed):
	decompressed = []

	for item in compressed:
		if isinstance(item, tuple):
			offset, length = item
			for i in range(length):
				decompressed.append(decompressed[len(decompressed) + offset])
		else:
			decompressed.append(item)

	return bytes(decompressed)

def lzss_compress8(text, known_data = [], max_length=4000, min_length=3):
	combined_data = known_data + text
	compressed = []
	i = len(known_data)

	while i < len(combined_data):
		best_offset = -1
		best_length = -1

		for offset in range(1, min(i + 1, max_length + 1)):
			length = 0
			while (i + length < len(combined_data) and
				   length < offset and
				   length < max_length and
				   combined_data[i - offset + length] == combined_data[i + length]):
				length += 1

			if length >= min_length and length > best_length:
				best_offset = offset
				best_length = length

		if best_length >= min_length:
			compressed.append((-best_offset, best_length))
			i += best_length
		else:
			compressed.append(combined_data[i])
			i += 1

	return compressed

def lzss_decompress8(compressed, known_data=''):
	decompressed = list(known_data)

	for item in compressed:
		if isinstance(item, tuple):
			offset, length = item
			for i in range(length):
				decompressed.append(decompressed[len(decompressed) + offset])
		else:
			decompressed.append(item)

	return decompressed[len(known_data):]

#====================

def generate_known_data(data, known_data_size=256, sequence_length=4):
	byte_sequence_counter = Counter()
	
	for i in range(len(data) - sequence_length + 1):
		byte_sequence = data[i:i+sequence_length]
		byte_sequence_counter[byte_sequence] += 1

	most_common_sequences = heapq.nlargest(known_data_size // sequence_length, byte_sequence_counter, key=byte_sequence_counter.get)
	known_data = b''
	for arr in most_common_sequences[:known_data_size]:
		known_data += arr
	return known_data

def generate_known_data2(text, num_substrings=10, sequence_length=4):
	substring_counter = Counter()

	for i in range(len(text) - sequence_length + 1):
		substring = text[i:i+sequence_length]
		substring_counter[substring] += 1

	most_common_substrings = heapq.nlargest(num_substrings, substring_counter, key=substring_counter.get)
	
	# Remove substrings containing other substrings
	filtered_substrings = []
	for substring in most_common_substrings:
		is_contained = False
		for other_substring in most_common_substrings:
			if substring != other_substring and substring in other_substring:
				is_contained = True
				break

		if not is_contained:
			filtered_substrings.append(substring)

	known_data = b''
	for arr in filtered_substrings[:num_substrings]:
		known_data += arr
	return known_data

def build_lzw_dictionary_bytearray(text):
    # Initialize the dictionary with individual characters
    dictionary = {chr(i): i for i in range(256)}

    next_code = 256
    prefix = ''

    for char in text:
        combined = prefix + chr(char)

        if combined not in dictionary:
            dictionary[combined] = next_code
            next_code += 1

            prefix = chr(char)
        else:
            prefix = combined

    return dictionary

def generate_known_data3(text):
	dict = build_lzw_dictionary_bytearray(text)
	# make a list from dict
	dict_list = []
	for str in dict:
		value = dict[str]
		dict_list.append((str, 1))
	
	dict_list.reverse()
	
	for i, (str, counter) in enumerate(dict_list):
		# set a string's counter = 0 if len of str < 4
		if counter == 0 or len(str) < 4:
			continue
		# if any next strings in the list with counter > 0 are substrings of srt, then make their counter = 0
		if i+1 < len(dict_list):
			for j in range(i+1, len(dict_list)):
				str2, counter2 = dict_list[j]
				if counter2 == 0:
					continue
				if str2 in str:
					dict_list[j] = ("", 0)

	# combine all the strings of dict_list into one string
	out = ''
	for str, counter in dict_list:
		if counter > 0:
			out += str

	return out.encode('utf-8')


def print_out(data, out, decoded):
	print(f"input file size: {len(data)}")
	print(data)
	print(f"output file size: {len(compressed_to_bytes(out))}")
	print(out)       
	print(f"decoded file size: {len(decoded)}")
	#print(decoded)
	print_check(data, decoded)	

def print_check(data, decoded): 
	if len(data) != len(decoded):
		print("do not match")
		return
	for i, byte in enumerate(data):
		if byte != decoded[i]:
			print("do not match")
			return
	print("match!")
	return

def compressed_to_bytes(compressed):
	out = []
	for item in compressed:
		if isinstance(item, tuple):
			offset, length = item
			out.append(offset)
			out.append(length)
		else:
			out.append(item)

	return out

binFile1 = "C:\\Work\\Programming\\_Dev\\Vector06c_Dev\\_Projects\\GameNoname\\temp\\level_compression\\level_tmp1.bin"
binFile2 = "C:\\Work\\Programming\\_Dev\\Vector06c_Dev\\_Projects\\GameNoname\\temp\\level_compression\\level_tmp2.bin"
binFile3 = "C:\\Work\\Programming\\_Dev\\Vector06c_Dev\\_Projects\\GameNoname\\temp\\level_compression\\level_tmp3.bin"

with open(binFile1, "rb") as f:
	data1 = list(f.read())

with open(binFile2, "rb") as f:
	data2 = list(f.read())
		
with open(binFile3, "rb") as f:
	data3 = list(f.read())

#prev = []
combined_input = data1 + data2 + data3
known_data = compressed_to_bytes(generate_known_data3(list(combined_input)))
# get only NNN first literals
known_data = known_data[:512]

print("\n\nbinFile1")
out1 = lzss_compress8(data1, known_data)
decoded1 = lzss_decompress8(out1, known_data)
print_out(data1, out1, decoded1)

print("\n\nbinFile2")
#prev.append(compressed_to_bytes(out1))
out2 = lzss_compress8(data2, known_data)
decoded2 = lzss_decompress8(out2, known_data)
print_out(data2, out2, decoded2)

print("\n\nbinFile3")
#prev.append(compressed_to_bytes(out2))
out3 = lzss_compress8(data3, known_data)
decoded3 = lzss_decompress8(out3, known_data)
print_out(data3, out3, decoded3)


'''
preceding_data = b"This is known data. "
data = b"this is a simple test for the lzss compression algorithm"
compressed_data = lzss_compress8(data, known_data=preceding_data)
decompressed_data = lzss_decompress8(compressed_data, known_data=preceding_data)

print("Original data: ", data)
print("Compressed data: ", compressed_data)
print("Decompressed data: ", decompressed_data)
print("Original and decompressed data are the same: ", data == decompressed_data)
print(f"input str size: {len(data)}, compressed size: {len(compressed_to_bytes(compressed_data))}")
'''