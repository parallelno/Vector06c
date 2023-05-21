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
__tiled_images_tiles_addr:
			.word __tiled_images_tile1, 0, __tiled_images_tile2, 0, __tiled_images_tile3, 0, __tiled_images_tile4, 0, __tiled_images_tile5, 0, __tiled_images_tile6, 0, __tiled_images_tile7, 0, __tiled_images_tile8, 0, __tiled_images_tile9, 0, __tiled_images_tile10, 0, __tiled_images_tile11, 0, __tiled_images_tile12, 0, __tiled_images_tile13, 0, __tiled_images_tile14, 0, __tiled_images_tile15, 0, __tiled_images_tile16, 0, __tiled_images_tile17, 0, __tiled_images_tile18, 0, __tiled_images_tile19, 0, __tiled_images_tile20, 0, __tiled_images_tile21, 0, __tiled_images_tile22, 0, __tiled_images_tile23, 0, __tiled_images_tile24, 0, __tiled_images_tile25, 0, __tiled_images_tile26, 0, __tiled_images_tile27, 0, __tiled_images_tile28, 0, __tiled_images_tile29, 0, __tiled_images_tile30, 0, __tiled_images_tile31, 0, __tiled_images_tile32, 0, __tiled_images_tile33, 0, __tiled_images_tile34, 0, __tiled_images_tile35, 0, __tiled_images_tile36, 0, __tiled_images_tile37, 0, __tiled_images_tile38, 0, __tiled_images_tile39, 0, __tiled_images_tile40, 0, __tiled_images_tile41, 0, __tiled_images_tile42, 0, __tiled_images_tile43, 0, __tiled_images_tile44, 0, __tiled_images_tile45, 0, __tiled_images_tile46, 0, __tiled_images_tile47, 0, __tiled_images_tile48, 0, __tiled_images_tile49, 0, __tiled_images_tile50, 0, __tiled_images_tile51, 0, __tiled_images_tile52, 0, __tiled_images_tile53, 0, __tiled_images_tile54, 0, __tiled_images_tile55, 0, __tiled_images_tile56, 0, __tiled_images_tile57, 0, __tiled_images_tile58, 0, __tiled_images_tile59, 0, __tiled_images_tile60, 0, __tiled_images_tile61, 0, __tiled_images_tile62, 0, __tiled_images_tile63, 0, __tiled_images_tile64, 0, __tiled_images_tile65, 0, __tiled_images_tile66, 0, __tiled_images_tile67, 0, __tiled_images_tile68, 0, __tiled_images_tile69, 0, __tiled_images_tile70, 0, __tiled_images_tile71, 0, __tiled_images_tile72, 0, __tiled_images_tile73, 0, __tiled_images_tile74, 0, __tiled_images_tile75, 0, __tiled_images_tile76, 0, __tiled_images_tile77, 0, __tiled_images_tile78, 0, __tiled_images_tile79, 0, __tiled_images_tile80, 0, __tiled_images_tile81, 0, __tiled_images_tile82, 0, __tiled_images_tile83, 0, __tiled_images_tile84, 0, __tiled_images_tile85, 0, __tiled_images_tile86, 0, __tiled_images_tile87, 0, __tiled_images_tile88, 0, __tiled_images_tile89, 0, __tiled_images_tile90, 0, __tiled_images_tile91, 0, __tiled_images_tile92, 0, __tiled_images_tile93, 0, __tiled_images_tile94, 0, __tiled_images_tile95, 0, __tiled_images_tile96, 0, __tiled_images_tile97, 0, __tiled_images_tile98, 0, __tiled_images_tile99, 0, __tiled_images_tile100, 0, __tiled_images_tile101, 0, __tiled_images_tile102, 0, __tiled_images_tile103, 0, __tiled_images_tile104, 0, __tiled_images_tile105, 0, __tiled_images_tile106, 0, __tiled_images_tile107, 0, __tiled_images_tile108, 0, __tiled_images_tile109, 0, __tiled_images_tile110, 0, __tiled_images_tile111, 0, __tiled_images_tile112, 0, __tiled_images_tile113, 0, __tiled_images_tile114, 0, __tiled_images_tile115, 0, __tiled_images_tile116, 0, __tiled_images_tile117, 0, __tiled_images_tile118, 0, __tiled_images_tile119, 0, __tiled_images_tile120, 0, __tiled_images_tile121, 0, __tiled_images_tile122, 0, __tiled_images_tile123, 0, __tiled_images_tile124, 0, __tiled_images_tile125, 0, __tiled_images_tile126, 0, __tiled_images_tile127, 0, __tiled_images_tile128, 0, __tiled_images_tile129, 0, __tiled_images_tile130, 0, __tiled_images_tile131, 0, __tiled_images_tile132, 0, __tiled_images_tile133, 0, __tiled_images_tile134, 0, __tiled_images_tile135, 0, __tiled_images_tile136, 

; source\sprites\art\tiled_images.png
__tiled_images_tiles:
			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile1:
			.byte 15 ; mask
			.byte 4 ; counter
			.byte 144,144,144,144,0,0,12,4,
			.byte 70,71,67,64,239,112,51,11,
			.byte 246,247,247,240,255,255,127,63,
			.byte 2,3,0,0,143,64,44,4,
			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile2:
			.byte 15 ; mask
			.byte 4 ; counter
			.byte 0,0,192,0,0,0,0,0,
			.byte 0,255,63,0,255,0,255,255,
			.byte 0,255,255,0,255,255,255,255,
			.byte 0,255,192,0,255,0,0,0,
			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile3:
			.byte 15 ; mask
			.byte 4 ; counter
			.byte 73,73,9,1,1,1,2,4,
			.byte 4,164,196,12,244,12,252,240,
			.byte 39,167,231,15,255,255,254,252,
			.byte 72,200,8,8,240,0,4,0,
			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile4:
			.byte 15 ; mask
			.byte 4 ; counter
			.byte 146,146,146,144,144,144,144,144,
			.byte 0,0,0,2,2,70,6,70,
			.byte 246,246,246,246,246,246,246,246,
			.byte 0,0,0,2,2,2,2,2,
			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile5:
			.byte 0 ; mask
			.byte 4 ; counter

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile6:
			.byte 13 ; mask
			.byte 4 ; counter
			.byte 77,73,73,73,73,73,73,73,
			.byte 39,39,39,39,39,39,39,39,
			.byte 72,72,72,72,72,72,72,72,
			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile7:
			.byte 15 ; mask
			.byte 4 ; counter
			.byte 31,111,192,207,144,148,147,146,
			.byte 0,16,32,0,0,0,0,0,
			.byte 31,127,255,255,240,243,246,246,
			.byte 0,16,32,0,0,4,1,0,
			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile8:
			.byte 13 ; mask
			.byte 4 ; counter
			.byte 255,255,0,255,0,0,255,0,
			.byte 255,255,255,192,0,255,0,0,
			.byte 0,0,0,63,0,0,255,0,
			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile9:
			.byte 15 ; mask
			.byte 4 ; counter
			.byte 248,252,6,227,11,45,205,77,
			.byte 0,0,0,24,4,0,0,0,
			.byte 248,252,254,127,7,231,39,39,
			.byte 0,0,0,152,12,8,200,72,
			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile10:
			.byte 15 ; mask
			.byte 4 ; counter
			.byte 96,48,56,28,14,3,0,0,
			.byte 144,200,68,34,17,12,1,0,
			.byte 240,248,124,127,63,15,7,0,
			.byte 111,191,255,188,222,251,249,255,
			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile11:
			.byte 15 ; mask
			.byte 4 ; counter
			.byte 0,0,0,0,0,245,0,0,
			.byte 0,0,0,1,129,10,255,1,
			.byte 0,0,0,1,193,255,255,1,
			.byte 255,255,255,255,190,245,0,255,
			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile12:
			.byte 15 ; mask
			.byte 4 ; counter
			.byte 0,0,96,224,224,192,192,0,
			.byte 0,96,128,0,0,32,32,224,
			.byte 0,96,224,224,224,224,224,224,
			.byte 255,191,127,255,255,223,223,255,
			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile13:
			.byte 15 ; mask
			.byte 4 ; counter
			.byte 2,3,1,1,0,0,0,0,
			.byte 5,4,2,0,0,0,0,0,
			.byte 7,7,3,1,0,0,0,0,
			.byte 254,255,253,255,255,255,255,255,
			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile14:
			.byte 15 ; mask
			.byte 4 ; counter
			.byte 4,1,128,128,0,0,0,0,
			.byte 3,130,1,64,192,64,0,0,
			.byte 135,131,193,193,192,64,0,0,
			.byte 124,125,191,254,127,191,255,255,
			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile15:
			.byte 15 ; mask
			.byte 4 ; counter
			.byte 0,128,248,15,0,0,0,0,
			.byte 0,112,7,112,15,0,0,0,
			.byte 128,240,255,255,31,0,0,0,
			.byte 127,159,249,79,239,255,255,255,
			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile16:
			.byte 14 ; mask
			.byte 4 ; counter
			.byte 0,0,128,128,0,0,0,0,
			.byte 0,0,192,128,128,0,0,0,
			.byte 255,255,191,127,127,255,255,255,
			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile17:
			.byte 15 ; mask
			.byte 4 ; counter
			.byte 1,1,1,1,1,1,0,0,
			.byte 2,2,2,2,2,2,1,1,
			.byte 3,3,3,3,3,3,3,1,
			.byte 255,255,253,253,255,255,252,254,
			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile18:
			.byte 15 ; mask
			.byte 4 ; counter
			.byte 224,192,192,192,192,192,192,224,
			.byte 0,32,32,32,32,32,32,0,
			.byte 224,224,224,224,224,224,224,240,
			.byte 255,223,255,255,255,223,223,239,
			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile19:
			.byte 15 ; mask
			.byte 4 ; counter
			.byte 1,1,1,7,63,0,0,0,
			.byte 0,2,2,56,64,127,0,0,
			.byte 1,3,3,127,127,127,0,0,
			.byte 255,255,255,167,191,199,255,255,
			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile20:
			.byte 15 ; mask
			.byte 4 ; counter
			.byte 128,128,129,129,193,1,0,0,
			.byte 65,65,64,64,50,254,0,0,
			.byte 193,193,193,193,255,255,0,0,
			.byte 190,190,191,191,209,189,255,255,
			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile21:
			.byte 15 ; mask
			.byte 4 ; counter
			.byte 192,128,128,128,128,129,0,0,
			.byte 0,64,64,80,89,90,0,0,
			.byte 192,192,192,216,217,219,0,0,
			.byte 255,191,191,183,174,191,255,255,
			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile22:
			.byte 15 ; mask
			.byte 4 ; counter
			.byte 48,96,96,96,224,224,0,0,
			.byte 64,16,144,144,0,1,0,0,
			.byte 112,112,240,240,241,241,0,0,
			.byte 255,239,255,127,238,238,255,255,
			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile23:
			.byte 15 ; mask
			.byte 4 ; counter
			.byte 48,48,48,48,48,248,0,0,
			.byte 8,8,72,72,200,0,0,0,
			.byte 56,120,120,120,248,254,4,0,
			.byte 247,191,255,255,191,249,251,255,
			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile24:
			.byte 15 ; mask
			.byte 4 ; counter
			.byte 96,96,96,112,120,31,0,0,
			.byte 144,144,144,136,134,224,7,0,
			.byte 240,240,240,248,255,255,15,0,
			.byte 255,255,239,255,122,31,246,255,
			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile25:
			.byte 15 ; mask
			.byte 4 ; counter
			.byte 24,24,56,56,68,131,0,0,
			.byte 32,32,0,64,187,68,129,0,
			.byte 60,60,57,124,255,199,131,0,
			.byte 219,219,254,251,199,187,253,255,
			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile26:
			.byte 15 ; mask
			.byte 4 ; counter
			.byte 24,24,24,24,48,240,0,0,
			.byte 4,4,36,36,200,8,224,0,
			.byte 28,28,60,124,248,248,240,0,
			.byte 251,255,255,159,183,255,47,255,
			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile27:
			.byte 15 ; mask
			.byte 4 ; counter
			.byte 64,96,96,48,24,15,0,0,
			.byte 160,128,16,64,39,16,3,0,
			.byte 224,224,240,120,63,31,7,0,
			.byte 95,127,127,247,219,255,251,255,
			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile28:
			.byte 15 ; mask
			.byte 4 ; counter
			.byte 4,12,12,24,16,224,0,0,
			.byte 10,18,18,36,232,16,224,3,
			.byte 30,30,30,60,248,240,224,3,
			.byte 229,253,255,251,215,239,255,255,
			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile29:
			.byte 15 ; mask
			.byte 4 ; counter
			.byte 7,28,24,8,6,1,0,8,
			.byte 8,3,0,20,9,18,17,4,
			.byte 15,31,29,30,31,23,27,30,
			.byte 247,253,250,237,238,249,229,237,
			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile30:
			.byte 15 ; mask
			.byte 4 ; counter
			.byte 14,0,0,2,12,224,0,0,
			.byte 177,64,35,5,242,24,192,0,
			.byte 255,247,255,255,255,252,224,0,
			.byte 47,72,34,6,12,227,223,255,
			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile31:
			.byte 14 ; mask
			.byte 4 ; counter
			.byte 0,0,0,0,0,0,1,1,
			.byte 0,0,0,0,0,0,1,3,
			.byte 255,255,255,255,255,255,254,252,
			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile32:
			.byte 15 ; mask
			.byte 4 ; counter
			.byte 0,0,15,63,120,112,224,224,
			.byte 0,3,16,64,134,136,16,16,
			.byte 0,7,63,127,254,248,240,240,
			.byte 255,251,207,255,251,119,239,255,
			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile33:
			.byte 15 ; mask
			.byte 4 ; counter
			.byte 0,0,255,1,1,1,1,0,
			.byte 0,255,0,254,0,0,0,1,
			.byte 0,255,255,255,1,1,1,1,
			.byte 255,143,255,1,255,255,255,254,
			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile34:
			.byte 15 ; mask
			.byte 4 ; counter
			.byte 0,0,192,192,192,128,128,128,
			.byte 0,192,32,0,0,65,65,65,
			.byte 0,224,224,193,193,193,193,193,
			.byte 255,223,255,254,254,191,191,191,
			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile35:
			.byte 15 ; mask
			.byte 4 ; counter
			.byte 0,0,115,96,224,192,192,192,
			.byte 0,127,140,147,0,32,32,32,
			.byte 0,127,255,243,224,224,224,224,
			.byte 255,248,123,126,255,223,255,255,
			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile36:
			.byte 15 ; mask
			.byte 4 ; counter
			.byte 0,0,241,241,112,48,48,48,
			.byte 0,227,10,10,0,64,0,64,
			.byte 0,243,251,251,249,112,112,112,
			.byte 255,110,245,255,118,255,191,255,
			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile37:
			.byte 15 ; mask
			.byte 4 ; counter
			.byte 0,0,240,240,112,48,48,16,
			.byte 0,224,15,8,136,8,8,40,
			.byte 0,255,255,248,248,120,120,56,
			.byte 255,32,247,247,247,183,183,215,
			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile38:
			.byte 15 ; mask
			.byte 4 ; counter
			.byte 0,0,240,96,96,96,96,96,
			.byte 0,115,9,144,144,144,144,144,
			.byte 0,251,251,240,240,240,240,240,
			.byte 255,119,253,111,239,255,255,255,
			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile39:
			.byte 15 ; mask
			.byte 4 ; counter
			.byte 0,0,56,24,24,24,24,24,
			.byte 0,124,68,36,36,32,32,32,
			.byte 0,255,124,60,60,60,60,60,
			.byte 255,68,255,223,223,219,219,219,
			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile40:
			.byte 15 ; mask
			.byte 4 ; counter
			.byte 0,0,28,28,24,8,8,8,
			.byte 0,60,32,0,4,20,20,20,
			.byte 0,254,63,28,28,28,28,28,
			.byte 255,61,252,255,251,235,235,235,
			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile41:
			.byte 15 ; mask
			.byte 4 ; counter
			.byte 0,0,31,56,112,96,96,96,
			.byte 0,15,32,71,8,144,128,128,
			.byte 0,159,255,255,248,240,224,224,
			.byte 255,104,31,59,127,255,255,127,
			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile42:
			.byte 15 ; mask
			.byte 4 ; counter
			.byte 0,0,224,48,24,12,12,12,
			.byte 0,192,16,200,36,18,18,2,
			.byte 0,224,240,252,60,30,30,14,
			.byte 255,95,255,51,219,239,253,253,
			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile43:
			.byte 15 ; mask
			.byte 4 ; counter
			.byte 0,0,3,0,0,0,0,0,
			.byte 0,31,28,7,0,15,12,3,
			.byte 0,31,31,31,24,31,14,3,
			.byte 255,255,243,231,231,232,253,255,
			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile44:
			.byte 15 ; mask
			.byte 4 ; counter
			.byte 0,0,128,57,1,0,64,60,
			.byte 0,132,126,198,54,129,185,195,
			.byte 0,204,254,255,255,227,253,255,
			.byte 255,179,133,185,55,156,203,61,
			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile45:
			.byte 15 ; mask
			.byte 4 ; counter
			.byte 0,0,0,0,0,128,128,0,
			.byte 0,0,0,0,128,0,0,0,
			.byte 0,0,0,0,128,128,128,0,
			.byte 255,255,255,255,127,255,255,255,
			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile46:
			.byte 15 ; mask
			.byte 4 ; counter
			.byte 15,15,15,15,15,31,0,0,
			.byte 16,16,16,16,16,0,15,0,
			.byte 31,31,31,31,31,31,31,0,
			.byte 239,239,239,239,239,255,239,255,
			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile47:
			.byte 14 ; mask
			.byte 4 ; counter
			.byte 128,128,128,128,128,128,128,0,
			.byte 128,128,128,128,128,128,128,0,
			.byte 255,255,127,127,127,127,255,255,
			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile48:
			.byte 15 ; mask
			.byte 4 ; counter
			.byte 0,0,0,0,0,7,0,0,
			.byte 0,0,0,0,0,8,15,0,
			.byte 0,0,0,0,7,15,15,0,
			.byte 255,255,255,255,248,247,240,255,
			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile49:
			.byte 15 ; mask
			.byte 4 ; counter
			.byte 0,0,0,0,0,255,0,0,
			.byte 0,0,0,0,0,0,255,0,
			.byte 0,0,0,0,255,255,255,0,
			.byte 255,255,255,255,0,255,0,255,
			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile50:
			.byte 15 ; mask
			.byte 4 ; counter
			.byte 0,0,0,0,0,255,0,0,
			.byte 3,0,0,0,0,0,255,0,
			.byte 3,0,0,0,255,255,255,0,
			.byte 255,255,255,255,0,255,0,255,
			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile51:
			.byte 15 ; mask
			.byte 4 ; counter
			.byte 0,0,0,0,0,255,0,0,
			.byte 0,0,0,0,0,0,255,0,
			.byte 128,0,0,0,224,255,255,0,
			.byte 127,255,255,255,31,255,0,255,
			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile52:
			.byte 15 ; mask
			.byte 4 ; counter
			.byte 0,0,0,0,0,255,7,0,
			.byte 1,0,0,0,0,0,248,0,
			.byte 1,0,0,0,0,255,255,0,
			.byte 255,255,255,255,255,255,7,255,
			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile53:
			.byte 15 ; mask
			.byte 4 ; counter
			.byte 0,0,0,0,0,255,0,0,
			.byte 240,0,0,0,0,0,255,0,
			.byte 240,0,0,0,0,255,255,0,
			.byte 63,255,255,255,255,255,0,255,
			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile54:
			.byte 15 ; mask
			.byte 4 ; counter
			.byte 0,0,0,0,0,255,0,0,
			.byte 54,0,0,0,0,0,255,0,
			.byte 127,0,0,0,0,255,255,0,
			.byte 182,255,255,255,255,255,0,255,
			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile55:
			.byte 15 ; mask
			.byte 4 ; counter
			.byte 0,0,0,0,0,255,0,0,
			.byte 0,0,0,0,0,0,255,0,
			.byte 0,0,0,0,0,255,255,0,
			.byte 255,255,255,255,255,255,0,255,
			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile56:
			.byte 15 ; mask
			.byte 4 ; counter
			.byte 0,0,0,0,0,255,0,0,
			.byte 0,0,0,0,0,0,255,0,
			.byte 0,0,0,0,0,255,255,0,
			.byte 255,255,255,255,255,255,0,255,
			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile57:
			.byte 15 ; mask
			.byte 4 ; counter
			.byte 0,0,0,0,0,255,0,0,
			.byte 64,0,0,0,0,0,255,0,
			.byte 224,0,0,0,0,255,255,0,
			.byte 95,255,255,255,255,255,0,255,
			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile58:
			.byte 15 ; mask
			.byte 4 ; counter
			.byte 0,0,0,0,0,255,0,0,
			.byte 32,0,0,0,0,0,255,0,
			.byte 240,0,0,0,0,255,255,0,
			.byte 47,255,255,255,255,255,0,255,
			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile59:
			.byte 15 ; mask
			.byte 4 ; counter
			.byte 0,0,0,0,0,255,0,0,
			.byte 0,0,0,0,0,0,255,0,
			.byte 0,0,0,0,0,255,255,0,
			.byte 255,255,255,255,255,255,1,255,
			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile60:
			.byte 15 ; mask
			.byte 4 ; counter
			.byte 0,0,0,0,0,255,0,0,
			.byte 1,0,0,0,0,0,255,0,
			.byte 1,1,0,0,0,255,255,0,
			.byte 255,254,255,255,255,255,255,255,
			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile61:
			.byte 15 ; mask
			.byte 4 ; counter
			.byte 94,0,0,0,0,255,0,0,
			.byte 161,60,0,0,0,0,255,0,
			.byte 255,126,0,0,0,255,255,0,
			.byte 94,189,255,255,255,255,255,255,
			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile62:
			.byte 15 ; mask
			.byte 4 ; counter
			.byte 0,0,0,0,0,167,0,0,
			.byte 128,0,0,0,0,88,254,0,
			.byte 192,0,0,0,0,255,254,0,
			.byte 191,255,255,255,255,167,255,255,
			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile63:
			.byte 14 ; mask
			.byte 4 ; counter
			.byte 3,1,1,0,0,0,0,0,
			.byte 3,3,3,1,1,0,0,0,
			.byte 255,253,253,254,254,255,255,255,
			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile64:
			.byte 15 ; mask
			.byte 4 ; counter
			.byte 0,0,0,60,127,63,15,0,
			.byte 224,224,240,195,128,64,48,15,
			.byte 224,224,240,255,255,127,63,63,
			.byte 255,127,15,60,255,191,239,207,
			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile65:
			.byte 15 ; mask
			.byte 4 ; counter
			.byte 0,0,0,0,192,192,128,0,
			.byte 0,0,0,224,32,32,96,128,
			.byte 0,0,0,224,224,224,224,128,
			.byte 255,255,255,63,223,223,191,255,
			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile66:
			.byte 15 ; mask
			.byte 4 ; counter
			.byte 15,15,15,15,15,15,15,15,
			.byte 16,16,16,16,16,16,16,16,
			.byte 31,31,31,31,31,31,31,31,
			.byte 239,239,239,239,239,239,239,239,
			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile67:
			.byte 15 ; mask
			.byte 4 ; counter
			.byte 1,1,1,1,1,7,7,0,
			.byte 130,130,130,130,130,136,152,143,
			.byte 131,131,131,131,131,159,159,159,
			.byte 127,255,255,255,255,231,247,236,
			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile68:
			.byte 15 ; mask
			.byte 4 ; counter
			.byte 192,192,192,192,192,224,255,0,
			.byte 32,32,32,32,0,31,0,255,
			.byte 224,224,224,224,224,255,255,255,
			.byte 255,255,255,255,223,224,255,124,
			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile69:
			.byte 15 ; mask
			.byte 4 ; counter
			.byte 1,3,7,15,62,248,224,0,
			.byte 2,4,8,16,65,6,24,192,
			.byte 3,7,15,95,255,254,248,224,
			.byte 255,255,247,175,127,251,239,95,
			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile70:
			.byte 15 ; mask
			.byte 4 ; counter
			.byte 240,192,128,0,0,0,3,3,
			.byte 0,48,96,128,0,1,0,4,
			.byte 248,240,240,128,128,3,7,7,
			.byte 247,223,175,127,127,253,251,255,
			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile71:
			.byte 15 ; mask
			.byte 4 ; counter
			.byte 112,112,112,112,112,112,252,128,
			.byte 136,128,136,136,136,136,2,126,
			.byte 248,248,248,248,248,248,254,254,
			.byte 255,247,255,255,255,119,255,167,
			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile72:
			.byte 15 ; mask
			.byte 4 ; counter
			.byte 112,112,112,112,96,124,126,240,
			.byte 0,8,0,128,28,2,129,9,
			.byte 248,248,248,248,252,255,255,251,
			.byte 119,127,119,247,111,126,126,244,
			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile73:
			.byte 15 ; mask
			.byte 4 ; counter
			.byte 24,24,24,16,24,25,63,255,
			.byte 36,36,36,44,37,38,192,0,
			.byte 60,60,60,60,61,63,255,255,
			.byte 251,251,251,247,255,249,63,255,
			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile74:
			.byte 15 ; mask
			.byte 4 ; counter
			.byte 30,28,60,120,240,224,192,0,
			.byte 33,34,66,132,8,16,32,192,
			.byte 63,127,254,252,248,240,224,192,
			.byte 254,156,63,127,247,239,255,127,
			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile75:
			.byte 15 ; mask
			.byte 4 ; counter
			.byte 0,0,0,0,0,0,0,1,
			.byte 0,0,0,0,0,0,1,2,
			.byte 0,0,0,0,0,5,3,3,
			.byte 255,255,255,255,255,250,252,253,
			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile76:
			.byte 15 ; mask
			.byte 4 ; counter
			.byte 16,48,16,48,56,126,255,192,
			.byte 40,8,40,8,68,129,0,63,
			.byte 56,120,120,124,124,255,255,255,
			.byte 215,183,151,179,255,255,255,192,
			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile77:
			.byte 15 ; mask
			.byte 4 ; counter
			.byte 0,0,0,0,3,7,158,240,
			.byte 0,0,0,1,4,24,97,14,
			.byte 0,0,1,3,7,223,255,254,
			.byte 255,255,254,252,255,55,158,243,
			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile78:
			.byte 15 ; mask
			.byte 4 ; counter
			.byte 28,60,120,240,224,192,0,0,
			.byte 34,66,132,8,16,32,128,0,
			.byte 62,126,252,252,240,224,128,0,
			.byte 221,191,123,243,239,255,255,255,
			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile79:
			.byte 15 ; mask
			.byte 4 ; counter
			.byte 16,24,8,12,12,4,0,0,
			.byte 40,36,52,18,19,11,15,3,
			.byte 124,124,124,62,63,47,15,7,
			.byte 179,191,171,207,221,220,248,248,
			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile80:
			.byte 15 ; mask
			.byte 4 ; counter
			.byte 0,0,0,0,0,0,1,7,
			.byte 0,0,0,0,0,128,254,248,
			.byte 0,0,0,0,0,128,255,255,
			.byte 255,255,255,255,255,255,63,7,
			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile81:
			.byte 15 ; mask
			.byte 4 ; counter
			.byte 2,4,4,8,24,96,192,128,
			.byte 5,11,10,22,100,152,48,96,
			.byte 7,15,31,63,124,248,248,224,
			.byte 255,253,228,202,223,239,215,191,
			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile82:
			.byte 15 ; mask
			.byte 4 ; counter
			.byte 96,66,68,64,32,31,0,0,
			.byte 17,164,170,46,81,32,14,0,
			.byte 247,255,255,239,127,127,31,0,
			.byte 121,66,108,90,224,191,238,255,
			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile83:
			.byte 15 ; mask
			.byte 4 ; counter
			.byte 128,128,128,128,128,0,0,0,
			.byte 67,67,67,67,67,195,3,3,
			.byte 195,195,195,195,195,195,131,3,
			.byte 255,255,255,191,191,127,127,255,
			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile84:
			.byte 14 ; mask
			.byte 4 ; counter
			.byte 224,224,224,224,224,224,224,224,
			.byte 224,224,224,224,224,224,224,224,
			.byte 255,255,255,255,255,255,255,255,
			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile85:
			.byte 15 ; mask
			.byte 4 ; counter
			.byte 7,7,15,7,15,15,15,15,
			.byte 56,56,48,56,16,16,16,16,
			.byte 63,63,63,63,31,31,31,31,
			.byte 231,231,239,231,239,239,239,239,
			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile86:
			.byte 15 ; mask
			.byte 4 ; counter
			.byte 1,1,1,1,1,1,1,1,
			.byte 130,130,130,130,130,130,130,130,
			.byte 131,131,131,131,131,131,131,131,
			.byte 255,255,255,255,255,255,127,255,
			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile87:
			.byte 13 ; mask
			.byte 4 ; counter
			.byte 192,192,192,192,192,192,192,192,
			.byte 192,192,192,192,192,192,192,192,
			.byte 255,255,255,255,255,255,255,255,
			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile88:
			.byte 12 ; mask
			.byte 4 ; counter
			.byte 0,0,0,0,0,0,0,1,
			.byte 255,255,255,255,255,255,255,254,
			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile89:
			.byte 15 ; mask
			.byte 4 ; counter
			.byte 28,28,28,28,60,56,120,112,
			.byte 32,32,32,32,0,68,132,136,
			.byte 60,60,60,60,124,124,252,248,
			.byte 255,255,255,255,191,251,255,119,
			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile90:
			.byte 15 ; mask
			.byte 4 ; counter
			.byte 112,112,112,112,112,112,112,112,
			.byte 136,136,136,136,128,136,128,128,
			.byte 248,248,248,248,248,248,248,248,
			.byte 255,255,255,255,247,255,247,247,
			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile91:
			.byte 15 ; mask
			.byte 4 ; counter
			.byte 112,112,112,112,112,112,112,112,
			.byte 136,136,8,8,8,8,8,8,
			.byte 248,248,248,248,248,248,248,248,
			.byte 255,255,127,127,127,127,127,127,
			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile92:
			.byte 15 ; mask
			.byte 4 ; counter
			.byte 24,8,24,24,24,24,24,24,
			.byte 36,52,36,36,36,36,36,36,
			.byte 60,60,60,60,60,60,60,60,
			.byte 255,235,251,251,251,251,251,251,
			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile93:
			.byte 15 ; mask
			.byte 4 ; counter
			.byte 0,0,0,1,1,3,7,15,
			.byte 0,0,1,2,6,4,8,16,
			.byte 0,0,3,3,7,15,15,31,
			.byte 255,255,253,255,253,243,247,255,
			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile94:
			.byte 15 ; mask
			.byte 4 ; counter
			.byte 60,120,240,224,224,192,128,0,
			.byte 66,132,8,16,16,32,64,128,
			.byte 254,252,248,248,240,224,192,128,
			.byte 63,123,247,231,255,255,255,127,
			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile95:
			.byte 15 ; mask
			.byte 4 ; counter
			.byte 24,16,16,16,16,16,16,16,
			.byte 32,40,40,40,40,40,40,40,
			.byte 56,56,56,56,56,56,56,56,
			.byte 223,215,215,215,215,215,215,215,
			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile96:
			.byte 15 ; mask
			.byte 4 ; counter
			.byte 14,6,14,6,15,14,14,30,
			.byte 17,25,17,25,16,17,17,1,
			.byte 31,31,31,31,31,31,31,63,
			.byte 239,246,254,246,255,254,238,223,
			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile97:
			.byte 15 ; mask
			.byte 4 ; counter
			.byte 0,48,48,16,48,16,16,16,
			.byte 96,64,64,96,72,104,104,40,
			.byte 96,112,112,112,120,120,124,124,
			.byte 223,255,255,223,247,215,219,147,
			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile98:
			.byte 15 ; mask
			.byte 4 ; counter
			.byte 0,0,0,0,127,18,0,0,
			.byte 0,0,0,127,0,45,0,0,
			.byte 0,0,0,127,127,63,0,0,
			.byte 255,255,255,255,255,210,255,255,
			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile99:
			.byte 15 ; mask
			.byte 4 ; counter
			.byte 0,0,0,0,0,0,0,2,
			.byte 0,0,0,128,248,243,3,1,
			.byte 0,0,0,224,248,251,11,7,
			.byte 255,255,255,159,15,22,244,251,
			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile100:
			.byte 15 ; mask
			.byte 4 ; counter
			.byte 0,0,0,0,0,0,0,25,
			.byte 0,0,0,0,0,128,30,102,
			.byte 0,0,0,0,0,128,191,255,
			.byte 255,255,255,255,255,255,64,89,
			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile101:
			.byte 15 ; mask
			.byte 4 ; counter
			.byte 0,0,0,0,0,0,0,128,
			.byte 3,3,3,3,3,3,3,3,
			.byte 3,3,3,3,3,3,3,195,
			.byte 254,254,254,255,254,255,254,191,
			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile102:
			.byte 14 ; mask
			.byte 4 ; counter
			.byte 224,224,224,224,224,224,224,224,
			.byte 224,224,224,224,224,224,224,224,
			.byte 255,223,255,255,255,223,255,255,
			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile103:
			.byte 15 ; mask
			.byte 4 ; counter
			.byte 0,0,0,0,0,2,0,3,
			.byte 252,126,126,127,63,61,63,60,
			.byte 254,254,127,127,63,63,63,63,
			.byte 129,67,192,193,193,226,224,227,
			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile104:
			.byte 15 ; mask
			.byte 4 ; counter
			.byte 0,7,3,1,1,1,1,1,
			.byte 15,8,4,2,2,2,2,130,
			.byte 31,31,15,15,3,131,131,131,
			.byte 224,231,243,243,255,127,127,255,
			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile105:
			.byte 15 ; mask
			.byte 4 ; counter
			.byte 176,225,128,128,0,128,0,192,
			.byte 79,30,65,64,192,64,192,0,
			.byte 255,255,227,192,192,192,192,192,
			.byte 179,225,157,191,63,191,63,255,
			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile106:
			.byte 15 ; mask
			.byte 4 ; counter
			.byte 0,128,32,0,0,0,0,0,
			.byte 128,124,223,31,7,3,0,0,
			.byte 240,254,255,63,15,3,0,0,
			.byte 143,141,161,208,244,255,255,255,
			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile107:
			.byte 15 ; mask
			.byte 4 ; counter
			.byte 0,0,0,0,128,96,16,24,
			.byte 0,0,128,192,112,152,232,100,
			.byte 0,0,128,224,240,248,252,124,
			.byte 255,255,255,95,159,111,147,223,
			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile108:
			.byte 15 ; mask
			.byte 4 ; counter
			.byte 3,7,15,28,56,56,48,112,
			.byte 4,8,16,35,68,68,72,8,
			.byte 7,31,63,63,124,124,248,248,
			.byte 251,231,207,221,251,191,55,119,
			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile109:
			.byte 15 ; mask
			.byte 4 ; counter
			.byte 248,254,15,3,1,0,0,0,
			.byte 7,1,240,4,2,1,0,0,
			.byte 255,255,255,143,7,1,1,0,
			.byte 251,254,111,119,251,254,254,255,
			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile110:
			.byte 15 ; mask
			.byte 4 ; counter
			.byte 0,0,0,192,192,224,224,112,
			.byte 0,128,192,0,32,16,16,128,
			.byte 0,192,192,192,224,240,240,248,
			.byte 255,191,127,255,223,255,239,119,
			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile111:
			.byte 15 ; mask
			.byte 4 ; counter
			.byte 56,62,24,24,8,8,24,8,
			.byte 71,65,39,36,52,52,36,52,
			.byte 127,127,63,62,60,60,60,60,
			.byte 184,254,251,253,239,235,255,235,
			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile112:
			.byte 15 ; mask
			.byte 4 ; counter
			.byte 0,0,0,1,3,7,15,30,
			.byte 0,0,1,2,4,8,16,33,
			.byte 0,0,3,7,7,15,63,63,
			.byte 255,255,253,251,255,255,207,223,
			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile113:
			.byte 15 ; mask
			.byte 4 ; counter
			.byte 28,88,216,152,152,152,24,24,
			.byte 99,164,36,100,100,32,160,32,
			.byte 127,252,252,252,252,248,184,56,
			.byte 223,219,255,191,255,159,223,223,
			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile114:
			.byte 15 ; mask
			.byte 4 ; counter
			.byte 8,3,0,0,0,0,0,0,
			.byte 247,28,7,1,0,0,0,0,
			.byte 255,63,7,1,0,0,0,0,
			.byte 203,211,252,254,255,255,255,255,
			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile115:
			.byte 15 ; mask
			.byte 4 ; counter
			.byte 0,0,192,96,48,56,28,12,
			.byte 0,192,32,144,200,68,34,50,
			.byte 128,192,240,248,252,126,62,63,
			.byte 127,127,239,103,179,249,223,236,
			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile116:
			.byte 15 ; mask
			.byte 4 ; counter
			.byte 0,2,1,2,0,0,32,0,
			.byte 3,5,2,1,3,0,0,96,
			.byte 3,7,3,3,3,0,96,96,
			.byte 254,250,253,254,253,255,191,223,
			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile117:
			.byte 15 ; mask
			.byte 4 ; counter
			.byte 188,192,128,0,0,0,0,0,
			.byte 67,63,65,128,0,0,0,0,
			.byte 255,255,193,128,0,0,0,0,
			.byte 188,200,255,255,255,255,255,255,
			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile118:
			.byte 14 ; mask
			.byte 4 ; counter
			.byte 192,224,240,112,24,0,0,0,
			.byte 224,240,248,248,56,0,0,0,
			.byte 223,47,151,71,223,255,255,255,
			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile119:
			.byte 15 ; mask
			.byte 4 ; counter
			.byte 4,3,1,3,3,0,0,0,
			.byte 11,12,6,4,0,3,3,3,
			.byte 31,15,15,7,3,3,3,3,
			.byte 228,251,241,255,255,252,252,254,
			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile120:
			.byte 15 ; mask
			.byte 4 ; counter
			.byte 208,224,192,128,128,0,0,0,
			.byte 44,16,32,96,96,224,224,224,
			.byte 252,248,240,224,224,224,224,224,
			.byte 215,231,207,191,255,255,127,255,
			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile121:
			.byte 14 ; mask
			.byte 4 ; counter
			.byte 7,15,63,28,112,96,0,0,
			.byte 7,31,63,127,124,96,0,0,
			.byte 255,239,255,156,243,255,255,255,
			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile122:
			.byte 14 ; mask
			.byte 4 ; counter
			.byte 254,255,255,31,15,3,1,0,
			.byte 255,255,255,255,31,15,7,3,
			.byte 6,192,224,24,236,242,249,252,
			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile123:
			.byte 14 ; mask
			.byte 4 ; counter
			.byte 0,0,192,224,240,240,248,248,
			.byte 0,128,192,224,240,240,248,252,
			.byte 255,127,255,63,31,31,15,131,
			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile124:
			.byte 14 ; mask
			.byte 4 ; counter
			.byte 1,0,0,0,0,0,0,0,
			.byte 1,0,0,0,0,0,0,0,
			.byte 255,255,255,255,255,255,255,255,
			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile125:
			.byte 14 ; mask
			.byte 4 ; counter
			.byte 255,0,0,0,0,0,0,0,
			.byte 255,0,0,0,0,0,0,0,
			.byte 40,255,255,255,255,255,255,255,
			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile126:
			.byte 14 ; mask
			.byte 4 ; counter
			.byte 255,0,0,0,0,0,0,0,
			.byte 255,0,0,0,0,0,0,0,
			.byte 0,255,255,255,255,255,255,255,
			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile127:
			.byte 15 ; mask
			.byte 4 ; counter
			.byte 94,0,0,0,0,0,0,0,
			.byte 161,7,3,1,0,0,0,0,
			.byte 255,7,3,1,0,0,0,0,
			.byte 94,252,254,255,255,255,255,255,
			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile128:
			.byte 15 ; mask
			.byte 4 ; counter
			.byte 0,64,0,16,0,0,0,0,
			.byte 224,176,248,232,248,124,60,28,
			.byte 224,240,248,248,248,124,60,28,
			.byte 63,95,15,31,135,199,227,227,
			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile129:
			.byte 15 ; mask
			.byte 4 ; counter
			.byte 0,0,0,0,0,15,63,252,
			.byte 0,0,0,0,15,48,64,3,
			.byte 0,0,0,0,15,63,127,255,
			.byte 255,255,255,255,252,239,191,253,
			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile130:
			.byte 15 ; mask
			.byte 4 ; counter
			.byte 0,0,0,0,0,128,0,0,
			.byte 0,0,0,0,224,112,200,4,
			.byte 0,0,0,0,224,240,248,12,
			.byte 255,255,255,255,63,159,79,247,
			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile131:
			.byte 14 ; mask
			.byte 4 ; counter
			.byte 0,0,0,0,0,0,0,240,
			.byte 0,0,0,0,0,0,0,252,
			.byte 255,255,255,255,255,255,255,243,
			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile132:
			.byte 15 ; mask
			.byte 4 ; counter
			.byte 0,0,0,0,1,0,0,0,
			.byte 0,0,0,1,2,3,3,0,
			.byte 0,0,0,1,3,3,3,0,
			.byte 255,255,255,254,255,252,254,255,
			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile133:
			.byte 15 ; mask
			.byte 4 ; counter
			.byte 0,0,0,250,253,4,2,0,
			.byte 0,0,254,5,2,251,253,3,
			.byte 0,0,254,255,255,255,255,3,
			.byte 255,255,3,251,253,4,114,252,
			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile134:
			.byte 15 ; mask
			.byte 4 ; counter
			.byte 0,0,0,0,0,128,0,0,
			.byte 0,0,0,0,128,64,224,255,
			.byte 0,0,0,0,128,192,224,255,
			.byte 255,255,255,255,255,255,63,2,
			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile135:
			.byte 14 ; mask
			.byte 4 ; counter
			.byte 0,0,0,0,0,0,0,255,
			.byte 0,0,0,0,0,0,0,255,
			.byte 255,255,255,255,255,255,255,255,
			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tile136:
			.byte 14 ; mask
			.byte 4 ; counter
			.byte 0,0,0,0,0,0,0,255,
			.byte 0,0,0,0,0,0,0,255,
			.byte 255,255,255,255,255,255,255,255,
