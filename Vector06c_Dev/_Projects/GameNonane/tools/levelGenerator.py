from PIL import Image
import json
import common

def RoomToAsm(roomJ, roomPath, remapIdxs):
	asm = "; " + roomPath + "\n"
	labelPrefix = roomPath.split("/")[-1].split("\\")[-1].split(".")[0]
	asm += labelPrefix + ":\n"
	width = roomJ["layers"][0]["width"]
	height = roomJ["layers"][0]["height"]

	for i, tidx in enumerate(roomJ["layers"][0]["data"]):
		if i % width == 0 : asm += "			.byte "
		asm += str(remapIdxs[tidx]) + ", "
		if i % width == width-1 : asm += "\n"
	return asm

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
	
def TilesToAsm(roomJ, image, path, remapIdxs):
	size = 0
	asm = "; " + path + "\n"
	labelPrefix = path.split("/")[-1].split("\\")[-1].split(".")[0]

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

		asm += "tile" + str(remapIdxs[tidx]) + ":\n"
		asm += "			.byte " + str(mask) + "\n"
		# two empty bytes prior every to support a stack renderer
		asm += "			.byte 0,0\n"		
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

def GetListOfRooms(roomPaths):
	size = 0
	asm = "roomsAddr:\n			.word "
	for roomPathP in roomPaths:
		roomPath = roomPathP['file']
		labelPrefix = roomPath.split("/")[-1].split("\\")[-1].split(".")[0]
		asm += labelPrefix + ", "
		size += 2
	asm += "\n"
	return asm, size

def GetListOfTiles(remapIdxs):
	size = 0
	asm = "tilesAddr:\n			.word "
	for tidx in remapIdxs:
		asm += "tile" + str(remapIdxs[tidx]) + ", "
		size += 2
	asm += "\n"
	return asm, size

#=====================================================


levelJPath = "sources/level01.json"
asmLevelPath = "levels/level01.dasm"

with open(levelJPath, "rb") as file:
	levelJ = json.load(file)

pngPath = str(levelJ["png"])
image = Image.open(pngPath)
asm, colors = common.PaletteToAsm(image, levelJ, pngPath)
dataSize = 16
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

# list of rooms
asmL, size = GetListOfRooms(roomPaths)
asm += asmL
dataSize += size
# list of tiles addreses
asmLT, size = GetListOfTiles(remapIdxs)
asm += asmLT
dataSize += size
# every room data
for i, roomJ in enumerate(roomsJ):
	#asm += RoomTilesAddrToAsm(roomJ, roomPaths[i]['file'], remapIdxs)
	asm += RoomToAsm(roomJ, roomPaths[i]['file'], remapIdxs)

# tile art data to asm
asmT, size = TilesToAsm(roomsJ[0], image, pngPath, remapIdxs)
asm += asmT
dataSize += size

# save asm
with open(asmLevelPath, "w") as file:
	file.write(asm)

print(f"dataSize: {dataSize}")






