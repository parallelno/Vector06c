; source\sprites\scythe.json
__RAM_DISK_S_SCYTHE = RAM_DISK_S
; source\sprites\scythe.json
__RAM_DISK_M_SCYTHE = RAM_DISK_M
__scythe_sprites:
			.byte 1,1  ; safety pair of bytes for reading by POP B, and also (mask_flag, preshifting is done)
__scythe_run0_0:
			.byte 4, 0; offset_y, offset_x
			.byte 5, 1; height, width
			.byte 255,0,63,64,63,0,255,0,63,192,255,0,251,4,159,96,159,0,251,0,159,32,251,0,240,0,15,48,15,0,240,4,15,224,240,11,0,248,15,32,15,192,0,7,15,48,0,0,7,0,207,16,207,0,7,120,207,48,7,128,

			.byte 0, 1 ; safety pair of bytes for reading by POP B and also (copy_from_buff_offset, mask_flag)
__scythe_run0_1:
			.byte 4, 0; offset_y, offset_x
			.byte 5, 1; height, width
			.byte 255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,

			.byte 0, 1 ; safety pair of bytes for reading by POP B and also (copy_from_buff_offset, mask_flag)
__scythe_run0_2:
			.byte 4, 0; offset_y, offset_x
			.byte 5, 1; height, width
			.byte 255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,

			.byte 0, 1 ; safety pair of bytes for reading by POP B and also (copy_from_buff_offset, mask_flag)
__scythe_run0_3:
			.byte 4, 0; offset_y, offset_x
			.byte 5, 2; height, width
			.byte 255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,

			.byte 1,1  ; safety pair of bytes for reading by POP B, and also (mask_flag, preshifting is done)
__scythe_run1_0:
			.byte 0, 0; offset_y, offset_x
			.byte 12, 1; height, width
			.byte 248,0,255,0,255,0,248,0,255,0,248,7,240,9,255,0,255,0,240,0,255,0,240,7,224,14,255,0,255,0,224,0,255,0,224,29,236,17,255,0,255,0,236,2,255,0,236,16,252,0,255,0,255,0,252,2,255,0,252,1,252,1,255,0,255,0,252,2,255,0,252,0,248,0,255,0,255,0,248,2,255,0,248,5,248,1,255,0,255,0,248,6,255,0,248,0,254,0,127,0,127,0,254,1,127,128,254,0,254,0,127,128,127,0,254,1,127,0,254,0,254,0,127,0,127,0,254,1,127,128,254,0,254,0,127,128,127,0,254,1,127,0,254,0,

			.byte 0, 1 ; safety pair of bytes for reading by POP B and also (copy_from_buff_offset, mask_flag)
__scythe_run1_1:
			.byte 0, 0; offset_y, offset_x
			.byte 12, 1; height, width
			.byte 255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,

			.byte 0, 1 ; safety pair of bytes for reading by POP B and also (copy_from_buff_offset, mask_flag)
__scythe_run1_2:
			.byte 0, 0; offset_y, offset_x
			.byte 12, 1; height, width
			.byte 255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,

			.byte 1, 1 ; safety pair of bytes for reading by POP B and also (copy_from_buff_offset, mask_flag)
__scythe_run1_3:
			.byte 0, 1; offset_y, offset_x
			.byte 12, 0; height, width
			.byte 255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,

			.byte 1,1  ; safety pair of bytes for reading by POP B, and also (mask_flag, preshifting is done)
__scythe_run2_0:
			.byte 4, 0; offset_y, offset_x
			.byte 6, 1; height, width
			.byte 126,0,15,0,15,0,126,0,15,240,126,129,0,126,15,16,15,224,0,1,15,0,0,128,0,192,255,0,255,0,0,62,255,0,0,1,28,161,255,0,255,0,28,2,255,0,28,192,159,64,255,0,255,0,159,0,255,0,159,96,223,32,255,0,255,0,223,0,255,0,223,32,

			.byte 0, 1 ; safety pair of bytes for reading by POP B and also (copy_from_buff_offset, mask_flag)
__scythe_run2_1:
			.byte 4, 0; offset_y, offset_x
			.byte 6, 1; height, width
			.byte 255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,

			.byte 0, 1 ; safety pair of bytes for reading by POP B and also (copy_from_buff_offset, mask_flag)
__scythe_run2_2:
			.byte 4, 0; offset_y, offset_x
			.byte 6, 1; height, width
			.byte 255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,

			.byte 0, 1 ; safety pair of bytes for reading by POP B and also (copy_from_buff_offset, mask_flag)
__scythe_run2_3:
			.byte 4, 0; offset_y, offset_x
			.byte 6, 2; height, width
			.byte 255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,

			.byte 1,1  ; safety pair of bytes for reading by POP B, and also (mask_flag, preshifting is done)
__scythe_run3_0:
			.byte 0, 0; offset_y, offset_x
			.byte 12, 1; height, width
			.byte 249,0,255,0,255,0,249,0,255,0,249,6,249,2,255,0,255,0,249,4,255,0,249,0,249,0,255,0,255,0,249,4,255,0,249,2,249,2,255,0,255,0,249,4,255,0,249,0,248,0,255,0,255,0,248,4,255,0,248,3,252,0,127,128,127,0,252,3,127,0,252,0,252,0,255,0,255,0,252,2,255,0,252,1,252,1,255,0,255,0,252,2,255,0,252,0,252,0,191,0,191,0,252,2,191,64,252,1,252,1,63,192,63,0,252,2,63,64,252,0,248,3,127,128,127,0,248,0,127,128,248,4,248,7,255,0,255,0,248,0,255,0,248,7,

			.byte 0, 1 ; safety pair of bytes for reading by POP B and also (copy_from_buff_offset, mask_flag)
__scythe_run3_1:
			.byte 0, 0; offset_y, offset_x
			.byte 12, 1; height, width
			.byte 255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,

			.byte 1, 1 ; safety pair of bytes for reading by POP B and also (copy_from_buff_offset, mask_flag)
__scythe_run3_2:
			.byte 0, 1; offset_y, offset_x
			.byte 12, 0; height, width
			.byte 255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,

			.byte 1, 1 ; safety pair of bytes for reading by POP B and also (copy_from_buff_offset, mask_flag)
__scythe_run3_3:
			.byte 0, 1; offset_y, offset_x
			.byte 12, 0; height, width
			.byte 255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,
