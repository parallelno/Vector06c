import os
from pathlib import Path
from PIL import Image
import json
import common
import build
 
def gfx_to_asm(label_prefix, source_j, image):
	gfx_ptrs = {}
	gfx_j = source_j["gfx"]
	asm = label_prefix + "_gfx:"

	backgrount_color_pos = source_j.get("color_sample_pos", [0,0])
	backgrount_color_idx = image.getpixel((backgrount_color_pos[0], backgrount_color_pos[1]))
	spacing = source_j.get("spacing", 1)
	
	char_addr_offset = 0
	for char_j in gfx_j:
		char_name = char_j["name"]
		# every char gfx is 16 pxls width, there first 8 pixels are empty to support shifting
		WIDTH_MAX = 8
		x = char_j["x"]
		y = char_j["y"]
		offset_x = char_j.get("offset_x", 0)
		offset_y = char_j.get("offset_y", 0)
		width = char_j["width"]
		height = char_j["height"]

		# convert color indexes into a list of bits.
		bits = []
		for py in reversed(range(y, y + height)) : # Y is reversed because it is from bottomto top in the game
			for px in range(x, x + WIDTH_MAX) :
				color_idx = image.getpixel((px, py))
				if color_idx == backgrount_color_idx:
					bit = 0
				else:
					bit = 1
				bits.append(bit)

		# combite bits into byte lists
		data = common.combine_bits_to_bytes(bits)

		asm += "\n"
		asm += f"			.word 0 ; safety pair of bytes for reading by POP B\n"
		adjusted_char = get_char_label_postfix(char_name)
		asm += f"{label_prefix}_{adjusted_char}:\n"

		if offset_y < 0:
			offset_x -= 1
		asm += f"			.byte {offset_y}, {offset_x} ; offset_y, offset_x\n"
		
		asm += common.words_to_asm(data)
		asm += f"			.byte 0, {width + spacing} ; next_char_offset\n"

		char_addr_offset += 2 # safety pair of bytes for reading by POP B
		gfx_ptrs[char_name] = char_addr_offset
		char_addr_offset += 2 + len(data)*2 + 2 # offset_y, offset_x + data_len + next_char_offset

	return asm, gfx_ptrs
 
def get_char_label_postfix(char_name):
	eng_alphabet_len = 26

	adjusted_char = char_name
	unicode_code_point = ord(char_name[0])
	if unicode_code_point > 0x100:
		adjusted_code_point = (unicode_code_point - 0x100) % eng_alphabet_len + 0x61
		offset = (unicode_code_point - 0x100) // eng_alphabet_len
		adjusted_char = f"{chr(adjusted_code_point)}{offset}"
	return adjusted_char

def gfx_ptrs_to_asm(label_prefix, source_j, font_gfx_ptrs_rd = False, gfx_ptrs = None):
	asm = ""
	if font_gfx_ptrs_rd:
		label_access_prefix = ""
	else:
		label_access_prefix = "__"

	# if font_gfx_ptrs_rd == True, then add list of labels with relatives addresses
	if font_gfx_ptrs_rd:
		asm += "; relative label addresses. to global addr add __font_rus_gfx\n"
		for char_name in gfx_ptrs:
			adjusted_char = get_char_label_postfix(char_name) 
			asm += f"{label_prefix}_{adjusted_char} = {gfx_ptrs[char_name]}\n"

	asm += f"{label_prefix}_gfx_ptrs:\n"

	gfx_ptrs_len = len(source_j["gfx_ptrs"])
	asm += f"GFX_PTRS_LEN = {gfx_ptrs_len}\n"
	
	numbers_in_line = 16 
	for i, char_name in enumerate(source_j["gfx_ptrs"]):
		if i % numbers_in_line == 0:
			if i != 0:
				asm += "\n"
			asm += "			.word "
		adjusted_char = get_char_label_postfix(char_name)
		asm += f"{label_access_prefix}{label_prefix}_{adjusted_char}, "

	asm +="\n"

	return asm

def export(source_j_path, asm_gfx_ptrs_path, asm_gfx_path, font_gfx_ptrs_rd = False):
	source_name = common.path_to_basename(source_j_path)
	source_dir = str(Path(source_j_path).parent) + "\\"
	asm_gfx_ptrs_dir = str(Path(asm_gfx_ptrs_path).parent) + "\\"
	asm_gfx_dir = str(Path(asm_gfx_path).parent) + "\\"

	with open(source_j_path, "rb") as file:
		source_j = json.load(file)

	if "asset_type" not in source_j or source_j["asset_type"] != build.ASSET_TYPE_FONT :
		build.exit_error(f'export_font ERROR: asset_type != "{build.ASSET_TYPE_FONT}", path: {source_j_path}')

	path_png = source_dir + source_j["path_png"]
	image = Image.open(path_png)

	asm = "; " + source_j_path + "\n"
	asm_gfx = asm + f"__RAM_DISK_S_{source_name.upper()} = RAM_DISK_S" + "\n"
	asm_gfx += asm + f"__RAM_DISK_M_{source_name.upper()} = RAM_DISK_M" + "\n"
	asm_gfx_, gfx_ptrs = gfx_to_asm("__" + source_name, source_j, image)
	asm_gfx += asm_gfx_

	asm_gfx_ptrs = gfx_ptrs_to_asm(source_name, source_j, font_gfx_ptrs_rd, gfx_ptrs)

	# save asm
	if not os.path.exists(asm_gfx_ptrs_dir):
		os.mkdir(asm_gfx_ptrs_dir)

	with open(asm_gfx_ptrs_path, "w") as file:
		file.write(asm_gfx_ptrs)

	if not os.path.exists(asm_gfx_dir):
		os.mkdir(asm_gfx_dir)

	with open(asm_gfx_path, "w") as file:
		file.write(asm_gfx)

def export_if_updated(source_path, generated_dir, force_export, font_gfx_ptrs_rd = False):
	source_name = common.path_to_basename(source_path)

	gfx_ptrs_path = generated_dir + source_name + "_gfx_ptrs" + build.EXT_ASM
	gfx_path = generated_dir + source_name + "_gfx" + build.EXT_ASM

	export_paths = {"ram" : gfx_ptrs_path, "ram_disk" : gfx_path }

	if force_export or is_source_updated(source_path):
		export(source_path,	gfx_ptrs_path, gfx_path, font_gfx_ptrs_rd)

		print(f"export_font: {source_path} got exported.")
		return True, export_paths
	else:
		return False, export_paths

def is_source_updated(source_j_path):
	with open(source_j_path, "rb") as file:
		source_j = json.load(file)
	
	source_dir = str(Path(source_j_path).parent) + "\\"
	path_png = source_dir + source_j["path_png"]

	if build.is_file_updated(source_j_path) | build.is_file_updated(path_png):
		return True
	return False


