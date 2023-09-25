import os
import json
import build

def combine_bits_to_bytes(_bits):
	bytes = []
	i = 0
	while i < len(_bits):
		byte = 0
		for j in range(8):
			byte += _bits[i] << 7-j
			i += 1
		bytes.append(byte)
	return bytes

def path_to_basename(path):
	path_wo_ext = os.path.splitext(path)[0]
	name = os.path.basename(path_wo_ext)
	return name

def is_bytes_zeros(bytes):
	for byte in bytes: 
		if byte != 0 : return False
	return True

def bytes_to_asm(data, numbers_in_line = 16, add_empty_line = False):
	asm = ""
	for i, byte in enumerate(data):
		if i % numbers_in_line == 0:
			if i != 0:
				asm += "\n"
			asm += "			.byte "
		asm += str(byte) + ","

	asm += "\n"
	if add_empty_line:
		asm += "\n"
	return asm

def words_to_asm(data, numbers_in_line = 16):
	asm = ""
	for i, word in enumerate(data):
		if i % numbers_in_line == 0:
			if i != 0:
				asm += "\n"
			asm += "			.word "
		asm += str(word) + ","
	return asm + "\n"

def bin_to_asm(path, out_path):
	with open(path, "rb") as file:
		txt = ""
		while True:
			data = file.read(32)
			if data:
				txt += "\n.byte "
				for byte in data:
					txt += str(byte) + ", " 
			else: break
		
		with open(out_path, "w") as fw:
			fw.write(txt)

def run_command(command, comment = "", check_path = ""):
	if comment != "" : 
		print(comment)
	if check_path == "" or os.path.isfile(check_path):
		os.system(command)
	else:
		print(f"run_command ERROR: command: {command} is failed. file {check_path} doesn't exist")
		exit(1)

def delete_file(path):
	if os.path.isfile(f"{path}"):
		os.remove(f"{path}")

def load_json(source_j_path):
	with open(source_j_path, "rb") as file:
		source_j = json.load(file)
	return source_j

def remove_double_slashes(path):
	res = ""
	doubled_slashe = False
	for char in path:
		if char != '\\':
			res += char
			doubled_slashe = False
		else:
			if doubled_slashe == False:
				res += char
				doubled_slashe = True
			else:
				doubled_slashe = False
	return res

def double_slashes(path):
	res = ""
	for char in path:
		res += char
		if char == '\\':
			res += char
	return res

def get_addr_wo_prefix(hex_string):
	hex_string_without_prefix = hex_string.replace("$", "")
	hex_string_without_prefix = hex_string_without_prefix.replace("0x", "")

	if int(hex_string_without_prefix, 16) == 0:
		hex_string_without_prefix = "0"

	return hex_string_without_prefix

def hex_str_to_int(hex_string):
	hex_string_without_prefix = hex_string.replace("$", "")
	return int(hex_string_without_prefix, 16)

def align_string(str, allign, to_left = False):
	addition = "                   "
	if to_left:
		str = addition + str
		return str[-allign:]
	else:
		str += addition
		return str[0:allign]

def get_label_addr(path, _label):
	with open(path, "rb") as file:
		labels = file.readlines()

	if len(labels) == 0:
		return 0

	for line_a in labels:
		line = line_a.decode('ascii')
		if line.find(_label) != -1:
			addr_s = line[line.find("$")+1:]
			return int(addr_s, 16)

	return -1

def compress(source_path, path_compressed):
	delete_file(path_compressed)
	run_command(f"{build.packer_path} {source_path} {path_compressed}")
	
def asm_compress_to_asm(asm, path_tmp = "temp\\", delete_tmp_asm = True, delete_tmp_bin = True, delete_tmp_packed = True):
	asm = ".org 0 \n" + asm

	# save room data to a temp file
	path_asm = path_tmp + "tmp" + build.EXT_ASM
	path_bin = path_tmp + "tmp" + build.EXT_BIN
	path_packed = path_tmp + "tmp" + build.packer_ext

	with open(path_asm, "w") as file:
		file.write(asm)

	# asm to temp bin
	run_command(f"{build.assembler_path} {path_asm} "
		f" {path_bin}")
	
	# pack a room data
	run_command(f"{build.packer_path} {path_bin} {path_packed}")
	
	# load bin
	with open(path_packed, "rb") as file:
		asm_packed = bytes_to_asm(file.read())

	# del tmp files
	if delete_tmp_asm:
		delete_file(path_asm)
	if delete_tmp_bin:
		delete_file(path_bin) 
	if delete_tmp_packed:
		delete_file(path_packed)

	return asm_packed