from asyncio.windows_events import NULL
from msilib import sequence
from PIL import Image
import numpy as np
from collections import OrderedDict

CODE_ZERO = 0
CODE_UNIQUE = 1
CODE_DUPS = -1

fileName = "tiles"
importPNGName = "sources/" + fileName + ".png"
exportPngName = "sources/" + fileName + "_vector.png"
exportAsmName = fileName + ".asm"

exportPNG = True
exportPNGRoundUpColors = True

printOrigPalette = True
printAdaptedPalette = True
printColorArray = False

MAX_COLOR_IDX = 15
#----------------------------------------------------
def GetActivePalette(_imagePng):
	colorIdxList = []
	w, h = _imagePng.size
	for x in range(w):
		for y in range(h):
			coord = (x, y)
			colorIdx = _imagePng.getpixel(coord)
			if colorIdx not in colorIdxList:
				colorIdxList.append(colorIdx)

	palette = _imagePng.getpalette()
	activePalette = list()
	for colorIdx in colorIdxList:
		r = palette[colorIdx * 3 + 0]
		g = palette[colorIdx * 3 + 1]
		b = palette[colorIdx * 3 + 2]
		rgb = (r, g, b)
		activePalette.append([colorIdx, rgb])
	return activePalette

def GetPaletteSize(_imagePng):
	return len(GetActivePalette(_imagePng))

def PrintPalette(_title, _imagePng):
	print(_title)
	activePalette = GetActivePalette(_imagePng)
	for color in activePalette:
		colorIdx, rgb = color
		print (f"{colorIdx}, {rgb}")
	print()

def PrintImageData(_imagePng):
	print()
	print("Color indexes:")
	
	w, h = _imagePng.size
	
	for x in range(w):
		lineStr = ""
		for y in range(h):
			coord = (x, y)
			lineStr += str(_imagePng.getpixel(coord)) + ", "
		print(x, lineStr)

def AdaptPalette(_imagePng):
	palette = _imagePng.getpalette()
	for i in range(len(palette) // 3):
		r = palette[i*3+0]
		g = palette[i*3+1]
		b = palette[i*3+2]

		rr = round(float(r) / 32, 0)
		r = int(rr)
		gg = round(float(g) / 32, 0)
		g = int(gg)
		bb = round(float(b) / 64, 0)
		b = int(bb)

		r *= 32
		g *= 32
		b *= 64

		palette[i*3+0] = min(r, 255)
		palette[i*3+1] = min(g, 255)
		palette[i*3+2] = min(b, 255)
	_imagePng.putpalette(palette)
	return _imagePng

def RemoveColorDups(_imagePng) :
	activePalette = GetActivePalette(_imagePng) # [[colorIdx, rgb],..]

	# reformat active palette to [[rgb : [colorIdx1, colorIdx2..]]..]
	uniqueColors = OrderedDict()
	uniqueColorsCounter = 0

	for i in range(len(activePalette)):
		oldColorIdx, rgb = activePalette[i]

		if rgb not in uniqueColors :
			uniqueColors[rgb] = [(oldColorIdx, uniqueColorsCounter)]
			uniqueColorsCounter += 1
		else : 
			newColorIdx = uniqueColors[rgb][0][1]
			uniqueColors[rgb].append((oldColorIdx, newColorIdx))

	# copy colors from uniqueColors to the palette
	i = 0
	palette = _imagePng.getpalette()
	for rgb in uniqueColors:
		r, g, b = rgb
		palette[i*3+0] = r
		palette[i*3+1] = g
		palette[i*3+2] = b
		i += 1

	_imagePng.putpalette(palette)
	# print("uniqueColors")
	# print(uniqueColors)
	
	# print (f"palette after removing dups:\n")
	# print(_imagePng.getpalette())
	
	# make color index replacement list
	colorIndexReplacentList = dict()
	for rgb in uniqueColors :
		for replacementPair in uniqueColors[rgb]:
			oldColorIdx, newColorIdx = replacementPair
			colorIndexReplacentList[oldColorIdx] = newColorIdx

	# replace color idx dups in the  image 
	w, h = _imagePng.size
	for x in range(w):
		#msgLine = ""
		for y in range(h):
			coord = (x, y)
			colorIdx = _imagePng.getpixel(coord)
			newColorIdx = colorIndexReplacentList[colorIdx]
			_imagePng.putpixel(coord, newColorIdx)
			#msgLine += f"{newColorIdx}, "
		#print (msgLine + "\n")

	return _imagePng

def PaletteToAsm(_imagePng, _labelPrefix):
	asm = _labelPrefix + "Palette:\n"
	palette = _imagePng.getpalette()

	for i in range(GetPaletteSize(_imagePng)):
		r = palette[i*3+0]
		g = palette[i*3+1]
		b = palette[i*3+2]
		r = r >> 5
		g = g >> 5
		g = g << 3
		b = b >> 6
		b = b << 6
		color = b | g | r
		if i % 4 == 0 : asm += "			.byte "
		asm += "%" + format(color, '08b') + ", "
		if i % 4 == 3 : asm += "\n"
		
	return asm + "\n"

def SizeToAsm(_imagePng, _labelPrefix):
	w, h = _imagePng.size
	asm = _labelPrefix + "Size:\n" + "			.byte " + str(w) + ", " + str(h) + "\n\n"
	return asm

colorIndexToBit = [
		(0,0,0,0), # color idx = 0
		(0,0,0,1),
		(0,0,1,0), # color idx = 2
		(0,0,1,1),
		(0,1,0,0), # color idx = 4
		(0,1,0,1),
		(0,1,1,0),
		(0,1,1,1),
		(1,0,0,0), # color idx = 8
		(1,0,0,1),
		(1,0,1,0),
		(1,0,1,1),
		(1,1,0,0),
		(1,1,0,1),
		(1,1,1,0),
		(1,1,1,1),
	]

def IndexesToBitLists(_imagePng):
	w, h = _imagePng.size	
	bits0 = [] # 8000-9FFF # from left to right, from bottom to top
	bits1 = [] # A000-BFFF
	bits2 = [] # C000-DFFF
	bits3 = [] # E000-FFFF
	for y in range(h):
		for x in range(w):
			coord = (x, h-y-1) # flip over Y, because png from top to bottom
			colorIdx = _imagePng.getpixel(coord)
			bit0, bit1, bit2, bit3 = colorIndexToBit[colorIdx]
			bits0.append(bit0) 
			bits1.append(bit1)
			bits2.append(bit2)
			bits3.append(bit3)
	return bits0, bits1, bits2, bits3

def CombineBitsToBytes(_bits):
	bytes = []
	i = 0
	while i < len(_bits):
		byte = 0
		for j in range(8):
			byte += _bits[i] << 7-j
			i += 1
		bytes.append(byte)
	return bytes

def RearrangeBytesToListVlines(_bytes, _w, _h):
	listVLines = []
	for x in range(_w // 8):
		vline = []
		for y in range(_h):
			i = y * (_w // 8) + x
			vline.append(_bytes[i])
		listVLines.append(vline)
	return listVLines

def MakeRepeatCode(_length, _isUniqueBytes):
	code = _length << 1
	if _isUniqueBytes : code += 1
	return code


def ExtractSequence(_line, _i):
	lineLength = len(_line)
	firstByte = _line[_i]
	_i += 1
	if _i == lineLength :
		return CODE_UNIQUE, [_line[-1]]

	# check if the sequence has dups
	secondByte = _line[_i]
	_i += 1
	sequence = [firstByte, secondByte]

	if (firstByte == secondByte 
	    and _i < lineLength
	    and firstByte == _line[_i]):
	    # process duplicates. the length 3 is minimum
		while (_i < lineLength 
		    and firstByte == _line[_i]):
			sequence.append(_line[_i])
			_i += 1
		if sequence[0] == 0:
			return CODE_ZERO, sequence
		return CODE_DUPS, sequence

	# process unique bytes
	# if there are first unique and the next two or more dups, 
	# return only first to let next bytes be combined
	if (_i < lineLength
	    and secondByte == _line[_i]) :
		return CODE_UNIQUE, [firstByte]
	# continue process uniques
	while (_i < lineLength
	    and _line[_i-1] != _line[_i]):
		sequence.append( _line[_i])
		_i += 1

	return CODE_UNIQUE, sequence

def MakeChunk(code, _sequence):
	if code == CODE_UNIQUE:
		chunk = [MakeRepeatCode(len(_sequence), True)]
		chunk.extend(_sequence)
		return chunk

	return [MakeRepeatCode(len(_sequence), False), _sequence[0]]

def ListVLinesToRle(_listVLines, _x, _y):
	REPEAT_CODE_END_LINE = 0
	rle = []
	for line in _listVLines:
		sequences = []
		# convert vertical line byte data into sequences
		i = 0
		while i < len(line):
			code, sequence = ExtractSequence(line, i)
			sequences.append((code, sequence))
			i += len(sequence)

		# remove firsts consecutive zero sequences
		sequences2 = []
		firstZeros = True
		vOffset = 0
		for code, sequence in sequences:
			if code != CODE_ZERO: 
				firstZeros = False
			if firstZeros and code == CODE_ZERO:
				# calculate a vertical offset
				vOffset += len(sequence)
				continue
			sequences2.append((code, sequence))

		# remove last consecutive zero sequences
		sequences3 = []
		firstZeros = True
		for i in range(len(sequences2)):
			code, sequence = sequences2[-1-i]
			if code != CODE_ZERO: 
				firstZeros = False
			if firstZeros and code == CODE_ZERO:
				continue
			sequences3.insert(0, (code, sequence))

		# combine all consecutive unique sequences
		sequences4 = []
		uniqueSequence = []
		i = 0
		while i < len(sequences3):
			code, sequence = sequences3[i]
			if code != CODE_UNIQUE:
				if len( uniqueSequence) != 0:
					sequences4.append((CODE_UNIQUE, uniqueSequence))
					uniqueSequence = []
				sequences4.append((code, sequence))
			else:
				uniqueSequence.extend(sequence)
			i += 1
		# add an unique sequence if there is left any
		if len( uniqueSequence) != 0:
			sequences4.append((CODE_UNIQUE, uniqueSequence))
		# split sequences into 127 parts
		sequences5 = []
		for code, sequence in sequences4:
			while len(sequence) >= 127:
				s = sequence[0:127]
				del sequence[0:127]
				sequences5.append((code, s))
			if len(sequence) != 0:
				sequences5.append((code, sequence))

		sequences = sequences5
		# add the screen addr
		chunks = [_x, _y + vOffset]
		_x += 1
		# if there is no chunks added, continue
		if len(sequences) == 0: continue
		
		# copy sequenes into chunks
		for code, sequence in sequences:
			chunks.extend(MakeChunk(code, sequence))
		# add the end of the line code
		chunks.append(REPEAT_CODE_END_LINE)
		rle.append(chunks)

	return rle

def PrintRleLines(_rleLines):
	size = 0
	asm = ""
	for line in _rleLines:
		asm += "			.byte "
		for byte in line:
			asm += str(byte) + ","
			size += 1
		asm += "\n"
	return asm, size

# the format description is in drawRle.asm
def ImageToAsm(_imagePng, _labelPrefix, _x, _y):
	# TODO: analize the color index popularity in the image.
	# swap the most popular color idx with 0 color idx.
	# the next popular color idx swap with 2 color idx.
	# the next popular color idx swap with 4 color idx.
	# the next popular color idx swap with 8 color idx.

	# _x - screen X, 0 - 31, left image side
	# _y - screen Y, 0 - 255, bottom image side
	
	# convert indexes into bit lists.
	bits0, bits1, bits2, bits3 = IndexesToBitLists(_imagePng)

	# combite bits into byte lists
	bytes0 = CombineBitsToBytes(bits0) # 8000-9FFF # from left to right, from bottom to top
	bytes1 = CombineBitsToBytes(bits1) # A000-BFFF
	bytes2 = CombineBitsToBytes(bits2) # C000-DFFF
	bytes3 = CombineBitsToBytes(bits3) # E000-FFFF

	# rearrange bytes from left to right, from bottom to top
	# to the list of vertical lines of bytes
	w, h = _imagePng.size
	listVLines0 = RearrangeBytesToListVlines(bytes0, w, h) # 8000-9FFF from bottom to top
	listVLines1 = RearrangeBytesToListVlines(bytes1, w, h) # A000-BFFF
	listVLines2 = RearrangeBytesToListVlines(bytes2, w, h) # C000-DFFF
	listVLines3 = RearrangeBytesToListVlines(bytes3, w, h) # E000-FFFF

	# pack bytes into vertical RLEs lines.
	rleLines = ListVLinesToRle(listVLines0, _x + 0x80, _y)
	rleLines.extend( ListVLinesToRle(listVLines1, _x + 0xA0, _y))
	rleLines.extend( ListVLinesToRle(listVLines2, _x + 0xC0, _y))
	rleLines.extend( ListVLinesToRle(listVLines3, _x + 0xE0, _y))
	# combine all vertical RLEs into one sequence
    
	asm, size = PrintRleLines(rleLines)
	asm = f"{_labelPrefix}:\n" + asm
	# add the end of the image code
	asm += "			.byte 0\n"
	size += 1 # count the end of the image code
	originalImageDataSize = (w // 8) * h * 4

	# save bin file
	with open('img.bin', "wb") as file:
		x = 0x80
		y = 0
		binData = []
		for line in listVLines0:
			#binData.extend([x, y])
			binData.extend(line)
			x += 1
		x = 0xa0
		for line in listVLines1:
			#binData.extend([x, y])
			binData.extend(line)
			x += 1
		x = 0xc0
		for line in listVLines2:
			#binData.extend([x, y])
			binData.extend(line)
			x += 1
		x = 0xe0
		for line in listVLines3:
			#binData.extend([x, y])
			binData.extend(line)
			x += 1
		#binData.append(0)
		br = bytearray(binData)
		print (len(br))
		file.write(br)
	# dave rle bin file
	#with open('rle.bin', "wb") as file:
		#binData = []
		#for line in rleLines:
			#binData.extend(line)
		#binData.append(0)
		#br = bytearray(binData)
		#print(len(binData))
		#file.write(br)


	print(f"original image data : {originalImageDataSize} bytes, RLE compressed image: {size} bytes.")
	print(f"compressed size: {size/ originalImageDataSize * 100}%.\n")


	return asm
			
	 

#--------------------------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------------------------
imagePng = Image.open(importPNGName)
print()
#ERRORs/WARNINGs
w, h = imagePng.size
if (w % 8 != 0) :
	print ("ERROR. Width is not multiple of 8\n")

# original data

paletteSize = GetPaletteSize(imagePng)
print(f"paletteSize: {paletteSize}\n")
PrintPalette("Original palette:", imagePng)
if printColorArray :
	PrintImageData(imagePng)

# convert the palette to vector06C specific one
print("Adapting the palette to vector06C specifics.\n")
imagePng2 = AdaptPalette(imagePng)
PrintPalette("Adapted palette:", imagePng2)


# after color adaptation there can be color dups. remove them
print(f"Remove color duplicates.\n")
imagePng3 = RemoveColorDups(imagePng2)
PrintPalette("Palette after removing dups:", imagePng)

# export to PNG
if exportPNGRoundUpColors: 
	imagePng3.save(exportPngName,"PNG")
	print (f"Adapted PNG is saved to {exportPngName}\n")

#ERRORs
paletteSizeAdapted = GetPaletteSize(imagePng)
if (paletteSizeAdapted > MAX_COLOR_IDX) :
	print(f"ERROR. paletteSizeAdapted is {paletteSizeAdapted}. Vector06C supports only {MAX_COLOR_IDX}\n")

# converting to asm
labelPrefix = exportAsmName[0 : -4].split("/")[-1].split("\\")[-1]
asmPalette = PaletteToAsm(imagePng, labelPrefix)
print(f"asmPalette: \n{asmPalette}")

#asmSize = SizeToAsm(imagePng, labelPrefix)
#print(f"asmSize: \n{asmSize}")

asmImage = ImageToAsm(imagePng, labelPrefix, 0, 0)
#print(f"asmImage: \n{asmImage}")

print(asmPalette + asmImage, file = open(exportAsmName, 'w') )

