import os
from pathlib import Path
from PIL import Image
import json
import common
import build

def bytes_to_asm_tiled(data):
	asm = ""
	for tile in data:
		asm += "			.byte "
		for b in tile:
			asm += str(b) + ","
		asm += "\n"
	return asm

def mask_data(mask_bytes, w, h ):
	# sprite data structure description is in drawSprite.asm
	# sprite uses only 3 out of 4 screen buffers.
	# the width is devided by 8 because there is 8 pixels per a byte
	width = w // 8
	#mask = 0
	data = []
	for y in range(h):
		even_line = y % 2 == 0
		if even_line:
			for x in range(width):
				i = y*width+x
				data.append(mask_bytes[i])
		else:
			for x in range(width):
				i = y*width+x
				data.append(mask_bytes[i])
	return data

# from left-bottom corner by columns all the data for the first scr buff
# then the same for each other scr buffs
# sprite data structure description is in drawSprite.asm
# sprite uses only 3 out of 4 screen buffers.
# the width is devided by 8 because there is 8 pixels per a byte

def sprite_data_bb(bytes1, bytes2, bytes3, w, h, mask_bytes = None):
	bytes_all = [bytes1, bytes2, bytes3]
	width = w // 8
	data = []
	for bytes in bytes_all:
		scr_buff = []
		for x in range(width):
			for y in reversed(range(0, h)):
				i = y*width + x
				scr_buff.append(bytes[i])
				if mask_bytes:
					scr_buff.append(mask_bytes[i])
		data.append(scr_buff)
	return data

# tiles 8*8pxs for 3 scr fuffers
def sprite_data_tiled(bytes1, bytes2, bytes3, w, h, mask_bytes = None):
	# sprite data structure description is in drawSprite.asm
	# sprite uses only 3 out of 4 screen buffers.
	# the width is devided by 8 because there is 8 pixels per a byte
	bytes_all = [bytes1, bytes2, bytes3]
	width = w // 8
	data = []
	for x in range(width):
		for y in range(0, h, 8):
			tile = []
			for bytes in bytes_all:
				for dy in range(8):
					i = y*width + x
					tile.append(bytes[i])
					if mask_bytes:
						tile.append(mask_bytes[i])
			data.append(tile)
	return data

def sprite_data(bytes1, bytes2, bytes3, w, h, mask_bytes = None):
	# sprite data structure description is in draw_sprite.asm
	# sprite uses only 3 out of 4 screen buffers.
	# the width is devided by 8 because there is 8 pixels per a byte
	width = w // 8
	data = []
	for y in range(h):
		even_line = y % 2 == 0
		if even_line:
			for x in range(width):
				i = y*width+x
				if mask_bytes:
					data.append(mask_bytes[i])
				data.append(bytes1[i])
			for x in range(width):
				i = y*width+width-x-1
				if mask_bytes:
					data.append(mask_bytes[i])
				data.append(bytes2[i])
			for x in range(width):
				i = y*width+width-x-1
				if mask_bytes:
					data.append(mask_bytes[i])
				data.append(bytes3[i])
		else:
			for x in range(width):
				i = y*width+x
				if mask_bytes:
					data.append(mask_bytes[i])
				data.append(bytes3[i])
			for x in range(width):
				i = y*width+width-x-1
				if mask_bytes:
					data.append(mask_bytes[i])
				data.append(bytes2[i])
			for x in range(width):
				i = y*width+width-x-1
				if mask_bytes:
					data.append(mask_bytes[i])
				data.append(bytes1[i])

	return [data]

def anims_to_asm(label_prefix, source_j, source_j_path):
	asm = ""
	preshifted_sprites = source_j.get("preshifted_sprites", 1)
	
	if (preshifted_sprites != 1 and
		preshifted_sprites != 4 and preshifted_sprites != 8):
		print(f'export_sprite ERROR: preshifted_sprites can be only equal 1, 4, 8", path: {source_j_path}')
		print("Stop export")
		exit(1)

	if preshifted_sprites == 4 or preshifted_sprites == 8:
		asm += f"sprite_get_scr_addr_{label_prefix} = sprite_get_scr_addr{preshifted_sprites}\n\n"
		asm += label_prefix + "_preshifted_sprites:\n"
		asm += f"			.byte " + str(preshifted_sprites) + "\n"

	# make a list of animNames
	asm += label_prefix + "_anims:\n"
	asm += "			.word "
	for animName in source_j["anims"]:
		asm += label_prefix + "_" + animName + ", "
	asm += "0, \n"

	# make a list of sprites for an every anim
	for animName in source_j["anims"]:

		asm += label_prefix + "_" + animName + ":\n"
 
		anims = source_j["anims"][animName]["frames"]
		loop = source_j["anims"][animName]["loop"]
		frame_count = len(source_j["anims"][animName]["frames"])
		for i, frame in enumerate(anims):

			if i < frame_count-1:
				next_frame_offset = preshifted_sprites * 2 # every frame consists of preshifted_sprites pointers
				next_frame_offset += 1 # increase the offset to save one instruction in the game code
				asm += "			.byte " + str(next_frame_offset) + ", 0 ; offset to the next frame\n"
			else:
				next_frame_offset_hi_str = "$ff"
				if loop == False:
					next_frame_offset_low = -1
					comment = "offset to the same last frame"
				else:
					offset_addr = 1
					next_frame_offset_low = 255 - (frame_count - 1) * (preshifted_sprites + offset_addr) * 2 + 1
					next_frame_offset_low -= 1 # decrease the offset to save one instruction in the game code
					comment = "offset to the first frame"
					
				asm += f"			.byte {next_frame_offset_low}, {next_frame_offset_hi_str} ; {comment}\n"

			asm += "			.word "
			for i in range(preshifted_sprites):
				asm += "__" + label_prefix + "_" + str(frame) + "_" + str(i) + ", "
			asm += "\n"

	return asm

# find the most leftest or rightest pixel in a sprite
# return its dx
def find_sprite_horiz_border(forwardSearch, sprite_img, mask_alpha, width, height):
	stop_flag = False
	for dx in range(width):
		for dy in range(height):
			if forwardSearch:
				dx2 = dx
			else:
				dx2 = width - 1 - dx
			color_idx = sprite_img[dy][dx2]
			if color_idx != mask_alpha:
				stop_flag = True
				break
		if stop_flag: break
	return dx2  

def get_sprite_params(label_prefix, sprite_name, dx_l, dx_r, sprite_img, mask_alpha, width, height, shift):
	#if label_prefix == 'burner' and sprite_name == 'idle_l0':
	#	test= 10 
	shifted_dx_l = shift + dx_l
	shifted_dx_r = shift + dx_r

	offset_x_preshifted_local = shifted_dx_l//8 * 8
	width_new = (shifted_dx_r//8+1) * 8 - offset_x_preshifted_local
	return offset_x_preshifted_local, width_new

def make_empty_sprite_data(has_mask, width, height):
	src_buff_count = 3
	data = []
	for dy in range(height):
		for dx in range(width // 8 * src_buff_count):		
			if has_mask:
				data.append(255)
			data.append(0)

	return [data]

def sprites_to_asm(label_prefix, source_j, image, has_mask, source_j_path):
	sprites_j = source_j["sprites"]
	asm = label_prefix + "_sprites:"

	preshifted_sprites = source_j.get("preshifted_sprites", 1)
	
	if (preshifted_sprites != 1 and
		preshifted_sprites != 4 and preshifted_sprites != 8):
		print(f'export_sprite ERROR: preshifted_sprites can be only equal 1, 4, 8", path: {source_j_path}')
		print("Stop export")
		exit(1)

	for sprite in sprites_j:
		sprite_name = sprite["name"]
		x = sprite["x"]
		y = sprite["y"]
		width = sprite["width"]
		height = sprite["height"]
		offset_x = 0
		if sprite.get("offset_x") is not None:
			offset_x = sprite["offset_x"]
		offset_y = 0
		if sprite.get("offset_y") is not None:
			offset_y = sprite["offset_y"]

		# get a sprite as a color index 2d array
		sprite_img = []
		for py in reversed(range(y, y + height)) : # Y is reversed because it is from bottomto top in the game
			line = []
			for px in range(x, x+width) :
				color_idx = image.getpixel((px, py))
				line.append(color_idx)

			sprite_img.append(line)

		# convert indexes into bit lists.
		bits0, bits1, bits2, bits3 = common.indexes_to_bit_lists(sprite_img)

		# combite bits into byte lists
		#bytes0 = common.combine_bits_to_bytes(bits0) # 8000-9FFF # from left to right, from bottom to top
		bytes1 = common.combine_bits_to_bytes(bits1) # A000-BFFF
		bytes2 = common.combine_bits_to_bytes(bits2) # C000-DFFF
		bytes3 = common.combine_bits_to_bytes(bits3) # E000-FFFF

		mask_alpha = sprite["mask_alpha"]
		mask_color = sprite["mask_color"]

		mask_bytes = None
		if has_mask:
			# get a sprite as a color index 2d array
			x = sprite["mask_x"]
			y = sprite["mask_y"]

			mask_img = []
			for py in reversed(range(y, y + height)) : # Y is reversed because it is from bottomto top in the game
				for px in range(x, x+width) :
					color_idx = image.getpixel((px, py))
					if color_idx == mask_alpha:
						mask_img.append(1)
					else:
						mask_img.append(0)

			mask_bytes = common.combine_bits_to_bytes(mask_img)

		# to support a sprite render function
		data = sprite_data(bytes1, bytes2, bytes3, width, height, mask_bytes)

		if has_mask:
			mask_flag = 1
		else: 
			mask_flag = 0

		asm += "\n"
		asm += f"			.byte {mask_flag},1  ; safety pair of bytes for reading by POP B, and also (mask_flag, preshifting is done)\n"
		asm += label_prefix + "_" + sprite_name + "_0:\n"

		width_packed = width//8 - 1
		offset_x_packed = offset_x//8
		asm += "			.byte " + str( offset_y ) + ", " +  str( offset_x_packed ) + "; offset_y, offset_x\n"
		asm += "			.byte " + str( height ) + ", " +  str( width_packed ) + "; height, width\n"

		asm += bytes_to_asm_tiled(data)

 
		# find leftest pixel dx
		dx_l = find_sprite_horiz_border(True, sprite_img, mask_alpha, width, height)
		# find rightest pixel dx
		dx_r = find_sprite_horiz_border(False, sprite_img, mask_alpha, width, height) 

		# calculate preshifted sprite data
		for i in range(1, preshifted_sprites):
			shift = 8//preshifted_sprites * i

			offset_x_preshifted_local, width_preshifted = get_sprite_params(label_prefix, sprite_name, dx_l, dx_r, sprite_img, mask_alpha, width, height, shift)
			offset_x_preshifted = offset_x + offset_x_preshifted_local
			asm += "\n"

			copy_from_buff_offset = offset_x_preshifted_local//8
			if width_preshifted == 8: 
				copy_from_buff_offset -= 1

			asm += "			.byte " + str(copy_from_buff_offset) + ", "+ str(mask_flag) + " ; safety pair of bytes for reading by POP B and also (copy_from_buff_offset, mask_flag)\n"
			asm += label_prefix + "_" + sprite_name + "_" + str(i) + ":\n"

			width_preshifted_packed = width_preshifted//8 - 1
			offset_x_preshifted_packed = offset_x_preshifted//8
			asm += "			.byte " + str( offset_y ) + ", " +  str( offset_x_preshifted_packed ) + "; offset_y, offset_x\n"
			asm += "			.byte " + str( height ) + ", " +  str( width_preshifted_packed ) + "; height, width\n"

			empty_data = make_empty_sprite_data(has_mask, width_preshifted, height)
			asm += bytes_to_asm_tiled(empty_data)

	return asm

def export_if_updated(source_path, generated_dir, force_export):
	source_name = common.path_to_basename(source_path)

	anim_path = generated_dir + source_name + "_anim" + build.EXT_ASM
	sprite_path = generated_dir + source_name + "_sprites" + build.EXT_ASM

	export_paths = {"ram" : anim_path, "ram_disk" : sprite_path }

	if force_export or is_source_updated(source_path):
		export( source_path, anim_path, sprite_path)

		print(f"export_sprite: {source_path} got exported.")
		return True, export_paths
	else:
		return False, export_paths

def export(source_j_path, asmAnimPath, asmSpritePath):
	source_name = common.path_to_basename(source_j_path)
	source_dir = str(Path(source_j_path).parent) + "\\"
	asm_anim_dir = str(Path(asmAnimPath).parent) + "\\"
	asm_sprite_dir = str(Path(asmSpritePath).parent) + "\\"

	with open(source_j_path, "rb") as file:
		source_j = json.load(file)

	if "asset_type" not in source_j or source_j["asset_type"] != build.ASSET_TYPE_SPRITE :
		print(f'export_sprite ERROR: asset_type != "{build.ASSET_TYPE_SPRITE}", path: {source_j_path}')
		print("Stop export")
		exit(1)

	path_png = source_dir + source_j["path_png"]
	has_mask = str(source_j["mask"])
	image = Image.open(path_png)

	_, colors = common.palette_to_asm(image, source_j)

	image = common.remap_colors(image, colors)

	asm = "; " + source_j_path + "\n"
	asm_anims = asm + anims_to_asm(source_name, source_j, source_j_path)
	asm_sprites = asm + f"__RAM_DISK_S_{source_name.upper()} = RAM_DISK_S" + "\n"
	asm_sprites += asm + f"__RAM_DISK_M_{source_name.upper()} = RAM_DISK_M" + "\n"
	asm_sprites += sprites_to_asm("__" + source_name, source_j, image, has_mask, source_j_path)

	# save asm
	if not os.path.exists(asm_anim_dir):
		os.mkdir(asm_anim_dir)

	with open(asmAnimPath, "w") as file:
		file.write(asm_anims)

	if not os.path.exists(asm_sprite_dir):
		os.mkdir(asm_sprite_dir)

	with open(asmSpritePath, "w") as file:
		file.write(asm_sprites)

def is_source_updated(source_j_path):
	with open(source_j_path, "rb") as file:
		source_j = json.load(file)
	
	source_dir = str(Path(source_j_path).parent) + "\\"
	path_png = source_dir + source_j["path_png"]

	if build.is_file_updated(source_j_path) | build.is_file_updated(path_png):
		return True
	return False


