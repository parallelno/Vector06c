def PairCount(pair, data):
	count = 0
	i = 1
	p1, p2 = pair
	while i < len(data):
		pp1 = data[i-1]
		pp2 = data[i]
		if p1 == pp1 and p2 == pp2:
			count += 1
			i += 2
		else:
			i += 1
	return count

def FindPopularPairs(data):
	pairs = {}
	i = 1
	while i< len(data):
		p1 = data[i-2]
		p2 = data[i-1]
		pair = (p1, p2)
		if pair not in pairs:
			count = PairCount(pair, data)
			if count > 0:
				pairs[pair] = count
		i += 1

	pairsSorted = sorted(pairs.items(), key=lambda kv: kv[1], reverse = True)
	return pairsSorted

def TriadCount(triad, data):
	count = 0
	i = 2
	p1, p2, p3 = triad
	while i < len(data):
		pp1 = data[i-2]
		pp2 = data[i-1]
		pp3 = data[i]

		if p1 == pp1 and p2 == pp2 and p3 == pp3:
			count += 1
			i += 3
		else:
			i += 1
	return count

def FindPopularTriads(data):
	triads = {}
	i = 2
	while i< len(data):
		p1 = data[i-2]
		p2 = data[i-1]
		p3 = data[i]
		triad = (p1, p2, p3)
		if triad not in triads:
			count = TriadCount(triad, data)
			if count > 0:
				triads[triad] = count
		i += 1

	pairsSorted = sorted(triads.items(), key=lambda kv: kv[1], reverse = True)
	return pairsSorted

def FindLinerSeqs3(data):
	linearSeqs = []
	i = 2
	while i< len(data):
		p1 = data[i-2]
		p2 = data[i-1]
		p3 = data[i]

		if p2-p1 == p3-p2:
			linearSeqs.append((p1, p2, p3))
		i += 1
	return linearSeqs

def FindLinerSeqs4(data):
	linearSeqs = []
	i = 3
	while i< len(data):
		p1 = data[i-3]
		p2 = data[i-2]
		p3 = data[i-1]
		p4 = data[i]

		if p2-p1 == p3-p2 == p4-p3:
			linearSeqs.append((p1, p2, p3, p4))
		i += 1

	return linearSeqs	


def PopularBytes(data, reverse = True):
	popB = {}
	for i in range(256): 
		popB[i] = 0
	for b in data: 
		popB[b] += 1
	popBSorted = sorted(popB.items(), key=lambda kv: kv[1], reverse = reverse)
	return popBSorted

def ToSmallDict(data):
	if len(data) < 2 : return []
	# find unused bytes in data to use it as markers
	popB = PopularBytes(data, False)
	marker = popB[0][0]
	# if there is no unused bytes, give up
	if popB[0][1] != 0 : return []
	pairs = FindPopularPairs(data)
	
	#pairs = []
	# # get pairs that are more than two times present in this data
	# for pair, count in popPairs:
	# 	if count > 2: pairs.append(pair)

	# replace pairs that are more than one time present in the dataa with markers
	packedData =[]
	i = 1
	markerId = 0
	usedPairs = {}
	while i < len(data) and markerId<len(popB) and popB[markerId][1] == 0:
		pairId = 0
		foundPair = False
		while pairId < len(pairs) and pairs[pairId][1] > 1:
			pair, _ = pairs[pairId]
			p1, p2 = pair
			pp1 = data[i-1]
			pp2 = data[i]
			marker, _ = popB[markerId]
			if p1 == pp1 and p2 == pp2:
				packedData.append(marker)
				i += 2
				markerId += 1
				if pair not in usedPairs: 
					usedPairs[pair] = 1
				else:
					usedPairs[pair] += 1
				foundPair = True
				break
			pairId += 1
		if i == 1 : packedData.append(pp1)
		if not foundPair : 
			packedData.append(pp2)
			i += 1
	origSize = len(data)
	packedDataSize = len(packedData)
	dictSize = len(usedPairs) * 3
	compressedSize = packedDataSize + dictSize
	iii = 0

#==============================

fileName = "tests/accel2.rom"

with open(fileName, "rb") as file:
	br = bytearray(file.read())

# bytearray to list
data = []
for b in br: data.append(b)
print(f'bin file: {fileName} size: {len(data)}\n bin: {data}')

# find the most popular bytes
# sorted_popB = PopularBytes(data)
# print(f'popB: {sorted_popB}')
# find popular  triads
popTriads = FindPopularTriads(data)
# to upgraded rle

# for test a linear seqs
linerSeqs3 = FindLinerSeqs3(data)
linerSeqs4 = FindLinerSeqs4(data)

packed = ToSmallDict(data)

e = 0

