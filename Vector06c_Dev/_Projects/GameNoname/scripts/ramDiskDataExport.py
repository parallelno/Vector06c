import os
import json
import common
import build

def Export(contentJPath):
	extAsm = ".asm"

	with open(contentJPath, "rb") as file:
		contentJ = json.load(file)

	# set global buildDBPath
	build.buildDBPath = contentJ["buildDBPath"]

	sourceFolder = contentJ["paths"]["source"]
	generatedFolder = contentJ["paths"]["generated"]

	dependencyPathsJ = contentJ["dependencies"]
	# check dependencies
	globalForceExport = False
	for path in dependencyPathsJ["global"]:
		if build.IsFileUpdated(path):
			globalForceExport = True
			break
	spriteForceExport = globalForceExport | build.IsFileUpdated(dependencyPathsJ["sprite"])
	levelForceExport = globalForceExport | build.IsFileUpdated(dependencyPathsJ["level"])
	musicForceExport = globalForceExport | build.IsFileUpdated(dependencyPathsJ["music"])
	
	labelsPaths = []
	spriteAnimsPaths = []
	segmentPaths = []
	allCompressedChunkPaths = []
	chunksLayout = []

	for bankJ in contentJ["banks"]:
		bank = int(bankJ["bank"])
		for segmentJ in bankJ["segments"]:
			addrS = segmentJ["addr"]
			addrS_WO_hexSym = addrS
			if addrS_WO_hexSym[0] == "$":
				addrS_WO_hexSym = addrS_WO_hexSym[1:]
			ramDiskSegmentFilePath = f"code\\ramDiskData_bank{bank}_addr{addrS_WO_hexSym}{extAsm}"
			ramDiskSegmentData = f'.org {addrS}\n'
			ramDiskSegmentData += f'__chunkStart_bank{bank}_addr{addrS_WO_hexSym}_chunk0:\n\n'
			ramDiskSegmentData += '.include "globalConsts.asm"\n'
			ramDiskSegmentData += '.include "macro.asm"\n'
			ramDiskSegmentData += f'RAM_DISK_BANK_ACTIVATION_CMD = RAM_DISK_S{bank}\n\n'

			segmentIncludesUpdatedFiles = globalForceExport
			for chunkN, chunkJ in enumerate(segmentJ["chunks"]):
				chunkLayout = []
				for asset in chunkJ:
					path = asset["path"]
					pathWOExt = os.path.splitext(path)[0]
					chunkLayout.append(os.path.basename(pathWOExt))

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
				ramDiskSegmentData += f'__chunkEnd_bank{bank}_addr{addrS_WO_hexSym}_chunk{chunkN}:\n\n'
				chunksLayout.append(chunkLayout)

			# save a segment data file
			with open(generatedFolder + ramDiskSegmentFilePath, "w") as file:
				file.write(ramDiskSegmentData)
			# export a segment data file
			if addrS_WO_hexSym == "0" or addrS_WO_hexSym == "0000":
				segmentStartAddr = build.SEGMENT_0000_7F00_ADDR
			else:
				segmentStartAddr = build.SEGMENT_8000_0000_ADDR
			_, labelsPath, segmentPath, compressedChunkPaths = build.ExportSegment(ramDiskSegmentFilePath, segmentIncludesUpdatedFiles, segmentStartAddr, True, generatedFolder)
			labelsPaths.append(labelsPath)
			segmentPaths.append(segmentPath)
			allCompressedChunkPaths.extend(compressedChunkPaths)
	
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
	for i, compressedChunkPath in enumerate(allCompressedChunkPaths):
		compressedChunkpathWoExt = os.path.splitext(compressedChunkPath)[0].split(".")[0]
		compressedChunkName = os.path.basename(compressedChunkpathWoExt)
		ramDiskDataAsm += f"{compressedChunkName}: ; {chunksLayout[i]}\n"
		ramDiskDataAsm += f'.incbin "{common.DoubleSleshes(compressedChunkPath)}"\n'
	ramDiskDataAsm += "\n"

	ramDiskDataAsm += "; ram-disk data layout\n"
	segmentNum = 0
	for bankJ in contentJ["banks"]:
		bank = int(bankJ["bank"])
		for segmentJ in bankJ["segments"]:
			name = segmentJ["name"]
			addrS = segmentJ["addr"]
			addrS_WO_hexSym = addrS
			if addrS_WO_hexSym[0] == "$":
				addrS_WO_hexSym = addrS_WO_hexSym[1:]			
			if (addrS_WO_hexSym == "0"):
				addrS = "$0000"
				addrS_WO_hexSym = "0000"
			
			if addrS_WO_hexSym == "0" or addrS_WO_hexSym == "0000":
				segmentStartAddr = build.SEGMENT_0000_7F00_ADDR
			else:
				segmentStartAddr = build.SEGMENT_8000_0000_ADDR			
			segmentSizeMax = build.GetSegmentSizeMax(segmentStartAddr)
			segmentSize = os.path.getsize(segmentPaths[segmentNum])
			segmentNum += 1

			assetNames = []
			for chunkJ in segmentJ["chunks"]:
				for asset in chunkJ:
					path = asset["path"]
					pathWOExt = os.path.splitext(path)[0]
					assetName = os.path.basename(pathWOExt)
					assetNames.append(assetName)

			ramDiskDataAsm += f"; bank{bank} addr{addrS} [{segmentSizeMax - segmentSize} free]	- {name}:	{assetNames}\n"
	ramDiskDataAsm += "; bank3 addr$8000 - $8000-$9FFF tiledata (for collision, copyToScr, etc), $A000-$FFFF back buffer2 (to restore the background in the back buffer)\n"

	# save ramDiskData.asm
	ramDiskDataPath = f"\\code\\ramDiskData{extAsm}"
	with open(generatedFolder + ramDiskDataPath, "w") as file:
		file.write(ramDiskDataAsm)


	# make ramDiskInit.asm
	ramDiskInitAsm = "RamDiskInit:\n"
	ramDiskInitAsm += "			;call ClearRamDisk\n"
	# unpack segments in a reverse order of banks listed in ramDiskData.json
	for bankJ in reversed(contentJ["banks"]):
		bank = int(bankJ["bank"])
		for segmentJ in reversed(bankJ["segments"]):
			name = segmentJ["name"]
			addrS = segmentJ["addr"]
			addrS_WO_hexSym = addrS
			if addrS_WO_hexSym[0] == "$":
				addrS_WO_hexSym = addrS_WO_hexSym[1:]			
	
			ramDiskSegmentFileName = f"ramDiskData_bank{bank}_addr{addrS_WO_hexSym}"
			ramDiskInitAsm += "	;===============================================\n"
			ramDiskInitAsm +=f"	;		{name}, bank {bank}, addr {addrS}\n"
			ramDiskInitAsm += "	;===============================================\n"

			if name == "sprites":
				for chunk, chunkJ in enumerate(segmentJ["chunks"]):
					assetNames = []
					for asset in chunkJ:
						path = asset["path"]
						pathWOExt = os.path.splitext(path)[0]
						assetName = os.path.basename(pathWOExt)
						assetNames.append(assetName)

					ramDiskInitAsm +=f"			; unpack chunk {chunk} {assetNames} sprites into the ram-disk back buffer\n"
					ramDiskInitAsm +=f"			lxi d, {ramDiskSegmentFileName}_{chunk}\n"
					ramDiskInitAsm += "			lxi b, SCR_BUFF1_ADDR\n"
					ramDiskInitAsm += "			mvi a, RAM_DISK_M2 | RAM_DISK_M_8F\n"
					ramDiskInitAsm += "			call dzx0RD\n\n"

					chunkStartAddrS = f"__chunkStart_bank{bank}_addr{addrS}_chunk"
					chunkEndAddrS = f"__chunkEnd_bank{bank}_addr{addrS}_chunk"
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
						ramDiskInitAsm +=f"			RAM_DISK_ON(RAM_DISK_M2 | RAM_DISK_M_8F)\n"
						ramDiskInitAsm +=f"			lxi d, {assetName}_preshifted_sprites\n"
						ramDiskInitAsm +=f"			lxi h, SCR_BUFF1_ADDR{chunkOffsetS}\n"
						ramDiskInitAsm +=f"			call __SpriteDupPreshift\n"
						ramDiskInitAsm +=f"			RAM_DISK_OFF()\n\n"

					ramDiskInitAsm +=f"			; copy chunk {chunk} {assetNames} sprites to the ram-disk\n"
					ramDiskInitAsm +=f"			lxi d, SCR_BUFF1_ADDR + {chunkLenS}\n"
					ramDiskInitAsm +=f"			lxi h, {chunkEndAddrS}{chunk}\n"
					ramDiskInitAsm +=f"			lxi b, ({chunkLenS}) / 2\n"
					ramDiskInitAsm +=f"			mvi a, RAM_DISK_S{bank} | RAM_DISK_M2 | RAM_DISK_M_8F\n"
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
