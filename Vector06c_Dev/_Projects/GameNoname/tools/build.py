import os
import sqlite3
import tools.common as common
import tools.animSpriteExport as animSpriteExport
import tools.levelExport as levelExport
import tools.musicExport as musicExport


buildDBPath = "generated\\build.db"
SEGMENT_0000_7F00_ADDR = 0x0000
SEGMENT_8000_0000_ADDR = 0x8000

SEGMENT_0000_7F00_SIZE_MAX = 2 ** 15 - 256 # because an interruption can corrupt the ram-disk memory from STACK_MIN_ADDR = $7f00 to STACK_TEMP_ADDR = $8000
SEGMENT_8000_0000_SIZE_MAX = 2 ** 15

def DelBuildDB():
	common.RunCommand("del " + buildDBPath, "Build DB was deleted")

def ExportAnimSprites(sourcePath, forceExport, mask = False, sourceFolder = "sources\\", generatedFolder = "generated\\"):
	ext = ".json"
	if animSpriteExport.IsFileUpdated(sourceFolder + sourcePath + ext) or forceExport:
		animSpriteExport.Export( 
			mask, 
			sourceFolder + sourcePath + ext, 
			generatedFolder + sourcePath + "Anim.asm", 
			generatedFolder + sourcePath + "Sprites.asm")

		print("animSpriteExport: " + sourceFolder + sourcePath + ext + " got exported.")
		return True
	else:
		#print("animSpriteExport: " + sourceFolder + sourcePath + ext + " is no need to export.")
		return False

def ExportLevel(sourcePath, forceExport, sourceFolder = "sources\\", generatedFolder = "generated\\"):
	ext = ".json"
	if levelExport.IsFileUpdated(sourceFolder + sourcePath + ext) or forceExport:
		levelExport.Export( 
			sourceFolder + sourcePath + ext, 
			generatedFolder + sourcePath + ".asm")
			
		print("levelExport: " + sourceFolder + sourcePath + ext + " got exported.")		
		return True
	else:
		#print("levelExport: " + sourceFolder + sourcePath + ext + " is no need to export.")		
		return False

def ExportMusic(sourcePath, forceExport, sourceFolder = "sources\\", generatedFolder = "generated\\"):
	ext = ".ym"
	if IsFileUpdated(sourceFolder + sourcePath + ext) or forceExport:
		musicExport.Export( 
			sourceFolder + sourcePath + ext, 
			generatedFolder + sourcePath + ".asm")
			
		print("musicExport: " + sourceFolder + sourcePath + ext + " got exported.")		
		return True
	else:	
		return False		

def ExportSegment(segmentPath, forceExport, segmentAddr, externalsOnly = False):
	segmentPathWOExt = os.path.splitext(segmentPath)[0]
	segmentName = os.path.basename(segmentPathWOExt)
	generatedFolder = "generated\\bin\\"

	if IsAsmUpdated(segmentPath) | forceExport:
		common.RunCommand(f"..\\..\\retroassembler\\retroassembler.exe -C=8080 {segmentPath} "
				f" {generatedFolder}{segmentName}.bin >{segmentPathWOExt}Labels.asm")

		CheckSegmentSize(f"{generatedFolder}{segmentName}.bin", segmentAddr)

		ExportLabels(f"{segmentPathWOExt}Labels.asm", externalsOnly)

		chunkPaths = SplitSegment(f"{generatedFolder}{segmentName}.bin", f"{segmentPathWOExt}Labels.asm")

		if len(chunkPaths) == 0:
			common.DeleteFile(f"{generatedFolder}{segmentName}.bin.zx0")
			common.RunCommand(f"tools\\zx0salvador.exe -v -classic {generatedFolder}{segmentName}.bin {generatedFolder}{segmentName}.bin.zx0")
		else:
			for chunkPath in chunkPaths:
				zipfilePathWOExt = os.path.splitext(chunkPath)[0] 
				common.DeleteFile(zipfilePathWOExt + ".bin.zx0")
				common.RunCommand(f"tools\\zx0salvador.exe -v -classic {zipfilePathWOExt}.bin {zipfilePathWOExt}.bin.zx0")
		
		print(f"ExportSegment: {segmentName} segment got exported.")	
		return True
	else:
		return False



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
	for path in includes:
		anyIncUpdated |= IsFileUpdated(asmPath)

	return anyIncUpdated | IsFileUpdated(path)

def IsFileUpdated(path, _buildDBPath = buildDBPath):
	
	con = sqlite3.connect(_buildDBPath)
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

def CheckSegmentSize(path, segmentAddr):
	assert segmentAddr == SEGMENT_0000_7F00_ADDR or segmentAddr == SEGMENT_8000_0000_ADDR, (
		"ERROR: Segment start addr has to be " + hex(SEGMENT_0000_7F00_SIZE_MAX) + " or " + hex(SEGMENT_8000_0000_SIZE_MAX))

	size = os.path.getsize(path)

	if segmentAddr == SEGMENT_0000_7F00_ADDR:
		segmentSizeMax = SEGMENT_0000_7F00_SIZE_MAX
	else:
		segmentSizeMax = SEGMENT_8000_0000_SIZE_MAX

	if size > segmentSizeMax:
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
		label = line.decode('ascii')
		if label.find("__split") != -1:
			splitAddrStr = label[label.find("$")+1:]
			splitAddr = int(splitAddrStr, 16) - firstLabelAddr
			splitAddrs.append(splitAddr)

	if len(splitAddrs) == 0:
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
		'''
		# remain chunk
		remainSize = segmentSize - splitAddr
		data = file.read(remainSize)
		chunkPath = os.path.splitext(segmentPath)[0] + "_" + str(i+1) + chunkExt
		splittedFiles.append(chunkPath)
		with open(chunkPath, "wb") as fw:
			fw.write(data)
		'''
	return splittedFiles