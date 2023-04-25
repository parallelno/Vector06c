import os
from pathlib import Path
from PIL import Image
import json
import common
import common_gfx
import build

def sprite_data(bytes0, bytes1, bytes2, bytes3, w, h):
	# data format is described in draw_back.asm
	# sprite uses 4 screen buffers without a mask
	# the width is devided by 8 because there is 8 pixels per a byte
	width = w // 8
	data = []
	for y in range(h):
		even_line = y % 2 == 0
		if even_line:
			for x in range(width):
				i = y*width+x
				data.append(bytes0[i])			
			for x in range(width):
				i = y*width+width-x-1
				data.append(bytes1[i])
			for x in range(width):
				i = y*width+width-x-1
				data.append(bytes2[i])
			for x in range(width):
				i = y*width+width-x-1
				data.append(bytes3[i])
		else:
			for x in range(width):
				i = y*width+x
				data.append(bytes3[i])
			for x in range(width):
				i = y*width+width-x-1
				data.append(bytes2[i])
			for x in range(width):
				i = y*width+width-x-1
				data.append(bytes1[i])
			for x in range(width):
				i = y*width+width-x-1		
				data.append(bytes0[i])

	return [data]

def anims_to_asm(label_prefix, source_j):
	asm = ""

	# make a list of animNames
	asm += label_prefix + "_anims:\n"
	asm += "			.word "
	for anim_name in source_j["anims"]:
		asm += label_prefix + "_" + anim_name + ", "
	asm += "\n"
	
	preshifted_sprites = 1 # means no preshifted sprites

	# make a list of sprites for an every anim
	for anim_name in source_j["anims"]:

		asm += f"{label_prefix}_{anim_name}:\n"
 
		anims = source_j["anims"][anim_name]["frames"]
		loop = source_j["anims"][anim_name]["loop"]
		frame_count = len(source_j["anims"][anim_name]["frames"])
		for i, frame in enumerate(anims):

			if i < frame_count-1:
				next_frame_offset = preshifted_sprites * 2 # every frame consists of preshifted_sprites pointers
				next_frame_offset += 1 # increase the offset to save one instruction in the game code
				asm += f"			.byte {next_frame_offset}, 0 ; offset to the next frame\n"
			else:
				next_frame_offset_hi_str = "$ff"
				if loop == False:
					next_frame_offset_low = -1
				else:
					offsetAddr = 1
					next_frame_offset_low = 255 - (frame_count - 1) * (preshifted_sprites + offsetAddr) * 2 + 1
					next_frame_offset_low -= 1 # decrease the offset to save one instruction in the game code
					
				asm += f"			.byte {next_frame_offset_low}, {next_frame_offset_hi_str} ; offset to the first frame\n"

			asm += "			.word "
			for i in range(preshifted_sprites):
				asm += f"__{label_prefix}_{frame}, "
			asm += "\n"

	return asm

def gfx_to_asm(label_prefix, source_j, image):
	sprites_j = source_j["sprites"]
	asm = label_prefix + "_sprites:"

	for sprite in sprites_j:
		sprite_name = sprite["name"]
		x = sprite["x"]
		y = sprite["y"]
		width = sprite["width"]
		height = sprite["height"]
		offset_x = sprite.get("offset_x", 0)
		offset_y = sprite.get("offset_y", 0)

		# get a sprite as a color index 2d array
		sprite_img = []
		for py in reversed(range(y, y + height)) : # Y is reversed because it is from bottomto top in the game
			line = []
			for px in range(x, x+width) :
				color_idx = image.getpixel((px, py))
				line.append(color_idx)

			sprite_img.append(line)

		# convert indexes into bit lists.
		bits0, bits1, bits2, bits3 = common_gfx.indexes_to_bit_lists(sprite_img)

		# combite bits into byte lists
		bytes0 = common.combine_bits_to_bytes(bits0) # 8000-9FFF # from left to right, from bottom to top
		bytes1 = common.combine_bits_to_bytes(bits1) # A000-BFFF
		bytes2 = common.combine_bits_to_bytes(bits2) # C000-DFFF
		bytes3 = common.combine_bits_to_bytes(bits3) # E000-FFFF

		# to support a sprite render function
		data = sprite_data(bytes0, bytes1, bytes2, bytes3, width, height)

		asm += "\n"
		asm += f"			.word 0  ; safety pair of bytes for reading by POP B\n"
		asm += f"{label_prefix}_{sprite_name}:\n"

		width_packed = width//8 - 1
		offset_x_packed = offset_x//8
		asm += "			.byte " + str( offset_y ) + ", " +  str( offset_x_packed ) + "; offset_y, offset_x\n"
		asm += "			.byte " + str( height ) + ", " +  str( width_packed ) + "; height, width\n"
		asm += common_gfx.bytes_to_asm_tiled(data)
		asm += "\n"

	return asm

def export_if_updated(source_path, generated_dir, force_export):
	source_name = common.path_to_basename(source_path)

	anim_path = generated_dir + source_name + "_anim" + build.EXT_ASM
	sprite_path = generated_dir + source_name + "_sprites" + build.EXT_ASM

	export_paths = {"ram" : anim_path, "ram_disk" : sprite_path }

	if force_export or is_source_updated(source_path):
		export(	source_path, anim_path, sprite_path)

		print(f"export_back: {source_path} got exported.")
		return True, export_paths
	else:
		return False, export_paths

def export(source_j_path, asm_anim_path, asm_sprite_path):
	source_name = common.path_to_basename(source_j_path)
	source_dir = str(Path(source_j_path).parent) + "\\"
	asm_anim_dir = str(Path(asm_anim_path).parent) + "\\"
	asm_sprite_dir = str(Path(asm_sprite_path).parent) + "\\"

	with open(source_j_path, "rb") as file:
		source_j = json.load(file)

	if "asset_type" not in source_j or source_j["asset_type"] != build.ASSET_TYPE_BACK :
		print(f'export_back ERROR: asset_type != "{build.ASSET_TYPE_BACK}", path: {source_j_path}')
		print("Stop export")
		exit(1)

	path_png = source_dir + source_j["path_png"]
	image = Image.open(path_png)

	_, colors = common_gfx.palette_to_asm(image, source_j)

	image = common_gfx.remap_colors(image, colors)

	asm = "; " + source_j_path + "\n"
	asm_anims = asm + anims_to_asm(source_name, source_j)
	asm_sprites = asm + f"__RAM_DISK_S_{source_name.upper()} = RAM_DISK_S" + "\n"
	asm_sprites += asm + f"__RAM_DISK_M_{source_name.upper()} = RAM_DISK_M" + "\n"
	asm_sprites += gfx_to_asm("__" + source_name, source_j, image) 

	# save asm
	if not os.path.exists(asm_anim_dir):
		os.mkdir(asm_anim_dir)

	with open(asm_anim_path, "w") as file:
		file.write(asm_anims)

	if not os.path.exists(asm_sprite_dir):
		os.mkdir(asm_sprite_dir)

	with open(asm_sprite_path, "w") as file:
		file.write(asm_sprites)

def is_source_updated(source_j_path):
	with open(source_j_path, "rb") as file:
		source_j = json.load(file)
	
	source_dir = str(Path(source_j_path).parent) + "\\"
	path_png = source_dir + source_j["path_png"]

	if build.is_file_updated(source_j_path) | build.is_file_updated(path_png):
		return True
	return False


