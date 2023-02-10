import os
import sqlite3
import common

SEGMENT_0000_7F00_ADDR = 0x0000
SEGMENT_8000_0000_ADDR = 0x8000

SEGMENT_0000_7F00_SIZE_MAX = 2 ** 15 - 256 # because an interruption can corrupt the ram-disk memory from STACK_MIN_ADDR = $7f00 to STACK_TEMP_ADDR = $8000
SEGMENT_8000_0000_SIZE_MAX = 2 ** 15

SCR_BUFF_SIZE = 8192

ASSET_TYPE_BACK		= "back"
ASSET_TYPE_SPRITE	= "sprite"
ASSET_TYPE_LEVEL	= "level"
ASSET_TYPE_MUSIC	= "music"
ASSET_TYPE_CODE		= "code"
ASSET_TYPE_RAM_DISK_DATA = "ram_disk_data"

EXT_ASM		= ".asm"
EXT_BIN		= ".bin"
EXT_ZX0		= ".zx0"
EXT_BIN_ZX0	= ".bin.zx0"
EXT_ROM		= ".rom"
EXT_YM		= ".ym"

build_db_path = "generated\\build.db"

BIN_DIR = "bin\\"

def build_db_init(path):
	global build_db_path
	dir = os.path.dirname(path)
	if not os.path.exists(dir):
		os.mkdir(dir)

def is_asm_updated(asmPath):
	with open(asmPath, "rb") as file:
		lines = file.readlines()
		
	includes = []
	for line in lines:
		lineStr = line.decode('ascii')
		incStr = ".include "
		incIdx = lineStr.find(incStr)
		
		if incIdx != -1 and lineStr[0] != ";":
			path = lineStr[incIdx + len(incStr)+1:]
			path = common.remove_double_slashes(path)
			pathEndQ1 = path.find('"')
			pathEndQ2 = path.find("'")
			if pathEndQ1 != -1:
				includes.append(path[:pathEndQ1])
			elif pathEndQ2 != -1:
				includes.append(path[:pathEndQ2])
			continue

	anyIncUpdated = False
	for incPath in includes:
		anyIncUpdated |= is_file_updated(incPath)
		if anyIncUpdated:
			break

	return anyIncUpdated | is_file_updated(asmPath)

def is_file_updated(path):
	con = sqlite3.connect(build_db_path)
	cur = con.cursor()
	cur.execute('''CREATE TABLE if not exists files
			   (path text, modtime integer)''')
	
	if not os.path.exists(path):
		return True
	modificationTime = int(os.path.getmtime(path))
	
	
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

def export_labels(path, externals_only = False):
	with open(path, "rb") as file:
		lines = file.readlines()
		
	getAllNextLines = False
	labels = ""
	for line in lines:
		lineStr = line.decode('ascii')
		if getAllNextLines:
			if not externals_only or (externals_only and lineStr[0:2] == "__"):
				labels += lineStr
			continue

		if lineStr.find("Segment: Code") != -1:
			getAllNextLines = True

	with open(path, "w") as file:
		file.write(labels) 

def get_segment_addr(_addr_s):
	addr_s_wo_prefix = common.get_addr_wo_prefix(_addr_s)
	addr = int(addr_s_wo_prefix, 16)

	if addr == SEGMENT_0000_7F00_ADDR:
		return SEGMENT_0000_7F00_ADDR
	if addr == SEGMENT_8000_0000_ADDR:
		return SEGMENT_8000_0000_ADDR
	
	print(f"get_segment_addr ERROR: addr: {_addr_s} is not supported.")
	exit(1)

def get_segment_size_max(segment_addr):
	if segment_addr == SEGMENT_0000_7F00_ADDR:
		return SEGMENT_0000_7F00_SIZE_MAX
	else:
		return SEGMENT_8000_0000_SIZE_MAX

def get_segment_name(bank_id, addr_s_wo_hex_sym, chunk_n = "", chunks = 2):
	result = f'segment_bank{bank_id}_addr{addr_s_wo_hex_sym}'
	if chunk_n != "" and chunks > 1:
		result += "_" + str(chunk_n)
	return result		