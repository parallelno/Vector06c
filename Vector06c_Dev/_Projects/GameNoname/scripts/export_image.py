import os
from pathlib import Path
from PIL import Image
from sklearn.cluster import KMeans
import numpy as np
import json
import math
import common
import common_gfx
import build

def palette_to_vec06(image):
	img_vec06c = image.copy()
	# adapted to vector06c palette
	colors = img_vec06c.getpalette()
	# collect palette
	for color_idx in range(common_gfx.IMAGE_COLORS_MAX):
		colors[color_idx*3 + 0] = colors[color_idx*3 + 0] >> 5 << 5
		colors[color_idx*3 + 1] = colors[color_idx*3 + 1] >> 5 << 5
		colors[color_idx*3 + 2] = colors[color_idx*3 + 2] >> 6 << 6

	img_vec06c.putpalette(colors)
	return img_vec06c

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
	return image_adjusted_rgb.quantize(colors=common_gfx.IMAGE_COLORS_MAX, method=1)

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

def match_colors(image, image_ref):
	# get a collection of pos_xy for every color in the image
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

	# for each color pos_xy collection find the most popular color_idx in the image_ref
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

def color_indices_to_asm(image):
	# pack 2 color indices into one byte
	#image.save("temp\\tmp.png")
	#bytes = list(image.tobytes())
	data = []
	for y in reversed(range(image.height)):
		for x in range(0, image.width, 2): 
			idx1 = image.getpixel((x, y))
			idx2 = image.getpixel((x+1, y)) 
			# two color_idxs are encoded into a byte like 			
			# (a3, b3, a2, b2, a1, b1, a0, b0) 
			# where "a" is the first color_idx, "b" is the second one
			b =	 (idx1 & 8)<<4	| (idx2 & 8)<<3
			b |= (idx1 & 4)<<3	| (idx2 & 4)<<2
			b |= (idx1 & 2)<<2	| (idx2 & 2)<<1
			b |= (idx1 & 1)<<1	| (idx2 & 1)
			data.append(b)
	'''
	data2 = []
	for x in range(0, image.width, 8): 
		for y in reversed(range(image.height)):
			idx0 = image.getpixel((x, y))
			idx1 = image.getpixel((x+1, y))
			idx2 = image.getpixel((x+2, y))
			idx3 = image.getpixel((x+3, y))
			idx4 = image.getpixel((x+4, y))
			idx5 = image.getpixel((x+5, y))
			idx6 = image.getpixel((x+6, y))
			idx7 = image.getpixel((x+7, y))

			# color_idx into the vector06 screen buff format
			b0 = (idx0 & 8)<<4	| (idx1 & 8)<<3	| (idx2 & 8)<<2 | (idx3 & 8)<<1 | (idx4 & 8)    | (idx5 & 8)>>1 | (idx6 & 8)>>2 | (idx7 & 8)>>3
			b1 = (idx0 & 4)<<5	| (idx1 & 4)<<4	| (idx2 & 4)<<3 | (idx3 & 4)<<2 | (idx4 & 4)<<1 | (idx5 & 4)    | (idx6 & 4)>>1 | (idx7 & 4)>>2
			b2 = (idx0 & 2)<<6	| (idx1 & 2)<<5	| (idx2 & 2)<<4 | (idx3 & 2)<<3 | (idx4 & 2)<<2 | (idx5 & 2)<<1 | (idx6 & 2)    | (idx7 & 2)>>1
			b3 = (idx0 & 1)<<7	| (idx1 & 1)<<6	| (idx2 & 1)<<5 | (idx3 & 1)<<4 | (idx4 & 1)<<3 | (idx5 & 1)<<2 | (idx6 & 1)<<1 | (idx7 & 1)

			data2.append(b0)
			data2.append(b1)
			data2.append(b2)
			data2.append(b3)
	with open(f"temp\\tmp2{build.EXT_BIN}", "wb") as fw:
		fw.write(bytearray(data2))
	'''
	return common.bytes_to_asm(data)

def image_to_asm(image, label_prefix):
	asm = common_gfx.image_palette_to_asm(image.getpalette(), label_prefix)
	asm += "\n"
	asm += "			.word 0 ; safety pair of bytes for reading by POP B\n"
	asm += label_prefix + "_gfx:\n"
	asm += common.asm_compress_to_asm(color_indices_to_asm(image), delete_tmp_bin=False)
	
	return asm

#==================================================================================================================================================
#
def convert_to_asm(image, label_prefix, source_j_path, tile_size = 2, n_clusters = 512, random_state = 42, n_init = 'auto'):
	
	width = image.width // tile_size * tile_size
	height = image.height // tile_size * tile_size
	image = image.crop((0, 0, width, height))
	
	img_vec06c = palette_to_vec06(image)

	image = image.convert('RGB')

	width, height = image.size
	tiles_count = (width // tile_size) * (height // tile_size)
	if n_clusters > tiles_count:
		build.exit_error(f'export_image ERROR: n_clusters is to high for this image resolution. It has to be <= "{tiles_count}", path: {source_j_path}')

	compressed_indices, codebook = vector_quantization_compression(image = image, n_clusters = n_clusters, tile_size = tile_size, random_state = random_state, n_init = n_init)

	tile_idxs, atlas, tiles_coords = codebook_to_img(compressed_indices, codebook, tile_size)

	atlas_indexed = image_to_indexed(atlas)

	# sort tiles gfx by data similarity for better compression
	tile_idxs, tiles_gfx = sort_tiles(tile_idxs, atlas_indexed, tiles_coords, tile_size)

	image_decoded = atlas_to_image(tile_idxs, tiles_gfx, atlas_indexed.getpalette(), width, height, tile_size)
	image_decoded_matched_colors = match_colors(image_decoded, img_vec06c)
	
	return image_to_asm(image_decoded_matched_colors, label_prefix)

def export_if_updated(source_path, generated_dir, force_export):
	source_name = common.path_to_basename(source_path)

	sprite_path = generated_dir + source_name + "_gfx" + build.EXT_ASM

	export_paths = {"ram_disk" : sprite_path }

	if force_export or is_source_updated(source_path):
		export(	source_path, sprite_path)

		print(f"export_decal: {source_path} got exported.")
		return True, export_paths
	else:
		return False, export_paths



def export(source_j_path, asmSpritePath):

	source_name = common.path_to_basename(source_j_path)
	source_dir = str(Path(source_j_path).parent) + "\\"
	asm_sprite_dir = str(Path(asmSpritePath).parent) + "\\"

	with open(source_j_path, "rb") as file:
		source_j = json.load(file)

	if "asset_type" not in source_j or source_j["asset_type"] != build.ASSET_TYPE_IMAGE :
		build.exit_error(f'export_image ERROR: asset_type != "{build.ASSET_TYPE_IMAGE}", path: {source_j_path}')

	asm = "; " + source_j_path + "\n"
	asm += f"__RAM_DISK_S_{source_name.upper()} = RAM_DISK_S" + "\n"
	asm += f"__RAM_DISK_M_{source_name.upper()} = RAM_DISK_M" + "\n\n"

	for img_j in source_j["images"]:
		image_name = img_j["name"]
		path_png = source_dir + img_j["path_png"]
		extention = img_j["extention"]
		label_prefix = "__image_" + image_name

		tile_size = 2
		n_clusters = 256
		random_state =  42
		if "tile_size" in img_j:
			tile_size = img_j["tile_size"]
		if "n_clusters" in img_j:
			n_clusters = img_j["n_clusters"]
		if "random_state" in img_j:
			random_state = img_j["random_state"]

		image = Image.open(path_png)

		asm += convert_to_asm(image, label_prefix, source_j_path, tile_size, n_clusters, random_state)

	# save asm
	if not os.path.exists(asm_sprite_dir):
		os.mkdir(asm_sprite_dir)

	with open(asmSpritePath, "w") as file:
		file.write(asm)

def is_source_updated(source_j_path):

	if build.is_file_updated(source_j_path):
		return True

	with open(source_j_path, "rb") as file:
		source_j = json.load(file)

	source_dir = str(Path(source_j_path).parent) + "\\"
	for img_j in source_j["images"]:
		path_png = source_dir + img_j["path_png"]

		if build.is_file_updated(path_png):
			return True
	return False


