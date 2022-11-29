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
	allCompressedChunkPaths = []

	for bankJ in contentJ["banks"]:
		bank = int(bankJ["bank"])
		for segmentsJ in bankJ["segments"]:
			addrS = segmentsJ["addr"]
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
			for chunkN, chunkJ in enumerate(segmentsJ["chunks"]):
				for asset in chunkJ:
					path = asset["path"]
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

			# save a segment data file
			with open(generatedFolder + ramDiskSegmentFilePath, "w") as file:
				file.write(ramDiskSegmentData)
			# export a segment data file
			if addrS_WO_hexSym == "0" or addrS_WO_hexSym == "0000":
				segmentStartAddr = build.SEGMENT_0000_7F00_ADDR
			else:
				segmentStartAddr = build.SEGMENT_8000_0000_ADDR
			_, labelsPath, compressedChunkPaths = build.ExportSegment(ramDiskSegmentFilePath, segmentIncludesUpdatedFiles, segmentStartAddr, True, generatedFolder)
			labelsPaths.append(labelsPath)
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

	ramDiskDataAsm += "; compressed ram-disk data\n"
	ramDiskDataAsm += "; ram-disk data has to keep the range from STACK_MIN_ADDR to STACK_MAIN_PROGRAM_ADDR-1 unused,\n"
	ramDiskDataAsm += "; because it can be corrupted by the subroutines which manipulate the stack\n"
	for compressedChunkPath in allCompressedChunkPaths:
		compressedChunkpathWoExt = os.path.splitext(compressedChunkPath)[0].split(".")[0]
		compressedChunkName = os.path.basename(compressedChunkpathWoExt)
		ramDiskDataAsm += f"{compressedChunkName}:\n"
		ramDiskDataAsm += f'.incbin "{common.DoubleSleshes(compressedChunkPath)}"\n'
	ramDiskDataAsm += "\n"

	# save ramDiskData.asm
	ramDiskDataPath = f"\\code\\ramDiskData{extAsm}"
	with open(generatedFolder + ramDiskDataPath, "w") as file:
		file.write(ramDiskDataAsm)	
