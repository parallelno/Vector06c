import os
import json
import build
import common
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
 
	if ram_disk_data_asm_force_export:
		# generate ram_disk_data.asm. it includes the ram-disk data		
		export_data_asm.export(source_j, source_j_path, generated_code_dir, generated_bin_dir, segments_info)
		# generate ram_disk_init.asm. it copies and preprocess the ram-disk data
		export_data_init.export(source_j, source_j_path, generated_code_dir, segments_info)

	# export main.asm
	source_path = source_j["main_asm_path"]

	rom_name = "main_asm"
	bin_path = generated_bin_dir + rom_name + build.EXT_BIN
	common.delete_file(bin_path)

	common.run_command(f"{build.assembler_path} {source_path} {bin_path}", "", source_path)
	
	if not os.path.exists(bin_path):
		print(f'ERROR: compilation error, path: {source_path}')
		print("Stop export")
		exit(1)	

	zx0_path = bin_path + build.packer_ext
	common.delete_file(zx0_path)
	common.run_command(f"{build.packer_path} {bin_path} {zx0_path}")

	# export unpacker.asm
	source_path = source_j["unpacker_path"]
	rom_dir = "rom\\"
	
	rom_name = os.path.basename(os.getcwd())
	bin_path = rom_dir + rom_name + build.EXT_BIN
	rom_path = rom_dir + rom_name + build.EXT_ROM	

	common.delete_file(bin_path)
	common.delete_file(rom_path) 

	common.run_command(f"{build.assembler_path} {source_path} {bin_path}", "", source_path)
	
	if not os.path.exists(bin_path):
		print(f'ERROR: compilation error, path: {source_path}')
		print("Stop export")
		exit(1)
	
	common.run_command(f"ren {bin_path} {rom_name + build.EXT_ROM}")    
	common.run_command(f"{build.emulator_path} {rom_path}", "", rom_path)	