import os
from PIL import Image
from pathlib import Path
import json
import common
import build

def room_tiles_to_asm(room_j, room_path, remap_idxs, source_dir):
	asm = "; " + source_dir + room_path + "\n"
	room_path_wo_ext = os.path.splitext(room_path)[0]
	label_prefix = os.path.basename(room_path_wo_ext)
	asm += "__" + label_prefix + ":\n"
	width = room_j["width"]
	height = room_j["height"]
	size = width * height

	for y in reversed(range(height)):
		asm += "			.byte "
		for x in range(width):
			i = y*width + x
			t_idx = room_j["data"][i]
			asm += str(remap_idxs[t_idx]) + ", "
		asm += "\n"
	return asm, size

def room_tiles_data_to_asm(room_j, room_path, source_dir):
	asm = "; " + source_dir + room_path + "\n"
	room_path_wo_ext = os.path.splitext(room_path)[0]
	label_prefix = os.path.basename(room_path_wo_ext)
	asm += "__" + label_prefix + "_tilesData:\n"
	width = room_j["width"]
	height = room_j["height"]
	size = width * height

	for y in reversed(range(height)):
		asm += "			.byte "
		for x in range(width):
			i = y*width + x
			t_idx = room_j["data"][i]
			asm += str(t_idx) + ", "
		asm += "\n"
	return asm, size

def get_tile_data(bytes0, bytes1, bytes2, bytes3):
	all_bytes = [bytes0, bytes1, bytes2, bytes3]
	# data structure description is in drawTile.asm
	mask = 0
	data = []
	for bytes in all_bytes:
		mask >>=  1
		if common.is_bytes_zeros(bytes) : 
			continue
		mask += 8

		x = 0
		for y in reversed(range(16)):
			byte = bytes[y * 2 + x]
			data.append(byte)
		x = 1
		for y in range(16):
			byte = bytes[y * 2 + x]
			data.append(byte)

	return data, mask
	
def tiles_to_asm(room_j, image, path, remap_idxs, label_prefix):
	size = 0
	asm = "; " + path + "\n"
	asm += label_prefix + "_tiles:\n"

	tileW = room_j["tilewidth"]
	tileH = room_j["tileheight"]
	
	width = room_j["layers"][0]["width"]
	height = room_j["layers"][0]["height"]
	
	# extract tile images and convert them into asm
	for t_idx in remap_idxs:
		# get a tile as a color index 2d array
		tile_img = []
		idx = t_idx - 1
		sx = idx % width * tileW
		sy = idx // width * tileH
		for y in range(sy, sy + tileH) :
			line = []
			for x in range(sx, sx+tileW) :
				color_idx = image.getpixel((x, y))
				line.append(color_idx)
				#x += 1
			tile_img.append(line)
			#y += 1
		
		# convert indexes into bit lists.
		bits0, bits1, bits2, bits3 = common.indexes_to_bit_lists(tile_img)

		# combite bits into byte lists
		bytes0 = common.combine_bits_to_bytes(bits0) # 8000-9FFF # from left to right, from bottom to top
		bytes1 = common.combine_bits_to_bytes(bits1) # A000-BFFF
		bytes2 = common.combine_bits_to_bytes(bits2) # C000-DFFF
		bytes3 = common.combine_bits_to_bytes(bits3) # E000-FFFF

		# to support a tile render function
		data, mask = get_tile_data(bytes0, bytes1, bytes2, bytes3)


		# two empty bytes prior every data to support a stack renderer
		asm += "			.byte 0,0 ; safety pair of bytes to support a stack renderer\n"
		asm += label_prefix + "_tile" + str(remap_idxs[t_idx]) + ":\n"
		asm += "			.byte " + str(mask) + " ; mask\n"
		asm += "			.byte 4 ; counter\n"
		asm += common.bytes_to_asm(data)
		size += len(data)

	return asm, size

def remap_index(rooms_j):
	unique_idxs = [] # old idx : new idx
	for room_j in rooms_j:
		for idx in room_j["layers"][0]["data"]:
			if idx in unique_idxs:
				continue
			unique_idxs.append(idx)
	remap_idxs = {} # old idx : new idx
	for i, idx in enumerate(unique_idxs):
		remap_idxs[idx] = i
	
	return remap_idxs

def get_list_of_rooms(room_paths, label_prefix):
	size = 0
	asm = "\n			.byte 0,0 ; safety pair of bytes to support a stack renderer\n"
	asm += label_prefix + "_rooms_addr:\n			.word "
	for i, room_path_p in enumerate(room_paths):
		room_path = room_path_p['path']
		room_path_wo_ext = os.path.splitext(room_path)[0]
		label_prefix = os.path.basename(room_path_wo_ext)
		asm += "__" + label_prefix + ", "
		if i != len(room_paths)-1:
			# two safety fytes
			asm += "0, "
		size += 2
	asm += "\n"
	return asm, size

def get_list_of_tiles(remap_idxs, label_prefix, pngLabelPrefix):
	size = 0
	asm = "\n			.byte 0,0 ; safety pair of bytes to support a stack renderer\n"
	asm += label_prefix + "_tilesAddr:\n			.word "
	for i, t_idx in enumerate(remap_idxs):
		asm += "__" + pngLabelPrefix + "_tile" + str(remap_idxs[t_idx]) + ", "
		if i != len(remap_idxs)-1:
			# two safety fytes
			asm += "0, "
		size += 2
	asm += "\n"
	return asm, size

def start_pos_to_asm(source_j, label_prefix):
	asm = ("\n			.byte 0,0 ; safety pair of bytes to support a stack renderer\n" + 
			"__" + label_prefix + "_startPos:\n			.byte " + 
			str(source_j["startPos"]["y"]) + ", " + 
			str(source_j["startPos"]["x"]) + "\n")
	return asm, 4

#=====================================================
def export_if_updated(source_path, generated_dir, force_export):
	source_path_wo_ext = os.path.splitext(source_path)[0]
	source_name = os.path.basename(source_path_wo_ext)
	export_paths = {"ram_disk" : generated_dir + source_name + build.EXT_ASM }

	if force_export or is_source_updated(source_path):
		export(
			source_path, 
			export_paths["ram_disk"])
			
		print(f"level: {source_path} got exported.")		
		return True, export_paths
	else:
		return False, export_paths

def export(source_j_path, export_path):

	export_dir = str(Path(export_path).parent) + "\\"

	with open(source_j_path, "rb") as file:
		source_j = json.load(file)

	source_dir = str(Path(source_j_path).parent) + "\\"

	if "asset_type" not in source_j or source_j["asset_type"] != build.ASSET_TYPE_LEVEL :
		print(f'level_export ERROR: asset_type != "{build.ASSET_TYPE_LEVEL}", path: {source_j_path}')
		print("Stop export")
		exit(1)

	png_path = source_dir + source_j["png_path"]
	image = Image.open(png_path) 

	source_path_wo_ext = os.path.splitext(source_j_path)[0]
	source_name = os.path.basename(source_path_wo_ext)

	asm = f"__RAM_DISK_S_{source_name.upper()} = RAM_DISK_S\n"
	asm += f"__RAM_DISK_M_{source_name.upper()} = RAM_DISK_M\n"
	
	palette_asm, colors = common.palette_to_asm(image, source_j, png_path, "__" + source_name)
	asm += palette_asm

	data_size = len(colors)
	asm_start_pos, size = start_pos_to_asm(source_j, source_name)
	asm += asm_start_pos
	data_size += size
	image = common.remap_colors(image, colors)

	room_paths = source_j["rooms"]
	rooms_j = []
	# load and parse tiled map
	for room_path_p in room_paths:
		room_path = source_dir + room_path_p['path']
		with open(room_path, "rb") as file:
			rooms_j.append(json.load(file))
		
	# make a tile index remap dictionary, to have the first idx = 0
	remap_idxs = remap_index(rooms_j)

	png_path_wo_ext = os.path.splitext(png_path)[0]
	png_name = os.path.basename(png_path_wo_ext)

	# list of rooms
	asm_l, size = get_list_of_rooms(room_paths, "__" + source_name)
	asm += asm_l
	data_size += size
	# list of tiles addreses
	asm_lt, size = get_list_of_tiles(remap_idxs, "__" + source_name, png_name)
	asm += asm_lt
	data_size += size
	# every room data
	for i, room_j in enumerate(rooms_j):
		asm_rt, size = room_tiles_to_asm(room_j["layers"][0], room_paths[i]['path'], remap_idxs, source_dir)
		asm += "\n			.byte 0,0 ; safety pair of bytes to support a stack renderer\n"
		asm += asm_rt
		data_size += size
		asm_rtd, size = room_tiles_data_to_asm(room_j["layers"][1], room_paths[i]['path'], source_dir)
		asm += "\n			.byte 0,0 ; safety pair of bytes to support a stack renderer\n"
		asm += asm_rtd
		data_size += size

	# tile art data to asm
	asm_t, size = tiles_to_asm(rooms_j[0], image, png_path, remap_idxs, "__" + png_name)
	asm += asm_t
	data_size += size

	# save asm
	if not os.path.exists(export_dir):
		os.mkdir(export_dir)

	with open(export_path, "w") as file:
		file.write(asm)

def is_source_updated(source_j_path):
	with open(source_j_path, "rb") as file:
		source_j = json.load(file)
	
	source_dir = str(Path(source_j_path).parent) + "\\"
	png_path = source_dir + source_j["png_path"]

	room_paths = source_j["rooms"]
	rooms_updated = False
	for room_path_p in room_paths:
		room_path = source_dir + room_path_p['path']
		rooms_updated |= build.is_file_updated(room_path)

	if build.is_file_updated(source_j_path) | build.is_file_updated(png_path) | rooms_updated:
		return True
	return False





