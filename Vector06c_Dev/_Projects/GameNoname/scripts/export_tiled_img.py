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

TILED_IMG_GFX_IDX_MAX = 255
TILED_IMG_IDXS_LEN_MAX = 256

META_DATA_LEN = 4

REPEATER_CODE = 255

def get_tiledata(bytes0, bytes1, bytes2, bytes3, use_mask):
	if not use_mask:
		# reverse every second list of bytes to support tiled_img format
		bytes1 = bytes1[::-1]
		bytes3 = bytes3[::-1]
	
	all_bytes = [bytes0, bytes1, bytes2, bytes3]
	# data structure description is in draw_tiled_img.asm
	mask = 0
	data = []
	for bytes in all_bytes:
		if use_mask:
			mask >>=  1
			if common.is_bytes_zeros(bytes) : 
				continue
			mask += 8

		data.extend(bytes)

	return data, mask

def gfx_to_asm(image, remap_idxs, label_prefix):
	#asm = "; " + path + "\n"
	#asm += label_prefix + "_tiles:\n"
	asm = "\n"
	
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
		# do not use the mask because this gives a big overhead for such small tiles.
		data, mask = get_tiledata(bytes0, bytes1, bytes2, bytes3, False)


		asm += "			.word 0 ; safety pair of bytes for reading by POP B\n"
		asm += label_prefix + "_tile" + str(remap_idxs[t_idx]) + ":\n"
		# remove it because this gives a big overhead for such small tiles.
		# asm += "			.byte " + str(mask) + " ; mask\n"
		# asm += "			.byte 4 ; counter\n"
		asm += common.bytes_to_asm(data, IMG_TILE_H, True)

	return asm

def remap_indices(tiled_file_j):
	unique_idxs = {}
	new_idx = 1
	for layer in tiled_file_j["layers"]:
		if layer["type"] != "tilelayer":
			continue

		for idx in layer["data"]:
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

def pack_idxs(idxs_unpacked, tiles_w, tiles_h):
	idxs = []
	for j in range(tiles_h):
		# convert the line into the pairs (idx, how many times it repeats)
		repeaters = []
		repeaters_lens = []
		prev_idx = -1
		for i in range(tiles_w):
			idx = idxs_unpacked[j * tiles_w + i]
			if idx != prev_idx:
				repeaters.append(idx)
				repeaters_lens.append(1)
				prev_idx = idx
			else:
				repeaters_lens[-1] += 1

		idxs_line = []
		# decode pairs with len > 3 into (REPEATER_CODE, IDX, LEN)
		for i, idx in enumerate(repeaters):
			repeater_len = repeaters_lens[i]
			if repeater_len <= 3:
				for j in range(repeater_len):
					idxs_line.append(idx)
			else:
				idxs_line.append(REPEATER_CODE)
				idxs_line.append(idx)
				idxs_line.append(repeater_len)
		idxs.extend(idxs_line)
	return idxs

def tile_idxs_to_asm(idxs_unpacked, pos_x, pos_y, tiles_w, tiles_h, label_name):
	idxs = pack_idxs(idxs_unpacked, tiles_w, tiles_h)

	asm = "" 
	# idxs_data_copy_len represents how many pairs of bytes have to be copied by copy_from_ram_disk asm func, 
	# it equals "data_len // 2 + data_len % 2"
	idxs_data_copy_len = len(idxs) // 2 + len(idxs) % 2 + META_DATA_LEN
	asm += f"{label_name.upper()}_COPY_LEN = {idxs_data_copy_len}\n"

	#asm += f"{label_name.upper()}_SCR_ADDR = SCR_BUFF0_ADDR + ({pos_x}<<8 | {pos_y})\n"
	#asm += f"{label_name.upper()}_SCR_ADDR_END = SCR_BUFF0_ADDR + ({pos_x + tiles_w}<<8 | {pos_y + tiles_h * 8})\n"
	asm += "			.word 0 ; safety pair of bytes for reading by POP B\n"
	asm += label_name + ":\n"
	asm += f"			.word SCR_BUFF0_ADDR + ({pos_x}<<8 | {pos_y})	; scr addr\n"
	asm += f"			.word SCR_BUFF0_ADDR + ({pos_x + tiles_w}<<8 | {(pos_y + tiles_h * 8) % 256})	; scr addr end\n"
	asm += common.bytes_to_asm(idxs, tiles_w, True)

	return asm, len(idxs) + META_DATA_LEN

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

	tiled_file_path = source_dir + source_j['path']
	with open(tiled_file_path, "rb") as file:
		tiled_file_j = json.load(file)

	# make a tile index remap dictionary, to have the first idx = 0
	remap_idxs = remap_indices(tiled_file_j)

	if len(remap_idxs) > TILED_IMG_GFX_IDX_MAX:
		print(f'export_tiled_img ERROR: gfx_idxs > "{TILED_IMG_GFX_IDX_MAX}", path: {source_j_path}')
		print("Stop export")
		exit(1)	

	# list of tiles addreses
	png_name = common.path_to_basename(path_png)

	# remove it because this gives a big overhead for such small tiles.
	# asm += common_gfx.get_list_of_tiles(remap_idxs, "__" + source_name, png_name)
	
	# tile gfx data to asm
	asm += gfx_to_asm(image, remap_idxs, "__" + png_name)

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

	tiled_file_path = source_dir + source_j['path']
	with open(tiled_file_path, "rb") as file:
		tiled_file_j = json.load(file)

	# make a tile index remap dictionary, to have the first idx = 0
	remap_idxs = remap_indices(tiled_file_j)
 
	base_name = common.path_to_basename(tiled_file_path)

	for layer in tiled_file_j["layers"]:
		layer_name = layer["name"]
		if layer["type"] != "tilelayer":
			continue

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
		for t_y in reversed(range(tile_first_y, tile_last_y + 1)):
			for t_x in range(tile_first_x, tile_last_x + 1):
				t_idx = data[t_y * SCR_TILES_W + t_x]
				if t_idx > 0:
					idxs.append(remap_idxs[t_idx]) 
				else:
					idxs.append(0)

		label_name = "__" + base_name + "_" + layer_name
		pos_x = tile_first_x # SCR_TILES_W - tile_last_x - 1
		pos_y = (SCR_TILES_H - tile_last_y - 1) * IMG_TILE_W
		tiles_w = tile_last_x - tile_first_x + 1   
		tiles_h = tile_last_y - tile_first_y + 1 

		tiled_img_asm, tiled_img_len = tile_idxs_to_asm(idxs, pos_x, pos_y, tiles_w, tiles_h, label_name)
		asm += tiled_img_asm

		# check if the length of the image fits the requirements
		if tiled_img_len > TILED_IMG_IDXS_LEN_MAX:
			print(f'export_tiled_img ERROR: tiled image {layer_name} > "{TILED_IMG_IDXS_LEN_MAX}", path: {source_j_path}')
			print("Stop export")
			exit(1)		
	 
	with open(export_data_path, "w") as file:
		file.write(asm)

def is_source_updated(source_j_path):
	with open(source_j_path, "rb") as file:
		source_j = json.load(file)
	
	source_dir = str(Path(source_j_path).parent) + "\\"
	path_png = source_dir + source_j["path_png"]

	tiled_file_path = source_dir + source_j["path"]
	tiled_file_updated = build.is_file_updated(tiled_file_path)

	if build.is_file_updated(source_j_path) | build.is_file_updated(path_png) | tiled_file_updated:
		return True
	return False





