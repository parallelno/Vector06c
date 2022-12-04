import os
import json
import common
import build

SEGMENT_RESERVED = "reserved"


def ChunkStartLabelName(bank, addrS_WO_hexSym, chunkN = -1):
	res = f'__chunkStart_bank{bank}_addr{addrS_WO_hexSym}_'
	if chunkN == -1:
		return res
	return res + str(chunkN)	

def ChunkEndLabelName(bank, addrS_WO_hexSym, chunkN = -1):
	res = f'__chunkEnd_bank{bank}_addr{addrS_WO_hexSym}_'
	if chunkN == -1:
		return res
	return res + str(chunkN)

def AddrWOHexS(addrS):
	addrS_WO_hexSym = addrS
	if addrS_WO_hexSym[0] == "$":
		addrS_WO_hexSym = addrS_WO_hexSym[1:]
	if addrS_WO_hexSym == "0000" or addrS_WO_hexSym == "000" or addrS_WO_hexSym == "00":
		addrS_WO_hexSym = "0"

	if addrS_WO_hexSym == "0":
		segmentStartAddr = build.SEGMENT_0000_7F00_ADDR
	else:
		segmentStartAddr = build.SEGMENT_8000_0000_ADDR		

	return addrS_WO_hexSym, segmentStartAddr

def RamDiskDataFileName(bank, addrS_WO_hexSym, chunkN = "", chunks = 2):
	result = f'ramDiskData_bank{bank}_addr{addrS_WO_hexSym}'
	if chunkN != "" and chunks > 1:
		result += "_" + str(chunkN)

	return result

def Export(contentJPath):
	extAsm = ".asm"
	extBin = ".bin"
	extZx0 = ".bin.zx0"

	with open(contentJPath, "rb") as file:
		contentJ = json.load(file)

	# set global buildDBPath
	build.SetBuildDBPath(contentJ["buildDBPath"])

	sourceFolder = contentJ["paths"]["source"]
	generatedFolder = contentJ["paths"]["generated"]
	binFolder = contentJ["paths"]["bin"]

	dependencyPathsJ = contentJ["dependencies"]
	# check dependencies
	globalForceExport = False
	for path in dependencyPathsJ["global"]:
		globalForceExport |= build.IsFileUpdated(path)

	spriteForceExport = globalForceExport | build.IsFileUpdated(dependencyPathsJ["sprite"])
	levelForceExport = globalForceExport | build.IsFileUpdated(dependencyPathsJ["level"])
	musicForceExport = globalForceExport | build.IsFileUpdated(dependencyPathsJ["music"])

	bankBackBuffer = contentJ["bankBackBuffer"]
	bankBackBuffer2 = contentJ["bankBackBuffer2"]
	backBufferSize = contentJ["backBufferSize"]

	labelsPaths = []
	segmentPaths = []
	spriteAnimsPaths = []
	compressedChunkFileNames = []


	for bankJ in contentJ["banks"]:
		bank = int(bankJ["bank"])
		for segmentJ in bankJ["segments"]:
			if segmentJ["name"] == SEGMENT_RESERVED:
				continue

			segments = len(segmentJ["chunks"])
			if segments == 0:
				continue

			addrS = segmentJ["addr"]
			addrS_WO_hexSym, segmentStartAddr = AddrWOHexS(addrS)
			ramDiskSegmentData = f'.org {addrS}\n'
			ramDiskSegmentData += ChunkStartLabelName(bank, addrS_WO_hexSym, 0) + ":\n\n"
			ramDiskSegmentData += '.include "asm\\\\globals\\\\globalConsts.asm"\n' 
			ramDiskSegmentData += '.include "asm\\\\globals\\\\macro.asm"\n'
			ramDiskSegmentData += f'RAM_DISK_S = RAM_DISK_S{bank}\n'
			ramDiskSegmentData += f'RAM_DISK_M = RAM_DISK_M{bank}\n\n'

			segmentIncludesUpdatedFiles = globalForceExport
			for chunkN, chunkJ in enumerate(segmentJ["chunks"]):
				chunkLayout = []
				for asset in chunkJ:
					path = asset["path"]
					pathWOExt = os.path.splitext(path)[0]
					exportedAssetFilePath = ""
					if asset["type"] == "sprite":
						exportedfileUpdated, exportedFilePaths = build.ExportAnimSprites(path, spriteForceExport, sourceFolder, generatedFolder)
						segmentIncludesUpdatedFiles |= exportedfileUpdated
						spriteAnimsPaths.append(exportedFilePaths["anim"])
						exportedAssetFilePath = exportedFilePaths["sprites"]

					if asset["type"] == "level":
						exportedfileUpdated, exportedFilePath = build.ExportLevel(path, levelForceExport, sourceFolder, generatedFolder)
						segmentIncludesUpdatedFiles |= exportedfileUpdated
						exportedAssetFilePath = exportedFilePath

					if asset["type"] == "music":
						exportedfileUpdated, exportedFilePath = build.ExportMusic(path, musicForceExport, sourceFolder, generatedFolder)
						segmentIncludesUpdatedFiles |= exportedfileUpdated
						exportedAssetFilePath = exportedFilePath

					if asset["type"] == "code":
						exportedAssetFilePath = path										
					
					ramDiskSegmentData += f'.include "{common.DoubleSleshes(exportedAssetFilePath)}"\n'
				
				ramDiskSegmentData += f'.align 2\n'
				ramDiskSegmentData += ChunkEndLabelName(bank, addrS_WO_hexSym, chunkN) + ":\n\n"

			ramDiskSegmentFileNameWOext = RamDiskDataFileName(bank, addrS_WO_hexSym)
			ramDiskSegmentFilePath = "code\\" + ramDiskSegmentFileNameWOext + extAsm
			# save a segment data file
			if (segmentIncludesUpdatedFiles):
				with open(generatedFolder + ramDiskSegmentFilePath, "w") as file:
					file.write(ramDiskSegmentData)
				# export a segment data file
				_ = build.ExportSegment(ramDiskSegmentFilePath, segmentIncludesUpdatedFiles, segmentStartAddr, True, generatedFolder)
			
			labelsPaths.append(f"{generatedFolder}code\\{ramDiskSegmentFileNameWOext}_labels.asm")
			segmentPaths.append(f"{binFolder}{ramDiskSegmentFileNameWOext}{extBin}")
			compressedChunkFileNames.append(RamDiskDataFileName(bank, addrS_WO_hexSym, chunkN, segments))
	
	# make ramDiskData.asm
	ramDiskDataAsm = "; ram-disk data labels\n"
	for labelsPath in labelsPaths:
		ramDiskDataAsm += f'.include "{common.DoubleSleshes(labelsPath)}"\n'
	ramDiskDataAsm += "\n"

	ramDiskDataAsm += "; sprites anims\n"
	for animsPath in spriteAnimsPaths:
		ramDiskDataAsm += f'.include "{common.DoubleSleshes(animsPath)}"\n'
	ramDiskDataAsm += "\n"

	ramDiskDataAsm += "; compressed ram-disk data. They will be unpacked in a reverse order.\n"
	for bankJ in contentJ["banks"]:
		bank = int(bankJ["bank"])
		for segmentJ in bankJ["segments"]:
			if segmentJ["name"] == SEGMENT_RESERVED:
				continue
			if len(segmentJ["chunks"]) == 0:
				continue
			addrS = segmentJ["addr"]
			addrS_WO_hexSym, segmentStartAddr = AddrWOHexS(addrS)

			for chunkN, chunkJ in enumerate(segmentJ["chunks"]):
				chunkLayout = []
				compressedChunkName = RamDiskDataFileName(bank, addrS_WO_hexSym, chunkN, len(segmentJ["chunks"]))
				compressedChunkPath = binFolder + compressedChunkName + extZx0
				for asset in chunkJ:
					path = asset["path"]
					pathWOExt = os.path.splitext(path)[0]
					chunkLayout.append(os.path.basename(pathWOExt))
					
				ramDiskDataAsm += f"{compressedChunkName}: ; {chunkLayout}\n"
				ramDiskDataAsm += f'.incbin "{common.DoubleSleshes(compressedChunkPath)}"\n'

	ramDiskDataAsm += "\n"

	ramDiskDataAsm += "; ram-disk data layout\n"
	segmentNum = 0
	for bankJ in contentJ["banks"]:
		bank = int(bankJ["bank"])
		for segmentJ in bankJ["segments"]:
			name = segmentJ["name"]

			addrS = segmentJ["addr"]
			addrS_WO_hexSym, segmentStartAddr = AddrWOHexS(addrS)
			if segmentStartAddr == build.SEGMENT_8000_0000_ADDR:
				addrS_WO_hexSym = "8000"
			else:
				addrS_WO_hexSym = "0000"

			description = ""
			if "description" in segmentJ:
				description = segmentJ["description"]

			if name == SEGMENT_RESERVED:
				ramDiskDataAsm += f"; bank{bank} addr{addrS_WO_hexSym} [0 free]		- {description}\n"	
			else:	
				if bank == bankBackBuffer and segmentStartAddr == build.SEGMENT_8000_0000_ADDR :
					segmentSizeMax = build.SCR_BUFF_SIZE * 4 - backBufferSize
				else:
					segmentSizeMax = build.GetSegmentSizeMax(segmentStartAddr)

				if len(segmentJ["chunks"]) > 0:
					segmentSize = os.path.getsize(segmentPaths[segmentNum])
					segmentNum += 1
				else:
					segmentSize = 0
				
				if description == "":
					assetNames = []
					for chunkJ in segmentJ["chunks"]:
						for asset in chunkJ:
							path = asset["path"]
							pathWOExt = os.path.splitext(path)[0]
							assetName = os.path.basename(pathWOExt)
							assetNames.append(assetName)
					if len(assetNames) > 0:
						description = f"{name}:	{assetNames}"
					else:
						description = "empty:"

				ramDiskDataAsm += f"; bank{bank} addr{addrS} [{segmentSizeMax - segmentSize} free]	- {description}\n"

	# save ramDiskData.asm
	ramDiskDataPath = f"\\code\\ramDiskData{extAsm}"
	with open(generatedFolder + ramDiskDataPath, "w") as file:
		file.write(ramDiskDataAsm)


	# make ramDiskInit.asm
	ramDiskInitAsm = ""
	ramDiskInitAsm += f'__RAM_DISK_S_BACKBUFF = RAM_DISK_S{bankBackBuffer}\n'
	ramDiskInitAsm += f'__RAM_DISK_M_BACKBUFF = RAM_DISK_M{bankBackBuffer}\n'
	ramDiskInitAsm += f'__RAM_DISK_S_BACKBUFF2 = RAM_DISK_S{bankBackBuffer2}\n'
	ramDiskInitAsm += f'__RAM_DISK_M_BACKBUFF2 = RAM_DISK_M{bankBackBuffer2}\n\n'

	ramDiskInitAsm += "RamDiskInit:\n"
	ramDiskInitAsm += "			;call ClearRamDisk\n"
	# unpack segments in a reverse order of banks listed in ramDiskData.json
	for bankJ in reversed(contentJ["banks"]):
		bank = int(bankJ["bank"])
		for segmentJ in reversed(bankJ["segments"]):
			name = segmentJ["name"]
			if segmentJ["name"] == SEGMENT_RESERVED:
				continue			
			if len(segmentJ["chunks"]) == 0:
				continue

			addrS = segmentJ["addr"]
			addrS_WO_hexSym, segmentStartAddr = AddrWOHexS(addrS)
	
			ramDiskSegmentFileName = RamDiskDataFileName(bank, addrS_WO_hexSym)
			ramDiskInitAsm += "	;===============================================\n"
			ramDiskInitAsm +=f"	;		{name}, bank {bank}, addr {addrS}\n"
			ramDiskInitAsm += "	;===============================================\n"

			if name == "sprites":
				chunkLen = len(segmentJ["chunks"])
				for chunk, chunkJ in enumerate(segmentJ["chunks"]):
					assetNames = []
					for asset in chunkJ:
						path = asset["path"]
						pathWOExt = os.path.splitext(path)[0]
						assetName = os.path.basename(pathWOExt)
						assetNames.append(assetName)

					ramDiskChunkFileName = ramDiskSegmentFileName
					if chunkLen > 1:
						ramDiskChunkFileName += f"_{chunk}"

					ramDiskInitAsm +=f"			; unpack chunk {chunk} {assetNames} sprites into the ram-disk back buffer\n"
					ramDiskInitAsm +=f"			lxi d, {ramDiskChunkFileName}\n"
					ramDiskInitAsm += "			lxi b, SCR_BUFF1_ADDR\n"
					ramDiskInitAsm +=f"			mvi a, __RAM_DISK_M_BACKBUFF | RAM_DISK_M_8F\n"
					ramDiskInitAsm += "			call dzx0RD\n\n"

					chunkStartAddrS = ChunkStartLabelName(bank, addrS_WO_hexSym)
					chunkEndAddrS = ChunkEndLabelName(bank, addrS_WO_hexSym)
					chunkOffsetS = ""
					if chunk > 0:
						chunkOffsetS = f" - {chunkEndAddrS}{chunk-1}"
						chunkLenS = f"{chunkEndAddrS}{chunk} - {chunkEndAddrS}{chunk-1}"
					else:
						chunkLenS = f"{chunkEndAddrS}{chunk} - {chunkStartAddrS}{chunk}"
					

					for asset in chunkJ:
						path = asset["path"]
						pathWOExt = os.path.splitext(path)[0]
						assetName = os.path.basename(pathWOExt)

						ramDiskInitAsm +=f"			; preshift chunk {chunk} {assetName} sprites\n"
						ramDiskInitAsm +=f"			RAM_DISK_ON(__RAM_DISK_M_BACKBUFF | RAM_DISK_M_8F)\n"
						ramDiskInitAsm +=f"			lxi d, {assetName}_preshifted_sprites\n"
						ramDiskInitAsm +=f"			lxi h, SCR_BUFF1_ADDR{chunkOffsetS}\n"
						ramDiskInitAsm +=f"			call __SpriteDupPreshift\n"
						ramDiskInitAsm +=f"			RAM_DISK_OFF()\n\n"

					ramDiskInitAsm +=f"			; copy chunk {chunk} {assetNames} sprites to the ram-disk\n"
					ramDiskInitAsm +=f"			lxi d, SCR_BUFF1_ADDR + ({chunkLenS})\n"
					ramDiskInitAsm +=f"			lxi h, {chunkEndAddrS}{chunk}\n"
					ramDiskInitAsm +=f"			lxi b, ({chunkLenS}) / 2\n"
					ramDiskInitAsm +=f"			mvi a, RAM_DISK_S{bank} | __RAM_DISK_M_BACKBUFF | RAM_DISK_M_8F\n"
					ramDiskInitAsm +=f"			call CopyToRamDisk\n\n"
				
			elif addrS_WO_hexSym == "0" or addrS_WO_hexSym == "0000":

				# supposed to have just one chunk
				chunkStartAddrS = ChunkStartLabelName(bank, addrS_WO_hexSym)
				chunkEndAddrS = ChunkEndLabelName(bank, addrS_WO_hexSym)

				chunkLenS = f"{chunkEndAddrS}0 - {chunkStartAddrS}0"

				ramDiskInitAsm +=f"			; unpack {name} into the ram-disk backbuffer2\n"
				ramDiskInitAsm +=f"			lxi d, {ramDiskSegmentFileName}\n"
				ramDiskInitAsm +=f"			lxi b, SCR_BUFF0_ADDR\n"
				ramDiskInitAsm +=f"			mvi a, __RAM_DISK_M_BACKBUFF2 | RAM_DISK_M_8F\n"
				ramDiskInitAsm += "			call dzx0RD\n\n"

				ramDiskInitAsm +=f"			; copy {name} to the ram-disk\n"
				ramDiskInitAsm +=f"			lxi d, SCR_BUFF0_ADDR + ({chunkLenS})\n"
				ramDiskInitAsm +=f"			lxi h, {chunkEndAddrS}0\n"
				ramDiskInitAsm +=f"			lxi b, ({chunkLenS}) / 2\n"
				ramDiskInitAsm +=f"			mvi a, RAM_DISK_S{bank} | __RAM_DISK_M_BACKBUFF2 | RAM_DISK_M_8F\n"
				ramDiskInitAsm +=f"			call CopyToRamDisk\n\n"

			else:
				ramDiskInitAsm +=f"			; unpack {name} to the ram-disk\n"
				ramDiskInitAsm +=f"			lxi d, {ramDiskSegmentFileName}\n"
				ramDiskInitAsm +=f"			lxi b, {addrS}\n"
				ramDiskInitAsm +=f"			mvi a, RAM_DISK_M{bank} | RAM_DISK_M_8F\n"
				ramDiskInitAsm += "			call dzx0RD\n\n"

	ramDiskInitAsm += "			ret\n"

	# save ramDiskInit.asm
	ramDiskInitPath = f"\\code\\ramDiskInit{extAsm}"
	with open(generatedFolder + ramDiskInitPath, "w") as file:
		file.write(ramDiskInitAsm)		

