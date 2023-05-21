import os
from PIL import Image
from pathlib import Path
import json
import common
import common_gfx
import build
import numpy as np

IMG_TILE_W = 8
IMG_TILE_H = 8

SCR_TILES_W = 32
SCR_TILES_H = 32

def get_tiledata(bytes0, bytes1, bytes2, bytes3):
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

def gfx_to_asm(image, path, remap_idxs, label_prefix):
	asm = "; " + path + "\n"
	asm += label_prefix + "_tiles:\n"
	
	# extract tile images and convert them into asm
	for t_idx in remap_idxs:
		# get a tile as a color index array
		tile_img = []
		idx = t_idx - 1 # because in Tiled exported data the first tile index is 1 instead of 0.
		sx = idx % SCR_TILES_W * IMG_TILE_W
		sy = idx // SCR_TILES_W * IMG_TILE_H
		for y in reversed(range(sy, sy + IMG_TILE_H)):
			line = []
			for x in range(sx, sx + IMG_TILE_W):
				color_idx = image.getpixel((x, y))
				line.append(color_idx)
				#x += 1
			tile_img.append(line)
		
		# convert indexes into bit lists.
		bits0, bits1, bits2, bits3 = common_gfx.indexes_to_bit_lists(tile_img)

		# combite bits into byte lists
		bytes0 = common.combine_bits_to_bytes(bits0) # 8000-9FFF # from left to right, from bottom to top
		bytes1 = common.combine_bits_to_bytes(bits1) # A000-BFFF
		bytes2 = common.combine_bits_to_bytes(bits2) # C000-DFFF
		bytes3 = common.combine_bits_to_bytes(bits3) # E000-FFFF

		# to support a tile render function
		data, mask = get_tiledata(bytes0, bytes1, bytes2, bytes3)


		asm += "			.word 0 ; safety pair of bytes for reading by POP B\n"
		asm += label_prefix + "_tile" + str(remap_idxs[t_idx]) + ":\n"
		asm += "			.byte " + str(mask) + " ; mask\n"
		asm += "			.byte 4 ; counter\n"
		asm += common.bytes_to_asm(data, IMG_TILE_H)

	return asm

def remap_indices(tiled_files_j, image_names):
	unique_idxs = {}
	new_idx = 1
	for path in tiled_files_j: 
		tiled_file_j = tiled_files_j[path]
		for layer in tiled_file_j["layers"]:
			name = layer["name"]
			if layer["type"] == "tilelayer" and name in image_names:
				data = layer["data"]
				for idx in data:
					if idx != 0 and idx not in unique_idxs:
						unique_idxs[idx] = new_idx
						new_idx += 1
	return unique_idxs

def get_img_ptrs(images_j, label_prefix):
	asm = "\n			.word 0 ; safety pair of bytes for reading by POP B\n"
	asm += label_prefix + "_tiled_imgs_addr:\n			.word "

	for i, image_j in enumerate(images_j):
		layer_name = image_j['layer_name']
		path = image_j['path']
		label_name = "__" + common.path_to_basename(path) + "_" + layer_name
		asm += label_name + ", "

		if i != len(images_j)-1:
			# two safety fytes
			asm += "0, "
	asm += "\n"
	return asm

def tile_idxs_to_asm(idxs, pos_x, pos_y, tiles_w, tiles_h, label_name):
	asm = "\n			.word 0 ; safety pair of bytes for reading by POP B\n"
	asm += label_name + ":\n			.byte "
	asm += f"{pos_y}, {pos_x} ; pos_y, pos_x\n"
	asm += common.bytes_to_asm(idxs, tiles_w)

	return asm

#=====================================================
def export_data_if_updated(source_path, generated_dir, force_export):
	source_name = common.path_to_basename(source_path)

	export_paths = {"ram_disk" : generated_dir + source_name + "_data" + build.EXT_ASM }

	if force_export or is_source_updated(source_path):
		export_data( source_path, export_paths["ram_disk"])
			
		print(f"export_level: {source_path} got exported.")		
		return True, export_paths
	else:
		return False, export_paths
	
def export_gfx_if_updated(source_path, generated_dir, force_export):
	source_name = common.path_to_basename(source_path)

	export_paths = {"ram_disk" : generated_dir + source_name + "_gfx" + build.EXT_ASM }

	if force_export or is_source_updated(source_path):
		export_gfx( source_path, export_paths["ram_disk"])
			
		print(f"export_level: {source_path} got exported.")		
		return True, export_paths
	else:
		return False, export_paths

def export_gfx(source_j_path, export_gfx_path):
	with open(source_j_path, "rb") as file:
		source_j = json.load(file)

	source_dir = str(Path(source_j_path).parent) + "\\"

	if "asset_type" not in source_j or source_j["asset_type"] != build.ASSET_TYPE_TILED_IMG:
		print(f'export_tiled_img ERROR: asset_type != "{build.ASSET_TYPE_TILED_IMG}", path: {source_j_path}')
		print("Stop export")
		exit(1)

	path_png = source_dir + source_j["path_png"]
	image = Image.open(path_png)

	source_name = common.path_to_basename(source_j_path)
	
	asm = ""
	asm = f"__RAM_DISK_S_{source_name.upper()}_GFX = RAM_DISK_S\n"
	asm += f"__RAM_DISK_M_{source_name.upper()}_GFX = RAM_DISK_M\n"
	
	palette_asm, colors = common_gfx.palette_to_asm(image, source_j, path_png, "__" + source_name)
	asm += palette_asm

	image = common_gfx.remap_colors(image, colors)
	
	images = source_j["images"]
	tiled_files_j = {}
	image_names = []
	# load and parse tiled map
	for image_j in images:
		image_names.append(image_j['layer_name'])
		tiled_file_path = source_dir + image_j['path']
		
		if tiled_file_path not in tiled_files_j:
			with open(tiled_file_path, "rb") as file:
				tiled_files_j[tiled_file_path] = json.load(file)

	# make a tile index remap dictionary, to have the first idx = 0
	remap_idxs = remap_indices(tiled_files_j, image_names)

	# list of tiles addreses
	png_name = common.path_to_basename(path_png)

	asm += common_gfx.get_list_of_tiles(remap_idxs, "__" + source_name, png_name)
	
	# tile gfx data to asm
	asm += gfx_to_asm(image, path_png, remap_idxs, "__" + png_name)

	# save asm
	export_dir = str(Path(export_gfx_path).parent) + "\\"		
	if not os.path.exists(export_dir):
		os.mkdir(export_dir)	
	with open(export_gfx_path, "w") as file:
		file.write(asm)	

def export_data(source_j_path, export_data_path):

	with open(source_j_path, "rb") as file:
		source_j = json.load(file)

	source_dir = str(Path(source_j_path).parent) + "\\"

	# check if a folder exists
	export_dir = str(Path(export_data_path).parent) + "\\"
	if not os.path.exists(export_dir):
		os.mkdir(export_dir)

	if "asset_type" not in source_j or source_j["asset_type"] != build.ASSET_TYPE_TILED_IMG:
		print(f'export_tiled_img ERROR: asset_type != "{build.ASSET_TYPE_TILED_IMG}", path: {source_j_path}')
		print("Stop export")
		exit(1)

	source_name = common.path_to_basename(source_j_path)
	asm = ""

	asm = f"__RAM_DISK_S_{source_name.upper()}_DATA = RAM_DISK_S\n"
	asm += f"__RAM_DISK_M_{source_name.upper()}_DATA = RAM_DISK_M\n"
	asm += "\n"

	images_j = source_j["images"]
	tiled_files_j = {}
	image_names = []
	# load and parse tiled map
	for image_j in images_j:
		image_names.append(image_j['layer_name'])
		tiled_file_path = source_dir + image_j['path']

		if tiled_file_path not in tiled_files_j:
			with open(tiled_file_path, "rb") as file:
				tiled_files_j[tiled_file_path] = json.load(file)

	# make a tile index remap dictionary, to have the first idx = 0
	remap_idxs = remap_indices(tiled_files_j, image_names)
	
	# get a list of pointers to images represented by the tile_gfx_idxs
	asm += get_img_ptrs(images_j, "__" + source_name)

	for i, full_path in enumerate(tiled_files_j):
		tiled_file_j = tiled_files_j[full_path]
		base_name = common.path_to_basename(full_path)
		for layer in tiled_file_j["layers"]:  
			layer_name = layer["name"]
			if layer["type"] == "tilelayer" and layer_name in image_names:
								
				data = layer["data"]

				# determine pos_x, pos_y, tiles_w, tiles_h
				tile_first_x = SCR_TILES_W # max
				tile_first_y = SCR_TILES_H # max

				tile_last_x = -1 # min
				tile_last_y = -1 # min

				for t_y in range(SCR_TILES_H):
					
					non_empty_tile_line = False
					
					for t_x in range(SCR_TILES_W):
						
						t_idx = data[t_y * SCR_TILES_W + t_x]
						
						if t_idx != 0:
							non_empty_tile_line = True

							if t_x < tile_first_x:
								tile_first_x = t_x

							if t_x > tile_last_x:
								tile_last_x = t_x

					if non_empty_tile_line:
						if t_y < tile_first_y:
							tile_first_y = t_y
						if t_y > tile_last_y:
							tile_last_y = t_y
				
				# image idxs to asm
				idxs = []
				for t_y in reversed(range(tile_first_y, tile_last_y)):
					for t_x in range(tile_first_x, tile_last_x):
						t_idx = data[t_y * SCR_TILES_W + t_x]
						if t_idx > 0:
							idxs.append(remap_idxs[t_idx]) 
						else:
							idxs.append(0)

				label_name = "__" + base_name + "_" + layer_name
				pos_x = SCR_TILES_W - tile_last_x - 1
				pos_y = (SCR_TILES_H - tile_last_y - 1) * IMG_TILE_W
				tiles_w = tile_last_x - tile_first_x
				tiles_h = tile_last_y - tile_first_y

				asm += tile_idxs_to_asm(idxs, pos_x, pos_y, tiles_w, tiles_h, label_name)
	
	with open(export_data_path, "w") as file:
		file.write(asm)

def is_source_updated(source_j_path):
	with open(source_j_path, "rb") as file:
		source_j = json.load(file)
	
	source_dir = str(Path(source_j_path).parent) + "\\"
	path_png = source_dir + source_j["path_png"]

	images_j = source_j["images"]
	images_updated = False
	for image_j in images_j:
		tiled_file_path = source_dir + image_j['path']
		images_updated |= build.is_file_updated(tiled_file_path)

	if build.is_file_updated(source_j_path) | build.is_file_updated(path_png) | images_updated:
		return True
	return False





