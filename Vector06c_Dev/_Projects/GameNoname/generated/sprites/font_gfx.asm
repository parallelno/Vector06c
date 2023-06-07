; source\sprites\font.json
__RAM_DISK_S_FONT = RAM_DISK_S
; source\sprites\font.json
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
__font_d_quote:
			.byte 0, 0 ; offset_y, offset_x
			.word 240,
			.byte 0, 5 ; next_char_offset

			.word 0 ; safety pair of bytes for reading by POP B
__font_ampersand:
			.byte 0, 0 ; offset_y, offset_x
			.word 113,138,132,138,80,48,72,72,48,
			.byte 0, 9 ; next_char_offset

			.word 0 ; safety pair of bytes for reading by POP B
__font_hash:
			.byte 0, 0 ; offset_y, offset_x
			.word 240,
			.byte 0, 5 ; next_char_offset

			.word 0 ; safety pair of bytes for reading by POP B
__font_dollar:
			.byte 0, 0 ; offset_y, offset_x
			.word 240,
			.byte 0, 5 ; next_char_offset

			.word 0 ; safety pair of bytes for reading by POP B
__font_percent:
			.byte 0, 0 ; offset_y, offset_x
			.word 240,
			.byte 0, 5 ; next_char_offset

			.word 0 ; safety pair of bytes for reading by POP B
__font_ampercent:
			.byte 0, 0 ; offset_y, offset_x
			.word 240,
			.byte 0, 5 ; next_char_offset

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
__font_multidot:
			.byte 0, 0 ; offset_y, offset_x
			.word 168,
			.byte 0, 6 ; next_char_offset

			.word 0 ; safety pair of bytes for reading by POP B
__font_equal:
			.byte 0, 0 ; offset_y, offset_x
			.word 240,
			.byte 0, 5 ; next_char_offset

			.word 0 ; safety pair of bytes for reading by POP B
__font_question:
			.byte 0, 0 ; offset_y, offset_x
			.word 32,0,32,32,16,24,8,8,136,112,
			.byte 0, 6 ; next_char_offset

			.word 0 ; safety pair of bytes for reading by POP B
__font_A:
			.byte 0, 0 ; offset_y, offset_x
			.word 196,68,68,124,40,40,16,16,16,
			.byte 0, 7 ; next_char_offset

			.word 0 ; safety pair of bytes for reading by POP B
__font_B:
			.byte 0, -1 ; offset_y, offset_x
			.word 124,34,34,34,36,56,36,164,120,
			.byte 0, 7 ; next_char_offset

			.word 0 ; safety pair of bytes for reading by POP B
__font_C:
			.byte 0, 0 ; offset_y, offset_x
			.word 112,200,136,128,128,128,128,200,112,
			.byte 0, 6 ; next_char_offset

			.word 0 ; safety pair of bytes for reading by POP B
__font_D:
			.byte 0, 0 ; offset_y, offset_x
			.word 240,72,72,72,72,72,72,72,240,
			.byte 0, 6 ; next_char_offset

			.word 0 ; safety pair of bytes for reading by POP B
__font_E:
			.byte 0, 0 ; offset_y, offset_x
			.word 248,72,64,80,112,80,64,72,248,
			.byte 0, 6 ; next_char_offset

			.word 0 ; safety pair of bytes for reading by POP B
__font_F:
			.byte 0, 0 ; offset_y, offset_x
			.word 192,64,64,80,112,80,64,72,248,
			.byte 0, 6 ; next_char_offset

			.word 0 ; safety pair of bytes for reading by POP B
__font_G:
			.byte -2, -1 ; offset_y, offset_x
			.word 4,4,116,204,140,140,132,156,128,196,120,
			.byte 0, 7 ; next_char_offset

			.word 0 ; safety pair of bytes for reading by POP B
__font_H:
			.byte 0, 0 ; offset_y, offset_x
			.word 72,72,72,72,120,72,72,72,200,
			.byte 0, 6 ; next_char_offset

			.word 0 ; safety pair of bytes for reading by POP B
__font_I:
			.byte 0, 0 ; offset_y, offset_x
			.word 224,64,64,64,64,64,64,64,192,
			.byte 0, 4 ; next_char_offset

			.word 0 ; safety pair of bytes for reading by POP B
__font_J:
			.byte 0, 0 ; offset_y, offset_x
			.word 96,208,144,16,16,16,16,16,56,
			.byte 0, 6 ; next_char_offset

			.word 0 ; safety pair of bytes for reading by POP B
__font_K:
			.byte 0, 0 ; offset_y, offset_x
			.word 228,76,88,112,112,80,72,72,196,
			.byte 0, 7 ; next_char_offset

			.word 0 ; safety pair of bytes for reading by POP B
__font_L:
			.byte 0, 0 ; offset_y, offset_x
			.word 248,72,72,64,64,64,64,64,192,
			.byte 0, 6 ; next_char_offset

			.word 0 ; safety pair of bytes for reading by POP B
__font_M:
			.byte 0, 0 ; offset_y, offset_x
			.word 65,65,65,73,93,119,99,99,193,1,
			.byte 0, 9 ; next_char_offset

			.word 0 ; safety pair of bytes for reading by POP B
__font_N:
			.byte 0, 0 ; offset_y, offset_x
			.word 196,68,76,92,92,116,100,68,196,
			.byte 0, 7 ; next_char_offset

			.word 0 ; safety pair of bytes for reading by POP B
__font_O:
			.byte 0, 0 ; offset_y, offset_x
			.word 48,72,132,132,180,132,132,72,48,
			.byte 0, 7 ; next_char_offset

			.word 0 ; safety pair of bytes for reading by POP B
__font_P:
			.byte 0, 0 ; offset_y, offset_x
			.word 224,64,64,64,112,72,72,72,240,
			.byte 0, 6 ; next_char_offset

			.word 0 ; safety pair of bytes for reading by POP B
__font_Q:
			.byte -1, -1 ; offset_y, offset_x
			.word 12,44,88,132,132,180,132,132,72,48,
			.byte 0, 7 ; next_char_offset

			.word 0 ; safety pair of bytes for reading by POP B
__font_R:
			.byte -2, -1 ; offset_y, offset_x
			.word 7,8,200,80,80,96,80,72,72,72,240,
			.byte 0, 6 ; next_char_offset

			.word 0 ; safety pair of bytes for reading by POP B
__font_S:
			.byte 0, 0 ; offset_y, offset_x
			.word 112,200,136,16,32,64,136,136,112,
			.byte 0, 6 ; next_char_offset

			.word 0 ; safety pair of bytes for reading by POP B
__font_T:
			.byte 0, 0 ; offset_y, offset_x
			.word 56,16,16,16,16,16,16,146,254,
			.byte 0, 8 ; next_char_offset

			.word 0 ; safety pair of bytes for reading by POP B
__font_U:
			.byte 0, 0 ; offset_y, offset_x
			.word 48,104,68,68,68,68,68,68,198,
			.byte 0, 8 ; next_char_offset

			.word 0 ; safety pair of bytes for reading by POP B
__font_V:
			.byte 0, 0 ; offset_y, offset_x
			.word 16,16,56,56,40,40,68,68,198,
			.byte 0, 8 ; next_char_offset

			.word 0 ; safety pair of bytes for reading by POP B
__font_W:
			.byte 0, 0 ; offset_y, offset_x
			.word 34,34,34,119,85,73,73,73,201,
			.byte 0, 9 ; next_char_offset

			.word 0 ; safety pair of bytes for reading by POP B
__font_X:
			.byte 0, 0 ; offset_y, offset_x
			.word 132,140,72,120,48,48,104,200,132,
			.byte 0, 7 ; next_char_offset

			.word 0 ; safety pair of bytes for reading by POP B
__font_Y:
			.byte 0, 0 ; offset_y, offset_x
			.word 56,16,16,16,56,40,104,68,198,
			.byte 0, 8 ; next_char_offset

			.word 0 ; safety pair of bytes for reading by POP B
__font_Z:
			.byte 0, 0 ; offset_y, offset_x
			.word 252,196,64,32,32,16,72,76,252,
			.byte 0, 7 ; next_char_offset

			.word 0 ; safety pair of bytes for reading by POP B
__font_a:
			.byte 0, 0 ; offset_y, offset_x
			.word 136,240,144,144,80,112,
			.byte 0, 5 ; next_char_offset

			.word 0 ; safety pair of bytes for reading by POP B
__font_b:
			.byte 0, 0 ; offset_y, offset_x
			.word 224,144,144,144,144,224,128,128,
			.byte 0, 5 ; next_char_offset

			.word 0 ; safety pair of bytes for reading by POP B
__font_c:
			.byte 0, 0 ; offset_y, offset_x
			.word 96,144,144,128,144,96,
			.byte 0, 5 ; next_char_offset

			.word 0 ; safety pair of bytes for reading by POP B
__font_d:
			.byte 0, 0 ; offset_y, offset_x
			.word 112,144,144,144,144,112,16,16,
			.byte 0, 5 ; next_char_offset

			.word 0 ; safety pair of bytes for reading by POP B
__font_e:
			.byte 0, 0 ; offset_y, offset_x
			.word 240,144,128,192,144,224,
			.byte 0, 5 ; next_char_offset

			.word 0 ; safety pair of bytes for reading by POP B
__font_f:
			.byte 0, 0 ; offset_y, offset_x
			.word 64,64,64,64,64,240,64,64,60,
			.byte 0, 5 ; next_char_offset

			.word 0 ; safety pair of bytes for reading by POP B
__font_g:
			.byte -2, -3 ; offset_y, offset_x
			.word 248,4,28,36,36,36,36,28,
			.byte 0, 5 ; next_char_offset

			.word 0 ; safety pair of bytes for reading by POP B
__font_h:
			.byte 0, 0 ; offset_y, offset_x
			.word 144,144,144,240,144,144,
			.byte 0, 5 ; next_char_offset

			.word 0 ; safety pair of bytes for reading by POP B
__font_i:
			.byte 0, 0 ; offset_y, offset_x
			.word 64,64,64,64,64,192,0,64,
			.byte 0, 3 ; next_char_offset

			.word 0 ; safety pair of bytes for reading by POP B
__font_j:
			.byte -3, -2 ; offset_y, offset_x
			.word 128,64,64,64,64,64,64,64,64,0,64,
			.byte 0, 2 ; next_char_offset

			.word 0 ; safety pair of bytes for reading by POP B
__font_k:
			.byte 0, 0 ; offset_y, offset_x
			.word 88,96,80,80,72,200,
			.byte 0, 6 ; next_char_offset

			.word 0 ; safety pair of bytes for reading by POP B
__font_l:
			.byte 0, 0 ; offset_y, offset_x
			.word 240,144,128,128,128,128,
			.byte 0, 5 ; next_char_offset

			.word 0 ; safety pair of bytes for reading by POP B
__font_m:
			.byte 0, 0 ; offset_y, offset_x
			.word 172,168,168,168,168,208,
			.byte 0, 7 ; next_char_offset

			.word 0 ; safety pair of bytes for reading by POP B
__font_n:
			.byte 0, 0 ; offset_y, offset_x
			.word 144,144,144,144,144,224,
			.byte 0, 5 ; next_char_offset

			.word 0 ; safety pair of bytes for reading by POP B
__font_o:
			.byte 0, 0 ; offset_y, offset_x
			.word 112,136,168,136,136,112,
			.byte 0, 6 ; next_char_offset

			.word 0 ; safety pair of bytes for reading by POP B
__font_p:
			.byte -4, -2 ; offset_y, offset_x
			.word 64,64,64,64,112,72,72,72,72,240,
			.byte 0, 5 ; next_char_offset

			.word 0 ; safety pair of bytes for reading by POP B
__font_q:
			.byte -1, -1 ; offset_y, offset_x
			.word 4,104,144,168,136,136,112,
			.byte 0, 6 ; next_char_offset

			.word 0 ; safety pair of bytes for reading by POP B
__font_r:
			.byte -2, -1 ; offset_y, offset_x
			.word 12,16,80,96,80,80,80,224,
			.byte 0, 5 ; next_char_offset

			.word 0 ; safety pair of bytes for reading by POP B
__font_s:
			.byte 0, 0 ; offset_y, offset_x
			.word 224,16,16,224,128,96,
			.byte 0, 5 ; next_char_offset

			.word 0 ; safety pair of bytes for reading by POP B
__font_t:
			.byte -1, -1 ; offset_y, offset_x
			.word 48,64,64,64,64,64,240,64,64,64,
			.byte 0, 5 ; next_char_offset

			.word 0 ; safety pair of bytes for reading by POP B
__font_u:
			.byte 0, 0 ; offset_y, offset_x
			.word 112,136,136,136,136,136,
			.byte 0, 6 ; next_char_offset

			.word 0 ; safety pair of bytes for reading by POP B
__font_v:
			.byte 0, 0 ; offset_y, offset_x
			.word 32,112,80,136,136,136,
			.byte 0, 6 ; next_char_offset

			.word 0 ; safety pair of bytes for reading by POP B
__font_w:
			.byte 0, 0 ; offset_y, offset_x
			.word 80,168,168,168,136,136,
			.byte 0, 6 ; next_char_offset

			.word 0 ; safety pair of bytes for reading by POP B
__font_x:
			.byte 0, 0 ; offset_y, offset_x
			.word 144,144,96,96,144,144,
			.byte 0, 5 ; next_char_offset

			.word 0 ; safety pair of bytes for reading by POP B
__font_y:
			.byte 0, 0 ; offset_y, offset_x
			.word 32,32,32,80,136,136,
			.byte 0, 6 ; next_char_offset

			.word 0 ; safety pair of bytes for reading by POP B
__font_z:
			.byte 0, 0 ; offset_y, offset_x
			.word 240,128,64,32,16,240,
			.byte 0, 5 ; next_char_offset
