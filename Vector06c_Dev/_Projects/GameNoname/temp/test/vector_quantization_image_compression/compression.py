import os
from pathlib import Path
from PIL import Image
from sklearn.cluster import KMeans
import numpy as np
import math
import cv2
import difflib
import asyncio

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

def compress_image(image, codebook, tile_size=8):
	tiles = image_to_tiles(image, tile_size)
	flattened_tiles = tiles.reshape(tiles.shape[0], -1)
	compressed_indices = codebook.predict(flattened_tiles)
	return compressed_indices

def vector_quantization_compression(image, n_clusters = 256, tile_size = 8, random_state = 42, n_init = 'auto'):

	# Train the codebook
	tiles = image_to_tiles(image, tile_size)
	codebook = train_codebook(tiles, n_clusters, random_state, n_init)

	# Compress and decompress the image
	compressed_indices = compress_image(image, codebook, tile_size)

	return compressed_indices, codebook

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

def asm_to_bin_zx0(asm, dir, base_name, delete_encoded):
	asm = ".org 0 \n" + asm

	# save room data to a temp file
	path_asm = dir + "\\" + base_name + ".asm"
	path_bin = dir + "\\" + base_name + ".bin"
	path_zx0 = dir + "\\" + base_name + ".zx0"
	path_upkr = dir + "\\" + base_name + ".upkr"

	with open(path_asm, "w") as file:
		file.write(asm)
	# asm to temp bin
	common.run_command(f"{build.assembler_path} {path_asm} "
		f" {path_bin}")
	# pack a room data
	#common.run_command(f"{build.zx0_path} {path_bin} {path_zx0}")
	common.run_command(f"{build.upkr_path} {path_bin} {path_upkr}")
	
	size = os.path.getsize(path_upkr)

	# del tmp files
	common.delete_file(path_asm)
	common.delete_file(path_bin)
	#delete_file(path_zx0)
	
	if delete_encoded:
		common.delete_file(path_upkr)

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


async def compress(n_clusters, tile_size, img_vec06c_not_cropped, path_source, path_name_prefix, save_atlas = False, decode = False, delete_encoded = True, delete_decoded = True, random_state = 42, n_init = 'auto'):

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
	if decode or save_atlas:
		atlas_index_sorted = tiles_to_image_indexed(tiles_gfx, image_decoded_matched_colors.getpalette(), tile_size)

	if save_atlas:
		path_atlas_indexed = path_name_prefix + "_atlas" + PNG_EXT
		atlas_index_sorted.save(path_atlas_indexed)
	
	# pack with upkr VQ decoded tiled image
	size_encoded_tiled = 0
	if decode:
		path_asm = path_name_prefix + "_encoded.asm"
		asm = get_asm(tile_idxs, tiles_gfx, atlas_index_sorted.getpalette(), path_asm)
		dir = os.path.dirname(path_asm)
		base_name = common.path_to_basename(path_asm)
		size_encoded_tiled = asm_to_bin_zx0(asm, dir, base_name, delete_encoded)

	# pack with upkr decoded image
	path_decoded_upkr = path_name_prefix + "_decoded"
	size_decoded_upkr = compress_raw_image(image_decoded_matched_colors, path_decoded_upkr, delete_decoded)

	# color_idx into bytes, then pack with upkr
	#path_decoded_buff_upkr = path_name_prefix + "_decoded_buff"
	#size_decoded_buff_upkr = image_to_buff_compress(image_decoded_matched_colors, path_decoded_buff_upkr, delete_decoded)

	return size_encoded_tiled, size_decoded_upkr #, size_decoded_buff_upkr

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

def compress_raw_image(image, path_name_prefix, delete_decoded = True):
	
	colors = image.getpalette()[:16*3]
	data=[]
	# collect palette
	for color_idx in range(IMAGE_VECTOR_COLOR_MAX):
		r = colors[color_idx*3 + 0]
		g = colors[color_idx*3 + 1]
		b = colors[color_idx*3 + 2]
		data.append(pack_color(r, g, b))
	
	# pack and collect color_idx
	for x in range(image.width):
		for y in range(image.height//2):
			idx1 = image.getpixel((x, y))
			idx2 = image.getpixel((x, y+1))
			b = idx1<<4 | idx2
			data.append(b)
	
	path_bin = path_name_prefix + ".bin"
	#path_zx0 = path_name_prefix + "_img.zx0"
	path_upkr = path_name_prefix + ".upkr"

	with open(path_bin, "wb") as file:
		file.write(bytearray(data))	

	#common.run_command(f"{build.zx0_path} {path_bin} {path_zx0}")
	common.run_command(f"{build.upkr_path} {path_bin} {path_upkr}")

	# del tmp files
	common.delete_file(path_bin)

	size = os.path.getsize(path_upkr)
	
	if delete_decoded:
		common.delete_file(path_upkr)

	return size

#===========================================================================
async def main():
	paths_source = [
		"temp\\test\\vector_quantization_image_compression\\contrast_dither_adaptive.png",
		"temp\\test\\vector_quantization_image_compression\\image_intro.png",
		"temp\\test\\vector_quantization_image_compression\\image_intro2.png",
		"temp\\test\\vector_quantization_image_compression\\img01.png",
		"temp\\test\\vector_quantization_image_compression\\img02.png",
		"temp\\test\\vector_quantization_image_compression\\img03.png",
		"temp\\test\\vector_quantization_image_compression\\img04.png",
		"temp\\test\\vector_quantization_image_compression\\img05.png",
		"temp\\test\\vector_quantization_image_compression\\img06.png",
		"temp\\test\\vector_quantization_image_compression\\img07.png",
		"temp\\test\\vector_quantization_image_compression\\img08.png",
		"temp\\test\\vector_quantization_image_compression\\img09.png",
		"temp\\test\\vector_quantization_image_compression\\img10.png",
		"temp\\test\\vector_quantization_image_compression\\img11.png",
		"temp\\test\\vector_quantization_image_compression\\img12.png",
		"temp\\test\\vector_quantization_image_compression\\img13.png",
		"temp\\test\\vector_quantization_image_compression\\img14.png",
		"temp\\test\\vector_quantization_image_compression\\img15.png",
		"temp\\test\\vector_quantization_image_compression\\img16.png",
		"temp\\test\\vector_quantization_image_compression\\img17.png",		
		"temp\\test\\vector_quantization_image_compression\\img18.png",
	]

	tile_sizes = [2]
	n_clusters_list = [64, 96, 128, 256, 1024]
	random_state = 1
	n_init = 'auto'
	
	sizes_upkr = {}
	sizes_vq = {}
	sizes_decoded_upkr = {}
	#sizes_decoded_buff_upkr = {}
	tasks = {}

	source_count = len(paths_source)

	for path_source in paths_source:
		
		print("\n\n\n")
		print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>")
		print(f"compressing image: {path_source}")
		print("\n")

		path_wo_ext = os.path.splitext(path_source)[0]
		base_name =os.path.basename(path_wo_ext)
		dir = os.path.dirname(path_source)
		path_name_prefix = dir + "\\result_" + base_name

	#=================
		# run compression tasks

		img_vec06c = palette_to_vec06(Image.open(path_source))
		path_indexed = path_name_prefix + ".png"
		img_vec06c.save(path_indexed)

		size_upkr = compress_raw_image(img_vec06c, path_name_prefix, delete_decoded = True)
		sizes_upkr[base_name] = size_upkr
		tasks[base_name] = {}

		for tile_size in tile_sizes:
			tasks[base_name][tile_size] = {}

			for n_clusters in n_clusters_list:
				
				width, height = img_vec06c.size
				tiles_count = (width // tile_size) * (height // tile_size)

				if tiles_count >= n_clusters:
					
					path_name_prefix2 = f"{path_name_prefix}_{tile_size}_{n_clusters}_"

					tasks[base_name][tile_size][n_clusters] = asyncio.create_task(compress(n_clusters, tile_size, img_vec06c, path_source, path_name_prefix2, False, False, True, True, random_state, n_init))

	# retrieve the result of compression
	for base_name in sizes_upkr:
		size_upkr = sizes_upkr[base_name]

		for tile_size in tile_sizes:

			for n_clusters in n_clusters_list:
				task = tasks[base_name][tile_size][n_clusters]
				#size_vq, size_decoded_upkr, size_decoded_buff_upkr = await task
				size_vq, size_decoded_upkr = await task

				# store stats only if its better than raw image packed by UPKR
				if size_vq <= size_upkr:
					if base_name not in sizes_vq:
						sizes_vq[base_name] = {}
					if tile_size not in sizes_vq[base_name]:
						sizes_vq[base_name][tile_size] = {}
					if n_clusters not in sizes_vq[base_name][tile_size]:
						sizes_vq[base_name][tile_size][n_clusters] = {}
					sizes_vq[base_name][tile_size][n_clusters] = size_vq

				if size_decoded_upkr <= size_upkr:
					if base_name not in sizes_decoded_upkr:
						sizes_decoded_upkr[base_name] = {}
					if tile_size not in sizes_decoded_upkr[base_name]:
						sizes_decoded_upkr[base_name][tile_size] = {}
					if n_clusters not in sizes_decoded_upkr[base_name][tile_size]:
						sizes_decoded_upkr[base_name][tile_size][n_clusters] = {}
					sizes_decoded_upkr[base_name][tile_size][n_clusters] = size_decoded_upkr
				'''
				if base_name not in sizes_decoded_buff_upkr:
					sizes_decoded_buff_upkr[base_name] = {}
				if tile_size not in sizes_decoded_buff_upkr[base_name]:
					sizes_decoded_buff_upkr[base_name][tile_size] = {}
				if n_clusters not in sizes_decoded_buff_upkr[base_name][tile_size]:
					sizes_decoded_buff_upkr[base_name][tile_size][n_clusters] = {}
				sizes_decoded_buff_upkr[base_name][tile_size][n_clusters] = size_decoded_buff_upkr
				'''

	# print stats
	print("\n\n\n")
	print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>")
	for base_name in sizes_upkr:
		print(f"{base_name}")
		size_upkr = sizes_upkr[base_name]
		print(f"original image to upkr: {size_upkr}")
		
		print(f"vector quantization to upkr:")
		for tile_size in tile_sizes:
			for n_clusters in n_clusters_list:
				
				'''
				size_vq = -1
				if tile_size in sizes_vq[base_name] and n_clusters in sizes_vq[base_name][tile_size]:
					size_vq = sizes_vq[base_name][tile_size][n_clusters]
				if size_vq > 0:
					size_vq_rate = size_vq / size_upkr
					print(f"tiled   VQ to upkr: {size_vq}, rate: {size_vq_rate:.02f}, tile_size: {tile_size}, n_clusters: {n_clusters}")
				'''					
				size_decoded_upkr = -1				
				if tile_size in sizes_decoded_upkr[base_name] and n_clusters in sizes_decoded_upkr[base_name][tile_size]:
					size_decoded_upkr = sizes_decoded_upkr[base_name][tile_size][n_clusters]
				if size_decoded_upkr > 0:
					size_decoded_upkr_rate = size_decoded_upkr / size_upkr
					print(f"decoded VQ color_idx to upkr: {size_decoded_upkr}, rate: {size_decoded_upkr_rate:.02f}, tile_size: {tile_size}, n_clusters: {n_clusters}")
				'''
				size_decoded_buff_upkr = -1
				if tile_size in sizes_decoded_buff_upkr[base_name] and n_clusters in sizes_decoded_buff_upkr[base_name][tile_size]:
					size_decoded_buff_upkr = sizes_decoded_buff_upkr[base_name][tile_size][n_clusters]
				if size_decoded_buff_upkr > 0:
					size_decoded_upkr_rate = size_decoded_buff_upkr / size_upkr
					print(f"decoded VQ color bytes to upkr: {size_decoded_buff_upkr}, rate: {size_decoded_upkr_rate:.02f}, tile_size: {tile_size}, n_clusters: {n_clusters}")					
				'''
asyncio.run(main())
