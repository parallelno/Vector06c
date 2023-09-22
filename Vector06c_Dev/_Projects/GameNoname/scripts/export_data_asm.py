import os
import json
import common
import build

def export(source_j, source_j_path, generated_code_dir, generated_bin_dir, segments_info):
	
	# generate and save ram_disk_data_labels.asm
	asm = "; ram-disk data labels\n"

	for seg_info in segments_info:
		labels_path = seg_info["labels_path"]
		asm += f'.include "{common.double_slashes(labels_path)}"\n'
	asm += "\n"

	# save ram_disk_data_labels.asm
	path = f"{generated_code_dir}ram_disk_data_labels{build.EXT_ASM}"
	with open(path, "w") as file:
		file.write(asm)



	# generate and save ram_data.asm
	asm = ""
	'''
	bank_id_backbuffer, bank_id_backbuffer2 = build.find_backbuffers_bank_ids(source_j, source_j_path)	
	asm += f'__RAM_DISK_S_BACKBUFF = RAM_DISK_S{bank_id_backbuffer}\n'
	asm += f'__RAM_DISK_M_BACKBUFF = RAM_DISK_M{bank_id_backbuffer}\n'
	asm += f'__RAM_DISK_S_BACKBUFF2 = RAM_DISK_S{bank_id_backbuffer2}\n'
	asm += f'__RAM_DISK_M_BACKBUFF2 = RAM_DISK_M{bank_id_backbuffer2}\n'
	asm +="\n"
'''
	asm += "; ram_data:\n"
	for seg_info in segments_info:
		ram_data_paths = seg_info["ram_include_paths"]
		for ram_data_path in ram_data_paths:
			if len(ram_data_path) != 0:
				asm += f'.include "{common.double_slashes(ram_data_path)}"\n'
	asm += "\n" 
 
	# save ram_data.asm
	path = f"{generated_code_dir}ram_data{build.EXT_ASM}"
	with open(path, "w") as file:
		file.write(asm)

	# generate and save ram_disk_data.asm
	asm = ""
	''' temporaly excluded
	# add required includes
	for include in source_j["includes"]["data_init"]:
		asm += f'.include "{common.double_slashes(include)}"\n'
	asm += "\n"
	'''
	# sort segments by the unpack priority
	segs_sorted = sorted(segments_info, key=lambda dictionary: dictionary.get('unpack_priority', 0))

	asm += "ram_disk_data:\n"
	for seg_info in segs_sorted:
		for chunk_id, chunk in enumerate(seg_info['chunks']):
			chunk_name = build.get_chunk_name(seg_info["bank_id"], seg_info["addr_s"], chunk_id)
			chunk_path = generated_bin_dir + chunk_name + build.packer_bin_ext
			asm += f"{chunk_name}:\n"
			asm += f'.incbin "{common.double_slashes(chunk_path)}"\n'

	asm += "\n"

	# print ram-disk data layout
	asm += "; ram-disk data layout\n"
	total_data_size = 0
	total_data_compressed = 0
	total_free_size = 0 

	for seg_info in segments_info:
		seg_size = 0
		assets_s = ""
		size_compressed = 0
		for chunk in seg_info['chunks']:
			seg_size += chunk['size']
			size_compressed += chunk['size_compressed']
			for asset_info in chunk['assets']:
				assets_s += f"{asset_info['name']} [{asset_info['size']}], "

		seg_free_size = seg_info["not_reserved_size"] - seg_size
		total_data_size += seg_size

		segment_free_space_s_aligned = common.align_string(f"{seg_free_size}", 5, True)
		addr_s_aligned = common.align_string(seg_info['addr_s'], 4)
		asm += f"; bank{seg_info['bank_id']} addr{addr_s_aligned} [{segment_free_space_s_aligned} free] description: {seg_info['description']}\n"
		
		if len(assets_s) == 0:
			assets_s = ["empty"]
		asm += ";                             " + assets_s + "\n"

		total_free_size += seg_free_size
		total_data_compressed += size_compressed

	asm += f"; [{total_data_size} total/{total_data_compressed} compressed][{total_free_size} total free]\n\n"

	# save ram_disk_data.asm
	path = f"{generated_code_dir}ram_disk_data{build.EXT_ASM}"
	with open(path, "w") as file:
		file.write(asm)