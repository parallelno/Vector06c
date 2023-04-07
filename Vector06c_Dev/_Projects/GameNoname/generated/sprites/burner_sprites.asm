; source\sprites\burner.json
__RAM_DISK_S_BURNER = RAM_DISK_S
; source\sprites\burner.json
__RAM_DISK_M_BURNER = RAM_DISK_M
__burner_sprites:
			.byte 1,1  ; safety word to support a stack renderer, and also (mask_flag, preshifting is done)
__burner_dash_0_0:
			.byte 0, 0; offset_y, offset_x
			.byte 14, 1; height, width
			.byte 254,0,63,0,63,0,254,0,63,192,254,1,252,2,63,64,63,0,252,0,63,128,252,1,248,3,31,0,31,0,248,0,31,224,248,4,200,53,7,184,7,0,200,0,7,96,200,2,128,38,3,248,3,0,128,0,3,196,128,91,128,75,1,250,1,0,128,0,1,196,128,54,192,31,1,240,1,0,192,0,1,254,192,47,224,31,3,228,3,0,224,0,3,216,224,3,144,7,1,236,1,0,144,0,1,178,144,107,128,87,1,154,1,0,128,0,1,228,128,45,192,25,1,176,1,0,192,0,1,206,192,38,224,28,7,200,7,0,224,0,7,48,224,3,240,6,7,96,7,0,240,0,7,152,240,9,249,6,15,240,15,0,249,0,15,0,249,0,

			.byte 0, 1 ; safety word to support a stack renderer and also (copy_from_buff_offset, mask_flag)
__burner_dash_0_1:
			.byte 0, 0; offset_y, offset_x
			.byte 14, 2; height, width
			.byte 255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,

			.byte 0, 1 ; safety word to support a stack renderer and also (copy_from_buff_offset, mask_flag)
__burner_dash_0_2:
			.byte 0, 0; offset_y, offset_x
			.byte 14, 2; height, width
			.byte 255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,

			.byte 0, 1 ; safety word to support a stack renderer and also (copy_from_buff_offset, mask_flag)
__burner_dash_0_3:
			.byte 0, 0; offset_y, offset_x
			.byte 14, 2; height, width
			.byte 255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,

			.byte 1,1  ; safety word to support a stack renderer, and also (mask_flag, preshifting is done)
__burner_dash_1_0:
			.byte 0, 0; offset_y, offset_x
			.byte 14, 1; height, width
			.byte 252,0,143,0,143,0,252,0,143,112,252,3,248,5,15,144,15,0,248,0,15,96,248,2,240,4,3,192,3,0,240,0,3,60,240,11,240,11,1,102,1,0,240,0,1,152,240,5,224,13,1,124,1,0,224,0,1,194,224,27,128,119,1,154,1,0,128,0,1,228,128,15,128,39,1,240,1,0,128,0,1,254,128,95,128,79,3,228,3,0,128,0,3,248,128,49,192,31,1,204,1,0,192,0,1,242,192,39,224,25,1,186,1,0,224,0,1,100,224,7,248,1,3,48,3,0,248,0,3,204,248,7,240,12,71,168,71,0,240,0,71,16,240,3,240,6,143,32,143,0,240,0,143,80,240,9,249,6,159,96,159,0,249,0,159,0,249,0,

			.byte 0, 1 ; safety word to support a stack renderer and also (copy_from_buff_offset, mask_flag)
__burner_dash_1_1:
			.byte 0, 0; offset_y, offset_x
			.byte 14, 2; height, width
			.byte 255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,

			.byte 0, 1 ; safety word to support a stack renderer and also (copy_from_buff_offset, mask_flag)
__burner_dash_1_2:
			.byte 0, 0; offset_y, offset_x
			.byte 14, 2; height, width
			.byte 255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,

			.byte 0, 1 ; safety word to support a stack renderer and also (copy_from_buff_offset, mask_flag)
__burner_dash_1_3:
			.byte 0, 0; offset_y, offset_x
			.byte 14, 2; height, width
			.byte 255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,

			.byte 1,1  ; safety word to support a stack renderer, and also (mask_flag, preshifting is done)
__burner_dash_2_0:
			.byte 0, 0; offset_y, offset_x
			.byte 14, 1; height, width
			.byte 240,0,159,0,159,0,240,0,159,96,240,15,224,25,15,144,15,0,224,0,15,96,224,6,224,12,7,192,7,0,224,0,7,56,224,19,128,115,3,100,3,0,128,0,3,152,128,13,128,39,1,180,1,0,128,0,1,234,128,89,128,77,9,214,9,0,128,0,9,224,128,55,192,27,7,192,7,0,192,0,7,248,192,39,128,127,3,244,3,0,128,0,3,248,128,15,128,35,1,108,1,0,128,0,1,210,128,95,192,35,1,218,1,0,192,0,1,100,192,31,224,6,19,64,19,0,224,0,19,172,224,29,248,7,31,32,31,0,248,0,31,192,248,0,252,1,63,128,63,0,252,0,63,64,252,2,252,3,127,128,127,0,252,0,127,0,252,0,

			.byte 0, 1 ; safety word to support a stack renderer and also (copy_from_buff_offset, mask_flag)
__burner_dash_2_1:
			.byte 0, 0; offset_y, offset_x
			.byte 14, 2; height, width
			.byte 255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,

			.byte 0, 1 ; safety word to support a stack renderer and also (copy_from_buff_offset, mask_flag)
__burner_dash_2_2:
			.byte 0, 0; offset_y, offset_x
			.byte 14, 2; height, width
			.byte 255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,

			.byte 0, 1 ; safety word to support a stack renderer and also (copy_from_buff_offset, mask_flag)
__burner_dash_2_3:
			.byte 0, 0; offset_y, offset_x
			.byte 14, 2; height, width
			.byte 255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,

			.byte 1,1  ; safety word to support a stack renderer, and also (mask_flag, preshifting is done)
__burner_dash_3_0:
			.byte 0, 0; offset_y, offset_x
			.byte 14, 1; height, width
			.byte 249,0,159,0,159,0,249,0,159,96,249,6,241,10,15,144,15,0,241,0,15,96,241,4,226,8,15,192,15,0,226,0,15,48,226,21,192,51,31,224,31,0,192,0,31,128,192,12,128,38,7,224,7,0,128,0,7,152,128,93,128,79,3,228,3,0,128,0,3,248,128,51,192,31,1,140,1,0,192,0,1,242,192,39,128,127,1,250,1,0,128,0,1,228,128,15,128,39,1,240,1,0,128,0,1,238,128,89,128,67,7,216,7,0,128,0,7,176,128,62,128,25,15,160,15,0,128,0,15,208,128,102,192,60,15,208,15,0,192,0,15,32,192,3,240,6,31,64,31,0,240,0,31,160,240,9,241,14,63,192,63,0,241,0,63,0,241,0,

			.byte 0, 1 ; safety word to support a stack renderer and also (copy_from_buff_offset, mask_flag)
__burner_dash_3_1:
			.byte 0, 0; offset_y, offset_x
			.byte 14, 2; height, width
			.byte 255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,

			.byte 0, 1 ; safety word to support a stack renderer and also (copy_from_buff_offset, mask_flag)
__burner_dash_3_2:
			.byte 0, 0; offset_y, offset_x
			.byte 14, 2; height, width
			.byte 255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,

			.byte 0, 1 ; safety word to support a stack renderer and also (copy_from_buff_offset, mask_flag)
__burner_dash_3_3:
			.byte 0, 0; offset_y, offset_x
			.byte 14, 2; height, width
			.byte 255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,

			.byte 1,1  ; safety word to support a stack renderer, and also (mask_flag, preshifting is done)
__burner_run_r0_0:
			.byte 1, 0; offset_y, offset_x
			.byte 13, 1; height, width
			.byte 255,0,47,0,47,0,255,0,47,208,255,0,254,1,7,104,7,0,254,0,7,208,254,0,252,1,3,248,3,0,252,0,3,244,252,2,248,5,3,252,3,0,248,0,3,32,248,2,248,2,3,32,3,144,248,1,3,108,248,4,240,13,3,244,3,0,240,0,3,248,240,7,224,13,3,240,3,0,224,0,3,236,224,30,224,25,3,244,3,0,224,0,3,8,224,14,240,7,3,248,3,0,240,0,3,228,240,9,248,6,7,200,7,0,248,0,7,240,248,1,252,1,15,224,15,0,252,0,15,80,252,2,254,1,31,96,31,0,254,0,31,128,254,0,255,0,127,0,127,0,255,0,127,128,255,0,

			.byte 0, 1 ; safety word to support a stack renderer and also (copy_from_buff_offset, mask_flag)
__burner_run_r0_1:
			.byte 1, 0; offset_y, offset_x
			.byte 13, 1; height, width
			.byte 255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,

			.byte 0, 1 ; safety word to support a stack renderer and also (copy_from_buff_offset, mask_flag)
__burner_run_r0_2:
			.byte 1, 0; offset_y, offset_x
			.byte 13, 2; height, width
			.byte 255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,

			.byte 1, 1 ; safety word to support a stack renderer and also (copy_from_buff_offset, mask_flag)
__burner_run_r0_3:
			.byte 1, 1; offset_y, offset_x
			.byte 13, 1; height, width
			.byte 255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,

			.byte 1,1  ; safety word to support a stack renderer, and also (mask_flag, preshifting is done)
__burner_run_r1_0:
			.byte 2, 0; offset_y, offset_x
			.byte 13, 1; height, width
			.byte 255,0,47,0,47,0,255,0,47,208,255,0,254,1,7,104,7,0,254,0,7,208,254,0,252,1,3,248,3,0,252,0,3,244,252,2,248,5,3,252,3,0,248,0,3,32,248,2,240,2,3,32,3,144,240,1,3,108,240,12,240,13,3,252,3,0,240,0,3,248,240,3,224,13,3,240,3,0,224,0,3,236,224,30,224,25,3,244,3,0,224,0,3,8,224,14,224,11,7,240,7,0,224,0,7,232,224,21,244,10,7,200,7,0,244,0,7,240,244,1,252,1,15,192,15,0,252,0,15,176,252,2,252,2,63,192,63,0,252,0,63,0,252,1,254,0,255,0,255,0,254,0,255,0,254,1,

			.byte 0, 1 ; safety word to support a stack renderer and also (copy_from_buff_offset, mask_flag)
__burner_run_r1_1:
			.byte 2, 0; offset_y, offset_x
			.byte 13, 1; height, width
			.byte 255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,

			.byte 0, 1 ; safety word to support a stack renderer and also (copy_from_buff_offset, mask_flag)
__burner_run_r1_2:
			.byte 2, 0; offset_y, offset_x
			.byte 13, 2; height, width
			.byte 255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,

			.byte 1, 1 ; safety word to support a stack renderer and also (copy_from_buff_offset, mask_flag)
__burner_run_r1_3:
			.byte 2, 1; offset_y, offset_x
			.byte 13, 1; height, width
			.byte 255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,

			.byte 1,1  ; safety word to support a stack renderer, and also (mask_flag, preshifting is done)
__burner_run_r2_0:
			.byte 1, 0; offset_y, offset_x
			.byte 13, 1; height, width
			.byte 255,0,47,0,47,0,255,0,47,208,255,0,254,1,7,104,7,0,254,0,7,208,254,0,252,1,3,248,3,0,252,0,3,244,252,2,248,5,3,252,3,0,248,0,3,32,248,2,240,2,3,32,3,144,240,1,3,108,240,12,224,29,3,252,3,0,224,0,3,248,224,11,192,13,3,240,3,0,192,0,3,236,192,62,192,49,3,244,3,0,192,0,3,8,192,30,192,19,7,240,7,0,192,0,7,232,192,45,236,18,7,200,7,0,236,0,7,240,236,1,248,3,15,192,15,0,248,0,15,48,248,4,248,5,63,192,63,0,248,0,63,0,248,2,253,0,255,0,255,0,253,0,255,0,253,2,

			.byte 0, 1 ; safety word to support a stack renderer and also (copy_from_buff_offset, mask_flag)
__burner_run_r2_1:
			.byte 1, 0; offset_y, offset_x
			.byte 13, 1; height, width
			.byte 255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,

			.byte 0, 1 ; safety word to support a stack renderer and also (copy_from_buff_offset, mask_flag)
__burner_run_r2_2:
			.byte 1, 0; offset_y, offset_x
			.byte 13, 2; height, width
			.byte 255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,

			.byte 1, 1 ; safety word to support a stack renderer and also (copy_from_buff_offset, mask_flag)
__burner_run_r2_3:
			.byte 1, 1; offset_y, offset_x
			.byte 13, 1; height, width
			.byte 255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,

			.byte 1,1  ; safety word to support a stack renderer, and also (mask_flag, preshifting is done)
__burner_run_r3_0:
			.byte 0, 0; offset_y, offset_x
			.byte 13, 1; height, width
			.byte 255,0,47,0,47,0,255,0,47,208,255,0,254,1,7,104,7,0,254,0,7,208,254,0,252,1,3,248,3,0,252,0,3,244,252,2,248,5,3,252,3,0,248,0,3,32,248,2,240,2,3,32,3,144,240,1,3,108,240,12,240,13,3,252,3,0,240,0,3,248,240,7,224,13,3,240,3,0,224,0,3,236,224,30,224,25,3,244,3,0,224,0,3,8,224,14,224,11,7,240,7,0,224,0,7,200,224,21,244,11,7,136,7,0,244,0,7,240,244,1,252,1,15,192,15,0,252,0,15,48,252,3,252,2,63,192,63,0,252,0,63,0,252,1,254,0,255,0,255,0,254,0,255,0,254,1,

			.byte 0, 1 ; safety word to support a stack renderer and also (copy_from_buff_offset, mask_flag)
__burner_run_r3_1:
			.byte 0, 0; offset_y, offset_x
			.byte 13, 1; height, width
			.byte 255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,

			.byte 0, 1 ; safety word to support a stack renderer and also (copy_from_buff_offset, mask_flag)
__burner_run_r3_2:
			.byte 0, 0; offset_y, offset_x
			.byte 13, 2; height, width
			.byte 255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,

			.byte 1, 1 ; safety word to support a stack renderer and also (copy_from_buff_offset, mask_flag)
__burner_run_r3_3:
			.byte 0, 1; offset_y, offset_x
			.byte 13, 1; height, width
			.byte 255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,

			.byte 1,1  ; safety word to support a stack renderer, and also (mask_flag, preshifting is done)
__burner_run_l0_0:
			.byte 1, 0; offset_y, offset_x
			.byte 13, 1; height, width
			.byte 244,0,255,0,255,0,244,0,255,0,244,11,224,22,127,128,127,0,224,0,127,0,224,11,192,31,63,128,63,0,192,0,63,64,192,47,192,63,31,160,31,0,192,0,31,64,192,4,192,4,31,64,31,128,192,9,31,32,192,54,192,47,15,176,15,0,192,0,15,224,192,31,192,15,7,176,7,0,192,0,7,120,192,55,192,47,7,152,7,0,192,0,7,112,192,16,192,31,15,224,15,0,192,0,15,144,192,39,224,19,31,96,31,0,224,0,31,128,224,15,240,7,63,128,63,0,240,0,63,64,240,10,248,6,127,128,127,0,248,0,127,0,248,1,254,0,255,0,255,0,254,0,255,0,254,1,

			.byte 0, 1 ; safety word to support a stack renderer and also (copy_from_buff_offset, mask_flag)
__burner_run_l0_1:
			.byte 1, 0; offset_y, offset_x
			.byte 13, 1; height, width
			.byte 255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,

			.byte 0, 1 ; safety word to support a stack renderer and also (copy_from_buff_offset, mask_flag)
__burner_run_l0_2:
			.byte 1, 0; offset_y, offset_x
			.byte 13, 2; height, width
			.byte 255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,

			.byte 1, 1 ; safety word to support a stack renderer and also (copy_from_buff_offset, mask_flag)
__burner_run_l0_3:
			.byte 1, 1; offset_y, offset_x
			.byte 13, 1; height, width
			.byte 255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,

			.byte 1,1  ; safety word to support a stack renderer, and also (mask_flag, preshifting is done)
__burner_run_l1_0:
			.byte 2, 0; offset_y, offset_x
			.byte 13, 1; height, width
			.byte 244,0,255,0,255,0,244,0,255,0,244,11,224,22,127,128,127,0,224,0,127,0,224,11,192,31,63,128,63,0,192,0,63,64,192,47,192,63,31,160,31,0,192,0,31,64,192,4,192,4,15,64,15,128,192,9,15,48,192,54,192,63,15,176,15,0,192,0,15,192,192,31,192,15,7,176,7,0,192,0,7,120,192,55,192,47,7,152,7,0,192,0,7,112,192,16,224,15,7,208,7,0,224,0,7,168,224,23,224,19,47,80,47,0,224,0,47,128,224,15,240,3,63,128,63,0,240,0,63,64,240,13,252,3,63,64,63,0,252,0,63,128,252,0,255,0,127,0,127,0,255,0,127,128,255,0,

			.byte 0, 1 ; safety word to support a stack renderer and also (copy_from_buff_offset, mask_flag)
__burner_run_l1_1:
			.byte 2, 0; offset_y, offset_x
			.byte 13, 1; height, width
			.byte 255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,

			.byte 0, 1 ; safety word to support a stack renderer and also (copy_from_buff_offset, mask_flag)
__burner_run_l1_2:
			.byte 2, 0; offset_y, offset_x
			.byte 13, 2; height, width
			.byte 255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,

			.byte 1, 1 ; safety word to support a stack renderer and also (copy_from_buff_offset, mask_flag)
__burner_run_l1_3:
			.byte 2, 1; offset_y, offset_x
			.byte 13, 1; height, width
			.byte 255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,

			.byte 1,1  ; safety word to support a stack renderer, and also (mask_flag, preshifting is done)
__burner_run_l2_0:
			.byte 1, 0; offset_y, offset_x
			.byte 13, 1; height, width
			.byte 244,0,255,0,255,0,244,0,255,0,244,11,224,22,127,128,127,0,224,0,127,0,224,11,192,31,63,128,63,0,192,0,63,64,192,47,192,63,31,160,31,0,192,0,31,64,192,4,192,4,15,64,15,128,192,9,15,48,192,54,192,63,7,184,7,0,192,0,7,208,192,31,192,15,3,176,3,0,192,0,3,124,192,55,192,47,3,140,3,0,192,0,3,120,192,16,224,15,3,200,3,0,224,0,3,180,224,23,224,19,55,72,55,0,224,0,55,128,224,15,240,3,31,192,31,0,240,0,31,32,240,12,252,3,31,160,31,0,252,0,31,64,252,0,255,0,191,0,191,0,255,0,191,64,255,0,

			.byte 0, 1 ; safety word to support a stack renderer and also (copy_from_buff_offset, mask_flag)
__burner_run_l2_1:
			.byte 1, 0; offset_y, offset_x
			.byte 13, 1; height, width
			.byte 255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,

			.byte 0, 1 ; safety word to support a stack renderer and also (copy_from_buff_offset, mask_flag)
__burner_run_l2_2:
			.byte 1, 0; offset_y, offset_x
			.byte 13, 2; height, width
			.byte 255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,

			.byte 1, 1 ; safety word to support a stack renderer and also (copy_from_buff_offset, mask_flag)
__burner_run_l2_3:
			.byte 1, 1; offset_y, offset_x
			.byte 13, 1; height, width
			.byte 255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,

			.byte 1,1  ; safety word to support a stack renderer, and also (mask_flag, preshifting is done)
__burner_run_l3_0:
			.byte 0, 0; offset_y, offset_x
			.byte 13, 1; height, width
			.byte 244,0,255,0,255,0,244,0,255,0,244,11,224,22,127,128,127,0,224,0,127,0,224,11,192,31,63,128,63,0,192,0,63,64,192,47,192,63,31,160,31,0,192,0,31,64,192,4,192,4,15,64,15,128,192,9,15,48,192,54,192,63,15,176,15,0,192,0,15,224,192,31,192,15,7,176,7,0,192,0,7,120,192,55,192,47,7,152,7,0,192,0,7,112,192,16,224,15,7,208,7,0,224,0,7,168,224,19,224,17,47,208,47,0,224,0,47,128,224,15,240,3,63,128,63,0,240,0,63,192,240,12,252,3,63,64,63,0,252,0,63,128,252,0,255,0,127,0,127,0,255,0,127,128,255,0,

			.byte 0, 1 ; safety word to support a stack renderer and also (copy_from_buff_offset, mask_flag)
__burner_run_l3_1:
			.byte 0, 0; offset_y, offset_x
			.byte 13, 1; height, width
			.byte 255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,

			.byte 0, 1 ; safety word to support a stack renderer and also (copy_from_buff_offset, mask_flag)
__burner_run_l3_2:
			.byte 0, 0; offset_y, offset_x
			.byte 13, 2; height, width
			.byte 255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,

			.byte 1, 1 ; safety word to support a stack renderer and also (copy_from_buff_offset, mask_flag)
__burner_run_l3_3:
			.byte 0, 1; offset_y, offset_x
			.byte 13, 1; height, width
			.byte 255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,
