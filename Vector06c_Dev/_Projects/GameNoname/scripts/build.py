import os
import sqlite3
import common

SEGMENT_0000_7F00_ADDR = 0x0000
SEGMENT_8000_0000_ADDR = 0x8000

SEGMENT_0000_7F00_SIZE_MAX = 2 ** 15 - 256 # because an interruption can corrupt the ram-disk memory from STACK_MIN_ADDR = $7f00 to STACK_TEMP_ADDR = $8000
SEGMENT_8000_0000_SIZE_MAX = 2 ** 15

SCR_BUFF_SIZE = 8192

ASSET_TYPE_BACK			= "back"
ASSET_TYPE_FONT			= "font"
ASSET_TYPE_FONT_RD		= "font_rd" # font_gfx_ptrs.asm will be included into the main programm. it has to be included into the ram-disk asm code manually instead.
ASSET_TYPE_SPRITE		= "sprite"

ASSET_TYPE_LEVEL		= "level"
ASSET_TYPE_LEVEL_DATA	= "level_data"
ASSET_TYPE_LEVEL_GFX	= "level_gfx"

ASSET_TYPE_TILED_IMG	= "tiled_img"
ASSET_TYPE_TILED_IMG_DATA	= "tiled_img_data"
ASSET_TYPE_TILED_IMG_GFX	= "tiled_img_gfx"

ASSET_TYPE_DECAL		= "decal"
ASSET_TYPE_IMAGE		= "image"
ASSET_TYPE_MUSIC		= "music"
ASSET_TYPE_CODE			= "code"
ASSET_TYPE_RAM_DISK_DATA = "ram_disk_data"

EXT_ASM			= ".asm"
EXT_BIN			= ".bin"
EXT_ZX0			= ".zx0"
EXT_BIN_ZX0		= ".bin.zx0"
EXT_BIN_UPKR	= ".bin.upkr"
EXT_ROM			= ".rom"
EXT_YM			= ".ym"

# global vars
build_db_path = "generated\\build.db"
assembler_path = "..\\..\\retroassembler\\retroassembler.exe -C=8080 -c"
assembler_labels_cmd = " -x"
zx0_path = "tools\\zx0salvador.exe -v -classic"
upkr_path = "tools\\upkr.exe --z80"
emulator_path = "..\\..\\Emu80\\Emu80qt.exe"
# end global vars

BIN_DIR = "bin\\"

def set_assembler_path(path):
	global assembler_path
	assembler_path = path

def set_assembler_labels_cmd(cmd):
	global assembler_labels_cmd
	assembler_labels_cmd = cmd

def set_zx0_path(path):
	global zx0_path
	zx0_path = path

def set_emulator_path(path):
	global emulator_path
	emulator_path = path

def build_db_init(path):
	global build_db_path
	dir = os.path.dirname(path)
	if not os.path.exists(dir):
		os.mkdir(dir)
	build_db_path = path

def is_asm_updated(asmPath):
	with open(asmPath, "rb") as file:
		lines = file.readlines()

	includes = []
	for line in lines:
		line_str = line.decode('ascii')
		inc_str = ".include "
		inc_idx = line_str.find(inc_str)

		if inc_idx != -1 and line_str[0] != ";":
			path = line_str[inc_idx + len(inc_str)+1:]
			path = common.remove_double_slashes(path)
			path_end_q1 = path.find('"')
			path_end_q2 = path.find("'")
			if path_end_q1 != -1:
				includes.append(path[:path_end_q1])
			elif path_end_q2 != -1:
				includes.append(path[:path_end_q2])
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

	get_all_next_lines = False
	labels = ""
	for line in lines:
		line_str = line.decode('ascii')
		if get_all_next_lines:
			if not externals_only or (externals_only and line_str[0:2] == "__"):
				labels += line_str
			continue

		if line_str.find("Segment: Code") != -1:
			get_all_next_lines = True

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

def get_segment_name(bank_id, addr_s_wo_hex_sym):
	return f'segment_bank{bank_id}_addr{addr_s_wo_hex_sym}'

def get_chunk_name(bank_id, addr_s_wo_hex_sym, chunk_id):
	return f'chunk_bank{bank_id}_addr{addr_s_wo_hex_sym}' + "_" + str(chunk_id)

def get_chunk_start_label_name(bank_id, addr_s_wo_hex_sym, chunk_id):
	return f'__chunk_start_bank{bank_id}_addr{addr_s_wo_hex_sym}_{chunk_id}'

def get_chunk_end_label_name(bank_id, addr_s_wo_hex_sym, chunk_id):
	return f'__chunk_end_bank{bank_id}_addr{addr_s_wo_hex_sym}_{chunk_id}'