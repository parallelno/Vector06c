import os
import json
import common
import build

def export(source_j, generated_code_dir, segments_paths, 
		bankBackBuffer, backBufferSize,
		force_export):
	# generate and save ram_disk_data.asm

	asm = "; ram-disk data labels\n"

	for name in segments_paths:
		labels_path = segments_paths[name]["labels_path"]
		asm += f'.include "{common.double_slashes(labels_path)}"\n'
	asm += "\n"

	asm += "; main-ram data (sprite anims, etc.)\n"
	for name in segments_paths:
		ram_data_paths = segments_paths[name]["ram_include_paths"]
		for ram_data_path in ram_data_paths:
			if len(ram_data_path) != 0:
				asm += f'.include "{common.double_slashes(ram_data_path)}"\n'
	asm += "\n"

	asm += "; compressed ram-disk data. They will be unpacked in a reverse order.\n"
	for name in segments_paths:
		zx0_chunk_paths = segments_paths[name]["zx0_chunk_paths"]
		for zx0_chunk_path in zx0_chunk_paths:
			zx0_chunk_name = common.path_to_filename(zx0_chunk_path)
			asm += f"{zx0_chunk_name}:\n"
			asm += f'.incbin "{common.double_slashes(zx0_chunk_path)}"\n'
	asm += "\n"


	asm += "; ram-disk data layout\n"

	for bank_j in source_j["banks"]:
		bank_id = int(bank_j["bank_id"])
		for segment_j in bank_j["segments"]:

			addr_s = segment_j["addr"]
			addr_s_wo_hex_sym = common.get_addr_wo_prefix(addr_s)
			segment_addr = build.get_segment_addr(addr_s_wo_hex_sym)

			description = ""
			if "description" in segment_j:
				description = segment_j["description"]

			if segment_j["reserved"]:
				asm += f"; bank{bank_id} addr{addr_s_wo_hex_sym} [    0 free] //{description}\n"

			else:
				if bank_id == bankBackBuffer and segment_addr == build.SEGMENT_8000_0000_ADDR :
					segmentSizeMax = build.SCR_BUFF_SIZE * 4 - backBufferSize
				else:
					segmentSizeMax = build.get_segment_size_max(segment_addr)

				segment_name = build.get_segment_name(bank_id, addr_s_wo_hex_sym)

				if len(segment_j["chunks"]) > 0:
					segmentPath = segments_paths[segment_name]["bin_path"]
					segmentSize = os.path.getsize(segmentPath)
				else:
					segmentSize = 0

				labels_path = segments_paths[segment_name]["labels_path"]

				if len(segments_paths[segment_name]["segment_include_paths"]) > 0:
					assets_s = ""
					for path in segments_paths[segment_name]["segment_include_paths"]:
						ext = os.path.splitext(path)[1]
						asset_name = common.path_to_filename(path)

						label_start = common.get_label_addr(labels_path, "__" + asset_name + "_rd_data_start")
						label_end = common.get_label_addr(labels_path, "__" + asset_name + "_rd_data_end")
						asset_size = label_end - label_start

						if ext == build.EXT_ASM:
							asset_name += build.EXT_ASM
							
						assets_s += f";                             {asset_name}: {asset_size}\n"
				
				else:
					assets_s = "empty"
					
				description = "asset_name: size //" + description
				
				addr_s_aligned = common.align_string(addr_s_wo_hex_sym, 4)
				segment_free_space_s_aligned = common.align_string(f"{segmentSizeMax - segmentSize}", 5, True)

				asm += f"; bank{bank_id} addr{addr_s_aligned} [{segment_free_space_s_aligned} free] {description}\n"
				asm += assets_s + "\n"

	# save ram_disk_data.asm
	path = f"{generated_code_dir}ram_disk_data{build.EXT_ASM}"
	with open(path, "w") as file:
		file.write(asm)