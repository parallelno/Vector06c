__RAM_DISK_S_TILED_IMAGES_GFX = RAM_DISK_S
__RAM_DISK_M_TILED_IMAGES_GFX = RAM_DISK_M
; source\sprites\art\tiled_images.png
			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_palette:
			.byte %01001010, %00000001, %01011100, %00011010, 
			.byte %11100100, %11111101, %01110111, %01011111, 
			.byte %01000010, %11101011, %01001100, %01001011, 
			.byte %11111111, %01001001, %01010010, %01011011, 

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile1:
			.byte 145,148,147,144,0,0,12,4,
			.byte 15,63,112,239,64,67,71,70,
			.byte 246,243,244,240,255,255,115,59,
			.byte 0,32,64,143,0,0,3,2,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile2:
			.byte 255,0,0,0,0,0,0,0,
			.byte 255,255,0,255,0,255,255,0,
			.byte 0,255,255,0,255,255,255,255,
			.byte 0,0,0,255,0,0,255,0,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile3:
			.byte 201,73,9,1,1,1,2,4,
			.byte 240,252,12,244,12,196,164,4,
			.byte 111,239,239,15,255,255,254,252,
			.byte 0,4,0,240,8,8,200,72,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile4:
			.byte 144,144,144,144,144,144,144,144,
			.byte 70,70,70,70,70,70,70,70,
			.byte 246,246,246,246,246,246,246,246,
			.byte 2,2,2,2,2,2,2,2,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile5:
			.byte 255,255,255,255,255,255,255,255,
			.byte 0,0,0,0,0,0,0,0,
			.byte 0,0,0,0,0,0,0,0,
			.byte 0,0,0,0,0,0,0,0,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile6:
			.byte 201,201,201,201,201,201,201,201,
			.byte 0,0,0,0,0,0,0,0,
			.byte 111,111,111,111,111,111,111,111,
			.byte 72,72,72,72,72,72,72,72,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile7:
			.byte 147,147,147,145,145,145,145,145,
			.byte 70,70,70,66,66,64,64,64,
			.byte 246,246,246,246,246,246,246,246,
			.byte 2,2,2,2,2,0,0,0,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile8:
			.byte 31,111,192,207,144,148,147,147,
			.byte 0,64,0,0,0,32,16,0,
			.byte 31,127,255,255,240,247,247,246,
			.byte 0,1,4,0,0,32,16,0,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile9:
			.byte 255,255,0,255,0,0,255,255,
			.byte 0,0,0,0,0,0,0,0,
			.byte 255,255,255,255,0,255,255,0,
			.byte 0,255,0,0,63,0,0,0,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile10:
			.byte 248,252,6,227,11,45,205,205,
			.byte 0,0,0,4,24,0,0,0,
			.byte 248,252,254,255,15,239,239,111,
			.byte 72,200,8,12,152,0,0,0,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile11:
			.byte 121,73,65,121,113,73,73,49,
			.byte 0,0,0,0,0,0,0,0,
			.byte 56,120,112,48,48,120,120,48,
			.byte 246,206,206,182,182,206,206,190,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile12:
			.byte 0,0,0,0,0,0,0,0,
			.byte 0,0,0,0,0,0,0,0,
			.byte 0,0,0,0,0,0,0,0,
			.byte 248,252,232,240,248,248,252,232,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile13:
			.byte 0,0,0,0,0,0,0,0,
			.byte 0,0,0,0,0,0,0,0,
			.byte 0,0,0,0,0,0,0,0,
			.byte 31,47,119,47,31,47,119,43,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile14:
			.byte 158,146,130,158,142,146,146,140,
			.byte 0,0,0,0,0,0,0,0,
			.byte 28,30,14,12,12,30,30,12,
			.byte 111,115,115,109,109,115,115,125,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile15:
			.byte 0,0,0,0,16,0,0,0,
			.byte 0,0,0,0,0,0,0,0,
			.byte 0,0,0,0,0,0,0,0,
			.byte 240,248,240,232,220,232,240,248,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile16:
			.byte 0,0,0,0,0,0,0,0,
			.byte 0,0,0,0,0,0,0,0,
			.byte 0,0,0,0,0,0,0,0,
			.byte 55,15,31,15,23,59,23,15,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile17:
			.byte 2,40,26,22,6,202,129,0,
			.byte 0,0,0,0,0,0,0,0,
			.byte 0,0,0,0,0,0,0,0,
			.byte 223,110,53,249,169,165,151,189,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile18:
			.byte 110,0,32,53,255,135,1,120,
			.byte 0,0,0,0,0,0,0,0,
			.byte 110,0,0,121,252,255,123,120,
			.byte 255,133,135,252,49,195,254,239,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile19:
			.byte 33,97,33,30,0,2,72,96,
			.byte 0,0,0,0,0,0,0,0,
			.byte 63,127,255,158,0,0,0,0,
			.byte 157,181,253,127,30,33,225,97,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile20:
			.byte 0,0,0,0,0,0,0,0,
			.byte 0,0,0,0,0,0,0,0,
			.byte 0,0,0,0,0,0,0,0,
			.byte 0,68,238,85,187,127,255,255,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile21:
			.byte 0,0,0,0,0,0,0,0,
			.byte 0,0,0,0,0,0,0,0,
			.byte 0,0,0,0,0,0,0,0,
			.byte 0,0,33,117,174,223,255,255,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile22:
			.byte 132,134,132,120,0,64,18,6,
			.byte 0,0,0,0,0,0,0,0,
			.byte 252,254,255,121,0,0,0,0,
			.byte 185,173,191,254,120,132,135,134,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile23:
			.byte 118,0,4,172,255,225,128,30,
			.byte 0,0,0,0,0,0,0,0,
			.byte 118,0,0,158,63,255,222,30,
			.byte 255,161,225,63,140,195,127,247,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile24:
			.byte 48,56,70,0,0,0,100,40,
			.byte 0,0,0,0,0,0,0,0,
			.byte 48,56,70,0,0,0,100,40,
			.byte 239,229,195,157,255,255,185,177,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile25:
			.byte 127,0,14,17,23,32,32,14,
			.byte 0,0,0,0,0,0,0,0,
			.byte 15,0,14,31,23,63,49,14,
			.byte 110,224,224,119,241,255,63,15,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile26:
			.byte 0,0,196,215,253,31,7,224,
			.byte 0,0,0,0,0,0,0,0,
			.byte 0,0,196,228,240,252,239,224,
			.byte 255,23,28,240,196,244,255,208,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile27:
			.byte 0,0,1,177,227,204,248,3,
			.byte 0,0,0,0,0,0,0,0,
			.byte 0,0,1,35,3,143,251,3,
			.byte 255,252,140,15,37,3,255,3,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile28:
			.byte 250,238,0,206,34,35,220,0,
			.byte 0,0,0,0,0,0,0,0,
			.byte 0,238,0,206,255,255,220,0,
			.byte 255,255,35,34,206,255,238,5,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile29:
			.byte 7,95,64,236,52,34,205,0,
			.byte 0,0,0,0,0,0,0,0,
			.byte 0,79,64,236,253,239,205,0,
			.byte 255,255,34,52,236,127,79,24,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile30:
			.byte 254,0,112,136,232,4,4,112,
			.byte 0,0,0,0,0,0,0,0,
			.byte 240,0,112,248,232,252,140,112,
			.byte 118,7,7,238,143,255,252,240,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile31:
			.byte 0,30,0,2,0,0,0,16,
			.byte 0,0,0,0,0,0,0,0,
			.byte 0,28,0,0,0,0,0,16,
			.byte 145,129,195,255,225,193,253,255,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile32:
			.byte 122,0,220,0,229,253,248,157,
			.byte 0,0,0,0,0,0,0,0,
			.byte 0,0,0,0,0,0,0,0,
			.byte 64,7,0,2,255,34,255,133,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile33:
			.byte 255,1,236,65,92,0,15,15,
			.byte 0,0,0,0,0,0,0,0,
			.byte 0,0,0,0,0,0,0,0,
			.byte 224,224,96,35,62,19,254,0,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile34:
			.byte 255,104,3,193,0,0,64,240,
			.byte 0,0,0,0,0,0,0,0,
			.byte 0,0,0,0,0,0,0,0,
			.byte 3,2,127,193,62,252,151,0,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile35:
			.byte 0,0,223,64,30,30,19,31,
			.byte 0,0,0,0,0,0,0,0,
			.byte 0,0,0,0,0,0,0,0,
			.byte 32,32,224,33,63,32,255,255,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile36:
			.byte 0,0,220,0,229,253,248,156,
			.byte 0,0,0,0,0,0,0,0,
			.byte 0,0,0,0,0,0,0,0,
			.byte 65,7,0,2,255,34,255,255,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile37:
			.byte 254,0,204,216,1,13,65,1,
			.byte 0,0,0,0,0,0,0,0,
			.byte 250,0,0,0,0,0,1,0,
			.byte 2,1,240,254,39,48,255,251,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile38:
			.byte 31,0,29,13,0,0,0,32,
			.byte 0,0,0,0,0,0,0,0,
			.byte 5,0,0,0,0,0,0,0,
			.byte 16,96,199,255,114,226,127,101,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile39:
			.byte 94,0,59,0,167,191,31,185,
			.byte 0,0,0,0,0,0,0,0,
			.byte 0,0,0,0,0,0,0,0,
			.byte 2,224,0,64,255,68,255,161,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile40:
			.byte 64,20,88,104,96,83,129,0,
			.byte 0,0,0,0,0,0,0,0,
			.byte 0,0,0,0,0,0,0,0,
			.byte 251,118,172,159,149,165,233,189,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile41:
			.byte 0,64,64,0,0,0,0,0,
			.byte 0,0,0,0,0,0,0,0,
			.byte 0,0,0,0,0,0,0,0,
			.byte 255,255,255,251,117,174,132,0,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile42:
			.byte 0,0,0,0,0,0,0,0,
			.byte 0,0,0,0,0,0,0,0,
			.byte 0,0,0,0,0,0,0,0,
			.byte 255,255,255,254,221,170,119,34,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile43:
			.byte 0,0,0,0,4,2,0,0,
			.byte 0,0,0,4,0,0,0,0,
			.byte 0,0,0,0,4,0,0,0,
			.byte 0,0,0,0,0,0,0,0,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile44:
			.byte 0,0,0,0,0,96,16,0,
			.byte 0,0,96,0,0,0,0,0,
			.byte 0,0,0,0,0,96,0,0,
			.byte 0,0,0,0,0,0,0,0,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile45:
			.byte 0,0,0,237,128,128,128,128,
			.byte 0,0,0,0,0,0,0,0,
			.byte 0,0,0,0,0,0,0,0,
			.byte 0,0,0,0,0,0,0,0,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile46:
			.byte 0,1,0,0,0,0,0,232,
			.byte 0,0,0,0,0,0,0,0,
			.byte 0,0,0,0,0,0,0,0,
			.byte 0,0,0,0,0,0,0,0,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile47:
			.byte 0,0,0,0,0,0,0,0,
			.byte 0,0,0,0,0,0,0,0,
			.byte 0,0,0,0,0,0,0,0,
			.byte 0,0,0,0,0,0,0,0,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile48:
			.byte 255,128,128,0,0,0,0,0,
			.byte 0,0,0,0,0,0,0,0,
			.byte 0,0,0,0,0,0,0,0,
			.byte 0,0,0,0,0,0,0,0,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile49:
			.byte 63,1,1,1,1,1,244,0,
			.byte 0,0,0,0,0,0,0,0,
			.byte 0,0,0,0,0,0,0,0,
			.byte 0,0,0,0,0,0,0,0,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile50:
			.byte 1,1,1,1,1,1,1,1,
			.byte 0,0,0,0,0,0,0,0,
			.byte 0,0,0,0,0,0,0,0,
			.byte 0,0,0,0,0,0,0,0,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile51:
			.byte 0,0,0,0,242,0,0,0,
			.byte 0,0,0,0,0,0,0,0,
			.byte 0,0,0,0,0,0,0,0,
			.byte 0,0,0,0,0,0,0,0,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile52:
			.byte 128,128,128,128,128,0,0,0,
			.byte 0,0,0,0,0,0,0,0,
			.byte 0,0,0,0,0,0,0,0,
			.byte 0,0,0,0,0,0,0,0,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile53:
			.byte 1,255,0,0,0,0,0,0,
			.byte 0,0,0,0,0,0,0,0,
			.byte 0,0,0,0,0,0,0,0,
			.byte 0,0,0,0,0,0,0,0,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile54:
			.byte 0,0,0,0,0,0,255,0,
			.byte 0,0,0,0,0,0,0,0,
			.byte 0,0,0,0,0,0,0,0,
			.byte 0,0,0,0,0,0,0,0,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile55:
			.byte 0,1,0,1,1,1,1,1,
			.byte 0,0,0,0,0,0,0,0,
			.byte 0,0,0,0,0,0,0,0,
			.byte 0,0,0,0,0,0,0,0,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile56:
			.byte 128,128,128,128,128,0,0,0,
			.byte 0,0,0,0,0,0,0,0,
			.byte 0,0,0,0,0,0,0,0,
			.byte 0,0,0,0,0,0,0,0,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile57:
			.byte 1,1,1,1,79,0,0,0,
			.byte 0,0,0,0,0,0,0,0,
			.byte 0,0,0,0,0,0,0,0,
			.byte 0,0,0,0,0,0,0,0,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile58:
			.byte 255,1,1,1,0,0,0,0,
			.byte 0,0,0,0,0,0,0,0,
			.byte 0,0,0,0,0,0,0,0,
			.byte 0,0,0,0,0,0,0,0,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile59:
			.byte 1,0,0,0,0,0,0,0,
			.byte 0,0,0,0,0,0,0,0,
			.byte 0,0,0,0,0,0,0,0,
			.byte 0,0,0,0,0,0,0,0,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile60:
			.byte 0,255,0,0,0,0,0,0,
			.byte 0,0,0,0,0,0,0,0,
			.byte 0,0,0,0,0,0,0,0,
			.byte 0,0,0,0,0,0,0,0,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile61:
			.byte 0,0,1,1,1,0,0,0,
			.byte 0,0,0,0,0,0,0,0,
			.byte 0,0,0,0,0,0,0,0,
			.byte 0,0,0,0,0,0,0,0,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile62:
			.byte 255,1,1,1,0,0,0,0,
			.byte 0,0,0,0,0,0,0,0,
			.byte 0,0,0,0,0,0,0,0,
			.byte 0,0,0,0,0,0,0,0,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile63:
			.byte 232,0,0,0,0,0,1,0,
			.byte 0,0,0,0,0,0,0,0,
			.byte 0,0,0,0,0,0,0,0,
			.byte 0,0,0,0,0,0,0,0,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile64:
			.byte 1,1,1,1,1,0,0,0,
			.byte 0,0,0,0,0,0,0,0,
			.byte 0,0,0,0,0,0,0,0,
			.byte 0,0,0,0,0,0,0,0,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile65:
			.byte 0,0,0,0,0,0,1,1,
			.byte 0,0,0,0,0,0,0,0,
			.byte 0,0,0,0,0,0,0,0,
			.byte 0,0,0,0,0,0,0,0,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile66:
			.byte 0,0,0,0,0,0,0,1,
			.byte 0,0,0,0,0,0,0,0,
			.byte 0,0,0,0,0,0,0,0,
			.byte 0,0,0,0,0,0,0,0,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile67:
			.byte 0,0,0,0,0,0,0,0,
			.byte 0,0,0,0,0,0,0,0,
			.byte 0,0,0,0,0,0,0,0,
			.byte 0,0,0,0,0,0,0,0,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile68:
			.byte 0,244,1,1,1,1,1,63,
			.byte 0,0,0,0,0,0,0,0,
			.byte 0,0,0,0,0,0,0,0,
			.byte 0,0,0,0,0,0,0,0,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile69:
			.byte 0,0,0,0,1,1,1,255,
			.byte 0,0,0,0,0,0,0,0,
			.byte 0,0,0,0,0,0,0,0,
			.byte 0,0,0,0,0,0,0,0,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile70:
			.byte 0,0,0,183,1,1,1,1,
			.byte 0,0,0,0,0,0,0,0,
			.byte 0,0,0,0,0,0,0,0,
			.byte 0,0,0,0,0,0,0,0,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile71:
			.byte 96,48,56,28,14,3,0,0,
			.byte 0,1,15,31,62,124,248,240,
			.byte 144,200,68,99,49,12,7,0,
			.byte 0,1,8,16,32,71,143,15,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile72:
			.byte 0,0,0,0,0,245,0,0,
			.byte 1,255,255,129,1,0,0,0,
			.byte 0,0,0,1,193,10,255,1,
			.byte 1,0,0,190,255,240,192,0,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile73:
			.byte 0,0,96,224,224,192,192,0,
			.byte 224,224,224,224,224,224,96,0,
			.byte 0,96,128,0,0,32,32,224,
			.byte 224,0,24,24,24,24,56,56,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile74:
			.byte 2,3,1,1,0,0,0,0,
			.byte 0,0,0,0,1,3,7,7,
			.byte 5,4,2,0,0,0,0,0,
			.byte 0,0,0,0,0,0,4,4,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile75:
			.byte 8,3,129,128,0,0,0,0,
			.byte 0,0,64,192,192,131,135,14,
			.byte 135,132,66,67,192,64,0,0,
			.byte 0,0,0,64,80,50,112,112,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile76:
			.byte 0,0,240,30,0,0,0,0,
			.byte 0,0,0,30,255,255,224,0,
			.byte 0,224,15,225,63,0,0,0,
			.byte 0,0,0,30,128,3,63,255,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile77:
			.byte 1,1,1,1,1,1,0,0,
			.byte 1,1,3,3,3,3,3,3,
			.byte 2,2,2,2,2,2,3,1,
			.byte 0,0,2,2,0,0,2,2,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile78:
			.byte 224,192,192,192,192,192,192,224,
			.byte 224,224,224,224,224,224,224,224,
			.byte 0,32,32,32,32,32,32,16,
			.byte 14,28,28,56,56,56,24,24,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile79:
			.byte 1,1,1,7,63,0,0,0,
			.byte 0,0,127,127,63,3,3,1,
			.byte 0,2,2,120,64,127,0,0,
			.byte 0,0,71,0,32,30,30,0,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile80:
			.byte 128,128,129,129,193,1,0,0,
			.byte 0,0,255,243,193,193,193,193,
			.byte 65,65,64,64,62,254,0,0,
			.byte 24,0,188,16,62,62,48,48,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile81:
			.byte 192,128,128,128,128,129,0,0,
			.byte 0,0,219,217,208,192,192,192,
			.byte 0,64,64,88,89,90,0,0,
			.byte 0,0,26,8,54,54,54,48,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile82:
			.byte 48,96,96,96,224,224,0,0,
			.byte 0,0,225,224,240,240,112,112,
			.byte 64,16,144,144,17,17,0,0,
			.byte 0,0,0,0,28,156,12,76,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile83:
			.byte 48,48,48,48,48,248,0,0,
			.byte 0,0,248,248,120,120,56,56,
			.byte 8,72,72,72,200,6,0,0,
			.byte 0,0,0,136,79,78,14,6,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile84:
			.byte 96,96,96,112,120,31,0,0,
			.byte 0,7,255,254,248,240,240,240,
			.byte 144,144,144,136,135,224,15,0,
			.byte 0,6,0,2,143,143,158,156,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile85:
			.byte 24,24,56,56,68,131,0,0,
			.byte 0,129,199,255,120,56,56,56,
			.byte 36,36,0,68,187,68,131,0,
			.byte 0,129,0,131,193,199,3,2,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile86:
			.byte 24,24,24,24,48,240,0,0,
			.byte 0,224,248,248,60,60,28,28,
			.byte 4,4,36,100,200,8,240,0,
			.byte 0,32,8,132,134,230,7,3,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile87:
			.byte 64,96,96,48,24,15,0,0,
			.byte 0,3,31,63,112,112,224,224,
			.byte 160,128,144,72,39,16,7,0,
			.byte 0,3,16,3,71,31,30,28,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile88:
			.byte 4,12,12,24,16,224,0,0,
			.byte 3,224,240,248,60,30,30,14,
			.byte 26,18,18,36,232,16,224,3,
			.byte 3,225,0,192,224,242,17,1,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile89:
			.byte 14,56,48,16,12,3,0,16,
			.byte 24,35,39,31,56,48,62,31,
			.byte 17,7,8,44,51,44,55,44,
			.byte 201,195,224,16,9,3,2,128,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile90:
			.byte 28,0,0,4,24,192,0,0,
			.byte 0,128,240,252,14,6,128,126,
			.byte 226,128,6,26,230,56,192,0,
			.byte 248,128,0,0,232,253,135,67,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile91:
			.byte 0,0,0,0,0,0,0,0,
			.byte 1,1,0,0,0,0,0,0,
			.byte 0,0,0,0,0,0,1,3,
			.byte 0,0,0,0,0,0,0,0,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile92:
			.byte 0,0,15,63,120,112,224,224,
			.byte 240,240,248,254,127,31,3,0,
			.byte 0,7,48,64,134,136,16,16,
			.byte 24,8,4,130,64,0,27,15,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile93:
			.byte 0,0,255,1,1,1,1,0,
			.byte 1,1,1,1,255,255,255,0,
			.byte 0,255,0,254,0,0,0,1,
			.byte 0,0,0,0,0,0,143,255,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile94:
			.byte 0,0,192,192,192,128,128,128,
			.byte 193,193,193,192,192,224,192,0,
			.byte 0,224,32,1,1,65,65,65,
			.byte 49,49,49,48,48,48,208,248,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile95:
			.byte 0,0,115,96,224,192,192,192,
			.byte 224,224,224,224,243,255,127,0,
			.byte 0,127,140,147,0,32,32,32,
			.byte 48,48,24,24,26,8,120,63,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile96:
			.byte 0,0,241,241,112,48,48,48,
			.byte 112,48,112,112,251,251,227,0,
			.byte 0,243,10,10,137,64,64,64,
			.byte 76,12,76,4,14,4,110,254,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile97:
			.byte 0,0,240,240,112,48,48,16,
			.byte 56,56,56,248,248,255,224,0,
			.byte 0,255,15,8,136,72,72,40,
			.byte 6,6,6,134,6,7,32,255,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile98:
			.byte 0,0,240,96,96,96,96,96,
			.byte 240,240,240,240,240,249,115,0,
			.byte 0,251,11,144,144,144,144,144,
			.byte 156,156,156,140,12,13,119,254,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile99:
			.byte 0,0,56,24,24,24,24,24,
			.byte 56,56,56,60,60,124,124,0,
			.byte 0,255,68,36,36,36,36,36,
			.byte 3,3,3,7,7,71,68,223,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile100:
			.byte 0,0,28,28,24,8,8,8,
			.byte 28,28,28,28,28,60,60,0,
			.byte 0,254,35,0,4,20,20,20,
			.byte 3,3,3,3,3,32,61,15,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile101:
			.byte 0,0,31,56,112,96,96,96,
			.byte 224,224,240,120,127,63,15,0,
			.byte 0,159,224,199,136,144,128,128,
			.byte 24,152,152,8,3,0,40,255,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile102:
			.byte 0,0,224,48,24,12,12,12,
			.byte 14,30,30,60,248,240,192,0,
			.byte 0,224,16,204,36,18,18,2,
			.byte 1,17,3,3,3,31,95,252,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile103:
			.byte 0,0,7,0,0,0,0,0,
			.byte 7,25,31,0,15,63,63,0,
			.byte 0,63,56,15,1,31,29,7,
			.byte 142,153,145,128,143,32,63,15,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile104:
			.byte 0,0,0,114,2,1,129,120,
			.byte 254,243,3,111,254,252,8,0,
			.byte 0,152,252,140,253,198,122,134,
			.byte 2,18,0,108,1,11,103,255,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile105:
			.byte 30,30,30,30,30,30,62,0,
			.byte 31,63,63,63,63,63,63,63,
			.byte 33,33,33,33,33,33,1,63,
			.byte 31,0,0,0,0,1,1,1,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile106:
			.byte 0,0,0,0,0,7,0,0,
			.byte 0,15,15,0,0,0,0,0,
			.byte 0,0,0,0,7,8,15,0,
			.byte 0,0,0,0,3,1,0,0,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile107:
			.byte 0,0,0,0,0,255,0,0,
			.byte 0,255,255,0,0,0,0,0,
			.byte 0,0,0,0,255,0,255,0,
			.byte 1,0,0,0,255,255,0,0,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile108:
			.byte 0,0,0,0,0,255,0,0,
			.byte 0,255,255,0,0,0,0,3,
			.byte 3,0,0,0,255,0,255,0,
			.byte 255,0,0,0,255,255,0,3,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile109:
			.byte 0,0,0,0,0,255,0,0,
			.byte 0,255,255,0,0,0,0,0,
			.byte 128,0,0,0,224,0,255,0,
			.byte 248,0,0,31,255,248,0,0,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile110:
			.byte 0,0,0,0,0,255,7,0,
			.byte 0,255,255,0,0,0,0,1,
			.byte 1,0,0,0,0,0,248,0,
			.byte 31,0,0,255,255,0,0,1,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile111:
			.byte 0,0,0,0,0,255,0,0,
			.byte 0,255,255,0,0,0,0,240,
			.byte 240,0,0,0,0,0,255,0,
			.byte 252,0,0,255,255,0,0,48,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile112:
			.byte 0,0,0,0,0,255,0,0,
			.byte 0,255,255,0,0,0,0,54,
			.byte 127,0,0,0,0,0,255,0,
			.byte 255,0,0,255,255,0,0,54,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile113:
			.byte 0,0,0,0,0,255,0,0,
			.byte 0,255,255,0,0,0,0,0,
			.byte 0,0,0,0,0,0,255,0,
			.byte 254,0,0,255,255,0,0,0,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile114:
			.byte 0,0,0,0,0,255,0,0,
			.byte 0,255,255,0,0,0,0,0,
			.byte 0,0,0,0,0,0,255,0,
			.byte 255,0,0,255,255,0,0,0,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile115:
			.byte 0,0,0,0,0,255,0,0,
			.byte 0,255,255,0,0,0,0,64,
			.byte 224,0,0,0,0,0,255,0,
			.byte 255,0,0,255,255,0,0,64,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile116:
			.byte 0,0,0,0,0,255,0,0,
			.byte 0,255,255,0,0,0,0,32,
			.byte 240,0,0,0,0,0,255,0,
			.byte 167,0,0,255,255,0,0,32,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile117:
			.byte 0,0,0,0,0,255,0,0,
			.byte 0,255,255,0,0,0,0,0,
			.byte 0,0,0,0,0,0,255,0,
			.byte 248,1,0,255,255,0,0,0,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile118:
			.byte 0,0,0,0,0,255,0,0,
			.byte 0,255,255,0,0,0,0,1,
			.byte 1,1,0,0,0,0,255,0,
			.byte 15,255,0,255,255,0,0,1,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile119:
			.byte 94,0,0,0,0,255,0,0,
			.byte 0,255,255,0,0,0,60,255,
			.byte 161,126,0,0,0,0,255,0,
			.byte 230,255,0,255,255,0,60,0,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile120:
			.byte 0,0,0,0,0,167,0,0,
			.byte 0,254,255,0,0,0,0,128,
			.byte 192,0,0,0,0,88,254,0,
			.byte 0,254,0,255,255,0,0,128,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile121:
			.byte 0,0,0,0,0,0,0,0,
			.byte 0,0,0,0,0,1,1,3,
			.byte 3,3,3,1,1,0,0,0,
			.byte 0,0,0,0,0,1,1,3,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile122:
			.byte 0,0,0,60,127,63,15,0,
			.byte 15,63,127,255,255,240,224,224,
			.byte 224,224,240,195,128,64,48,63,
			.byte 15,32,0,128,0,15,127,252,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile123:
			.byte 0,0,0,0,192,192,128,0,
			.byte 128,224,224,224,224,0,0,0,
			.byte 0,0,0,224,32,32,96,128,
			.byte 128,32,0,24,56,248,248,0,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile124:
			.byte 30,30,30,30,30,30,30,30,
			.byte 63,63,63,63,63,63,63,63,
			.byte 33,33,33,33,33,33,33,33,
			.byte 1,1,1,1,1,1,0,1,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile125:
			.byte 1,1,1,1,1,7,7,0,
			.byte 15,31,15,3,3,3,3,3,
			.byte 2,2,2,2,2,24,24,31,
			.byte 204,208,192,198,198,194,194,194,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile126:
			.byte 192,192,192,192,192,224,255,0,
			.byte 255,255,255,192,224,224,224,224,
			.byte 32,32,32,32,32,31,0,255,
			.byte 124,0,0,31,63,56,56,56,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile127:
			.byte 1,3,7,15,62,248,224,0,
			.byte 192,248,254,127,31,15,7,3,
			.byte 2,4,8,80,193,6,24,224,
			.byte 64,8,2,65,160,48,20,2,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile128:
			.byte 240,192,128,0,0,0,3,3,
			.byte 7,3,1,0,128,224,240,240,
			.byte 8,48,112,128,128,3,4,4,
			.byte 4,0,1,1,0,32,16,4,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile129:
			.byte 112,112,112,112,112,112,252,128,
			.byte 254,254,248,248,248,248,240,248,
			.byte 136,136,136,136,136,136,2,126,
			.byte 38,2,7,143,142,142,134,142,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile130:
			.byte 112,112,112,112,96,124,126,240,
			.byte 249,255,126,124,240,112,120,112,
			.byte 136,136,136,136,156,131,129,11,
			.byte 0,0,2,15,135,7,14,6,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile131:
			.byte 24,24,24,16,24,25,63,255,
			.byte 255,255,63,61,60,60,60,60,
			.byte 36,36,36,44,37,38,192,0,
			.byte 0,0,224,231,231,35,35,35,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile132:
			.byte 30,28,60,120,240,224,192,0,
			.byte 192,224,240,248,252,126,62,63,
			.byte 33,99,194,132,8,16,32,192,
			.byte 64,32,0,0,4,2,0,32,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile133:
			.byte 0,0,0,0,0,0,0,1,
			.byte 3,1,0,0,0,0,0,0,
			.byte 0,0,0,0,0,1,3,2,
			.byte 0,0,0,0,0,0,0,128,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile134:
			.byte 16,48,16,48,56,126,255,192,
			.byte 255,255,255,124,56,56,56,56,
			.byte 40,72,104,76,68,129,0,63,
			.byte 0,0,129,199,3,7,7,6,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile135:
			.byte 0,0,0,0,3,7,158,240,
			.byte 254,255,31,7,1,0,0,0,
			.byte 0,0,1,3,4,216,97,14,
			.byte 2,0,48,252,244,0,0,0,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile136:
			.byte 28,60,120,240,224,192,0,0,
			.byte 0,128,224,240,248,252,126,62,
			.byte 34,66,132,12,16,32,128,0,
			.byte 0,128,32,0,0,0,131,65,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile137:
			.byte 16,24,8,12,12,4,0,0,
			.byte 3,15,15,31,30,60,60,56,
			.byte 108,100,116,50,51,43,15,7,
			.byte 0,8,8,17,3,35,39,35,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile138:
			.byte 0,0,0,0,0,0,1,7,
			.byte 255,255,128,0,0,0,0,0,
			.byte 0,0,0,0,0,128,254,248,
			.byte 0,62,255,255,224,192,128,0,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile139:
			.byte 2,4,4,8,24,96,192,128,
			.byte 224,240,248,124,30,14,15,7,
			.byte 5,11,27,55,100,152,56,96,
			.byte 32,16,136,198,2,0,9,5,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile140:
			.byte 96,66,68,64,32,31,0,0,
			.byte 0,14,63,113,110,238,230,113,
			.byte 151,189,187,175,95,96,31,0,
			.byte 0,14,32,64,26,40,0,25,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile141:
			.byte 128,128,128,128,128,0,0,0,
			.byte 3,3,195,195,195,195,195,195,
			.byte 67,67,67,67,67,195,131,3,
			.byte 3,3,67,35,51,115,115,115,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile142:
			.byte 0,0,0,0,0,0,0,0,
			.byte 224,224,224,224,224,224,224,224,
			.byte 224,224,224,224,224,224,224,224,
			.byte 248,248,248,248,248,248,248,248,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile143:
			.byte 6,14,14,30,14,30,30,30,
			.byte 63,63,63,127,127,127,127,127,
			.byte 121,113,113,97,113,33,33,33,
			.byte 0,1,1,65,65,65,65,65,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile144:
			.byte 1,1,1,1,1,1,1,1,
			.byte 3,3,3,3,3,3,3,3,
			.byte 2,2,2,2,2,2,2,2,
			.byte 194,194,194,194,194,194,194,194,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile145:
			.byte 192,192,192,192,192,192,192,192,
			.byte 192,192,192,192,192,192,192,192,
			.byte 0,0,0,0,0,0,0,0,
			.byte 56,56,48,48,48,48,48,48,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile146:
			.byte 28,28,28,28,60,56,120,112,
			.byte 248,252,124,60,60,60,60,60,
			.byte 32,32,32,32,64,68,132,136,
			.byte 4,134,66,3,35,35,35,35,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile147:
			.byte 112,112,112,112,112,112,112,112,
			.byte 240,240,248,240,248,248,248,248,
			.byte 136,136,136,136,136,136,136,136,
			.byte 134,134,142,134,142,142,142,142,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile148:
			.byte 112,112,112,112,112,112,112,112,
			.byte 120,120,120,120,120,120,248,248,
			.byte 136,136,136,136,136,136,136,136,
			.byte 14,14,14,14,14,14,142,142,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile149:
			.byte 24,8,24,24,24,24,24,24,
			.byte 60,60,60,60,60,60,60,60,
			.byte 36,52,36,36,36,36,36,36,
			.byte 35,35,35,35,35,35,35,39,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile150:
			.byte 0,0,0,1,1,3,7,15,
			.byte 31,15,7,7,3,1,0,0,
			.byte 0,0,3,2,6,12,8,16,
			.byte 16,0,0,4,2,1,0,0,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile151:
			.byte 60,120,240,224,224,192,128,0,
			.byte 128,192,224,240,240,248,252,126,
			.byte 194,132,8,24,16,32,64,128,
			.byte 64,64,32,16,0,4,2,2,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile152:
			.byte 24,16,16,16,16,16,16,16,
			.byte 56,56,56,56,56,56,56,56,
			.byte 32,40,40,40,40,40,40,40,
			.byte 6,6,6,6,6,6,6,6,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile153:
			.byte 14,6,14,6,15,14,14,30,
			.byte 31,31,31,31,31,31,31,31,
			.byte 17,25,17,25,16,17,17,33,
			.byte 1,0,16,16,16,16,16,1,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile154:
			.byte 0,0,0,0,127,18,0,0,
			.byte 0,0,63,127,127,0,0,0,
			.byte 0,0,0,127,0,45,0,0,
			.byte 0,0,0,0,127,31,31,0,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile155:
			.byte 0,0,0,0,0,0,0,2,
			.byte 3,3,243,248,128,0,0,0,
			.byte 0,0,0,224,248,251,11,5,
			.byte 1,0,18,10,158,254,248,0,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile156:
			.byte 0,0,0,0,0,0,0,25,
			.byte 127,30,128,0,0,0,0,0,
			.byte 0,0,0,0,0,128,191,230,
			.byte 64,64,255,239,224,0,0,0,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile157:
			.byte 0,0,0,0,0,0,0,128,
			.byte 131,3,3,3,3,3,3,3,
			.byte 3,3,3,3,3,3,3,67,
			.byte 51,242,243,194,3,2,2,2,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile158:
			.byte 0,0,0,0,0,0,0,0,
			.byte 224,224,224,224,224,224,224,224,
			.byte 224,224,224,224,224,224,224,224,
			.byte 248,248,216,248,248,248,216,248,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile159:
			.byte 0,0,0,0,0,0,0,0,
			.byte 0,0,0,0,0,0,1,1,
			.byte 7,3,1,0,0,0,0,0,
			.byte 0,0,0,0,0,0,1,1,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile160:
			.byte 0,0,0,0,0,0,4,0,
			.byte 126,126,126,254,252,252,248,240,
			.byte 248,252,252,254,254,126,123,127,
			.byte 64,64,3,131,129,135,3,7,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile161:
			.byte 0,7,3,1,1,1,1,1,
			.byte 3,3,3,3,3,7,15,15,
			.byte 31,24,12,14,2,2,2,2,
			.byte 194,194,194,194,130,128,128,0,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile162:
			.byte 176,225,128,128,0,128,0,192,
			.byte 192,192,192,192,192,193,255,255,
			.byte 79,30,99,64,192,64,192,0,
			.byte 48,48,48,48,48,17,0,3,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile163:
			.byte 0,128,32,0,0,0,0,0,
			.byte 0,0,3,7,31,255,252,128,
			.byte 240,126,223,63,15,3,0,0,
			.byte 0,0,3,4,16,129,13,143,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile164:
			.byte 0,0,0,0,128,96,16,24,
			.byte 124,248,248,240,192,128,0,0,
			.byte 0,0,128,224,112,152,236,100,
			.byte 71,131,15,31,94,252,248,224,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile165:
			.byte 3,7,15,28,56,56,48,112,
			.byte 120,120,124,124,63,31,15,7,
			.byte 4,24,48,35,68,68,200,136,
			.byte 6,6,6,66,1,0,0,8,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile166:
			.byte 248,254,15,3,1,0,0,0,
			.byte 0,0,1,3,7,255,255,255,
			.byte 7,1,240,140,6,1,1,0,
			.byte 0,0,0,2,4,96,0,3,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile167:
			.byte 0,0,0,192,192,224,224,112,
			.byte 240,240,240,224,192,192,128,0,
			.byte 0,192,192,0,32,16,16,136,
			.byte 6,14,30,28,60,120,176,240,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile168:
			.byte 56,62,24,24,8,8,24,8,
			.byte 60,60,60,60,60,63,127,127,
			.byte 71,65,39,38,52,52,36,52,
			.byte 35,39,35,39,37,35,64,0,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile169:
			.byte 0,0,0,0,0,0,0,0,
			.byte 0,0,0,0,0,0,0,0,
			.byte 0,0,0,0,0,0,0,0,
			.byte 0,0,0,0,0,0,128,192,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile170:
			.byte 0,0,0,1,3,7,15,30,
			.byte 63,31,15,7,3,1,0,0,
			.byte 0,0,3,6,4,8,48,33,
			.byte 1,0,8,12,2,1,1,0,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile171:
			.byte 28,88,216,152,152,152,24,24,
			.byte 56,184,184,252,252,252,252,127,
			.byte 99,164,36,100,100,96,160,32,
			.byte 6,134,6,102,38,39,131,195,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile172:
			.byte 8,3,0,0,0,0,0,0,
			.byte 0,0,0,0,1,7,31,255,
			.byte 247,60,7,1,0,0,0,0,
			.byte 0,0,0,0,0,4,16,195,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile173:
			.byte 0,0,192,96,48,56,28,12,
			.byte 62,62,124,248,240,224,192,0,
			.byte 128,192,48,152,204,70,34,51,
			.byte 32,3,65,131,7,47,126,124,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile174:
			.byte 188,192,128,0,0,0,0,0,
			.byte 0,0,0,0,128,193,255,255,
			.byte 67,63,65,128,0,0,0,0,
			.byte 0,0,0,0,128,65,8,0,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile175:
			.byte 0,0,0,0,0,0,0,0,
			.byte 0,0,0,24,112,240,224,192,
			.byte 224,240,248,248,56,0,0,0,
			.byte 0,0,0,24,64,150,46,222,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile176:
			.byte 0,7,1,3,3,0,0,0,
			.byte 3,3,3,7,7,15,15,31,
			.byte 31,24,14,12,4,3,3,3,
			.byte 2,0,0,4,0,8,0,0,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile177:
			.byte 208,224,192,128,128,0,0,0,
			.byte 224,224,224,224,224,224,240,252,
			.byte 44,24,48,96,96,224,224,224,
			.byte 248,120,248,120,56,8,0,4,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile178:
			.byte 0,0,0,0,0,0,0,0,
			.byte 0,192,224,56,127,31,15,7,
			.byte 7,15,63,127,255,248,192,0,
			.byte 0,192,224,56,127,31,30,15,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile179:
			.byte 0,0,0,0,0,0,0,0,
			.byte 3,7,31,63,255,254,252,224,
			.byte 248,254,255,255,255,63,31,15,
			.byte 2,4,24,48,193,128,13,231,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile180:
			.byte 0,0,0,0,0,0,0,0,
			.byte 240,224,224,192,128,0,0,0,
			.byte 0,0,0,128,192,224,224,240,
			.byte 31,62,60,120,248,240,224,192,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile181:
			.byte 0,0,0,0,0,0,0,0,
			.byte 0,0,0,0,0,0,1,3,
			.byte 3,1,0,0,0,0,0,0,
			.byte 7,7,0,0,0,0,1,0,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile182:
			.byte 0,0,0,0,0,0,0,0,
			.byte 0,0,0,0,0,0,255,255,
			.byte 255,255,0,0,0,0,0,0,
			.byte 255,255,0,0,0,0,40,2,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile183:
			.byte 0,0,0,0,0,0,0,0,
			.byte 0,0,0,0,0,0,255,255,
			.byte 255,255,0,0,0,0,0,0,
			.byte 255,252,0,0,0,0,0,254,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile184:
			.byte 0,0,0,0,0,0,0,0,
			.byte 0,0,0,0,0,0,255,255,
			.byte 255,255,0,0,0,0,0,0,
			.byte 128,0,0,0,0,0,0,171,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile185:
			.byte 0,0,0,0,0,0,0,0,
			.byte 1,0,0,0,0,0,255,255,
			.byte 255,255,0,0,0,0,0,3,
			.byte 5,1,0,0,0,0,0,255,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile186:
			.byte 0,0,0,0,0,0,0,0,
			.byte 0,0,0,0,0,0,255,255,
			.byte 255,255,0,0,0,0,0,0,
			.byte 255,255,0,0,0,0,0,255,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile187:
			.byte 0,0,0,0,0,0,0,0,
			.byte 0,0,0,0,0,0,255,255,
			.byte 255,255,0,0,0,0,0,0,
			.byte 0,0,0,0,0,0,0,255,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile188:
			.byte 0,0,0,0,0,0,0,0,
			.byte 0,0,0,0,0,0,255,255,
			.byte 255,255,0,0,0,0,0,0,
			.byte 192,192,0,0,0,0,0,255,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile189:
			.byte 0,94,0,0,0,0,0,0,
			.byte 0,0,0,1,3,7,255,255,
			.byte 255,161,7,3,1,0,0,0,
			.byte 0,0,0,1,2,4,0,255,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile190:
			.byte 0,0,64,0,16,0,0,0,
			.byte 60,124,248,248,248,240,224,128,
			.byte 128,224,176,248,232,248,124,60,
			.byte 35,71,135,15,14,30,62,252,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile191:
			.byte 0,0,0,0,0,15,63,252,
			.byte 255,127,63,15,0,0,0,0,
			.byte 0,0,0,0,15,48,64,3,
			.byte 1,128,32,28,15,3,0,0,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile192:
			.byte 0,0,0,0,0,128,0,0,
			.byte 4,200,240,224,0,0,0,0,
			.byte 0,0,0,0,224,112,248,12,
			.byte 4,72,19,62,252,248,0,0,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile193:
			.byte 0,0,0,0,0,0,0,0,
			.byte 0,0,0,0,0,0,0,0,
			.byte 0,0,0,0,0,0,0,0,
			.byte 3,1,0,0,0,0,0,0,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile194:
			.byte 0,0,0,0,0,0,0,0,
			.byte 0,0,0,0,0,0,0,0,
			.byte 0,0,0,0,0,0,0,0,
			.byte 255,254,0,0,0,0,0,0,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile195:
			.byte 0,0,0,0,0,1,0,0,
			.byte 3,3,3,1,0,0,0,0,
			.byte 0,0,0,0,1,2,3,3,
			.byte 130,0,2,0,0,0,0,0,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile196:
			.byte 0,0,0,0,250,253,4,2,
			.byte 255,255,255,255,254,0,0,0,
			.byte 0,0,0,254,5,2,251,253,
			.byte 112,0,0,1,3,127,63,0,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile197:
			.byte 0,0,0,0,0,0,128,0,
			.byte 224,192,128,0,0,0,0,0,
			.byte 0,0,0,0,0,128,64,224,
			.byte 63,127,248,240,224,192,128,0,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile198:
			.byte 0,0,0,0,0,0,0,0,
			.byte 0,0,0,0,0,0,0,0,
			.byte 0,0,0,0,0,0,0,0,
			.byte 255,255,0,0,0,0,0,0,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile199:
			.byte 0,0,0,0,0,0,0,0,
			.byte 0,0,0,0,0,0,0,0,
			.byte 0,0,0,0,0,0,0,0,
			.byte 248,224,0,0,0,0,0,0,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile200:
			.byte 0,0,0,0,0,0,0,0,
			.byte 0,0,0,0,0,0,0,0,
			.byte 0,0,0,0,0,0,0,0,
			.byte 255,255,255,255,255,255,255,255,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile201:
			.byte 64,64,112,128,64,4,23,8,
			.byte 15,127,78,76,248,248,208,192,
			.byte 240,216,248,252,78,110,127,15,
			.byte 248,151,132,208,128,113,67,67,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile202:
			.byte 128,128,160,73,0,0,255,0,
			.byte 255,255,0,0,54,127,127,127,
			.byte 127,127,95,54,0,0,255,255,
			.byte 0,255,0,255,182,79,95,127,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile203:
			.byte 148,162,128,0,0,0,255,0,
			.byte 255,255,0,0,0,0,0,0,
			.byte 8,20,34,0,0,0,255,255,
			.byte 0,255,0,255,255,93,73,99,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile204:
			.byte 0,0,0,0,0,0,255,0,
			.byte 255,255,0,0,0,0,0,0,
			.byte 0,0,0,0,0,0,255,255,
			.byte 0,255,0,255,255,255,255,255,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile205:
			.byte 219,233,125,56,0,0,255,0,
			.byte 255,255,0,0,2,60,121,122,
			.byte 1,4,2,2,0,0,255,255,
			.byte 0,255,0,255,199,188,123,95,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile206:
			.byte 148,162,0,0,0,0,255,0,
			.byte 255,255,0,0,0,0,0,0,
			.byte 8,20,34,0,0,0,255,255,
			.byte 0,255,0,255,255,221,73,99,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile207:
			.byte 0,0,0,0,0,0,255,0,
			.byte 255,255,0,0,1,2,2,1,
			.byte 1,2,2,1,0,0,255,255,
			.byte 0,255,0,255,254,252,253,252,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile208:
			.byte 0,0,0,0,0,0,255,0,
			.byte 255,255,0,0,198,9,8,200,
			.byte 200,8,9,198,0,0,255,255,
			.byte 0,255,0,255,57,48,246,55,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile209:
			.byte 0,0,0,0,0,0,255,0,
			.byte 255,255,0,0,51,74,74,75,
			.byte 75,74,74,51,0,0,255,255,
			.byte 0,255,0,255,204,132,181,180,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile210:
			.byte 0,0,0,0,0,0,255,0,
			.byte 255,255,0,0,158,80,80,152,
			.byte 152,80,80,158,0,0,255,255,
			.byte 0,255,0,255,97,33,175,39,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile211:
			.byte 0,0,0,0,0,0,255,0,
			.byte 255,255,0,0,247,132,132,199,
			.byte 199,132,132,247,0,0,255,255,
			.byte 0,255,0,255,8,8,123,56,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile212:
			.byte 0,0,0,0,0,0,255,0,
			.byte 255,255,0,0,28,160,160,28,
			.byte 28,160,160,28,0,0,255,255,
			.byte 0,255,0,255,227,67,95,195,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile213:
			.byte 0,0,0,0,2,2,252,0,
			.byte 252,254,3,2,1,1,1,1,
			.byte 1,1,1,1,3,3,254,252,
			.byte 3,253,2,252,252,252,252,252,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile214:
			.byte 0,63,96,64,64,64,64,64,
			.byte 192,192,64,64,64,96,63,15,
			.byte 63,127,224,192,192,192,192,192,
			.byte 71,95,95,95,31,0,128,192,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile215:
			.byte 0,255,0,0,8,20,34,65,
			.byte 62,28,8,0,0,0,255,255,
			.byte 255,255,0,0,0,8,28,62,
			.byte 190,221,235,247,255,0,0,0,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile216:
			.byte 0,255,0,0,0,34,20,8,
			.byte 0,0,0,0,0,0,255,255,
			.byte 255,255,0,0,0,0,34,20,
			.byte 227,201,221,255,255,0,0,0,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile217:
			.byte 0,255,0,0,0,0,0,0,
			.byte 0,0,0,0,0,0,255,255,
			.byte 255,255,0,0,0,0,0,0,
			.byte 255,255,255,255,255,0,0,0,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile218:
			.byte 0,255,0,0,62,125,254,223,
			.byte 126,126,32,0,0,0,255,255,
			.byte 255,255,0,0,0,30,1,1,
			.byte 95,126,188,193,255,0,0,0,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile219:
			.byte 0,255,0,0,0,34,148,136,
			.byte 0,0,0,0,0,0,255,255,
			.byte 255,255,0,0,0,0,34,20,
			.byte 99,73,221,255,255,0,0,0,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile220:
			.byte 0,255,0,0,0,0,0,0,
			.byte 0,0,3,0,0,0,255,255,
			.byte 255,255,0,0,0,3,0,0,
			.byte 254,255,252,252,255,0,0,0,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile221:
			.byte 0,255,0,0,0,0,0,0,
			.byte 40,41,198,0,0,0,255,255,
			.byte 255,255,0,0,0,198,41,40,
			.byte 23,214,16,57,255,0,0,0,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile222:
			.byte 0,255,0,0,0,0,0,0,
			.byte 74,74,50,0,0,0,255,255,
			.byte 255,255,0,0,0,50,74,74,
			.byte 180,181,133,205,255,0,0,0,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile223:
			.byte 0,255,0,0,0,0,0,0,
			.byte 144,80,94,0,0,0,255,255,
			.byte 255,255,0,0,0,94,80,144,
			.byte 103,47,161,161,255,0,0,0,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile224:
			.byte 0,255,0,0,0,0,0,0,
			.byte 132,132,132,0,0,0,255,255,
			.byte 255,255,0,0,0,132,132,132,
			.byte 56,123,123,123,255,0,0,0,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile225:
			.byte 0,255,0,0,0,0,0,0,
			.byte 2,2,60,0,0,0,255,255,
			.byte 255,255,0,0,0,60,2,2,
			.byte 225,253,193,195,255,0,0,0,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile226:
			.byte 16,232,0,2,1,0,0,0,
			.byte 1,4,0,61,66,6,252,240,
			.byte 240,254,22,82,63,9,5,1,
			.byte 240,240,196,128,1,1,0,8,

