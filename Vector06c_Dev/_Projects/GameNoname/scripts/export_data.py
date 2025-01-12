import os
import json
import build
import common
import export_segment
import export_data_asm
import export_data_init
import export_sprite

def export_ram_data_labels(generated_code_dir, segments_info, main_asm_labels):
	# use the main programm labels to find preshift anim labels and their addrs
	asm = "; ram_data_labels:\n"

	for seg_info in segments_info:
		ram_data_paths = seg_info["ram_include_paths"]
		for ram_data_path in ram_data_paths:
			if len(ram_data_path) != 0:
				asm += export_sprite.get_anim_labels(ram_data_path, main_asm_labels)
	asm += "\n"

	path = f"{generated_code_dir}ram_data_labels{build.EXT_ASM}"
	with open(path, "w") as file:
		file.write(asm)

def export(source_j_path):
	with open(source_j_path, "rb") as file:
		source_j = json.load(file)

	if "asset_type" not in source_j or source_j["asset_type"] != build.ASSET_TYPE_DATA :
		build.exit_error(f'export_back ERROR: asset_type != "{build.ASSET_TYPE_DATA}", path: {source_j_path}')

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

	localization_id = source_j["localization"]["id"]
	if "overrides" in source_j["localization"] and localization_id in source_j["localization"]["overrides"]:
		export_localization_symbol(source_j["localization"]["overrides"][localization_id])

	# export all segments into bin files, then zip them, then split them into chunks (files <= 24KB)
	for bank_j in source_j["banks"]:
		seg_id = -1
		bank_id = int(bank_j["bank_id"])
		for segment_j in bank_j["segments"]:
			seg_id += 1
			exported, segment_info = export_segment.export(
				bank_id, seg_id, segment_j, source_j["includes"]["segment"],
				global_force_export, asset_types_force_export,
				generated_code_dir, generated_bin_dir, localization_id)

			ram_disk_data_asm_force_export |= exported
			segments_info.append(segment_info)
 
	if ram_disk_data_asm_force_export:
		# generate ram_disk_data.asm. it includes the ram-disk data		
		export_data_asm.export(source_j, source_j_path, generated_code_dir, generated_bin_dir, segments_info)
		
		# generate ram_disk_init.asm. it copies and preprocess the ram-disk data
		export_data_init.export(source_j, source_j_path, generated_code_dir, segments_info)

	# processing main.asm
	source_path = source_j["main_asm_path"]

	rom_name = "main_asm"
	bin_path = generated_bin_dir + rom_name + build.EXT_BIN
	common.delete_file(bin_path)

	# compile the main.asm
	main_asm_labels_path = generated_bin_dir + "main_asm_labels.txt"
	build.compile_asm(source_path, bin_path, main_asm_labels_path)
	main_asm_labels, comments = build.export_labels(main_asm_labels_path, False, True)

	build.printc(comments, build.TextColor.YELLOW)

	zx0_path = bin_path + build.packer_ext
	common.compress(bin_path, zx0_path)

	# processing main_unpacker.asm
	source_path = source_j["main_unpacker_path"]
	rom_dir = "rom\\"
	
	rom_name = os.path.basename(os.getcwd())
	bin_path = rom_dir + rom_name + build.EXT_BIN
	rom_path = rom_dir + rom_name + build.EXT_ROM	
	
	common.delete_file(bin_path)
	common.delete_file(rom_path)

	# export ram_data_labels.asm
	# export_ram_data_labels(generated_code_dir, segments_info, main_asm_labels)

	labels_path = rom_dir + build.DEBUG_FILE_NAME
	build.compile_asm(source_path, bin_path, labels_path)
	labels, comments = build.export_labels(labels_path, False, False)
	build.printc(comments, build.TextColor.YELLOW)
	labels.update(main_asm_labels)
	build.store_labels(labels, labels_path)
	
	common.run_command(f"ren {bin_path} {rom_name + build.EXT_ROM}")    

	build.printc(f";===========================================================================", build.TextColor.GREEN)
	build.printc(f";", build.TextColor.GREEN)
	build.printc(f"; ram-disk data export: Success.", build.TextColor.GREEN)
	build.printc(f"; start the game: {rom_path}", build.TextColor.GREEN)
	build.printc(f";", build.TextColor.GREEN)
	build.printc(f";===========================================================================", build.TextColor.GREEN)

	common.run_command(f"{build.emulator_path} {rom_path}", "", rom_path)

def export_localization_symbol(override_j):

	for file_data in override_j:
		path = file_data["path"] 
		content = ""
		for line in file_data["content"]:
			content += f"{line}\n"

		dir = os.path.dirname(path)
		if not os.path.exists(dir):
			os.makedirs(dir)

		with open(path, "w") as file:
			file.write(content)
