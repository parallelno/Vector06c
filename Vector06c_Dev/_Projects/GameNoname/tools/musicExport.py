#!/usr/bin/env python3
import struct
import sys
import os
from subprocess import Popen, PIPE
import common

#from utils import *
import lhafile      # pip3 install lhafile
import io


def chunker(seq, size):
	return (seq[pos:pos + size] for pos in range(0, len(seq), size))

def drop_comment(f):
	comment = ''
	print("AY6 Exporter: song name/credits: ")
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
	print('AY6 Exporter: hdr=', hdr)
	nframes = struct.unpack(">I", f.read(4))[0]      # 16

	print("AY6 Exporter: YM6 file has ", nframes, " frames")

	attrib = struct.unpack(">I", f.read(4))       # 20
	digidrums = struct.unpack(">h", f.read(2))    # 22
	masterclock = struct.unpack(">I", f.read(4))  # 26
	framehz = struct.unpack(">h", f.read(2))      # 28
	loopfrm = struct.unpack(">I", f.read(4))      # 32
	f.read(2) # additional data                   # 34
	print("AY6 Exporter: Masterclock: ", masterclock, "Hz")
	print("AY6 Exporter: Frame: ", framehz, "Hz")

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
		#print(f'AY6 Exporter: complete[{i}]=', complete)
		#print(f'AY6 Exporter: decimated[{i}]=', decimated)
		decbytes = bytes(decimated)
		regs.append(decbytes)  ## brutal decimator

	f.close()

	return [regs, comment1, comment2, comment3]

#=====================================================
import argparse
parser = argparse.ArgumentParser()
parser.add_argument("-i", "--input", help = "Input file")
parser.add_argument("-o", "--output", help = "Output file")
parser.add_argument("-c", "--clean", action='store_false', help = "Delete temp files")
args = parser.parse_args()

if not args.output or not args.input:
	print("AY6 Exporter: -i and -o command-line parameters needed. Use -h for help.")
	exit()

inPath = args.input
outPath = args.output
cleanTmp = args.clean

# test
# inPath = "sources\\music\\song01.ym" 
# outPath = "sources\\music\\song01.asm"

(fileName, ext) = os.path.splitext(inPath)

try:
	[regData, comment1, comment2, comment3] = readym(inPath)
except:
	sys.stderr.write(f'AY6 Exporter: error reading f{inPath}\n')
	exit(1)

with open(outPath, "w") as fileInc:
	# ram-disk addrs
	#fileInc.write(f'.org $a000\n')
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
		binFile = fileName + ("%02d" % i) + ".bin"
		zx0File = fileName + ("%02d" % i) + ".zx0"
		with open(binFile, "wb") as f:
			f.write(c)
		
		common.DeleteFile(zx0File)
		common.RunCommand(f"tools\\zx0salvador.exe -v -classic -w 256 {binFile} {zx0File}")

		with open(zx0File, "rb") as f:
			dbname = "ayRegData" + ("%02d" % i)
			data = f.read()
			fileInc.write(f'{dbname}: .byte ' +  ",".join("$%02x" % x for x in data) + "\n")
		if cleanTmp:
			print("AY6 Exporter: clean up tmp resources")
			common.DeleteFile(binFile)
			common.DeleteFile(zx0File)
	
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

	fileInc.write(f'; buffers for unpacking the streams, must be aligned to 256 byte boundary\n')
	fileInc.write(f'.align $100\n')
	fileInc.write(f'GCPlayerBuffer00 : .storage $100\n')
	fileInc.write(f'GCPlayerBuffer01 : .storage $100\n')  
	fileInc.write(f'GCPlayerBuffer02 : .storage $100\n')
	fileInc.write(f'GCPlayerBuffer03 : .storage $100\n')
	fileInc.write(f'GCPlayerBuffer04 : .storage $100\n')
	fileInc.write(f'GCPlayerBuffer05 : .storage $100\n')
	fileInc.write(f'GCPlayerBuffer06 : .storage $100\n')
	fileInc.write(f'GCPlayerBuffer07 : .storage $100\n')
	fileInc.write(f'GCPlayerBuffer08 : .storage $100\n')
	fileInc.write(f'GCPlayerBuffer09 : .storage $100\n')
	fileInc.write(f'GCPlayerBuffer10 : .storage $100\n')
	fileInc.write(f'GCPlayerBuffer11 : .storage $100\n') 
	fileInc.write(f'GCPlayerBuffer12 : .storage $100\n')
	fileInc.write(f'GCPlayerBuffer13 : .storage $100\n')