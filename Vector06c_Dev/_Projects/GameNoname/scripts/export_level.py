import os
from PIL import Image
from pathlib import Path
import json
import common
import build

def RoomTilesToAsm(roomJ, roomPath, remapIdxs, source_dir):
	asm = "; " + source_dir + roomPath + "\n"
	roomPathWOExt = os.path.splitext(roomPath)[0]
	labelPrefix = os.path.basename(roomPathWOExt)
	asm += "__" + labelPrefix + ":\n"
	width = roomJ["width"]
	height = roomJ["height"]
	size = width * height

	for y in reversed(range(height)):
		asm += "			.byte "
		for x in range(width):
			i = y*width + x
			tidx = roomJ["data"][i]
			asm += str(remapIdxs[tidx]) + ", "
		asm += "\n"
	return asm, size

def RoomTilesDataToAsm(roomJ, roomPath, source_dir):
	asm = "; " + source_dir + roomPath + "\n"
	roomPathWOExt = os.path.splitext(roomPath)[0]
	labelPrefix = os.path.basename(roomPathWOExt)
	asm += "__" + labelPrefix + "_tilesData:\n"
	width = roomJ["width"]
	height = roomJ["height"]
	size = width * height

	for y in reversed(range(height)):
		asm += "			.byte "
		for x in range(width):
			i = y*width + x
			tidx = roomJ["data"][i]
			asm += str(tidx) + ", "
		asm += "\n"
	return asm, size

def get_tile_data(bytes0, bytes1, bytes2, bytes3):
	allBytes = [bytes0, bytes1, bytes2, bytes3]
	# data structure description is in drawTile.asm
	mask = 0
	data = []
	for bytes in allBytes:
		mask >>=  1
		if common.is_bytes_zeros(bytes) : 
			continue
		mask += 8

		x = 0
		for y in reversed(range(16)):
			byte = bytes[y * 2 + x]
			data.append(byte)
		x = 1
		for y in range(16):
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
		bits0, bits1, bits2, bits3 = common.indexes_to_bit_lists(tileImg)

		# combite bits into byte lists
		bytes0 = common.combine_bits_to_bytes(bits0) # 8000-9FFF # from left to right, from bottom to top
		bytes1 = common.combine_bits_to_bytes(bits1) # A000-BFFF
		bytes2 = common.combine_bits_to_bytes(bits2) # C000-DFFF
		bytes3 = common.combine_bits_to_bytes(bits3) # E000-FFFF

		# to support a tile render function
		data, mask = get_tile_data(bytes0, bytes1, bytes2, bytes3)


		# two empty bytes prior every data to support a stack renderer
		asm += "			.byte 0,0 ; safety pair of bytes to support a stack renderer\n"
		asm += labelPrefix + "_tile" + str(remapIdxs[tidx]) + ":\n"
		asm += "			.byte " + str(mask) + " ; mask\n"
		asm += "			.byte 4 ; counter\n"
		asm += common.bytes_to_asm(data)
		size += len(data)

	return asm, size

def remap_index(roomsJ):
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
	for i, roomPathP in enumerate(roomPaths):
		roomPath = roomPathP['path']
		roomPathWOExt = os.path.splitext(roomPath)[0]
		labelPrefix = os.path.basename(roomPathWOExt)
		asm += "__" + labelPrefix + ", "
		if i != len(roomPaths)-1:
			# two safety fytes
			asm += "0, "
		size += 2
	asm += "\n"
	return asm, size

def GetListOfTiles(remapIdxs, labelPrefix, pngLabelPrefix):
	size = 0
	asm = "\n			.byte 0,0 ; safety pair of bytes to support a stack renderer\n"
	asm += labelPrefix + "_tilesAddr:\n			.word "
	for i, tidx in enumerate(remapIdxs):
		asm += "__" + pngLabelPrefix + "_tile" + str(remapIdxs[tidx]) + ", "
		if i != len(remapIdxs)-1:
			# two safety fytes
			asm += "0, "
		size += 2
	asm += "\n"
	return asm, size

def StartPosToAsm(source_j, labelPrefix):
	asm = ("\n			.byte 0,0 ; safety pair of bytes to support a stack renderer\n" + 
			"__" + labelPrefix + "_startPos:\n			.byte " + 
			str(source_j["startPos"]["y"]) + ", " + 
			str(source_j["startPos"]["x"]) + "\n")
	return asm, 4

#=====================================================
def export_if_updated(source_path, generated_dir, force_export):
	source_path_wo_ext = os.path.splitext(source_path)[0]
	source_name = os.path.basename(source_path_wo_ext)
	export_paths = {"ram_disk" : generated_dir + source_name + build.EXT_ASM }

	if force_export or is_source_updated(source_path):
		export(
			source_path, 
			export_paths["ram_disk"])
			
		print(f"level: {source_path} got exported.")		
		return True, export_paths
	else:
		return False, export_paths

def export(source_j_path, export_path):

	exportDir = str(Path(export_path).parent) + "\\"

	with open(source_j_path, "rb") as file:
		source_j = json.load(file)

	source_dir = str(Path(source_j_path).parent) + "\\"

	if "asset_type" not in source_j or source_j["asset_type"] != build.ASSET_TYPE_LEVEL :
		print(f'level_export ERROR: asset_type != "{build.ASSET_TYPE_LEVEL}", path: {source_j_path}')
		print("Stop export")
		exit(1)

	png_path = source_dir + source_j["png_path"]
	image = Image.open(png_path)

	source_path_wo_ext = os.path.splitext(source_j_path)[0]
	source_name = os.path.basename(source_path_wo_ext)

	asm = f"__RAM_DISK_S_{source_name.upper()} = RAM_DISK_S\n"
	asm += f"__RAM_DISK_M_{source_name.upper()} = RAM_DISK_M\n"
	
	paletteAsm, colors = common.palette_to_asm(image, source_j, png_path, "__" + source_name)
	asm += paletteAsm

	dataSize = len(colors)
	asmStartPos, size = StartPosToAsm(source_j, source_name)
	asm += asmStartPos
	dataSize += size
	image = common.remap_colors(image, colors)

	roomPaths = source_j["rooms"]
	roomsJ = []
	# load and parse tiled map
	for roomPathP in roomPaths:
		roomPath = source_dir + roomPathP['path']
		with open(roomPath, "rb") as file:
			roomsJ.append(json.load(file))
		
	# make a tile index remap dictionary, to have the first idx = 0
	remapIdxs = remap_index(roomsJ)

	pngPathWOExt = os.path.splitext(png_path)[0]
	pngName = os.path.basename(pngPathWOExt)

	# list of rooms
	asmL, size = GetListOfRooms(roomPaths, "__" + source_name)
	asm += asmL
	dataSize += size
	# list of tiles addreses
	asmLT, size = GetListOfTiles(remapIdxs, "__" + source_name, pngName)
	asm += asmLT
	dataSize += size
	# every room data
	for i, roomJ in enumerate(roomsJ):
		asmRT, size = RoomTilesToAsm(roomJ["layers"][0], roomPaths[i]['path'], remapIdxs, source_dir)
		asm += "\n			.byte 0,0 ; safety pair of bytes to support a stack renderer\n"
		asm += asmRT
		dataSize += size
		asmRTD, size = RoomTilesDataToAsm(roomJ["layers"][1], roomPaths[i]['path'], source_dir)
		asm += "\n			.byte 0,0 ; safety pair of bytes to support a stack renderer\n"
		asm += asmRTD
		dataSize += size

	# tile art data to asm
	asmT, size = TilesToAsm(roomsJ[0], image, png_path, remapIdxs, "__" + pngName)
	asm += asmT
	dataSize += size

	# save asm
	if not os.path.exists(exportDir):
		os.mkdir(exportDir)

	with open(export_path, "w") as file:
		file.write(asm)

def is_source_updated(source_j_path):
	with open(source_j_path, "rb") as file:
		source_j = json.load(file)
	
	source_dir = str(Path(source_j_path).parent) + "\\"
	png_path = source_dir + source_j["png_path"]

	roomPaths = source_j["rooms"]
	roomsUpdated = False
	for roomPathP in roomPaths:
		roomPath = source_dir + roomPathP['path']
		roomsUpdated |= build.is_file_updated(roomPath)

	if build.is_file_updated(source_j_path) | build.is_file_updated(png_path) | roomsUpdated:
		return True
	return False





