#!/usr/bin/env python3
import struct
import sys
import os
from pathlib import Path
import common
import build

#from utils import *
import lhafile      # pip3 install lhafile
import io


def chunker(seq, size):
	return (seq[pos:pos + size] for pos in range(0, len(seq), size))

def drop_comment(f):
	comment = ''
	print("musicExport: song name/credits: ")
	while True:
		b = f.read(1)
		if b[0] == 0:
			break
		comment = comment + chr(b[0])
		print(chr(b[0]), end='')
	print()
	return comment

def readym(filename):
	try:
		lf = lhafile.Lhafile(filename)
		data = lf.read(lf.namelist()[0])
		f = io.BytesIO(data)
	except:
		f = open(filename, "rb")

	hdr = f.read(12) # YM6!LeOnArD!               # 12
	print('musicExport: hdr=', hdr)
	nframes = struct.unpack(">I", f.read(4))[0]      # 16

	print("musicExport: YM6 file has ", nframes, " frames")

	attrib = struct.unpack(">I", f.read(4))       # 20
	digidrums = struct.unpack(">h", f.read(2))    # 22
	masterclock = struct.unpack(">I", f.read(4))  # 26
	framehz = struct.unpack(">h", f.read(2))      # 28
	loopfrm = struct.unpack(">I", f.read(4))      # 32
	f.read(2) # additional data                   # 34
	print("musicExport: Masterclock: ", masterclock, "Hz")
	print("musicExport: Frame: ", framehz, "Hz")

	# skip digidrums but we don't do that here..

	comment1 = drop_comment(f)
	comment2 = drop_comment(f)
	comment3 = drop_comment(f)

	regs=[]
	for i in range(16):
		complete = list(f.read(nframes))
		chu = chunker(complete, 2)
		#decimated = [x if x < y else y for x, y in chu]
		#decimated = complete[::2]
		#decimated = [x if x != 255 else y for x, y in chu]
		decimated = complete
		#print(f'musicExport: complete[{i}]=', complete)
		#print(f'musicExport: decimated[{i}]=', decimated)
		decbytes = bytes(decimated)
		regs.append(decbytes)  ## brutal decimator

	f.close()

	return [regs, comment1, comment2, comment3]

#=====================================================
def export_if_updated(source_path, generated_dir, force_export):
	source_path_wo_ext = os.path.splitext(source_path)[0]
	source_name = os.path.basename(source_path_wo_ext)
	export_paths = {"ram_disk" : generated_dir + source_name + build.EXT_ASM }

	if force_export or build.is_file_updated(source_path):
		export(
			source_path, 
			export_paths["ram_disk"])
			
		print(f"music: {source_path} got exported.")		
		return True, export_paths
	else:
		return False, export_paths

def export(source_path, export_path, cleanTmp = True):

	source_name = os.path.splitext(source_path)[0]
	exportDir = str(Path(export_path).parent) + "\\"
	if not os.path.exists(exportDir):
		os.mkdir(exportDir)

	try:
		[regData, comment1, comment2, comment3] = readym(source_path)
	except:
		sys.stderr.write(f'musicExport: error reading f{source_path}\n')
		exit(1)

	with open(export_path, "w") as fileInc:
		# task stacks
		fileInc.write(f'GCP_WORD_LEN = 2\n')
		fileInc.write(f'GCP_TEMP_ADDR = 0\n')
		fileInc.write(f'GC_PLAYER_TASKS = 14\n')
		fileInc.write(f'GC_PLAYER_STACK_SIZE = 16\n')

		# song's credits
		fileInc.write(f'; {comment1}\n; {comment2}\n; {comment3}\n')
		# redData ptrs. 
		fileInc.write(f'GCPlayerAyRegDataPtrs: .word ')
		for i, _ in enumerate(regData[0:14]):
			fileInc.write(f'ayRegData{i:02d}, ')
		fileInc.write(f'\n')

		for i, c in enumerate(regData[0:14]):
			binFile = f"source_name{i:02d}.bin"
			zx0File = f"source_name{i:02d}.zx0"
			with open(binFile, "wb") as f:
				f.write(c)
			
			common.delete_file(zx0File)
			common.run_command(f"tools\\zx0salvador.exe -v -classic -w 256 {binFile} {zx0File}")

			with open(zx0File, "rb") as f:
				dbname = f"ayRegData{i:02d}"
				data = f.read()
				fileInc.write(f'{dbname}: .byte ' + ",".join("$%02x" % x for x in data) + "\n")
			if cleanTmp:
				print("musicExport: clean up tmp resources")
				common.delete_file(binFile)
				common.delete_file(zx0File)

		fileInc.write(f'; buffers for unpacking the streams, must be aligned to 256 byte boundary\n')
		fileInc.write(f'.align $100\n')
		fileInc.write(f'gc_player_buffer00 : .storage $100\n')
		fileInc.write(f'gc_player_buffer01 : .storage $100\n')  
		fileInc.write(f'gc_player_buffer02 : .storage $100\n')
		fileInc.write(f'gc_player_buffer03 : .storage $100\n')
		fileInc.write(f'gc_player_buffer04 : .storage $100\n')
		fileInc.write(f'gc_player_buffer05 : .storage $100\n')
		fileInc.write(f'gc_player_buffer06 : .storage $100\n')
		fileInc.write(f'gc_player_buffer07 : .storage $100\n')
		fileInc.write(f'gc_player_buffer08 : .storage $100\n')
		fileInc.write(f'gc_player_buffer09 : .storage $100\n')
		fileInc.write(f'gc_player_buffer10 : .storage $100\n')
		fileInc.write(f'gc_player_buffer11 : .storage $100\n') 
		fileInc.write(f'gc_player_buffer12 : .storage $100\n')
		fileInc.write(f'gc_player_buffer13 : .storage $100\n')


		fileInc.write(f'; array of task stack pointers. GCPlayerTaskSPs[i] = taskSP\n')
		fileInc.write(f'GCPlayerTaskSPs: .storage GCP_WORD_LEN * GC_PLAYER_TASKS\n')
		fileInc.write(f'GCPlayerTaskSPsEnd     = *\n')
		fileInc.write(f'; task stacks\n')
		fileInc.write(f'GCPlayerTaskStack00: .storage GC_PLAYER_STACK_SIZE\n')
		fileInc.write(f'GCPlayerTaskStack01: .storage GC_PLAYER_STACK_SIZE\n')
		fileInc.write(f'GCPlayerTaskStack02: .storage GC_PLAYER_STACK_SIZE\n')
		fileInc.write(f'GCPlayerTaskStack03: .storage GC_PLAYER_STACK_SIZE\n')
		fileInc.write(f'GCPlayerTaskStack04: .storage GC_PLAYER_STACK_SIZE\n')
		fileInc.write(f'GCPlayerTaskStack05: .storage GC_PLAYER_STACK_SIZE\n')
		fileInc.write(f'GCPlayerTaskStack06: .storage GC_PLAYER_STACK_SIZE\n')
		fileInc.write(f'GCPlayerTaskStack07: .storage GC_PLAYER_STACK_SIZE\n')
		fileInc.write(f'GCPlayerTaskStack08: .storage GC_PLAYER_STACK_SIZE\n')
		fileInc.write(f'GCPlayerTaskStack09: .storage GC_PLAYER_STACK_SIZE\n')
		fileInc.write(f'GCPlayerTaskStack10: .storage GC_PLAYER_STACK_SIZE\n')
		fileInc.write(f'GCPlayerTaskStack11: .storage GC_PLAYER_STACK_SIZE\n')
		fileInc.write(f'GCPlayerTaskStack12: .storage GC_PLAYER_STACK_SIZE\n')
		fileInc.write(f'GCPlayerTaskStack13: .storage GC_PLAYER_STACK_SIZE\n')

		fileInc.write(f'; a pointer to a current task sp. *GCPlayerCurrentTaskSPp = GCPlayerTaskSPs[currentTask]\n')
		fileInc.write(f'GCPlayerCurrentTaskSPp: .word GCP_TEMP_ADDR;\n')
