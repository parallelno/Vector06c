import json
import build
import export_segment
import export_data_asm
import export_data_init

def export(source_j_path):
	with open(source_j_path, "rb") as file:
		source_j = json.load(file)

	if "asset_type" not in source_j or source_j["asset_type"] != build.ASSET_TYPE_RAM_DISK_DATA :
		print(f'export_back ERROR: asset_type != "{build.ASSET_TYPE_BACK}", path: {source_j_path}')
		print("Stop export")
		exit(1)

	# set the global build_db_path
	build.build_db_init(source_j["build_db_path"])

	# check dependencies
	dependency_paths_j = source_j["dependencies"]
	global_force_export = False
	for path in dependency_paths_j["global"]:
		global_force_export |= build.is_file_updated(path)

	asset_types_dependencies = dependency_paths_j["asset_types"]
	asset_types_force_export = {}
	for asset_type in asset_types_dependencies:
		asset_types_force_export[asset_type] = build.is_file_updated(asset_types_dependencies[asset_type]) | global_force_export

	generated_code_dir = source_j["dirs"]["generated_code"]
	generated_bin_dir = source_j["dirs"]["generated_bin"]

	segments_info = []
	ram_disk_data_asm_force_export = global_force_export

	# export all segments into bin files, then zip them, then split them into chunks (files <= 24KB)
	for bank_j in source_j["banks"]:
		seg_id = -1
		bank_id = int(bank_j["bank_id"])
		for segment_j in bank_j["segments"]:
			seg_id += 1
			exported, segment_info = export_segment.export(
				bank_id, seg_id, segment_j, source_j["includes"]["segment"],
				global_force_export, asset_types_force_export,
				generated_code_dir, generated_bin_dir)

			ram_disk_data_asm_force_export |= exported
			segments_info.append(segment_info)
 
	# generate ram_disk_data.asm. it includes the ram-disk data
	# generate ram_disk_init.asm. it copies and preprocess the ram-disk data
	if ram_disk_data_asm_force_export:
		export_data_asm.export(source_j, generated_code_dir, generated_bin_dir, segments_info)
		export_data_init.export(source_j, generated_code_dir, source_j_path, segments_info)
