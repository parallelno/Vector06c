__RAM_DISK_S_LEVEL01_GFX = RAM_DISK_S
__RAM_DISK_M_LEVEL01_GFX = RAM_DISK_M
; source\levels\art\sprites_tiles_lv01.png
__level01_palette_sprites_tiles_lv01:
			.byte %01001010, %00000001, %01011100, %00011010, 
			.byte %11100100, %11111101, %01110111, %01011111, 
			.byte %01000010, %01001011, %01001100, %11111111, 
			.byte %01001001, %11101011, %01010010, %01011011, 


			.byte 0,0 ; safety pair of bytes to support a stack renderer
__level01_tilesAddr:
			.word __sprites_tiles_lv01_tile0, 0, __sprites_tiles_lv01_tile1, 0, __sprites_tiles_lv01_tile2, 0, __sprites_tiles_lv01_tile3, 0, __sprites_tiles_lv01_tile4, 0, __sprites_tiles_lv01_tile5, 0, __sprites_tiles_lv01_tile6, 0, __sprites_tiles_lv01_tile7, 0, __sprites_tiles_lv01_tile8, 0, __sprites_tiles_lv01_tile9, 0, __sprites_tiles_lv01_tile10, 0, __sprites_tiles_lv01_tile11, 0, __sprites_tiles_lv01_tile12, 0, __sprites_tiles_lv01_tile13, 0, __sprites_tiles_lv01_tile14, 0, __sprites_tiles_lv01_tile15, 0, __sprites_tiles_lv01_tile16, 0, __sprites_tiles_lv01_tile17, 0, __sprites_tiles_lv01_tile18, 0, __sprites_tiles_lv01_tile19, 0, __sprites_tiles_lv01_tile20, 0, __sprites_tiles_lv01_tile21, 0, __sprites_tiles_lv01_tile22, 0, __sprites_tiles_lv01_tile23, 0, __sprites_tiles_lv01_tile24, 0, __sprites_tiles_lv01_tile25, 0, __sprites_tiles_lv01_tile26, 0, __sprites_tiles_lv01_tile27, 0, __sprites_tiles_lv01_tile28, 0, __sprites_tiles_lv01_tile29, 0, __sprites_tiles_lv01_tile30, 0, __sprites_tiles_lv01_tile31, 0, __sprites_tiles_lv01_tile32, 0, __sprites_tiles_lv01_tile33, 0, __sprites_tiles_lv01_tile34, 0, __sprites_tiles_lv01_tile35, 0, __sprites_tiles_lv01_tile36, 0, __sprites_tiles_lv01_tile37, 0, __sprites_tiles_lv01_tile38, 0, __sprites_tiles_lv01_tile39, 0, __sprites_tiles_lv01_tile40, 0, __sprites_tiles_lv01_tile41, 0, __sprites_tiles_lv01_tile42, 0, __sprites_tiles_lv01_tile43, 0, __sprites_tiles_lv01_tile44, 0, __sprites_tiles_lv01_tile45, 0, __sprites_tiles_lv01_tile46, 0, __sprites_tiles_lv01_tile47, 0, __sprites_tiles_lv01_tile48, 0, __sprites_tiles_lv01_tile49, 0, __sprites_tiles_lv01_tile50, 0, __sprites_tiles_lv01_tile51, 0, __sprites_tiles_lv01_tile52, 0, __sprites_tiles_lv01_tile53, 0, __sprites_tiles_lv01_tile54, 0, __sprites_tiles_lv01_tile55, 0, __sprites_tiles_lv01_tile56, 0, __sprites_tiles_lv01_tile57, 0, __sprites_tiles_lv01_tile58, 0, __sprites_tiles_lv01_tile59, 0, __sprites_tiles_lv01_tile60, 0, __sprites_tiles_lv01_tile61, 0, __sprites_tiles_lv01_tile62, 0, __sprites_tiles_lv01_tile63, 0, __sprites_tiles_lv01_tile64, 0, __sprites_tiles_lv01_tile65, 0, __sprites_tiles_lv01_tile66, 0, __sprites_tiles_lv01_tile67, 0, __sprites_tiles_lv01_tile68, 0, __sprites_tiles_lv01_tile69, 0, __sprites_tiles_lv01_tile70, 0, __sprites_tiles_lv01_tile71, 0, __sprites_tiles_lv01_tile72, 0, __sprites_tiles_lv01_tile73, 0, __sprites_tiles_lv01_tile74, 0, __sprites_tiles_lv01_tile75, 0, __sprites_tiles_lv01_tile76, 0, __sprites_tiles_lv01_tile77, 0, __sprites_tiles_lv01_tile78, 

; source\levels\art\sprites_tiles_lv01.png
__sprites_tiles_lv01_tiles:
			.byte 0,0 ; safety pair of bytes to support a stack renderer
__sprites_tiles_lv01_tile0:
			.byte 8 ; mask
			.byte 4 ; counter
			.byte 255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,
			.byte 255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,
			.byte 0,0 ; safety pair of bytes to support a stack renderer
__sprites_tiles_lv01_tile1:
			.byte 13 ; mask
			.byte 4 ; counter
			.byte 65,28,33,33,33,30,0,0,0,0,0,0,0,0,0,0,
			.byte 0,0,3,0,4,7,1,3,0,0,32,32,128,0,0,0,
			.byte 50,0,30,30,30,0,0,0,0,0,0,0,0,0,0,0,
			.byte 0,0,0,3,3,0,2,0,0,24,88,192,0,0,0,0,
			.byte 193,221,225,225,225,222,255,255,255,255,255,255,255,255,255,255,
			.byte 255,255,255,252,252,255,249,227,235,129,35,39,229,143,187,231,
			.byte 0,0 ; safety pair of bytes to support a stack renderer
__sprites_tiles_lv01_tile2:
			.byte 13 ; mask
			.byte 4 ; counter
			.byte 0,0,0,1,4,4,0,0,192,128,224,32,0,192,0,0,
			.byte 0,0,0,0,0,0,0,0,0,0,120,132,132,132,56,130,
			.byte 0,0,0,0,3,26,24,0,0,64,0,192,192,0,0,0,
			.byte 0,0,0,0,0,0,0,0,0,0,0,120,120,120,0,68,
			.byte 231,221,241,167,228,196,129,215,199,159,255,63,63,255,255,255,
			.byte 255,255,255,255,255,255,255,255,255,255,123,135,135,135,187,131,
			.byte 0,0 ; safety pair of bytes to support a stack renderer
__sprites_tiles_lv01_tile3:
			.byte 13 ; mask
			.byte 4 ; counter
			.byte 31,0,56,12,3,0,0,44,31,0,0,95,64,12,53,0,
			.byte 1,246,206,0,238,0,0,220,3,67,1,233,6,0,0,252,
			.byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,200,13,
			.byte 220,9,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
			.byte 97,127,199,99,220,195,96,24,3,127,255,79,127,12,53,224,
			.byte 1,246,206,255,238,255,255,221,2,1,252,6,249,252,255,243,
			.byte 0,0 ; safety pair of bytes to support a stack renderer
__sprites_tiles_lv01_tile4:
			.byte 13 ; mask
			.byte 4 ; counter
			.byte 31,0,29,13,0,0,0,32,7,95,64,236,52,34,205,0,
			.byte 0,220,35,34,206,0,238,250,1,65,13,1,216,204,0,254,
			.byte 0,0,0,0,0,0,0,0,0,0,0,0,201,205,0,0,
			.byte 0,0,220,221,0,0,0,0,0,0,0,0,0,0,0,0,
			.byte 101,127,226,114,255,199,96,16,24,79,127,236,52,34,255,255,
			.byte 255,255,35,34,206,255,238,5,2,1,240,254,39,48,255,251,
			.byte 0,0 ; safety pair of bytes to support a stack renderer
__sprites_tiles_lv01_tile5:
			.byte 13 ; mask
			.byte 4 ; counter
			.byte 0,100,8,52,0,0,0,28,2,1,60,0,28,34,122,65,
			.byte 1,0,0,0,0,136,0,0,8,0,4,0,16,2,36,8,
			.byte 0,2,4,2,0,0,0,0,0,0,0,0,0,28,0,62,
			.byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
			.byte 193,229,233,245,127,199,0,28,2,129,63,127,127,163,251,193,
			.byte 255,178,226,194,2,138,2,31,47,92,187,127,239,253,219,215,
			.byte 0,0 ; safety pair of bytes to support a stack renderer
__sprites_tiles_lv01_tile6:
			.byte 13 ; mask
			.byte 4 ; counter
			.byte 0,0,0,192,1,2,0,0,0,0,17,0,0,0,0,128,
			.byte 130,94,68,56,0,188,128,64,56,0,32,0,110,20,38,0,
			.byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
			.byte 124,0,56,0,0,0,0,0,0,0,0,0,0,0,0,0,
			.byte 251,251,247,55,239,223,58,228,248,64,81,64,67,71,77,255,
			.byte 131,223,197,254,254,124,129,64,56,0,195,254,239,247,167,195,
			.byte 0,0 ; safety pair of bytes to support a stack renderer
__sprites_tiles_lv01_tile7:
			.byte 15 ; mask
			.byte 4 ; counter
			.byte 0,48,1,2,0,0,0,0,0,0,0,0,0,0,0,0,
			.byte 1,0,1,1,0,0,0,1,0,0,0,0,25,227,0,0,
			.byte 0,0,0,0,1,0,1,3,3,1,1,0,0,0,0,0,
			.byte 0,0,0,0,128,192,224,240,240,224,0,48,0,0,0,0,
			.byte 0,0,0,1,2,0,1,3,3,1,1,0,0,0,0,0,
			.byte 0,0,0,0,128,192,224,240,240,224,0,192,224,0,0,0,
			.byte 254,207,254,124,104,127,255,255,47,63,111,239,47,47,255,112,
			.byte 2,255,254,254,255,254,126,254,127,127,255,3,6,28,255,63,
			.byte 0,0 ; safety pair of bytes to support a stack renderer
__sprites_tiles_lv01_tile8:
			.byte 9 ; mask
			.byte 4 ; counter
			.byte 0,1,236,65,92,0,15,15,192,0,66,0,29,0,0,0,
			.byte 97,32,25,245,128,0,0,125,240,64,0,0,193,3,104,0,
			.byte 255,254,19,62,35,96,224,224,48,63,32,226,34,63,240,112,
			.byte 66,1,230,2,35,34,254,130,3,2,127,193,62,252,151,255,
			.byte 0,0 ; safety pair of bytes to support a stack renderer
__sprites_tiles_lv01_tile9:
			.byte 9 ; mask
			.byte 4 ; counter
			.byte 0,1,224,3,64,0,0,1,196,0,65,0,0,0,0,0,
			.byte 1,0,1,65,64,16,144,1,0,0,0,0,249,3,104,0,
			.byte 255,254,31,60,40,127,255,252,42,62,46,239,47,47,255,112,
			.byte 2,255,254,190,255,174,190,174,231,255,255,3,6,252,151,255,
			.byte 0,0 ; safety pair of bytes to support a stack renderer
__sprites_tiles_lv01_tile10:
			.byte 13 ; mask
			.byte 4 ; counter
			.byte 0,128,28,0,60,0,64,0,0,0,8,14,26,98,0,0,
			.byte 8,40,40,32,40,40,40,32,17,22,0,0,15,0,127,0,
			.byte 0,0,0,0,0,0,0,0,0,0,0,0,4,0,0,0,
			.byte 0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,
			.byte 255,127,255,255,223,193,161,255,195,129,137,143,155,255,255,157,
			.byte 215,215,215,223,215,215,215,222,206,200,236,255,192,128,128,255,
			.byte 0,0 ; safety pair of bytes to support a stack renderer
__sprites_tiles_lv01_tile11:
			.byte 13 ; mask
			.byte 4 ; counter
			.byte 0,254,0,224,0,0,32,224,0,112,0,0,0,0,0,0,
			.byte 0,0,98,28,12,8,0,0,0,64,0,120,0,56,0,0,
			.byte 0,0,0,0,0,0,192,0,96,0,16,0,0,0,0,0,
			.byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
			.byte 255,1,1,3,255,55,19,19,27,139,203,251,251,251,251,251,
			.byte 185,255,255,157,141,137,129,195,255,135,131,191,255,255,255,255,
			.byte 0,0 ; safety pair of bytes to support a stack renderer
__sprites_tiles_lv01_tile12:
			.byte 13 ; mask
			.byte 4 ; counter
			.byte 0,0,223,64,30,30,19,31,0,0,196,215,253,31,7,224,
			.byte 3,248,204,227,177,1,0,0,156,248,253,229,0,220,0,0,
			.byte 0,0,0,0,0,0,0,0,0,0,0,32,0,224,232,0,
			.byte 0,3,3,0,2,0,0,0,0,0,0,0,0,0,0,0,
			.byte 255,255,32,63,33,224,32,32,208,255,244,196,240,28,23,255,
			.byte 255,252,140,15,37,3,255,3,65,7,0,2,255,34,255,255,
			.byte 0,0 ; safety pair of bytes to support a stack renderer
__sprites_tiles_lv01_tile13:
			.byte 13 ; mask
			.byte 4 ; counter
			.byte 94,0,59,0,167,191,31,185,254,0,112,136,232,4,4,112,
			.byte 40,100,0,0,0,70,56,48,16,0,0,0,2,0,30,0,
			.byte 0,0,0,0,0,0,0,0,0,0,0,112,0,248,136,0,
			.byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
			.byte 161,255,68,255,64,0,224,2,240,252,255,143,238,7,7,118,
			.byte 239,229,195,157,255,255,185,177,145,129,195,255,225,193,253,255,
			.byte 0,0 ; safety pair of bytes to support a stack renderer
__sprites_tiles_lv01_tile14:
			.byte 9 ; mask
			.byte 4 ; counter
			.byte 0,0,240,129,0,128,0,0,0,1,0,4,0,0,0,0,
			.byte 0,0,0,0,64,64,192,0,0,0,0,0,0,0,0,0,
			.byte 0,0,0,0,0,0,0,0,0,0,0,130,87,186,125,255,
			.byte 255,255,238,85,59,17,0,0,0,0,0,0,0,0,0,0,
			.byte 0,0 ; safety pair of bytes to support a stack renderer
__sprites_tiles_lv01_tile15:
			.byte 15 ; mask
			.byte 4 ; counter
			.byte 0,0,0,0,4,2,0,0,7,15,31,31,23,15,14,0,
			.byte 0,250,252,252,112,32,224,128,0,16,96,0,0,0,0,0,
			.byte 0,0,0,0,4,0,0,0,6,15,15,15,7,14,4,0,
			.byte 0,0,240,240,96,0,128,0,0,0,96,0,0,0,0,0,
			.byte 0,0,0,0,4,0,0,0,6,15,15,15,7,14,4,0,
			.byte 0,0,240,240,96,0,128,0,0,0,96,0,0,0,0,0,
			.byte 0,0,0,0,0,0,0,0,0,0,0,0,64,48,113,255,
			.byte 255,4,2,0,10,16,0,0,0,0,0,0,0,0,0,0,
			.byte 0,0 ; safety pair of bytes to support a stack renderer
__sprites_tiles_lv01_tile16:
			.byte 9 ; mask
			.byte 4 ; counter
			.byte 0,0,0,0,0,0,0,2,2,124,0,4,0,0,0,0,
			.byte 0,0,0,0,64,0,0,128,0,0,0,0,0,0,0,0,
			.byte 0,0,0,0,0,0,0,0,0,0,0,2,87,58,125,255,
			.byte 255,255,238,85,59,17,0,0,0,0,0,0,0,0,0,0,
			.byte 0,0 ; safety pair of bytes to support a stack renderer
__sprites_tiles_lv01_tile17:
			.byte 9 ; mask
			.byte 4 ; counter
			.byte 0,1,0,1,1,1,1,1,0,0,0,0,0,0,0,0,
			.byte 0,0,0,0,0,0,0,0,0,174,0,0,0,0,0,0,
			.byte 0,0,0,0,0,0,0,0,0,0,0,136,93,235,247,255,
			.byte 254,252,186,80,224,64,0,0,0,0,0,0,0,0,0,0,
			.byte 0,0 ; safety pair of bytes to support a stack renderer
__sprites_tiles_lv01_tile18:
			.byte 13 ; mask
			.byte 4 ; counter
			.byte 65,156,161,161,161,94,96,62,7,3,16,4,67,0,0,0,
			.byte 0,39,15,56,124,119,225,195,0,128,32,32,128,0,0,0,
			.byte 50,0,30,30,30,0,0,0,0,0,0,0,0,0,0,0,
			.byte 0,0,0,3,3,0,2,0,0,24,88,192,0,0,0,0,
			.byte 193,93,97,97,97,30,31,1,0,0,0,0,0,0,0,0,
			.byte 0,0,3,4,4,15,25,35,235,1,35,39,229,143,187,231,
			.byte 0,0 ; safety pair of bytes to support a stack renderer
__sprites_tiles_lv01_tile19:
			.byte 1 ; mask
			.byte 4 ; counter
			.byte 255,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,
			.byte 1,1,1,1,1,1,1,1,0,1,0,0,0,0,0,232,
			.byte 0,0 ; safety pair of bytes to support a stack renderer
__sprites_tiles_lv01_tile20:
			.byte 0 ; mask
			.byte 4 ; counter

			.byte 0,0 ; safety pair of bytes to support a stack renderer
__sprites_tiles_lv01_tile21:
			.byte 1 ; mask
			.byte 4 ; counter
			.byte 0,0,0,0,0,0,0,0,0,0,0,237,128,128,128,128,
			.byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,95,
			.byte 0,0 ; safety pair of bytes to support a stack renderer
__sprites_tiles_lv01_tile22:
			.byte 1 ; mask
			.byte 4 ; counter
			.byte 0,0,0,0,0,0,1,1,1,1,1,1,1,0,0,0,
			.byte 0,0,0,0,0,0,255,1,1,0,0,0,0,0,0,0,
			.byte 0,0 ; safety pair of bytes to support a stack renderer
__sprites_tiles_lv01_tile23:
			.byte 0 ; mask
			.byte 4 ; counter

			.byte 0,0 ; safety pair of bytes to support a stack renderer
__sprites_tiles_lv01_tile24:
			.byte 0 ; mask
			.byte 4 ; counter

			.byte 0,0 ; safety pair of bytes to support a stack renderer
__sprites_tiles_lv01_tile25:
			.byte 13 ; mask
			.byte 4 ; counter
			.byte 65,72,72,59,96,152,153,145,56,200,139,139,136,242,144,0,
			.byte 0,0,0,0,208,128,224,120,60,194,185,4,4,144,64,50,
			.byte 48,48,48,0,16,96,96,104,0,48,112,112,112,0,0,0,
			.byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
			.byte 198,207,207,252,230,159,158,150,247,207,140,140,140,252,96,0,
			.byte 0,0,0,0,0,0,0,128,192,124,170,15,13,13,137,203,
			.byte 0,0 ; safety pair of bytes to support a stack renderer
__sprites_tiles_lv01_tile26:
			.byte 1 ; mask
			.byte 4 ; counter
			.byte 0,0,0,0,0,0,0,0,0,255,0,0,0,0,0,0,
			.byte 63,1,1,1,1,1,244,0,0,0,0,0,0,0,0,0,
			.byte 0,0 ; safety pair of bytes to support a stack renderer
__sprites_tiles_lv01_tile27:
			.byte 15 ; mask
			.byte 4 ; counter
			.byte 137,152,184,191,7,32,64,38,80,0,0,48,88,15,32,31,
			.byte 112,13,114,26,2,0,16,50,240,2,14,132,225,53,53,36,
			.byte 0,16,16,24,7,0,0,0,0,0,0,0,0,0,0,0,
			.byte 0,0,0,0,0,0,0,0,0,0,0,192,48,16,16,0,
			.byte 7,23,23,24,7,0,0,0,14,48,0,0,32,48,31,0,
			.byte 0,112,12,4,0,12,12,192,0,0,0,128,32,208,208,192,
			.byte 120,104,64,64,248,175,240,198,144,135,192,184,222,207,96,63,
			.byte 252,14,115,251,19,17,241,49,247,11,253,59,78,10,42,58,
			.byte 0,0 ; safety pair of bytes to support a stack renderer
__sprites_tiles_lv01_tile28:
			.byte 1 ; mask
			.byte 4 ; counter
			.byte 0,0,0,0,242,0,0,0,0,0,0,0,0,0,0,0,
			.byte 0,0,0,0,0,0,0,0,0,0,0,128,128,128,128,128,
			.byte 0,0 ; safety pair of bytes to support a stack renderer
__sprites_tiles_lv01_tile29:
			.byte 1 ; mask
			.byte 4 ; counter
			.byte 128,128,128,128,128,0,0,0,0,0,0,0,1,1,1,255,
			.byte 232,0,0,0,0,0,1,0,1,1,1,1,1,1,1,1,
			.byte 0,0 ; safety pair of bytes to support a stack renderer
__sprites_tiles_lv01_tile30:
			.byte 1 ; mask
			.byte 4 ; counter
			.byte 0,0,1,1,1,0,0,0,0,0,0,0,0,0,0,0,
			.byte 0,0,0,0,0,0,0,0,0,0,0,79,1,1,1,1,
			.byte 0,0 ; safety pair of bytes to support a stack renderer
__sprites_tiles_lv01_tile31:
			.byte 13 ; mask
			.byte 4 ; counter
			.byte 76,2,9,32,32,157,67,60,30,3,1,9,2,0,0,0,
			.byte 0,9,79,209,209,209,19,28,137,153,25,6,220,18,18,130,
			.byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
			.byte 0,0,0,14,14,14,12,0,22,6,6,8,0,12,12,12,
			.byte 211,145,176,176,240,85,62,3,1,0,0,0,0,0,0,0,
			.byte 0,6,63,49,49,49,243,239,105,121,249,103,63,243,243,99,
			.byte 0,0 ; safety pair of bytes to support a stack renderer
__sprites_tiles_lv01_tile32:
			.byte 13 ; mask
			.byte 4 ; counter
			.byte 64,56,68,5,68,60,76,57,17,73,89,33,65,73,73,49,
			.byte 0,129,83,96,104,88,20,64,96,72,192,112,58,10,166,56,
			.byte 48,0,24,120,56,0,48,0,0,48,32,0,48,48,48,0,
			.byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
			.byte 207,255,231,134,199,255,207,254,214,206,222,230,198,206,206,246,
			.byte 251,118,172,159,149,165,233,189,157,181,61,141,197,241,93,199,
			.byte 0,0 ; safety pair of bytes to support a stack renderer
__sprites_tiles_lv01_tile33:
			.byte 13 ; mask
			.byte 4 ; counter
			.byte 184,64,143,16,96,72,24,145,6,8,8,9,10,9,9,137,
			.byte 32,34,34,160,32,32,32,192,8,2,2,5,13,241,0,6,
			.byte 0,0,0,0,0,0,0,0,1,7,7,7,7,7,7,7,
			.byte 192,192,192,192,192,192,192,0,0,0,0,0,0,0,0,0,
			.byte 7,63,112,224,159,184,251,87,94,88,120,120,120,88,88,88,
			.byte 54,52,52,52,52,52,52,244,228,140,28,250,2,14,254,248,
			.byte 0,0 ; safety pair of bytes to support a stack renderer
__sprites_tiles_lv01_tile34:
			.byte 13 ; mask
			.byte 4 ; counter
			.byte 28,101,80,92,14,3,18,6,2,40,26,22,6,202,129,0,
			.byte 140,146,146,130,132,154,146,136,156,50,60,34,160,34,28,2,
			.byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
			.byte 0,12,12,12,0,4,12,0,0,12,0,28,30,24,0,12,
			.byte 227,186,143,163,177,188,173,185,189,151,165,169,249,53,110,223,
			.byte 111,115,115,99,103,123,115,107,127,243,255,227,97,231,255,243,
			.byte 0,0 ; safety pair of bytes to support a stack renderer
__sprites_tiles_lv01_tile35:
			.byte 13 ; mask
			.byte 4 ; counter
			.byte 110,0,32,53,255,135,1,120,121,73,65,121,113,73,73,49,
			.byte 0,129,83,96,104,88,20,64,96,72,2,0,30,33,97,33,
			.byte 0,0,0,72,0,120,122,0,0,48,48,0,0,48,48,0,
			.byte 0,0,0,0,0,0,0,0,0,0,0,0,128,222,30,30,
			.byte 239,254,195,49,252,135,133,255,190,206,206,182,182,206,206,246,
			.byte 251,118,172,159,149,165,233,189,157,181,253,127,30,33,225,97,
			.byte 0,0 ; safety pair of bytes to support a stack renderer
__sprites_tiles_lv01_tile36:
			.byte 9 ; mask
			.byte 4 ; counter
			.byte 0,0,0,0,0,26,0,0,0,0,0,0,16,0,0,0,
			.byte 0,0,0,2,2,2,2,2,28,0,0,0,0,0,4,0,
			.byte 0,0,0,0,0,0,0,0,0,0,0,4,46,117,123,255,
			.byte 255,254,221,168,112,32,0,0,0,0,0,0,0,0,0,0,
			.byte 0,0 ; safety pair of bytes to support a stack renderer
__sprites_tiles_lv01_tile37:
			.byte 1 ; mask
			.byte 4 ; counter
			.byte 1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
			.byte 1,1,1,1,1,0,1,0,0,0,0,0,1,1,1,255,
			.byte 0,0 ; safety pair of bytes to support a stack renderer
__sprites_tiles_lv01_tile38:
			.byte 13 ; mask
			.byte 4 ; counter
			.byte 132,134,132,120,0,64,18,6,2,40,26,22,6,202,129,0,
			.byte 140,146,146,142,158,130,146,158,30,128,225,255,172,4,0,118,
			.byte 120,120,123,1,0,0,0,0,0,0,0,0,0,0,0,0,
			.byte 0,12,12,0,0,12,12,0,0,94,30,0,18,0,0,0,
			.byte 134,135,132,120,254,191,173,185,189,151,165,169,249,53,110,223,
			.byte 111,115,115,109,109,115,115,125,255,161,225,63,140,195,127,247,
			.byte 0,0 ; safety pair of bytes to support a stack renderer
__sprites_tiles_lv01_tile39:
			.byte 13 ; mask
			.byte 4 ; counter
			.byte 0,120,0,64,0,0,0,8,12,28,98,0,0,0,38,20,
			.byte 14,32,32,23,17,14,0,127,157,248,253,229,0,220,0,122,
			.byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
			.byte 0,17,31,0,14,0,0,0,0,0,0,0,0,0,0,0,
			.byte 255,191,131,135,255,195,129,137,141,157,255,255,185,195,167,247,
			.byte 110,224,224,119,241,255,63,15,64,7,0,2,255,34,255,133,
			.byte 0,0 ; safety pair of bytes to support a stack renderer
__sprites_tiles_lv01_tile40:
			.byte 13 ; mask
			.byte 4 ; counter
			.byte 163,184,176,136,25,32,64,38,80,0,0,48,88,15,32,31,
			.byte 112,13,114,26,2,0,16,50,240,2,14,252,17,1,5,244,
			.byte 0,0,0,0,0,0,0,0,14,48,0,0,32,48,31,0,
			.byte 0,112,12,4,0,12,12,192,0,0,0,0,0,0,0,0,
			.byte 64,100,79,112,192,159,240,198,144,135,192,184,222,207,96,63,
			.byte 252,14,115,251,19,17,241,49,247,11,245,3,14,250,34,2,
			.byte 0,0 ; safety pair of bytes to support a stack renderer
__sprites_tiles_lv01_tile41:
			.byte 15 ; mask
			.byte 4 ; counter
			.byte 0,127,7,3,2,114,2,2,2,18,2,0,0,0,0,0,
			.byte 0,0,0,0,72,72,72,72,72,72,72,72,252,252,248,0,
			.byte 0,0,0,120,112,0,0,120,112,0,96,104,13,5,0,0,
			.byte 0,52,181,129,0,1,1,1,1,1,1,1,1,1,3,0,
			.byte 0,8,4,1,5,109,5,1,5,13,101,120,31,7,0,0,
			.byte 0,124,252,128,52,180,180,180,180,180,180,180,180,160,0,0,
			.byte 255,247,251,182,234,146,250,182,234,242,250,239,109,29,7,0,
			.byte 126,183,183,255,203,74,74,74,74,74,74,74,74,94,252,255,
			.byte 0,0 ; safety pair of bytes to support a stack renderer
__sprites_tiles_lv01_tile42:
			.byte 15 ; mask
			.byte 4 ; counter
			.byte 0,31,48,44,0,0,0,0,2,18,18,18,0,0,0,0,
			.byte 0,0,0,0,0,64,72,64,64,64,72,64,64,224,254,0,
			.byte 0,192,142,145,145,142,196,252,128,128,128,0,129,173,44,0,
			.byte 0,0,160,176,22,6,0,14,30,0,0,14,30,0,0,0,
			.byte 0,0,0,40,44,32,1,1,1,45,45,44,1,63,62,0,
			.byte 0,0,224,248,30,166,176,160,128,160,182,32,0,160,2,0,
			.byte 255,255,241,198,195,215,126,30,254,210,210,211,255,237,237,126,
			.byte 0,224,184,182,247,95,79,87,109,95,73,215,237,95,253,255,
			.byte 0,0 ; safety pair of bytes to support a stack renderer
__sprites_tiles_lv01_tile43:
			.byte 13 ; mask
			.byte 4 ; counter
			.byte 65,72,72,59,0,248,141,133,4,196,137,136,136,113,49,113,
			.byte 4,128,193,83,87,22,134,6,2,192,184,4,4,144,64,50,
			.byte 48,48,48,0,48,0,112,120,120,56,112,112,112,0,0,0,
			.byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
			.byte 198,207,207,252,198,127,142,134,135,199,142,143,143,254,206,246,
			.byte 249,127,126,124,168,232,120,248,252,126,171,15,13,13,137,203,
			.byte 0,0 ; safety pair of bytes to support a stack renderer
__sprites_tiles_lv01_tile44:
			.byte 13 ; mask
			.byte 4 ; counter
			.byte 76,2,9,32,32,29,3,64,96,97,104,234,202,131,1,32,
			.byte 142,140,142,17,17,145,35,32,161,177,31,0,220,18,18,130,
			.byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
			.byte 0,0,0,14,14,14,28,30,30,14,0,12,0,12,12,12,
			.byte 211,145,176,176,240,213,126,63,31,30,23,21,62,126,254,159,
			.byte 111,115,127,241,241,113,227,225,97,113,254,99,63,243,243,99,
			.byte 0,0 ; safety pair of bytes to support a stack renderer
__sprites_tiles_lv01_tile45:
			.byte 1 ; mask
			.byte 4 ; counter
			.byte 255,128,128,0,0,0,0,0,0,0,0,0,0,0,0,0,
			.byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,128,
			.byte 0,0 ; safety pair of bytes to support a stack renderer
__sprites_tiles_lv01_tile46:
			.byte 1 ; mask
			.byte 4 ; counter
			.byte 0,0,0,0,0,0,255,0,0,0,0,0,0,0,0,0,
			.byte 0,0,0,0,0,0,0,0,0,244,1,1,1,1,1,63,
			.byte 0,0 ; safety pair of bytes to support a stack renderer
__sprites_tiles_lv01_tile47:
			.byte 9 ; mask
			.byte 4 ; counter
			.byte 0,0,0,0,0,0,0,0,0,0,16,40,0,0,0,0,
			.byte 0,64,176,8,0,0,0,0,0,0,0,0,0,0,0,0,
			.byte 255,255,127,187,85,238,68,0,0,0,0,0,0,0,0,0,
			.byte 0,0,0,0,0,0,0,0,0,0,33,117,174,223,255,255,
			.byte 0,0 ; safety pair of bytes to support a stack renderer
__sprites_tiles_lv01_tile48:
			.byte 15 ; mask
			.byte 4 ; counter
			.byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
			.byte 0,30,0,0,30,0,0,30,0,0,30,0,0,30,0,0,
			.byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
			.byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,30,
			.byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
			.byte 0,0,30,30,0,30,30,0,30,30,0,30,30,0,0,0,
			.byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
			.byte 30,63,33,33,63,33,33,63,33,33,63,33,33,63,63,33,
			.byte 0,0 ; safety pair of bytes to support a stack renderer
__sprites_tiles_lv01_tile49:
			.byte 9 ; mask
			.byte 4 ; counter
			.byte 0,63,0,3,0,0,0,0,0,0,0,0,0,0,0,0,
			.byte 1,0,1,1,0,0,0,1,0,0,0,0,249,3,192,0,
			.byte 255,192,255,124,104,127,255,255,47,63,111,239,47,47,255,112,
			.byte 2,255,254,254,255,254,254,254,255,255,255,3,6,252,63,255,
			.byte 0,0 ; safety pair of bytes to support a stack renderer
__sprites_tiles_lv01_tile50:
			.byte 15 ; mask
			.byte 4 ; counter
			.byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
			.byte 0,0,30,0,0,30,0,0,30,0,0,30,0,0,30,0,
			.byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
			.byte 30,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
			.byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
			.byte 0,0,0,30,30,0,30,30,0,30,30,0,30,30,0,0,
			.byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
			.byte 33,63,63,33,33,63,33,33,63,33,33,63,33,33,63,30,
			.byte 0,0 ; safety pair of bytes to support a stack renderer
__sprites_tiles_lv01_tile51:
			.byte 1 ; mask
			.byte 4 ; counter
			.byte 250,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
			.byte 1,1,1,1,183,0,0,0,0,0,0,0,0,0,0,0,
			.byte 0,0 ; safety pair of bytes to support a stack renderer
__sprites_tiles_lv01_tile52:
			.byte 9 ; mask
			.byte 4 ; counter
			.byte 184,64,143,16,96,64,0,138,84,84,84,80,86,64,64,136,
			.byte 0,2,2,200,152,152,24,136,72,2,2,5,13,241,0,6,
			.byte 7,63,112,224,159,176,239,117,43,43,43,43,41,63,63,112,
			.byte 14,252,244,44,108,108,228,116,180,236,28,250,2,14,254,248,
			.byte 0,0 ; safety pair of bytes to support a stack renderer
__sprites_tiles_lv01_tile53:
			.byte 15 ; mask
			.byte 4 ; counter
			.byte 0,0,0,31,10,10,10,10,10,2,0,16,2,0,0,0,
			.byte 0,0,0,64,8,0,64,80,80,80,80,80,248,0,0,0,
			.byte 0,63,96,64,64,64,64,64,64,64,76,79,76,108,63,0,
			.byte 0,252,54,50,242,50,2,2,2,2,2,2,2,6,252,0,
			.byte 0,0,0,0,21,21,21,21,21,17,16,0,1,0,0,0,
			.byte 0,0,0,128,0,8,136,168,168,168,168,168,0,0,0,0,
			.byte 127,192,191,191,234,170,234,234,234,238,239,247,182,183,192,127,
			.byte 254,3,237,109,239,247,119,87,87,87,85,87,253,253,3,254,
			.byte 0,0 ; safety pair of bytes to support a stack renderer
__sprites_tiles_lv01_tile54:
			.byte 8 ; mask
			.byte 4 ; counter
			.byte 255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,
			.byte 255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,
			.byte 0,0 ; safety pair of bytes to support a stack renderer
__sprites_tiles_lv01_tile55:
			.byte 13 ; mask
			.byte 4 ; counter
			.byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
			.byte 0,0,0,0,0,31,16,96,128,140,71,0,0,0,35,64,
			.byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
			.byte 0,0,0,0,0,0,15,15,15,67,0,0,0,0,28,0,
			.byte 255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,
			.byte 255,255,255,255,255,255,240,224,128,140,255,255,223,223,163,192,
			.byte 0,0 ; safety pair of bytes to support a stack renderer
__sprites_tiles_lv01_tile56:
			.byte 13 ; mask
			.byte 4 ; counter
			.byte 2,244,0,0,0,242,17,1,6,8,248,0,0,0,0,0,
			.byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
			.byte 0,8,0,0,0,0,194,240,240,240,0,0,0,0,0,0,
			.byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
			.byte 3,245,251,251,255,255,49,1,7,15,255,255,255,255,255,255,
			.byte 255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,
			.byte 0,0 ; safety pair of bytes to support a stack renderer
__sprites_tiles_lv01_tile57:
			.byte 8 ; mask
			.byte 4 ; counter
			.byte 255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,
			.byte 255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,
			.byte 0,0 ; safety pair of bytes to support a stack renderer
__sprites_tiles_lv01_tile58:
			.byte 13 ; mask
			.byte 4 ; counter
			.byte 32,63,8,4,7,0,8,8,8,8,12,15,0,0,0,0,
			.byte 0,0,0,0,120,136,8,12,140,4,1,252,4,60,132,4,
			.byte 31,0,6,3,0,0,7,7,7,7,3,0,0,0,0,0,
			.byte 0,0,0,0,0,112,241,241,113,121,0,0,240,0,120,120,
			.byte 160,191,137,228,231,239,248,248,248,248,252,255,255,255,255,255,
			.byte 255,255,255,255,123,139,10,12,140,4,103,254,7,255,135,5,
			.byte 0,0 ; safety pair of bytes to support a stack renderer
__sprites_tiles_lv01_tile59:
			.byte 13 ; mask
			.byte 4 ; counter
			.byte 0,0,224,32,0,0,200,36,18,16,16,16,48,6,1,0,
			.byte 64,128,0,0,0,0,0,0,0,0,0,0,0,0,2,4,
			.byte 0,0,0,0,0,0,0,192,224,224,96,39,7,1,0,0,
			.byte 0,0,128,128,128,0,0,0,0,0,0,0,0,0,1,0,
			.byte 252,28,238,255,255,183,251,37,30,20,24,208,248,254,255,255,
			.byte 223,176,89,16,88,15,72,255,255,208,192,207,79,207,222,207,
			.byte 0,0 ; safety pair of bytes to support a stack renderer
__sprites_tiles_lv01_tile60:
			.byte 13 ; mask
			.byte 4 ; counter
			.byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,2,
			.byte 0,128,96,12,8,8,8,72,36,19,0,0,4,7,0,0,
			.byte 16,240,0,0,0,0,0,0,0,0,0,1,1,1,0,0,
			.byte 0,0,128,224,228,6,7,7,3,0,0,0,0,0,0,0,
			.byte 235,9,249,249,249,17,1,255,255,6,112,10,8,234,29,251,
			.byte 255,255,127,31,11,24,40,120,164,223,237,255,255,119,56,63,
			.byte 0,0 ; safety pair of bytes to support a stack renderer
__sprites_tiles_lv01_tile61:
			.byte 13 ; mask
			.byte 4 ; counter
			.byte 32,32,33,32,63,128,32,48,48,16,17,30,0,0,0,0,
			.byte 0,0,0,0,240,48,16,16,16,16,0,224,48,240,28,4,
			.byte 30,30,30,15,0,0,158,143,143,143,14,0,0,0,0,0,
			.byte 0,0,0,0,0,192,224,224,224,224,0,0,192,0,224,248,
			.byte 161,224,225,224,127,241,33,48,48,80,209,222,255,255,255,255,
			.byte 255,255,255,255,255,63,31,31,31,31,63,231,55,241,29,5,
			.byte 0,0 ; safety pair of bytes to support a stack renderer
__sprites_tiles_lv01_tile62:
			.byte 13 ; mask
			.byte 4 ; counter
			.byte 7,0,0,0,0,7,24,0,0,0,1,63,31,32,44,35,
			.byte 100,28,68,200,28,224,0,0,0,56,192,0,0,0,48,192,
			.byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,16,28,
			.byte 24,0,0,48,224,0,0,0,0,0,0,0,0,0,0,0,
			.byte 199,207,255,248,224,135,159,159,255,248,193,255,255,163,172,163,
			.byte 101,157,197,207,31,231,31,255,251,251,195,31,60,241,243,199,
			.byte 0,0 ; safety pair of bytes to support a stack renderer
__sprites_tiles_lv01_tile63:
			.byte 9 ; mask
			.byte 4 ; counter
			.byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
			.byte 4,4,4,0,0,0,0,0,0,0,0,0,0,0,0,0,
			.byte 129,64,224,232,246,119,59,77,15,33,0,128,192,224,224,240,
			.byte 207,207,223,203,219,203,203,107,235,203,206,231,103,103,231,230,
			.byte 0,0 ; safety pair of bytes to support a stack renderer
__sprites_tiles_lv01_tile64:
			.byte 9 ; mask
			.byte 4 ; counter
			.byte 0,0,0,0,0,0,0,16,0,16,16,16,0,16,16,16,
			.byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
			.byte 39,255,250,251,251,15,239,251,235,251,251,255,239,255,251,249,
			.byte 15,7,7,3,1,0,132,240,178,220,238,109,23,7,2,129,
			.byte 0,0 ; safety pair of bytes to support a stack renderer
__sprites_tiles_lv01_tile65:
			.byte 13 ; mask
			.byte 4 ; counter
			.byte 3,12,0,0,0,3,28,0,0,0,0,63,31,32,56,38,
			.byte 196,52,4,248,140,224,0,0,0,24,224,0,0,0,0,224,
			.byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,24,
			.byte 56,8,0,0,112,0,0,0,0,0,0,0,0,0,0,0,
			.byte 227,207,143,188,248,195,223,159,255,248,224,255,255,167,185,167,
			.byte 197,53,197,255,143,227,31,255,249,249,225,7,31,255,243,227,
			.byte 0,0 ; safety pair of bytes to support a stack renderer
__sprites_tiles_lv01_tile66:
			.byte 13 ; mask
			.byte 4 ; counter
			.byte 0,3,0,0,0,0,6,8,0,0,0,3,0,0,0,1,
			.byte 0,0,0,32,192,0,0,0,8,48,128,128,0,0,192,4,
			.byte 0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,
			.byte 0,0,0,0,0,0,0,0,0,192,0,0,0,0,0,0,
			.byte 252,247,111,60,184,96,230,79,255,240,224,227,227,252,224,193,
			.byte 4,24,121,163,201,13,29,250,250,55,135,143,63,235,207,63,
			.byte 0,0 ; safety pair of bytes to support a stack renderer
__sprites_tiles_lv01_tile67:
			.byte 15 ; mask
			.byte 4 ; counter
			.byte 0,0,0,8,24,0,0,0,0,0,0,0,0,0,0,0,
			.byte 0,0,5,0,0,0,0,0,0,0,0,0,1,17,49,177,
			.byte 0,0,0,8,24,0,0,0,0,0,0,0,0,0,0,0,
			.byte 0,0,5,0,0,0,0,0,0,0,0,0,0,0,0,0,
			.byte 0,0,0,8,24,0,0,0,0,0,0,0,0,0,0,0,
			.byte 0,0,5,0,0,0,0,0,0,0,0,0,0,0,0,0,
			.byte 228,228,252,244,236,252,254,254,127,63,223,111,55,187,140,131,
			.byte 127,255,250,255,252,248,104,104,104,76,76,76,77,93,125,253,
			.byte 0,0 ; safety pair of bytes to support a stack renderer
__sprites_tiles_lv01_tile68:
			.byte 15 ; mask
			.byte 4 ; counter
			.byte 217,153,152,144,144,0,0,0,0,0,0,8,10,144,0,0,
			.byte 0,0,0,0,0,0,32,8,0,0,0,0,0,0,0,128,
			.byte 64,0,0,0,0,0,0,0,0,0,0,8,10,144,0,0,
			.byte 0,0,0,0,0,0,32,8,0,0,0,0,0,0,0,0,
			.byte 64,0,0,0,0,0,0,0,0,0,0,8,10,144,0,0,
			.byte 0,0,0,0,0,0,32,8,0,0,0,0,0,0,0,0,
			.byte 187,187,186,178,178,34,34,34,34,34,34,34,225,47,255,254,
			.byte 65,177,221,236,118,57,92,118,59,59,59,59,59,59,59,187,
			.byte 0,0 ; safety pair of bytes to support a stack renderer
__sprites_tiles_lv01_tile69:
			.byte 13 ; mask
			.byte 4 ; counter
			.byte 32,0,0,0,1,1,12,16,0,0,0,3,4,0,0,0,
			.byte 128,0,0,0,192,0,0,0,0,112,0,0,0,0,0,0,
			.byte 0,3,0,0,0,0,3,0,0,0,0,0,0,0,0,0,
			.byte 0,0,0,0,0,0,0,0,0,128,0,0,0,0,192,0,
			.byte 252,240,211,200,193,225,108,95,95,184,176,147,197,158,24,32,
			.byte 131,7,63,199,199,7,15,255,250,119,6,29,60,254,47,63,
			.byte 0,0 ; safety pair of bytes to support a stack renderer
__sprites_tiles_lv01_tile70:
			.byte 13 ; mask
			.byte 4 ; counter
			.byte 0,0,0,3,0,0,0,0,3,12,24,32,0,0,0,0,
			.byte 0,0,0,0,0,8,48,0,0,128,0,0,192,128,128,0,
			.byte 0,0,0,0,0,0,0,0,0,3,0,0,0,0,0,0,
			.byte 0,0,0,0,0,0,192,0,0,0,0,0,0,0,0,0,
			.byte 248,248,240,243,239,244,248,255,255,236,219,255,240,224,128,207,
			.byte 231,3,7,31,251,239,63,11,251,159,127,255,223,159,159,31,
			.byte 0,0 ; safety pair of bytes to support a stack renderer
__sprites_tiles_lv01_tile71:
			.byte 15 ; mask
			.byte 4 ; counter
			.byte 0,0,0,0,0,32,0,0,1,1,33,1,1,1,1,1,
			.byte 179,177,177,177,145,153,153,144,49,51,32,32,32,0,0,0,
			.byte 0,0,0,0,0,32,0,0,0,0,32,0,0,0,0,0,
			.byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
			.byte 0,0,0,0,0,32,0,0,0,0,32,0,0,0,0,0,
			.byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
			.byte 236,228,228,228,228,196,196,196,197,229,197,229,229,229,229,229,
			.byte 255,253,253,253,245,253,253,244,117,119,100,116,244,85,93,93,
			.byte 0,0 ; safety pair of bytes to support a stack renderer
__sprites_tiles_lv01_tile72:
			.byte 15 ; mask
			.byte 4 ; counter
			.byte 0,16,16,152,24,48,184,149,17,89,25,217,153,217,217,153,
			.byte 144,128,128,144,144,144,144,16,16,0,0,0,0,0,0,0,
			.byte 0,0,0,136,8,0,128,4,0,64,0,64,0,64,64,0,
			.byte 16,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
			.byte 0,0,0,136,8,0,128,4,0,64,0,64,0,64,64,0,
			.byte 16,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
			.byte 206,222,218,82,210,122,122,211,83,59,123,187,187,187,187,187,
			.byte 171,185,169,185,187,179,179,51,51,35,35,99,99,115,243,243,
			.byte 0,0 ; safety pair of bytes to support a stack renderer
__sprites_tiles_lv01_tile73:
			.byte 13 ; mask
			.byte 4 ; counter
			.byte 0,1,1,3,0,0,1,0,7,8,48,32,0,0,0,0,
			.byte 0,0,0,0,4,8,16,192,0,0,0,0,192,0,0,0,
			.byte 0,0,0,0,0,0,0,0,0,7,8,16,0,0,0,0,
			.byte 0,0,0,0,0,16,224,0,0,0,0,0,0,0,0,0,
			.byte 248,249,249,251,255,254,249,223,223,232,247,239,248,224,224,231,
			.byte 243,1,7,11,247,203,23,255,255,31,47,247,207,15,31,31,
			.byte 0,0 ; safety pair of bytes to support a stack renderer
__sprites_tiles_lv01_tile74:
			.byte 13 ; mask
			.byte 4 ; counter
			.byte 0,0,0,0,0,4,24,32,0,12,0,0,0,0,0,0,
			.byte 0,0,0,0,0,48,64,0,16,32,0,0,0,0,0,0,
			.byte 0,0,0,0,0,3,0,0,0,3,0,0,0,0,0,0,
			.byte 0,0,0,0,0,0,128,0,0,64,128,0,0,0,0,0,
			.byte 255,254,254,255,244,228,159,184,192,236,227,252,241,240,241,252,
			.byte 63,31,31,207,47,255,95,3,19,167,15,63,255,255,127,255,
			.byte 0,0 ; safety pair of bytes to support a stack renderer
__sprites_tiles_lv01_tile75:
			.byte 15 ; mask
			.byte 4 ; counter
			.byte 0,0,3,0,1,7,0,0,0,0,0,0,0,0,0,0,
			.byte 0,0,31,28,31,0,2,0,0,0,248,255,128,255,0,0,
			.byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
			.byte 0,0,0,0,16,0,2,0,0,0,0,0,0,0,0,0,
			.byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
			.byte 0,0,0,0,16,0,2,0,0,0,0,0,0,0,0,0,
			.byte 255,255,252,255,254,248,255,255,255,253,252,252,244,228,228,228,
			.byte 95,127,127,124,111,127,116,255,255,255,0,0,127,0,255,255,
			.byte 0,0 ; safety pair of bytes to support a stack renderer
__sprites_tiles_lv01_tile76:
			.byte 15 ; mask
			.byte 4 ; counter
			.byte 0,0,192,0,255,0,0,0,0,216,0,252,15,228,0,0,
			.byte 0,0,0,128,0,0,0,0,0,0,0,192,0,15,0,0,
			.byte 0,0,0,0,0,0,0,0,0,216,0,0,0,228,0,0,
			.byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
			.byte 0,0,0,0,0,0,0,0,0,216,0,0,0,228,0,0,
			.byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
			.byte 255,255,0,255,0,0,255,255,255,38,255,254,15,3,255,194,
			.byte 115,243,247,215,127,95,95,255,255,255,7,63,255,0,255,255,
			.byte 0,0 ; safety pair of bytes to support a stack renderer
__sprites_tiles_lv01_tile77:
			.byte 13 ; mask
			.byte 4 ; counter
			.byte 0,0,0,0,0,0,0,8,0,4,12,0,0,0,0,0,
			.byte 0,0,0,0,0,0,48,0,4,0,0,0,0,0,0,0,
			.byte 0,0,0,0,0,1,6,0,0,3,0,0,0,0,0,0,
			.byte 0,0,0,0,0,0,192,0,0,24,224,0,0,0,0,0,
			.byte 255,254,255,255,254,248,225,200,208,204,255,244,243,248,248,252,
			.byte 63,143,15,143,63,199,55,3,29,225,7,31,255,255,63,255,
			.byte 0,0 ; safety pair of bytes to support a stack renderer
__sprites_tiles_lv01_tile78:
			.byte 15 ; mask
			.byte 4 ; counter
			.byte 0,0,24,0,0,0,0,0,0,0,24,0,0,0,0,0,
			.byte 0,0,0,0,0,24,0,0,0,0,0,0,0,24,0,0,
			.byte 0,0,0,0,63,0,0,0,0,0,0,0,63,0,0,24,
			.byte 24,0,0,252,0,0,0,0,0,0,0,252,0,0,0,0,
			.byte 24,24,0,63,39,24,24,24,24,24,0,63,39,24,24,24,
			.byte 24,24,24,228,252,0,24,24,24,24,24,228,252,0,24,24,
			.byte 231,231,255,192,239,231,231,231,231,231,255,192,239,0,0,24,
			.byte 24,0,0,247,3,255,231,231,231,231,231,247,3,255,231,231,