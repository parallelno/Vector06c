IMAGE_COLORS_MAX = 16

def bytes_to_asm_tiled(data):
	asm = ""
	for tile in data:
		asm += "			.byte "
		for b in tile:
			asm += str(b) + ","
		asm += "\n"
	return asm

# find the most leftest or rightest pixel in a sprite
# return its dx
def find_sprite_horiz_border(forward_search, sprite_img, mask_alpha, width, height):
	stop_flag = False
	for dx in range(width):
		for dy in range(height):
			if forward_search:
				dx2 = dx
			else:
				dx2 = width - 1 - dx
			color_idx = sprite_img[dy][dx2]
			if color_idx != mask_alpha:
				stop_flag = True
				break
		if stop_flag: break
	return dx2 

def palette_to_asm(image, char_j, path = "", label_prefix = ""):
	# usially there are color tiles in top row in the image.
	palette_coords = char_j["palette"]
	colors = {}
	asm = "; " + path + "\n"
	asm += "			.word 0 ; safety pair of bytes for reading by POP B\n"	
	asm += label_prefix + "_palette" + ":\n"
	palette = image.getpalette()

	for i, pos in enumerate(palette_coords):
		x = pos["x"]
		y = pos["y"]
		color_idx = image.getpixel((x, y))
		r = palette[color_idx * 3]
		g = palette[color_idx * 3 + 1]
		b = palette[color_idx * 3 + 2]
		colors[(r, g, b)] = i
		color = pack_color(r, g, b)
		if i % 4 == 0 : asm += "			.byte "
		asm += "%" + format(color, '08b') + ", "
		if i % 4 == 3 : asm += "\n"
	
	return asm, colors

# combines RGB values into a Vector06c color format
def pack_color(r,g,b):
	r = r >> 5
	g = g >> 5
	g = g << 3
	b = b >> 6
	b = b << 6
	return b | g | r

def image_palette_to_asm(colors, label_prefix):
	asm = "			.word 0 ; safety pair of bytes for reading by POP B\n"
	asm += label_prefix + "_palette:\n"	

	for color_idx in range(IMAGE_COLORS_MAX):
		r = colors[color_idx*3 + 0]
		g = colors[color_idx*3 + 1]
		b = colors[color_idx*3 + 2]
		color_packed = pack_color(r, g, b)

		if color_idx % 4 == 0 : asm += "			.byte "
		asm += "%" + format(color_packed, '08b') + ", "
		if color_idx % 4 == 3 : asm += "\n"
	return asm	

def remap_colors(image, colors):
	palette = image.getpalette()
	color_matching_table = {}
	
	for color_idx in range(len(palette) //3):
		r = palette[color_idx*3]
		g = palette[color_idx*3 + 1]
		b = palette[color_idx*3 + 2]
		rgb = (r,g,b)
		if rgb not in colors: 
			continue
		cidx = colors[rgb]
		color_matching_table[color_idx] = cidx
	
	w = image.width
	h = image.height

	for y in range(h) :
		for x in range(w) :
			color_idx = image.getpixel((x, y))
			new_color_idx = color_matching_table[color_idx]
			image.putpixel((x,y), new_color_idx)
	return image

color_index_to_bit = [
		(0,0,0,0), # color_idx = 0
		(0,0,0,1),
		(0,0,1,0), # color_idx = 2
		(0,0,1,1),
		(0,1,0,0), # color_idx = 4
		(0,1,0,1),
		(0,1,1,0),
		(0,1,1,1),
		(1,0,0,0), # color_idx = 8
		(1,0,0,1),
		(1,0,1,0),
		(1,0,1,1),
		(1,1,0,0),
		(1,1,0,1),
		(1,1,1,0),
		(1,1,1,1),
	]

def indexes_to_bit_lists(tile_img):
	bits0 = [] # 8000-9FFF # from left to right, from bottom to top
	bits1 = [] # A000-BFFF
	bits2 = [] # C000-DFFF
	bits3 = [] # E000-FFFF
	for line in tile_img:
		for color_idx in line:
			bit0, bit1, bit2, bit3 = color_index_to_bit[color_idx]
			bits0.append(bit0) 
			bits1.append(bit1)
			bits2.append(bit2)
			bits3.append(bit3)
	return bits0, bits1, bits2, bits3

def plane_indexes_to_bit_lists(tile_img):
	bits0 = [] # 8000-9FFF # from left to right, from bottom to top
	bits1 = [] # A000-BFFF
	bits2 = [] # C000-DFFF
	bits3 = [] # E000-FFFF
	for color_idx in tile_img:
		bit0, bit1, bit2, bit3 = color_index_to_bit[color_idx]
		bits0.append(bit0) 
		bits1.append(bit1)
		bits2.append(bit2)
		bits3.append(bit3)
	return bits0, bits1, bits2, bits3

def get_list_of_tiles(remap_idxs, label_prefix, pngLabelPrefix):
	asm = "\n			.word 0 ; safety pair of bytes for reading by POP B\n"
	asm += label_prefix + "_tiles_addr:\n			.word "
	for i, t_idx in enumerate(remap_idxs):
		asm += "__" + pngLabelPrefix + "_tile" + str(remap_idxs[t_idx]) + ", "
		if i != len(remap_idxs)-1:
			# two safety fytes
			asm += "0, "
	asm += "\n\n"
	return asm