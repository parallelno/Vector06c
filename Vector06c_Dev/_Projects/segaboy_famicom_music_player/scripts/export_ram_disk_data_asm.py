import os
import json
import common
import build

def get_unpack_priority(dictionary):
	if 'unpack_priority' in dictionary:
		return dictionary['unpack_priority']
	return 0
 
# generate and save ram_disk_data.asm
def export(source_j, generated_code_dir, generated_bin_dir, segments_paths):

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

	# collect all chunks
	chunks = []
	for bank_j in source_j["banks"]:
		bank_id = int(bank_j["bank_id"])
		for segment_j in bank_j["segments"]:
			for chunk_id, chunk_j in enumerate(segment_j["chunks"]):
				if "reserved" in chunk_j and chunk_j["reserved"]:
					continue

				chunk_j["bank_id"] = bank_id
				chunk_j["segment_addr_s"] = segment_j["addr"]
				chunk_j["chunk_id"] = chunk_id
				chunk_j["preshift"] = False
				chunk_j["assets_names"] = []
				# mark a chunk as it needs a special unpacking + preshifting
				for asset in chunk_j["assets"]:
					if asset["asset_type"] == build.ASSET_TYPE_SPRITE:
						chunk_j["preshift"] = True

					path = asset["path"]
					name = common.path_to_basename(path)
					chunk_j["assets_names"].append(name)
				chunks.append(chunk_j)

	# sort chunks by the unpack priority
	sorted_chunks = sorted(chunks, key=get_unpack_priority)
	
	total_data_compressed = 0
	# print it in the unpacking order
	asm += "ram_disk_data: ; the addr of this label has to be < BUFFERS_START_ADDR\n"
	for chunk_j in sorted_chunks:
		bank_id = chunk_j["bank_id"]
		addr_s = chunk_j["segment_addr_s"]
		chunk_id = chunk_j["chunk_id"]
		addr_s_wo_hex_sym = common.get_addr_wo_prefix(addr_s)
		chunk_name = build.get_chunk_name(bank_id, addr_s_wo_hex_sym, chunk_id)
		chunk_path = generated_bin_dir + chunk_name + build.EXT_BIN_ZX0
		asm += f"{chunk_name}:\n"
		asm += f'.incbin "{common.double_slashes(chunk_path)}"\n'

		segment_compressed_size = os.path.getsize(chunk_path)
		total_data_compressed += segment_compressed_size
				
	asm += "\n"

	asm += "; ram-disk data layout\n"
	total_free_space = 0
	total_data_space = 0
	for bank_j in source_j["banks"]:
		bank_id = int(bank_j["bank_id"])
		for segment_j in bank_j["segments"]:

			addr_s = segment_j["addr"]
			addr_s_wo_hex_sym = common.get_addr_wo_prefix(addr_s)
			segment_addr = build.get_segment_addr(addr_s_wo_hex_sym)

			description = segment_j.get("description", "")

			segment_name = build.get_segment_name(bank_id, addr_s_wo_hex_sym)

			if len(segment_j["chunks"]) > 0:
				segment_path = segments_paths[segment_name]["segment_bin_path"]
				segment_size = os.path.getsize(segment_path)
			else:
				segment_size = 0

			labels_path = segments_paths[segment_name]["labels_path"]

			if len(segments_paths[segment_name]["segment_include_paths"]) > 0:
				assets_s = ""
				for path in segments_paths[segment_name]["segment_include_paths"]:
					ext = os.path.splitext(path)[1]
					asset_name = common.path_to_basename(path)

					label_start = common.get_label_addr(labels_path, "__" + asset_name + "_rd_data_start")
					label_end = common.get_label_addr(labels_path, "__" + asset_name + "_rd_data_end")
					asset_size = label_end - label_start
						
					assets_s += f"{asset_name} [{asset_size}], "
					total_data_space += asset_size
			else:
				assets_s = ["empty"]
			
			# calc total_free_space
			segment_size_max = build.get_segment_size_max(segment_addr)
			# reserved size
			reserved_size = 0
			for chunk_j in segment_j["chunks"]:
				if "reserved" in chunk_j and chunk_j["reserved"]:
					reserved_size += common.hex_str_to_int(chunk_j["len"])

			free_space = segment_size_max - segment_size - reserved_size
			if free_space < 0:
				print(f'export_ram_disk_data_asm ERROR: free_space < 0, segment_name: "{segment_name}", paths: {segments_paths[segment_name]}')
				print("stop export")
				exit(1)

			total_free_space += free_space
			
			# aggregate all the segment descriptions
			for chunk_j in segment_j["chunks"]:
				if "description" in chunk_j:
					description += chunk_j["description"] + " "

			segment_free_space_s_aligned = common.align_string(f"{free_space}", 5, True)
			addr_s_aligned = common.align_string(addr_s_wo_hex_sym, 4)
			asm += f"; bank{bank_id} addr{addr_s_aligned} [{segment_free_space_s_aligned} free] description: {description}\n"
			if len(assets_s) > 0:
				asm += ";                             " + assets_s + "\n"

			if bank_id == 2:
				a = 1

	asm += f"; [{total_data_space} total/{total_data_compressed} compressed][{total_free_space} total free]\n\n"
	asm += '.if BUFFERS_START_ADDR < ram_disk_data\n' \
			'			.error "the programm is too big. It overlaps with tables at the end of RAM"\n' \
			'.endif\n'

	# save ram_disk_data.asm
	path = f"{generated_code_dir}ram_disk_data{build.EXT_ASM}"
	with open(path, "w") as file:
		file.write(asm)