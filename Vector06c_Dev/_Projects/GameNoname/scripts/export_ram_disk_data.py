import os
import json
import common
import build
import export_segment
import export_ram_disk_data_asm

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

	sprite_force_export = global_force_export | build.is_file_updated(dependencyPathsJ["sprite"])
	back_force_export = global_force_export | build.is_file_updated(dependencyPathsJ["back"])
	level_force_export = global_force_export | build.is_file_updated(dependencyPathsJ["level"])
	music_force_export = global_force_export | build.is_file_updated(dependencyPathsJ["music"])

	generated_code_dir = source_j["dirs"]["generated_code"]
	generated_bin_dir = source_j["dirs"]["generated_bin"]

	segments_paths = {}
	ram_disk_data_asm_force_export = False

	# export all the banks data into bin files, then zip them, then split them into chunks
	for bank_j in source_j["banks"]:
		bank_id = int(bank_j["bank_id"])
		for segment_j in bank_j["segments"]:
			if segment_j["reserved"]:
				continue

			chunksCount = len(segment_j["chunks"])
			if chunksCount == 0:
				continue

			exported, segment_name, segment_paths = export_segment.export(
				bank_id, segment_j,
				sprite_force_export, back_force_export, level_force_export, music_force_export,
				generated_code_dir, generated_bin_dir)

			ram_disk_data_asm_force_export |= exported
			segments_paths[segment_name] = segment_paths

	bankBackBuffer = source_j["bankBackBuffer"]
	bankBackBuffer2 = source_j["bankBackBuffer2"]
	backBufferSize = source_j["backBufferSize"]

	# generate ram_disk_data.asm. it includes all ram-disk data
	export_ram_disk_data_asm.export(source_j, generated_code_dir, segments_paths, 
									bankBackBuffer, backBufferSize, global_force_export )
'''
	
	# make ramDiskInit.asm
	ram_disk_init_asm = ""
	ram_disk_init_asm += f'__RAM_DISK_S_BACKBUFF = RAM_DISK_S{bankBackBuffer}\n'
	ram_disk_init_asm += f'__RAM_DISK_M_BACKBUFF = RAM_DISK_M{bankBackBuffer}\n'
	ram_disk_init_asm += f'__RAM_DISK_S_BACKBUFF2 = RAM_DISK_S{bankBackBuffer2}\n'
	ram_disk_init_asm += f'__RAM_DISK_M_BACKBUFF2 = RAM_DISK_M{bankBackBuffer2}\n\n'

	ram_disk_init_asm += "ram_disk_init:\n"
	ram_disk_init_asm += "			;call clear_ram_disk\n"
	# unpack segments in a reverse order of banks listed in ram_disk_data.json
	for bank_j in reversed(source_j["banks"]):
		bank_id = int(bank_j["bank_id"])
		for segment_j in reversed(bank_j["segments"]):
			name = segment_j["name"]
			if segment_j["name"] == SEGMENT_RESERVED:
				continue
			if len(segment_j["chunks"]) == 0:
				continue

			addr_s = segment_j["addr"]
			addr_s_wo_hex_sym, segment_addr = common.get_addr_wo_prefix(addr_s)

			ramDiskSegmentFileName = get_segment_name(bank_id, addr_s_wo_hex_sym)
			ram_disk_init_asm += "	;===============================================\n"
			ram_disk_init_asm +=f"	;		{name}, bank_id {bank_id}, addr {addr_s}\n"
			ram_disk_init_asm += "	;===============================================\n"

			if name == "sprites":
				chunkLen = len(segment_j["chunks"])
				for chunk, chunk_j in enumerate(segment_j["chunks"]):
					assetNames = []
					for asset in chunk_j:
						path = asset["path"]
						pathWOExt = os.path.splitext(path)[0]
						asset_name = os.path.basename(pathWOExt)
						assetNames.append(asset_name)

					ramDiskChunkFileName = ramDiskSegmentFileName
					if chunkLen > 1:
						ramDiskChunkFileName += f"_{chunk}"

					ram_disk_init_asm +=f"			; unpack chunk {chunk} {assetNames} sprites into the ram-disk back buffer\n"
					ram_disk_init_asm +=f"			lxi d, {ramDiskChunkFileName}\n"
					ram_disk_init_asm += "			lxi b, SCR_BUFF1_ADDR\n"
					ram_disk_init_asm +=f"			mvi a, __RAM_DISK_M_BACKBUFF | RAM_DISK_M_8F\n"
					ram_disk_init_asm += "			call dzx0RD\n\n"

					chunkStartAddrS = get_chunk_start_label_name(bank_id, addr_s_wo_hex_sym)
					chunkEndAddrS = chunk_end_label_name(bank_id, addr_s_wo_hex_sym)
					chunkOffsetS = ""
					if chunk > 0:
						chunkOffsetS = f" - {chunkEndAddrS}{chunk-1}"
						chunkLenS = f"{chunkEndAddrS}{chunk} - {chunkEndAddrS}{chunk-1}"
					else:
						chunkLenS = f"{chunkEndAddrS}{chunk} - {chunkStartAddrS}{chunk}"


					for asset in chunk_j:
						path = asset["path"]
						pathWOExt = os.path.splitext(path)[0]
						asset_name = os.path.basename(pathWOExt)

						ram_disk_init_asm +=f"			; preshift chunk {chunk} {asset_name} sprites\n"
						ram_disk_init_asm +=f"			RAM_DISK_ON(__RAM_DISK_M_BACKBUFF | RAM_DISK_M_8F)\n"
						ram_disk_init_asm +=f"			lxi d, {asset_name}_preshifted_sprites\n"
						ram_disk_init_asm +=f"			lxi h, SCR_BUFF1_ADDR{chunkOffsetS}\n"
						ram_disk_init_asm +=f"			call __SpriteDupPreshift\n"
						ram_disk_init_asm +=f"			RAM_DISK_OFF()\n\n"

					ram_disk_init_asm +=f"			; copy chunk {chunk} {assetNames} sprites to the ram-disk\n"
					ram_disk_init_asm +=f"			lxi d, SCR_BUFF1_ADDR + ({chunkLenS})\n"
					ram_disk_init_asm +=f"			lxi h, {chunkEndAddrS}{chunk}\n"
					ram_disk_init_asm +=f"			lxi b, ({chunkLenS}) / 2\n"
					ram_disk_init_asm +=f"			mvi a, RAM_DISK_S{bank_id} | __RAM_DISK_M_BACKBUFF | RAM_DISK_M_8F\n"
					ram_disk_init_asm +=f"			call copy_to_ram_disk\n\n"

			elif addr_s_wo_hex_sym == "0" or addr_s_wo_hex_sym == "0000":

				# supposed to have just one chunk
				chunkStartAddrS = get_chunk_start_label_name(bank_id, addr_s_wo_hex_sym)
				chunkEndAddrS = chunk_end_label_name(bank_id, addr_s_wo_hex_sym)

				chunkLenS = f"{chunkEndAddrS}0 - {chunkStartAddrS}0"

				ram_disk_init_asm +=f"			; unpack {name} into the ram-disk backbuffer2\n"
				ram_disk_init_asm +=f"			lxi d, {ramDiskSegmentFileName}\n"
				ram_disk_init_asm +=f"			lxi b, SCR_BUFF0_ADDR\n"
				ram_disk_init_asm +=f"			mvi a, __RAM_DISK_M_BACKBUFF2 | RAM_DISK_M_8F\n"
				ram_disk_init_asm += "			call dzx0RD\n\n"

				ram_disk_init_asm +=f"			; copy {name} to the ram-disk\n"
				ram_disk_init_asm +=f"			lxi d, SCR_BUFF0_ADDR + ({chunkLenS})\n"
				ram_disk_init_asm +=f"			lxi h, {chunkEndAddrS}0\n"
				ram_disk_init_asm +=f"			lxi b, ({chunkLenS}) / 2\n"
				ram_disk_init_asm +=f"			mvi a, RAM_DISK_S{bank_id} | __RAM_DISK_M_BACKBUFF2 | RAM_DISK_M_8F\n"
				ram_disk_init_asm +=f"			call copy_to_ram_disk\n\n"

			else:
				ram_disk_init_asm +=f"			; unpack {name} to the ram-disk\n"
				ram_disk_init_asm +=f"			lxi d, {ramDiskSegmentFileName}\n"
				ram_disk_init_asm +=f"			lxi b, {addr_s}\n"
				ram_disk_init_asm +=f"			mvi a, RAM_DISK_M{bank_id} | RAM_DISK_M_8F\n"
				ram_disk_init_asm += "			call dzx0RD\n\n"

	ram_disk_init_asm += "			ret\n"

	# save ram_disk_init.asm
	ram_disk_init_path = f"\\code\\ram_disk_init{build.EXT_ASM}"
	with open(generated_dir + ram_disk_init_path, "w") as file:
		file.write(ram_disk_init_asm)
'''

