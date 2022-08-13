import string
from xmlrpc.client import Boolean
from PIL import Image
import json
import common

def SpriteData(bytes1, bytes2, bytes3, w, height):
	# sprite data structure description is in drawSprite.asm
	# sprite uses only 3 out of 4 screen buffers.
	# the width is devided by 8 because there is 8 pixels per a byte
	width = w // 8
	#mask = 0
	data = []
	for y in range(height):
		#mask >>=  1
		#if common.IsBytesZeros(bytes):
		#	continue
		#mask += 8
		evenLine = y % 2 == 0
		if evenLine:
			for x in range(width):
				i = y*width+x
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

	return data#, mask

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

def CharToAsm(charJ, image):
	labelPrefix = charJPath.split("/")[-1].split("\\")[-1].split(".")[0]
	spritesJ = charJ["sprites"]
	asm = ""

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
				#x += 1
			spriteImg.append(line)
			#y += 1
		
		# convert indexes into bit lists.
		bits0, bits1, bits2, bits3 = common.IndexesToBitLists(spriteImg)

		# combite bits into byte lists
		bytes0 = common.CombineBitsToBytes(bits0) # 8000-9FFF # from left to right, from bottom to top
		bytes1 = common.CombineBitsToBytes(bits1) # A000-BFFF
		bytes2 = common.CombineBitsToBytes(bits2) # C000-DFFF
		bytes3 = common.CombineBitsToBytes(bits3) # E000-FFFF

		# to support a sprite render function
		data = SpriteData(bytes1, bytes2, bytes3, width, height)

		# two empty bytes prior every to support a stack renderer
		asm += "			.byte 0,0\n"
		asm += labelPrefix + "_" + spriteName + ":\n"

		if addSize:
			widthPacked = width//8 - 1
			offsetXPacked = offsetX//8
			widthOffsetXpacked = widthPacked << 1 | offsetXPacked | offsetY << 3
			asm += "			.byte " + str( height ) + ", " +  str( widthOffsetXpacked ) + "\n"
		
		#asm += "			.byte " + str(mask) + "\n"
		asm += common.BytesToAsm(data)

	return asm

#=====================================================
import argparse
parser = argparse.ArgumentParser()
parser.add_argument("-s", "--size", help = "Size and a screen addr are included in the sprite data", type = Boolean)
parser.add_argument("-i", "--input", help = "Input file")
parser.add_argument("-o", "--output", help = "Output file")
args = parser.parse_args()

addSize = False
if args.size :
	addSize = True

if not args.output and not args.input:
	print("-i and -o command-line parameters needed. Use -h for help.")
	exit()
charJPath = args.input
asmCharPath = args.output

with open(charJPath, "rb") as file:
	charJ = json.load(file)

pngPath = str(charJ["png"])
image = Image.open(pngPath)

asm = "; " + charJPath + "\n"

_, colors = common.PaletteToAsm(image, charJ, charJPath)

image = common.RemapColors(image, colors)

asm = AnimsToAsm(charJ, charJPath)

# char data to asm
asm += CharToAsm(charJ, image)

# save asm
with open(asmCharPath, "w") as file:
	file.write(asm)

