import os
from pathlib import Path
import json
import common
import common_gfx
import build


#=====================================================
def export_if_updated(source_path, generated_dir, force_export):
	source_name = common.path_to_basename(source_path)

	export_paths = {"ram_disk" : generated_dir + source_name + "_data" + build.EXT_ASM }

	if force_export or is_source_updated(source_path):
		export_data( source_path, export_paths["ram_disk"])
			
		print(f"export_level: {source_path} got exported.")		
		return True, export_paths
	else:
		return False, export_paths
	
def export_data(source_j_path, export_data_path):

	with open(source_j_path, "rb") as file:
		source_j = json.load(file)

	source_dir = str(Path(source_j_path).parent) + "\\"

	# check if a folder exists
	export_dir = str(Path(export_data_path).parent) + "\\"
	if not os.path.exists(export_dir):
		os.mkdir(export_dir)

	if "asset_type" not in source_j or source_j["asset_type"] != build.ASSET_TYPE_LEVEL :
		print(f'export_level ERROR: asset_type != "{build.ASSET_TYPE_LEVEL}", path: {source_j_path}')
		print("Stop export")
		exit(1)

	source_name = common.path_to_basename(source_j_path)
	asm = ""

	asm = f"__RAM_DISK_S_{source_name.upper()}_DATA = RAM_DISK_S\n"
	asm += f"__RAM_DISK_M_{source_name.upper()}_DATA = RAM_DISK_M\n"
	asm += "\n"

	asm += "			.word 0 ; safety pair of bytes for reading by POP B\n"	
	asm += f"__{source_name}_start_pos:										; a hero starting pos\n"
	asm += f'			.byte {source_j["hero_start_pos"]["y"]}						; pos_y\n'
	asm += f'			.byte {source_j["hero_start_pos"]["x"]}						; pos_x\n'

	room_paths = source_j["rooms"]
	rooms_j = []
	# load and process tiled map
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
		room_data_label = get_room_data_label(room_path, source_dir)

		asm_room_data = room_tiles_to_asm(room_j["layers"][0], remap_idxs, room_data_label)
		
		# clamp tiledata values into the range 
		tiledatas_unclamped = room_j["layers"][1]["data"]
		tiledatas = [x % 256 for x in tiledatas_unclamped]
		
		width = room_j["width"]
		height = room_j["height"]
		asm_room_data += room_tiles_data_to_asm(tiledatas, width, height, room_path, source_dir)
		asm += "\n			.word 0 ; safety pair of bytes for reading by POP B\n"
		asm += room_data_label			
		asm += common.asm_compress_to_asm(asm_room_data)

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

		for i, tiledata in enumerate(tiledatas):
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
		# for example: all the rooms contain only res_id=1 and res_id=3
		# to make a proper data we need to add null_ptrs for res_id=0 and res_id=2
		# to let the asm code look up it by the res_id
		for tiledata in range(TILEDATA_RESOURCE, resource_max_tiledata + 1):
			if tiledata not in resources:
				resources[tiledata] = []

		resources_sorted = dict(sorted(resources.items()))
		
		ptr = 0
		resources_inst_data_ptrs_len = len(resources_sorted) + 1

		for i, tiledata in enumerate(resources_sorted):
			inst_len = len(resources_sorted[tiledata]) * WORD_LEN							
			if len(resources_sorted[tiledata]) > 0:
				asm += str(ptr + resources_inst_data_ptrs_len) + ", "
			else:     
				asm += str(ptr + inst_len + resources_inst_data_ptrs_len) + ", "				
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
			inst_len = len(containers_sorted[tiledata]) * WORD_LEN
			if len(containers_sorted[tiledata]) > 0:
				asm += str(ptr + containers_inst_data_ptrs_len) + ", "
			else:
				asm += str(ptr + inst_len + containers_inst_data_ptrs_len) + ", "			
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





