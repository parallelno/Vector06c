; source\sprites\vfx.json
__RAM_DISK_S_VFX = RAM_DISK_S
; source\sprites\vfx.json
__RAM_DISK_M_VFX = RAM_DISK_M
__vfx_sprites:
			.byte 1,1  ; safety pair of bytes for reading by POP B, and also (mask_flag, preshifting is done)
__vfx_invis_0:
			.byte 0, 0; offset_y, offset_x
			.byte 5, 0; height, width
			.byte 255,3,255,12,255,0,255,0,255,16,255,15,255,6,255,25,255,0,255,0,255,15,255,0,255,0,255,0,255,0,

			.byte 1,1  ; safety pair of bytes for reading by POP B, and also (mask_flag, preshifting is done)
__vfx_puff0_0:
			.byte 2, 0; offset_y, offset_x
			.byte 11, 1; height, width
			.byte 255,0,159,0,159,96,255,0,159,0,255,0,224,0,15,0,15,240,224,31,15,0,224,0,192,7,15,192,15,48,192,56,15,0,192,0,192,0,15,0,15,16,192,48,15,224,192,15,224,15,15,224,15,16,224,16,15,0,224,0,224,0,7,0,7,56,224,16,7,192,224,15,240,3,3,240,3,12,240,12,3,0,240,0,224,0,3,0,3,4,224,16,3,248,224,15,224,6,3,248,3,4,224,25,3,0,224,0,240,0,3,0,3,140,240,15,3,112,240,0,255,0,135,0,135,120,255,0,135,0,255,0,

			.byte 1,1  ; safety pair of bytes for reading by POP B, and also (mask_flag, preshifting is done)
__vfx_puff1_0:
			.byte 0, 0; offset_y, offset_x
			.byte 15, 1; height, width
			.byte 255,0,255,0,255,96,255,0,255,0,255,0,255,0,255,0,255,252,255,0,255,0,255,0,255,0,159,0,159,254,255,24,159,0,255,0,224,0,15,0,15,158,224,63,15,96,224,0,192,6,15,240,15,12,192,121,15,0,192,0,192,0,15,0,15,96,192,114,15,16,192,12,224,8,15,0,15,16,224,52,15,0,224,0,224,0,7,0,7,8,224,16,7,0,224,8,240,8,3,0,3,12,240,16,3,0,240,0,224,0,3,0,3,22,224,16,3,8,224,12,224,7,3,24,3,230,224,24,3,0,224,0,240,0,3,0,3,15,240,55,3,240,240,8,255,0,135,72,135,183,255,60,135,0,255,0,255,0,255,0,255,254,255,24,255,0,255,0,255,0,255,0,255,124,255,0,255,0,255,0,

			.byte 1,1  ; safety pair of bytes for reading by POP B, and also (mask_flag, preshifting is done)
__vfx_puff2_0:
			.byte 0, 0; offset_y, offset_x
			.byte 15, 1; height, width
			.byte 255,0,255,0,255,120,255,0,255,0,255,0,255,0,255,0,255,252,255,120,255,0,255,0,255,0,159,0,159,142,255,228,159,0,255,0,224,0,15,0,15,6,224,195,15,0,224,0,192,0,15,0,15,4,192,193,15,0,192,0,192,0,15,0,15,0,192,192,15,0,192,0,224,0,15,0,15,16,224,96,15,0,224,0,224,0,7,0,7,12,224,16,7,0,224,0,240,0,3,0,3,14,240,16,3,0,240,0,224,0,3,0,3,22,224,96,3,0,224,0,224,0,3,0,3,2,224,192,3,0,224,0,240,0,3,0,3,3,240,193,3,0,240,0,255,0,135,0,135,3,255,192,135,0,255,0,255,0,255,0,255,135,255,100,255,0,255,0,255,0,255,0,255,78,255,56,255,0,255,0,

			.byte 1,1  ; safety pair of bytes for reading by POP B, and also (mask_flag, preshifting is done)
__vfx_puff3_0:
			.byte 0, 0; offset_y, offset_x
			.byte 15, 1; height, width
			.byte 255,0,255,0,255,124,255,120,255,0,255,0,255,0,255,0,255,134,255,196,255,0,255,0,255,0,159,0,159,2,255,129,159,0,255,0,224,0,15,0,15,2,224,0,15,0,224,0,192,0,15,0,15,2,192,0,15,0,192,0,192,0,15,0,15,8,192,0,15,0,192,0,224,0,15,0,15,0,224,32,15,0,224,0,224,0,7,0,7,4,224,0,7,0,224,0,240,0,3,0,3,6,240,0,3,0,240,0,224,0,3,0,3,0,224,64,3,0,224,0,224,0,3,0,3,0,224,128,3,0,224,0,240,0,3,0,3,1,240,128,3,0,240,0,255,0,135,0,135,1,255,128,135,0,255,0,255,0,255,0,255,0,255,64,255,0,255,0,255,0,255,0,255,130,255,32,255,0,255,0,

			.byte 1,1  ; safety pair of bytes for reading by POP B, and also (mask_flag, preshifting is done)
__vfx_reward0_0:
			.byte 0, 0; offset_y, offset_x
			.byte 15, 1; height, width
			.byte 254,1,255,0,255,0,254,0,255,0,254,0,254,0,255,0,255,0,254,0,255,0,254,1,223,32,247,8,247,0,223,0,247,0,223,0,239,0,239,0,239,0,239,0,239,16,239,16,250,5,191,64,191,0,250,0,191,0,250,0,246,0,223,0,223,0,246,0,223,32,246,9,252,3,127,128,127,0,252,0,127,0,252,1,48,3,25,128,25,0,48,0,25,230,48,207,252,3,127,128,127,0,252,0,127,0,252,1,246,0,223,0,223,0,246,0,223,32,246,9,250,5,191,64,191,0,250,0,191,0,250,0,239,0,239,0,239,0,239,0,239,16,239,16,223,32,247,8,247,0,223,0,247,0,223,0,254,0,255,0,255,0,254,0,255,0,254,1,254,1,255,0,255,0,254,0,255,0,254,0,

			.byte 1,1  ; safety pair of bytes for reading by POP B, and also (mask_flag, preshifting is done)
__vfx_reward1_0:
			.byte 0, 0; offset_y, offset_x
			.byte 16, 1; height, width
			.byte 254,1,255,0,255,0,254,0,255,0,254,0,246,1,247,0,247,0,246,0,247,8,246,9,250,5,239,16,239,0,250,0,239,0,250,1,190,1,253,0,253,0,190,0,253,2,190,65,222,33,251,4,251,0,222,0,251,0,222,1,252,1,127,0,127,0,252,0,127,128,252,3,248,7,63,192,63,0,248,0,63,128,248,3,0,127,0,254,0,0,0,0,0,255,0,255,248,7,63,192,63,0,248,0,63,128,248,3,252,1,127,0,127,0,252,0,127,128,252,3,222,33,251,4,251,0,222,0,251,0,222,1,254,1,253,0,253,0,254,0,253,2,254,1,238,17,191,64,191,0,238,0,191,0,238,1,222,1,223,0,223,0,222,0,223,32,222,33,254,1,255,0,255,0,254,0,255,0,254,1,254,0,255,0,255,0,254,0,255,0,254,1,

			.byte 1,1  ; safety pair of bytes for reading by POP B, and also (mask_flag, preshifting is done)
__vfx_reward2_0:
			.byte 1, 0; offset_y, offset_x
			.byte 13, 1; height, width
			.byte 254,1,255,0,255,0,254,0,255,0,254,0,255,0,255,0,255,0,255,0,255,0,255,0,238,17,239,16,239,0,238,0,239,0,238,0,246,9,223,32,223,0,246,0,223,32,246,9,248,7,63,192,63,0,248,0,63,64,248,5,248,3,63,128,63,0,248,0,63,192,248,7,160,95,11,244,11,0,160,0,11,224,160,15,248,3,63,128,63,0,248,0,63,192,248,7,248,7,63,192,63,0,248,0,63,64,248,5,246,9,223,32,223,0,246,0,223,32,246,9,238,17,239,16,239,0,238,0,239,0,238,0,255,0,255,0,255,0,255,0,255,0,255,0,254,1,255,0,255,0,254,0,255,0,254,0,

			.byte 1,1  ; safety pair of bytes for reading by POP B, and also (mask_flag, preshifting is done)
__vfx_reward3_0:
			.byte 3, 0; offset_y, offset_x
			.byte 9, 1; height, width
			.byte 254,1,255,0,255,0,254,0,255,0,254,1,255,0,255,0,255,0,255,0,255,0,255,0,254,1,255,0,255,0,254,0,255,0,254,0,254,1,255,0,255,0,254,0,255,0,254,1,232,23,47,208,47,0,232,0,47,144,232,19,254,1,255,0,255,0,254,0,255,0,254,1,254,1,255,0,255,0,254,0,255,0,254,0,255,0,255,0,255,0,255,0,255,0,255,0,254,1,255,0,255,0,254,0,255,0,254,1,
