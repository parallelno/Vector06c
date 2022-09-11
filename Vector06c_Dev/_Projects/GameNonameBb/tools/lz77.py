def GetMarkersAndChunkSource(data, idx):
	usedBytes = []
	i=0
	while idx+i<len(data) and len(usedBytes)<255-2:
		b = data[idx+i]
		if b not in usedBytes:
			usedBytes.append(b)
		i+=1

	chunkLen = i
	dupMarker = 0
	chunkEndMarker = 0
	for i in range(256):
		if i not in usedBytes:
			dupMarker = i
			break
	for i in range(256):
		if i == dupMarker:
			continue
		if i not in usedBytes:
			chunkEndMarker = i
			break
	return dupMarker, chunkEndMarker, chunkLen

def find_sublist(sub, bigger):
    if not bigger:
        return -1
    if not sub:
        return 0
    first, rest = sub[0], sub[1:]
    pos = 0
    try:
        while True:
            pos = bigger.index(first, pos) + 1
            if not rest or bigger[pos:pos+len(rest)] == rest:
                return pos
    except ValueError:
        return -1

def GetCode(dupLen, backPtr):
	# code format: 
	# %CCCPPPPP format:
	# CCC - the length of the data to dup. dupLen = CCC + 3, 
	#     dupLen in the range [3, 10], because the length less than three has no sence
	# PPPPP - a relative back pointer to the unpacked data to copy from.
	# copyFromPtr = currentPtr - backPtr. backPtr = PPPPP + dupLen
	#     the backPtr in the range [3, 31+dupLen]

	# %CCCCPPPP format:
	# CCCC - the length of the data to dup. dupLen = CCCC + 3, 
	#     dupLen in the range [3, 18], because the length less than three has no sence
	# PPPP - a relative back pointer to the unpacked data to copy from.
	# copyFromPtr = currentPtr - backPtr. backPtr = PPPP + dupLen
	#     the backPtr in the range [3, 15+dupLen]	

	c = dupLen - 3
	p = backPtr - dupLen
	if codeType == CODE_CCC_PPPPP:
		code = (c << 5) + p
	elif codeType == CODE_CCCC_PPPP:
		code = (c << 4) + p
	return code

def Lz77Packing(data, codeType):
	# find the maximum range of data where is not used 2 different bytes.
	# they will be used as dupMarker and chunkEndMarker
	# more info on the format in in lz77.asm

	minDupLen = 3
	if codeType == CODE_CCC_PPPPP:
		maxDupLen = 2 ** 3 - 1 + minDupLen
		backPtrMax = 2 ** 5 - 1
	elif codeType == CODE_CCCC_PPPP:
		maxDupLen = 2 ** 4 - 1 + minDupLen
		backPtrMax = 2 ** 4 - 1

	compressedData = []

	idx = 0 # because min dupLen = 3
	dupMarker, chunkEndMarker, chunkLen = GetMarkersAndChunkSource(data, idx)
	# dupMarker can't be 0
	if dupMarker == 0:
		dupMarker = chunkEndMarker
		chunkEndMarker = 0

	chunkData = data[idx : idx+chunkLen]
	idx += chunkLen

	chunkIdx = 0
	compressedData.extend([dupMarker, chunkEndMarker])
	# add the first 3 bytes because there is nothing to dup so far
	compressedData.extend(chunkData[0 : minDupLen])
	chunkIdx += minDupLen

	while True:
		# find the longest possible dups in the uncompressed data earliier than idx
		# the max length is maxDupLen, the min is minDupLen
		maxL = min(maxDupLen, chunkIdx)
		maxL = min(len(chunkData) - chunkIdx, maxL)
		if maxL < minDupLen:
			compressedData.extend(chunkData[-2 : ])
			compressedData.append(chunkEndMarker)
			break
		for l in range(maxL, minDupLen-1, -1):
			backPtrMaxClamped = min(backPtrMax + l, chunkIdx)
			dups = chunkData[chunkIdx : chunkIdx + l]
			# find the first accurance of the dups
			lookUp = chunkData[chunkIdx - backPtrMaxClamped: chunkIdx]
			pos = find_sublist(dups, lookUp) - 1
			if pos >= 0:
				break
			
		if pos < 0:
			compressedData.append(chunkData[chunkIdx])
			chunkIdx += 1
			continue
		compressedData.append(dupMarker)
		backPtr = backPtrMaxClamped - pos
		code = GetCode(l, backPtr)
		compressedData.append(code)
		chunkIdx += l



	compressedData.append(0)
	return compressedData

#=====================================================

CODE_CCC_PPPPP = 0
CODE_CCCC_PPPP = 1

codeType = CODE_CCC_PPPPP

import argparse
parser = argparse.ArgumentParser()
parser.add_argument("-i", "--input", help = "Input file")
parser.add_argument("-o", "--output", help = "Output file")
parser.add_argument("-c", "--code", help = "code type (CODE_CCC_PPPPP = 0 / CODE_CCCC_PPPP = 1)")
args = parser.parse_args()

if not args.output or not args.input or not args.code :
	print("Lz77: -c, -i and -o command-line parameters needed. Use -h for help.")
	exit()
fileNameIn = args.input
fileNameOut = args.output
codeType = int(args.code)
"""
# for tests
fileNameIn = "song00.bin.unpack"
fileNameOut = "song00.bin.lz77"
"""
with open(fileNameIn, "rb") as file:
	br = bytearray(file.read())

# bytearray to list
data = []
for b in br:
	data.append(b)
# print data
#print(f'bin file: {fileName} size: {len(data)}\n bin: {data}')

packedData = Lz77Packing(data, codeType)
packedDataB = bytearray(packedData)
print(f"Lz77: codeType: {codeType}, original data size: {len(data)}, compressed lz77: {len(packedData)}")

with open(fileNameOut, "wb") as fBinCut:
	fBinCut.write(packedDataB)