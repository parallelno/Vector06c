import os
import sqlite3
from tools.common import *

buildDBPath = "generated\\build.db"
SEGMENT_0000_7F00_ADDR = 0x0000
SEGMENT_8000_0000_ADDR = 0x8000

SEGMENT_0000_7F00_SIZE_MAX = 2 ** 31 - 256 # because an interruption can corrupt the ram-disk memory from STACK_MIN_ADDR = $7f00 to STACK_TEMP_ADDR = $8000
SEGMENT_8000_0000_SIZE_MAX = 2 ** 31

def DelBuildDB():
	RunCommand("del " + buildDBPath, "Build DB was deleted")

def ExportAminSprites(sourcePath, exporterUpdated, sourceFolder = "sources\\", generatedFolder = "generated\\"):
	jsonExt = ".json"
	if IsFileUpdated(sourceFolder + sourcePath + jsonExt) or exporterUpdated:
		RunCommand("python tools\\animSpriteExport.py -s True -i " + sourceFolder + sourcePath + jsonExt + 
			" -oa " + generatedFolder + sourcePath + "Anim.dasm " + 
			" -os " + generatedFolder + sourcePath + "Sprites.dasm")
		print("animSpriteExport: " + sourceFolder + sourcePath + jsonExt + " got exported.")
		return True
	else:
		print("animSpriteExport: " + sourceFolder + sourcePath + jsonExt + " wasn't updated. No need to export.")
		return False

def ExportLevel(sourcePath, exporterUpdated, sourceFolder = "sources\\", generatedFolder = "generated\\"):
	jsonExt = ".json"
	if (IsFileUpdated(sourceFolder + sourcePath + jsonExt) or exporterUpdated):
		RunCommand("python tools\\levelExport.py -i " + sourceFolder + sourcePath + jsonExt + 
			" -o " + generatedFolder + sourcePath + ".dasm")
		print("levelExport: " + sourceFolder + sourcePath + jsonExt + " got exported.")
		return True
	else:
		print("levelExport: " + sourceFolder + sourcePath + jsonExt + " wasn't updated. No need to export.")		
		return False

def IsFileUpdated(path, _buildDBPath = buildDBPath):
	
	con = sqlite3.connect(_buildDBPath)
	cur = con.cursor()
	cur.execute('''CREATE TABLE if not exists files
			   (path text, modtime real)''')
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

def ExportLabels(path):
	with open(path, "rb") as file:
		lines = file.readlines()
		
	getAllNextLines = False
	labels = ""
	for line in lines:
		lineStr = line.decode('ascii')
		if getAllNextLines:
			labels += lineStr#[0: -1]
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
		assert size < SEGMENT_0000_7F00_SIZE_MAX, f"ERROR: the segment size can't be bigger " + hex(SEGMENT_0000_7F00_SIZE_MAX)
	
	if segmentAddr == SEGMENT_8000_0000_ADDR:
		assert size < SEGMENT_8000_0000_SIZE_MAX, f"ERROR: the segment size can't be bigger " + hex(SEGMENT_8000_0000_SIZE_MAX)