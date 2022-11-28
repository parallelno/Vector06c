import json
import tools.common as common
import tools.build as build

def Export(sourcePath, sourceFolder = "sources\\", generatedFolder = "generated\\"):

	extJson = ".json"
	extAsm = ".asm"

	with open(sourceFolder + sourcePath + extJson, "rb") as file:
		contentJ = json.load(file)

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

	for bankJ in contentJ["banks"]:
		bank = int(bankJ["bank"])
		for segmentsJ in bankJ["segments"]:
			addrS = segmentsJ["addr"]
			addrS_WO_hexSym = addrS
			if addrS_WO_hexSym[0] == "$":
				addrS_WO_hexSym = addrS_WO_hexSym[1:]
			ramDiskSegmentFilePath = f"code\\ramDiskSegmentData_bank{bank}_addr{addrS_WO_hexSym}"
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
						exportedfileUpdated, exportedFilePaths = build.ExportAnimSprites(path, spriteForceExport)
						segmentIncludesUpdatedFiles |= exportedfileUpdated
						exportedAssetFilePath = exportedFilePaths["sprites"]

					if asset["type"] == "level":
						exportedfileUpdated, exportedFilePath = build.ExportLevel(path, levelForceExport)
						segmentIncludesUpdatedFiles |= exportedfileUpdated
						exportedAssetFilePath = exportedFilePath

					if asset["type"] == "music":
						exportedfileUpdated, exportedFilePath = build.ExportMusic(path, musicForceExport)
						segmentIncludesUpdatedFiles |= exportedfileUpdated
						exportedAssetFilePath = exportedFilePath

					if asset["type"] == "code":
						exportedAssetFilePath = path											
					
					ramDiskSegmentData += f'.include "{common.DoubleSleshes(exportedAssetFilePath)}"\n'
				ramDiskSegmentData += f'.align 2\n'

				ramDiskSegmentData += f'__chunkEnd_bank{bank}_addr{addrS_WO_hexSym}_chunk{chunkN}:\n\n'

			# save a segment data file
			with open(generatedFolder + ramDiskSegmentFilePath + extAsm, "w") as file:
				file.write(ramDiskSegmentData)
			# export a segment data file
			if addrS_WO_hexSym == "0" or addrS_WO_hexSym == "0000":
				segmentStartAddr = build.SEGMENT_0000_7F00_ADDR
			else:
				segmentStartAddr = build.SEGMENT_8000_0000_ADDR
			build.ExportSegment(ramDiskSegmentFilePath, segmentIncludesUpdatedFiles, segmentStartAddr, True)

# end
