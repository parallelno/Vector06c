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

	dependency_paths_j = source_j["dependencies"]
	# check dependencies
	global_force_export = False
	for path in dependency_paths_j["global"]:
		global_force_export |= build.is_file_updated(path)

	sprite_force_export = build.is_file_updated(dependency_paths_j["sprite"])
	back_force_export = build.is_file_updated(dependency_paths_j["back"])
	decal_force_export = build.is_file_updated(dependency_paths_j["decal"])
	level_force_export = build.is_file_updated(dependency_paths_j["level"])
	music_force_export = build.is_file_updated(dependency_paths_j["music"])
	font_force_export = build.is_file_updated(dependency_paths_j["font"])
	image_force_export = build.is_file_updated(dependency_paths_j["image"])
	tiled_img_force_export = build.is_file_updated(dependency_paths_j["tiled_img"])

	generated_code_dir = source_j["dirs"]["generated_code"]
	generated_bin_dir = source_j["dirs"]["generated_bin"]

	segments_paths = {}
	ram_disk_data_asm_force_export = global_force_export

	# export all the banks data into bin files, then zip them, then split them into chunks
	for bank_j in source_j["banks"]:
		bank_id = int(bank_j["bank_id"])
		for segment_j in bank_j["segments"]:

			chunks_count = len(segment_j["chunks"])
			if chunks_count == 0:
				continue

			non_reserved_chunks = False
			for chunk_j in segment_j["chunks"]:
				if "reserved" not in chunk_j or not chunk_j["reserved"]:
					non_reserved_chunks = True
					break

			if not non_reserved_chunks:
				continue

			exported, segment_name, segment_paths = export_segment.export(
				bank_id, segment_j,
				global_force_export, sprite_force_export, back_force_export, decal_force_export, level_force_export, music_force_export, font_force_export, image_force_export, tiled_img_force_export,
				generated_code_dir, generated_bin_dir)

			ram_disk_data_asm_force_export |= exported
			segments_paths[segment_name] = segment_paths

	# generate ram_disk_data.asm. it includes all ram-disk data
	if ram_disk_data_asm_force_export:
		export_ram_disk_data_asm.export(source_j, generated_code_dir, generated_bin_dir, segments_paths)
		export_ram_disk_init.export(source_j, generated_code_dir, source_j_path)
