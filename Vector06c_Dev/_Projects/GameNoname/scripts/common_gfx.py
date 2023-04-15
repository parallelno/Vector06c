


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
def find_sprite_horiz_border(forwardSearch, sprite_img, mask_alpha, width, height):
	stop_flag = False
	for dx in range(width):
		for dy in range(height):
			if forwardSearch:
				dx2 = dx
			else:
				dx2 = width - 1 - dx
			color_idx = sprite_img[dy][dx2]
			if color_idx != mask_alpha:
				stop_flag = True
				break
		if stop_flag: break
	return dx2 
