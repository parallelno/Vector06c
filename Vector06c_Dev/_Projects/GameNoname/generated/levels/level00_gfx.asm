__RAM_DISK_S_LEVEL00_GFX = RAM_DISK_S
__RAM_DISK_M_LEVEL00_GFX = RAM_DISK_M
; source\levels\art\level00.png
			.word 0 ; safety pair of bytes for reading by POP B
__level00_palette:
			.byte %01100101, %01010010, %01011100, %01101011, 
			.byte %10100100, %01101100, %10110111, %01101111, 
			.byte %10011011, %11111101, %10101111, %01011111, 
			.byte %11111111, %11100010, %01100010, %00011111, 

			.word 0 ; safety pair of bytes for reading by POP B
__level00_tiles_addr:
			.word __level00_tile0, 0, __level00_tile1, 0, __level00_tile2, 0, __level00_tile3, 0, __level00_tile4, 0, __level00_tile5, 0, __level00_tile6, 0, __level00_tile7, 0, __level00_tile8, 0, __level00_tile9, 0, __level00_tile10, 0, __level00_tile11, 0, __level00_tile12, 0, __level00_tile13, 0, __level00_tile14, 0, __level00_tile15, 0, __level00_tile16, 0, __level00_tile17, 0, __level00_tile18, 0, __level00_tile19, 0, __level00_tile20, 0, __level00_tile21, 0, __level00_tile22, 0, __level00_tile23, 0, __level00_tile24, 0, __level00_tile25, 0, __level00_tile26, 0, __level00_tile27, 0, __level00_tile28, 0, __level00_tile29, 0, __level00_tile30, 0, __level00_tile31, 0, __level00_tile32, 0, __level00_tile33, 0, __level00_tile34, 0, __level00_tile35, 0, __level00_tile36, 0, __level00_tile37, 0, __level00_tile38, 0, __level00_tile39, 0, __level00_tile40, 0, __level00_tile41, 0, __level00_tile42, 0, __level00_tile43, 0, __level00_tile44, 

; source\levels\art\level00.png
__level00_tiles:
			.word 0 ; safety pair of bytes for reading by POP B
__level00_tile0:
			.byte 15 ; mask
			.byte 4 ; counter
			.byte 0,32,0,64,64,224,128,192,128,224,124,120,192,128,64,64,
			.byte 30,1,0,0,24,0,0,3,1,1,14,7,3,27,6,12,
			.byte 128,160,0,64,72,236,180,216,128,224,124,120,248,244,204,216,
			.byte 62,51,54,20,24,0,0,3,1,1,14,7,3,27,6,12,
			.byte 63,63,63,127,119,243,203,231,255,255,127,127,199,139,115,103,
			.byte 222,205,201,235,255,255,255,255,255,255,255,255,255,255,254,252,
			.byte 255,223,255,191,191,31,127,63,127,31,131,135,63,127,191,191,
			.byte 225,254,255,255,231,255,255,252,254,254,241,248,252,228,249,243,
			.word 0 ; safety pair of bytes for reading by POP B
__level00_tile1:
			.byte 15 ; mask
			.byte 4 ; counter
			.byte 0,1,191,255,255,217,137,4,4,24,0,0,0,0,163,12,
			.byte 48,124,2,0,0,0,2,31,31,15,45,124,248,236,96,32,
			.byte 0,1,191,255,255,217,137,4,4,24,1,3,0,1,163,204,
			.byte 63,127,143,217,113,254,206,31,31,15,45,124,249,237,99,35,
			.byte 0,1,191,255,255,255,255,255,255,255,254,252,255,254,191,12,
			.byte 48,252,114,32,140,0,50,255,255,255,253,252,248,236,96,32,
			.byte 255,254,64,0,0,38,118,251,251,231,255,255,255,255,92,243,
			.byte 207,131,253,255,255,255,253,224,224,240,210,131,7,19,159,223,
			.word 0 ; safety pair of bytes for reading by POP B
__level00_tile2:
			.byte 15 ; mask
			.byte 4 ; counter
			.byte 0,0,24,0,252,3,0,0,0,0,0,0,0,193,54,0,
			.byte 0,0,255,0,16,16,16,0,0,40,212,3,0,0,0,0,
			.byte 0,0,0,0,0,0,1,1,0,0,0,0,0,0,1,3,
			.byte 7,7,0,0,0,0,0,0,192,128,0,0,0,0,0,0,
			.byte 231,231,231,3,0,252,254,254,255,255,255,255,254,56,0,196,
			.byte 248,248,0,0,239,239,239,239,47,71,3,56,252,255,255,255,
			.byte 24,24,0,252,3,0,0,0,0,0,0,0,1,6,200,56,
			.byte 0,0,0,255,0,0,0,16,16,16,40,196,3,0,0,0,
			.word 0 ; safety pair of bytes for reading by POP B
__level00_tile3:
			.byte 15 ; mask
			.byte 4 ; counter
			.byte 192,160,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
			.byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
			.byte 223,167,207,255,255,255,255,255,255,255,255,255,255,255,255,255,
			.byte 255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,
			.byte 224,248,48,0,0,0,0,0,0,0,0,0,0,0,0,0,
			.byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
			.byte 63,95,255,255,255,255,255,255,255,255,255,255,255,255,255,255,
			.byte 255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,
			.word 0 ; safety pair of bytes for reading by POP B
__level00_tile4:
			.byte 15 ; mask
			.byte 4 ; counter
			.byte 16,39,71,95,127,112,88,88,96,80,92,121,112,96,48,48,
			.byte 14,3,7,2,224,112,64,16,56,56,122,255,127,63,32,0,
			.byte 240,230,198,222,255,244,218,218,243,216,220,249,252,248,240,240,
			.byte 14,3,7,2,224,112,64,144,56,56,122,255,127,63,32,0,
			.byte 16,38,70,94,127,123,93,93,108,87,95,127,115,103,63,63,
			.byte 254,255,255,255,255,255,255,127,255,255,255,255,127,63,32,0,
			.byte 239,216,184,160,128,143,167,167,159,175,163,134,143,159,207,207,
			.byte 241,252,248,253,31,143,191,239,199,199,133,0,128,192,223,255,
			.word 0 ; safety pair of bytes for reading by POP B
__level00_tile5:
			.byte 15 ; mask
			.byte 4 ; counter
			.byte 96,48,112,192,240,240,224,195,96,0,0,0,0,0,224,112,
			.byte 15,0,0,0,28,0,0,3,64,224,199,7,15,15,7,12,
			.byte 224,48,112,192,240,240,252,251,100,12,8,0,0,0,224,240,
			.byte 15,27,31,12,28,0,0,3,64,224,199,7,15,15,7,12,
			.byte 127,63,127,255,255,255,227,199,251,243,247,255,255,255,255,127,
			.byte 255,228,224,243,255,255,255,255,255,255,255,255,255,255,255,252,
			.byte 159,207,143,63,15,15,31,60,159,255,255,255,255,255,31,143,
			.byte 240,255,255,255,227,255,255,252,191,31,56,248,240,240,248,243,
			.word 0 ; safety pair of bytes for reading by POP B
__level00_tile6:
			.byte 15 ; mask
			.byte 4 ; counter
			.byte 32,56,80,0,48,96,80,16,0,16,0,0,16,0,12,8,
			.byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
			.byte 47,63,87,15,63,127,127,31,3,23,15,3,19,3,15,15,
			.byte 255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,
			.byte 240,248,120,112,48,96,80,48,60,56,48,60,60,124,124,248,
			.byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
			.byte 31,7,15,15,15,31,15,15,31,47,15,31,15,15,3,7,
			.byte 255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,
			.word 0 ; safety pair of bytes for reading by POP B
__level00_tile7:
			.byte 15 ; mask
			.byte 4 ; counter
			.byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
			.byte 16,12,0,8,0,0,0,112,24,0,4,0,0,12,12,4,
			.byte 254,255,251,255,255,255,255,255,255,255,255,255,255,255,255,255,
			.byte 248,220,160,248,224,232,192,240,216,224,236,252,60,156,12,4,
			.byte 1,0,4,0,0,0,0,0,0,0,0,0,0,0,0,0,
			.byte 20,44,92,12,30,22,60,120,58,30,23,3,195,110,254,244,
			.byte 255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,
			.byte 232,240,248,240,240,248,224,128,224,248,248,252,252,240,240,224,
			.word 0 ; safety pair of bytes for reading by POP B
__level00_tile8:
			.byte 15 ; mask
			.byte 4 ; counter
			.byte 0,0,0,195,195,195,195,0,0,255,248,0,0,193,54,0,
			.byte 0,0,255,0,0,0,255,0,0,195,195,195,131,0,0,0,
			.byte 0,0,56,0,0,0,0,0,0,0,0,0,0,0,1,3,
			.byte 7,7,0,0,0,0,0,0,0,0,0,0,64,28,0,0,
			.byte 0,255,0,24,24,24,24,24,195,0,0,0,0,0,192,228,
			.byte 248,248,0,0,0,0,0,195,24,24,24,24,24,0,255,0,
			.byte 255,0,199,36,36,36,36,231,60,0,7,255,255,62,8,24,
			.byte 0,0,0,255,255,255,0,60,231,36,36,36,36,227,0,255,
			.word 0 ; safety pair of bytes for reading by POP B
__level00_tile9:
			.byte 15 ; mask
			.byte 4 ; counter
			.byte 64,120,112,192,224,225,192,128,0,0,0,0,0,7,33,79,
			.byte 46,206,116,8,14,14,30,6,30,143,129,15,15,30,14,24,
			.byte 64,120,112,192,224,225,192,128,0,0,0,0,0,7,33,207,
			.byte 47,207,119,25,46,14,30,54,126,143,177,127,63,30,14,25,
			.byte 127,127,127,255,255,255,255,255,255,255,255,255,255,255,63,79,
			.byte 62,206,244,232,222,254,254,206,158,255,207,143,207,254,254,248,
			.byte 191,135,143,63,31,30,63,127,255,255,255,255,255,248,222,176,
			.byte 209,49,139,247,241,241,225,249,225,112,126,240,240,225,241,231,
			.word 0 ; safety pair of bytes for reading by POP B
__level00_tile10:
			.byte 14 ; mask
			.byte 4 ; counter
			.byte 0,0,0,0,0,0,0,0,63,127,255,255,255,127,63,0,
			.byte 0,254,255,255,255,255,255,255,0,0,0,0,0,0,0,0,
			.byte 0,231,231,231,0,127,255,255,192,128,0,0,0,128,192,127,
			.byte 254,1,0,0,0,0,0,0,255,255,255,224,247,247,247,0,
			.byte 255,24,24,24,255,128,0,0,0,0,0,0,0,0,0,128,
			.byte 1,0,0,0,0,0,0,0,0,0,0,31,8,8,8,255,
			.word 0 ; safety pair of bytes for reading by POP B
__level00_tile11:
			.byte 15 ; mask
			.byte 4 ; counter
			.byte 248,128,0,32,1,0,0,0,0,32,0,0,0,0,0,128,
			.byte 0,0,0,0,0,0,0,0,0,0,0,248,0,0,0,0,
			.byte 0,0,0,0,96,0,0,0,0,0,96,0,0,0,0,0,
			.byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
			.byte 0,64,120,24,24,123,120,57,59,31,31,102,18,2,4,120,
			.byte 255,0,24,24,24,247,231,231,247,3,231,3,3,3,0,0,
			.byte 7,63,135,199,134,132,135,134,132,192,128,128,132,132,251,7,
			.byte 0,255,0,0,0,8,24,24,8,252,24,4,252,252,255,255,
			.word 0 ; safety pair of bytes for reading by POP B
__level00_tile12:
			.byte 15 ; mask
			.byte 4 ; counter
			.byte 0,24,48,0,0,0,0,4,6,15,8,0,0,1,0,0,
			.byte 0,32,176,176,16,0,128,0,0,0,0,0,0,0,0,0,
			.byte 9,27,49,7,3,31,5,7,7,15,8,0,0,1,0,0,
			.byte 0,48,185,251,159,199,199,255,255,255,255,255,255,255,255,255,
			.byte 102,124,62,56,124,96,250,68,6,15,15,1,3,1,0,0,
			.byte 0,99,242,180,112,56,184,0,0,0,0,0,0,0,0,0,
			.byte 15,7,15,31,63,63,47,3,1,0,0,0,0,0,0,0,
			.byte 0,18,11,79,239,255,127,255,255,255,255,255,255,255,255,255,
			.word 0 ; safety pair of bytes for reading by POP B
__level00_tile13:
			.byte 15 ; mask
			.byte 4 ; counter
			.byte 32,32,0,64,64,128,192,224,113,65,98,252,248,112,11,14,
			.byte 142,249,32,0,64,192,224,224,3,15,7,3,15,30,12,29,
			.byte 160,160,128,64,64,128,204,232,119,77,98,254,254,118,143,238,
			.byte 143,248,40,24,80,192,224,224,3,15,7,3,15,30,12,29,
			.byte 63,63,63,127,127,255,243,247,121,115,127,253,249,121,11,14,
			.byte 142,254,247,231,239,255,255,255,255,255,255,255,255,254,252,253,
			.byte 223,223,255,191,191,127,63,31,142,190,157,3,7,143,244,241,
			.byte 113,6,223,255,191,63,31,31,252,240,248,252,240,225,243,226,
			.word 0 ; safety pair of bytes for reading by POP B
__level00_tile14:
			.byte 15 ; mask
			.byte 4 ; counter
			.byte 0,0,0,0,0,0,0,0,56,108,96,0,0,0,0,0,
			.byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
			.byte 0,0,0,0,0,0,0,0,56,108,96,0,0,0,0,0,
			.byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
			.byte 0,0,0,0,0,0,0,192,126,124,120,8,0,0,0,0,
			.byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
			.byte 0,0,0,0,0,0,0,0,0,16,24,8,0,0,0,0,
			.byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
			.word 0 ; safety pair of bytes for reading by POP B
__level00_tile15:
			.byte 15 ; mask
			.byte 4 ; counter
			.byte 0,0,0,0,0,0,1,1,1,0,0,6,15,6,4,0,
			.byte 189,224,64,12,14,64,120,192,192,128,0,0,0,0,0,0,
			.byte 0,0,0,0,0,0,1,15,31,7,15,7,15,7,7,0,
			.byte 253,242,228,220,254,248,248,192,240,224,0,0,0,0,0,0,
			.byte 0,0,0,0,0,0,15,1,33,120,48,62,15,14,12,3,
			.byte 191,237,91,46,14,68,120,248,200,144,0,0,0,0,0,0,
			.byte 0,0,0,0,0,0,0,14,30,7,15,1,0,1,3,0,
			.byte 64,30,188,240,240,184,128,0,48,96,0,0,0,0,0,0,
			.word 0 ; safety pair of bytes for reading by POP B
__level00_tile16:
			.byte 14 ; mask
			.byte 4 ; counter
			.byte 15,31,31,31,31,31,15,0,63,127,127,127,127,127,63,0,
			.byte 0,252,254,254,254,254,254,252,0,240,248,248,248,248,248,240,
			.byte 112,96,96,96,96,32,208,255,192,128,128,128,128,128,192,0,
			.byte 0,2,0,0,0,0,0,2,254,10,4,6,6,6,6,14,
			.byte 128,128,128,128,128,192,32,0,0,0,0,0,0,0,0,255,
			.byte 255,1,1,1,1,1,1,1,1,5,3,1,1,1,1,1,
			.word 0 ; safety pair of bytes for reading by POP B
__level00_tile17:
			.byte 15 ; mask
			.byte 4 ; counter
			.byte 224,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
			.byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,7,
			.byte 0,0,0,0,0,0,0,0,0,0,0,7,128,192,192,207,
			.byte 0,0,0,0,224,0,0,0,0,0,0,0,0,0,0,0,
			.byte 15,15,16,39,79,80,70,78,80,71,79,88,0,0,31,16,
			.byte 231,248,1,1,26,114,98,10,226,226,10,98,100,9,243,240,
			.byte 16,240,239,216,176,175,185,177,175,184,176,160,127,63,32,32,
			.byte 24,7,254,254,5,141,157,245,29,29,245,157,155,246,12,8,
			.word 0 ; safety pair of bytes for reading by POP B
__level00_tile18:
			.byte 15 ; mask
			.byte 4 ; counter
			.byte 0,0,0,0,0,0,4,0,0,0,0,0,0,0,0,0,
			.byte 0,0,0,0,0,2,6,0,0,128,66,64,0,0,0,2,
			.byte 0,0,0,0,7,24,24,7,7,0,0,0,0,0,0,0,
			.byte 0,0,0,0,2,12,0,128,192,102,32,128,0,0,0,0,
			.byte 0,0,248,224,227,224,248,255,248,252,254,3,3,3,0,255,
			.byte 194,4,2,6,4,240,248,126,190,56,24,26,24,56,0,0,
			.byte 255,255,7,31,24,7,3,0,0,3,1,0,0,0,255,0,
			.byte 61,251,5,1,1,1,1,1,1,1,133,37,231,199,255,253,
			.word 0 ; safety pair of bytes for reading by POP B
__level00_tile19:
			.byte 15 ; mask
			.byte 4 ; counter
			.byte 2,32,0,0,0,0,0,32,32,32,0,0,0,0,0,0,
			.byte 0,0,48,24,16,0,0,0,0,0,0,0,0,0,0,0,
			.byte 14,175,247,255,255,223,31,251,251,241,255,255,255,255,255,255,
			.byte 143,207,247,217,119,167,255,255,255,255,255,255,255,255,255,255,
			.byte 255,124,8,0,0,32,248,252,252,238,96,96,0,0,0,0,
			.byte 124,62,62,126,248,88,0,0,0,0,0,0,0,0,0,0,
			.byte 241,223,255,255,255,255,255,7,7,31,255,255,255,255,255,255,
			.byte 251,255,205,231,143,255,255,255,255,255,255,255,255,255,255,255,
			.word 0 ; safety pair of bytes for reading by POP B
__level00_tile20:
			.byte 15 ; mask
			.byte 4 ; counter
			.byte 12,8,76,31,63,31,7,98,0,0,1,192,32,0,121,63,
			.byte 255,193,0,0,0,6,6,6,3,197,247,255,127,108,36,249,
			.byte 224,200,200,158,159,159,151,106,48,48,113,240,168,152,249,255,
			.byte 255,225,120,80,0,198,198,198,19,221,255,255,127,36,36,0,
			.byte 0,8,72,30,31,63,47,119,79,79,15,207,55,7,127,63,
			.byte 255,223,135,175,255,63,63,63,239,231,247,255,127,36,36,0,
			.byte 243,247,179,224,192,224,248,157,255,255,254,63,223,255,134,192,
			.byte 0,62,255,255,255,249,249,249,252,58,8,0,128,147,219,6,
			.word 0 ; safety pair of bytes for reading by POP B
__level00_tile21:
			.byte 15 ; mask
			.byte 4 ; counter
			.byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
			.byte 0,0,8,0,0,0,0,0,0,0,0,0,0,0,0,0,
			.byte 255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,
			.byte 252,248,121,255,243,247,255,255,255,255,255,255,255,255,255,255,
			.byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
			.byte 3,7,142,0,12,8,0,0,0,0,0,0,0,0,0,0,
			.byte 255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,
			.byte 252,248,241,255,255,255,255,255,255,255,255,255,255,255,255,255,
			.word 0 ; safety pair of bytes for reading by POP B
__level00_tile22:
			.byte 15 ; mask
			.byte 4 ; counter
			.byte 0,0,0,0,0,0,0,0,0,0,0,0,0,1,39,3,
			.byte 0,196,130,0,0,0,0,0,0,0,0,0,0,0,0,0,
			.byte 255,255,255,255,255,255,255,255,255,255,255,249,240,93,39,3,
			.byte 48,244,227,243,255,236,207,199,255,255,255,255,255,255,255,255,
			.byte 0,0,0,0,0,0,0,0,0,0,0,6,15,163,255,39,
			.byte 202,207,158,12,0,19,48,56,0,0,0,0,0,0,0,0,
			.byte 255,255,255,255,255,255,255,255,255,255,255,255,255,254,192,0,
			.byte 48,56,125,255,255,255,255,255,255,255,255,255,255,255,255,255,
			.word 0 ; safety pair of bytes for reading by POP B
__level00_tile23:
			.byte 15 ; mask
			.byte 4 ; counter
			.byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
			.byte 0,0,0,0,0,192,96,0,0,0,0,0,0,0,0,0,
			.byte 255,255,255,255,255,255,255,255,253,254,255,255,255,255,255,255,
			.byte 255,255,255,215,187,255,251,255,159,31,255,255,255,255,255,255,
			.byte 0,0,0,0,0,0,0,0,3,1,0,0,0,0,0,0,
			.byte 0,0,0,56,124,220,228,128,96,224,0,0,0,0,0,0,
			.byte 255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,
			.byte 255,255,255,255,223,63,159,127,255,255,255,255,255,255,255,255,
			.word 0 ; safety pair of bytes for reading by POP B
__level00_tile24:
			.byte 15 ; mask
			.byte 4 ; counter
			.byte 0,0,0,0,0,0,0,0,0,4,0,1,144,0,0,0,
			.byte 0,0,0,0,0,0,0,128,32,56,8,0,0,0,24,16,
			.byte 255,255,255,255,255,255,255,255,207,197,224,225,176,0,0,0,
			.byte 0,0,0,0,0,0,0,128,224,248,248,224,222,184,248,208,
			.byte 0,0,0,0,0,0,0,0,48,62,31,31,216,160,0,0,
			.byte 0,0,0,0,0,128,192,224,48,56,8,30,32,66,30,62,
			.byte 255,255,255,255,255,255,255,255,255,251,255,254,96,32,0,0,
			.byte 0,0,0,0,0,128,128,0,192,192,240,240,254,248,224,224,
			.word 0 ; safety pair of bytes for reading by POP B
__level00_tile25:
			.byte 0 ; mask
			.byte 4 ; counter

			.word 0 ; safety pair of bytes for reading by POP B
__level00_tile26:
			.byte 14 ; mask
			.byte 4 ; counter
			.byte 31,31,31,31,31,31,31,31,0,254,254,254,254,254,254,0,
			.byte 0,124,254,254,254,254,254,0,248,248,248,248,248,248,248,248,
			.byte 127,127,127,191,191,127,63,31,1,254,254,254,254,254,255,63,
			.byte 128,124,254,254,254,254,254,0,248,252,254,254,248,250,250,250,
			.byte 159,159,159,95,95,31,31,31,0,254,254,254,254,254,254,192,
			.byte 3,125,255,255,255,255,255,1,249,249,249,249,251,249,249,249,
			.word 0 ; safety pair of bytes for reading by POP B
__level00_tile27:
			.byte 10 ; mask
			.byte 4 ; counter
			.byte 255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,
			.byte 255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,
			.byte 255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,
			.byte 255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,
			.word 0 ; safety pair of bytes for reading by POP B
__level00_tile28:
			.byte 15 ; mask
			.byte 4 ; counter
			.byte 0,29,49,226,64,128,0,0,0,0,0,0,0,0,0,0,
			.byte 0,0,0,0,0,0,0,0,0,8,2,66,103,129,0,0,
			.byte 0,29,57,234,238,143,47,255,255,231,255,255,255,255,255,255,
			.byte 255,255,255,255,255,127,255,255,255,127,59,118,103,129,0,0,
			.byte 15,63,247,247,81,240,208,0,0,24,0,0,0,0,0,0,
			.byte 0,0,0,0,0,128,0,0,0,136,198,203,255,255,248,0,
			.byte 0,2,14,29,191,127,255,255,255,255,255,255,255,255,255,255,
			.byte 255,255,255,255,255,255,255,255,255,247,253,189,152,12,0,0,
			.word 0 ; safety pair of bytes for reading by POP B
__level00_tile29:
			.byte 15 ; mask
			.byte 4 ; counter
			.byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
			.byte 0,0,0,0,0,0,0,0,0,0,0,0,1,3,0,0,
			.byte 255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,
			.byte 255,255,255,255,255,255,255,255,255,255,255,255,255,255,248,252,
			.byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
			.byte 0,0,0,0,0,0,0,0,0,0,0,0,1,3,7,2,
			.byte 255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,
			.byte 255,255,255,255,255,255,255,255,255,255,255,255,254,252,248,252,
			.word 0 ; safety pair of bytes for reading by POP B
__level00_tile30:
			.byte 14 ; mask
			.byte 4 ; counter
			.byte 31,31,31,31,31,31,31,31,31,31,31,31,31,31,31,31,
			.byte 248,248,248,248,248,248,248,248,248,248,248,248,248,248,248,248,
			.byte 127,127,127,127,127,127,127,127,127,127,127,127,127,127,127,127,
			.byte 254,254,254,254,254,254,254,254,254,254,254,254,254,254,254,254,
			.byte 159,159,159,159,159,159,159,159,159,159,159,159,159,159,159,159,
			.byte 249,249,249,249,249,249,249,249,249,249,249,249,249,249,249,249,
			.word 0 ; safety pair of bytes for reading by POP B
__level00_tile31:
			.byte 15 ; mask
			.byte 4 ; counter
			.byte 98,194,8,16,3,7,4,1,0,0,0,0,0,0,0,0,
			.byte 16,24,32,0,0,8,0,12,136,156,0,128,0,0,0,0,
			.byte 98,226,46,254,191,63,244,249,252,255,255,255,255,255,255,255,
			.byte 240,248,224,252,248,248,192,204,136,156,0,128,0,0,0,0,
			.byte 254,222,217,209,195,199,15,7,3,0,0,0,0,0,0,0,
			.byte 28,24,56,0,4,12,60,60,248,252,240,192,128,0,0,0,
			.byte 0,32,230,174,252,248,251,254,255,255,255,255,255,255,255,255,
			.byte 224,224,192,252,248,240,252,240,112,0,0,0,0,0,0,0,
			.word 0 ; safety pair of bytes for reading by POP B
__level00_tile32:
			.byte 15 ; mask
			.byte 4 ; counter
			.byte 0,0,2,3,3,0,1,3,7,68,2,32,16,0,64,32,
			.byte 0,0,0,0,0,0,128,128,0,0,4,67,98,112,16,0,
			.byte 0,0,2,3,3,0,1,3,7,124,62,63,31,127,121,51,
			.byte 255,255,255,255,127,127,255,191,255,255,127,123,122,120,16,0,
			.byte 0,0,2,3,7,7,15,31,63,71,67,96,240,128,70,108,
			.byte 0,0,0,0,128,128,128,192,0,0,132,199,231,241,16,0,
			.byte 0,0,0,0,0,1,0,0,0,59,61,31,15,127,63,31,
			.byte 255,255,255,255,255,255,127,127,255,255,251,184,24,8,0,0,
			.word 0 ; safety pair of bytes for reading by POP B
__level00_tile33:
			.byte 15 ; mask
			.byte 4 ; counter
			.byte 0,0,1,24,0,0,0,0,0,0,0,0,0,0,0,0,
			.byte 0,0,0,0,0,0,0,0,0,0,0,0,0,2,8,0,
			.byte 0,0,1,24,24,0,0,0,0,0,1,0,0,0,0,0,
			.byte 0,0,224,16,48,192,0,0,0,0,0,0,0,34,8,0,
			.byte 0,1,7,56,28,0,1,1,0,0,1,2,1,0,0,0,
			.byte 0,0,224,240,240,208,16,16,16,144,208,240,240,86,12,112,
			.byte 0,0,6,32,28,1,2,2,2,7,13,9,8,6,1,0,
			.byte 0,224,240,24,60,239,200,8,8,8,8,8,8,172,240,0,
			.word 0 ; safety pair of bytes for reading by POP B
__level00_tile34:
			.byte 8 ; mask
			.byte 4 ; counter
			.byte 0,0,0,0,0,0,0,0,0,255,0,0,0,0,0,0,
			.byte 0,0,0,0,0,0,255,0,0,0,0,0,0,0,0,0,
			.word 0 ; safety pair of bytes for reading by POP B
__level00_tile35:
			.byte 15 ; mask
			.byte 4 ; counter
			.byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
			.byte 0,0,0,0,0,0,0,0,0,0,0,0,0,192,0,0,
			.byte 0,0,0,0,0,0,0,0,0,0,0,3,5,3,0,0,
			.byte 0,0,128,64,128,0,0,0,0,0,0,0,0,192,0,0,
			.byte 6,17,54,7,5,4,6,6,12,0,3,7,14,3,0,0,
			.byte 0,0,128,192,192,128,64,64,64,64,128,128,0,192,128,0,
			.byte 0,14,25,8,8,8,8,8,16,24,220,51,21,11,3,0,
			.byte 0,192,160,96,160,32,32,32,32,0,64,64,128,0,0,0,
			.word 0 ; safety pair of bytes for reading by POP B
__level00_tile36:
			.byte 15 ; mask
			.byte 4 ; counter
			.byte 0,0,0,8,24,0,0,0,0,0,1,0,0,0,0,0,
			.byte 0,0,0,0,0,128,0,0,0,0,0,96,0,0,0,0,
			.byte 255,62,183,158,255,243,255,241,254,254,255,254,255,255,255,255,
			.byte 255,127,79,255,239,239,127,127,111,63,255,127,220,211,255,255,
			.byte 0,241,127,111,120,124,48,14,7,7,1,1,0,0,0,0,
			.byte 0,128,240,224,240,240,128,192,208,192,0,252,59,44,0,0,
			.byte 255,255,249,241,167,239,255,255,249,249,254,255,255,255,255,255,
			.byte 255,255,255,255,191,95,255,255,255,255,255,151,231,255,255,255,
			.word 0 ; safety pair of bytes for reading by POP B
__level00_tile37:
			.byte 15 ; mask
			.byte 4 ; counter
			.byte 0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,
			.byte 0,0,0,0,0,0,0,0,0,0,0,0,60,128,0,0,
			.byte 255,255,253,60,0,0,0,192,252,1,1,252,254,255,255,255,
			.byte 255,255,255,31,15,47,32,207,63,56,0,0,60,185,255,255,
			.byte 0,0,3,192,60,128,60,252,255,131,1,1,0,0,0,0,
			.byte 0,0,0,0,32,32,224,223,255,248,255,156,63,198,0,0,
			.byte 255,255,252,63,195,127,3,195,252,1,255,254,255,255,255,255,
			.byte 255,255,255,255,31,63,63,207,63,56,0,99,192,63,255,255,
			.word 0 ; safety pair of bytes for reading by POP B
__level00_tile38:
			.byte 15 ; mask
			.byte 4 ; counter
			.byte 0,0,0,0,128,0,0,0,0,0,0,0,0,0,0,0,
			.byte 0,0,0,0,0,0,0,0,0,0,48,32,0,0,0,0,
			.byte 252,236,217,137,129,0,0,252,56,0,192,254,255,255,255,255,
			.byte 255,255,255,255,31,111,151,151,103,7,191,191,191,191,223,223,
			.byte 1,16,33,115,131,241,31,253,61,1,1,0,0,0,0,0,
			.byte 0,0,0,0,0,96,240,240,104,136,176,160,128,128,192,192,
			.byte 254,254,253,253,125,14,0,252,56,192,254,255,255,255,255,255,
			.byte 255,255,255,255,255,127,159,159,127,63,207,223,255,255,255,255,
			.word 0 ; safety pair of bytes for reading by POP B
__level00_tile39:
			.byte 15 ; mask
			.byte 4 ; counter
			.byte 0,4,8,8,0,8,0,0,0,0,0,0,0,0,0,0,
			.byte 24,16,0,0,0,0,0,0,0,0,32,0,0,0,0,0,
			.byte 252,253,249,249,241,233,192,249,250,250,249,252,254,254,254,252,
			.byte 223,223,223,223,31,159,95,95,159,31,63,143,143,191,223,223,
			.byte 1,5,9,9,9,25,57,3,3,3,1,0,0,0,0,0,
			.byte 216,208,192,192,0,192,192,192,192,192,160,176,176,128,192,192,
			.byte 254,251,247,247,255,247,254,253,254,254,255,255,255,255,255,255,
			.byte 231,239,255,255,255,191,127,127,191,63,95,255,255,255,255,255,
			.word 0 ; safety pair of bytes for reading by POP B
__level00_tile40:
			.byte 15 ; mask
			.byte 4 ; counter
			.byte 0,0,0,1,3,2,0,0,0,0,0,0,0,0,0,0,
			.byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,240,0,
			.byte 255,255,255,253,251,254,254,254,254,254,254,254,254,254,254,254,
			.byte 223,239,111,111,15,103,144,151,103,96,0,0,0,3,255,255,
			.byte 0,0,0,3,7,2,0,0,0,0,0,0,0,0,0,0,
			.byte 192,224,96,96,0,240,144,255,255,248,103,100,35,12,240,0,
			.byte 255,255,255,254,252,253,255,255,255,255,255,255,255,255,255,255,
			.byte 255,255,127,255,159,111,159,151,103,96,152,155,220,243,15,255,
			.word 0 ; safety pair of bytes for reading by POP B
__level00_tile41:
			.byte 15 ; mask
			.byte 4 ; counter
			.byte 0,1,191,255,255,112,64,64,0,0,0,0,0,128,192,96,
			.byte 30,1,0,0,0,0,0,0,64,64,225,229,255,255,132,128,
			.byte 0,1,191,255,255,118,71,71,1,0,0,0,0,128,192,96,
			.byte 30,1,0,0,0,0,0,0,64,64,225,229,255,255,132,128,
			.byte 0,1,191,255,255,249,248,248,254,255,255,255,255,255,255,127,
			.byte 254,255,255,255,255,255,255,255,255,255,255,255,255,255,132,128,
			.byte 255,254,64,0,0,143,191,191,255,255,255,255,255,127,63,159,
			.byte 225,254,255,255,255,255,255,255,191,191,30,26,0,0,123,127,
			.word 0 ; safety pair of bytes for reading by POP B
__level00_tile42:
			.byte 15 ; mask
			.byte 4 ; counter
			.byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
			.byte 0,0,0,0,0,0,0,0,0,0,0,0,0,24,16,24,
			.byte 252,253,249,249,249,241,240,243,244,244,243,248,255,255,255,255,
			.byte 255,255,255,255,127,63,176,135,127,56,0,128,131,159,215,223,
			.byte 1,1,1,1,1,1,3,7,7,7,7,0,0,0,0,0,
			.byte 0,0,0,0,0,128,128,143,255,252,135,128,136,216,216,216,
			.byte 254,255,255,255,255,255,252,251,252,252,251,255,255,255,255,255,
			.byte 255,255,255,255,255,127,255,247,127,59,120,255,247,167,239,231,
			.word 0 ; safety pair of bytes for reading by POP B
__level00_tile43:
			.byte 15 ; mask
			.byte 4 ; counter
			.byte 0,0,0,7,15,0,0,0,0,0,0,0,2,0,0,0,
			.byte 0,0,0,0,0,0,0,0,0,0,2,12,8,0,0,0,
			.byte 255,255,255,255,15,0,0,128,248,126,14,240,254,254,254,254,
			.byte 223,223,223,15,103,151,151,103,7,7,3,15,15,255,255,255,
			.byte 0,0,0,7,15,192,126,192,255,255,14,0,2,0,0,0,
			.byte 192,192,192,192,240,240,240,112,96,104,78,12,8,0,0,0,
			.byte 255,255,255,248,240,63,129,191,248,126,255,255,253,255,255,255,
			.byte 255,255,255,63,111,159,159,239,159,159,189,243,247,255,255,255,
			.word 0 ; safety pair of bytes for reading by POP B
__level00_tile44:
			.byte 15 ; mask
			.byte 4 ; counter
			.byte 0,0,20,56,0,0,0,128,128,192,96,16,98,33,0,0,
			.byte 0,0,224,4,6,1,1,0,1,0,4,8,16,56,0,0,
			.byte 255,255,156,184,64,192,128,128,128,192,96,208,226,169,63,255,
			.byte 255,31,231,5,7,1,1,1,1,1,7,9,31,63,255,255,
			.byte 0,0,119,124,137,8,8,137,192,228,224,20,102,111,192,0,
			.byte 0,248,232,14,46,137,9,40,9,24,116,14,22,188,0,0,
			.byte 255,255,232,195,244,247,247,112,54,19,144,195,129,202,255,255,
			.byte 255,255,7,227,1,102,230,7,230,231,11,247,207,7,255,255,
