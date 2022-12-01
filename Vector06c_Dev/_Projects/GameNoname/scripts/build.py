import os
import sqlite3
import common
import animSpriteExport
import levelExport
import musicExport


buildDBPath = "generated\\build_default.db"
SEGMENT_0000_7F00_ADDR = 0x0000
SEGMENT_8000_0000_ADDR = 0x8000

SEGMENT_0000_7F00_SIZE_MAX = 2 ** 15 - 256 # because an interruption can corrupt the ram-disk memory from STACK_MIN_ADDR = $7f00 to STACK_TEMP_ADDR = $8000
SEGMENT_8000_0000_SIZE_MAX = 2 ** 15

SCR_BUFF_SIZE = 8192

def SetBuildDBPath(_buildDBPath):
	global buildDBPath
	buildDBPath = _buildDBPath

def DelBuildDB():
	common.RunCommand("del " + buildDBPath, "Build DB was deleted")

def ExportAnimSprites(sourcePath, forceExport, sourceFolder = "sources\\", generatedFolder = "generated\\"):
	sourcePathWOExt = os.path.splitext(sourcePath)[0]
	sourceName = os.path.basename(sourcePathWOExt)
	extAsm = ".asm"

	if animSpriteExport.IsFileUpdated(sourceFolder + sourcePath) or forceExport:
		animSpriteExport.Export(  
			sourceFolder + sourcePath, 
			generatedFolder + sourcePathWOExt + "Anim" + extAsm, 
			generatedFolder + sourcePathWOExt + "Sprites" + extAsm)

		print(f"animSpriteExport: {sourceFolder + sourcePath} got exported.")
		return True, {"anim" : generatedFolder + sourcePathWOExt + "Anim" + extAsm, "sprites" : generatedFolder + sourcePathWOExt + "Sprites" + extAsm}
	else:
		#print(f"animSpriteExport: {sourceFolder + sourcePath} is no need to export.")
		return False, {"anim" : generatedFolder + sourcePathWOExt + "Anim" + extAsm, "sprites" : generatedFolder + sourcePathWOExt + "Sprites" + extAsm}

def ExportLevel(sourcePath, forceExport, sourceFolder = "sources\\", generatedFolder = "generated\\"):
	sourcePathWOExt = os.path.splitext(sourcePath)[0]
	sourceName = os.path.basename(sourcePathWOExt)
	extAsm = ".asm"

	if levelExport.IsFileUpdated(sourceFolder + sourcePath) or forceExport:
		levelExport.Export( 
			sourceFolder + sourcePath, 
			generatedFolder + sourcePathWOExt + extAsm)
			
		print(f"levelExport: {sourceFolder + sourcePath} got exported.")		
		return True, generatedFolder + sourcePathWOExt + extAsm
	else:
		#print(f"levelExport: {sourceFolder + sourcePath} is no need to export.")		
		return False, generatedFolder + sourcePathWOExt + extAsm

def ExportMusic(sourcePath, forceExport, sourceFolder = "sources\\", generatedFolder = "generated\\"):
	sourcePathWOExt = os.path.splitext(sourcePath)[0]
	sourceName = os.path.basename(sourcePathWOExt)
	extAsm = ".asm"	
	extYm = ".ym"

	if IsFileUpdated(sourceFolder + sourcePath) or forceExport:
		musicExport.Export( 
			sourceFolder + sourcePath, 
			generatedFolder + sourcePathWOExt + extAsm)
			
		print(f"musicExport: {sourceFolder + sourcePath} got exported.")		
		return True, generatedFolder + sourcePathWOExt + extAsm
	else:	
		return False, generatedFolder + sourcePathWOExt + extAsm

def ExportSegment(sourcePath1, forceExport, segmentAddr, externalsOnly = False, generatedFolder = "generated\\", binFolder = "generated\\bin\\", ):
	sourcePathWOExt = os.path.splitext(sourcePath1)[0]
	sourceName = os.path.basename(sourcePathWOExt)
	extAsm = ".asm"

	if IsAsmUpdated(generatedFolder + sourcePath1) | forceExport:
		common.RunCommand(f"..\\..\\retroassembler\\retroassembler.exe -x -C=8080 {generatedFolder + sourcePath1} "
				f" {binFolder}{sourceName}.bin >{generatedFolder + sourcePathWOExt}_labels.asm")

		CheckSegmentSize(f"{binFolder}{sourceName}.bin", segmentAddr)

		ExportLabels(f"{generatedFolder + sourcePathWOExt}_labels.asm", externalsOnly)

		chunkPaths = SplitSegment(f"{binFolder}{sourceName}.bin", f"{generatedFolder + sourcePathWOExt}_labels.asm")
		compressedChunkPaths = []

		if len(chunkPaths) == 0:
			common.DeleteFile(f"{binFolder}{sourceName}.bin.zx0")
			common.RunCommand(f"tools\\zx0salvador.exe -v -classic {binFolder}{sourceName}.bin {binFolder}{sourceName}.bin.zx0")
			compressedChunkPaths.append(f"{binFolder}{sourceName}.bin.zx0")
		else:
			for chunkPath in chunkPaths:
				zipfilePathWOExt = os.path.splitext(chunkPath)[0] 
				common.DeleteFile(zipfilePathWOExt + ".bin.zx0")
				common.RunCommand(f"tools\\zx0salvador.exe -v -classic {zipfilePathWOExt}.bin {zipfilePathWOExt}.bin.zx0")
				compressedChunkPaths.append(f"{zipfilePathWOExt}.bin.zx0")
		
		print(f"ExportSegment: {sourceName} segment got exported.")	
		return True, f"{generatedFolder + sourcePathWOExt}_labels.asm", f"{binFolder}{sourceName}.bin", compressedChunkPaths
	else:
		return False, f"{generatedFolder + sourcePathWOExt}_labels.asm", f"{binFolder}{sourceName}.bin", compressedChunkPaths

def IsAsmUpdated(asmPath):
	with open(asmPath, "rb") as file:
		lines = file.readlines()
		
	includes = []
	for line in lines:
		lineStr = line.decode('ascii')
		incStr = ".include "
		incIdx = lineStr.find(incStr)
		
		if incIdx != -1 and lineStr[0] != ";":
			path = lineStr[incIdx + len(incStr)+1:]
			pathEndQ1 = path.find('"')
			pathEndQ2 = path.find("'")
			if pathEndQ1 != -1:
				includes.append(path[:pathEndQ1])
			elif pathEndQ2 != -1:
				includes.append(path[:pathEndQ2])
			continue

	anyIncUpdated = False
	for incPath in includes:
		anyIncUpdated |= IsFileUpdated(incPath)

	return anyIncUpdated | IsFileUpdated(asmPath)

def IsFileUpdated(path):
	
	con = sqlite3.connect(buildDBPath)
	cur = con.cursor()
	cur.execute('''CREATE TABLE if not exists files
			   (path text, modtime real)''')
	
	if not os.path.exists(path):
		return True
	modificationTime = os.path.getmtime(path)
	
	
	res = cur.execute("SELECT * FROM files WHERE path = '%s'" % path)
	modified = False
	ents = res.fetchall()

	if not ents:
		cur.execute("INSERT INTO files VALUES ('" + path + "', " + str(modificationTime) + ")")
		modified = True
	else:
		if ents[0][1] == modificationTime:
			modified = False
		else:
			sql = ''' UPDATE files
              SET modtime = ?
              WHERE path = ?'''
			cur.execute(sql, (modificationTime, path))
			modified = True

	# done with DB
	con.commit()
	con.close()
	return modified

def ExportLabels(path, externalsOnly = False):
	with open(path, "rb") as file:
		lines = file.readlines()
		
	getAllNextLines = False
	labels = ""
	for line in lines:
		lineStr = line.decode('ascii')
		if getAllNextLines:
			if not externalsOnly or (externalsOnly and lineStr[0:2] == "__"):
				labels += lineStr
			continue

		if lineStr.find("Segment: Code") != -1:
			getAllNextLines = True

	with open(path, "w") as file:
		file.write(labels) 

def BinToAsm(path, outPath):
	with open(path, "rb") as file:
		txt = ""
		while True:
			data = file.read(32)
			if data:
				txt += "\n.byte "
				for byteData in data:
					txt += str(byteData) + ", " 
			else: break
		
		with open(outPath, "w") as fw:
			fw.write(txt)

def GetSegmentSizeMax(segmentStartAddr):
	if segmentStartAddr == SEGMENT_0000_7F00_ADDR:
		return SEGMENT_0000_7F00_SIZE_MAX
	else:
		return SEGMENT_8000_0000_SIZE_MAX

def CheckSegmentSize(path, segmentAddr):
	if segmentAddr != SEGMENT_0000_7F00_ADDR and segmentAddr != SEGMENT_8000_0000_ADDR :
		print("ERROR: Segment start addr has to be " + hex(SEGMENT_0000_7F00_SIZE_MAX) + " or " + hex(SEGMENT_8000_0000_SIZE_MAX))
		print("Stop export")
		exit(1)

	segmentSize = os.path.getsize(path)
	segmentSizeMax = GetSegmentSizeMax(segmentAddr)

	if segmentSize > segmentSizeMax:
			print(f"ERROR: {path} is bigger than {segmentSizeMax} bytes")
			print("Stop export")
			exit(1)

def SplitSegment(segmentPath, segmentLabelsPath):
	with open(segmentLabelsPath, "rb") as file:
		labels = file.readlines()

	if len(labels) == 0:
		return []

	firstLine = labels[0].decode('ascii')
	firstLabelAddrStr = firstLine[firstLine.find("$")+1:]
	firstLabelAddr = int(firstLabelAddrStr, 16)

	splitAddrs = []
	for line in labels:
		label = line.decode('ascii').lower()
		if label.find("__chunkend") != -1:
			splitAddrStr = label[label.find("$")+1:]
			splitAddr = int(splitAddrStr, 16) - firstLabelAddr
			splitAddrs.append(splitAddr)

	if len(splitAddrs) < 2:
		return []
	
	chunkExt = os.path.splitext(segmentPath)[1]
	segmentSize = os.path.getsize(segmentPath)
	splittedFiles = []

	with open(segmentPath, "rb") as file:
		for i, splitAddr in enumerate(splitAddrs):
			data = file.read(splitAddr)
			chunkPath = os.path.splitext(segmentPath)[0] + "_" + str(i) + chunkExt
			splittedFiles.append(chunkPath)
			with open(chunkPath, "wb") as fw:
				fw.write(data)
	return splittedFiles