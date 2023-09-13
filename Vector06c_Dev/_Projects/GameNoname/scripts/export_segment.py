import os
import json
import common
import build
import export_sprite
import export_back
import export_decal
import export_level
import export_music
import export_font
import export_image
import export_tiled_img

def check_segment_size(path, segment_addr):
	if segment_addr != build.SEGMENT_0000_7F00_ADDR and segment_addr != build.SEGMENT_8000_0000_ADDR :
		print("ERROR: Segment start addr has to be " + hex(build.SEGMENT_0000_7F00_SIZE_MAX) + " or " + hex(build.SEGMENT_8000_0000_SIZE_MAX))
		print("Stop export")
		exit(1)

	segment_size = os.path.getsize(path)
	segment_size_max = build.get_segment_size_max(segment_addr)

	if segment_size > segment_size_max:
			print(f"ERROR: {path} is bigger than {segment_size_max} bytes")
			print("Stop export")
			exit(1)

def split_segment(segment_path, segmentLabelsPath):
	with open(segmentLabelsPath, "rb") as file:
		labels = file.readlines()

	# look up the start and the end addrs of a chunk in a segment
	chunk_start_addrs = []
	chunk_end_addrs = []
	for line_a in labels:
		line = line_a.decode('ascii').lower()
		if line.find("__chunk_start") != -1:
			chunk_start_addr_s = line[line.find("$")+1:]
			chunk_start_addr = int(chunk_start_addr_s, 16)
			chunk_start_addrs.append(chunk_start_addr)
		if line.find("__chunk_end") != -1:
			chunk_end_addr_s = line[line.find("$")+1:]
			chunk_end_addr = int(chunk_end_addr_s, 16)
			chunk_end_addrs.append(chunk_end_addr)

	chunks_paths = []

	chunk_count = len(chunk_start_addrs)
	with open(segment_path, "rb") as file:
		for i in range(chunk_count):

			chunk_size = chunk_end_addrs[i] - chunk_start_addrs[i]
			data = file.read(chunk_size)
			chunk_dir = os.path.dirname(segment_path) + "\\"
			segment_basename = common.path_to_basename(segment_path)
			segment_idx = segment_basename.find("_")
			chunk_name = "chunk" + segment_basename[segment_idx:]

			chunk_path = chunk_dir + chunk_name + "_" + str(i) + build.EXT_BIN
			chunks_paths.append(chunk_path)
			with open(chunk_path, "wb") as fw:
				fw.write(data)
	return chunks_paths

def compile_and_compress(source_path, generated_bin_dir, segment_addr, force_export, externals_only):
	source_path_wo_ext = os.path.splitext(source_path)[0]
	source_name = common.path_to_basename(source_path)

	labels_path = f"{source_path_wo_ext}_labels{build.EXT_ASM}"
	segment_bin_path = generated_bin_dir + source_name + build.EXT_BIN

	export_paths = {
		"labels_path" : labels_path,
		"segment_bin_path" : segment_bin_path,
	}

	if force_export:
		common.run_command(f"{build.assembler_path} {build.assembler_labels_cmd} {source_path} "
				f" {segment_bin_path} >{labels_path}")

		if not os.path.exists(segment_bin_path):
			print(f'export_segment ERROR: compilation error, path: {source_path}')
			print("Stop export")
			exit(1)

		check_segment_size(segment_bin_path, segment_addr)

		build.export_labels(labels_path, externals_only)

		chunk_paths = split_segment(segment_bin_path, labels_path)

		for chunk_path in chunk_paths:
			zx0_chunk_path = chunk_path + build.packer_ext

			common.delete_file(zx0_chunk_path)
			common.run_command(f"{build.packer_path} {chunk_path} {zx0_chunk_path}")

		print(f"segment: {source_name} got exported.")

		return True, export_paths
	else:
		return False, export_paths

#=========================================================================================
def export(bank_id, segment_j,
			force_export, sprite_force_export, back_force_export, decal_force_export, level_force_export, music_force_export, font_force_export, image_force_export, tiled_img_force_export,
			generated_code_dir, generated_bin_dir):

	addr_s = segment_j["addr"]
	addr_s_wo_hex_sym = common.get_addr_wo_prefix(addr_s)
	asm = f'.org {addr_s}\n'
	asm += '.include "asm\\\\globals\\\\global_consts.asm"\n'
	asm += f'RAM_DISK_S = RAM_DISK_S{bank_id}\n'
	asm += f'RAM_DISK_M = RAM_DISK_M{bank_id}\n\n'

	segment_force_export = force_export
	ram_include_paths = []
	segment_include_paths = []

	# export segment data
	for chunk_n, chunk_j in enumerate(segment_j["chunks"]):

		if "reserved" in chunk_j and chunk_j["reserved"]:
			asm += f"; {build.get_chunk_start_label_name(bank_id, addr_s_wo_hex_sym, chunk_n)}:\n"
			description = chunk_j.get("description", "")
			asm += f"; reserved. {description}\n\n"
			continue
		
		asm += build.get_chunk_start_label_name(bank_id, addr_s_wo_hex_sym, chunk_n) + ":\n\n"

		for asset in chunk_j["assets"]:

			segment_include_path = ""

			if asset["asset_type"] == build.ASSET_TYPE_SPRITE:
				exported, export_paths = export_sprite.export_if_updated(asset["path"], asset["export_dir"], sprite_force_export | force_export)
				segment_force_export |= exported
				ram_include_paths.append(export_paths["ram"])
				segment_include_path = export_paths["ram_disk"]

			elif asset["asset_type"] == build.ASSET_TYPE_BACK:
				exported, export_paths = export_back.export_if_updated(asset["path"], asset["export_dir"], back_force_export | force_export)
				segment_force_export |= exported
				ram_include_paths.append(export_paths["ram"])
				segment_include_path = export_paths["ram_disk"]
			
			elif asset["asset_type"] == build.ASSET_TYPE_FONT or asset["asset_type"] == build.ASSET_TYPE_FONT_RD:
				font_gfx_ptrs_rd = False
				if asset["asset_type"] == build.ASSET_TYPE_FONT_RD:
					font_gfx_ptrs_rd = True
				exported, export_paths = export_font.export_if_updated(asset["path"], asset["export_dir"], font_force_export | force_export, font_gfx_ptrs_rd)
				segment_force_export |= exported
				if asset["asset_type"] == build.ASSET_TYPE_FONT:
					ram_include_paths.append(export_paths["ram"])
				segment_include_path = export_paths["ram_disk"]

			elif asset["asset_type"] == build.ASSET_TYPE_IMAGE:
				exported, export_paths = export_image.export_if_updated(asset["path"], asset["export_dir"], image_force_export | force_export)
				segment_force_export |= exported
				segment_include_path = export_paths["ram_disk"]

			elif asset["asset_type"] == build.ASSET_TYPE_DECAL:
				exported, export_paths = export_decal.export_if_updated(asset["path"], asset["export_dir"], decal_force_export | force_export)
				segment_force_export |= exported
				segment_include_path = export_paths["ram_disk"]

			elif asset["asset_type"] == build.ASSET_TYPE_LEVEL_DATA:
				exported, export_paths = export_level.export_data_if_updated(asset["path"], asset["export_dir"], level_force_export | force_export)
				segment_force_export |= exported
				segment_include_path = export_paths["ram_disk"]

			elif asset["asset_type"] == build.ASSET_TYPE_LEVEL_GFX:
				exported, export_paths = export_level.export_gfx_if_updated(asset["path"], asset["export_dir"], level_force_export | force_export)
				segment_force_export |= exported
				segment_include_path = export_paths["ram_disk"]

			elif asset["asset_type"] == build.ASSET_TYPE_TILED_IMG_GFX:
				exported, export_paths = export_tiled_img.export_gfx_if_updated(asset["path"], asset["export_dir"], tiled_img_force_export | force_export)
				segment_force_export |= exported
				segment_include_path = export_paths["ram_disk"]

			elif asset["asset_type"] == build.ASSET_TYPE_TILED_IMG_DATA:
				exported, export_paths = export_tiled_img.export_data_if_updated(asset["path"], asset["export_dir"], tiled_img_force_export | force_export)
				segment_force_export |= exported
				segment_include_path = export_paths["ram_disk"]

			elif asset["asset_type"] == build.ASSET_TYPE_MUSIC:
				exported, export_paths = export_music.export_if_updated(asset["path"], asset["export_dir"], music_force_export | force_export)
				segment_force_export |= exported
				segment_include_path = export_paths["ram_disk"]

			elif asset["asset_type"] == build.ASSET_TYPE_CODE:
				segment_include_path = asset["path"]
				segment_force_export |= build.is_asm_updated(segment_include_path)

			asm += f'__{common.path_to_basename(segment_include_path)}_rd_data_start:\n'
			asm += f'.include "{common.double_slashes(segment_include_path)}"\n'
			asm += f'__{common.path_to_basename(segment_include_path)}_rd_data_end:\n'

			segment_include_paths.append(segment_include_path)

		asm += f'\n.align 2\n'
		asm += build.get_chunk_end_label_name(bank_id, addr_s_wo_hex_sym, chunk_n) + ":\n\n"

	name = build.get_segment_name(bank_id, addr_s_wo_hex_sym)
	path = generated_code_dir + name + build.EXT_ASM

	# save a segment data file
	if (segment_force_export):
		if not os.path.exists(generated_code_dir):
			os.mkdir(generated_code_dir)

		with open(path, "w") as file:
			file.write(asm)

	segment_addr = build.get_segment_addr(addr_s_wo_hex_sym)
	exported, export_paths = compile_and_compress(path, generated_bin_dir, segment_addr, segment_force_export, True)

	return exported, name, export_paths | {
		"ram_include_paths" : ram_include_paths,
		"segment_include_paths" : segment_include_paths}
