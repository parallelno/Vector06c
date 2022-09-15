from xmlrpc.client import Boolean
from PIL import Image
import json
import common

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

def SpriteData(bytes1, bytes2, bytes3, w, h, maskBytes = None):
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

	return data

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
		asm += "			.word "
		for spriteName in charJ["anims"][animName]:
			asm += labelPrefix + "_" + spriteName + ", "
		asm += "\n"
	return asm

def SpritesToAsm(charJ, image, addSize, addMask):
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
			maskData = MaskData(maskBytes, width, height)

		# to support a sprite render function
		data = SpriteData(bytes1, bytes2, bytes3, width, height, maskBytes)
		#data = SpriteData(bytes1, bytes2, bytes3, width, height)

		asm += "\n"
		# two empty bytes prior every to support a stack renderer
		asm += "			.byte 0,0  ; safety pair of bytes to support a stack renderer\n"
		asm += labelPrefix + "_" + spriteName + ":\n"

		if addSize:
			widthPacked = width//8 - 1
			offsetXPacked = offsetX//8
			widthOffsetXpacked = widthPacked << 1 | offsetXPacked | offsetY << 3
			asm += "			.byte " + str( height ) + ", " +  str( widthOffsetXpacked ) + "; height, widthOffsetXpacked\n"
		
		asm += common.BytesToAsm(data)

	return asm

#=====================================================
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
'''
addSize = True
addMask = True
charJPath = "sources\\sprites\\skeleton.json"
asmAnimPath = ""
asmSpritePath = ""
'''

with open(charJPath, "rb") as file:
	charJ = json.load(file)

pngPath = str(charJ["png"])
image = Image.open(pngPath)

_, colors = common.PaletteToAsm(image, charJ, charJPath)

image = common.RemapColors(image, colors)

asm = "; " + charJPath + "\n"
asmAnims = asm + AnimsToAsm(charJ, charJPath)
asmSprites = asm + SpritesToAsm(charJ, image, addSize, addMask)

# save asm
with open(asmAnimPath, "w") as file:
	file.write(asmAnims)

with open(asmSpritePath, "w") as file:
	file.write(asmSprites) 
