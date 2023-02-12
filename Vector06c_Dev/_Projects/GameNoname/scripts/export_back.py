import os
from pathlib import Path
from PIL import Image
import json
import common
import build

def BytesToAsmTiled(data):
	asm = ""
	for tile in data:
		asm += "			.byte "
		for b in tile:
			asm += str(b) + ","
		asm += "\n"
	return asm

def MaskData(maskBytes, w, h ):
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

def SpriteDataBB(bytes1, bytes2, bytes3, w, h, maskBytes = None):
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
def SpriteDataTiled(bytes1, bytes2, bytes3, w, h, maskBytes = None):
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

def SpriteData(bytes0, bytes1, bytes2, bytes3, w, h):
	# data format is described in draw_back.asm
	# sprite uses 4 screen buffers without a mask
	# the width is devided by 8 because there is 8 pixels per a byte
	width = w // 8
	data = []
	for y in range(h):
		evenLine = y % 2 == 0
		if evenLine:
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

	return [data]

def AnimsToAsm(labelPrefix, source_j):
	asm = ""
	preshiftedSprites = 1 # means no preshifted sprites

	# make a list of sprites for an every anim
	for animName in source_j["anims"]:

		asm += f"{labelPrefix}_{animName}:\n"
 
		anims = source_j["anims"][animName]["frames"]
		loop = source_j["anims"][animName]["loop"]
		frameCount = len(source_j["anims"][animName]["frames"])
		for i, frame in enumerate(anims):

			if i < frameCount-1:
				nextFrameOffset = preshiftedSprites * 2 # every frame consists of preshiftedSprites pointers
				nextFrameOffset += 1 # increase the offset to save one instruction in the game code
				asm += f"			.byte {nextFrameOffset}, 0 ; offset to the next frame\n"
			else:
				nextFrameOffsetHiStr = "$ff"
				if loop == False:
					nextFrameOffsetLow = -1
				else:
					offsetAddr = 1
					nextFrameOffsetLow = 255 - (frameCount - 1) * (preshiftedSprites + offsetAddr) * 2 + 1
					nextFrameOffsetLow -= 1 # decrease the offset to save one instruction in the game code
					
				asm += f"			.byte {nextFrameOffsetLow}, {nextFrameOffsetHiStr} ; offset to the first frame\n"

			asm += "			.word "
			for i in range(preshiftedSprites):
				asm += f"__{labelPrefix}_{frame}, "
			asm += "\n"

	return asm

# find the most leftest or rightest pixel in a sprite
# return its dx
def FindSpriteHorizBorder(forwardSearch, spriteImg, mask_alpha, width, height):
	stopFlag = False
	for dx in range(width):
		for dy in range(height):
			if forwardSearch:
				dx2 = dx
			else:
				dx2 = width - 1 - dx
			colorIdx = spriteImg[dy][dx2]
			if colorIdx != 0:
				stopFlag = True
				break
		if stopFlag: break
	return dx2  

def GetSpriteParams(labelPrefix, spriteName, dxL, dxR, spriteImg, mask_alpha, width, height, shift):
	#if labelPrefix == 'burner' and spriteName == 'idle_l0':
	#	test= 10 
	shiftedDxL = shift + dxL
	shiftedDxR = shift + dxR

	offsetXPreshiftedLocal = shiftedDxL//8 * 8
	widthNew = (shiftedDxR//8+1) * 8 - offsetXPreshiftedLocal
	return offsetXPreshiftedLocal, widthNew

def MakeEmptySpriteData(width, height, srcBuffCount):
	data = []
	for dy in range(height):
		for dx in range(width // 8 * srcBuffCount):
			data.append(0)

	return [data]

def SpritesToAsm(labelPrefix, source_j, image):
	spritesJ = source_j["sprites"]
	asm = labelPrefix + "_sprites:"

	for sprite in spritesJ:
		spriteName = sprite["name"]
		x = sprite["x"]
		y = sprite["y"]
		width = sprite["width"]
		height = sprite["height"]

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
		bytes0 = common.combine_bits_to_bytes(bits0) # 8000-9FFF # from left to right, from bottom to top
		bytes1 = common.combine_bits_to_bytes(bits1) # A000-BFFF
		bytes2 = common.combine_bits_to_bytes(bits2) # C000-DFFF
		bytes3 = common.combine_bits_to_bytes(bits3) # E000-FFFF

		# to support a sprite render function
		data = SpriteData(bytes0, bytes1, bytes2, bytes3, width, height)

		asm += "\n"
		# two empty bytes prior every sprite data to support a stack renderer
		asm += f"			.byte 0,0  ; safety pair of bytes to support a stack renderer\n"
		asm += f"{labelPrefix}_{spriteName}:\n"

		widthPacked = width//8 - 1
		asm += "			.byte " + str( height ) + ", " +  str( widthPacked ) + "; height, width\n"
		asm += BytesToAsmTiled(data)
		asm += "\n"

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

		print(f"back: {source_path} got exported.")
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

	png_path = source_dir + source_j["png_path"]
	image = Image.open(png_path)

	_, colors = common.palette_to_asm(image, source_j)

	image = common.remap_colors(image, colors)

	asm = "; " + source_j_path + "\n"
	asmAnims = asm + AnimsToAsm(source_name, source_j)
	asmSprites = asm + f"__RAM_DISK_S_{source_name.upper()} = RAM_DISK_S" + "\n"
	asmSprites += asm + f"__RAM_DISK_M_{source_name.upper()} = RAM_DISK_M" + "\n"
	asmSprites += SpritesToAsm("__" + source_name, source_j, image)

	# save asm
	if not os.path.exists(asm_anim_dir):
		os.mkdir(asm_anim_dir)

	with open(asm_anim_path, "w") as file:
		file.write(asmAnims)

	if not os.path.exists(asm_sprite_dir):
		os.mkdir(asm_sprite_dir)

	with open(asm_sprite_path, "w") as file:
		file.write(asmSprites)

def is_source_updated(source_j_path):
	with open(source_j_path, "rb") as file:
		source_j = json.load(file)
	
	source_dir = str(Path(source_j_path).parent) + "\\"
	png_path = source_dir + source_j["png_path"]

	if build.is_file_updated(source_j_path) | build.is_file_updated(png_path):
		return True
	return False


