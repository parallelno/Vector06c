import os
import sqlite3
import common

SEGMENT_0000_7F00_ADDR = 0x0000
SEGMENT_8000_0000_ADDR = 0x8000

SEGMENT_0000_7F00_SIZE_MAX = 2 ** 15 - 256 # because an interruption can corrupt the ram-disk memory from STACK_MIN_ADDR = $7f00 to STACK_TEMP_ADDR = $8000
SEGMENT_8000_0000_SIZE_MAX = 2 ** 15

CHUNKS_MAX		= 2
CHUNK_SIZE_MAX	= 24 * 1024

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
ASSET_TYPE_DATA 		= "data"

LABEL_POSTFIX_ASSET_START	= "_rd_data_start"
LABEL_POSTFIX_ASSET_END		= "_rd_data_end"

DEBUG_FILE_NAME	= "debug.txt"

EXT_TXT			= ".txt"
EXT_ASM			= ".asm"
EXT_BIN			= ".bin"
EXT_ZX0			= ".zx0"
EXT_BIN_ZX0		= ".bin.zx0"
EXT_UPKR		= ".upkr"
EXT_BIN_UPKR	= ".bin.upkr"
EXT_ROM			= ".rom"
EXT_YM			= ".ym"

PACKER_ZX0				= 0
PACKER_ZX0_SALVADORE	= 1
PACKER_UPKR				= 2

# global vars
build_db_path = "generated\\build.db"
assembler_path = "..\\..\\retroassembler\\retroassembler.exe -C=8080 -c"
emulator_path = "..\\..\\Emu80\\Emu80qt.exe"

assembler_labels_cmd = " -x"

zx0_path = "tools\\zx0 -c"
zx0salvadore_path = "tools\\zx0salvador.exe -v -classic"
upkr_path = "tools\\upkr.exe --z80"

packer_path 	= ""
packer_ext		= ""
packer_bin_ext	= ""

# end global vars

BIN_DIR = "bin\\"

def set_assembler_path(path):
	global assembler_path
	assembler_path = path

def set_assembler_labels_cmd(cmd):
	global assembler_labels_cmd
	assembler_labels_cmd = cmd

def set_packer(packer):
	global packer_path
	global packer_ext
	global packer_bin_ext
	if packer == PACKER_ZX0:
		packer_path = zx0_path
		packer_ext = EXT_ZX0
		packer_bin_ext = EXT_BIN_ZX0

	if packer == PACKER_ZX0_SALVADORE:
		packer_path = zx0salvadore_path
		packer_ext = EXT_ZX0
		packer_bin_ext = EXT_BIN_ZX0

	if packer == PACKER_UPKR:
		packer_path = upkr_path
		packer_ext = EXT_UPKR
		packer_bin_ext = EXT_BIN_UPKR


def set_emulator_path(path):
	global emulator_path
	emulator_path = path

def build_db_init(path):
	global build_db_path
	dir = os.path.dirname(path)
	if not os.path.exists(dir):
		os.mkdir(dir)
	build_db_path = path

def is_asm_updated(asm_path):
	with open(asm_path, "rb") as file:
		lines = file.readlines()

	includes = []
	for line_b in lines:
		line = line_b.decode('ascii')
		inc_str = ".include "
		inc_idx = line.find(inc_str)

		if inc_idx != -1 and line[0] != ";":
			path = line[inc_idx + len(inc_str)+1:]
			path = common.remove_double_slashes(path)
			path_end_q1 = path.find('"')
			path_end_q2 = path.find("'")
			if path_end_q1 != -1:
				includes.append(path[:path_end_q1])
			elif path_end_q2 != -1:
				includes.append(path[:path_end_q2])
			continue

	any_inc_updated = False
	for inc_path in includes:
		any_inc_updated |= is_file_updated(inc_path)
		if any_inc_updated:
			break

	return any_inc_updated | is_file_updated(asm_path)

def is_file_updated(path):
	con = sqlite3.connect(build_db_path)
	cur = con.cursor()
	cur.execute('''CREATE TABLE if not exists files
			   (path text, modtime integer)''')

	if not os.path.exists(path):
		return True
	modification_time = int(os.path.getmtime(path))


	res = cur.execute("SELECT * FROM files WHERE path = '%s'" % path)
	modified = False
	ents = res.fetchall()

	if not ents:
		cur.execute("INSERT INTO files VALUES ('" + path + "', " + str(modification_time) + ")")
		modified = True
	else:
		if ents[0][1] == modification_time:
			modified = False
		else:
			sql = ''' UPDATE files
              SET modtime = ?
              WHERE path = ?'''
			cur.execute(sql, (modification_time, path))
			modified = True

	# done with DB
	con.commit()
	con.close()
	return modified

def store_labels(labels, path):
	labels_txt = ""
	for label_name in labels:
		labels_txt += f"{label_name} ${labels[label_name]:X}\n"

	with open(path, "w") as file:
		file.write(labels_txt)

def export_labels(path, externals_only = False, save_output = True):
	with open(path, "rb") as file:
		lines = file.readlines()

	get_all_next_lines = False
	labels = ""
	label_pairs = {}
	for line_b in lines:
		line = line_b.decode('ascii')
		if get_all_next_lines:
			if (not externals_only or line[0:2] == "__") and line.find("=") != -1:
				labels += line

				label_name_end = line.find(" ")
				label_name = line[:label_name_end]

				second_addr_end = line.find(")")
				if second_addr_end == -1:
					addr_start = line.find("$") + 1
					addr_end = len(line)
					
				else:
					addr_start = line.find("(") + 2
					addr_end = second_addr_end

				addr_s = line[addr_start : addr_end]
				addr = int(addr_s, 16)
				label_pairs[label_name] = addr

			continue

		if line.find("Segment: Code") != -1:
			get_all_next_lines = True
	if save_output:
		with open(path, "w") as file:
			file.write(labels)
	
	return label_pairs

def get_segment_size_max(segment_addr):
	if segment_addr == SEGMENT_0000_7F00_ADDR:
		return SEGMENT_0000_7F00_SIZE_MAX
	else:
		return SEGMENT_8000_0000_SIZE_MAX

def get_segment_name(bank_id, addr_s_wo_hex_sym):
	return f'segment_bank{bank_id}_addr{addr_s_wo_hex_sym}'

def get_chunk_name(bank_id, addr_s_wo_hex_sym, chunk_id):
	return f'chunk_bank{bank_id}_addr{addr_s_wo_hex_sym}' + "_" + str(chunk_id)

def find_backbuffers_bank_ids(source_j, source_j_path):

	# find bank_id_backbuffer and bank_id_backbuffer2
	bank_id_backbuffer = -1
	bank_id_backbuffer2 = -1	
	for bank_id, bank_j in enumerate(source_j["banks"]):
		for segment_j in bank_j["segments"]:
			for asset in segment_j["assets"]:
				if "reserved" in asset and asset["reserved"]:
					if asset["asset_type"] == "backbuffer":
						if bank_id_backbuffer >= 0:
							print(f"export_ram_disk_init ERROR: more than one chunk is reserved for bank_id_backbuffer. path: {source_j_path}\n")
							exit(1)
						bank_id_backbuffer = bank_id

					elif asset["asset_type"] == "backbuffer2":
						if bank_id_backbuffer2 >= 0:
							print(f"export_ram_disk_init ERROR: more than one chunk is reserved for bank_id_backbuffer2. path: {source_j_path}\n")
							exit(1)						
						bank_id_backbuffer2 = bank_id
					continue

	if bank_id_backbuffer < 0:
		print(f"export_ram_disk_init ERROR: no chunk is reserved for bank_id_backbuffer. path: {source_j_path}\n")
		exit(1)
	if bank_id_backbuffer2 < 0:
		print(f"export_ram_disk_init ERROR: no chunk is reserved for bank_id_backbuffer2. path: {source_j_path}\n")
		exit(1)
		
	return bank_id_backbuffer, bank_id_backbuffer2


def compile_asm(source_path, bin_path, labels_path = ""):
	print(f"\n;===========================================================================")
	print(f"build: Compilation {source_path} to {bin_path}")

	if len(labels_path) > 0:
		common.run_command(f"{assembler_path} {assembler_labels_cmd} {source_path} {bin_path} >{labels_path}")	

		if not os.path.exists(bin_path):
			print(f'ERROR: compilation error, path: {source_path}')
			print("Stop export")
			with open(labels_path, "r") as file:
				print(file.read()) 
			exit(1)
		else:
			size = os.path.getsize(bin_path)
			print(f"Success. Size: {size} bytes (${size:X})")
			print("\n")

	else:
		common.run_command(f"{assembler_path} {source_path} {bin_path}")
		if not os.path.exists(bin_path):
			print(f'ERROR: compilation error, path: {source_path}')
			print("Stop export")
			exit(1)