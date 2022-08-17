from PIL import Image
import json
import common

def RoomTilesToAsm(roomJ, roomPath, remapIdxs):
	asm = "; " + roomPath + "\n"
	labelPrefix = roomPath.split("/")[-1].split("\\")[-1].split(".")[0]
	asm += labelPrefix + ":\n"
	width = roomJ["width"]
	height = roomJ["height"]
	size = width * height

	for i, tidx in enumerate(roomJ["data"]):
		if i % width == 0 : asm += "			.byte "
		asm += str(remapIdxs[tidx]) + ", "
		if i % width == width-1 : asm += "\n"
	return asm, size

def RoomTilesDataToAsm(roomJ, roomPath):
	asm = "; " + roomPath + "\n"
	labelPrefix = roomPath.split("/")[-1].split("\\")[-1].split(".")[0]
	asm += labelPrefix + "_tilesData:\n"
	width = roomJ["width"]
	height = roomJ["height"]
	size = width * height

	for i, tidx in enumerate(roomJ["data"]):
		if i % width == 0 : asm += "			.byte "
		asm += str(tidx) + ", "
		if i % width == width-1 : asm += "\n"
	return asm, size

def RoomTilesAddrToAsm(roomJ, roomPath, remapIdxs):
	asm = "; " + roomPath + "\n"
	labelPrefix = roomPath.split("/")[-1].split("\\")[-1].split(".")[0]
	asm += "addr_" + labelPrefix + ":\n"
	width = roomJ["layers"][0]["width"]
	height = roomJ["layers"][0]["height"]

	for i, tidx in enumerate(roomJ["layers"][0]["data"]):
		if i % width == 0 : asm += "			.word "
		asm += "tile" + str(remapIdxs[tidx]) + ", "
		if i % width == width-1 : asm += "\n"
	return asm

def TileData(bytes0, bytes1, bytes2, bytes3):
	allBytes = [bytes0, bytes1, bytes2, bytes3]
	# data structure description is in drawTile.asm
	mask = 0
	data = []
	for bytes in allBytes:
		mask >>=  1
		if common.IsBytesZeros(bytes) : 
			continue
		mask += 8

		x = 0
		for y in range(16):
			byte = bytes[y * 2 + x]
			data.append(byte)
		x = 1
		for y in reversed(range(16)):
			byte = bytes[y * 2 + x]
			data.append(byte)

	return data, mask
	
def TilesToAsm(roomJ, image, path, remapIdxs, labelPrefix):
	size = 0
	asm = "; " + path + "\n"
	asm += labelPrefix + "_tiles:\n"

	tileW = roomJ["tilewidth"]
	tileH = roomJ["tileheight"]
	
	width = roomJ["layers"][0]["width"]
	height = roomJ["layers"][0]["height"]
	
	# extract tile images and convert them into asm
	for tidx in remapIdxs:
		# get a tile as a color index 2d array
		tileImg = []
		idx = tidx - 1
		sx = idx % width * tileW
		sy = idx // width * tileH
		for y in range(sy, sy + tileH) :
			line = []
			for x in range(sx, sx+tileW) :
				colorIdx = image.getpixel((x, y))
				line.append(colorIdx)
				#x += 1
			tileImg.append(line)
			#y += 1
		
		# convert indexes into bit lists.
		bits0, bits1, bits2, bits3 = common.IndexesToBitLists(tileImg)

		# combite bits into byte lists
		bytes0 = common.CombineBitsToBytes(bits0) # 8000-9FFF # from left to right, from bottom to top
		bytes1 = common.CombineBitsToBytes(bits1) # A000-BFFF
		bytes2 = common.CombineBitsToBytes(bits2) # C000-DFFF
		bytes3 = common.CombineBitsToBytes(bits3) # E000-FFFF

		# to support a tile render function
		data, mask = TileData(bytes0, bytes1, bytes2, bytes3)


		# two empty bytes prior every data to support a stack renderer
		asm += "			.byte 0,0 ; safety pair of bytes to support a stack renderer\n"
		asm += labelPrefix + "_tile" + str(remapIdxs[tidx]) + ":\n"
		asm += "			.byte " + str(mask) + " ; mask\n"
		asm += "			.byte 4 ; counter\n"
		asm += common.BytesToAsm(data)
		size += len(data)

	return asm, size

def RemapIndex(roomsJ):
	uniqueIdxs = [] # old idx : new idx
	for roomJ in roomsJ:
		for idx in roomJ["layers"][0]["data"]:
			if idx in uniqueIdxs:
				continue
			uniqueIdxs.append(idx)
	remapIdxs = {} # old idx : new idx
	for i, idx in enumerate(uniqueIdxs):
		remapIdxs[idx] = i
	
	return remapIdxs

def GetListOfRooms(roomPaths, labelPrefix):
	size = 0
	asm = "\n			.byte 0,0 ; safety pair of bytes to support a stack renderer\n"
	asm += labelPrefix + "_roomsAddr:\n			.word "
	for roomPathP in roomPaths:
		roomPath = roomPathP['file']
		labelPrefix = roomPath.split("/")[-1].split("\\")[-1].split(".")[0]
		asm += labelPrefix + ", "
		size += 2
	asm += "\n"
	return asm, size

def GetListOfTiles(remapIdxs, levelAsmName, pngLabelPrefix):
	size = 0
	asm = "\n			.byte 0,0 ; safety pair of bytes to support a stack renderer\n"
	asm += levelAsmName + "_tilesAddr:\n			.word "
	for tidx in remapIdxs:
		asm += pngLabelPrefix + "_tile" + str(remapIdxs[tidx]) + ", "
		size += 2
	asm += "\n"
	return asm, size

def StartPosToAsm(levelJ, labelPrefix):
	asm = ("\n			.byte 0,0 ; safety pair of bytes to support a stack renderer\n" + 
			labelPrefix + "_startPos:\n			.byte " + 
			str(levelJ["startPos"]["y"]) + ", " + 
			str(levelJ["startPos"]["x"]) + "\n")
	return asm, 4

#=====================================================
import argparse
parser = argparse.ArgumentParser()
parser.add_argument("-i", "--input", help = "Input file")
parser.add_argument("-o", "--output", help = "Output file")
args = parser.parse_args()

if not args.output and not args.input:
	print("-i and -o command-line parameters needed. Use -h for help.")
	exit()
levelJPath = args.input
levelAsmPath = args.output

with open(levelJPath, "rb") as file:
	levelJ = json.load(file)

pngPath = str(levelJ["png"])
image = Image.open(pngPath)

levelAsmName = levelAsmPath.split("/")[-1].split("\\")[-1].split(".")[0]

asm, colors = common.PaletteToAsm(image, levelJ, pngPath, levelAsmName)

dataSize = len(colors)
asmStartPos, size = StartPosToAsm(levelJ, levelAsmName)
asm += asmStartPos
dataSize += size
image = common.RemapColors(image, colors)

roomPaths = levelJ["rooms"]
roomsJ = []
# load and parse tiled map
for roomPathP in roomPaths:
	roomPath = roomPathP['file']
	with open(roomPath, "rb") as file:
		roomsJ.append(json.load(file))
	
# make a tile index remap dictionary, to have the first idx = 0
remapIdxs = RemapIndex(roomsJ)

pngLabelPrefix = pngPath.split("/")[-1].split("\\")[-1].split(".")[0]

# list of rooms
asmL, size = GetListOfRooms(roomPaths, levelAsmName)
asm += asmL
dataSize += size
# list of tiles addreses
asmLT, size = GetListOfTiles(remapIdxs, levelAsmName, pngLabelPrefix)
asm += asmLT
dataSize += size
# every room data
for i, roomJ in enumerate(roomsJ):
	asmRT, size = RoomTilesToAsm(roomJ["layers"][0], roomPaths[i]['file'], remapIdxs)
	asm += "\n			.byte 0,0 ; safety pair of bytes to support a stack renderer\n"
	asm += asmRT
	dataSize += size
	asmRTD, size = RoomTilesDataToAsm(roomJ["layers"][1], roomPaths[i]['file'])
	asm += "\n			.byte 0,0 ; safety pair of bytes to support a stack renderer\n"
	asm += asmRTD
	dataSize += size

# tile art data to asm
asmT, size = TilesToAsm(roomsJ[0], image, pngPath, remapIdxs, pngLabelPrefix)
asm += asmT
dataSize += size


# save asm
with open(levelAsmPath, "w") as file:
	file.write(asm)

print(f"levelGenerator: path: {levelAsmPath}, dataSize: {dataSize} bytes.")






