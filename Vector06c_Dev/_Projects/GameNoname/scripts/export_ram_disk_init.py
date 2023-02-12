import os
import json
import common
import build

def sort_chunk_by_unpack_priority(dictionary):
	if 'unpack_priority' in dictionary:
		return dictionary['unpack_priority']
	return 0

# make ram_disk_init.asm
def export(source_j, generated_code_dir, segments_paths, 
		bank_id_backbuffer, bank_id_backbuffer2):
	
	# collect all chunks
	chunks = []
	for bank_j in source_j["banks"]:
		bank_id = int(bank_j["bank_id"])
		for segment_j in bank_j["segments"]:
			if "reserved" in segment_j and segment_j["reserved"]:
				continue

			for chunk_id, chunk_j in enumerate(segment_j["chunks"]):
				chunk_j["bank_id"] = bank_id
				chunk_j["segment_addr_s"] = segment_j["addr"]
				chunk_j["chunk_id"] = chunk_id
				chunk_j["preshift"] = False
				chunk_j["assets_names"] = []
				for asset in chunk_j["assets"]:
					if asset["asset_type"] == build.ASSET_TYPE_SPRITE:
						chunk_j["preshift"] = True

					path = asset["path"]
					name = common.path_to_basename(path)
					chunk_j["assets_names"].append(name)
				chunks.append(chunk_j)

	# sort chunks by the unpack priority
	sorted_chunks = sorted(chunks, key=sort_chunk_by_unpack_priority, reverse=True)

	asm = ""
	asm += f'__RAM_DISK_S_BACKBUFF = RAM_DISK_S{bank_id_backbuffer}\n'
	asm += f'__RAM_DISK_M_BACKBUFF = RAM_DISK_M{bank_id_backbuffer}\n'
	asm += f'__RAM_DISK_S_BACKBUFF2 = RAM_DISK_S{bank_id_backbuffer2}\n'
	asm += f'__RAM_DISK_M_BACKBUFF2 = RAM_DISK_M{bank_id_backbuffer2}\n'
	asm +="\n"

	asm += "ram_disk_init:\n"
	asm += "			;call clear_ram_disk\n"
	
	# unpack segments in a unpack_priority order
	for chunk_j in sorted_chunks:
		bank_id = chunk_j["bank_id"]
		addr_s = chunk_j["segment_addr_s"]
		chunk_id = chunk_j["chunk_id"]
		addr_s_wo_hex_sym = common.get_addr_wo_prefix(addr_s)
		chunk_name = build.get_chunk_name(bank_id, addr_s_wo_hex_sym, chunk_id)
		segment_addr = build.get_segment_addr(addr_s)

		asm += "	;===============================================\n"
		asm +=f"	;		bank_id {bank_id}, addr {addr_s}, chunk_id {chunk_id}\n"
		asm += "	;===============================================\n"
		assets_names = chunk_j["assets_names"]
		asm += f"			; {assets_names}\n"

		chunk_start_addr_s = build.get_chunk_start_label_name(bank_id, addr_s_wo_hex_sym, chunk_id)
		chunk_end_addr_s = build.get_chunk_end_label_name(bank_id, addr_s_wo_hex_sym, chunk_id)
		chunk_len_s = f"{chunk_end_addr_s} - {chunk_start_addr_s}"

		if chunk_j["preshift"]:
			
			asm +=f"			; unpack the chunk into the ram-disk back buffer\n"
			asm +=f"			lxi d, {chunk_name}\n"
			asm += "			lxi b, BACK_BUFF_ADDR\n"
			asm +=f"			mvi a, __RAM_DISK_M_BACKBUFF | RAM_DISK_M_8F\n"
			asm += "			call dzx0_rd\n"		
			asm +="\n"

			for asset in chunk_j["assets"]:
				path = asset["path"]
				asset_name = common.path_to_basename(path)

				asm +=f"			; preshift {asset_name} sprites\n"
				asm +=f"			RAM_DISK_ON(__RAM_DISK_M_BACKBUFF | RAM_DISK_M_8F)\n"
				asm +=f"			lxi d, {asset_name}_preshifted_sprites\n"
				asm +=f"			lxi h, SCR_BUFF1_ADDR - {chunk_start_addr_s}\n"
				asm +=f"			call __sprite_dup_preshift\n"
				asm +=f"			RAM_DISK_OFF()\n"
				asm +="\n"

			asm +=f"			; copy the chunk into the ram-disk\n"
			asm +=f"			lxi d, BACK_BUFF_ADDR + ({chunk_len_s})\n"
			asm +=f"			lxi h, {chunk_end_addr_s}\n"
			asm +=f"			lxi b, ({chunk_len_s}) / 2\n"
			asm +=f"			mvi a, RAM_DISK_S{bank_id} | __RAM_DISK_M_BACKBUFF | RAM_DISK_M_8F\n"
			asm +=f"			call copy_to_ram_disk\n"
			asm +="\n"

		elif segment_addr == build.SEGMENT_0000_7F00_ADDR:

			asm +=f"			; unpack the chunk into the ram-disk backbuffer2\n"
			asm +=f"			lxi d, {chunk_name}\n"
			asm +=f"			lxi b, BACK_BUFF2_ADDR\n"
			asm +=f"			mvi a, __RAM_DISK_M_BACKBUFF2 | RAM_DISK_M_8F\n"
			asm += "			call dzx0_rd\n"
			asm +="\n"

			asm +=f"			; copy the chunk to the ram-disk\n"
			asm +=f"			lxi d, BACK_BUFF2_ADDR + ({chunk_len_s})\n"
			asm +=f"			lxi h, {chunk_end_addr_s}\n"
			asm +=f"			lxi b, ({chunk_len_s}) / 2\n"
			asm +=f"			mvi a, RAM_DISK_S{bank_id} | __RAM_DISK_M_BACKBUFF2 | RAM_DISK_M_8F\n"
			asm +=f"			call copy_to_ram_disk\n"
			asm +="\n"

		elif segment_addr == build.SEGMENT_8000_0000_ADDR:
			asm +=f"			; unpack the chunk into the ram-disk\n"
			asm +=f"			lxi d, {chunk_name}\n"
			asm +=f"			lxi b, {chunk_start_addr_s}\n"
			asm +=f"			mvi a, RAM_DISK_M{bank_id} | RAM_DISK_M_8F\n"
			asm += "			call dzx0_rd\n"
			asm +="\n"
		else:
			print(f"export_ram_disk_init ERROR: chunk format is not supported. chunk_name: {chunk_name}\n")
			exit(1)

	asm += "			ret\n"

	# save ram_disk_init.asm
	path = f"{generated_code_dir}ram_disk_init{build.EXT_ASM}"
	with open(path, "w") as file:
		file.write(asm)