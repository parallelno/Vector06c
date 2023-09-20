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
import copy

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
 
def export_chunks(segment_path, segment_labels_path):

	with open(segment_labels_path, "rb") as file:
		labels = file.readlines()

	chunks = []
	chunk_template = {
		#"addr_offset" : 0,
		"label_start" : "",
		"label_end" : "",
		"size" : 0,
		"size_compressed" : 0,
		"path_compressed" : "",
		"assets" : [
			#{
			#	"name" : "",
			#	"size" : 0,
			#	"addr_start" : 0,
			#	"addr_end" : 0,
			#	"label_start" : "",
			#	"label_end" : "",			
			#	"seg_asset_idx" : 0 ; an asset index in the segment
			#}
		]
	}
	chunk = copy.deepcopy(chunk_template)
	chunks.append(chunk)
	# collect chunks info
	seg_asset_idx = 0
	for line_a in labels:
		line = line_a.decode('ascii').lower()
		 
		if line.find(build.LABEL_POSTFIX_ASSET_START) != -1:
			label_start = line[:line.find(" "):]
			asset_addr_start_s = line[line.find("$")+1:]
			asset_addr_start = int(asset_addr_start_s, 16)
		
		if line.find(build.LABEL_POSTFIX_ASSET_END) != -1:

			label_end = line[:line.find(" ")]
			asset_addr_end_s = line[line.find("$")+1:]

			asset = {}
			asset["addr_start"] = asset_addr_start
			asset["addr_end"] = int(asset_addr_end_s, 16)
			asset["size"] = asset["addr_end"] - asset["addr_start"]
			asset["label_start"] = label_start
			asset["label_end"] = label_end
			asset["name"] = line[2 : line.find("_rd_data_end")]
			asset["seg_asset_idx"] = seg_asset_idx
			seg_asset_idx += 1
	
			if chunk["size"] + asset["size"] > build.CHUNK_SIZE_MAX:
				chunk = copy.deepcopy(chunk_template)
				#chunk["addr_offset"] = chunks[-1]["size"]
				chunks.append(chunk)

			chunk["size"] += asset["size"]
			chunk["assets"].append(asset)
			chunk["label_end"] = chunk["assets"][-1]["label_end"]
			if chunk["label_start"] == "":
				chunk["label_start"] = label_start			

	# split up a segment into chunks
	with open(segment_path, "rb") as file:
		for i, chunk in enumerate(chunks):
 
			# split a chunk
			data = file.read(chunk["size"])
			chunk_dir = os.path.dirname(segment_path) + "\\"
			segment_basename = common.path_to_basename(segment_path)
			segment_idx = segment_basename.find("_")
			chunk_name = "chunk" + segment_basename[segment_idx:]
			chunk_path = chunk_dir + chunk_name + "_" + str(i) + build.EXT_BIN

			with open(chunk_path, "wb") as fw:
				fw.write(data)

			# pack a chunk
			zx0_chunk_path = chunk_path + build.packer_ext

			common.delete_file(zx0_chunk_path)
			common.run_command(f"{build.packer_path} {chunk_path} {zx0_chunk_path}")

			chunk["path_compressed"] = zx0_chunk_path
			chunk["size_compressed"] = os.path.getsize(zx0_chunk_path)

	return chunks

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

		chunks = export_chunks(segment_bin_path, labels_path)

		print(f"segment: {source_name} got exported.")

		return True, export_paths | {"chunks" : chunks}
	else:
		return False, export_paths | {"chunks" : []}

#=========================================================================================
def export(bank_id, seg_id, segment_j, includes,
			force_export, asset_types_force_export, generated_code_dir, generated_bin_dir):
 
	seg_addr = segment_j["seg_addr"]
	if seg_addr == "SEGMENT_0000_7F00_ADDR":
		addr = build.SEGMENT_0000_7F00_ADDR
	else:
		addr = build.SEGMENT_8000_0000_ADDR

	addr_s = hex(addr)[2:]

	asm = f'.org ${addr_s}\n'
	for include in includes:
		asm += f'.include "{common.double_slashes(include)}"\n'

	asm += f'RAM_DISK_S = RAM_DISK_S{bank_id}\n'
	asm += f'RAM_DISK_M = RAM_DISK_M{bank_id}\n\n'

	segment_force_export = force_export
	ram_include_paths = []		# data to be accessed in the main ram
	segment_include_paths = []	# data to be accessed in the ram-disk

	not_reserved_size = build.get_segment_size_max(addr)

	if 'description' in segment_j:
		description = segment_j['description'] + " "
	else:
		description = ''

	unpack_priority = segment_j.get('unpack_priority', 0)
	preshift_required = False

	# export the segment data
	for asset_j in segment_j["assets"]:

		if 'description' in asset_j:
			description += f"{asset_j['description']} "

		if 'reserved' in asset_j and asset_j['reserved']:
			not_reserved_size -= int(asset_j['size'][1:], 16)

		segment_include_path = ""

		if asset_j["asset_type"] == build.ASSET_TYPE_SPRITE:
			exported, export_paths = export_sprite.export_if_updated(asset_j["path"], asset_j["export_dir"], asset_types_force_export["sprite"])
			segment_force_export |= exported
			ram_include_paths.append(export_paths["ram"])
			segment_include_path = export_paths["ram_disk"]
			preshift_required = True

		elif asset_j["asset_type"] == build.ASSET_TYPE_BACK:
			exported, export_paths = export_back.export_if_updated(asset_j["path"], asset_j["export_dir"], asset_types_force_export["back"])
			segment_force_export |= exported
			ram_include_paths.append(export_paths["ram"])
			segment_include_path = export_paths["ram_disk"]
		
		elif asset_j["asset_type"] == build.ASSET_TYPE_FONT or asset_j["asset_type"] == build.ASSET_TYPE_FONT_RD:
			font_gfx_ptrs_rd = False
			if asset_j["asset_type"] == build.ASSET_TYPE_FONT_RD:
				font_gfx_ptrs_rd = True
			exported, export_paths = export_font.export_if_updated(asset_j["path"], asset_j["export_dir"], asset_types_force_export["font"], font_gfx_ptrs_rd)
			segment_force_export |= exported
			if asset_j["asset_type"] == build.ASSET_TYPE_FONT:
				ram_include_paths.append(export_paths["ram"])
			segment_include_path = export_paths["ram_disk"]

		elif asset_j["asset_type"] == build.ASSET_TYPE_IMAGE:
			exported, export_paths = export_image.export_if_updated(asset_j["path"], asset_j["export_dir"], asset_types_force_export["image"])
			segment_force_export |= exported
			segment_include_path = export_paths["ram_disk"]

		elif asset_j["asset_type"] == build.ASSET_TYPE_DECAL:
			exported, export_paths = export_decal.export_if_updated(asset_j["path"], asset_j["export_dir"], asset_types_force_export["decal"])
			segment_force_export |= exported
			segment_include_path = export_paths["ram_disk"]

		elif asset_j["asset_type"] == build.ASSET_TYPE_LEVEL_DATA:
			exported, export_paths = export_level.export_data_if_updated(asset_j["path"], asset_j["export_dir"], asset_types_force_export["level_data"])
			segment_force_export |= exported
			segment_include_path = export_paths["ram_disk"]

		elif asset_j["asset_type"] == build.ASSET_TYPE_LEVEL_GFX:
			exported, export_paths = export_level.export_gfx_if_updated(asset_j["path"], asset_j["export_dir"], asset_types_force_export["level_gfx"])
			segment_force_export |= exported
			segment_include_path = export_paths["ram_disk"]

		elif asset_j["asset_type"] == build.ASSET_TYPE_TILED_IMG_GFX:
			exported, export_paths = export_tiled_img.export_gfx_if_updated(asset_j["path"], asset_j["export_dir"], asset_types_force_export["tiled_img_gfx"])
			segment_force_export |= exported
			segment_include_path = export_paths["ram_disk"]

		elif asset_j["asset_type"] == build.ASSET_TYPE_TILED_IMG_DATA:
			exported, export_paths = export_tiled_img.export_data_if_updated(asset_j["path"], asset_j["export_dir"], asset_types_force_export["tiled_img_data"])
			segment_force_export |= exported
			segment_include_path = export_paths["ram_disk"]

		elif asset_j["asset_type"] == build.ASSET_TYPE_MUSIC:
			exported, export_paths = export_music.export_if_updated(asset_j["path"], asset_j["export_dir"], asset_types_force_export["music"])
			segment_force_export |= exported
			segment_include_path = export_paths["ram_disk"]

		elif asset_j["asset_type"] == build.ASSET_TYPE_CODE:
			segment_include_path = asset_j["path"]
			segment_force_export |= build.is_asm_updated(segment_include_path)

		if segment_include_path == "":
			continue

		# to calc the asset size later on
		asm += f'__{common.path_to_basename(segment_include_path)}{build.LABEL_POSTFIX_ASSET_START}:\n'
		asm += f'.include "{common.double_slashes(segment_include_path)}"\n'
		if segment_include_path.find("consts") == -1:
			asm += f'.align 2\n'
		
		asm += f'__{common.path_to_basename(segment_include_path)}{build.LABEL_POSTFIX_ASSET_END}:\n'

		segment_include_paths.append(segment_include_path)

	seg_name = build.get_segment_name(bank_id, addr_s)
	seg_path = generated_code_dir + seg_name + build.EXT_ASM

	# save a segment data file
	if (segment_force_export):
		if not os.path.exists(generated_code_dir):
			os.mkdir(generated_code_dir)

		with open(seg_path, "w") as file:
			file.write(asm)

	exported, seg_info = compile_and_compress(seg_path, generated_bin_dir, addr, segment_force_export, True)

	return exported, seg_info | {
		"ram_include_paths" : ram_include_paths,
		"segment_include_paths" : segment_include_paths,
		"name" : seg_name,
		"bank_id" : bank_id,
		"addr_s" : addr_s,
		"addr" : addr,
		"not_reserved_size" : not_reserved_size,
		"description" : description,
		"unpack_priority" : unpack_priority,
		"preshift_required" : preshift_required,
		"seg_id" : seg_id}
