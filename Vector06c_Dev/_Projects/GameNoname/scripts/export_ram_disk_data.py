import os
import json
import common
import build
import export_segment
import export_ram_disk_data_asm
import export_ram_disk_init

def export(source_j_path):
	with open(source_j_path, "rb") as file:
		source_j = json.load(file)

	if "asset_type" not in source_j or source_j["asset_type"] != build.ASSET_TYPE_RAM_DISK_DATA :
		print(f'export_back ERROR: asset_type != "{build.ASSET_TYPE_BACK}", path: {source_j_path}')
		print("Stop export")
		exit(1)

	# set the global build_db_path
	build.build_db_init(source_j["build_db_path"])

	dependencyPathsJ = source_j["dependencies"]
	# check dependencies
	global_force_export = False
	for path in dependencyPathsJ["global"]:
		global_force_export |= build.is_file_updated(path)

	sprite_force_export = build.is_file_updated(dependencyPathsJ["sprite"])
	back_force_export = build.is_file_updated(dependencyPathsJ["back"])
	level_force_export = build.is_file_updated(dependencyPathsJ["level"])
	music_force_export = build.is_file_updated(dependencyPathsJ["music"])

	generated_code_dir = source_j["dirs"]["generated_code"]
	generated_bin_dir = source_j["dirs"]["generated_bin"]

	segments_paths = {}
	ram_disk_data_asm_force_export = global_force_export

	# export all the banks data into bin files, then zip them, then split them into chunks
	for bank_j in source_j["banks"]:
		bank_id = int(bank_j["bank_id"])
		for segment_j in bank_j["segments"]:
			if "reserved" in segment_j and segment_j["reserved"]:
				continue

			chunks_count = len(segment_j["chunks"])
			if chunks_count == 0:
				continue

			exported, segment_name, segment_paths = export_segment.export(
				bank_id, segment_j,
				global_force_export, sprite_force_export, back_force_export, level_force_export, music_force_export,
				generated_code_dir, generated_bin_dir)

			ram_disk_data_asm_force_export |= exported
			segments_paths[segment_name] = segment_paths

	bank_id_backbuffer = source_j["bank_id_backbuffer"]
	bank_id_backbuffer2 = source_j["bank_id_backbuffer2"]
	back_buffer_size = source_j["back_buffer_size"]

	# generate ram_disk_data.asm. it includes all ram-disk data
	if ram_disk_data_asm_force_export:
		export_ram_disk_data_asm.export(source_j, generated_code_dir, segments_paths, 
										bank_id_backbuffer, back_buffer_size )
		export_ram_disk_init.export(source_j, generated_code_dir, segments_paths, 
										bank_id_backbuffer, bank_id_backbuffer2)
