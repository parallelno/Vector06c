import os
from pathlib import Path
from PIL import Image
from sklearn.cluster import KMeans
import numpy as np
import math
import cv2
import difflib
import time
import concurrent.futures
import threading

import sys
lib_path = os.path.abspath(os.path.join(os.path.dirname(__file__), '..', '..', '..', 'scripts'))
sys.path.append(lib_path)

from common import *
from common_gfx import *
from build import *

IMAGE_VECTOR_COLOR_MAX = 16
PNG_EXT = ".png"

def image_to_tiles(image, tile_size=8):
	width, height = image.size
	tiles = []
	for i in range(0, height, tile_size):
		for j in range(0, width, tile_size):
			tile = np.array(image.crop((j, i, j + tile_size, i + tile_size)))
			tiles.append(tile)
	return np.array(tiles)

def tiles_to_image(tiles, tiles_x, tiles_y, tile_size):
	image = Image.new('RGB', (tiles_x * tile_size, tiles_y * tile_size))
	tiles_len = len(tiles)

	tiles_coords = []

	tile_idx = 0
	for ty in range(tiles_y):
		for tx in range(tiles_x):
			if tile_idx >= tiles_len:
				break
			tile = Image.fromarray(tiles[tile_idx], 'RGB')
			coord = (tx * tile_size, ty * tile_size)
			image.paste(tile, coord)
			tiles_coords.append(coord)
			tile_idx += 1
	return image, tiles_coords

def train_codebook(tiles, n_clusters, random_state = 42, n_init = 'auto'):
	kmeans = KMeans(n_clusters=n_clusters, random_state=random_state, n_init=n_init)
	flattened_tiles = tiles.reshape(tiles.shape[0], -1)
	kmeans.fit(flattened_tiles)
	return kmeans

def compress_image(tiles, codebook):
	flattened_tiles = tiles.reshape(tiles.shape[0], -1)
	compressed_indices = codebook.predict(flattened_tiles)
	return compressed_indices

def vector_quantization_compression(image, n_clusters = 256, tile_size = 8, random_state = 42, n_init = 'auto'):

	# Train the codebook
	tiles = image_to_tiles(image, tile_size)
	'''
#================================================
# test to add mirrored tiles
	#mirrored_tiles = mirror_tiles(tiles)
	#tiles_plus_mirrored = np.concatenate(tiles, mirrored_tiles)

	# codebook = train_codebook(tiles_plus_mirrored, n_clusters, random_state, n_init)

	# Compress and decompress the image
	# compressed_indices = compress_image(tiles_plus_mirrored, codebook)

	# test to add mirrored tiles	
	# count how many mirrored tiles were used
	used_mirrored_tiles_count = count_used_mirrored_tiles(compressed_indices, codebook, mirrored_tiles)
#================================================
	'''
	codebook = train_codebook(tiles, n_clusters, random_state, n_init)

	# Compress and decompress the image
	compressed_indices = compress_image(tiles, codebook)
	
	return compressed_indices, codebook

def mirror_tiles(tiles):
	mirrored_tiles = []
	for tile in tiles:
		mirrored_tiles.append(np.flip(tile))
	return mirrored_tiles

def displa_PIL_image(image):
	np_image = np.array(image)
	# Convert the color space from RGB to BGR
	bgr_image = cv2.cvtColor(np_image, cv2.COLOR_RGB2BGR)
	# Display the image in a window
	cv2.imshow('Image', bgr_image)
	cv2.waitKey(0)
	cv2.destroyAllWindows()	

def tiles_to_image_indexed(tiles_gfx, palette, tile_size):	
	tiles_gfx_len = len(tiles_gfx)

	tiles_x = int(math.sqrt(tiles_gfx_len))
	tiles_y = tiles_gfx_len // tiles_x
	if (tiles_gfx_len % tiles_x) > 0:
		tiles_y += 1

	width = tiles_x * tile_size
	height = tiles_y * tile_size

	image = Image.new('P', (width, height), color=0)
	image.putpalette(palette)

	pixels = image.load()
	tile_gfx_idx = 0

	for dy in range(tiles_y):
		for dx in range(tiles_x):		

			if tile_gfx_idx >= tiles_gfx_len:
				break

			tile_gfx = tiles_gfx[tile_gfx_idx]
			# copy a tile into an image
			i = 0
			for x in range(dx * tile_size, dx * tile_size + tile_size):
				for y in range(dy * tile_size, dy * tile_size + tile_size):
					pixels[x, y] = tile_gfx[i]
					i += 1
			tile_gfx_idx += 1
	return image

def codebook_to_img(compressed_indices, codebook, tile_size):

	decompressed_tiles = codebook.cluster_centers_[compressed_indices].reshape(-1, tile_size, tile_size, 3).astype(np.uint8)

	# to map old_tile_gfx_idx into a range from 0 to max used unique tiles ( less or equal to n_clusters)
	gfx_idxs_mapper = {}
	tiles_gfx = []
	
	new_tile_gfx_idx = 0
	# collect only unique gfx_idxs_mapper
	for i, tile_gfx_idx in enumerate(compressed_indices):
		if tile_gfx_idx not in gfx_idxs_mapper:
			gfx_idxs_mapper[tile_gfx_idx] = new_tile_gfx_idx
			tiles_gfx.append(decompressed_tiles[i])
			new_tile_gfx_idx += 1

	# remap compressed_indices into new tile_gfx_idx
	tile_idxs = []
	for old_tile_gfx_idx in compressed_indices:
		tile_idxs.append(gfx_idxs_mapper[old_tile_gfx_idx])

	# atlas size
	tiles_len = len(tiles_gfx)
	atlas_tiles_x = int(math.sqrt(tiles_len))
	atlas_tiles_y = tiles_len // atlas_tiles_x
	if (tiles_len % atlas_tiles_x) > 0:
		atlas_tiles_y += 1

	atlas, tiles_coords = tiles_to_image(tiles_gfx, atlas_tiles_x, atlas_tiles_y, tile_size)

	return tile_idxs, atlas, tiles_coords

# adjust the color channels (R: 3 bits, G: 3 bits, B: 2 bits)
def adjust_color_channels(pixel):
	r, g, b = pixel
	r = (r >> 5) << 5
	g = (g >> 5) << 5
	b = (b >> 6) << 6
	return r, g, b

def image_to_indexed(image):
	# to color bit-death
	image_adjusted_rgb = Image.new("RGB", image.size)
	image_adjusted_rgb.putdata([adjust_color_channels(pixel) for pixel in image.getdata()])

	# to indexed color with 16 colors using an adaptive palette
	return image_adjusted_rgb.quantize(colors=IMAGE_VECTOR_COLOR_MAX, method=1)

def atlas_to_image(tile_idxs_sorted, tiles_gfx, palette, out_width, out_height, tile_size):
	image = Image.new('P', (out_width, out_height), color=0)
	image.putpalette(palette)
	
	img_width_in_tiles = out_width // tile_size
	img_height_in_tiles = out_height // tile_size

	pixels = image.load()
	for dy in range(img_height_in_tiles):
		for dx in range(img_width_in_tiles):
			
			tile_idx = dy * img_width_in_tiles + dx
			tile_gfx_id = tile_idxs_sorted[tile_idx]
			tile_gfx = tiles_gfx[tile_gfx_id]
		
			i = 0
			for x in range(dx * tile_size, dx * tile_size + tile_size):
				for y in range(dy * tile_size, dy * tile_size + tile_size):
					pixels[x, y] = tile_gfx[i]
					i += 1
				
	return image

# combines RGB values into a Vector06c color format
def pack_color(r,g,b):
	r = r >> 5
	g = g >> 5
	g = g << 3
	b = b >> 6
	b = b << 6
	return b | g | r

def palette_to_asm(colors, label_prefix):
	asm = "			.word 0 ; safety pair of bytes for reading by POP B\n"
	asm += label_prefix + "_palette:\n"

	for color_idx in range(IMAGE_VECTOR_COLOR_MAX):
		r = colors[color_idx*3 + 0]
		g = colors[color_idx*3 + 1]
		b = colors[color_idx*3 + 2]
		color_packed = pack_color(r, g, b)

		if color_idx % 4 == 0 : asm += "			.byte "
		asm += "%" + format(color_packed, '08b') + ", "
		if color_idx % 4 == 3 : asm += "\n"
	return asm	

def similarity(bytearray1, bytearray2):
	# calculate the similarity score between two bytearrays using SequenceMatcher ratio() method
	seq1 = bytearray1.hex()
	seq2 = bytearray2.hex()
	matcher = difflib.SequenceMatcher(None, seq1, seq2)
	return matcher.ratio()

def sort_dict_by_similarity(dict_to_sort):
	# sort a dictionary of tiles (list of color_idxs) by their similarity and return a new dictionary
	sorted_dict = {}
	keys_sorted_by_similarity = sorted(dict_to_sort, key=lambda x: dict_to_sort[x])
	# key = old index, value = sorted index
	index_map = {}
	for i, key in enumerate(keys_sorted_by_similarity):
		sorted_dict[i] = dict_to_sort[key]
		index_map[key] = i
	return sorted_dict, index_map

def sort_tiles(tile_idxs, atlas, tiles_coords, tile_size):
	# split the atlas into a dict of tiles (list of color_idxs)
	tiles_color_idxs = {}
	for i, coord in enumerate(tiles_coords):
		x, y = coord
		color_idxs = []
		for tx in range(x, x + tile_size):
			for ty in range(y, y + tile_size):
				color_idx = atlas.getpixel((tx, ty))
				color_idxs.append(color_idx)

		tiles_color_idxs[i] = color_idxs

	tiles_color_idxs_sorted, index_map = sort_dict_by_similarity(tiles_color_idxs)

	# remap tile_gfx_idxs
	for i, old_tile_idx in enumerate(tile_idxs):
		tile_idxs[i] = index_map[old_tile_idx]

	return tile_idxs, tiles_color_idxs_sorted

def color_indices_to_asm(tiles_gfx):
	# pack 2 color indices into one byte
	packed_color_idxs = []
	for tile_idx in tiles_gfx:
		tile_gfx = tiles_gfx[tile_idx]
		for idx in range(len(tile_gfx)//2):
			color_idx_01 = tile_gfx[idx * 2 + 0]
			color_idx_02 = tile_gfx[idx * 2 + 1]
			packed_idxs = color_idx_02<<4 | color_idx_01
			packed_color_idxs.append(packed_idxs)

	return common.bytes_to_asm(packed_color_idxs)

def get_asm(tile_idxs_sorted, tiles_gfx, palette, path):
	label_prefix = "__image_"
	asm = "; " + path + "\n"
	asm += palette_to_asm(palette, label_prefix)
	
	# store tile indices
	asm += "indices:\n"	
	
	max_value = max(tile_idxs_sorted)
	if max_value < 256:
		asm += common.bytes_to_asm(tile_idxs_sorted)
	else:
		asm += common.words_to_asm(tile_idxs_sorted)
	
	# store tile gfx
	asm += "gfx:\n"
	asm += color_indices_to_asm(tiles_gfx)
	return asm

def asm_to_bin_zx0(asm, dir, base_name, packer_path, delete_encoded):
	asm = ".org 0 \n" + asm

	# save room data to a temp file
	path_asm = dir + "\\" + base_name + ".asm"
	path_bin = dir + "\\" + base_name + ".bin"
	path_packed = dir + "\\" + base_name + ".packed"

	with open(path_asm, "w") as file:
		file.write(asm)
	# asm to temp bin
	common.run_command(f"{build.assembler_path} {path_asm} {path_bin}")
	# pack a room data
	common.run_command(f"{packer_path} {path_bin} {path_packed}")
	
	size = os.path.getsize(path_packed)

	# del tmp files
	common.delete_file(path_asm)
	common.delete_file(path_bin)
	
	if delete_encoded:
		common.delete_file(path_packed)

	return size

def match_colors(image, image_ref):
	# get a collection of posXY for every color in the image
	color_positions = {}
	pixels = image.load()
	width, height = image.size
	for y in range(height):
		for x in range(width):
			# Get the color index of the pixel
			color_index = pixels[x, y]

			if color_index not in color_positions:
				color_positions[color_index] = []

			color_positions[color_index].append((x, y))

	# for each color posXY collection find the most popular color_idx in the image_ref
	pixels_ref = image_ref.load()
	image_palette = image.getpalette()
	image_ref_palette = image_ref.getpalette()

	for color_idx in color_positions:
		colors_ref_count = {}
		for x, y in color_positions[color_idx]:
			color_idx_ref = pixels_ref[x, y]
			#if color_idx_ref == color_idx:
			if color_idx_ref not in colors_ref_count:
				colors_ref_count[color_idx_ref] = 0
			colors_ref_count[color_idx_ref] += 1
		# get the most popular color_idx
		color_idx_ref_sorted = sorted(colors_ref_count.items(), key=lambda x: x[1], reverse = True)
		color_idx_popular = color_idx_ref_sorted[0][0]
		image_palette[color_idx * 3 + 0] = image_ref_palette[color_idx_popular * 3 + 0]
		image_palette[color_idx * 3 + 1] = image_ref_palette[color_idx_popular * 3 + 1]
		image_palette[color_idx * 3 + 2] = image_ref_palette[color_idx_popular * 3 + 2]

	image.putpalette(image_palette)
	return image


def compress(n_clusters, tile_size, img_vec06c_not_cropped, path_source, path_name_prefix, packer_path, save_atlas = False, encode = False, delete_encoded = True, decode = False, delete_decoded = True, random_state = 42, n_init = 'auto'):

	image_not_cropped = Image.open(path_source).convert('RGB')
	width = image_not_cropped.width // tile_size * tile_size
	height = image_not_cropped.height // tile_size * tile_size
	image = image_not_cropped.crop((0, 0, width, height))

	img_vec06c = img_vec06c_not_cropped.crop((0, 0, width, height))

	compressed_indices, codebook = vector_quantization_compression(image = image, n_clusters = n_clusters, tile_size = tile_size, random_state = random_state, n_init = n_init)

	tile_idxs, atlas, tiles_coords = codebook_to_img(compressed_indices, codebook, tile_size)

	atlas_indexed = image_to_indexed(atlas)

	# sort tiles gfx by data similarity for better compression
	tile_idxs, tiles_gfx = sort_tiles(tile_idxs, atlas_indexed, tiles_coords, tile_size)

	image_decoded = atlas_to_image(tile_idxs, tiles_gfx, atlas_indexed.getpalette(), width, height, tile_size)
	image_decoded_matched_colors = match_colors(image_decoded, img_vec06c)

	path_decoded = path_name_prefix + "_decoded" + PNG_EXT
	image_decoded_matched_colors.save(path_decoded)
	
	# match atlas colors with image_decoded_matched_colors
	if encode or save_atlas:
		atlas_index_sorted = tiles_to_image_indexed(tiles_gfx, image_decoded_matched_colors.getpalette(), tile_size)

	if save_atlas:
		path_atlas_indexed = path_name_prefix + "_atlas" + PNG_EXT
		atlas_index_sorted.save(path_atlas_indexed)
	
	# pack with upkr VQ decoded tiled image
	size_encoded_tiled = 0
	if encode:
		path_asm = path_name_prefix + "_encoded.asm"
		asm = get_asm(tile_idxs, tiles_gfx, atlas_index_sorted.getpalette(), path_asm)
		dir = os.path.dirname(path_asm)
		base_name = common.path_to_basename(path_asm)
		size_encoded_tiled = asm_to_bin_zx0(asm, dir, base_name, packer_path, delete_encoded)

	# pack with upkr decoded image
	size_decoded_upkr = 0
	if decode:
		path_decoded_upkr = path_name_prefix + "_decoded"
		size_decoded_upkr = compress_raw_image(image_decoded_matched_colors, path_decoded_upkr, packer_path, delete_decoded)

	return size_encoded_tiled, size_decoded_upkr

def palette_to_vec06(image):
	# adapted to vector06c palette
	colors = image.getpalette()
	# collect palette
	for color_idx in range(IMAGE_VECTOR_COLOR_MAX):
		colors[color_idx*3 + 0] = colors[color_idx*3 + 0] >> 5 << 5
		colors[color_idx*3 + 1] = colors[color_idx*3 + 1] >> 5 << 5
		colors[color_idx*3 + 2] = colors[color_idx*3 + 2] >> 6 << 6

	image.putpalette(colors)
	return image

def color_idxs_to_bytes(image):
	data = []
	for y in reversed(range(image.height)):
		for x in range(0, image.width, 2): 
			idx1 = image.getpixel((x, y))
			idx2 = image.getpixel((x+1, y)) 
			'''
			# two color_idxs are encoded into a byte like 			
			# (a3, b3, a2, b2, a1, b1, a0, b0) 
			# where "a" is the first color_idx, "b" is the second one
			b =	 (idx1 & 8)<<4	| (idx2 & 8)<<3
			b |= (idx1 & 4)<<3	| (idx2 & 4)<<2
			b |= (idx1 & 2)<<2	| (idx2 & 2)<<1
			b |= (idx1 & 1)<<1	| (idx2 & 1)
			'''
			b = idx1<<4 | idx2
			data.append(b)

	return data	

def compress_raw_image(image, path_name_prefix, packer_path, delete_decoded = True):
	
	colors = image.getpalette()[:16*3]
	data=[]
	# collect palette
	for color_idx in range(IMAGE_VECTOR_COLOR_MAX):
		r = colors[color_idx*3 + 0]
		g = colors[color_idx*3 + 1]
		b = colors[color_idx*3 + 2]
		data.append(pack_color(r, g, b))
	
	data.extend(color_idxs_to_bytes(image))
	
	path_bin = path_name_prefix + ".bin"
	path_packed = path_name_prefix + ".packed"

	with open(path_bin, "wb") as file:
		file.write(bytearray(data))	

	common.run_command(f"{packer_path} {path_bin} {path_packed}")

	# del tmp files
	common.delete_file(path_bin)

	size = os.path.getsize(path_packed)
	
	if delete_decoded:
		common.delete_file(path_packed)

	return size

#===========================================================================
def main():
	
	paths_source = [
		"temp\\test\\vector_quantization_image_compression\\contrast_dither_adaptive.png",
		#"temp\\test\\vector_quantization_image_compression\\image_intro.png",
		#"temp\\test\\vector_quantization_image_compression\\image_intro2.png",
		#"temp\\test\\vector_quantization_image_compression\\img01.png",
		#"temp\\test\\vector_quantization_image_compression\\img02.png",
		#"temp\\test\\vector_quantization_image_compression\\img03.png",
		#"temp\\test\\vector_quantization_image_compression\\img04.png",
		#"temp\\test\\vector_quantization_image_compression\\img05.png",
		#"temp\\test\\vector_quantization_image_compression\\img06.png",
		#"temp\\test\\vector_quantization_image_compression\\img07.png",
		#"temp\\test\\vector_quantization_image_compression\\img08.png",
		#"temp\\test\\vector_quantization_image_compression\\img09.png",
		#"temp\\test\\vector_quantization_image_compression\\img10.png",
		#"temp\\test\\vector_quantization_image_compression\\img11.png",
		#"temp\\test\\vector_quantization_image_compression\\img12.png",
		#"temp\\test\\vector_quantization_image_compression\\img13.png",
		#"temp\\test\\vector_quantization_image_compression\\img14.png",
		#"temp\\test\\vector_quantization_image_compression\\img15.png",
		#"temp\\test\\vector_quantization_image_compression\\img16.png",
		#"temp\\test\\vector_quantization_image_compression\\img17.png",		
		#"temp\\test\\vector_quantization_image_compression\\img18.png",
		#"temp\\test\\vector_quantization_image_compression\\contrast_cropped.png",
	]
	compression_setups = [
		{
			"tile_size" : 4,
			"n_clusters" : 300,
			"random_state" : 9
		},
		{
			"tile_size" : 4,
			"n_clusters" : 600,
			"random_state" : 2
		},
		{
			"tile_size" : 4,
			"n_clusters" : 750,
			"random_state" : 7
		},		
		{
			"tile_size" : 8,
			"n_clusters" : 300,
			"random_state" : 2
		},
		{
			"tile_size" : 8,
			"n_clusters" : 400,
			"random_state" : 4
		},
	]
	n_init = 'auto' # 20
	
	result = {}
	futures = []
	executor = concurrent.futures.ThreadPoolExecutor(max_workers=40)
	packer_path = build.zx0_path

	for path_source in paths_source:

		path_wo_ext = os.path.splitext(path_source)[0]
		base_name =os.path.basename(path_wo_ext)
		dir = os.path.dirname(path_source)
		path_name_prefix = dir + "\\result_" + base_name

	#=================
		# run compression tasks

		img_vec06c = palette_to_vec06(Image.open(path_source))
		path_indexed = path_name_prefix + ".png"
		img_vec06c.save(path_indexed)

		future1 = executor.submit(compress_raw_image, img_vec06c, path_name_prefix, packer_path, delete_decoded = True)

		result[base_name] = {}
		result[base_name]["size_upkr"] = future1
		result[base_name]["quantization_features"] = {}
		result[base_name]["quantization"] = {}
		futures.append(future1)

		for setup in compression_setups:
			tile_size = setup["tile_size"]
			n_clusters = setup["n_clusters"]

			random_state = 0
			if "random_state" in setup:
				random_state = setup["random_state"]
				
			width, height = img_vec06c.size
			tiles_count = (width // tile_size) * (height // tile_size)

			if tiles_count >= n_clusters:
					
				path_name_prefix2 = f"{path_name_prefix}_{tile_size}_{n_clusters}_{random_state}"
				res_key = f"{tile_size}_{n_clusters}_{random_state}"

				future1 = executor.submit(compress, n_clusters, tile_size, img_vec06c, path_source, path_name_prefix2, packer_path, False, True, True, False, True, random_state, n_init)
				result[base_name]["quantization_features"][res_key] = future1
				futures.append(future1)

	# await for execution to complete
	concurrent.futures.wait(futures)
	# retrieve results
	for base_name in result:
		future1 = result[base_name]["size_upkr"]
		size_upkr = future1.result()
		result[base_name]["size_upkr"] = size_upkr

		for res_key in result[base_name]["quantization_features"]:
			future1 = result[base_name]["quantization_features"][res_key]
			size_vq, size_decoded_upkr = future1.result()

			result[base_name]["quantization"][res_key + "_size_vq"] = size_vq

	# print stats
	print("\n\n\n")
	print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>")
	for base_name in result:
		size_upkr = result[base_name]["size_upkr"]
		
		print(base_name)
		print(f"original image to upkr: {size_upkr}")

		for setup_name in result[base_name]["quantization"]:
			size = result[base_name]["quantization"][setup_name]
			rate = size / size_upkr
		
			print(f"{setup_name}: {size}, rate: {rate:.02f}")
					
start_time = time.time()
main()
end_time = time.time()
elapsed_time = end_time - start_time
print(f"Elapsed time: {elapsed_time:.03f} seconds")
