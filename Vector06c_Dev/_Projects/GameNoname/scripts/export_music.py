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
	print("export_music: song name/credits: ")
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
	print('export_music: hdr=', hdr)
	nframes = struct.unpack(">I", f.read(4))[0]      # 16

	print("export_music: YM6 file has ", nframes, " frames")

	attrib = struct.unpack(">I", f.read(4))       # 20
	digidrums = struct.unpack(">h", f.read(2))    # 22
	masterclock = struct.unpack(">I", f.read(4))  # 26
	framehz = struct.unpack(">h", f.read(2))      # 28
	loopfrm = struct.unpack(">I", f.read(4))      # 32
	f.read(2) # additional data                   # 34
	print("export_music: Masterclock: ", masterclock, "Hz")
	print("export_music: Frame: ", framehz, "Hz")

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
		#print(f'export_music: complete[{i}]=', complete)
		#print(f'export_music: decimated[{i}]=', decimated)
		decbytes = bytes(decimated)
		regs.append(decbytes)  ## brutal decimator

	f.close()

	return [regs, comment1, comment2, comment3]

#=====================================================
def export_if_updated(source_path, generated_dir, force_export):
	source_name = common.path_to_basename(source_path)

	export_paths = {"ram_disk" : generated_dir + source_name + build.EXT_ASM }

	if force_export or build.is_file_updated(source_path):
		export( source_path, export_paths["ram_disk"])
			
		print(f"export_music: {source_path} got exported.")		
		return True, export_paths
	else:
		return False, export_paths

def export(source_path, export_path, cleanTmp = True):

	source_name = os.path.splitext(source_path)[0]
	export_dir = str(Path(export_path).parent) + "\\"
	if not os.path.exists(export_dir):
		os.mkdir(export_dir)

	try:
		[regData, comment1, comment2, comment3] = readym(source_path)
	except:
		sys.stderr.write(f'export_music: error reading f{source_path}\n')
		exit(1)

	with open(export_path, "w") as fileInc:
		# task stacks
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
			common.run_command(f"{build.zx0_path} -w 256 {binFile} {zx0File}")

			with open(zx0File, "rb") as f:
				dbname = f"ayRegData{i:02d}"
				data = f.read()
				fileInc.write(f'{dbname}: .byte ' + ",".join("$%02x" % x for x in data) + "\n")
			if cleanTmp:
				print("export_music: clean up tmp resources")
				common.delete_file(binFile)
				common.delete_file(zx0File)
