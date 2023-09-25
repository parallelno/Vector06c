import os
import json
import common
import build

def get_unpack_priority(dictionary):
	if 'unpack_priority' in dictionary:
		return dictionary['unpack_priority']
	return 0

# make ram_disk_init.asm
def export(source_j, source_j_path, generated_code_dir, segments_info):
	
	bank_id_backbuffer, bank_id_backbuffer2 = build.find_backbuffers_bank_ids(source_j, source_j_path)

	# sort segments by the unpack priority
	segs_sorted = sorted(segments_info, key=lambda dictionary: dictionary.get('unpack_priority', 0), reverse=True)


	asm = ""
	asm += "ram_disk_init:\n"
	asm += "			;call clear_ram_disk\n"
	
	# unpack segments in a unpack_priority order
	for seg in segs_sorted:
		for chunk_id, chunk in enumerate(seg['chunks']):
			bank_id = seg["bank_id"]
			addr_s = seg["addr_s"]
			seg_id = seg["seg_id"]

			chunk_name = build.get_chunk_name(bank_id, addr_s, chunk_id)
			segment_addr = seg["addr"]

			asm += "	;===============================================\n"
			asm +=f"	;		bank_id {bank_id}, addr ${addr_s}, chunk_id {chunk_id}\n"
			asm += "	;===============================================\n"
			
			assets_names = []
			for asset in chunk["assets"]:
				assets_names.append(asset['name'])

			asm += f"			; {assets_names}\n"

			chunk_label_start = chunk["label_start"]
			chunk_label_end = chunk["label_end"]
			chunk_len_s = f"{chunk_label_end} - {chunk_label_start}"
 
			if seg["preshift_required"]:
				
				asm +=f"			; unpack the chunk into the ram-disk back buffer\n"
				asm +=f"			lxi d, {chunk_name}\n"
				asm += "			lxi b, BACK_BUFF_ADDR\n"
				asm +=f"			mvi a, __RAM_DISK_M_BACKBUFF | RAM_DISK_M_8F\n"
				asm += "			call dzx0_rd\n"		
				asm +="\n"

				for asset in chunk["assets"]:
					seg_asset_idx = asset["seg_asset_idx"]
					seg_asset = source_j["banks"][bank_id]["segments"][seg_id]["assets"][seg_asset_idx]
					if seg_asset["asset_type"] == build.ASSET_TYPE_SPRITE:
						path = seg_asset["path"]
						name = common.path_to_basename(path)
						asset_name = asset['name']
						asset_j = common.load_json(path)
					
						if ("preshifted_sprites" in asset_j and
							(asset_j["preshifted_sprites"] == 4 or asset_j["preshifted_sprites"] == 8)):

							asm +=f"			; preshift {asset_name}\n"
							asm +=f"			RAM_DISK_ON_NO_RESTORE(__RAM_DISK_M_BACKBUFF | RAM_DISK_M_8F)\n"
							asm +=f"			lxi d, {name}_preshifted_sprites\n"
							asm +=f"			LXI_H_TO_DIFF(SCR_BUFF1_ADDR - {chunk_label_start})\n"
							asm +=f"			call __sprite_dup_preshift\n"
							asm +=f"			RAM_DISK_OFF_NO_RESTORE()\n"
							asm +="\n"

				asm +=f"			; copy the chunk into the ram-disk\n" 
				asm +=f"			lxi d, BACK_BUFF_ADDR + ({chunk_len_s})\n"
				asm +=f"			lxi h, {chunk_label_end}\n"
				asm +=f"			lxi b, ({chunk_len_s}) / 2\n"
				asm +=f"			mvi a, RAM_DISK_S{bank_id} | __RAM_DISK_M_BACKBUFF | RAM_DISK_M_8F\n"
				asm +=f"			call copy_to_ram_disk\n"
				asm +="\n"

			elif segment_addr == build.SEGMENT_0000_7F00_ADDR:

				asm +=f"			; unpack the chunk into the ram-disk backbuffer2\n"
				asm +=f"			lxi d, {chunk_name}\n"
				asm +=f"			lxi b, BACK_BUFF_ADDR\n"
				asm +=f"			mvi a, __RAM_DISK_M_BACKBUFF | RAM_DISK_M_8F\n"
				asm += "			call dzx0_rd\n"
				asm +="\n"

				asm +=f"			; copy the chunk to the ram-disk\n"
				asm +=f"			lxi d, BACK_BUFF_ADDR + ({chunk_len_s})\n"
				asm +=f"			lxi h, {chunk_label_end}\n"
				asm +=f"			lxi b, ({chunk_len_s}) / 2\n"
				asm +=f"			mvi a, RAM_DISK_S{bank_id} | __RAM_DISK_M_BACKBUFF | RAM_DISK_M_8F\n"
				asm +=f"			call copy_to_ram_disk\n"
				asm +="\n"

			elif segment_addr == build.SEGMENT_8000_0000_ADDR:
				asm +=f"			; unpack the chunk into the ram-disk\n"
				asm +=f"			lxi d, {chunk_name}\n"
				asm +=f"			lxi b, {chunk_label_start}\n"
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