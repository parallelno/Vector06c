import os
import json
import common
import build
import export_sprite
import export_back
import export_level
import export_music

def get_chunk_start_label_name(bank_id, addr_s_wo_hex_sym, chunk_n = -1):
	res = f'__chunk_start_bank{bank_id}_addr{addr_s_wo_hex_sym}_'
	if chunk_n == -1:
		return res
	return res + str(chunk_n)

def chunk_end_label_name(bank_id, addr_s_wo_hex_sym, chunk_n = -1):
	res = f'__chunk_end_bank{bank_id}_addr{addr_s_wo_hex_sym}_'
	if chunk_n == -1:
		return res
	return res + str(chunk_n)

def check_segment_size(path, segment_addr):
	if segment_addr != build.SEGMENT_0000_7F00_ADDR and segment_addr != build.SEGMENT_8000_0000_ADDR :
		print("ERROR: Segment start addr has to be " + hex(build.SEGMENT_0000_7F00_SIZE_MAX) + " or " + hex(build.SEGMENT_8000_0000_SIZE_MAX))
		print("Stop export")
		exit(1)

	segmentSize = os.path.getsize(path)
	segmentSizeMax = build.get_segment_size_max(segment_addr)

	if segmentSize > segmentSizeMax:
			print(f"ERROR: {path} is bigger than {segmentSizeMax} bytes")
			print("Stop export")
			exit(1)

def split_segment(segmentPath, segmentLabelsPath):
	with open(segmentLabelsPath, "rb") as file:
		labels = file.readlines()

	if len(labels) == 0:
		return []

	firstLine = labels[0].decode('ascii')
	firstLabelAddrStr = firstLine[firstLine.find("$")+1:]
	firstLabelAddr = int(firstLabelAddrStr, 16)

	splitAddrs = []
	for line_a in labels:
		line = line_a.decode('ascii').lower()
		if line.find("__chunk_end") != -1:
			splitAddrStr = line[line.find("$")+1:]
			splitAddr = int(splitAddrStr, 16) - firstLabelAddr
			splitAddrs.append(splitAddr)

	if len(splitAddrs) < 2:
		return []
	
	chunkExt = os.path.splitext(segmentPath)[1]
	segmentSize = os.path.getsize(segmentPath)
	splittedFiles = []

	with open(segmentPath, "rb") as file:
		for i, splitAddr in enumerate(splitAddrs):
			data = file.read(splitAddr)
			chunk_path = os.path.splitext(segmentPath)[0] + "_" + str(i) + chunkExt
			splittedFiles.append(chunk_path)
			with open(chunk_path, "wb") as fw:
				fw.write(data)
	return splittedFiles

def compile_and_compress(source_path, generated_bin_dir, segment_addr, force_export, externals_only):
	source_path_wo_ext = os.path.splitext(source_path)[0]
	source_name = common.path_to_filename(source_path)

	labels_path = f"{source_path_wo_ext}_labels{build.EXT_ASM}"
	bin_path = generated_bin_dir + source_name + build.EXT_BIN
	zx0_path = bin_path + build.EXT_ZX0

	export_paths = {
		"labels_path" : labels_path,
		"bin_path" : bin_path,
		"zx0_path" : zx0_path,
		"zx0_chunk_paths" : []
	}

	if force_export or build.is_asm_updated(source_path):
		common.run_command(f"..\\..\\retroassembler\\retroassembler.exe -x -C=8080 {source_path} "
				f" {bin_path} >{labels_path}")

		if not os.path.exists(bin_path):
			print(f'export_segment ERROR: compilation error, path: {source_path}')
			print("Stop export")
			exit(1)
			
		check_segment_size(bin_path, segment_addr)

		build.export_labels(labels_path, externals_only)

		chunk_paths = split_segment(bin_path, labels_path)

		if len(chunk_paths) == 0:
			common.delete_file(zx0_path)
			common.run_command(f"tools\\zx0salvador.exe -v -classic {bin_path} {zx0_path}")
			export_paths["zx0_chunk_paths"].append(zx0_path)
		else:
			for chunk_path in chunk_paths:
				chunk_path_wo_ext = os.path.splitext(chunk_path)[0] 
				zx0_chunk_path = chunk_path_wo_ext + build.EXT_BIN_ZX0

				common.delete_file(zx0_chunk_path)
				common.run_command(f"tools\\zx0salvador.exe -v -classic {chunk_path} {zx0_chunk_path}")
				export_paths["zx0_chunk_paths"].append(zx0_chunk_path)
		
		print(f"segment: {source_name} got exported.")	

		return True, export_paths
	else:
		return False, export_paths

#=========================================================================================
def export(bank_id, segment_j,
			sprite_force_export, back_force_export, level_force_export, music_force_export,
			generated_code_dir, generated_bin_dir):

	addr_s = segment_j["addr"]
	addr_s_wo_hex_sym = common.get_addr_wo_prefix(addr_s)
	asm = f'.org {addr_s}\n'
	asm += get_chunk_start_label_name(bank_id, addr_s_wo_hex_sym, 0) + ":\n\n"
	asm += '.include "asm\\\\globals\\\\global_consts.asm"\n'
	asm += '.include "asm\\\\globals\\\\macro.asm"\n'
	asm += f'RAM_DISK_S = RAM_DISK_S{bank_id}\n'
	asm += f'RAM_DISK_M = RAM_DISK_M{bank_id}\n\n'

	segment_force_export = False
	ram_include_paths = []
	segment_include_paths = []

	# export segment data
	for chunk_n, chunk_j in enumerate(segment_j["chunks"]):
		for asset in chunk_j:

			segment_include_path = ""

			if asset["asset_type"] == build.ASSET_TYPE_SPRITE:
				exported, export_paths = export_sprite.export_if_updated(asset["path"], asset["export_dir"], sprite_force_export)
				segment_force_export |= exported
				ram_include_paths.append(export_paths["ram"])
				segment_include_path = export_paths["ram_disk"]

			elif asset["asset_type"] == build.ASSET_TYPE_BACK:
				exported, export_paths = export_back.export_if_updated(asset["path"], asset["export_dir"], back_force_export)
				segment_force_export |= exported
				ram_include_paths.append(export_paths["ram"])
				segment_include_path = export_paths["ram_disk"]

			elif asset["asset_type"] == build.ASSET_TYPE_LEVEL:
				exported, export_paths = export_level.export_if_updated(asset["path"], asset["export_dir"], level_force_export)
				segment_force_export |= exported
				segment_include_path = export_paths["ram_disk"]

			elif asset["asset_type"] == build.ASSET_TYPE_MUSIC:
				exported, export_paths = export_music.export_if_updated(asset["path"], asset["export_dir"], music_force_export)
				segment_force_export |= exported
				segment_include_path = export_paths["ram_disk"]

			elif asset["asset_type"] == build.ASSET_TYPE_CODE:
				segment_include_path = asset["path"]
				segment_force_export |= True

			asm += f'__{common.path_to_filename(segment_include_path)}_rd_data_start:\n'
			asm += f'.include "{common.double_slashes(segment_include_path)}"\n'
			asm += f'__{common.path_to_filename(segment_include_path)}_rd_data_end:\n'

			segment_include_paths.append(segment_include_path)

		asm += f'\n.align 2\n'
		asm += chunk_end_label_name(bank_id, addr_s_wo_hex_sym, chunk_n) + ":\n\n"

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
		"path" : path, 
		"ram_include_paths" : ram_include_paths,
		"segment_include_paths" : segment_include_paths}
