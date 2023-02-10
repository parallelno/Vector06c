import os

def palette_to_asm(image, charJ, path = "", labelPrefix = ""):
	# usially there are color tiles in top row in the image.
	paletteCoords = charJ["palette"]
	colors = {}
	pathWOExt = os.path.splitext(path)[0]
	labelPostfix = os.path.basename(pathWOExt)
	asm = "; " + path + "\n"
	asm += labelPrefix + "_palette_" + labelPostfix + ":\n"
	palette = image.getpalette()

	for i, pos in enumerate(paletteCoords):
		x = pos["x"]
		y = pos["y"]
		idx = image.getpixel((x, y))
		r = palette[idx * 3]
		g = palette[idx * 3 + 1]
		b = palette[idx * 3 + 2]
		colors[(r, g, b)] = i
		r = r >> 5
		g = g >> 5
		g = g << 3
		b = b >> 6
		b = b << 6
		color = b | g | r
		if i % 4 == 0 : asm += "			.byte "
		asm += "%" + format(color, '08b') + ", "
		if i % 4 == 3 : asm += "\n"
		
	return asm + "\n", colors

def  remap_colors(image, colors):
	palette = image.getpalette()
	colorMatchingTable = {}
	
	for idx in range(len(palette) //3):
		r = palette[idx*3]
		g = palette[idx*3 + 1]
		b = palette[idx*3 + 2]
		rgb = (r,g,b)
		if rgb not in colors: 
			continue
		cidx = colors[rgb]
		colorMatchingTable[idx] = cidx
	
	w = image.width
	h = image.height

	for y in range(h) :
		for x in range(w) :
			colorIdx = image.getpixel((x, y))
			newColorIdx = colorMatchingTable[colorIdx]
			image.putpixel((x,y), newColorIdx)
	return image

color_index_to_bit = [
		(0,0,0,0), # color idx = 0
		(0,0,0,1),
		(0,0,1,0), # color idx = 2
		(0,0,1,1),
		(0,1,0,0), # color idx = 4
		(0,1,0,1),
		(0,1,1,0),
		(0,1,1,1),
		(1,0,0,0), # color idx = 8
		(1,0,0,1),
		(1,0,1,0),
		(1,0,1,1),
		(1,1,0,0),
		(1,1,0,1),
		(1,1,1,0),
		(1,1,1,1),
	]

def indexes_to_bit_lists(tileImg):
	bits0 = [] # 8000-9FFF # from left to right, from bottom to top
	bits1 = [] # A000-BFFF
	bits2 = [] # C000-DFFF
	bits3 = [] # E000-FFFF
	for line in tileImg:
		for colorIdx in line:
			bit0, bit1, bit2, bit3 = color_index_to_bit[colorIdx]
			bits0.append(bit0) 
			bits1.append(bit1)
			bits2.append(bit2)
			bits3.append(bit3)
	return bits0, bits1, bits2, bits3

def combine_bits_to_bytes(_bits):
	bytes = []
	i = 0
	while i < len(_bits):
		byte = 0
		for j in range(8):
			byte += _bits[i] << 7-j
			i += 1
		bytes.append(byte)
	return bytes

def path_to_filename(path):
	path_wo_ext = os.path.splitext(path)[0]
	name = os.path.basename(path_wo_ext)
	return name

def is_bytes_zeros(bytes):
	for byte in bytes: 
		if byte != 0 : return False
	return True

def bytes_to_asm(data):
	asm = "			.byte "
	for i, byte in enumerate(data):
		asm += str(byte) + ","
	return asm + "\n"

def bin_to_asm(path, outPath):
	with open(path, "rb") as file:
		txt = ""
		while True:
			data = file.read(32)
			if data:
				txt += "\n.byte "
				for byte in data:
					txt += str(byte) + ", " 
			else: break
		
		with open(outPath, "w") as fw:
			fw.write(txt)

def run_command(command, comment = "", checkPath = ""):
	if comment != "" : 
		print(comment)
	if checkPath == "" or os.path.isfile(checkPath):
		os.system(command)
	else:
		print(f"run_command ERROR: command: {command} is failed. file {checkPath} doesn't exist")
		exit(1)

def delete_file(path):
	if os.path.isfile(f"{path}"):
		os.remove(f"{path}")

def str_to_bool(v):
    if isinstance(v, bool):
        return v
    if v.lower() in ('yes', 'true', 't', 'y', '1'):
        return True
    else:
        return False

def remove_double_slashes(path):
	res = ""
	doubledSlashe = False
	for char in path:
		if char != '\\':
			res += char
			doubledSlashe = False
		else:
			if doubledSlashe == False:
				res += char
				doubledSlashe = True
			else:
				doubledSlashe = False
	return res

def double_slashes(path):
	res = ""
	for char in path:
		res += char
		if char == '\\':
			res += char
	return res

def get_addr_wo_prefix(addr_s):
	if addr_s[0] == "$":
		addr_s = addr_s[1:]
	elif len(addr_s) > 1 and addr_s[1] == "x":
		addr_s = addr_s[2:]

	if int(addr_s, 16) == 0:
		addr_s = "0"

	return addr_s

def align_string(str, allign, to_left = False):
	addition = "                   "
	if to_left:
		str = addition + str
		return str[-allign:]
	else:
		str += addition
		return str[0:allign]

def get_label_addr(path, _label):
	with open(path, "rb") as file:
		labels = file.readlines()

	if len(labels) == 0:
		return 0

	for line_a in labels:
		line = line_a.decode('ascii')
		if line.find(_label) != -1:
			addr_s = line[line.find("$")+1:]
			return int(addr_s, 16)

	return -1