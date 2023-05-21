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
from export_level import *

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

def vector_quantization_compression(image, n_clusters = 256, tile_size = 8, random_state = 42, n_init = 'auto', add_flipped = False):

	# Train the codebook
	tiles = image_to_tiles(image, tile_size)
	
	if add_flipped:
#================================================
		codebook = train_codebook(tiles, n_clusters, random_state, n_init)
#================================================
	else:
		codebook = train_codebook(tiles, n_clusters, random_state, n_init)
		flattened_tiles_gfx = codebook.cluster_centers_.reshape(-1, tile_size * tile_size * 3).astype(np.uint8)	

	# compress and decompress the image
	tile_idxs = compress_image(tiles, codebook)

	if add_flipped:
		# test to add mirrored tiles	
		# count how many mirrored tiles were used
		tile_idxs, flattened_tiles_gfx = closest_tiles(tile_idxs, tiles, codebook, tile_size)

	return tile_idxs, flattened_tiles_gfx

def count_used_mirrored_tiles(compressed_indices, codebook, tile_size):
	# get max idx of a tile used for compression
	max_tile_idx = np.max(compressed_indices)
	unique_tiles_idxs = np.arange(max_tile_idx)

	decompressed_tiles = codebook.cluster_centers_[unique_tiles_idxs].reshape(-1, tile_size, tile_size, 3).astype(np.uint8)
	mirrored_v = np.flip(decompressed_tiles, axis=1)
	mirrored_h = np.flip(decompressed_tiles, axis=2)
	mirrored_vh = np.flip(mirrored_v, axis=2)

	match_v = np.sum(np.all(decompressed_tiles == mirrored_v, axis=(1, 2, 3)))
	match_h = np.sum(np.all(decompressed_tiles == mirrored_h, axis=(1, 2, 3)))
	match_vh = np.sum(np.all(decompressed_tiles == mirrored_vh, axis=(1, 2, 3)))

	all_matches = match_v + match_h + match_vh
	return all_matches

def closest_tiles(tile_idxs, tiles, codebook, tile_size):

	non_flipped = 0
	flipped_v = {}
	flipped_h = {}
	flipped_vh = {}

	cluster_centers = codebook.cluster_centers_.reshape(-1, tile_size * tile_size * 3).astype(np.int64)
	cluster_centers_flip_v = np.flip(codebook.cluster_centers_.reshape(-1, tile_size, tile_size, 3).astype(np.int64), axis=0).reshape(cluster_centers.shape[0], -1)
	cluster_centers_flip_h = np.flip(codebook.cluster_centers_.reshape(-1, tile_size, tile_size, 3).astype(np.int64), axis=1).reshape(cluster_centers.shape[0], -1)
	cluster_centers_flip_vh = np.flip(codebook.cluster_centers_.reshape(-1, tile_size, tile_size, 3).astype(np.int64), (0, 1)).reshape(cluster_centers.shape[0], -1)

	flattened_tiles = tiles.reshape(tiles.shape[0], -1).astype(np.int64)

	tiles_gfx = cluster_centers.copy()

	for i in range(flattened_tiles.shape[0]):
		flattened_tile = flattened_tiles[i]
		cluster_idx = tile_idxs[i]
		cluster_center = cluster_centers[cluster_idx]

		dist_to_cluster = get_tiles_distance(flattened_tile, [cluster_center])[0]

		dist_to_clusters_flip_v = get_tiles_distance(flattened_tile, cluster_centers_flip_v)
		dist_to_clusters_flip_v_idx = np.argmin(dist_to_clusters_flip_v)
		dist_to_cluster_flip_v = dist_to_clusters_flip_v[dist_to_clusters_flip_v_idx]

		dist_to_clusters_flip_h = get_tiles_distance(flattened_tile, cluster_centers_flip_h)
		dist_to_clusters_flip_h_idx = np.argmin(dist_to_clusters_flip_h)
		dist_to_cluster_flip_h = dist_to_clusters_flip_h[dist_to_clusters_flip_h_idx]

		dist_to_clusters_flip_vh = get_tiles_distance(flattened_tile, cluster_centers_flip_vh)
		dist_to_clusters_flip_vh_idx = np.argmin(dist_to_clusters_flip_vh)
		dist_to_cluster_flip_vh = dist_to_clusters_flip_vh[dist_to_clusters_flip_vh_idx]

		dists = np.array([dist_to_cluster, dist_to_cluster_flip_v, dist_to_cluster_flip_h, dist_to_cluster_flip_vh])
		dist_min_idx = np.argmin(dists)

		if dist_min_idx == 0:
			non_flipped += 1
		elif dist_min_idx == 1:
			if dist_to_clusters_flip_v_idx not in flipped_v:
				flipped_v[dist_to_clusters_flip_v_idx] = []
			flipped_v[dist_to_clusters_flip_v_idx].append(i)

		elif dist_min_idx == 2:
			if dist_to_clusters_flip_h_idx not in flipped_h:
				flipped_h[dist_to_clusters_flip_h_idx] = []
			flipped_h[dist_to_clusters_flip_h_idx].append(i)

		else:
			if dist_to_clusters_flip_vh_idx not in flipped_vh:
				flipped_vh[dist_to_clusters_flip_vh_idx] = []
			flipped_vh[dist_to_clusters_flip_vh_idx].append(i)

	
	# update tile_idxs, tiles_gfx to incorparate flipped tiles_gfx
	new_flipped_tile_idx = np.max(tile_idxs) + 1

	for tile_gfx_idx in flipped_v:
		# updating tile_idxs to use flipped tiles_gfx
		flipped_tile_idxs = flipped_v[tile_gfx_idx]
		for tile_idx in flipped_tile_idxs:
			tile_idxs[tile_idx] = new_flipped_tile_idx
		new_flipped_tile_idx += 1
		# adding a new flipped tile gfx into tiles_gfx
		flattened_tile_gfx = cluster_centers_flip_v[tile_gfx_idx].reshape(1, tile_size * tile_size * 3)
		tiles_gfx = np.append(tiles_gfx, flattened_tile_gfx, axis=0)

	for tile_gfx_idx in flipped_h:
		# updating tile_idxs to use flipped tiles_gfx
		flipped_tile_idxs = flipped_h[tile_gfx_idx]
		for tile_idx in flipped_tile_idxs:
			tile_idxs[tile_idx] = new_flipped_tile_idx
		new_flipped_tile_idx += 1
		# adding a new flipped tile gfx into tiles_gfx
		flattened_tile_gfx = cluster_centers_flip_h[tile_gfx_idx].reshape(1, tile_size * tile_size * 3)
		tiles_gfx = np.append(tiles_gfx, flattened_tile_gfx, axis=0)

	for tile_gfx_idx in flipped_vh:
		# updating tile_idxs to use flipped tiles_gfx
		flipped_tile_idxs = flipped_vh[tile_gfx_idx]
		for tile_idx in flipped_tile_idxs:
			tile_idxs[tile_idx] = new_flipped_tile_idx
		new_flipped_tile_idx += 1
		# adding a new flipped tile gfx into tiles_gfx
		flattened_tile_gfx = cluster_centers_flip_vh[tile_gfx_idx].reshape(1, tile_size * tile_size * 3)
		tiles_gfx = np.append(tiles_gfx, flattened_tile_gfx, axis=0)

		
	return tile_idxs, tiles_gfx

def get_tiles_distance(flatten_tile, flattened_tiles):
	# Assuming flattened_tiles is your array of flattened image tiles

	# Subtract the i-th cluster center from each tile
	differences = flattened_tiles - flatten_tile

	# Square the differences
	squared_differences = np.square(differences)

	# Sum the squared differences along the last axis to get the squared Euclidean distance
	squared_distances = np.sum(squared_differences, axis=1)

	# Take the square root to get the Euclidean distance
	distances_to_i = np.sqrt(squared_distances)

	return distances_to_i

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

def make_atlas(tile_idxs, flattened_tiles_gfx, tile_size):

	tiles_gfx = flattened_tiles_gfx.reshape(-1, tile_size, tile_size, 3).astype(np.uint8)

	# atlas size
	tiles_len = len(tiles_gfx)
	atlas_tiles_x = int(math.sqrt(tiles_len))
	atlas_tiles_y = tiles_len // atlas_tiles_x
	if (tiles_len % atlas_tiles_x) > 0:
		atlas_tiles_y += 1

	atlas, tiles_coords = tiles_to_image(tiles_gfx, atlas_tiles_x, atlas_tiles_y, tile_size)

	return atlas, tiles_coords

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

def get_tiledata(bytes0, bytes1, bytes2, bytes3, tile_size = 8):
	all_bytes = [bytes0, bytes1, bytes2, bytes3]
	# data structure description is in drawTile.asm
	mask = 0
	data = []
	for bytes in all_bytes:
		mask >>=  1
		if common.is_bytes_zeros(bytes) : 
			continue
		mask += 8

		data.extend(bytes)

	return data, mask

def tile_gfx_8_to_buffs_to_asm(tiles_gfx):
	# works only for 8x8 pixel tiles
	# convert 64 color indices into 32 bytes. Each 8 bytes for a corresponding screen buffer
	# add a special code that which each bit describes if there is data for a scr buff
	# then list 8 bytes for a corresponding screen buffer if there is any,
	# if there is no data for a buff, skip it
	
	asm = ""	
	for tile_gfx_idx in tiles_gfx:
		tile_gfx = tiles_gfx[tile_gfx_idx]
		# convert indexes into bit lists.
		bits0, bits1, bits2, bits3 = common_gfx.plane_indexes_to_bit_lists(tile_gfx)

		# combite bits into byte lists
		bytes0 = common.combine_bits_to_bytes(bits0) # 8000-9FFF # from left to right, from bottom to top
		bytes1 = common.combine_bits_to_bytes(bits1) # A000-BFFF
		bytes2 = common.combine_bits_to_bytes(bits2) # C000-DFFF
		bytes3 = common.combine_bits_to_bytes(bits3) # E000-FFFF

		# to support a tile render function
		data, mask = get_tiledata(bytes0, bytes1, bytes2, bytes3)

		asm += "			.word 0 ; safety pair of bytes for reading by POP B\n"
		#asm += label_prefix + "_tile" + str(remap_idxs[t_idx]) + ":\n"
		asm += "			.byte " + str(mask) + " ; mask\n"
		asm += "			.byte 4 ; counter\n"
		asm += common.bytes_to_asm(data)
	
	return asm

def get_asm(tile_idxs_sorted, tiles_gfx, palette, path, tile_size, color_idx_to_scr_buffs):
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
	asm += "gfx_postfix:\n"
	if color_idx_to_scr_buffs and tile_size == 8:
		asm += tile_gfx_8_to_buffs_to_asm(tiles_gfx)
	else:
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


def compress(n_clusters, tile_size, img_vec06c_not_cropped, path_source, path_name_prefix, packer_path, save_atlas = False, encode = False, delete_encoded = True, decode = False, delete_decoded = True, random_state = 42, n_init = 'auto', add_flipped = False, color_idx_to_scr_buffs = False):

	image_not_cropped = Image.open(path_source).convert('RGB')
	width = image_not_cropped.width // tile_size * tile_size
	height = image_not_cropped.height // tile_size * tile_size
	image = image_not_cropped.crop((0, 0, width, height))

	img_vec06c = img_vec06c_not_cropped.crop((0, 0, width, height))

	tile_idxs, flattened_tiles_gfx = vector_quantization_compression(image = image, n_clusters = n_clusters, tile_size = tile_size, random_state = random_state, n_init = n_init, add_flipped = add_flipped)

	atlas, tiles_coords = make_atlas(tile_idxs, flattened_tiles_gfx, tile_size)

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
	
	# pack VQ decoded tiled image
	size_encoded_tiled = 0
	if encode:
		path_asm = path_name_prefix + "_encoded.asm"
		asm = get_asm(tile_idxs, tiles_gfx, atlas_index_sorted.getpalette(), path_asm, tile_size, color_idx_to_scr_buffs)
		dir = os.path.dirname(path_asm)
		base_name = common.path_to_basename(path_asm)
		size_encoded_tiled = asm_to_bin_zx0(asm, dir, base_name, packer_path, delete_encoded)

	# pack decoded image
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
		"temp\\test\\vector_quantization_image_compression\\contrast_cropped.png",
	]
	compression_setups = [
		{
			"tile_size" : 4,
			"n_clusters" : 700,
			"random_state" : 12,
		},
		{
			"tile_size" : 8,
			"n_clusters" : 400,
			"random_state" : 12,
		}
	]
	n_init = 20 #"auto" # 20
	add_flipped = False
	color_idx_to_scr_buffs = False
	packer_path = build.zx0_path # build.upkr_path
		
	result = {}
	futures = []
	executor = concurrent.futures.ThreadPoolExecutor(max_workers=40)


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

			postfix = "_flipped" if add_flipped else ""
				
			width, height = img_vec06c.size
			tiles_count = (width // tile_size) * (height // tile_size)

			if tiles_count >= n_clusters:
					
				path_name_prefix2 = f"{path_name_prefix}_{tile_size}_{n_clusters}_{random_state}_{postfix}"
				res_key = f"{tile_size}_{n_clusters}_{random_state}_{postfix}"

				future1 = executor.submit(compress, n_clusters, tile_size, img_vec06c, path_source, path_name_prefix2, packer_path, False, True, True, False, True, random_state, n_init, add_flipped, color_idx_to_scr_buffs)
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
