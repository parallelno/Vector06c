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

def mask_data(maskBytes, w, h ):
	# sprite data structure description is in drawSprite.asm
	# sprite uses only 3 out of 4 screen buffers.
	# the width is devided by 8 because there is 8 pixels per a byte
	width = w // 8
	#mask = 0
	data = []
	for y in range(h):
		evenLine = y % 2 == 0
		if evenLine:
			for x in range(width):
				i = y*width+x
				data.append(maskBytes[i])
		else:
			for x in range(width):
				i = y*width+x
				data.append(maskBytes[i])
	return data

# from left-bottom corner by columns all the data for the first scr buff
# then the same for each other scr buffs
# sprite data structure description is in drawSprite.asm
# sprite uses only 3 out of 4 screen buffers.
# the width is devided by 8 because there is 8 pixels per a byte

def sprite_data_bb(bytes1, bytes2, bytes3, w, h, maskBytes = None):
	bytesAll = [bytes1, bytes2, bytes3]
	width = w // 8
	data = []
	for bytes in bytesAll:
		scrBuff = []
		for x in range(width):
			for y in reversed(range(0, h)):
				i = y*width + x
				scrBuff.append(bytes[i])
				if maskBytes:
					scrBuff.append(maskBytes[i])
		data.append(scrBuff)
	return data

# tiles 8*8pxs for 3 scr fuffers
def sprite_data_tiled(bytes1, bytes2, bytes3, w, h, maskBytes = None):
	# sprite data structure description is in drawSprite.asm
	# sprite uses only 3 out of 4 screen buffers.
	# the width is devided by 8 because there is 8 pixels per a byte
	bytesAll = [bytes1, bytes2, bytes3]
	width = w // 8
	data = []
	for x in range(width):
		for y in range(0, h, 8):
			tile = []
			for bytes in bytesAll:
				for dy in range(8):
					i = y*width + x
					tile.append(bytes[i])
					if maskBytes:
						tile.append(maskBytes[i])
			data.append(tile)
	return data

def sprite_data(bytes1, bytes2, bytes3, w, h, maskBytes = None):
	# sprite data structure description is in drawSprite.asm
	# sprite uses only 3 out of 4 screen buffers.
	# the width is devided by 8 because there is 8 pixels per a byte
	width = w // 8
	data = []
	for y in range(h):
		evenLine = y % 2 == 0
		if evenLine:
			for x in range(width):
				i = y*width+x
				if maskBytes:
					data.append(maskBytes[i])
				data.append(bytes1[i])
			for x in range(width):
				i = y*width+width-x-1
				if maskBytes:
					data.append(maskBytes[i])
				data.append(bytes2[i])
			for x in range(width):
				i = y*width+width-x-1
				if maskBytes:
					data.append(maskBytes[i])
				data.append(bytes3[i])
		else:
			for x in range(width):
				i = y*width+x
				if maskBytes:
					data.append(maskBytes[i])
				data.append(bytes3[i])
			for x in range(width):
				i = y*width+width-x-1
				if maskBytes:
					data.append(maskBytes[i])
				data.append(bytes2[i])
			for x in range(width):
				i = y*width+width-x-1
				if maskBytes:
					data.append(maskBytes[i])
				data.append(bytes1[i])

	return [data]

def anims_to_asm(labelPrefix, source_j):
	asm = ""
	# preshifted sprites
	preshiftedSprites = source_j["preshifted_sprites"]
	asm += f"sprite_get_scr_addr_{labelPrefix} = sprite_get_scr_addr{preshiftedSprites}\n\n"
	asm += labelPrefix + "_preshifted_sprites:\n"
	asm += f"			.byte " + str(preshiftedSprites) + "\n"


	# make a list of animNames
	asm += labelPrefix + "_anims:\n"
	asm += "			.word "
	for animName in source_j["anims"]:
		asm += labelPrefix + "_" + animName + ", "
	asm += "0, \n"

	# make a list of sprites for an every anim
	for animName in source_j["anims"]:

		asm += labelPrefix + "_" + animName + ":\n"
 
		anims = source_j["anims"][animName]["frames"]
		loop = source_j["anims"][animName]["loop"]
		frameCount = len(source_j["anims"][animName]["frames"])
		for i, frame in enumerate(anims):

			if i < frameCount-1:
				nextFrameOffset = preshiftedSprites * 2 # every frame consists of preshiftedSprites pointers
				nextFrameOffset += 1 # increase the offset to save one instruction in the game code
				asm += "			.byte " + str(nextFrameOffset) + ", 0 ; offset to the next frame\n"
			else:
				nextFrameOffsetHiStr = "$ff"
				if loop == False:
					nextFrameOffsetLow = -1
				else:
					offsetAddr = 1
					nextFrameOffsetLow = 255 - (frameCount - 1) * (preshiftedSprites + offsetAddr) * 2 + 1
					nextFrameOffsetLow -= 1 # decrease the offset to save one instruction in the game code
					
				asm += "			.byte " + str(nextFrameOffsetLow) + ", " + nextFrameOffsetHiStr + " ; offset to the first frame\n"

			asm += "			.word "
			for i in range(preshiftedSprites):
				asm += "__" + labelPrefix + "_" + str(frame) + "_" + str(i) + ", "
			asm += "\n"

	return asm

# find the most leftest or rightest pixel in a sprite
# return its dx
def find_sprite_horiz_border(forwardSearch, spriteImg, mask_alpha, width, height):
	stopFlag = False
	for dx in range(width):
		for dy in range(height):
			if forwardSearch:
				dx2 = dx
			else:
				dx2 = width - 1 - dx
			colorIdx = spriteImg[dy][dx2]
			if colorIdx != mask_alpha:
				stopFlag = True
				break
		if stopFlag: break
	return dx2  

def get_sprite_params(labelPrefix, spriteName, dxL, dxR, spriteImg, mask_alpha, width, height, shift):
	#if labelPrefix == 'burner' and spriteName == 'idle_l0':
	#	test= 10 
	shiftedDxL = shift + dxL
	shiftedDxR = shift + dxR

	offsetXPreshiftedLocal = shiftedDxL//8 * 8
	widthNew = (shiftedDxR//8+1) * 8 - offsetXPreshiftedLocal
	return offsetXPreshiftedLocal, widthNew

def make_empty_sprite_data(hasMask, width, height):
	srcBuffCount = 3
	data = []
	for dy in range(height):
		for dx in range(width // 8 * srcBuffCount):		
			if hasMask:
				data.append(255)
			data.append(0)

	return [data]

def sprites_to_asm(labelPrefix, source_j, image, hasMask):
	spritesJ = source_j["sprites"]
	asm = labelPrefix + "_sprites:"

	# preshifted sprites
	preshiftedSprites = source_j["preshifted_sprites"]

	for sprite in spritesJ:
		spriteName = sprite["name"]
		x = sprite["x"]
		y = sprite["y"]
		width = sprite["width"]
		height = sprite["height"]
		offsetX = 0
		if sprite.get("offsetX") is not None:
			offsetX = sprite["offsetX"]
		offsetY = 0
		if sprite.get("offsetY") is not None:
			offsetY = sprite["offsetY"]

		# get a sprite as a color index 2d array
		spriteImg = []
		for py in reversed(range(y, y + height)) : # Y is reversed because it is from bottomto top in the game
			line = []
			for px in range(x, x+width) :
				colorIdx = image.getpixel((px, py))
				line.append(colorIdx)

			spriteImg.append(line)

		# convert indexes into bit lists.
		bits0, bits1, bits2, bits3 = common.indexes_to_bit_lists(spriteImg)

		# combite bits into byte lists
		#bytes0 = common.combine_bits_to_bytes(bits0) # 8000-9FFF # from left to right, from bottom to top
		bytes1 = common.combine_bits_to_bytes(bits1) # A000-BFFF
		bytes2 = common.combine_bits_to_bytes(bits2) # C000-DFFF
		bytes3 = common.combine_bits_to_bytes(bits3) # E000-FFFF

		mask_alpha = sprite["mask_alpha"]
		mask_color = sprite["mask_color"]

		maskBytes = None
		if hasMask:
			# get a sprite as a color index 2d array
			x = sprite["mask_x"]
			y = sprite["mask_y"]

			maskImg = []
			for py in reversed(range(y, y + height)) : # Y is reversed because it is from bottomto top in the game
				for px in range(x, x+width) :
					colorIdx = image.getpixel((px, py))
					if colorIdx == mask_alpha:
						maskImg.append(1)
					else:
						maskImg.append(0)

			maskBytes = common.combine_bits_to_bytes(maskImg)

		# to support a sprite render function
		data = sprite_data(bytes1, bytes2, bytes3, width, height, maskBytes)

		if hasMask:
			maskFlag = 1
		else: 
			maskFlag = 0

		asm += "\n"
		# two empty bytes prior every sprite data to support a stack renderer
		asm += f"			.byte {maskFlag},1  ; safety pair of bytes to support a stack renderer, and also (maskFlag, preshifting is done)\n"
		asm += labelPrefix + "_" + spriteName + "_0:\n"

		widthPacked = width//8 - 1
		offsetXPacked = offsetX//8
		asm += "			.byte " + str( offsetY ) + ", " +  str( offsetXPacked ) + "; offsetY, offsetX\n"
		asm += "			.byte " + str( height ) + ", " +  str( widthPacked ) + "; height, width\n"

		asm += bytes_to_asm_tiled(data)

 
		# find leftest pixel dx
		dxL = find_sprite_horiz_border(True, spriteImg, mask_alpha, width, height)
		# find rightest pixel dx
		dxR = find_sprite_horiz_border(False, spriteImg, mask_alpha, width, height) 

		# calculate preshifted sprite data
		for i in range(1, preshiftedSprites):
			shift = 8//preshiftedSprites * i

			offsetXPreshiftedLocal, widthPreshifted = get_sprite_params(labelPrefix, spriteName, dxL, dxR, spriteImg, mask_alpha, width, height, shift)
			offsetXPreshifted = offsetX + offsetXPreshiftedLocal
			asm += "\n"

			copyFromBuffOffset = offsetXPreshiftedLocal//8
			if widthPreshifted == 8: 
				copyFromBuffOffset -= 1

			# two empty bytes prior every sprite data to support a stack renderer
			asm += "			.byte " + str(copyFromBuffOffset) + ", "+ str(maskFlag) + " ; safety pair of bytes to support a stack renderer and also (copyFromBuffOffset, maskFlag)\n"
			asm += labelPrefix + "_" + spriteName + "_" + str(i) + ":\n"

			widthPreshiftedPacked = widthPreshifted//8 - 1
			offsetXPreshiftedPacked = offsetXPreshifted//8
			asm += "			.byte " + str( offsetY ) + ", " +  str( offsetXPreshiftedPacked ) + "; offsetY, offsetX\n"
			asm += "			.byte " + str( height ) + ", " +  str( widthPreshiftedPacked ) + "; height, width\n"

			emptyData = make_empty_sprite_data(hasMask, widthPreshifted, height)
			asm += bytes_to_asm_tiled(emptyData)

	return asm

def export_if_updated(source_path, generated_dir, force_export):
	source_name = common.path_to_basename(source_path)

	anim_path = generated_dir + source_name + "_anim" + build.EXT_ASM
	sprite_path = generated_dir + source_name + "_sprites" + build.EXT_ASM

	export_paths = {"ram" : anim_path, "ram_disk" : sprite_path }

	if force_export or is_source_updated(source_path):
		export(
			source_path,
			anim_path, 
			sprite_path)

		print(f"sprite: {source_path} got exported.")
		return True, export_paths
	else:
		return False, export_paths

def export(source_j_path, asmAnimPath, asmSpritePath):
	source_name = common.path_to_basename(source_j_path)
	source_dir = str(Path(source_j_path).parent) + "\\"
	asmAnimDir = str(Path(asmAnimPath).parent) + "\\"
	asmSpriteDir = str(Path(asmSpritePath).parent) + "\\"

	with open(source_j_path, "rb") as file:
		source_j = json.load(file)

	if "asset_type" not in source_j or source_j["asset_type"] != build.ASSET_TYPE_SPRITE :
		print(f'export_sprite ERROR: asset_type != "{build.ASSET_TYPE_SPRITE}", path: {source_j_path}')
		print("Stop export")
		exit(1)

	png_path = source_dir + source_j["png_path"]
	hasMask = str(source_j["mask"])
	image = Image.open(png_path)

	_, colors = common.palette_to_asm(image, source_j)

	image = common.remap_colors(image, colors)

	asm = "; " + source_j_path + "\n"
	asmAnims = asm + anims_to_asm(source_name, source_j)
	asmSprites = asm + f"__RAM_DISK_S_{source_name.upper()} = RAM_DISK_S" + "\n"
	asmSprites += asm + f"__RAM_DISK_M_{source_name.upper()} = RAM_DISK_M" + "\n"
	asmSprites += sprites_to_asm("__" + source_name, source_j, image, hasMask)

	# save asm
	if not os.path.exists(asmAnimDir):
		os.mkdir(asmAnimDir)

	with open(asmAnimPath, "w") as file:
		file.write(asmAnims)

	if not os.path.exists(asmSpriteDir):
		os.mkdir(asmSpriteDir)

	with open(asmSpritePath, "w") as file:
		file.write(asmSprites)

def is_source_updated(source_j_path):
	with open(source_j_path, "rb") as file:
		source_j = json.load(file)
	
	source_dir = str(Path(source_j_path).parent) + "\\"
	png_path = source_dir + source_j["png_path"]

	if build.is_file_updated(source_j_path) | build.is_file_updated(png_path):
		return True
	return False


