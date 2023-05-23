__RAM_DISK_S_TILED_IMAGES_GFX = RAM_DISK_S
__RAM_DISK_M_TILED_IMAGES_GFX = RAM_DISK_M
; source\sprites\art\tiled_images.png
			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_palette:
			.byte %01001010, %00000001, %01011100, %00011010, 
			.byte %11100100, %11111101, %01110111, %01011111, 
			.byte %01000010, %01001011, %01001100, %11111111, 
			.byte %01001001, %11101011, %01010010, %01011011, 

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile1:
			.byte 144,144,144,144,0,0,12,4,
			.byte 11,51,112,239,64,67,71,70,
			.byte 246,247,247,240,255,255,127,63,
			.byte 4,44,64,143,0,0,3,2,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile2:
			.byte 0,0,192,0,0,0,0,0,
			.byte 255,255,0,255,0,63,255,0,
			.byte 0,255,255,0,255,255,255,255,
			.byte 0,0,0,255,0,192,255,0,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile3:
			.byte 73,73,9,1,1,1,2,4,
			.byte 240,252,12,244,12,196,164,4,
			.byte 39,167,231,15,255,255,254,252,
			.byte 0,4,0,240,8,8,200,72,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile4:
			.byte 146,146,146,144,144,144,144,144,
			.byte 70,6,70,2,2,0,0,0,
			.byte 246,246,246,246,246,246,246,246,
			.byte 2,2,2,2,2,0,0,0,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile5:
			.byte 0,0,0,0,0,0,0,0,
			.byte 0,0,0,0,0,0,0,0,
			.byte 0,0,0,0,0,0,0,0,
			.byte 0,0,0,0,0,0,0,0,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile6:
			.byte 77,73,73,73,73,73,73,73,
			.byte 0,0,0,0,0,0,0,0,
			.byte 39,39,39,39,39,39,39,39,
			.byte 72,72,72,72,72,72,72,72,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile7:
			.byte 31,111,192,207,144,148,147,146,
			.byte 0,0,0,0,0,32,16,0,
			.byte 31,127,255,255,240,243,246,246,
			.byte 0,1,4,0,0,32,16,0,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile8:
			.byte 255,255,0,255,0,0,255,0,
			.byte 0,0,0,0,0,0,0,0,
			.byte 255,255,255,192,0,255,0,0,
			.byte 0,255,0,0,63,0,0,0,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile9:
			.byte 248,252,6,227,11,45,205,77,
			.byte 0,0,0,4,24,0,0,0,
			.byte 248,252,254,127,7,231,39,39,
			.byte 72,200,8,12,152,0,0,0,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile10:
			.byte 96,48,56,28,14,3,0,0,
			.byte 0,1,12,17,34,68,200,144,
			.byte 240,248,124,127,63,15,7,0,
			.byte 255,249,251,222,188,255,191,111,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile11:
			.byte 0,0,0,0,0,245,0,0,
			.byte 1,255,10,129,1,0,0,0,
			.byte 0,0,0,1,193,255,255,1,
			.byte 255,0,245,190,255,255,255,255,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile12:
			.byte 0,0,96,224,224,192,192,0,
			.byte 224,32,32,0,0,128,96,0,
			.byte 0,96,224,224,224,224,224,224,
			.byte 255,223,223,255,255,127,191,255,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile13:
			.byte 2,3,1,1,0,0,0,0,
			.byte 0,0,0,0,0,2,4,5,
			.byte 7,7,3,1,0,0,0,0,
			.byte 255,255,255,255,255,253,255,254,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile14:
			.byte 4,1,128,128,0,0,0,0,
			.byte 0,0,64,192,64,1,130,3,
			.byte 135,131,193,193,192,64,0,0,
			.byte 255,255,191,127,254,191,125,124,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile15:
			.byte 0,128,248,15,0,0,0,0,
			.byte 0,0,0,15,112,7,112,0,
			.byte 128,240,255,255,31,0,0,0,
			.byte 255,255,255,239,79,249,159,127,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile16:
			.byte 0,0,0,0,0,0,0,0,
			.byte 0,0,0,0,128,128,0,0,
			.byte 0,0,192,128,128,0,0,0,
			.byte 255,255,255,127,127,191,255,255,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile17:
			.byte 1,1,1,1,1,1,0,0,
			.byte 1,1,2,2,2,2,2,2,
			.byte 3,3,3,3,3,3,3,1,
			.byte 254,252,255,255,253,253,255,255,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile18:
			.byte 224,192,192,192,192,192,192,224,
			.byte 0,32,32,32,32,32,32,0,
			.byte 224,224,224,224,224,224,224,240,
			.byte 239,223,223,255,255,255,223,255,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile19:
			.byte 1,1,1,7,63,0,0,0,
			.byte 0,0,127,64,56,2,2,0,
			.byte 1,3,3,127,127,127,0,0,
			.byte 255,255,199,191,167,255,255,255,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile20:
			.byte 128,128,129,129,193,1,0,0,
			.byte 0,0,254,50,64,64,65,65,
			.byte 193,193,193,193,255,255,0,0,
			.byte 255,255,189,209,191,191,190,190,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile21:
			.byte 192,128,128,128,128,129,0,0,
			.byte 0,0,90,89,80,64,64,0,
			.byte 192,192,192,216,217,219,0,0,
			.byte 255,255,191,174,183,191,191,255,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile22:
			.byte 48,96,96,96,224,224,0,0,
			.byte 0,0,1,0,144,144,16,64,
			.byte 112,112,240,240,241,241,0,0,
			.byte 255,255,238,238,127,255,239,255,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile23:
			.byte 48,48,48,48,48,248,0,0,
			.byte 0,0,0,200,72,72,8,8,
			.byte 56,120,120,120,248,254,4,0,
			.byte 255,251,249,191,255,255,191,247,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile24:
			.byte 96,96,96,112,120,31,0,0,
			.byte 0,7,224,134,136,144,144,144,
			.byte 240,240,240,248,255,255,15,0,
			.byte 255,246,31,122,255,239,255,255,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile25:
			.byte 24,24,56,56,68,131,0,0,
			.byte 0,129,68,187,64,0,32,32,
			.byte 60,60,57,124,255,199,131,0,
			.byte 255,253,187,199,251,254,219,219,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile26:
			.byte 24,24,24,24,48,240,0,0,
			.byte 0,224,8,200,36,36,4,4,
			.byte 28,28,60,124,248,248,240,0,
			.byte 255,47,255,183,159,255,255,251,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile27:
			.byte 64,96,96,48,24,15,0,0,
			.byte 0,3,16,39,64,16,128,160,
			.byte 224,224,240,120,63,31,7,0,
			.byte 255,251,255,219,247,127,127,95,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile28:
			.byte 4,12,12,24,16,224,0,0,
			.byte 3,224,16,232,36,18,18,10,
			.byte 30,30,30,60,248,240,224,3,
			.byte 255,255,239,215,251,255,253,229,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile29:
			.byte 7,28,24,8,6,1,0,8,
			.byte 4,17,18,9,20,0,3,8,
			.byte 15,31,29,30,31,23,27,30,
			.byte 237,229,249,238,237,250,253,247,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile30:
			.byte 14,0,0,2,12,224,0,0,
			.byte 0,192,24,242,5,35,64,177,
			.byte 255,247,255,255,255,252,224,0,
			.byte 255,223,227,12,6,34,72,47,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile31:
			.byte 0,0,0,0,0,0,0,0,
			.byte 1,1,0,0,0,0,0,0,
			.byte 0,0,0,0,0,0,1,3,
			.byte 252,254,255,255,255,255,255,255,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile32:
			.byte 0,0,15,63,120,112,224,224,
			.byte 16,16,136,134,64,16,3,0,
			.byte 0,7,63,127,254,248,240,240,
			.byte 255,239,119,251,255,207,251,255,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile33:
			.byte 0,0,255,1,1,1,1,0,
			.byte 1,0,0,0,254,0,255,0,
			.byte 0,255,255,255,1,1,1,1,
			.byte 254,255,255,255,1,255,143,255,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile34:
			.byte 0,0,192,192,192,128,128,128,
			.byte 65,65,65,0,0,32,192,0,
			.byte 0,224,224,193,193,193,193,193,
			.byte 191,191,191,254,254,255,223,255,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile35:
			.byte 0,0,115,96,224,192,192,192,
			.byte 32,32,32,0,147,140,127,0,
			.byte 0,127,255,243,224,224,224,224,
			.byte 255,255,223,255,126,123,248,255,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile36:
			.byte 0,0,241,241,112,48,48,48,
			.byte 64,0,64,0,10,10,227,0,
			.byte 0,243,251,251,249,112,112,112,
			.byte 255,191,255,118,255,245,110,255,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile37:
			.byte 0,0,240,240,112,48,48,16,
			.byte 40,8,8,136,8,15,224,0,
			.byte 0,255,255,248,248,120,120,56,
			.byte 215,183,183,247,247,247,32,255,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile38:
			.byte 0,0,240,96,96,96,96,96,
			.byte 144,144,144,144,144,9,115,0,
			.byte 0,251,251,240,240,240,240,240,
			.byte 255,255,255,239,111,253,119,255,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile39:
			.byte 0,0,56,24,24,24,24,24,
			.byte 32,32,32,36,36,68,124,0,
			.byte 0,255,124,60,60,60,60,60,
			.byte 219,219,219,223,223,255,68,255,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile40:
			.byte 0,0,28,28,24,8,8,8,
			.byte 20,20,20,4,0,32,60,0,
			.byte 0,254,63,28,28,28,28,28,
			.byte 235,235,235,251,255,252,61,255,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile41:
			.byte 0,0,31,56,112,96,96,96,
			.byte 128,128,144,8,71,32,15,0,
			.byte 0,159,255,255,248,240,224,224,
			.byte 127,255,255,127,59,31,104,255,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile42:
			.byte 0,0,224,48,24,12,12,12,
			.byte 2,18,18,36,200,16,192,0,
			.byte 0,224,240,252,60,30,30,14,
			.byte 253,253,239,219,51,255,95,255,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile43:
			.byte 0,0,3,0,0,0,0,0,
			.byte 3,12,15,0,7,28,31,0,
			.byte 0,31,31,31,24,31,14,3,
			.byte 255,253,232,231,231,243,255,255,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile44:
			.byte 0,0,128,57,1,0,64,60,
			.byte 195,185,129,54,198,126,132,0,
			.byte 0,204,254,255,255,227,253,255,
			.byte 61,203,156,55,185,133,179,255,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile45:
			.byte 0,0,0,0,0,128,128,0,
			.byte 0,0,0,128,0,0,0,0,
			.byte 0,0,0,0,128,128,128,0,
			.byte 255,255,255,127,255,255,255,255,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile46:
			.byte 15,15,15,15,15,31,0,0,
			.byte 0,15,0,16,16,16,16,16,
			.byte 31,31,31,31,31,31,31,0,
			.byte 255,239,255,239,239,239,239,239,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile47:
			.byte 0,0,0,0,0,0,0,0,
			.byte 0,128,128,128,128,128,128,128,
			.byte 128,128,128,128,128,128,128,0,
			.byte 255,255,127,127,127,127,255,255,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile48:
			.byte 0,0,0,0,0,7,0,0,
			.byte 0,15,8,0,0,0,0,0,
			.byte 0,0,0,0,7,15,15,0,
			.byte 255,240,247,248,255,255,255,255,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile49:
			.byte 0,0,0,0,0,255,0,0,
			.byte 0,255,0,0,0,0,0,0,
			.byte 0,0,0,0,255,255,255,0,
			.byte 255,0,255,0,255,255,255,255,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile50:
			.byte 0,0,0,0,0,255,0,0,
			.byte 0,255,0,0,0,0,0,3,
			.byte 3,0,0,0,255,255,255,0,
			.byte 255,0,255,0,255,255,255,255,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile51:
			.byte 0,0,0,0,0,255,0,0,
			.byte 0,255,0,0,0,0,0,0,
			.byte 128,0,0,0,224,255,255,0,
			.byte 255,0,255,31,255,255,255,127,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile52:
			.byte 0,0,0,0,0,255,7,0,
			.byte 0,248,0,0,0,0,0,1,
			.byte 1,0,0,0,0,255,255,0,
			.byte 255,7,255,255,255,255,255,255,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile53:
			.byte 0,0,0,0,0,255,0,0,
			.byte 0,255,0,0,0,0,0,240,
			.byte 240,0,0,0,0,255,255,0,
			.byte 255,0,255,255,255,255,255,63,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile54:
			.byte 0,0,0,0,0,255,0,0,
			.byte 0,255,0,0,0,0,0,54,
			.byte 127,0,0,0,0,255,255,0,
			.byte 255,0,255,255,255,255,255,182,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile55:
			.byte 0,0,0,0,0,255,0,0,
			.byte 0,255,0,0,0,0,0,0,
			.byte 0,0,0,0,0,255,255,0,
			.byte 255,0,255,255,255,255,255,255,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile56:
			.byte 0,0,0,0,0,255,0,0,
			.byte 0,255,0,0,0,0,0,0,
			.byte 0,0,0,0,0,255,255,0,
			.byte 255,0,255,255,255,255,255,255,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile57:
			.byte 0,0,0,0,0,255,0,0,
			.byte 0,255,0,0,0,0,0,64,
			.byte 224,0,0,0,0,255,255,0,
			.byte 255,0,255,255,255,255,255,95,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile58:
			.byte 0,0,0,0,0,255,0,0,
			.byte 0,255,0,0,0,0,0,32,
			.byte 240,0,0,0,0,255,255,0,
			.byte 255,0,255,255,255,255,255,47,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile59:
			.byte 0,0,0,0,0,255,0,0,
			.byte 0,255,0,0,0,0,0,0,
			.byte 0,0,0,0,0,255,255,0,
			.byte 255,1,255,255,255,255,255,255,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile60:
			.byte 0,0,0,0,0,255,0,0,
			.byte 0,255,0,0,0,0,0,1,
			.byte 1,1,0,0,0,255,255,0,
			.byte 255,255,255,255,255,255,254,255,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile61:
			.byte 94,0,0,0,0,255,0,0,
			.byte 0,255,0,0,0,0,60,161,
			.byte 255,126,0,0,0,255,255,0,
			.byte 255,255,255,255,255,255,189,94,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile62:
			.byte 0,0,0,0,0,167,0,0,
			.byte 0,254,88,0,0,0,0,128,
			.byte 192,0,0,0,0,255,254,0,
			.byte 255,255,167,255,255,255,255,191,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile63:
			.byte 0,0,0,0,0,0,0,0,
			.byte 0,0,0,0,0,1,1,3,
			.byte 3,3,3,1,1,0,0,0,
			.byte 255,255,255,254,254,253,253,255,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile64:
			.byte 0,0,0,60,127,63,15,0,
			.byte 15,48,64,128,195,240,224,224,
			.byte 224,224,240,255,255,127,63,63,
			.byte 207,239,191,255,60,15,127,255,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile65:
			.byte 0,0,0,0,192,192,128,0,
			.byte 128,96,32,32,224,0,0,0,
			.byte 0,0,0,224,224,224,224,128,
			.byte 255,191,223,223,63,255,255,255,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile66:
			.byte 15,15,15,15,15,15,15,15,
			.byte 16,16,16,16,16,16,16,16,
			.byte 31,31,31,31,31,31,31,31,
			.byte 239,239,239,239,239,239,239,239,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile67:
			.byte 1,1,1,1,1,7,7,0,
			.byte 143,152,136,130,130,130,130,130,
			.byte 131,131,131,131,131,159,159,159,
			.byte 236,247,231,255,255,255,255,127,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile68:
			.byte 192,192,192,192,192,224,255,0,
			.byte 255,0,31,0,32,32,32,32,
			.byte 224,224,224,224,224,255,255,255,
			.byte 124,255,224,223,255,255,255,255,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile69:
			.byte 1,3,7,15,62,248,224,0,
			.byte 192,24,6,65,16,8,4,2,
			.byte 3,7,15,95,255,254,248,224,
			.byte 95,239,251,127,175,247,255,255,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile70:
			.byte 240,192,128,0,0,0,3,3,
			.byte 4,0,1,0,128,96,48,0,
			.byte 248,240,240,128,128,3,7,7,
			.byte 255,251,253,127,127,175,223,247,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile71:
			.byte 112,112,112,112,112,112,252,128,
			.byte 126,2,136,136,136,136,128,136,
			.byte 248,248,248,248,248,248,254,254,
			.byte 167,255,119,255,255,255,247,255,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile72:
			.byte 112,112,112,112,96,124,126,240,
			.byte 9,129,2,28,128,0,8,0,
			.byte 248,248,248,248,252,255,255,251,
			.byte 244,126,126,111,247,119,127,119,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile73:
			.byte 24,24,24,16,24,25,63,255,
			.byte 0,192,38,37,44,36,36,36,
			.byte 60,60,60,60,61,63,255,255,
			.byte 255,63,249,255,247,251,251,251,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile74:
			.byte 30,28,60,120,240,224,192,0,
			.byte 192,32,16,8,132,66,34,33,
			.byte 63,127,254,252,248,240,224,192,
			.byte 127,255,239,247,127,63,156,254,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile75:
			.byte 0,0,0,0,0,0,0,1,
			.byte 2,1,0,0,0,0,0,0,
			.byte 0,0,0,0,0,5,3,3,
			.byte 253,252,250,255,255,255,255,255,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile76:
			.byte 16,48,16,48,56,126,255,192,
			.byte 63,0,129,68,8,40,8,40,
			.byte 56,120,120,124,124,255,255,255,
			.byte 192,255,255,255,179,151,183,215,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile77:
			.byte 0,0,0,0,3,7,158,240,
			.byte 14,97,24,4,1,0,0,0,
			.byte 0,0,1,3,7,223,255,254,
			.byte 243,158,55,255,252,254,255,255,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile78:
			.byte 28,60,120,240,224,192,0,0,
			.byte 0,128,32,16,8,132,66,34,
			.byte 62,126,252,252,240,224,128,0,
			.byte 255,255,255,239,243,123,191,221,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile79:
			.byte 16,24,8,12,12,4,0,0,
			.byte 3,15,11,19,18,52,36,40,
			.byte 124,124,124,62,63,47,15,7,
			.byte 248,248,220,221,207,171,191,179,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile80:
			.byte 0,0,0,0,0,0,1,7,
			.byte 248,254,128,0,0,0,0,0,
			.byte 0,0,0,0,0,128,255,255,
			.byte 7,63,255,255,255,255,255,255,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile81:
			.byte 2,4,4,8,24,96,192,128,
			.byte 96,48,152,100,22,10,11,5,
			.byte 7,15,31,63,124,248,248,224,
			.byte 191,215,239,223,202,228,253,255,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile82:
			.byte 96,66,68,64,32,31,0,0,
			.byte 0,14,32,81,46,170,164,17,
			.byte 247,255,255,239,127,127,31,0,
			.byte 255,238,191,224,90,108,66,121,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile83:
			.byte 128,128,128,128,128,0,0,0,
			.byte 3,3,195,67,67,67,67,67,
			.byte 195,195,195,195,195,195,131,3,
			.byte 255,127,127,191,191,255,255,255,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile84:
			.byte 0,0,0,0,0,0,0,0,
			.byte 224,224,224,224,224,224,224,224,
			.byte 224,224,224,224,224,224,224,224,
			.byte 255,255,255,255,255,255,255,255,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile85:
			.byte 7,7,15,7,15,15,15,15,
			.byte 16,16,16,16,56,48,56,56,
			.byte 63,63,63,63,31,31,31,31,
			.byte 239,239,239,239,231,239,231,231,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile86:
			.byte 1,1,1,1,1,1,1,1,
			.byte 130,130,130,130,130,130,130,130,
			.byte 131,131,131,131,131,131,131,131,
			.byte 255,127,255,255,255,255,255,255,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile87:
			.byte 192,192,192,192,192,192,192,192,
			.byte 0,0,0,0,0,0,0,0,
			.byte 192,192,192,192,192,192,192,192,
			.byte 255,255,255,255,255,255,255,255,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile88:
			.byte 0,0,0,0,0,0,0,0,
			.byte 0,0,0,0,0,0,0,0,
			.byte 0,0,0,0,0,0,0,1,
			.byte 254,255,255,255,255,255,255,255,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile89:
			.byte 28,28,28,28,60,56,120,112,
			.byte 136,132,68,0,32,32,32,32,
			.byte 60,60,60,60,124,124,252,248,
			.byte 119,255,251,191,255,255,255,255,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile90:
			.byte 112,112,112,112,112,112,112,112,
			.byte 128,128,136,128,136,136,136,136,
			.byte 248,248,248,248,248,248,248,248,
			.byte 247,247,255,247,255,255,255,255,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile91:
			.byte 112,112,112,112,112,112,112,112,
			.byte 8,8,8,8,8,8,136,136,
			.byte 248,248,248,248,248,248,248,248,
			.byte 127,127,127,127,127,127,255,255,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile92:
			.byte 24,8,24,24,24,24,24,24,
			.byte 36,36,36,36,36,36,52,36,
			.byte 60,60,60,60,60,60,60,60,
			.byte 251,251,251,251,251,251,235,255,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile93:
			.byte 0,0,0,1,1,3,7,15,
			.byte 16,8,4,6,2,1,0,0,
			.byte 0,0,3,3,7,15,15,31,
			.byte 255,247,243,253,255,253,255,255,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile94:
			.byte 60,120,240,224,224,192,128,0,
			.byte 128,64,32,16,16,8,132,66,
			.byte 254,252,248,248,240,224,192,128,
			.byte 127,255,255,255,231,247,123,63,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile95:
			.byte 24,16,16,16,16,16,16,16,
			.byte 40,40,40,40,40,40,40,32,
			.byte 56,56,56,56,56,56,56,56,
			.byte 215,215,215,215,215,215,215,223,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile96:
			.byte 14,6,14,6,15,14,14,30,
			.byte 1,17,17,16,25,17,25,17,
			.byte 31,31,31,31,31,31,31,63,
			.byte 223,238,254,255,246,254,246,239,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile97:
			.byte 0,0,0,0,127,18,0,0,
			.byte 0,0,45,0,127,0,0,0,
			.byte 0,0,0,127,127,63,0,0,
			.byte 255,255,210,255,255,255,255,255,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile98:
			.byte 0,0,0,0,0,0,0,2,
			.byte 1,3,243,248,128,0,0,0,
			.byte 0,0,0,224,248,251,11,7,
			.byte 251,244,22,15,159,255,255,255,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile99:
			.byte 0,0,0,0,0,0,0,25,
			.byte 102,30,128,0,0,0,0,0,
			.byte 0,0,0,0,0,128,191,255,
			.byte 89,64,255,255,255,255,255,255,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile100:
			.byte 0,0,0,0,0,0,0,128,
			.byte 3,3,3,3,3,3,3,3,
			.byte 3,3,3,3,3,3,3,195,
			.byte 191,254,255,254,255,254,254,254,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile101:
			.byte 0,0,0,0,0,0,0,0,
			.byte 224,224,224,224,224,224,224,224,
			.byte 224,224,224,224,224,224,224,224,
			.byte 255,255,223,255,255,255,223,255,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile102:
			.byte 0,0,0,0,0,2,0,3,
			.byte 60,63,61,63,127,126,126,252,
			.byte 254,254,127,127,63,63,63,63,
			.byte 227,224,226,193,193,192,67,129,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile103:
			.byte 0,7,3,1,1,1,1,1,
			.byte 130,2,2,2,2,4,8,15,
			.byte 31,31,15,15,3,131,131,131,
			.byte 255,127,127,255,243,243,231,224,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile104:
			.byte 176,225,128,128,0,128,0,192,
			.byte 0,192,64,192,64,65,30,79,
			.byte 255,255,227,192,192,192,192,192,
			.byte 255,63,191,63,191,157,225,179,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile105:
			.byte 0,128,32,0,0,0,0,0,
			.byte 0,0,3,7,31,223,124,128,
			.byte 240,254,255,63,15,3,0,0,
			.byte 255,255,255,244,208,161,141,143,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile106:
			.byte 0,0,0,0,128,96,16,24,
			.byte 100,232,152,112,192,128,0,0,
			.byte 0,0,128,224,240,248,252,124,
			.byte 223,147,111,159,95,255,255,255,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile107:
			.byte 3,7,15,28,56,56,48,112,
			.byte 8,72,68,68,35,16,8,4,
			.byte 7,31,63,63,124,124,248,248,
			.byte 119,55,191,251,221,207,231,251,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile108:
			.byte 248,254,15,3,1,0,0,0,
			.byte 0,0,1,2,4,240,1,7,
			.byte 255,255,255,143,7,1,1,0,
			.byte 255,254,254,251,119,111,254,251,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile109:
			.byte 0,0,0,192,192,224,224,112,
			.byte 128,16,16,32,0,192,128,0,
			.byte 0,192,192,192,224,240,240,248,
			.byte 119,239,255,223,255,127,191,255,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile110:
			.byte 56,62,24,24,8,8,24,8,
			.byte 52,36,52,52,36,39,65,71,
			.byte 127,127,63,62,60,60,60,60,
			.byte 235,255,235,239,253,251,254,184,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile111:
			.byte 0,0,0,1,3,7,15,30,
			.byte 33,16,8,4,2,1,0,0,
			.byte 0,0,3,7,7,15,63,63,
			.byte 223,207,255,255,251,253,255,255,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile112:
			.byte 28,88,216,152,152,152,24,24,
			.byte 32,160,32,100,100,36,164,99,
			.byte 127,252,252,252,252,248,184,56,
			.byte 223,223,159,255,191,255,219,223,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile113:
			.byte 8,3,0,0,0,0,0,0,
			.byte 0,0,0,0,1,7,28,247,
			.byte 255,63,7,1,0,0,0,0,
			.byte 255,255,255,255,254,252,211,203,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile114:
			.byte 0,0,192,96,48,56,28,12,
			.byte 50,34,68,200,144,32,192,0,
			.byte 128,192,240,248,252,126,62,63,
			.byte 236,223,249,179,103,239,127,127,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile115:
			.byte 188,192,128,0,0,0,0,0,
			.byte 0,0,0,0,128,65,63,67,
			.byte 255,255,193,128,0,0,0,0,
			.byte 255,255,255,255,255,255,200,188,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile116:
			.byte 0,0,0,0,0,0,0,0,
			.byte 0,0,0,24,112,240,224,192,
			.byte 224,240,248,248,56,0,0,0,
			.byte 255,255,255,223,71,151,47,223,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile117:
			.byte 4,3,1,3,3,0,0,0,
			.byte 3,3,3,0,4,6,12,11,
			.byte 31,15,15,7,3,3,3,3,
			.byte 254,252,252,255,255,241,251,228,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile118:
			.byte 208,224,192,128,128,0,0,0,
			.byte 224,224,224,96,96,32,16,44,
			.byte 252,248,240,224,224,224,224,224,
			.byte 255,127,255,255,191,207,231,215,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile119:
			.byte 0,0,0,0,0,0,0,0,
			.byte 0,0,96,112,28,63,15,7,
			.byte 7,31,63,127,124,96,0,0,
			.byte 255,255,255,243,156,255,239,255,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile120:
			.byte 0,0,0,0,0,0,0,0,
			.byte 0,1,3,15,31,255,255,254,
			.byte 255,255,255,255,31,15,7,3,
			.byte 252,249,242,236,24,224,192,6,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile121:
			.byte 0,0,0,0,0,0,0,0,
			.byte 248,248,240,240,224,192,0,0,
			.byte 0,128,192,224,240,240,248,252,
			.byte 131,15,31,31,63,255,127,255,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile122:
			.byte 0,0,0,0,0,0,0,0,
			.byte 0,0,0,0,0,0,0,1,
			.byte 1,0,0,0,0,0,0,0,
			.byte 255,255,255,255,255,255,255,255,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile123:
			.byte 0,0,0,0,0,0,0,0,
			.byte 0,0,0,0,0,0,0,255,
			.byte 255,0,0,0,0,0,0,0,
			.byte 255,255,255,255,255,255,255,40,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile124:
			.byte 0,0,0,0,0,0,0,0,
			.byte 0,0,0,0,0,0,0,255,
			.byte 255,0,0,0,0,0,0,0,
			.byte 255,255,255,255,255,255,255,0,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile125:
			.byte 94,0,0,0,0,0,0,0,
			.byte 0,0,0,0,1,3,7,161,
			.byte 255,7,3,1,0,0,0,0,
			.byte 255,255,255,255,255,254,252,94,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile126:
			.byte 0,64,0,16,0,0,0,0,
			.byte 28,60,124,248,232,248,176,224,
			.byte 224,240,248,248,248,124,60,28,
			.byte 227,227,199,135,31,15,95,63,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile127:
			.byte 0,0,0,0,0,15,63,252,
			.byte 3,64,48,15,0,0,0,0,
			.byte 0,0,0,0,15,63,127,255,
			.byte 253,191,239,252,255,255,255,255,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile128:
			.byte 0,0,0,0,0,128,0,0,
			.byte 4,200,112,224,0,0,0,0,
			.byte 0,0,0,0,224,240,248,12,
			.byte 247,79,159,63,255,255,255,255,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile129:
			.byte 0,0,0,0,0,0,0,0,
			.byte 240,0,0,0,0,0,0,0,
			.byte 0,0,0,0,0,0,0,252,
			.byte 243,255,255,255,255,255,255,255,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile130:
			.byte 0,0,0,0,1,0,0,0,
			.byte 0,3,3,2,1,0,0,0,
			.byte 0,0,0,1,3,3,3,0,
			.byte 255,254,252,255,254,255,255,255,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile131:
			.byte 0,0,0,250,253,4,2,0,
			.byte 3,253,251,2,5,254,0,0,
			.byte 0,0,254,255,255,255,255,3,
			.byte 252,114,4,253,251,3,255,255,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile132:
			.byte 0,0,0,0,0,128,0,0,
			.byte 255,224,64,128,0,0,0,0,
			.byte 0,0,0,0,128,192,224,255,
			.byte 2,63,255,255,255,255,255,255,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile133:
			.byte 0,0,0,0,0,0,0,0,
			.byte 255,0,0,0,0,0,0,0,
			.byte 0,0,0,0,0,0,0,255,
			.byte 255,255,255,255,255,255,255,255,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile134:
			.byte 0,0,0,0,0,0,0,0,
			.byte 255,0,0,0,0,0,0,0,
			.byte 0,0,0,0,0,0,0,255,
			.byte 255,255,255,255,255,255,255,255,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile135:
			.byte 64,64,112,128,64,4,23,8,
			.byte 15,127,78,76,248,248,208,192,
			.byte 240,216,248,252,78,110,127,15,
			.byte 248,151,132,208,128,113,67,67,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile136:
			.byte 128,128,160,73,0,0,255,0,
			.byte 255,255,0,0,54,95,127,127,
			.byte 127,127,127,54,0,0,255,255,
			.byte 0,255,0,255,182,111,95,127,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile137:
			.byte 148,162,128,0,0,0,255,0,
			.byte 255,255,0,0,0,0,0,0,
			.byte 8,20,34,0,0,0,255,255,
			.byte 0,255,0,255,255,93,73,99,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile138:
			.byte 0,0,0,0,0,0,255,0,
			.byte 255,255,0,0,0,0,0,0,
			.byte 0,0,0,0,0,0,255,255,
			.byte 0,255,0,255,255,255,255,255,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile139:
			.byte 219,233,125,56,0,0,255,0,
			.byte 255,255,0,0,2,60,121,122,
			.byte 0,4,2,2,0,0,255,255,
			.byte 0,255,0,255,199,128,18,5,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile140:
			.byte 148,162,0,0,0,0,255,0,
			.byte 255,255,0,0,0,0,0,0,
			.byte 8,20,34,0,0,0,255,255,
			.byte 0,255,0,255,255,221,73,99,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile141:
			.byte 0,0,0,0,0,0,255,0,
			.byte 255,255,0,0,1,2,2,1,
			.byte 1,2,2,1,0,0,255,255,
			.byte 0,255,0,255,254,252,253,252,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile142:
			.byte 0,0,0,0,0,0,255,0,
			.byte 255,255,0,0,198,9,8,200,
			.byte 200,8,9,198,0,0,255,255,
			.byte 0,255,0,255,57,48,246,55,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile143:
			.byte 0,0,0,0,0,0,255,0,
			.byte 255,255,0,0,51,74,74,75,
			.byte 75,74,74,51,0,0,255,255,
			.byte 0,255,0,255,204,132,181,180,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile144:
			.byte 0,0,0,0,0,0,255,0,
			.byte 255,255,0,0,158,80,80,152,
			.byte 152,80,80,158,0,0,255,255,
			.byte 0,255,0,255,97,33,175,39,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile145:
			.byte 0,0,0,0,0,0,255,0,
			.byte 255,255,0,0,0,0,0,0,
			.byte 0,0,0,0,0,0,255,255,
			.byte 0,255,0,255,255,255,255,255,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile146:
			.byte 0,0,0,0,0,0,255,0,
			.byte 255,255,0,0,0,0,0,0,
			.byte 0,0,0,0,0,0,255,255,
			.byte 0,255,0,255,255,255,255,255,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile147:
			.byte 0,0,0,0,0,0,255,0,
			.byte 255,255,0,0,247,132,132,199,
			.byte 199,132,132,247,0,0,255,255,
			.byte 0,255,0,255,8,8,123,56,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile148:
			.byte 0,0,0,0,0,0,255,0,
			.byte 255,255,0,0,28,160,160,28,
			.byte 28,160,160,28,0,0,255,255,
			.byte 0,255,0,255,227,67,95,195,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile149:
			.byte 0,0,0,0,2,2,252,0,
			.byte 252,254,3,2,1,1,1,1,
			.byte 1,1,1,1,3,3,254,252,
			.byte 3,253,2,252,252,252,252,252,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile150:
			.byte 0,63,96,64,64,64,64,64,
			.byte 192,192,64,64,64,96,63,15,
			.byte 63,127,224,192,192,192,192,192,
			.byte 71,95,95,95,31,0,128,192,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile151:
			.byte 0,255,0,0,8,20,34,65,
			.byte 62,28,8,0,0,0,255,255,
			.byte 255,255,0,0,0,8,28,62,
			.byte 190,221,235,247,255,0,0,0,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile152:
			.byte 0,255,0,0,0,34,20,8,
			.byte 0,0,0,0,0,0,255,255,
			.byte 255,255,0,0,0,0,34,20,
			.byte 227,201,221,255,255,0,0,0,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile153:
			.byte 0,255,0,0,0,0,0,0,
			.byte 0,0,0,0,0,0,255,255,
			.byte 255,255,0,0,0,0,0,0,
			.byte 255,255,255,255,255,0,0,0,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile154:
			.byte 0,255,0,0,62,125,254,223,
			.byte 126,126,32,0,0,0,255,255,
			.byte 255,255,0,0,0,2,1,0,
			.byte 1,0,156,193,255,0,0,0,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile155:
			.byte 0,255,0,0,0,34,148,136,
			.byte 0,0,0,0,0,0,255,255,
			.byte 255,255,0,0,0,0,34,20,
			.byte 99,73,221,255,255,0,0,0,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile156:
			.byte 0,255,0,0,0,0,0,0,
			.byte 0,0,3,0,0,0,255,255,
			.byte 255,255,0,0,0,3,0,0,
			.byte 254,255,252,252,255,0,0,0,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile157:
			.byte 0,255,0,0,0,0,0,0,
			.byte 40,41,198,0,0,0,255,255,
			.byte 255,255,0,0,0,198,41,40,
			.byte 23,214,16,57,255,0,0,0,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile158:
			.byte 0,255,0,0,0,0,0,0,
			.byte 74,74,50,0,0,0,255,255,
			.byte 255,255,0,0,0,50,74,74,
			.byte 180,181,133,205,255,0,0,0,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile159:
			.byte 0,255,0,0,0,0,0,0,
			.byte 144,80,94,0,0,0,255,255,
			.byte 255,255,0,0,0,94,80,144,
			.byte 103,47,161,161,255,0,0,0,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile160:
			.byte 0,255,0,0,0,0,0,0,
			.byte 0,0,0,0,0,0,255,255,
			.byte 255,255,0,0,0,0,0,0,
			.byte 255,255,255,255,255,0,0,0,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile161:
			.byte 0,255,0,0,0,0,0,0,
			.byte 0,0,0,0,0,0,255,255,
			.byte 255,255,0,0,0,0,0,0,
			.byte 255,255,255,255,255,0,0,0,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile162:
			.byte 0,255,0,0,0,0,0,0,
			.byte 132,132,132,0,0,0,255,255,
			.byte 255,255,0,0,0,132,132,132,
			.byte 56,123,123,123,255,0,0,0,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile163:
			.byte 0,255,0,0,0,0,0,0,
			.byte 2,2,60,0,0,0,255,255,
			.byte 255,255,0,0,0,60,2,2,
			.byte 225,253,193,195,255,0,0,0,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile164:
			.byte 16,232,0,2,1,0,0,0,
			.byte 1,4,0,61,66,6,252,240,
			.byte 240,254,22,82,63,9,5,1,
			.byte 240,240,196,128,1,1,0,8,

