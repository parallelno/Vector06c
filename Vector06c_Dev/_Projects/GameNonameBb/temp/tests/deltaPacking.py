from operator import xor
MIN_PACKED_SEQ = 5

#===================================================
def ToRle(data):
	# find indexes and length of sequences of duplicates
	sequencesN = []
	i = 0
	while i < len(data):
		dup, l, b = IsDups(data, i)
		if dup : 
			sequencesN.append((i, l, b))
			i += l
		else:
			i += 1
	# extract seqs
	sequences = []
	s = 0
	for i, l, b in sequencesN:
		if i != 0:
			if s == 0:
				sequences.append((CODE_UNIQUE, data[0 : i]))
			else :
				prevI, prevL, prevB = sequencesN[s-1]
				if prevI + prevL != i:
					prevUniqueSeqI = prevI + prevL
					sequences.append((CODE_UNIQUE, data[prevUniqueSeqI : i]))
		sequences.append((CODE_DUPS, data[i : i+l]))
		s += 1
	# add the last unique seq if there is any left
	if len(sequencesN) != 0 and sequencesN[-1][0] + sequencesN[-1][1] < len(data):
		i = sequencesN[-1][0] + sequencesN[-1][1]
		l = len(data) - i
		sequences.append((CODE_UNIQUE, data[i : i+l]))

	# calc unpack length to control rle packing
	# seqsLength = 0
	# for code, seq in sequences:
	# 	seqsLength += len(seq)
	# print (f"seqsLength: {seqsLength}")

	# pack in chunks
	rle = []
	for code, seq in sequences:
		rle.extend(MakeChunk(code, seq))
	rle.append(REPEAT_CODE_END)
	return rle

def MakeRepeatCode(_length, _isUniqueBytes):
	code = _length << 1
	if _isUniqueBytes : code += 1
	return code

def MakeChunk(code, _sequence):
	if code == CODE_UNIQUE:
		chunk = [MakeRepeatCode(len(_sequence), True)]
		chunk.extend(_sequence)
		return chunk

	return [MakeRepeatCode(len(_sequence), False), _sequence[0]]

def IsDups(data, _i):
	_i += 2
	l = 2
	res = False
	dup = -1
	while _i< len(data):
		if data[_i] == data[_i-1] and data[_i] == data[_i-2] :
			res = True
			dup = data[_i]
			l += 1
			_i += 1
		else: break

	return res, l, dup

def LessPopularByte(data):
	popB = {}
	for b in data:
		if b not in popB: popB[b] = 1
		else: popB[b] += 1
	sorted_popB = sorted(popB.items(), key=lambda kv: kv[1])
	return sorted_popB[0][0], sorted_popB

def GetDeltaSeq(seq, diffBits, deltaSeqFirstN, marker, markerIdxs):
	if len(seq) < MIN_PACKED_SEQ : return [], [], 0

	deltaSeq = [deltaSeqFirstN]
	dataForRle = []
	# preserve one bit for a sign
	diffBits -= 1
	# calculate the max delta
	delta = (1 << diffBits) - 1
	# positive delta is one step bigger because the zero value will be interpretted as 1
	deltaP = delta
	deltaN = -delta
	i = 0
	delFirst = False
	while i < len(seq):
		a = deltaSeq[-1]
		b = seq[i]
		c1 = a <= b
		c2 = a+deltaP >= b
		c3 = (a+deltaN + 256) % 256
		c4 = a+deltaN <= b
		c5 = seq[i-1]+deltaN
		c6 = (a+deltaP) % 256
		if (    a <= b and
				(a+deltaP >= b or 
				(a <= (a+deltaN + 256) % 256 and (a+deltaN + 256) % 256 <= b ) )
			or  a > b and
			    (a+deltaN <= b or 
				(a > (a+deltaP) % 256 and (a+deltaP) % 256 >= b ) )
		):
			deltaSeq.append(b)
			# mark all places where a delta seq was stored in the original data
			dataForRle.append(marker)
			# remove these ids becasue we do not need to restore them
			if i in markerIdxs : markerIdxs.remove(i)
		else:
			dataForRle.append(b)
		i += 1
		
	if len(deltaSeq) == 1 : return [], [], 0
	# remove the first byte becasue it is deltaSeqFirstN
	return deltaSeq[1:len(deltaSeq)], dataForRle, markerIdxs

def ToRle2(data):
	# find less popular byte to be used as a marker for compressed sequence
	marker, popBytes = LessPopularByte(data)
	# preserve all entrance of this byte
	markerIdxs = []
	for i in range(len(data)):
		if data[i] == marker: markerIdxs.append(i)

	# compress data for every deltaSeqFirstN
	diffBits = 2
	deltaSeqs = []

	while diffBits < 8:
		deltaSeqFirstN = 0
		BYTE_RANGE = 256
		while deltaSeqFirstN < BYTE_RANGE:
			deltaSeq, dataForRle, newMarkerIdxs = GetDeltaSeq(data, diffBits, deltaSeqFirstN, marker, markerIdxs)
			if len(deltaSeq) > 0:
				
				rle = ToRle(dataForRle)
				rleSize = len(rle)
				deltaSeqPackedSize = (len(deltaSeq) * diffBits) // 8 + 1
				markerIdxsSize = len(newMarkerIdxs) + 1
				packedDataSize = rleSize + markerIdxsSize + deltaSeqPackedSize
				
				deltaSeqs.append((deltaSeqFirstN, packedDataSize, len(deltaSeq), deltaSeq, dataForRle, newMarkerIdxs, diffBits, rle))

			deltaSeqFirstN += 1

		diffBits += 1

	# find the longest deltaSeq
	deltaSeqFirstN, packedDataSize, l, deltaSeq, dataForRle, newMarkerIdxs, diffBits, rle = sorted(deltaSeqs, key = lambda x: x[1], reverse=False)[0]
	rleSize = len(rle)
	markerIdxsSize = len(newMarkerIdxs) + 1
	deltaSeqPackedSize = (l * diffBits) // 8 + 1
	print(f"original size: {len(data)}, rleSize: {rleSize}, diffBits: {diffBits}, deltaSeqPackedSize: {deltaSeqPackedSize}, markerIdxsSize: {markerIdxsSize}, compressed size: {packedDataSize}")

	print(f"rle size: {len(ToRle(data))}")
	qwqqw = 0
#============================================================

CODE_UNIQUE = 1
CODE_DUPS = -1
REPEAT_CODE_END = 0
#MIN_DELTA_SEC_LEN = 4

fileName = "tests/accel3.rom"

with open(fileName, "rb") as file:
	br = bytearray(file.read())

# bytearray to list
data = []
for b in br: data.append(b)
print(f'bin file: {fileName} size: {len(data)}\n bin: {data}')

# find the most popular bytes
lessPop, sorted_popB = LessPopularByte(data)
print(f'popB: {sorted_popB}')

# to upgraded rle
rle2 = ToRle2(data)

e = 0



