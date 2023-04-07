; source\sprites\font.json
__RAM_DISK_S_FONT = RAM_DISK_S
; source\sprites\font.json
__RAM_DISK_M_FONT = RAM_DISK_M
__font_gfx:
			.word 0 ; safety word to support a stack renderer
__font_A:
			.byte 0, 0 ; offset_y, offset_x
			.byte 196,0,68,0,68,0,124,0,40,0,40,0,16,0,16,0,
			.byte 16,0,
			.byte 0, 7 ; next_char_offset

			.word 0 ; safety word to support a stack renderer
__font_p:
			.byte -4, -1 ; offset_y, offset_x
			.byte 128,0,128,0,128,0,128,0,224,0,144,0,144,0,144,0,
			.byte 144,0,224,0,
			.byte 0, 5 ; next_char_offset

			.word 0 ; safety word to support a stack renderer
__font_i:
			.byte 0, 0 ; offset_y, offset_x
			.byte 64,0,64,0,64,0,64,0,64,0,192,0,0,0,64,0,
			.byte 0, 3 ; next_char_offset
