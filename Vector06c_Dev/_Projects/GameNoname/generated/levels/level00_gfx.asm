__RAM_DISK_S_LEVEL00_GFX = RAM_DISK_S
__RAM_DISK_M_LEVEL00_GFX = RAM_DISK_M
			.word 0 ; safety pair of bytes for reading by POP B
; source\levels\art\level00.png
__level00_palette:
			.byte %01101100, %01100101, %01010010, %10110111, 
			.byte %01011100, %01100100, %01100010, %01101101, 
			.byte %01101011, %10100100, %10011011, %01101111, 
			.byte %00011111, %10101111, %11111111, %11100010, 


			.word 0 ; safety pair of bytes for reading by POP B
__level00_tiles_addr:
			.word __level00_tile0, 0, __level00_tile1, 0, __level00_tile2, 0, __level00_tile3, 0, __level00_tile4, 0, __level00_tile5, 0, __level00_tile6, 0, __level00_tile7, 0, __level00_tile8, 0, __level00_tile9, 0, __level00_tile10, 0, __level00_tile11, 0, __level00_tile12, 0, __level00_tile13, 0, __level00_tile14, 0, __level00_tile15, 0, __level00_tile16, 0, __level00_tile17, 0, __level00_tile18, 0, __level00_tile19, 0, __level00_tile20, 0, __level00_tile21, 0, __level00_tile22, 0, __level00_tile23, 0, __level00_tile24, 0, __level00_tile25, 0, __level00_tile26, 0, __level00_tile27, 0, __level00_tile28, 0, __level00_tile29, 0, __level00_tile30, 0, __level00_tile31, 0, __level00_tile32, 0, __level00_tile33, 0, __level00_tile34, 0, __level00_tile35, 0, __level00_tile36, 0, __level00_tile37, 

; source\levels\art\level00.png
__level00_tiles:
			.word 0 ; safety pair of bytes for reading by POP B
__level00_tile0:
			.byte 0 ; mask
			.byte 4 ; counter

			.word 0 ; safety pair of bytes for reading by POP B
__level00_tile1:
			.byte 15 ; mask
			.byte 4 ; counter
			.byte 0,0,0,0,0,0,226,242,0,64,216,96,28,0,1,0,
			.byte 128,0,128,160,0,0,0,0,0,0,0,0,0,16,88,28,
			.byte 0,0,0,0,0,0,0,0,210,48,0,1,1,3,2,3,
			.byte 32,0,0,0,128,0,0,0,0,0,0,0,0,40,4,192,
			.byte 0,0,0,0,0,0,96,110,222,240,224,97,1,15,14,3,
			.byte 224,0,128,128,128,0,0,0,0,0,0,0,0,56,60,220,
			.byte 0,0,0,0,0,0,96,110,206,192,224,97,1,15,14,0,
			.byte 224,0,128,128,128,0,0,0,0,0,0,0,0,56,60,28,
			.word 0 ; safety pair of bytes for reading by POP B
__level00_tile2:
			.byte 15 ; mask
			.byte 4 ; counter
			.byte 0,0,0,0,0,0,0,0,56,0,64,0,0,0,0,0,
			.byte 0,5,0,0,0,14,0,0,0,0,0,0,0,0,0,0,
			.byte 0,0,0,0,0,0,0,48,64,240,0,128,0,0,0,0,
			.byte 0,0,3,1,7,0,6,0,0,0,0,0,0,0,0,0,
			.byte 0,0,0,0,0,0,0,48,112,240,128,128,0,0,0,0,
			.byte 6,14,15,1,7,6,6,0,0,0,0,0,0,0,0,0,
			.byte 0,0,0,0,0,0,0,48,48,176,128,128,0,0,0,0,
			.byte 6,14,12,0,6,6,6,0,0,0,0,0,0,0,0,0,
			.word 0 ; safety pair of bytes for reading by POP B
__level00_tile3:
			.byte 15 ; mask
			.byte 4 ; counter
			.byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,3,0,
			.byte 128,0,96,224,0,0,0,0,0,0,0,0,0,0,0,0,
			.byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,
			.byte 100,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
			.byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,
			.byte 228,128,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
			.byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,
			.byte 132,128,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
			.word 0 ; safety pair of bytes for reading by POP B
__level00_tile4:
			.byte 15 ; mask
			.byte 4 ; counter
			.byte 0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,
			.byte 0,0,0,64,192,128,32,0,0,192,64,0,0,0,0,0,
			.byte 0,0,0,1,1,3,3,7,15,31,34,33,48,120,64,35,
			.byte 0,0,0,0,0,64,192,128,128,2,163,243,120,8,0,0,
			.byte 0,0,0,0,1,0,0,0,0,0,34,1,0,0,0,35,
			.byte 0,0,0,0,0,64,192,128,128,2,161,177,32,0,0,0,
			.byte 255,255,255,255,254,253,252,248,241,227,192,192,208,136,128,195,
			.byte 0,0,0,0,0,0,0,0,0,0,0,0,155,255,255,255,
			.word 0 ; safety pair of bytes for reading by POP B
__level00_tile5:
			.byte 8 ; mask
			.byte 4 ; counter
			.byte 255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,
			.byte 255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,
			.word 0 ; safety pair of bytes for reading by POP B
__level00_tile6:
			.byte 15 ; mask
			.byte 4 ; counter
			.byte 16,16,0,0,0,0,128,0,0,0,7,7,3,0,1,3,
			.byte 0,0,176,128,136,152,0,0,0,0,0,4,24,25,11,0,
			.byte 34,96,0,0,128,128,0,0,0,0,0,0,0,3,0,0,
			.byte 0,192,64,64,32,0,0,0,0,0,3,3,1,0,4,12,
			.byte 2,64,0,0,0,0,0,0,0,0,1,1,1,3,3,3,
			.byte 128,192,112,240,160,128,0,0,0,0,3,7,7,6,0,8,
			.byte 226,224,128,128,0,0,0,0,0,0,1,1,1,3,3,3,
			.byte 128,128,48,176,160,128,0,0,0,0,0,6,6,6,4,7,
			.word 0 ; safety pair of bytes for reading by POP B
__level00_tile7:
			.byte 15 ; mask
			.byte 4 ; counter
			.byte 0,0,0,0,0,40,36,68,0,0,0,0,0,0,0,0,
			.byte 0,0,0,0,0,0,0,0,132,200,192,64,0,0,0,0,
			.byte 0,0,224,222,255,215,64,0,0,0,0,0,0,0,0,0,
			.byte 0,0,0,0,0,0,0,16,48,4,30,191,31,7,0,0,
			.byte 0,0,0,0,48,148,64,0,0,0,0,0,0,0,0,0,
			.byte 0,0,0,0,0,0,0,16,48,4,6,1,0,0,0,0,
			.byte 255,255,31,33,62,83,0,0,0,0,0,0,0,0,0,0,
			.byte 0,0,0,0,0,0,0,16,48,0,8,6,228,248,255,255,
			.word 0 ; safety pair of bytes for reading by POP B
__level00_tile8:
			.byte 15 ; mask
			.byte 4 ; counter
			.byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
			.byte 56,24,24,0,24,36,37,25,24,0,0,0,0,0,0,0,
			.byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
			.byte 0,0,0,0,36,0,26,38,38,25,25,8,3,60,0,0,
			.byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
			.byte 124,92,124,100,90,103,101,89,88,102,38,55,60,0,0,0,
			.byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
			.byte 56,56,24,24,24,60,37,25,25,0,0,0,0,60,0,0,
			.word 0 ; safety pair of bytes for reading by POP B
__level00_tile9:
			.byte 15 ; mask
			.byte 4 ; counter
			.byte 0,0,0,0,0,0,0,0,240,255,0,0,0,0,0,0,
			.byte 0,0,0,0,72,72,51,15,14,0,0,0,0,0,0,0,
			.byte 0,0,0,0,240,15,224,15,15,0,32,0,0,0,0,0,
			.byte 0,0,0,72,0,176,196,48,48,63,39,15,240,0,0,0,
			.byte 0,0,0,0,0,240,31,0,240,255,192,63,0,0,0,0,
			.byte 0,0,120,132,204,79,51,207,206,192,216,240,0,0,0,0,
			.byte 0,0,0,0,0,0,0,240,240,255,31,0,0,0,0,0,
			.byte 0,0,0,48,120,72,59,15,15,0,0,15,96,0,0,0,
			.word 0 ; safety pair of bytes for reading by POP B
__level00_tile10:
			.byte 15 ; mask
			.byte 4 ; counter
			.byte 0,0,0,0,0,0,0,0,240,255,0,0,0,0,0,0,
			.byte 0,0,0,0,72,72,51,15,14,0,0,0,0,0,0,0,
			.byte 0,0,0,0,240,15,224,15,15,0,32,0,0,0,0,0,
			.byte 0,0,0,72,0,176,196,48,48,63,39,15,240,0,0,0,
			.byte 0,0,0,0,0,240,31,0,240,255,192,63,0,0,0,0,
			.byte 0,0,120,132,204,79,51,207,206,192,216,240,0,0,0,0,
			.byte 0,0,0,0,0,0,0,240,240,255,31,0,0,0,0,0,
			.byte 0,0,0,48,120,72,59,15,15,0,0,15,96,0,0,0,
			.word 0 ; safety pair of bytes for reading by POP B
__level00_tile11:
			.byte 15 ; mask
			.byte 4 ; counter
			.byte 0,0,0,0,0,0,0,0,240,255,0,0,0,0,0,0,
			.byte 0,0,0,0,72,72,51,15,14,0,0,0,0,0,0,0,
			.byte 0,0,0,0,240,15,224,15,15,0,32,0,0,0,0,0,
			.byte 0,0,0,72,0,176,196,48,48,63,39,15,240,0,0,0,
			.byte 0,0,0,0,0,240,31,0,240,255,192,63,0,0,0,0,
			.byte 0,0,120,132,204,79,51,207,206,192,216,240,0,0,0,0,
			.byte 0,0,0,0,0,0,0,240,240,255,31,0,0,0,0,0,
			.byte 0,0,0,48,120,72,59,15,15,0,0,15,96,0,0,0,
			.word 0 ; safety pair of bytes for reading by POP B
__level00_tile12:
			.byte 15 ; mask
			.byte 4 ; counter
			.byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
			.byte 48,48,48,0,96,144,144,96,0,64,96,96,96,112,48,48,
			.byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
			.byte 0,0,0,0,16,96,96,144,112,40,0,0,0,0,64,0,
			.byte 0,0,0,1,1,1,1,1,1,1,1,1,0,0,0,0,
			.byte 120,120,120,248,232,152,152,104,136,208,240,240,240,248,184,120,
			.byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
			.byte 48,48,48,0,96,144,144,96,0,72,96,96,96,112,48,48,
			.word 0 ; safety pair of bytes for reading by POP B
__level00_tile13:
			.byte 14 ; mask
			.byte 4 ; counter
			.byte 0,0,0,12,7,7,7,0,0,0,0,64,32,224,224,16,
			.byte 0,0,0,0,0,0,0,0,128,128,192,224,0,0,0,0,
			.byte 0,0,0,0,3,7,7,0,0,0,0,0,0,0,224,0,
			.byte 0,0,0,0,0,0,0,0,128,128,192,128,0,0,0,0,
			.byte 255,255,255,243,248,249,249,255,255,255,255,63,31,31,31,15,
			.byte 255,255,255,255,255,255,255,255,255,255,63,31,255,255,255,255,
			.word 0 ; safety pair of bytes for reading by POP B
__level00_tile14:
			.byte 15 ; mask
			.byte 4 ; counter
			.byte 0,0,128,0,7,18,0,1,7,14,14,6,0,128,0,0,
			.byte 64,64,193,64,48,64,0,128,0,128,0,0,0,0,0,1,
			.byte 0,0,0,0,0,0,3,6,0,0,1,0,0,65,233,251,
			.byte 191,187,6,0,8,10,0,0,0,0,0,0,0,0,0,0,
			.byte 0,0,0,0,0,12,15,6,1,0,7,7,1,65,168,50,
			.byte 0,163,30,158,142,10,128,192,192,0,0,0,0,0,0,0,
			.byte 0,0,0,0,0,12,12,0,1,1,6,7,1,1,64,8,
			.byte 3,4,30,158,134,2,128,192,192,0,0,0,0,0,0,0,
			.word 0 ; safety pair of bytes for reading by POP B
__level00_tile15:
			.byte 15 ; mask
			.byte 4 ; counter
			.byte 192,193,0,0,0,0,0,0,0,0,0,0,0,80,36,72,
			.byte 0,128,130,160,128,0,0,0,99,236,240,124,8,0,32,112,
			.byte 62,0,0,128,128,128,0,0,0,0,0,0,0,131,83,164,
			.byte 179,119,57,28,20,0,0,4,4,16,4,2,98,48,0,0,
			.byte 194,192,0,0,0,0,0,0,0,0,0,0,0,129,64,0,
			.byte 0,2,9,28,20,0,1,29,124,112,28,30,110,240,192,0,
			.byte 192,192,128,0,0,128,0,0,0,0,0,0,0,130,17,247,
			.byte 206,77,40,12,4,0,1,29,124,96,28,30,14,192,192,0,
			.word 0 ; safety pair of bytes for reading by POP B
__level00_tile16:
			.byte 15 ; mask
			.byte 4 ; counter
			.byte 0,0,0,0,0,0,0,0,0,24,29,15,15,0,0,0,
			.byte 0,0,0,0,128,0,0,0,0,0,0,0,0,0,16,8,
			.byte 39,0,0,0,128,128,128,128,0,0,2,0,0,236,208,128,
			.byte 0,0,0,128,64,96,112,24,28,4,15,16,33,15,15,151,
			.byte 191,0,128,128,128,128,128,128,128,128,130,128,128,32,144,128,
			.byte 0,0,0,0,64,64,0,0,24,0,8,16,32,12,8,240,
			.byte 0,0,0,0,0,0,0,0,0,0,0,0,0,235,191,255,
			.byte 255,255,255,255,127,95,79,23,7,7,8,16,34,0,0,4,
			.word 0 ; safety pair of bytes for reading by POP B
__level00_tile17:
			.byte 15 ; mask
			.byte 4 ; counter
			.byte 0,128,128,0,0,1,133,137,0,0,0,0,0,0,0,0,
			.byte 0,0,0,0,0,0,0,0,8,144,128,0,0,0,0,0,
			.byte 248,112,64,60,191,238,72,0,0,0,0,0,0,0,0,0,
			.byte 0,0,0,0,0,0,0,0,32,8,60,254,51,57,60,248,
			.byte 96,32,0,0,36,108,72,0,0,0,0,0,0,0,0,0,
			.byte 0,0,0,0,0,0,0,0,32,8,12,2,19,25,60,24,
			.byte 7,143,191,195,112,162,0,0,0,0,0,0,0,0,0,0,
			.byte 0,0,0,0,0,0,0,0,32,0,16,192,192,192,192,0,
			.word 0 ; safety pair of bytes for reading by POP B
__level00_tile18:
			.byte 15 ; mask
			.byte 4 ; counter
			.byte 0,0,0,0,0,0,12,72,0,0,0,0,0,0,0,0,
			.byte 0,0,0,0,0,0,0,0,140,132,194,128,0,0,0,0,
			.byte 56,184,108,180,255,191,32,0,0,0,0,0,0,0,0,0,
			.byte 0,0,0,0,0,0,0,0,32,8,60,127,31,15,0,0,
			.byte 56,176,96,176,244,188,32,0,0,0,0,0,0,0,0,0,
			.byte 0,0,0,0,0,0,0,0,32,8,4,67,0,0,0,0,
			.byte 7,135,99,51,0,19,0,0,0,0,0,0,0,0,0,0,
			.byte 0,0,0,0,0,0,0,0,32,0,40,132,224,240,255,255,
			.word 0 ; safety pair of bytes for reading by POP B
__level00_tile19:
			.byte 15 ; mask
			.byte 4 ; counter
			.byte 0,128,0,128,0,64,64,0,5,3,1,0,0,0,0,0,
			.byte 0,0,0,0,30,152,56,128,0,0,0,0,0,0,0,0,
			.byte 31,31,127,111,236,136,33,227,2,0,0,0,0,0,0,0,
			.byte 28,0,2,6,0,6,196,126,248,224,192,128,0,0,159,255,
			.byte 7,0,0,33,224,224,225,227,2,0,0,0,0,0,0,0,
			.byte 16,0,0,4,0,0,128,4,0,128,0,0,0,0,0,159,
			.byte 224,96,49,64,100,232,224,224,0,0,0,0,0,0,0,0,
			.byte 3,1,1,1,1,7,71,75,135,95,63,127,255,255,96,0,
			.word 0 ; safety pair of bytes for reading by POP B
__level00_tile20:
			.byte 7 ; mask
			.byte 4 ; counter
			.byte 0,0,0,0,0,0,4,13,188,254,255,255,255,255,255,63,
			.byte 254,255,255,255,255,255,127,63,31,26,8,0,0,0,0,0,
			.byte 0,0,0,1,159,255,251,240,64,0,0,0,0,0,0,192,
			.byte 1,0,0,0,0,0,0,64,224,229,247,255,192,0,0,0,
			.byte 0,0,255,255,255,255,251,240,64,0,0,0,0,0,0,192,
			.byte 1,0,0,0,0,0,0,64,224,229,247,255,255,255,0,0,
			.word 0 ; safety pair of bytes for reading by POP B
__level00_tile21:
			.byte 7 ; mask
			.byte 4 ; counter
			.byte 0,0,0,0,0,0,0,12,156,255,255,255,255,255,255,31,
			.byte 255,255,255,255,255,255,127,95,143,11,0,0,0,0,0,0,
			.byte 0,0,0,0,159,255,255,240,96,0,0,0,0,0,0,224,
			.byte 0,0,0,0,0,0,0,32,112,244,255,255,192,0,0,0,
			.byte 0,0,255,255,255,255,255,240,96,0,0,0,0,0,0,224,
			.byte 0,0,0,0,0,0,0,32,112,244,255,255,255,255,0,0,
			.word 0 ; safety pair of bytes for reading by POP B
__level00_tile22:
			.byte 15 ; mask
			.byte 4 ; counter
			.byte 15,31,3,7,31,15,15,31,63,127,255,255,255,255,252,15,
			.byte 0,64,240,232,248,240,228,192,184,39,192,224,240,248,240,224,
			.byte 112,160,60,56,224,240,240,224,192,128,0,0,0,0,3,144,
			.byte 231,186,4,7,7,15,3,15,71,192,7,7,15,7,12,31,
			.byte 240,96,252,248,224,240,240,224,192,128,0,0,0,0,3,240,
			.byte 248,188,7,7,7,15,3,15,71,192,7,7,15,7,15,31,
			.byte 0,128,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
			.byte 0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
			.word 0 ; safety pair of bytes for reading by POP B
__level00_tile23:
			.byte 15 ; mask
			.byte 4 ; counter
			.byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
			.byte 0,0,128,0,0,0,0,0,0,0,0,0,0,0,0,0,
			.byte 0,0,0,0,0,0,0,0,0,0,0,0,1,1,3,135,
			.byte 0,64,56,188,112,0,0,0,0,0,0,0,0,0,0,0,
			.byte 0,0,0,0,0,0,0,0,0,0,0,0,0,1,3,0,
			.byte 0,64,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
			.byte 255,255,255,255,255,255,255,255,255,255,255,255,254,254,252,120,
			.byte 127,127,7,67,143,255,255,255,255,255,255,255,255,255,255,255,
			.word 0 ; safety pair of bytes for reading by POP B
__level00_tile24:
			.byte 15 ; mask
			.byte 4 ; counter
			.byte 0,0,0,0,0,0,0,0,0,0,159,191,255,255,255,191,
			.byte 255,255,255,255,255,255,0,0,0,0,0,0,0,0,0,0,
			.byte 0,0,0,243,251,251,0,191,255,255,96,64,0,0,0,64,
			.byte 0,0,0,0,0,0,255,255,255,112,251,255,251,0,0,0,
			.byte 0,0,255,12,4,4,255,64,0,0,0,0,0,0,0,0,
			.byte 0,0,0,0,0,0,0,0,0,143,4,0,4,255,0,0,
			.byte 255,255,0,0,0,0,0,0,0,0,159,191,255,255,255,191,
			.byte 255,255,255,255,255,255,0,0,0,0,0,0,0,0,255,255,
			.word 0 ; safety pair of bytes for reading by POP B
__level00_tile25:
			.byte 15 ; mask
			.byte 4 ; counter
			.byte 31,0,7,15,15,15,15,15,7,0,159,191,191,191,191,191,
			.byte 255,255,255,255,255,254,0,248,252,252,252,252,252,248,0,255,
			.byte 224,63,56,48,48,48,48,16,232,255,96,64,64,64,64,64,
			.byte 0,0,0,0,0,1,255,5,2,3,3,3,3,7,255,0,
			.byte 128,192,192,192,192,192,192,224,16,0,0,0,0,0,0,0,
			.byte 0,0,0,0,0,0,0,2,1,0,0,0,0,0,0,0,
			.byte 31,0,7,15,15,15,15,15,7,0,159,191,191,191,191,191,
			.byte 255,255,255,255,255,254,0,248,252,252,252,252,252,248,0,255,
			.word 0 ; safety pair of bytes for reading by POP B
__level00_tile26:
			.byte 15 ; mask
			.byte 4 ; counter
			.byte 0,0,0,0,0,0,0,0,0,128,159,191,255,255,255,191,
			.byte 255,255,255,255,255,255,0,0,0,0,0,0,0,0,0,0,
			.byte 72,0,0,115,115,243,128,191,255,127,96,64,0,0,0,64,
			.byte 0,0,0,0,0,0,255,255,255,112,251,251,251,0,0,33,
			.byte 8,0,127,140,140,140,255,192,128,0,0,0,0,0,0,0,
			.byte 0,0,0,0,0,0,0,0,0,143,4,4,4,255,0,0,
			.byte 183,255,128,0,0,0,0,0,0,0,31,63,127,127,127,63,
			.byte 255,255,255,255,255,255,0,0,0,0,0,0,0,0,255,222,
			.word 0 ; safety pair of bytes for reading by POP B
__level00_tile27:
			.byte 15 ; mask
			.byte 4 ; counter
			.byte 31,0,7,15,15,15,15,15,7,0,159,191,191,191,191,191,
			.byte 255,255,255,255,255,254,0,248,252,252,252,252,252,248,0,254,
			.byte 224,63,56,48,48,48,48,16,232,255,96,64,64,64,64,64,
			.byte 0,0,0,0,0,1,255,5,2,3,3,3,3,7,255,1,
			.byte 128,192,192,192,192,192,192,224,16,0,0,0,0,0,0,0,
			.byte 0,0,0,0,0,0,0,2,1,0,0,0,0,0,0,0,
			.byte 31,0,7,15,15,15,15,15,7,0,159,191,191,191,191,191,
			.byte 255,255,255,255,255,254,0,248,252,252,252,252,252,248,0,254,
			.word 0 ; safety pair of bytes for reading by POP B
__level00_tile28:
			.byte 15 ; mask
			.byte 4 ; counter
			.byte 31,31,19,7,63,31,14,63,127,255,255,255,255,255,60,30,
			.byte 0,64,224,192,248,240,204,144,56,6,136,200,240,248,241,192,
			.byte 224,32,44,56,192,224,241,192,128,0,0,0,0,0,195,161,
			.byte 224,184,4,14,7,15,3,15,199,193,7,7,14,6,12,30,
			.byte 96,224,236,248,192,224,241,192,128,0,0,0,0,0,195,225,
			.byte 248,188,7,15,7,15,3,15,199,193,7,7,15,7,15,31,
			.byte 128,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
			.byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
			.word 0 ; safety pair of bytes for reading by POP B
__level00_tile29:
			.byte 15 ; mask
			.byte 4 ; counter
			.byte 7,7,15,15,31,31,31,63,25,11,4,25,14,0,0,4,
			.byte 235,243,215,159,15,15,254,248,252,254,248,240,248,240,240,254,
			.byte 248,56,16,16,0,32,32,64,96,112,56,32,49,126,124,56,
			.byte 16,0,32,96,240,240,1,7,3,1,7,15,6,14,14,1,
			.byte 56,56,48,48,32,96,96,64,96,112,120,96,113,126,124,120,
			.byte 16,0,32,96,240,240,1,7,3,1,7,15,7,15,15,1,
			.byte 0,192,192,192,192,128,128,128,128,128,128,128,128,128,128,128,
			.byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
			.word 0 ; safety pair of bytes for reading by POP B
__level00_tile30:
			.byte 15 ; mask
			.byte 4 ; counter
			.byte 0,0,0,0,0,0,0,2,6,94,255,255,255,255,255,255,
			.byte 255,255,255,255,255,127,95,143,13,4,0,0,0,0,0,0,
			.byte 128,0,255,0,8,223,255,253,248,160,0,0,0,0,0,0,
			.byte 0,0,0,0,0,0,32,112,242,251,255,226,64,255,0,0,
			.byte 0,0,0,255,255,255,255,253,248,160,0,0,0,0,0,0,
			.byte 0,0,0,0,0,0,32,112,242,251,255,255,255,0,0,0,
			.byte 127,255,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
			.byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,255,255,
			.word 0 ; safety pair of bytes for reading by POP B
__level00_tile31:
			.byte 7 ; mask
			.byte 4 ; counter
			.byte 0,0,0,0,64,0,0,4,208,241,201,231,255,255,255,15,
			.byte 142,251,242,244,255,255,127,95,143,13,0,0,0,0,0,0,
			.byte 0,0,0,0,159,255,255,248,32,0,0,0,0,0,0,144,
			.byte 113,0,0,0,0,0,0,32,112,242,255,191,2,0,15,0,
			.byte 0,0,255,255,255,255,255,248,32,0,0,0,0,0,0,240,
			.byte 113,0,0,0,0,0,0,32,112,242,255,255,255,255,12,0,
			.word 0 ; safety pair of bytes for reading by POP B
__level00_tile32:
			.byte 15 ; mask
			.byte 4 ; counter
			.byte 0,0,0,0,0,0,0,19,187,253,243,255,254,127,255,14,
			.byte 64,56,144,70,0,152,240,120,104,64,0,0,0,0,0,0,
			.byte 0,0,0,0,223,255,255,236,68,2,12,0,0,0,0,209,
			.byte 190,1,0,0,0,1,15,135,150,190,252,246,176,16,0,0,
			.byte 0,0,255,255,255,255,255,236,68,2,12,0,0,0,0,241,
			.byte 190,1,3,1,0,1,15,135,151,191,255,255,254,254,0,0,
			.byte 127,255,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
			.byte 1,0,0,0,0,0,0,0,0,0,0,0,1,1,255,255,
			.word 0 ; safety pair of bytes for reading by POP B
__level00_tile33:
			.byte 15 ; mask
			.byte 4 ; counter
			.byte 0,0,6,0,2,0,16,16,20,10,39,7,7,11,3,3,
			.byte 15,195,215,255,28,156,246,17,0,0,128,36,0,124,0,0,
			.byte 0,0,0,4,36,15,15,15,3,49,0,0,96,16,0,60,
			.byte 224,0,0,0,131,3,1,226,251,255,63,18,18,0,0,0,
			.byte 0,0,15,31,31,63,63,47,35,113,64,64,96,48,48,28,
			.byte 192,0,0,0,131,3,1,226,251,255,255,255,255,255,0,0,
			.byte 255,255,240,224,192,192,192,192,192,128,128,128,128,192,192,192,
			.byte 32,0,0,0,0,0,0,0,0,0,0,0,0,0,255,255,
			.word 0 ; safety pair of bytes for reading by POP B
__level00_tile34:
			.byte 15 ; mask
			.byte 4 ; counter
			.byte 0,0,206,0,0,0,0,0,3,94,239,239,255,255,255,31,
			.byte 243,228,176,152,70,70,96,24,0,0,2,0,0,40,0,0,
			.byte 8,0,0,8,8,223,255,255,252,160,16,16,0,0,0,224,
			.byte 0,3,67,97,1,0,2,230,255,255,252,224,96,64,0,0,
			.byte 0,0,255,255,255,255,255,255,252,160,16,16,0,0,0,224,
			.byte 0,3,67,97,1,1,3,231,255,255,255,255,255,254,0,0,
			.byte 255,255,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
			.byte 0,0,0,0,0,0,0,0,0,0,0,0,0,1,255,255,
			.word 0 ; safety pair of bytes for reading by POP B
__level00_tile35:
			.byte 15 ; mask
			.byte 4 ; counter
			.byte 63,0,15,15,15,15,15,15,135,0,31,191,255,255,191,191,
			.byte 255,255,255,255,255,254,0,248,252,252,252,252,252,252,0,158,
			.byte 0,0,176,48,48,176,176,144,104,255,224,64,0,0,64,64,
			.byte 0,0,0,0,0,1,255,5,2,3,3,3,3,3,0,97,
			.byte 192,255,64,192,192,192,192,224,16,128,128,0,0,0,0,0,
			.byte 0,0,0,0,0,0,0,2,1,0,0,0,0,0,255,0,
			.byte 63,0,15,15,15,15,15,15,7,0,31,63,127,127,63,63,
			.byte 255,255,255,255,255,254,0,248,252,252,252,252,252,252,0,158,
			.word 0 ; safety pair of bytes for reading by POP B
__level00_tile36:
			.byte 15 ; mask
			.byte 4 ; counter
			.byte 31,31,15,31,63,31,14,34,69,187,243,247,255,255,255,63,
			.byte 205,200,235,231,255,255,252,63,63,56,248,240,240,248,241,224,
			.byte 224,96,48,96,192,224,241,193,130,64,0,0,0,0,0,192,
			.byte 0,0,0,24,0,0,3,192,192,199,7,15,14,6,12,30,
			.byte 96,96,240,224,192,224,241,193,130,64,0,0,0,0,0,192,
			.byte 0,0,0,24,0,0,3,192,192,199,7,15,15,7,15,31,
			.byte 128,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
			.byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
			.word 0 ; safety pair of bytes for reading by POP B
__level00_tile37:
			.byte 15 ; mask
			.byte 4 ; counter
			.byte 3,1,0,0,1,2,66,0,0,0,0,0,128,0,0,0,
			.byte 0,0,0,0,0,0,0,0,0,0,0,0,70,64,0,192,
			.byte 0,0,0,0,0,0,128,128,0,0,0,0,0,128,128,0,
			.byte 0,0,0,0,0,0,0,0,0,128,128,192,0,24,64,32,
			.byte 1,1,0,0,0,3,131,224,224,128,0,0,0,0,0,0,
			.byte 0,0,0,0,0,0,0,0,96,224,128,248,56,24,192,224,
			.byte 1,1,0,0,0,3,3,96,224,128,0,0,0,128,0,128,
			.byte 0,0,0,0,0,0,0,0,96,224,128,56,56,24,192,224,