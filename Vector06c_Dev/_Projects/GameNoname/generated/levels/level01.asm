; sources\levels\art\sprites_tiles_lv01.png
level01_palette_sprites_tiles_lv01:
			.byte %01001010, %00000001, %01011100, %00011010, 
			.byte %11100100, %11111101, %01110111, %01011111, 
			.byte %01000010, %01001011, %01001100, %11111111, 
			.byte %11111111, %11101011, %00001010, %01011011, 


			.byte 0,0 ; safety pair of bytes to support a stack renderer
level01_startPos:
			.byte 160, 48

			.byte 0,0 ; safety pair of bytes to support a stack renderer
level01_roomsAddr:
			.word level01_room00, 0, level01_room01, 0, level01_room02, 

			.byte 0,0 ; safety pair of bytes to support a stack renderer
level01_tilesAddr:
			.word sprites_tiles_lv01_tile0, 0, sprites_tiles_lv01_tile1, 0, sprites_tiles_lv01_tile2, 0, sprites_tiles_lv01_tile3, 0, sprites_tiles_lv01_tile4, 0, sprites_tiles_lv01_tile5, 0, sprites_tiles_lv01_tile6, 0, sprites_tiles_lv01_tile7, 0, sprites_tiles_lv01_tile8, 0, sprites_tiles_lv01_tile9, 0, sprites_tiles_lv01_tile10, 0, sprites_tiles_lv01_tile11, 0, sprites_tiles_lv01_tile12, 0, sprites_tiles_lv01_tile13, 0, sprites_tiles_lv01_tile14, 0, sprites_tiles_lv01_tile15, 0, sprites_tiles_lv01_tile16, 0, sprites_tiles_lv01_tile17, 0, sprites_tiles_lv01_tile18, 0, sprites_tiles_lv01_tile19, 0, sprites_tiles_lv01_tile20, 0, sprites_tiles_lv01_tile21, 0, sprites_tiles_lv01_tile22, 0, sprites_tiles_lv01_tile23, 0, sprites_tiles_lv01_tile24, 0, sprites_tiles_lv01_tile25, 0, sprites_tiles_lv01_tile26, 0, sprites_tiles_lv01_tile27, 0, sprites_tiles_lv01_tile28, 0, sprites_tiles_lv01_tile29, 0, sprites_tiles_lv01_tile30, 0, sprites_tiles_lv01_tile31, 0, sprites_tiles_lv01_tile32, 0, sprites_tiles_lv01_tile33, 

			.byte 0,0 ; safety pair of bytes to support a stack renderer
; sources\levels\level01_room00.tmj
level01_room00:
			.byte 0, 0, 0, 0, 0, 28, 29, 29, 30, 0, 0, 0, 0, 0, 0, 0, 
			.byte 0, 0, 0, 0, 0, 10, 7, 7, 13, 0, 0, 0, 0, 0, 0, 0, 
			.byte 0, 26, 20, 20, 20, 20, 7, 7, 20, 20, 20, 20, 20, 27, 0, 0, 
			.byte 0, 10, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 13, 0, 0, 
			.byte 0, 10, 7, 7, 7, 7, 7, 7, 7, 7, 7, 25, 7, 13, 0, 0, 
			.byte 0, 10, 5, 5, 8, 23, 7, 7, 24, 5, 5, 8, 5, 9, 0, 0, 
			.byte 0, 10, 7, 7, 22, 7, 7, 7, 7, 7, 7, 13, 0, 0, 0, 0, 
			.byte 0, 10, 7, 7, 7, 7, 7, 7, 22, 7, 7, 13, 0, 0, 0, 0, 
			.byte 19, 20, 7, 7, 7, 7, 7, 7, 7, 7, 7, 20, 20, 20, 20, 21, 
			.byte 16, 7, 7, 7, 7, 18, 7, 7, 7, 7, 7, 7, 7, 7, 7, 17, 
			.byte 16, 7, 7, 7, 7, 7, 7, 5, 7, 7, 7, 7, 7, 7, 7, 17, 
			.byte 14, 8, 7, 7, 5, 7, 7, 7, 7, 7, 7, 5, 8, 5, 5, 15, 
			.byte 0, 10, 11, 7, 7, 7, 7, 7, 7, 12, 7, 13, 0, 0, 0, 0, 
			.byte 0, 4, 5, 6, 5, 5, 7, 7, 5, 8, 5, 9, 0, 0, 0, 0, 
			.byte 0, 0, 0, 0, 0, 1, 2, 2, 3, 0, 0, 0, 0, 0, 0, 0, 

			.byte 0,0 ; safety pair of bytes to support a stack renderer
; sources\levels\level01_room00.tmj
level01_room00_tilesData:
			.byte 0, 0, 0, 0, 0, 255, 20, 20, 255, 0, 0, 0, 0, 0, 0, 0, 
			.byte 0, 0, 0, 0, 0, 255, 0, 0, 255, 0, 0, 0, 0, 0, 0, 0, 
			.byte 0, 255, 255, 255, 255, 255, 3, 0, 255, 255, 255, 255, 255, 255, 0, 0, 
			.byte 0, 255, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 255, 0, 0, 
			.byte 0, 255, 0, 0, 0, 0, 0, 0, 0, 0, 3, 0, 0, 255, 0, 0, 
			.byte 0, 255, 255, 255, 255, 255, 0, 0, 255, 255, 255, 255, 255, 255, 0, 0, 
			.byte 0, 255, 0, 0, 255, 0, 0, 0, 0, 0, 0, 255, 0, 0, 0, 0, 
			.byte 0, 255, 0, 0, 0, 0, 0, 0, 255, 0, 0, 255, 0, 0, 0, 0, 
			.byte 255, 255, 0, 0, 0, 0, 0, 0, 0, 0, 0, 255, 255, 255, 255, 255, 
			.byte 20, 3, 0, 0, 0, 20, 0, 0, 0, 0, 0, 0, 0, 0, 0, 12, 
			.byte 20, 0, 0, 0, 0, 0, 0, 255, 0, 0, 3, 0, 0, 0, 0, 12, 
			.byte 255, 255, 0, 3, 255, 0, 0, 0, 0, 0, 0, 255, 255, 255, 255, 255, 
			.byte 0, 255, 0, 0, 0, 0, 0, 3, 0, 255, 0, 255, 0, 0, 0, 0, 
			.byte 0, 255, 255, 255, 255, 255, 0, 0, 255, 255, 255, 255, 0, 0, 0, 0, 
			.byte 0, 0, 0, 0, 0, 255, 20, 20, 255, 0, 0, 0, 0, 0, 0, 0, 

			.byte 0,0 ; safety pair of bytes to support a stack renderer
; sources\levels\level01_room01.tmj
level01_room01:
			.byte 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
			.byte 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
			.byte 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
			.byte 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
			.byte 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
			.byte 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
			.byte 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
			.byte 0, 0, 26, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 27, 0, 
			.byte 20, 20, 20, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 33, 13, 0, 
			.byte 16, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 13, 0, 
			.byte 16, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 32, 13, 0, 
			.byte 5, 5, 7, 7, 7, 7, 7, 7, 7, 7, 7, 5, 5, 5, 9, 0, 
			.byte 0, 10, 31, 7, 7, 7, 7, 7, 7, 7, 32, 13, 0, 0, 0, 0, 
			.byte 0, 4, 5, 5, 5, 12, 5, 5, 5, 12, 5, 9, 0, 0, 0, 0, 
			.byte 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 

			.byte 0,0 ; safety pair of bytes to support a stack renderer
; sources\levels\level01_room01.tmj
level01_room01_tilesData:
			.byte 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
			.byte 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
			.byte 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
			.byte 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
			.byte 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
			.byte 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
			.byte 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
			.byte 0, 0, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 0, 
			.byte 255, 255, 255, 0, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 255, 0, 
			.byte 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3, 0, 3, 0, 255, 0, 
			.byte 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 255, 0, 
			.byte 255, 255, 0, 0, 0, 0, 0, 0, 3, 0, 0, 255, 255, 255, 255, 0, 
			.byte 0, 255, 0, 0, 3, 0, 0, 0, 0, 0, 0, 255, 0, 0, 0, 0, 
			.byte 0, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 0, 0, 0, 0, 
			.byte 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 

			.byte 0,0 ; safety pair of bytes to support a stack renderer
; sources\levels\level01_room02.tmj
level01_room02:
			.byte 0, 0, 0, 0, 0, 10, 29, 29, 13, 0, 0, 0, 0, 0, 0, 0, 
			.byte 0, 0, 0, 0, 0, 10, 7, 7, 13, 0, 0, 0, 0, 0, 0, 0, 
			.byte 0, 26, 20, 20, 20, 20, 7, 7, 20, 20, 20, 20, 20, 27, 0, 0, 
			.byte 0, 10, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 13, 0, 0, 
			.byte 0, 10, 7, 7, 7, 7, 7, 7, 7, 7, 7, 25, 31, 13, 0, 0, 
			.byte 0, 10, 7, 7, 7, 23, 24, 5, 27, 7, 7, 5, 5, 9, 0, 0, 
			.byte 0, 4, 5, 7, 7, 7, 7, 7, 13, 7, 7, 13, 0, 0, 0, 0, 
			.byte 0, 0, 10, 7, 7, 7, 7, 7, 13, 7, 7, 20, 20, 20, 27, 0, 
			.byte 0, 26, 8, 7, 7, 7, 7, 7, 13, 7, 7, 7, 7, 7, 8, 5, 
			.byte 0, 10, 7, 7, 7, 7, 7, 7, 13, 7, 7, 7, 7, 7, 7, 17, 
			.byte 0, 10, 7, 7, 12, 8, 5, 5, 9, 7, 7, 7, 7, 7, 7, 17, 
			.byte 0, 10, 7, 7, 7, 7, 7, 7, 7, 7, 7, 5, 5, 5, 5, 5, 
			.byte 0, 10, 11, 7, 7, 7, 7, 7, 7, 7, 32, 13, 0, 0, 0, 0, 
			.byte 0, 4, 5, 8, 12, 5, 7, 7, 8, 22, 5, 9, 0, 0, 0, 0, 
			.byte 0, 0, 0, 0, 0, 10, 2, 2, 13, 0, 0, 0, 0, 0, 0, 0, 

			.byte 0,0 ; safety pair of bytes to support a stack renderer
; sources\levels\level01_room02.tmj
level01_room02_tilesData:
			.byte 0, 0, 0, 0, 0, 255, 4, 4, 255, 0, 0, 0, 0, 0, 0, 0, 
			.byte 0, 0, 0, 0, 0, 255, 0, 0, 255, 0, 0, 0, 0, 0, 0, 0, 
			.byte 0, 255, 255, 255, 255, 255, 0, 0, 255, 255, 255, 255, 255, 255, 0, 0, 
			.byte 0, 255, 0, 0, 3, 0, 0, 0, 0, 0, 3, 0, 0, 255, 0, 0, 
			.byte 0, 255, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 255, 0, 0, 
			.byte 0, 255, 0, 0, 3, 255, 255, 255, 255, 0, 0, 255, 255, 255, 0, 0, 
			.byte 0, 255, 255, 0, 0, 0, 3, 0, 255, 0, 0, 255, 0, 0, 0, 0, 
			.byte 0, 0, 255, 0, 3, 0, 0, 0, 255, 0, 0, 255, 255, 255, 255, 0, 
			.byte 0, 255, 255, 0, 0, 0, 0, 3, 255, 0, 0, 0, 0, 0, 255, 255, 
			.byte 0, 255, 0, 0, 3, 0, 0, 0, 255, 0, 0, 0, 3, 0, 0, 4, 
			.byte 0, 255, 0, 0, 255, 255, 255, 255, 255, 0, 3, 0, 0, 0, 0, 4, 
			.byte 0, 255, 0, 0, 0, 0, 0, 0, 0, 0, 0, 255, 255, 255, 255, 255, 
			.byte 0, 255, 0, 0, 0, 0, 0, 0, 3, 0, 0, 255, 0, 0, 0, 0, 
			.byte 0, 255, 255, 255, 255, 255, 0, 0, 255, 255, 255, 255, 0, 0, 0, 0, 
			.byte 0, 0, 0, 0, 0, 255, 4, 4, 255, 0, 0, 0, 0, 0, 0, 0, 
; sources\levels\art\sprites_tiles_lv01.png
sprites_tiles_lv01_tiles:
			.byte 0,0 ; safety pair of bytes to support a stack renderer
sprites_tiles_lv01_tile0:
			.byte 8 ; mask
			.byte 4 ; counter
			.byte 255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,
			.byte 0,0 ; safety pair of bytes to support a stack renderer
sprites_tiles_lv01_tile1:
			.byte 13 ; mask
			.byte 4 ; counter
			.byte 1,1,1,1,1,1,1,0,1,0,0,0,0,0,0,0,0,0,0,0,4,0,4,1,1,5,1,5,4,5,5,253,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,64,128,96,128,88,8,224,168,168,40,120,248,248,0,255,255,255,255,255,255,255,255,255,255,255,255,255,255,254,255,255,247,191,123,31,115,167,210,10,22,2,6,6,6,6,254,
			.byte 0,0 ; safety pair of bytes to support a stack renderer
sprites_tiles_lv01_tile2:
			.byte 9 ; mask
			.byte 4 ; counter
			.byte 128,0,8,4,24,0,0,0,0,0,0,0,0,0,0,0,0,0,16,0,0,0,0,0,0,0,0,0,0,0,0,0,0,8,16,64,160,10,20,124,43,66,230,223,223,126,255,255,255,255,235,255,127,255,171,206,121,8,154,16,34,72,0,0,
			.byte 0,0 ; safety pair of bytes to support a stack renderer
sprites_tiles_lv01_tile3:
			.byte 13 ; mask
			.byte 4 ; counter
			.byte 190,160,128,160,160,128,128,32,32,32,160,0,0,0,128,0,0,0,128,0,0,0,0,0,0,0,128,128,128,0,128,128,0,31,31,15,30,30,13,3,8,24,1,14,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,126,96,64,96,96,64,64,104,102,231,108,225,231,245,127,255,255,255,255,255,255,255,255,255,127,127,255,255,255,127,255,255,
			.byte 0,0 ; safety pair of bytes to support a stack renderer
sprites_tiles_lv01_tile4:
			.byte 13 ; mask
			.byte 4 ; counter
			.byte 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,253,5,4,5,4,5,4,253,252,5,4,7,4,5,4,253,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,248,248,248,248,248,248,0,0,248,248,248,248,248,248,0,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,7,7,7,7,7,7,255,255,7,7,7,7,7,7,254,
			.byte 0,0 ; safety pair of bytes to support a stack renderer
sprites_tiles_lv01_tile5:
			.byte 13 ; mask
			.byte 4 ; counter
			.byte 255,0,0,126,60,0,63,127,63,0,63,127,128,128,128,255,175,1,1,1,254,252,0,252,254,252,0,124,254,0,0,255,0,0,0,0,0,0,0,0,0,0,0,0,127,127,127,0,0,254,254,254,0,0,0,0,0,0,0,0,0,0,0,0,0,255,129,255,189,31,191,127,63,128,63,127,128,128,128,255,175,1,1,1,254,252,0,252,255,252,249,124,255,1,255,0,
			.byte 0,0 ; safety pair of bytes to support a stack renderer
sprites_tiles_lv01_tile6:
			.byte 15 ; mask
			.byte 4 ; counter
			.byte 255,0,0,126,56,0,0,64,0,0,0,0,152,128,128,240,15,1,1,25,8,0,0,0,2,0,0,28,126,0,0,255,0,0,0,0,1,7,31,31,31,31,31,63,39,48,15,0,0,240,12,228,244,248,248,248,248,248,224,128,0,0,0,0,0,0,0,0,1,7,31,31,31,31,31,31,31,0,0,0,0,0,0,248,248,248,248,248,248,248,224,128,0,0,0,0,0,255,129,255,190,24,163,103,39,167,39,71,223,255,245,255,255,207,255,251,234,228,228,228,231,196,25,124,255,1,255,0,
			.byte 0,0 ; safety pair of bytes to support a stack renderer
sprites_tiles_lv01_tile7:
			.byte 1 ; mask
			.byte 4 ; counter
			.byte 128,0,8,4,24,0,0,0,0,64,64,128,0,0,0,0,0,64,176,8,0,0,0,0,0,0,0,0,0,0,0,0,
			.byte 0,0 ; safety pair of bytes to support a stack renderer
sprites_tiles_lv01_tile8:
			.byte 13 ; mask
			.byte 4 ; counter
			.byte 255,0,0,127,63,0,49,123,49,0,63,127,128,128,128,255,175,1,1,1,254,252,0,252,254,252,0,0,128,0,0,255,0,0,0,0,0,0,0,0,0,0,0,0,127,127,127,0,0,254,254,254,0,0,0,0,0,0,0,0,0,0,0,0,0,255,128,255,191,31,177,123,49,128,63,127,128,128,128,255,175,1,1,1,254,252,0,252,255,252,249,66,215,111,255,0,
			.byte 0,0 ; safety pair of bytes to support a stack renderer
sprites_tiles_lv01_tile9:
			.byte 13 ; mask
			.byte 4 ; counter
			.byte 191,32,32,96,160,32,32,191,63,160,160,32,160,32,160,191,0,128,128,128,128,128,128,128,128,128,128,128,128,128,128,128,0,31,31,31,31,31,31,0,0,31,31,31,31,31,31,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,127,224,224,224,224,224,224,255,255,224,224,224,224,224,224,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,
			.byte 0,0 ; safety pair of bytes to support a stack renderer
sprites_tiles_lv01_tile10:
			.byte 13 ; mask
			.byte 4 ; counter
			.byte 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,253,5,5,5,5,5,5,5,5,5,5,5,5,5,5,253,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,248,248,248,248,248,248,248,248,248,248,248,248,248,248,0,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,254,6,6,6,6,6,6,6,6,6,6,6,6,6,6,254,
			.byte 0,0 ; safety pair of bytes to support a stack renderer
sprites_tiles_lv01_tile11:
			.byte 15 ; mask
			.byte 4 ; counter
			.byte 0,0,0,0,0,8,6,32,50,78,66,80,40,80,96,64,0,0,0,0,0,0,96,0,0,0,64,0,0,0,0,0,0,0,0,8,16,16,32,1,0,0,9,4,0,0,0,0,0,0,0,0,0,0,144,64,128,128,32,0,0,0,0,0,0,0,0,0,0,8,6,32,50,78,66,80,40,80,96,64,0,0,0,0,0,0,96,0,0,0,64,0,0,0,0,0,0,0,8,20,40,46,95,118,114,255,230,251,252,248,240,224,0,0,0,0,0,240,104,176,64,96,208,96,0,0,0,0,
			.byte 0,0 ; safety pair of bytes to support a stack renderer
sprites_tiles_lv01_tile12:
			.byte 15 ; mask
			.byte 4 ; counter
			.byte 255,0,0,126,60,0,60,124,60,0,56,120,128,128,128,255,175,1,1,1,14,12,0,28,30,28,0,60,254,0,0,255,0,0,0,0,0,0,1,1,0,1,2,2,1,0,0,0,0,0,0,192,32,32,192,128,64,64,128,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,124,127,127,0,0,254,254,30,0,0,0,0,0,0,0,0,0,0,0,0,0,255,129,255,188,29,190,126,61,130,62,126,131,128,128,255,175,1,1,161,94,92,96,220,127,60,89,188,255,1,255,0,
			.byte 0,0 ; safety pair of bytes to support a stack renderer
sprites_tiles_lv01_tile13:
			.byte 13 ; mask
			.byte 4 ; counter
			.byte 191,160,160,160,160,160,160,160,160,160,160,160,160,160,160,191,128,128,128,128,128,128,128,128,128,128,128,128,128,128,128,128,0,31,31,31,31,31,31,31,31,31,31,31,31,31,31,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,127,96,96,96,96,96,96,96,96,96,96,96,96,96,96,127,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,
			.byte 0,0 ; safety pair of bytes to support a stack renderer
sprites_tiles_lv01_tile14:
			.byte 13 ; mask
			.byte 4 ; counter
			.byte 0,0,0,4,0,0,0,0,23,0,0,7,0,0,0,9,167,1,1,1,246,152,0,140,126,188,0,100,22,0,0,247,0,0,0,0,0,0,0,0,0,0,0,0,2,1,0,0,0,158,62,46,0,0,0,0,0,0,0,0,0,0,0,0,254,215,248,239,221,191,255,238,223,246,244,255,253,252,255,253,167,65,129,65,246,216,0,204,127,188,161,100,247,1,55,0,
			.byte 0,0 ; safety pair of bytes to support a stack renderer
sprites_tiles_lv01_tile15:
			.byte 13 ; mask
			.byte 4 ; counter
			.byte 191,0,0,94,60,0,39,121,60,0,62,126,128,128,128,251,128,0,0,0,192,160,0,128,144,224,0,32,192,0,0,132,0,0,0,0,0,0,0,0,0,0,0,0,119,55,126,0,0,0,160,4,0,0,0,0,0,0,0,0,0,0,0,0,0,255,129,222,189,6,167,123,60,128,62,126,128,128,128,251,239,63,75,187,223,175,91,219,215,255,255,119,203,31,255,51,
			.byte 0,0 ; safety pair of bytes to support a stack renderer
sprites_tiles_lv01_tile16:
			.byte 9 ; mask
			.byte 4 ; counter
			.byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,64,16,8,0,0,0,0,0,0,0,0,0,0,0,0,215,253,238,252,248,174,234,254,239,215,252,255,253,255,235,255,144,32,160,128,34,88,16,32,72,0,8,162,96,64,160,160,
			.byte 0,0 ; safety pair of bytes to support a stack renderer
sprites_tiles_lv01_tile17:
			.byte 9 ; mask
			.byte 4 ; counter
			.byte 128,0,8,0,24,0,0,0,0,64,64,128,0,0,0,0,0,64,32,0,0,0,0,0,0,0,0,0,0,0,0,0,10,0,4,4,1,5,2,4,21,0,0,0,0,0,0,3,135,39,159,223,55,219,95,187,43,127,95,159,31,223,187,111,
			.byte 0,0 ; safety pair of bytes to support a stack renderer
sprites_tiles_lv01_tile18:
			.byte 15 ; mask
			.byte 4 ; counter
			.byte 0,0,24,0,0,0,0,0,0,0,24,0,0,0,0,0,0,0,0,0,0,24,0,0,0,0,0,0,0,24,0,0,0,0,0,0,63,0,0,0,0,0,0,0,63,0,0,24,24,0,0,252,0,0,0,0,0,0,0,252,0,0,0,0,24,24,0,63,39,24,24,24,24,24,0,63,39,24,24,24,24,24,24,228,252,0,24,24,24,24,24,228,252,0,24,24,231,231,255,192,239,231,231,231,231,231,255,192,239,0,0,24,24,0,0,247,3,255,231,231,231,231,231,247,3,255,231,231,
			.byte 0,0 ; safety pair of bytes to support a stack renderer
sprites_tiles_lv01_tile19:
			.byte 13 ; mask
			.byte 4 ; counter
			.byte 0,0,0,0,0,0,0,9,0,0,0,0,0,0,0,1,207,0,127,3,1,1,1,1,189,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,9,22,11,0,3,0,0,0,0,0,0,124,150,238,46,222,0,0,0,0,0,0,0,0,255,251,245,251,238,255,252,251,244,232,244,245,216,255,253,248,32,111,255,131,1,1,65,1,253,128,190,62,191,98,159,251,
			.byte 0,0 ; safety pair of bytes to support a stack renderer
sprites_tiles_lv01_tile20:
			.byte 13 ; mask
			.byte 4 ; counter
			.byte 0,0,0,0,0,0,0,255,128,128,128,128,192,255,0,255,255,0,255,3,1,1,1,1,255,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,127,127,127,127,63,0,0,0,0,0,0,252,254,254,254,254,0,0,0,0,0,0,0,0,255,127,193,127,127,63,0,255,128,128,128,128,192,255,255,0,0,255,255,3,1,1,1,1,255,0,254,190,191,66,255,255,
			.byte 0,0 ; safety pair of bytes to support a stack renderer
sprites_tiles_lv01_tile21:
			.byte 13 ; mask
			.byte 4 ; counter
			.byte 0,0,0,0,0,0,0,255,128,128,128,128,192,254,0,156,168,0,192,0,0,0,0,0,128,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,123,127,87,110,51,0,0,0,0,0,0,48,48,80,0,198,0,0,0,0,0,0,0,0,250,125,193,95,127,47,0,255,128,128,128,128,192,254,245,1,85,62,255,78,79,13,95,25,229,111,123,79,175,227,191,127,
			.byte 0,0 ; safety pair of bytes to support a stack renderer
sprites_tiles_lv01_tile22:
			.byte 15 ; mask
			.byte 4 ; counter
			.byte 255,0,0,112,48,0,48,112,32,0,32,112,128,128,128,255,175,1,1,1,126,60,0,60,126,252,0,0,0,0,0,255,0,0,0,7,7,0,2,2,7,8,8,7,0,0,0,0,0,0,0,0,0,128,128,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,127,127,127,0,0,254,254,254,0,0,0,0,0,0,0,0,0,0,0,0,0,255,143,249,187,31,177,117,44,145,49,123,128,128,128,255,175,1,1,1,254,252,192,188,127,252,249,194,215,239,255,0,
			.byte 0,0 ; safety pair of bytes to support a stack renderer
sprites_tiles_lv01_tile23:
			.byte 15 ; mask
			.byte 4 ; counter
			.byte 0,127,7,3,2,114,2,2,2,18,2,0,0,0,0,0,0,0,0,0,72,72,72,72,72,72,72,72,252,252,248,0,0,0,0,120,112,0,0,120,112,0,96,104,13,5,0,0,0,52,181,129,0,1,1,1,1,1,1,1,1,1,3,0,0,8,4,1,5,109,5,1,5,13,101,120,31,7,0,0,0,124,252,128,52,180,180,180,180,180,180,180,180,160,0,0,255,247,251,182,234,146,250,182,234,242,250,239,109,29,7,0,126,183,183,255,203,74,74,74,74,74,74,74,74,94,252,255,
			.byte 0,0 ; safety pair of bytes to support a stack renderer
sprites_tiles_lv01_tile24:
			.byte 15 ; mask
			.byte 4 ; counter
			.byte 0,31,48,44,0,0,0,0,2,18,18,18,0,0,0,0,0,0,0,0,0,64,72,64,64,64,72,64,64,224,254,0,0,192,142,145,145,142,196,252,128,128,128,0,129,173,44,0,0,0,160,176,22,6,0,14,30,0,0,14,30,0,0,0,0,0,0,40,44,32,1,1,1,45,45,44,1,63,62,0,0,0,224,248,30,166,176,160,128,160,182,32,0,160,2,0,255,255,241,198,195,215,126,30,254,210,210,211,255,237,237,126,0,224,184,182,247,95,79,87,109,95,73,215,237,95,253,255,
			.byte 0,0 ; safety pair of bytes to support a stack renderer
sprites_tiles_lv01_tile25:
			.byte 14 ; mask
			.byte 4 ; counter
			.byte 0,0,0,0,0,0,0,0,8,4,2,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,64,32,16,0,0,0,0,0,0,0,0,0,1,0,0,24,4,2,1,0,0,0,0,0,0,0,128,0,0,0,128,192,32,24,0,0,0,0,0,0,0,0,0,1,2,9,20,34,25,4,2,1,0,0,0,0,0,128,64,128,0,128,64,32,152,68,40,16,0,0,
			.byte 0,0 ; safety pair of bytes to support a stack renderer
sprites_tiles_lv01_tile26:
			.byte 13 ; mask
			.byte 4 ; counter
			.byte 0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,5,252,255,7,7,7,7,7,255,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,248,0,0,248,248,248,248,248,0,0,0,0,0,0,0,0,255,255,255,255,255,255,255,254,255,255,255,255,255,255,255,255,6,255,255,7,7,7,7,7,255,0,191,191,191,255,191,191,
			.byte 0,0 ; safety pair of bytes to support a stack renderer
sprites_tiles_lv01_tile27:
			.byte 13 ; mask
			.byte 4 ; counter
			.byte 0,0,0,0,0,0,0,255,224,224,224,224,224,255,63,160,128,128,128,128,128,128,128,128,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,31,31,31,31,31,0,0,31,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,253,253,255,253,253,253,3,255,224,224,224,224,224,255,255,96,255,255,255,255,255,255,255,255,127,255,255,255,255,255,255,255,
			.byte 0,0 ; safety pair of bytes to support a stack renderer
sprites_tiles_lv01_tile28:
			.byte 13 ; mask
			.byte 4 ; counter
			.byte 0,0,0,0,0,0,1,1,0,0,0,0,1,1,1,1,253,5,5,5,4,5,0,1,0,0,4,0,1,0,1,8,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,248,208,248,224,192,248,192,144,32,32,8,168,16,0,0,255,255,255,255,255,255,255,255,255,255,254,254,255,255,255,255,254,6,6,6,6,6,2,14,74,134,158,166,86,239,254,255,
			.byte 0,0 ; safety pair of bytes to support a stack renderer
sprites_tiles_lv01_tile29:
			.byte 9 ; mask
			.byte 4 ; counter
			.byte 0,0,0,0,8,0,0,0,0,64,64,128,0,0,0,0,0,64,144,8,0,0,0,0,0,0,0,0,0,0,0,0,239,255,253,223,183,239,182,163,9,28,36,34,0,0,0,0,0,0,32,0,1,88,16,74,93,223,254,75,187,252,158,127,
			.byte 0,0 ; safety pair of bytes to support a stack renderer
sprites_tiles_lv01_tile30:
			.byte 13 ; mask
			.byte 4 ; counter
			.byte 0,0,0,0,128,32,0,128,32,160,160,160,32,160,160,191,128,128,0,128,128,0,128,128,128,128,0,0,128,0,0,0,0,8,2,9,2,0,4,28,11,5,30,31,31,28,23,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,255,247,221,228,100,239,115,99,228,104,96,96,96,96,96,127,255,255,127,255,255,127,255,255,255,255,255,127,255,255,255,127,
			.byte 0,0 ; safety pair of bytes to support a stack renderer
sprites_tiles_lv01_tile31:
			.byte 14 ; mask
			.byte 4 ; counter
			.byte 0,0,0,2,6,12,16,0,0,0,3,0,0,1,1,0,0,0,200,128,128,224,64,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,40,16,0,1,0,0,0,2,0,0,0,240,48,8,8,24,32,0,0,0,0,0,0,0,0,0,0,0,2,5,8,51,68,40,17,2,0,3,2,0,2,1,240,8,4,68,116,4,152,96,0,0,0,128,0,0,0,0,
			.byte 0,0 ; safety pair of bytes to support a stack renderer
sprites_tiles_lv01_tile32:
			.byte 15 ; mask
			.byte 4 ; counter
			.byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2,26,18,2,2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,32,4,8,52,2,2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2,26,18,2,2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3,63,95,51,19,75,53,5,2,0,0,0,0,0,0,0,
			.byte 0,0 ; safety pair of bytes to support a stack renderer
sprites_tiles_lv01_tile33:
			.byte 10 ; mask
			.byte 4 ; counter
			.byte 0,0,8,7,1,1,1,1,0,7,15,0,0,0,0,0,0,0,0,0,0,224,192,0,0,0,0,0,192,32,0,0,0,0,31,11,3,3,2,2,7,11,23,15,0,0,0,0,0,0,0,0,224,208,160,192,128,128,128,192,160,240,0,0,
