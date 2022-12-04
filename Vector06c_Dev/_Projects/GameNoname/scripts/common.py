import os

def PaletteToAsm(image, charJ, path = "", labelPrefix = ""):
	# usially there are color tiles in top row in the image.
	paletteCoords = charJ["palette"]
	colors = {}
	pathWOExt = os.path.splitext(path)[0]
	labelPostfix = os.path.basename(pathWOExt)
	asm = "; " + path + "\n"
	asm += labelPrefix + "_palette_" + labelPostfix + ":\n"
	palette = image.getpalette()

	for i, pos in enumerate(paletteCoords):
		x = pos["x"]
		y = pos["y"]
		idx = image.getpixel((x, y))
		r = palette[idx * 3]
		g = palette[idx * 3 + 1]
		b = palette[idx * 3 + 2]
		colors[(r, g, b)] = i
		r = r >> 5
		g = g >> 5
		g = g << 3
		b = b >> 6
		b = b << 6
		color = b | g | r
		if i % 4 == 0 : asm += "			.byte "
		asm += "%" + format(color, '08b') + ", "
		if i % 4 == 3 : asm += "\n"
		
	return asm + "\n", colors

def  RemapColors(image, colors):
	palette = image.getpalette()
	colorMatchingTable = {}
	
	for idx in range(len(palette) //3):
		r = palette[idx*3]
		g = palette[idx*3 + 1]
		b = palette[idx*3 + 2]
		rgb = (r,g,b)
		if rgb not in colors: 
			continue
		cidx = colors[rgb]
		colorMatchingTable[idx] = cidx
	
	w = image.width
	h = image.height

	for y in range(h) :
		for x in range(w) :
			colorIdx = image.getpixel((x, y))
			newColorIdx = colorMatchingTable[colorIdx]
			image.putpixel((x,y), newColorIdx)
	return image

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

def IndexesToBitLists(tileImg):
	bits0 = [] # 8000-9FFF # from left to right, from bottom to top
	bits1 = [] # A000-BFFF
	bits2 = [] # C000-DFFF
	bits3 = [] # E000-FFFF
	for line in tileImg:
		for colorIdx in line:
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

def IsBytesZeros(bytes):
	for byte in bytes: 
		if byte != 0 : return False
	return True

def BytesToAsm(data):
	asm = "			.byte "
	for i, byte in enumerate(data):
		asm += str(byte) + ","
	return asm + "\n"

def RunCommand(command, comment = "", checkPath = ""):
	if comment != "" : 
		print(comment)
	if checkPath == "" or os.path.isfile(checkPath):
		os.system(command)
	else:
		print(f"command {command} is failed. file {checkPath} doesn't exist")

def DeleteFile(path):
	if os.path.isfile(f"{path}"):
		os.remove(f"{path}")

def str2bool(v):
    if isinstance(v, bool):
        return v
    if v.lower() in ('yes', 'true', 't', 'y', '1'):
        return True
    else:
        return False

def RemoveDoubleSlashes(path):
	res = ""
	doubledSlashe = False
	for char in path:
		if char != '\\':
			res += char
			doubledSlashe = False
		else:
			if doubledSlashe == False:
				res += char
				doubledSlashe = True
			else:
				doubledSlashe = False
	return res

def DoubleSleshes(path):
	res = ""
	for char in path:
		res += char
		if char == '\\':
			res += char
	return res