; source\sprites\font_rus.json
__RAM_DISK_S_FONT_RUS = RAM_DISK_S
; source\sprites\font_rus.json
__RAM_DISK_M_FONT_RUS = RAM_DISK_M
__font_rus_gfx:
			.word 0 ; safety pair of bytes for reading by POP B
__font_rus_0:
			.byte 0, 0 ; offset_y, offset_x
			.word 112,136,136,136,136,136,136,136,112,
			.byte 0, 6 ; next_char_offset

			.word 0 ; safety pair of bytes for reading by POP B
__font_rus_1:
			.byte 0, 0 ; offset_y, offset_x
			.word 64,64,64,64,64,64,64,192,64,
			.byte 0, 3 ; next_char_offset

			.word 0 ; safety pair of bytes for reading by POP B
__font_rus_2:
			.byte 0, 0 ; offset_y, offset_x
			.word 248,128,128,96,16,8,136,136,112,
			.byte 0, 6 ; next_char_offset

			.word 0 ; safety pair of bytes for reading by POP B
__font_rus_3:
			.byte 0, 0 ; offset_y, offset_x
			.word 112,136,8,8,16,8,136,136,112,
			.byte 0, 6 ; next_char_offset

			.word 0 ; safety pair of bytes for reading by POP B
__font_rus_4:
			.byte 0, 0 ; offset_y, offset_x
			.word 16,16,16,16,248,144,144,80,80,
			.byte 0, 6 ; next_char_offset

			.word 0 ; safety pair of bytes for reading by POP B
__font_rus_5:
			.byte 0, 0 ; offset_y, offset_x
			.word 112,136,136,8,8,240,128,128,248,
			.byte 0, 6 ; next_char_offset

			.word 0 ; safety pair of bytes for reading by POP B
__font_rus_6:
			.byte 0, 0 ; offset_y, offset_x
			.word 112,136,136,136,240,128,136,136,112,
			.byte 0, 6 ; next_char_offset

			.word 0 ; safety pair of bytes for reading by POP B
__font_rus_7:
			.byte 0, 0 ; offset_y, offset_x
			.word 64,64,64,64,32,16,16,16,240,
			.byte 0, 5 ; next_char_offset

			.word 0 ; safety pair of bytes for reading by POP B
__font_rus_8:
			.byte 0, 0 ; offset_y, offset_x
			.word 112,136,136,136,112,136,136,136,112,
			.byte 0, 6 ; next_char_offset

			.word 0 ; safety pair of bytes for reading by POP B
__font_rus_9:
			.byte 0, 0 ; offset_y, offset_x
			.word 112,8,8,8,120,136,136,136,112,
			.byte 0, 6 ; next_char_offset

			.word 0 ; safety pair of bytes for reading by POP B
__font_rus_space:
			.byte 0, 0 ; offset_y, offset_x
			.word 0,
			.byte 0, 5 ; next_char_offset

			.word 0 ; safety pair of bytes for reading by POP B
__font_rus_exclamation:
			.byte 0, 0 ; offset_y, offset_x
			.word 128,0,128,128,128,128,128,128,128,128,
			.byte 0, 2 ; next_char_offset

			.word 0 ; safety pair of bytes for reading by POP B
__font_rus_d_quote:
			.byte 0, 0 ; offset_y, offset_x
			.word 224,
			.byte 0, 5 ; next_char_offset

			.word 0 ; safety pair of bytes for reading by POP B
__font_rus_ampersand:
			.byte 0, 0 ; offset_y, offset_x
			.word 113,138,132,138,80,48,72,72,48,
			.byte 0, 9 ; next_char_offset

			.word 0 ; safety pair of bytes for reading by POP B
__font_rus_hash:
			.byte 0, 0 ; offset_y, offset_x
			.word 224,
			.byte 0, 5 ; next_char_offset

			.word 0 ; safety pair of bytes for reading by POP B
__font_rus_dollar:
			.byte 0, 0 ; offset_y, offset_x
			.word 224,
			.byte 0, 5 ; next_char_offset

			.word 0 ; safety pair of bytes for reading by POP B
__font_rus_percent:
			.byte 0, 0 ; offset_y, offset_x
			.word 224,
			.byte 0, 5 ; next_char_offset

			.word 0 ; safety pair of bytes for reading by POP B
__font_rus_ampercent:
			.byte 0, 0 ; offset_y, offset_x
			.word 224,
			.byte 0, 5 ; next_char_offset

			.word 0 ; safety pair of bytes for reading by POP B
__font_rus_quote:
			.byte 8, 0 ; offset_y, offset_x
			.word 128,64,
			.byte 0, 3 ; next_char_offset

			.word 0 ; safety pair of bytes for reading by POP B
__font_rus_parent_l:
			.byte 0, 0 ; offset_y, offset_x
			.word 32,64,128,128,128,128,64,32,
			.byte 0, 4 ; next_char_offset

			.word 0 ; safety pair of bytes for reading by POP B
__font_rus_parent_r:
			.byte 0, 0 ; offset_y, offset_x
			.word 128,64,32,32,32,32,64,128,
			.byte 0, 4 ; next_char_offset

			.word 0 ; safety pair of bytes for reading by POP B
__font_rus_comma:
			.byte -1, -1 ; offset_y, offset_x
			.word 128,64,
			.byte 0, 3 ; next_char_offset

			.word 0 ; safety pair of bytes for reading by POP B
__font_rus_dash:
			.byte 3, 0 ; offset_y, offset_x
			.word 248,
			.byte 0, 6 ; next_char_offset

			.word 0 ; safety pair of bytes for reading by POP B
__font_rus_period:
			.byte 0, 0 ; offset_y, offset_x
			.word 128,
			.byte 0, 2 ; next_char_offset

			.word 0 ; safety pair of bytes for reading by POP B
__font_rus_colon:
			.byte 1, 0 ; offset_y, offset_x
			.word 128,0,0,128,
			.byte 0, 2 ; next_char_offset

			.word 0 ; safety pair of bytes for reading by POP B
__font_rus_multidot:
			.byte 0, 0 ; offset_y, offset_x
			.word 168,
			.byte 0, 6 ; next_char_offset

			.word 0 ; safety pair of bytes for reading by POP B
__font_rus_equal:
			.byte 0, 0 ; offset_y, offset_x
			.word 224,
			.byte 0, 5 ; next_char_offset

			.word 0 ; safety pair of bytes for reading by POP B
__font_rus_question:
			.byte 0, 0 ; offset_y, offset_x
			.word 32,0,32,32,16,24,8,8,136,112,
			.byte 0, 6 ; next_char_offset

			.word 0 ; safety pair of bytes for reading by POP B
__font_rus_a0:
			.byte 0, 0 ; offset_y, offset_x
			.word 136,240,144,144,80,112,
			.byte 0, 5 ; next_char_offset

			.word 0 ; safety pair of bytes for reading by POP B
__font_rus_b0:
			.byte 0, 0 ; offset_y, offset_x
			.word 224,144,144,144,144,224,128,192,
			.byte 0, 5 ; next_char_offset

			.word 0 ; safety pair of bytes for reading by POP B
__font_rus_c0:
			.byte 0, 0 ; offset_y, offset_x
			.word 224,144,144,144,144,224,144,224,
			.byte 0, 5 ; next_char_offset

			.word 0 ; safety pair of bytes for reading by POP B
__font_rus_d0:
			.byte 0, 0 ; offset_y, offset_x
			.word 128,128,128,128,144,240,
			.byte 0, 5 ; next_char_offset

			.word 0 ; safety pair of bytes for reading by POP B
__font_rus_e0:
			.byte 0, -1 ; offset_y, offset_x
			.word 248,72,72,72,72,48,
			.byte 0, 5 ; next_char_offset

			.word 0 ; safety pair of bytes for reading by POP B
__font_rus_f0:
			.byte 0, 0 ; offset_y, offset_x
			.word 240,144,128,192,144,224,
			.byte 0, 5 ; next_char_offset

			.word 0 ; safety pair of bytes for reading by POP B
__font_rus_h1:
			.byte 0, 0 ; offset_y, offset_x
			.word 240,144,128,192,144,224,0,160,
			.byte 0, 5 ; next_char_offset

			.word 0 ; safety pair of bytes for reading by POP B
__font_rus_g0:
			.byte 0, 0 ; offset_y, offset_x
			.word 168,168,112,112,168,168,
			.byte 0, 6 ; next_char_offset

			.word 0 ; safety pair of bytes for reading by POP B
__font_rus_h0:
			.byte -2, -2 ; offset_y, offset_x
			.word 240,8,8,8,16,8,72,48,
			.byte 0, 5 ; next_char_offset

			.word 0 ; safety pair of bytes for reading by POP B
__font_rus_i0:
			.byte 0, 0 ; offset_y, offset_x
			.word 104,152,136,136,136,136,
			.byte 0, 6 ; next_char_offset

			.word 0 ; safety pair of bytes for reading by POP B
__font_rus_j0:
			.byte 0, 0 ; offset_y, offset_x
			.word 104,152,136,136,136,136,32,80,
			.byte 0, 6 ; next_char_offset

			.word 0 ; safety pair of bytes for reading by POP B
__font_rus_k0:
			.byte 0, 0 ; offset_y, offset_x
			.word 88,96,80,80,72,200,
			.byte 0, 6 ; next_char_offset

			.word 0 ; safety pair of bytes for reading by POP B
__font_rus_l0:
			.byte -2, -4 ; offset_y, offset_x
			.word 224,16,18,10,10,10,10,30,
			.byte 0, 5 ; next_char_offset

			.word 0 ; safety pair of bytes for reading by POP B
__font_rus_m0:
			.byte 0, 0 ; offset_y, offset_x
			.word 172,168,168,168,216,208,
			.byte 0, 7 ; next_char_offset

			.word 0 ; safety pair of bytes for reading by POP B
__font_rus_n0:
			.byte 0, 0 ; offset_y, offset_x
			.word 144,144,144,240,144,144,
			.byte 0, 5 ; next_char_offset

			.word 0 ; safety pair of bytes for reading by POP B
__font_rus_o0:
			.byte 0, 0 ; offset_y, offset_x
			.word 112,136,168,136,136,112,
			.byte 0, 6 ; next_char_offset

			.word 0 ; safety pair of bytes for reading by POP B
__font_rus_p0:
			.byte 0, 0 ; offset_y, offset_x
			.word 80,80,80,80,80,240,
			.byte 0, 5 ; next_char_offset

			.word 0 ; safety pair of bytes for reading by POP B
__font_rus_q0:
			.byte -4, -2 ; offset_y, offset_x
			.word 64,64,64,64,112,72,72,72,72,240,
			.byte 0, 5 ; next_char_offset

			.word 0 ; safety pair of bytes for reading by POP B
__font_rus_r0:
			.byte 0, 0 ; offset_y, offset_x
			.word 96,144,144,128,144,96,
			.byte 0, 5 ; next_char_offset

			.word 0 ; safety pair of bytes for reading by POP B
__font_rus_s0:
			.byte 0, 0 ; offset_y, offset_x
			.word 172,168,168,168,168,240,
			.byte 0, 7 ; next_char_offset

			.word 0 ; safety pair of bytes for reading by POP B
__font_rus_t0:
			.byte -2, -2 ; offset_y, offset_x
			.word 240,8,56,72,72,72,72,72,
			.byte 0, 5 ; next_char_offset

			.word 0 ; safety pair of bytes for reading by POP B
__font_rus_u0:
			.byte -1, -1 ; offset_y, offset_x
			.word 32,240,168,168,168,168,112,32,0,
			.byte 0, 6 ; next_char_offset

			.word 0 ; safety pair of bytes for reading by POP B
__font_rus_v0:
			.byte 0, 0 ; offset_y, offset_x
			.word 144,144,96,96,144,144,
			.byte 0, 5 ; next_char_offset

			.word 0 ; safety pair of bytes for reading by POP B
__font_rus_w0:
			.byte -2, -1 ; offset_y, offset_x
			.word 24,4,104,152,136,136,136,136,
			.byte 0, 6 ; next_char_offset

			.word 0 ; safety pair of bytes for reading by POP B
__font_rus_x0:
			.byte -2, -1 ; offset_y, offset_x
			.word 8,8,104,152,136,136,136,136,
			.byte 0, 6 ; next_char_offset

			.word 0 ; safety pair of bytes for reading by POP B
__font_rus_y0:
			.byte 0, 0 ; offset_y, offset_x
			.word 88,168,168,168,168,168,
			.byte 0, 6 ; next_char_offset

			.word 0 ; safety pair of bytes for reading by POP B
__font_rus_z0:
			.byte -2, -1 ; offset_y, offset_x
			.word 56,4,88,168,168,168,168,168,
			.byte 0, 7 ; next_char_offset

			.word 0 ; safety pair of bytes for reading by POP B
__font_rus_a1:
			.byte 0, -1 ; offset_y, offset_x
			.word 56,36,36,56,160,224,
			.byte 0, 6 ; next_char_offset

			.word 0 ; safety pair of bytes for reading by POP B
__font_rus_b1:
			.byte 0, 0 ; offset_y, offset_x
			.word 119,74,74,114,66,199,
			.byte 0, 9 ; next_char_offset

			.word 0 ; safety pair of bytes for reading by POP B
__font_rus_c1:
			.byte 0, 0 ; offset_y, offset_x
			.word 224,144,144,224,128,128,
			.byte 0, 5 ; next_char_offset

			.word 0 ; safety pair of bytes for reading by POP B
__font_rus_d1:
			.byte 0, 0 ; offset_y, offset_x
			.word 0,0,0,0,0,0,
			.byte 0, 5 ; next_char_offset

			.word 0 ; safety pair of bytes for reading by POP B
__font_rus_e1:
			.byte 0, 0 ; offset_y, offset_x
			.word 0,0,0,0,0,0,
			.byte 0, 7 ; next_char_offset

			.word 0 ; safety pair of bytes for reading by POP B
__font_rus_f1:
			.byte -2, -3 ; offset_y, offset_x
			.word 0,0,0,0,0,0,
			.byte 0, 5 ; next_char_offset
