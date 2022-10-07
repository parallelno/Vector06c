from xmlrpc.client import Boolean, boolean
from PIL import Image
import json
import tools.common as common

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

def SpriteData(bytes1, bytes2, bytes3, w, h, maskBytes = None):
	# sprite data structure description is in drawSprite.asm
	# sprite uses only 3 out of 4 screen buffers.
	# the width is devided by 8 because there is 8 pixels per a byte
	width = w // 8
	#mask = 0
	data = []
	for y in reversed(range(h)):
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

def AnimsToAsm(charJ, charJPath):
	asm = ""
	labelPrefix = charJPath.split("/")[-1].split("\\")[-1].split(".")[0]
	
	# make a list of animNames
	asm += labelPrefix + "_anims:\n"
	asm += "			.word "
	for animName in charJ["anims"]:
		asm += labelPrefix + "_" + animName + ", "
	asm += "\n"

	# make a list of sprites for an every anim
	for animName in charJ["anims"]:
		
		asm += labelPrefix + "_" + animName + ":\n"
		
		for i, frame in enumerate(charJ["anims"][animName]):
			preshiftedSpriteCount = len(frame)
		
			if i < len(charJ["anims"][animName])-1:
				nextFrameOffset = preshiftedSpriteCount * 2 # every frame consists of preshiftedSprites pointers
				nextFrameOffset += 1 # increase the offset to save one instruction in the game code
				asm += "			.byte " + str(nextFrameOffset) + ", 0 ; offset to the next frame\n"
			else:
				offsetAddr = 1
				nextFrameOffsetLow = -(len(charJ["anims"][animName]) -1) * (preshiftedSpriteCount + offsetAddr) * 2 
				nextFrameOffsetLow -= 1 # decrease the offset to save one instruction in the game code
				if nextFrameOffsetLow == 0:
					nextFrameOffsetHiStr = "0"
				else:
					nextFrameOffsetHiStr = "$ff"
				asm += "			.byte " + str(nextFrameOffsetLow) + ", " + nextFrameOffsetHiStr + " ; offset to the first frame\n"

			asm += "			.word "
			for spriteName in frame:	
				asm += labelPrefix + "_" + spriteName + ", " 
			asm += "\n"
		
	return asm

def SpritesToAsm(charJPath, charJ, image, addSize, addMask):
	labelPrefix = charJPath.split("/")[-1].split("\\")[-1].split(".")[0]
	spritesJ = charJ["sprites"]
	asm = labelPrefix + "_sprites:"

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
		for py in range(y, y + height) :
			line = []
			for px in range(x, x+width) :
				colorIdx = image.getpixel((px, py))
				line.append(colorIdx)

			spriteImg.append(line)
		
		# convert indexes into bit lists.
		bits0, bits1, bits2, bits3 = common.IndexesToBitLists(spriteImg)

		# combite bits into byte lists
		#bytes0 = common.CombineBitsToBytes(bits0) # 8000-9FFF # from left to right, from bottom to top
		bytes1 = common.CombineBitsToBytes(bits1) # A000-BFFF
		bytes2 = common.CombineBitsToBytes(bits2) # C000-DFFF
		bytes3 = common.CombineBitsToBytes(bits3) # E000-FFFF

		maskBytes = None
		if addMask:
			# get a sprite as a color index 2d array
			x = sprite["mask_x"]
			y = sprite["mask_y"]
			mask_alpha = sprite["mask_alpha"]
			mask_color = sprite["mask_color"]

			maskImg = []
			for py in range(y, y + height) :
				for px in range(x, x+width) :
					colorIdx = image.getpixel((px, py))
					if colorIdx == mask_alpha:
						maskImg.append(1)
					else:
						maskImg.append(0)
		
			maskBytes = common.CombineBitsToBytes(maskImg)

		# to support a sprite render function
		data = SpriteData(bytes1, bytes2, bytes3, width, height, maskBytes)

		asm += "\n"
		# two empty bytes prior every to support a stack renderer
		asm += "			.byte 0,0  ; safety pair of bytes to support a stack renderer\n"
		asm += labelPrefix + "_" + spriteName + ":\n"

		if addSize:
			widthPacked = width//8 - 1
			offsetXPacked = offsetX//8
			asm += "			.byte " + str( offsetY ) + ", " +  str( offsetXPacked ) + "; offsetY, offsetX\n"
			asm += "			.byte " + str( height ) + ", " +  str( widthPacked ) + "; height, width\n"
		
		asm += BytesToAsmTiled(data) 

	return asm

def Export(addSize : bool, addMask : bool, charJPath, asmAnimPath, asmSpritePath):

	with open(charJPath, "rb") as file:
		charJ = json.load(file)
	
	pngPath = str(charJ["png"])
	image = Image.open(pngPath)
	
	_, colors = common.PaletteToAsm(image, charJ, charJPath)
	
	image = common.RemapColors(image, colors)
	
	asm = "; " + charJPath + "\n"
	asmAnims = asm + AnimsToAsm(charJ, charJPath)
	asmSprites = asm + SpritesToAsm(charJPath, charJ, image, addSize, addMask)
	
	# save asm
	with open(asmAnimPath, "w") as file:
		file.write(asmAnims)
	
	with open(asmSpritePath, "w") as file:
		file.write(asmSprites)

#=====================================================
"""
import argparse

parser = argparse.ArgumentParser()
parser.add_argument("-s", "--size", help = "Size and a screen addr are included in the sprite data", type = Boolean)
parser.add_argument("-m", "--mask", help = "Mask is included in the sprite data")
parser.add_argument("-i", "--input", help = "Input file")
parser.add_argument("-oa", "--outputAnim", help = "Output anim file")
parser.add_argument("-os", "--outputSprite", help = "Output sprite file")
args = parser.parse_args()

addSize = False
if args.size :
	addSize = common.str2bool(args.size)

addMask = False
if args.mask :
	addMask = common.str2bool(args.mask)

if not args.input or not args.outputAnim or not args.outputSprite:
	print("-i, -oa, and -os command-line parameters are required. Use -h for help.")
	exit()
charJPath = args.input
asmAnimPath = args.outputAnim
asmSpritePath = args.outputSprite
"""
'''
addSize = True
addMask = True
charJPath = "sources\\sprites\\skeleton.json"
asmAnimPath = ""
asmSpritePath = ""
'''



