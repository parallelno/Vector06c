; source\font\rus\font.json
__RAM_DISK_S_FONT = RAM_DISK_S
; source\font\rus\font.json
__RAM_DISK_M_FONT = RAM_DISK_M
__font_gfx:
			.word 0 ; safety pair of bytes for reading by POP B
__font_0:
			.byte 0, 0 ; offset_y, offset_x
			.word 112,136,136,136,136,136,136,136,112,
			.byte 0, 6 ; next_char_offset

			.word 0 ; safety pair of bytes for reading by POP B
__font_1:
			.byte 0, 0 ; offset_y, offset_x
			.word 64,64,64,64,64,64,64,192,64,
			.byte 0, 3 ; next_char_offset

			.word 0 ; safety pair of bytes for reading by POP B
__font_2:
			.byte 0, 0 ; offset_y, offset_x
			.word 248,128,128,96,16,8,136,136,112,
			.byte 0, 6 ; next_char_offset

			.word 0 ; safety pair of bytes for reading by POP B
__font_3:
			.byte 0, 0 ; offset_y, offset_x
			.word 112,136,8,8,16,8,136,136,112,
			.byte 0, 6 ; next_char_offset

			.word 0 ; safety pair of bytes for reading by POP B
__font_4:
			.byte 0, 0 ; offset_y, offset_x
			.word 16,16,16,16,248,144,144,80,80,
			.byte 0, 6 ; next_char_offset

			.word 0 ; safety pair of bytes for reading by POP B
__font_5:
			.byte 0, 0 ; offset_y, offset_x
			.word 112,136,136,8,8,240,128,128,248,
			.byte 0, 6 ; next_char_offset

			.word 0 ; safety pair of bytes for reading by POP B
__font_6:
			.byte 0, 0 ; offset_y, offset_x
			.word 112,136,136,136,240,128,136,136,112,
			.byte 0, 6 ; next_char_offset

			.word 0 ; safety pair of bytes for reading by POP B
__font_7:
			.byte 0, 0 ; offset_y, offset_x
			.word 64,64,64,64,32,16,16,16,240,
			.byte 0, 5 ; next_char_offset

			.word 0 ; safety pair of bytes for reading by POP B
__font_8:
			.byte 0, 0 ; offset_y, offset_x
			.word 112,136,136,136,112,136,136,136,112,
			.byte 0, 6 ; next_char_offset

			.word 0 ; safety pair of bytes for reading by POP B
__font_9:
			.byte 0, 0 ; offset_y, offset_x
			.word 112,8,8,8,120,136,136,136,112,
			.byte 0, 6 ; next_char_offset

			.word 0 ; safety pair of bytes for reading by POP B
__font_space:
			.byte 0, 0 ; offset_y, offset_x
			.word 0,
			.byte 0, 5 ; next_char_offset

			.word 0 ; safety pair of bytes for reading by POP B
__font_exclamation:
			.byte 0, 0 ; offset_y, offset_x
			.word 128,0,128,128,128,128,128,128,128,128,
			.byte 0, 2 ; next_char_offset

			.word 0 ; safety pair of bytes for reading by POP B
__font_ampersand:
			.byte 0, 0 ; offset_y, offset_x
			.word 113,138,132,138,80,48,72,72,48,
			.byte 0, 9 ; next_char_offset

			.word 0 ; safety pair of bytes for reading by POP B
__font_quote:
			.byte 8, 0 ; offset_y, offset_x
			.word 128,64,
			.byte 0, 3 ; next_char_offset

			.word 0 ; safety pair of bytes for reading by POP B
__font_parent_l:
			.byte 0, 0 ; offset_y, offset_x
			.word 32,64,128,128,128,128,64,32,
			.byte 0, 4 ; next_char_offset

			.word 0 ; safety pair of bytes for reading by POP B
__font_parent_r:
			.byte 0, 0 ; offset_y, offset_x
			.word 128,64,32,32,32,32,64,128,
			.byte 0, 4 ; next_char_offset

			.word 0 ; safety pair of bytes for reading by POP B
__font_comma:
			.byte -1, -1 ; offset_y, offset_x
			.word 128,64,
			.byte 0, 3 ; next_char_offset

			.word 0 ; safety pair of bytes for reading by POP B
__font_dash:
			.byte 3, 0 ; offset_y, offset_x
			.word 248,
			.byte 0, 6 ; next_char_offset

			.word 0 ; safety pair of bytes for reading by POP B
__font_period:
			.byte 0, 0 ; offset_y, offset_x
			.word 128,
			.byte 0, 2 ; next_char_offset

			.word 0 ; safety pair of bytes for reading by POP B
__font_colon:
			.byte 1, 0 ; offset_y, offset_x
			.word 128,0,0,128,
			.byte 0, 2 ; next_char_offset

			.word 0 ; safety pair of bytes for reading by POP B
__font_question:
			.byte 0, 0 ; offset_y, offset_x
			.word 32,0,32,32,16,24,8,8,136,112,
			.byte 0, 6 ; next_char_offset

			.word 0 ; safety pair of bytes for reading by POP B
__font_k31:
			.byte 0, 0 ; offset_y, offset_x
			.word 144,240,144,144,80,112,
			.byte 0, 5 ; next_char_offset

			.word 0 ; safety pair of bytes for reading by POP B
__font_l31:
			.byte 0, 0 ; offset_y, offset_x
			.word 224,144,144,144,144,224,128,192,
			.byte 0, 5 ; next_char_offset

			.word 0 ; safety pair of bytes for reading by POP B
__font_m31:
			.byte 0, 0 ; offset_y, offset_x
			.word 224,144,144,144,144,224,144,224,
			.byte 0, 5 ; next_char_offset

			.word 0 ; safety pair of bytes for reading by POP B
__font_n31:
			.byte 0, 0 ; offset_y, offset_x
			.word 128,128,128,128,144,240,
			.byte 0, 5 ; next_char_offset

			.word 0 ; safety pair of bytes for reading by POP B
__font_o31:
			.byte -1, -2 ; offset_y, offset_x
			.word 136,248,72,72,72,72,48,
			.byte 0, 5 ; next_char_offset

			.word 0 ; safety pair of bytes for reading by POP B
__font_p31:
			.byte 0, 0 ; offset_y, offset_x
			.word 240,144,128,192,144,224,
			.byte 0, 5 ; next_char_offset

			.word 0 ; safety pair of bytes for reading by POP B
__font_r32:
			.byte 0, 0 ; offset_y, offset_x
			.word 240,144,128,192,144,224,0,160,
			.byte 0, 5 ; next_char_offset

			.word 0 ; safety pair of bytes for reading by POP B
__font_q31:
			.byte 0, 0 ; offset_y, offset_x
			.word 168,168,112,112,168,168,
			.byte 0, 6 ; next_char_offset

			.word 0 ; safety pair of bytes for reading by POP B
__font_r31:
			.byte -2, -2 ; offset_y, offset_x
			.word 240,8,8,8,16,8,72,48,
			.byte 0, 5 ; next_char_offset

			.word 0 ; safety pair of bytes for reading by POP B
__font_s31:
			.byte 0, 0 ; offset_y, offset_x
			.word 104,152,136,136,136,136,
			.byte 0, 6 ; next_char_offset

			.word 0 ; safety pair of bytes for reading by POP B
__font_t31:
			.byte 0, 0 ; offset_y, offset_x
			.word 104,152,136,136,136,136,32,80,
			.byte 0, 6 ; next_char_offset

			.word 0 ; safety pair of bytes for reading by POP B
__font_u31:
			.byte 0, 0 ; offset_y, offset_x
			.word 88,96,80,80,72,200,
			.byte 0, 6 ; next_char_offset

			.word 0 ; safety pair of bytes for reading by POP B
__font_v31:
			.byte -2, -4 ; offset_y, offset_x
			.word 224,16,18,10,10,10,10,30,
			.byte 0, 5 ; next_char_offset

			.word 0 ; safety pair of bytes for reading by POP B
__font_w31:
			.byte 0, 0 ; offset_y, offset_x
			.word 172,168,248,216,136,136,
			.byte 0, 7 ; next_char_offset

			.word 0 ; safety pair of bytes for reading by POP B
__font_x31:
			.byte 0, 0 ; offset_y, offset_x
			.word 144,144,144,240,144,144,
			.byte 0, 5 ; next_char_offset

			.word 0 ; safety pair of bytes for reading by POP B
__font_y31:
			.byte 0, 0 ; offset_y, offset_x
			.word 112,136,168,136,136,112,
			.byte 0, 6 ; next_char_offset

			.word 0 ; safety pair of bytes for reading by POP B
__font_z31:
			.byte 0, 0 ; offset_y, offset_x
			.word 80,80,80,80,80,240,
			.byte 0, 5 ; next_char_offset

			.word 0 ; safety pair of bytes for reading by POP B
__font_a32:
			.byte -4, -2 ; offset_y, offset_x
			.word 64,64,64,64,112,72,72,72,72,240,
			.byte 0, 5 ; next_char_offset

			.word 0 ; safety pair of bytes for reading by POP B
__font_b32:
			.byte 0, 0 ; offset_y, offset_x
			.word 96,144,128,128,144,96,
			.byte 0, 5 ; next_char_offset

			.word 0 ; safety pair of bytes for reading by POP B
__font_c32:
			.byte 0, 0 ; offset_y, offset_x
			.word 172,168,168,168,168,240,
			.byte 0, 7 ; next_char_offset

			.word 0 ; safety pair of bytes for reading by POP B
__font_d32:
			.byte -2, -2 ; offset_y, offset_x
			.word 240,8,56,72,72,72,72,72,
			.byte 0, 5 ; next_char_offset

			.word 0 ; safety pair of bytes for reading by POP B
__font_e32:
			.byte -1, -1 ; offset_y, offset_x
			.word 32,240,168,168,168,168,112,32,0,
			.byte 0, 6 ; next_char_offset

			.word 0 ; safety pair of bytes for reading by POP B
__font_f32:
			.byte 0, 0 ; offset_y, offset_x
			.word 144,144,96,96,144,144,
			.byte 0, 5 ; next_char_offset

			.word 0 ; safety pair of bytes for reading by POP B
__font_g32:
			.byte -2, -1 ; offset_y, offset_x
			.word 24,4,104,152,136,136,136,136,
			.byte 0, 6 ; next_char_offset

			.word 0 ; safety pair of bytes for reading by POP B
__font_h32:
			.byte 0, 0 ; offset_y, offset_x
			.word 8,8,120,136,136,136,
			.byte 0, 6 ; next_char_offset

			.word 0 ; safety pair of bytes for reading by POP B
__font_i32:
			.byte 0, 0 ; offset_y, offset_x
			.word 88,168,168,168,168,168,
			.byte 0, 6 ; next_char_offset

			.word 0 ; safety pair of bytes for reading by POP B
__font_j32:
			.byte -2, -1 ; offset_y, offset_x
			.word 56,4,88,168,168,168,168,168,
			.byte 0, 7 ; next_char_offset

			.word 0 ; safety pair of bytes for reading by POP B
__font_k32:
			.byte 0, -1 ; offset_y, offset_x
			.word 56,36,36,56,160,224,
			.byte 0, 6 ; next_char_offset

			.word 0 ; safety pair of bytes for reading by POP B
__font_l32:
			.byte 0, -1 ; offset_y, offset_x
			.word 119,74,74,114,66,199,
			.byte 0, 8 ; next_char_offset

			.word 0 ; safety pair of bytes for reading by POP B
__font_m32:
			.byte 0, 0 ; offset_y, offset_x
			.word 224,144,144,224,128,128,
			.byte 0, 5 ; next_char_offset

			.word 0 ; safety pair of bytes for reading by POP B
__font_n32:
			.byte 0, 0 ; offset_y, offset_x
			.word 224,16,16,48,16,224,
			.byte 0, 5 ; next_char_offset

			.word 0 ; safety pair of bytes for reading by POP B
__font_o32:
			.byte 0, 0 ; offset_y, offset_x
			.word 152,164,228,164,164,152,
			.byte 0, 7 ; next_char_offset

			.word 0 ; safety pair of bytes for reading by POP B
__font_p32:
			.byte -2, -2 ; offset_y, offset_x
			.word 128,64,72,72,56,72,72,56,
			.byte 0, 5 ; next_char_offset

			.word 0 ; safety pair of bytes for reading by POP B
__font_e30:
			.byte 0, 0 ; offset_y, offset_x
			.word 196,68,68,124,40,40,16,16,16,
			.byte 0, 7 ; next_char_offset

			.word 0 ; safety pair of bytes for reading by POP B
__font_f30:
			.byte 0, -1 ; offset_y, offset_x
			.word 248,68,68,68,72,112,64,64,248,
			.byte 0, 6 ; next_char_offset

			.word 0 ; safety pair of bytes for reading by POP B
__font_g30:
			.byte 0, -1 ; offset_y, offset_x
			.word 248,68,68,68,72,112,72,72,240,
			.byte 0, 6 ; next_char_offset

			.word 0 ; safety pair of bytes for reading by POP B
__font_h30:
			.byte 0, 0 ; offset_y, offset_x
			.word 224,64,64,64,64,64,64,72,248,
			.byte 0, 6 ; next_char_offset

			.word 0 ; safety pair of bytes for reading by POP B
__font_i30:
			.byte -1, -1 ; offset_y, offset_x
			.word 66,126,36,36,36,36,36,36,36,120,
			.byte 0, 7 ; next_char_offset

			.word 0 ; safety pair of bytes for reading by POP B
__font_j30:
			.byte 0, 0 ; offset_y, offset_x
			.word 248,72,64,80,112,80,64,72,248,
			.byte 0, 6 ; next_char_offset

			.word 0 ; safety pair of bytes for reading by POP B
__font_k30:
			.byte 0, 0 ; offset_y, offset_x
			.word 214,84,84,124,56,56,84,84,198,
			.byte 0, 8 ; next_char_offset

			.word 0 ; safety pair of bytes for reading by POP B
__font_l30:
			.byte 0, 0 ; offset_y, offset_x
			.word 48,72,4,4,4,24,68,68,56,
			.byte 0, 7 ; next_char_offset

			.word 0 ; safety pair of bytes for reading by POP B
__font_m30:
			.byte 0, 0 ; offset_y, offset_x
			.word 196,100,100,116,84,92,76,68,196,
			.byte 0, 7 ; next_char_offset

			.word 0 ; safety pair of bytes for reading by POP B
__font_o30:
			.byte 0, 0 ; offset_y, offset_x
			.word 228,76,88,112,112,80,72,72,196,
			.byte 0, 7 ; next_char_offset

			.word 0 ; safety pair of bytes for reading by POP B
__font_p30:
			.byte -2, -3 ; offset_y, offset_x
			.word 112,8,9,9,9,9,9,9,9,9,31,
			.byte 0, 7 ; next_char_offset

			.word 0 ; safety pair of bytes for reading by POP B
__font_q30:
			.byte 0, 0 ; offset_y, offset_x
			.word 65,65,65,73,93,119,99,99,193,1,
			.byte 0, 9 ; next_char_offset

			.word 0 ; safety pair of bytes for reading by POP B
__font_r30:
			.byte 0, 0 ; offset_y, offset_x
			.word 72,72,72,72,120,72,72,72,200,
			.byte 0, 6 ; next_char_offset

			.word 0 ; safety pair of bytes for reading by POP B
__font_s30:
			.byte 0, 0 ; offset_y, offset_x
			.word 48,72,132,132,180,132,132,72,48,
			.byte 0, 7 ; next_char_offset

			.word 0 ; safety pair of bytes for reading by POP B
__font_t30:
			.byte 0, 0 ; offset_y, offset_x
			.word 72,72,72,72,72,72,72,72,248,
			.byte 0, 6 ; next_char_offset

			.word 0 ; safety pair of bytes for reading by POP B
__font_u30:
			.byte 0, 0 ; offset_y, offset_x
			.word 224,64,64,64,112,72,72,72,240,
			.byte 0, 6 ; next_char_offset

			.word 0 ; safety pair of bytes for reading by POP B
__font_v30:
			.byte 0, 0 ; offset_y, offset_x
			.word 112,200,136,128,128,128,128,200,112,
			.byte 0, 6 ; next_char_offset

			.word 0 ; safety pair of bytes for reading by POP B
__font_w30:
			.byte 0, 0 ; offset_y, offset_x
			.word 56,16,16,16,16,16,16,146,254,
			.byte 0, 8 ; next_char_offset

			.word 0 ; safety pair of bytes for reading by POP B
__font_x30:
			.byte -2, -2 ; offset_y, offset_x
			.word 112,8,4,4,4,12,20,34,34,34,99,
			.byte 0, 8 ; next_char_offset

			.word 0 ; safety pair of bytes for reading by POP B
__font_y30:
			.byte -1, -1 ; offset_y, offset_x
			.word 16,16,124,146,146,146,146,146,146,124,16,
			.byte 0, 8 ; next_char_offset

			.word 0 ; safety pair of bytes for reading by POP B
__font_z30:
			.byte 0, 0 ; offset_y, offset_x
			.word 132,140,72,120,48,48,104,200,132,
			.byte 0, 7 ; next_char_offset

			.word 0 ; safety pair of bytes for reading by POP B
__font_a31:
			.byte -2, -1 ; offset_y, offset_x
			.word 12,2,52,108,68,68,68,68,68,68,198,
			.byte 0, 8 ; next_char_offset

			.word 0 ; safety pair of bytes for reading by POP B
__font_b31:
			.byte 0, 0 ; offset_y, offset_x
			.word 14,4,4,4,52,76,68,68,198,
			.byte 0, 8 ; next_char_offset

			.word 0 ; safety pair of bytes for reading by POP B
__font_c31:
			.byte 0, 0 ; offset_y, offset_x
			.word 38,91,73,73,73,73,73,73,201,
			.byte 0, 9 ; next_char_offset

			.word 0 ; safety pair of bytes for reading by POP B
__font_d31:
			.byte -2, -1 ; offset_y, offset_x
			.word 12,2,44,84,84,84,84,84,84,84,214,
			.byte 0, 8 ; next_char_offset

			.word 0 ; safety pair of bytes for reading by POP B
__font_e31:
			.byte 0, -1 ; offset_y, offset_x
			.word 120,36,36,36,56,32,32,160,224,
			.byte 0, 6 ; next_char_offset

			.word 0 ; safety pair of bytes for reading by POP B
__font_f31:
			.byte 0, 0 ; offset_y, offset_x
			.word 247,74,74,74,114,66,66,66,199,
			.byte 0, 9 ; next_char_offset

			.word 0 ; safety pair of bytes for reading by POP B
__font_g31:
			.byte 0, 0 ; offset_y, offset_x
			.word 240,72,72,72,112,64,64,64,192,
			.byte 0, 6 ; next_char_offset

			.word 0 ; safety pair of bytes for reading by POP B
__font_h31:
			.byte 0, 0 ; offset_y, offset_x
			.word 112,152,136,8,56,8,8,152,112,
			.byte 0, 6 ; next_char_offset

			.word 0 ; safety pair of bytes for reading by POP B
__font_i31:
			.byte 0, 0 ; offset_y, offset_x
			.word 206,90,81,81,117,81,81,90,204,
			.byte 0, 9 ; next_char_offset

			.word 0 ; safety pair of bytes for reading by POP B
__font_j31:
			.byte -2, -3 ; offset_y, offset_x
			.word 128,64,76,72,56,40,72,72,72,72,60,
			.byte 0, 6 ; next_char_offset
