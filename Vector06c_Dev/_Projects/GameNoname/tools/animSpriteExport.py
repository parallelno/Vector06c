from xmlrpc.client import Boolean, boolean
from PIL import Image
import json
import tools.common as common
import tools.build as build

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

def AnimsToAsm(charJ, charJPath):
	asm = ""
	labelPrefix = charJPath.split("/")[-1].split("\\")[-1].split(".")[0]

	# preshifted sprites
	preshiftedSprites = charJ["preshifted_sprites"]
	asm += labelPrefix + "_preshifted_sprites:\n"
	asm += f"			.byte " + str(preshiftedSprites) + "\n"


	# make a list of animNames
	asm += labelPrefix + "_anims:\n"
	asm += "			.word "
	for animName in charJ["anims"]:
		asm += labelPrefix + "_" + animName + ", "
	asm += "0, \n"

	# make a list of sprites for an every anim
	for animName in charJ["anims"]:

		asm += labelPrefix + "_" + animName + ":\n"
 
		for i, frame in enumerate(charJ["anims"][animName]):

			if i < len(charJ["anims"][animName])-1:
				nextFrameOffset = preshiftedSprites * 2 # every frame consists of preshiftedSprites pointers
				nextFrameOffset += 1 # increase the offset to save one instruction in the game code
				asm += "			.byte " + str(nextFrameOffset) + ", 0 ; offset to the next frame\n"
			else:
				offsetAddr = 1
				nextFrameOffsetLow = 255 - (len(charJ["anims"][animName]) -1) * (preshiftedSprites + offsetAddr) * 2 + 1
				nextFrameOffsetLow -= 1 # decrease the offset to save one instruction in the game code
				if nextFrameOffsetLow == 0:
					nextFrameOffsetHiStr = "0"
				else:
					nextFrameOffsetHiStr = "$ff"
				asm += "			.byte " + str(nextFrameOffsetLow) + ", " + nextFrameOffsetHiStr + " ; offset to the first frame\n"

			asm += "			.word "
			for i in range(preshiftedSprites):
				asm += labelPrefix + "_" + str(frame) + "_" + str(i) + ", "
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
			if colorIdx != mask_alpha:
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

def MakeEmptySpriteData(addMask, width, height):
	srcBuffCount = 3
	data = []
	for dy in range(height):
		for dx in range(width // 8 * srcBuffCount):		
			if addMask:
				data.append(255)
			data.append(0)

	return [data]

def SpritesToAsm(charJPath, charJ, image, addMask):
	labelPrefix = charJPath.split("/")[-1].split("\\")[-1].split(".")[0]
	spritesJ = charJ["sprites"]
	asm = labelPrefix + "_sprites:"

	# preshifted sprites
	preshiftedSprites = charJ["preshifted_sprites"]

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
		bits0, bits1, bits2, bits3 = common.IndexesToBitLists(spriteImg)

		# combite bits into byte lists
		#bytes0 = common.CombineBitsToBytes(bits0) # 8000-9FFF # from left to right, from bottom to top
		bytes1 = common.CombineBitsToBytes(bits1) # A000-BFFF
		bytes2 = common.CombineBitsToBytes(bits2) # C000-DFFF
		bytes3 = common.CombineBitsToBytes(bits3) # E000-FFFF

		mask_alpha = sprite["mask_alpha"]
		mask_color = sprite["mask_color"]

		maskBytes = None
		if addMask:
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

			maskBytes = common.CombineBitsToBytes(maskImg)

		# to support a sprite render function
		data = SpriteData(bytes1, bytes2, bytes3, width, height, maskBytes)

		if addMask:
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

		asm += BytesToAsmTiled(data)

 
		# find leftest pixel dx
		dxL = FindSpriteHorizBorder(True, spriteImg, mask_alpha, width, height)
		# find rightest pixel dx
		dxR = FindSpriteHorizBorder(False, spriteImg, mask_alpha, width, height) 

		# calculate preshifted sprite data
		for i in range(1, preshiftedSprites):
			shift = 8//preshiftedSprites * i

			offsetXPreshiftedLocal, widthPreshifted = GetSpriteParams(labelPrefix, spriteName, dxL, dxR, spriteImg, mask_alpha, width, height, shift)
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

			emptyData = MakeEmptySpriteData(addMask, widthPreshifted, height)
			asm += BytesToAsmTiled(emptyData)

	return asm

def Export(addMask : bool, charJPath, asmAnimPath, asmSpritePath):

	with open(charJPath, "rb") as file:
		charJ = json.load(file)

	pngPath = str(charJ["png"])
	image = Image.open(pngPath)

	_, colors = common.PaletteToAsm(image, charJ, charJPath)

	image = common.RemapColors(image, colors)

	asm = "; " + charJPath + "\n"
	asmAnims = asm + AnimsToAsm(charJ, charJPath)
	asmSprites = asm + SpritesToAsm(charJPath, charJ, image, addMask)

	# save asm
	with open(asmAnimPath, "w") as file:
		file.write(asmAnims)

	with open(asmSpritePath, "w") as file:
		file.write(asmSprites)

def IsFileUpdated(charJPath):
	with open(charJPath, "rb") as file:
		charJ = json.load(file)
	
	pngPath = str(charJ["png"])

	if build.IsFileUpdated(charJPath) | build.IsFileUpdated(pngPath):
		return True
	return False


