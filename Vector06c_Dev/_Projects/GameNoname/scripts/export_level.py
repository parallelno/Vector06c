import os
from PIL import Image
from pathlib import Path
import json
import common
import build

def get_room_data_label(room_path, source_dir = ""):
	asm = ""
	if source_dir != "": 
		asm += "; " + source_dir + room_path + "\n"
	room_path_wo_ext = os.path.splitext(room_path)[0]
	label_prefix = os.path.basename(room_path_wo_ext)
	asm += "__" + label_prefix
	if source_dir != "":
		asm += ":\n"
	return asm

def room_tiles_to_asm(room_j, room_path, remap_idxs, source_dir):
	asm = get_room_data_label(room_path, source_dir)
	width = room_j["width"]
	height = room_j["height"]
	width * height

	for y in reversed(range(height)):
		asm += "			.byte "
		for x in range(width):
			i = y*width + x
			t_idx = room_j["data"][i]
			asm += str(remap_idxs[t_idx]) + ", "
		asm += "\n"
	return asm

def room_tiles_data_to_asm(room_j, room_path, source_dir):
	asm = "; " + source_dir + room_path + "\n"
	room_path_wo_ext = os.path.splitext(room_path)[0]
	label_prefix = os.path.basename(room_path_wo_ext)
	asm += "__" + label_prefix + "_tilesData:\n"
	width = room_j["width"]
	height = room_j["height"]

	for y in reversed(range(height)):
		asm += "			.byte "
		for x in range(width):
			i = y*width + x
			t_idx = room_j["data"][i]
			asm += str(t_idx) + ", "
		asm += "\n"
	return asm

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

		x = 0
		for y in reversed(range(16)):
			byte = bytes[y * 2 + x]
			data.append(byte)
		x = 1
		for y in range(16):
			byte = bytes[y * 2 + x]
			data.append(byte)

	return data, mask
	
def gfx_to_asm(room_j, image, path, remap_idxs, label_prefix):
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
		data, mask = get_tiledata(bytes0, bytes1, bytes2, bytes3)


		asm += "			.word 0 ; safety pair of bytes for reading by POP B\n"
		asm += label_prefix + "_tile" + str(remap_idxs[t_idx]) + ":\n"
		asm += "			.byte " + str(mask) + " ; mask\n"
		asm += "			.byte 4 ; counter\n"
		asm += common.bytes_to_asm(data)

	return asm

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
	asm = "\n			.word 0 ; safety pair of bytes for reading by POP B\n"
	asm += label_prefix + "_rooms_addr:\n			.word "

	for i, room_path_p in enumerate(room_paths):
		room_path = room_path_p['path']
		asm += get_room_data_label(room_path) + ", "

		if i != len(room_paths)-1:
			# two safety fytes
			asm += "0, "
	asm += "\n"
	return asm

def get_list_of_tiles(remap_idxs, label_prefix, pngLabelPrefix):
	asm = "\n			.word 0 ; safety pair of bytes for reading by POP B\n"
	asm += label_prefix + "_tiles_addr:\n			.word "
	for i, t_idx in enumerate(remap_idxs):
		asm += "__" + pngLabelPrefix + "_tile" + str(remap_idxs[t_idx]) + ", "
		if i != len(remap_idxs)-1:
			# two safety fytes
			asm += "0, "
	asm += "\n\n"
	return asm

#=====================================================
def export_data_if_updated(source_path, generated_dir, force_export):
	source_path_wo_ext = os.path.splitext(source_path)[0]
	source_name = os.path.basename(source_path_wo_ext)
	export_paths = {"ram_disk" : generated_dir + source_name + "_data" + build.EXT_ASM }

	if force_export or is_source_updated(source_path):
		export_data( source_path, export_paths["ram_disk"])
			
		print(f"export_level: {source_path} got exported.")		
		return True, export_paths
	else:
		return False, export_paths
	
def export_gfx_if_updated(source_path, generated_dir, force_export):
	source_path_wo_ext = os.path.splitext(source_path)[0]
	source_name = os.path.basename(source_path_wo_ext)
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

	if "asset_type" not in source_j or source_j["asset_type"] != build.ASSET_TYPE_LEVEL :
		print(f'level_export ERROR: asset_type != "{build.ASSET_TYPE_LEVEL}", path: {source_j_path}')
		print("Stop export")
		exit(1)

	path_png = source_dir + source_j["path_png"]
	image = Image.open(path_png) 

	source_path_wo_ext = os.path.splitext(source_j_path)[0]
	source_name = os.path.basename(source_path_wo_ext)
	
	asm = ""
	asm = f"__RAM_DISK_S_{source_name.upper()}_GFX = RAM_DISK_S\n"
	asm += f"__RAM_DISK_M_{source_name.upper()}_GFX = RAM_DISK_M\n"

	#asm += f';=============================================================\n'
	#asm += "; init commands and ptrs to access the level gfx\n"
	#asm += "			.word 0 ; safety pair of bytes for reading by POP B\n"
	#asm += f"__{source_name}_init_tbl_gfx:\n"
	#asm += f"level_ram_disk_s_gfx: 						; ram-disk cmd to access level gfx via stack\n"
	#asm += f"			.byte RAM_DISK_S\n"
	#asm += f"level_ram_disk_m_gfx: 						; ram-disk cmd to access level gfx via commands\n"
	#asm += f"			.byte RAM_DISK_M\n"	
	
	#asm += f"level_palette_ptr:							; ram-disk ptr to a level palette\n"
	#asm += f'			.word __{source_name}_palette\n'
	#asm += f"level_tiles_addr:							; level tile gfx ptrs\n"
	#asm += f'			.word __{source_name}_tiles_addr\n'	
	#asm += f';=============================================================\n\n'
	
	palette_asm, colors = common.palette_to_asm(image, source_j, path_png, "__" + source_name)
	asm += palette_asm

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

	png_path_wo_ext = os.path.splitext(path_png)[0]
	png_name = os.path.basename(png_path_wo_ext)

	# list of tiles addreses
	png_path_wo_ext = os.path.splitext(path_png)[0]
	png_name = os.path.basename(png_path_wo_ext)
	asm += get_list_of_tiles(remap_idxs, "__" + source_name, png_name)
	
	# tile gfx data to asm
	asm += gfx_to_asm(rooms_j[0], image, path_png, remap_idxs, "__" + png_name)

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

	# save asm
	export_dir = str(Path(export_data_path).parent) + "\\"
	if not os.path.exists(export_dir):
		os.mkdir(export_dir)

	if "asset_type" not in source_j or source_j["asset_type"] != build.ASSET_TYPE_LEVEL :
		print(f'level_export ERROR: asset_type != "{build.ASSET_TYPE_LEVEL}", path: {source_j_path}')
		print("Stop export")
		exit(1)

	#path_png = source_dir + source_j["path_png"]
	#image = Image.open(path_png) 

	source_name = common.path_to_basename(source_j_path)
	asm = ""

	asm = f"__RAM_DISK_S_{source_name.upper()}_DATA = RAM_DISK_S\n"
	asm += f"__RAM_DISK_M_{source_name.upper()}_DATA = RAM_DISK_M\n"
	asm += "\n"

	asm += "			.word 0 ; safety pair of bytes for reading by POP B\n"	
	asm += f"__{source_name}_start_pos:										; a hero starting pos\n"
	asm += f'			.byte {source_j["start_pos"]["y"]}						; pos_y\n'
	asm += f'			.byte {source_j["start_pos"]["x"]}						; pos_x\n'

	room_paths = source_j["rooms"]
	rooms_j = []
	# load and parse tiled map
	for room_path_p in room_paths:
		room_path = source_dir + room_path_p['path']
		with open(room_path, "rb") as file:
			rooms_j.append(json.load(file))
		
	# make a tile index remap dictionary, to have the first idx = 0
	remap_idxs = remap_index(rooms_j)

	# list of rooms
	asm += get_list_of_rooms(room_paths, "__" + source_name)

	# data for rooms_resources_tbl and rooms_resources
	resources = {}
	resource_max_tiledata = 0
	# data for rooms_containers_tbl and rooms_containers
	containers = {}
	container_max_tiledata = 0
	# per room data
	for room_id, room_j in enumerate(rooms_j):
		room_path = room_paths[room_id]['path']

		asm_room_data = ".org 0 \n"
		asm_room_data += room_tiles_to_asm(room_j["layers"][0], room_path, remap_idxs, source_dir)
		asm_room_data += room_tiles_data_to_asm(room_j["layers"][1], room_path, source_dir)
		# save room data to a temp file
		asm_room_data_path_asm = export_dir + "room_data" + build.EXT_ASM
		asm_room_data_path_bin = export_dir + "room_data" + build.EXT_BIN
		asm_room_data_path_zx0 = export_dir + "room_data" + build.EXT_BIN_ZX0

		with open(asm_room_data_path_asm, "w") as file:
			file.write(asm_room_data)
		# asm to temp bin
		common.run_command(f"{build.assembler_path} {asm_room_data_path_asm} "
			f" {asm_room_data_path_bin}")
		# pack a room data
		common.run_command(f"{build.zx0_path} {asm_room_data_path_bin} {asm_room_data_path_zx0}")
		# load bin
		with open(asm_room_data_path_zx0, "rb") as file:
			asm += "\n			.word 0 ; safety pair of bytes for reading by POP B\n"
			asm += get_room_data_label(room_path, source_dir)
			asm += common.bytes_to_asm(file.read())

		# del tmp files
		common.delete_file(asm_room_data_path_asm)
		common.delete_file(asm_room_data_path_bin) 
		common.delete_file(asm_room_data_path_zx0)

		# collect resource data
		# TODO: get this from asm file
		TILEDATA_RESOURCE	= 7*16
		RESOURCES_UNIQUE_MAX = 16
		RESOURCES_LEN	= 0x100		
		# collect container data
		TILEDATA_CONTAINER	= 11*16 
		CONTAINERS_UNIQUE_MAX = 16
		# TODO: get this from asm file
		CONTAINERS_LEN	= 0x100

		WORD_LEN			= 2
		NULL_PTR			= "NULL_PTR"

		for i, tiledata in enumerate(room_j["layers"][1]["data"]):
			width = room_j["width"]
			height = room_j["height"]
			dy, dx = divmod(i, width)
			tile_idx = (height - 1 - dy) * width + dx
			if TILEDATA_RESOURCE <= tiledata < TILEDATA_RESOURCE + RESOURCES_UNIQUE_MAX:
				if tiledata not in resources:
					resources[tiledata] = []
				resources[tiledata].append((room_id, tile_idx))
				if resource_max_tiledata < tiledata:
					resource_max_tiledata = tiledata

			if TILEDATA_CONTAINER <= tiledata < TILEDATA_CONTAINER + CONTAINERS_UNIQUE_MAX:
				if tiledata not in containers:
					containers[tiledata] = []
				containers[tiledata].append((room_id, tile_idx))		
				if container_max_tiledata < tiledata:
					container_max_tiledata = tiledata
				
	# make resources_inst_data_ptrs data
	asm += f"\n__{source_name}_resources_inst_data_ptrs:\n"
	if len(resources) > 0:
		asm += "			.byte "

		# add resource tiledata which is not present in the level to make resources_inst_data_ptrs array contain contiguous data
		# for example: all the rooms contain only resource_id=1 and resource_id=3
		# to make a proper data we need to add null_ptrs for resource_id=0 and resource_id=2
		# to let the asm code look up it by the resource_id
		for tiledata in range(TILEDATA_RESOURCE, resource_max_tiledata + 1):
			if tiledata not in resources:
				resources[tiledata] = []

		resources_sorted = dict(sorted(resources.items()))
		
		ptr = 0
		resources_inst_data_ptrs_len = len(resources_sorted) + 1

		for i, tiledata in enumerate(resources_sorted):
			if len(resources_sorted[tiledata]) > 0:
				asm += str(ptr + resources_inst_data_ptrs_len) + ", "
			else:
				asm += NULL_PTR + ", "
			inst_len = len(resources_sorted[tiledata]) * WORD_LEN
			ptr += inst_len			
				
		asm += str(ptr + resources_inst_data_ptrs_len) + ", "

		# make resources_inst_data data 
		asm += f"\n__{source_name}_resources_inst_data:\n"
		for i, tiledata in enumerate(resources_sorted):
			if len(resources_sorted[tiledata]) > 0:
				asm += "			.byte "
				for room_id, tile_idx in resources_sorted[tiledata]:
					asm += f"{tile_idx}, {room_id}, "
				asm += "\n"

			
		if 	ptr + resources_inst_data_ptrs_len > 256:
			print(f"ERROR: {source_j_path} has resource instance data > {RESOURCES_LEN} bytes")
			print("Stop export")
			exit(1)

	# make containers_inst_data_ptrs data 
	asm += f"\n__{source_name}_containers_inst_data_ptrs:\n"
	if len(containers) > 0:		
		asm += "			.byte "

		# add container tiledata which is not present in the level to make containers_inst_data_ptrs array contain contiguous data
		# for example: all the rooms contain only container_id=1 and container_id=3
		# to make a proper data we need to add null_ptrs for container_id=0 and container_id=2
		# to let the asm code look up it by the container_id
		for tiledata in range(TILEDATA_CONTAINER, container_max_tiledata + 1):
			if tiledata not in containers:
				containers[tiledata] = []

		containers_sorted = dict(sorted(containers.items())) 

		ptr = 0
		containers_inst_data_ptrs_len = len(containers_sorted) + 1
		for i, tiledata in enumerate(containers_sorted):
			if len(containers_sorted[tiledata]) > 0:
				asm += str(ptr + containers_inst_data_ptrs_len) + ", "
			else:
				asm += NULL_PTR + ", "

			inst_len = len(containers_sorted[tiledata]) * WORD_LEN			
			ptr += inst_len
		asm += str(ptr + containers_inst_data_ptrs_len) + ", "

		# make containers_inst_data data 
		asm += f"\n__{source_name}_containers_inst_data:\n"
		for i, tiledata in enumerate(containers_sorted):
			if len(containers_sorted[tiledata]) > 0:
				asm += "			.byte "
				for room_id, tile_idx in containers_sorted[tiledata]:
					asm += f"{tile_idx}, {room_id}, "
				asm += "\n"
			
		if 	ptr + containers_inst_data_ptrs_len > 256:
			print(f"ERROR: {source_j_path} has container instance data > {CONTAINERS_LEN} bytes")
			print("Stop export")
			exit(1)		

	with open(export_data_path, "w") as file:
		file.write(asm)

def is_source_updated(source_j_path):
	with open(source_j_path, "rb") as file:
		source_j = json.load(file)
	
	source_dir = str(Path(source_j_path).parent) + "\\"
	path_png = source_dir + source_j["path_png"]

	room_paths = source_j["rooms"]
	rooms_updated = False
	for room_path_p in room_paths:
		room_path = source_dir + room_path_p['path']
		rooms_updated |= build.is_file_updated(room_path)

	if build.is_file_updated(source_j_path) | build.is_file_updated(path_png) | rooms_updated:
		return True
	return False





