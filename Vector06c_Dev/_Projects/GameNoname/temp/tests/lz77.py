
def PopularBytes(data, reverse = True):
	popB = {}
	for i in range(256): 
		popB[i] = 0
	for b in data: 
		popB[b] += 1
	popBSorted = sorted(popB.items(), key=lambda kv: kv[1], reverse = reverse)
	return popBSorted
    
def Pack(data):
	# get two unused bytes
	popB = PopularBytes(data, False)
	checkDupMarker = popB[0][0]
	checkChunkEndMarker = popB[1][0]
	packedData = [checkDupMarker, checkChunkEndMarker]

	# look up the sequence
	i = 15
	while i < len(data):
		b = data[i]

	a = 1

#===================================================
fileName = "tests/accel2.rom"

with open(fileName, "rb") as file:
	br = bytearray(file.read())

# bytearray to list
data = []
for b in br: data.append(b)
print(f'bin file: {fileName} size: {len(data)}\n bin: {data}')

packedData = Pack(data)

print(f"original data size: {len(data)}, compressed lz77: {len(packedData)}")