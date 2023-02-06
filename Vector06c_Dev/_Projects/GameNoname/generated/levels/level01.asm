__RAM_DISK_S_LEVEL01 = RAM_DISK_S
__RAM_DISK_M_LEVEL01 = RAM_DISK_M
; source\levels\art\sprites_tiles_lv01.png
__level01_palette_sprites_tiles_lv01:
			.byte %01001010, %00000001, %01011100, %00011010, 
			.byte %11100100, %11111101, %01110111, %01011111, 
			.byte %01000010, %01001011, %01001100, %11111111, 
			.byte %11111111, %11101011, %00001010, %01011011, 


			.byte 0,0 ; safety pair of bytes to support a stack renderer
__level01_startPos:
			.byte 160, 48

			.byte 0,0 ; safety pair of bytes to support a stack renderer
__level01_roomsAddr:
			.word __level01_room00, 0, __level01_room01, 0, __level01_room02, 

			.byte 0,0 ; safety pair of bytes to support a stack renderer
__level01_tilesAddr:
			.word __sprites_tiles_lv01_tile0, 0, __sprites_tiles_lv01_tile1, 0, __sprites_tiles_lv01_tile2, 0, __sprites_tiles_lv01_tile3, 0, __sprites_tiles_lv01_tile4, 0, __sprites_tiles_lv01_tile5, 0, __sprites_tiles_lv01_tile6, 0, __sprites_tiles_lv01_tile7, 0, __sprites_tiles_lv01_tile8, 0, __sprites_tiles_lv01_tile9, 0, __sprites_tiles_lv01_tile10, 0, __sprites_tiles_lv01_tile11, 0, __sprites_tiles_lv01_tile12, 0, __sprites_tiles_lv01_tile13, 0, __sprites_tiles_lv01_tile14, 0, __sprites_tiles_lv01_tile15, 0, __sprites_tiles_lv01_tile16, 0, __sprites_tiles_lv01_tile17, 0, __sprites_tiles_lv01_tile18, 0, __sprites_tiles_lv01_tile19, 0, __sprites_tiles_lv01_tile20, 0, __sprites_tiles_lv01_tile21, 0, __sprites_tiles_lv01_tile22, 0, __sprites_tiles_lv01_tile23, 0, __sprites_tiles_lv01_tile24, 0, __sprites_tiles_lv01_tile25, 0, __sprites_tiles_lv01_tile26, 0, __sprites_tiles_lv01_tile27, 0, __sprites_tiles_lv01_tile28, 0, __sprites_tiles_lv01_tile29, 0, __sprites_tiles_lv01_tile30, 0, __sprites_tiles_lv01_tile31, 0, __sprites_tiles_lv01_tile32, 0, __sprites_tiles_lv01_tile33, 0, __sprites_tiles_lv01_tile34, 0, __sprites_tiles_lv01_tile35, 0, __sprites_tiles_lv01_tile36, 0, __sprites_tiles_lv01_tile37, 0, __sprites_tiles_lv01_tile38, 0, __sprites_tiles_lv01_tile39, 0, __sprites_tiles_lv01_tile40, 0, __sprites_tiles_lv01_tile41, 0, __sprites_tiles_lv01_tile42, 0, __sprites_tiles_lv01_tile43, 0, __sprites_tiles_lv01_tile44, 0, __sprites_tiles_lv01_tile45, 0, __sprites_tiles_lv01_tile46, 0, __sprites_tiles_lv01_tile47, 0, __sprites_tiles_lv01_tile48, 0, __sprites_tiles_lv01_tile49, 0, __sprites_tiles_lv01_tile50, 0, __sprites_tiles_lv01_tile51, 0, __sprites_tiles_lv01_tile52, 0, __sprites_tiles_lv01_tile53, 

			.byte 0,0 ; safety pair of bytes to support a stack renderer
; source\levels\level01_room00.tmj
__level01_room00:
			.byte 0, 0, 0, 0, 0, 42, 43, 43, 44, 0, 0, 0, 0, 0, 0, 0, 
			.byte 0, 0, 0, 0, 0, 12, 8, 9, 19, 0, 0, 0, 0, 0, 0, 0, 
			.byte 0, 40, 33, 33, 33, 33, 21, 25, 33, 33, 33, 33, 33, 41, 0, 0, 
			.byte 0, 12, 17, 14, 22, 16, 17, 14, 15, 16, 22, 14, 15, 19, 0, 0, 
			.byte 0, 12, 8, 22, 24, 24, 8, 24, 24, 24, 8, 39, 29, 19, 0, 0, 
			.byte 0, 12, 5, 5, 10, 37, 21, 25, 38, 5, 5, 10, 5, 11, 0, 0, 
			.byte 0, 12, 17, 14, 36, 16, 22, 14, 15, 16, 22, 19, 0, 0, 0, 0, 
			.byte 0, 12, 8, 9, 24, 24, 24, 24, 36, 22, 8, 19, 0, 0, 0, 0, 
			.byte 32, 33, 21, 24, 23, 24, 24, 25, 23, 34, 21, 33, 33, 33, 33, 35, 
			.byte 27, 16, 17, 24, 24, 24, 17, 14, 15, 16, 17, 14, 24, 22, 17, 31, 
			.byte 27, 28, 8, 24, 29, 24, 24, 5, 30, 10, 8, 24, 24, 28, 8, 31, 
			.byte 20, 10, 21, 22, 23, 24, 24, 25, 23, 5, 5, 5, 10, 5, 5, 26, 
			.byte 0, 12, 13, 14, 15, 16, 17, 14, 15, 18, 19, 0, 0, 0, 0, 0, 
			.byte 0, 4, 5, 6, 5, 7, 8, 9, 7, 10, 11, 0, 0, 0, 0, 0, 
			.byte 0, 0, 0, 0, 0, 1, 2, 2, 3, 0, 0, 0, 0, 0, 0, 0, 

			.byte 0,0 ; safety pair of bytes to support a stack renderer
; source\levels\level01_room00.tmj
__level01_room00_tilesData:
			.byte 0, 0, 0, 0, 0, 255, 20, 20, 255, 0, 0, 0, 0, 0, 0, 0, 
			.byte 0, 0, 0, 0, 0, 255, 0, 0, 255, 0, 0, 0, 0, 0, 0, 0, 
			.byte 0, 255, 255, 255, 255, 255, 0, 0, 255, 255, 255, 255, 255, 255, 0, 0, 
			.byte 0, 255, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 255, 0, 0, 
			.byte 0, 255, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8, 0, 255, 0, 0, 
			.byte 0, 255, 255, 255, 255, 255, 0, 27, 255, 255, 255, 255, 255, 255, 0, 0, 
			.byte 0, 255, 0, 19, 255, 0, 0, 0, 0, 0, 0, 255, 0, 0, 0, 0, 
			.byte 0, 255, 0, 0, 0, 0, 0, 0, 255, 11, 0, 255, 0, 0, 0, 0, 
			.byte 255, 255, 0, 0, 0, 0, 0, 0, 0, 0, 0, 255, 255, 255, 255, 255, 
			.byte 20, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 12, 
			.byte 20, 0, 0, 0, 0, 0, 0, 255, 255, 255, 0, 0, 0, 27, 0, 12, 
			.byte 255, 255, 0, 0, 35, 0, 0, 0, 19, 255, 255, 255, 255, 255, 255, 255, 
			.byte 0, 255, 8, 0, 0, 0, 0, 0, 0, 20, 255, 0, 0, 0, 0, 0, 
			.byte 0, 255, 255, 255, 255, 255, 0, 0, 255, 255, 255, 0, 0, 0, 0, 0, 
			.byte 0, 0, 0, 0, 0, 255, 20, 20, 255, 0, 0, 0, 0, 0, 0, 0, 

			.byte 0,0 ; safety pair of bytes to support a stack renderer
; source\levels\level01_room01.tmj
__level01_room01:
			.byte 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
			.byte 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
			.byte 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
			.byte 0, 0, 40, 33, 33, 33, 41, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
			.byte 0, 0, 12, 34, 21, 25, 19, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
			.byte 0, 0, 12, 16, 24, 14, 19, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
			.byte 0, 0, 12, 28, 24, 24, 19, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
			.byte 0, 0, 12, 51, 22, 24, 33, 33, 33, 33, 33, 33, 33, 33, 41, 0, 
			.byte 32, 33, 33, 16, 24, 14, 46, 14, 22, 16, 17, 14, 15, 50, 19, 0, 
			.byte 27, 28, 8, 24, 8, 9, 49, 24, 29, 24, 24, 24, 29, 28, 19, 0, 
			.byte 27, 34, 24, 24, 24, 34, 21, 24, 24, 24, 24, 22, 23, 47, 19, 0, 
			.byte 20, 5, 17, 24, 24, 16, 48, 24, 24, 16, 17, 5, 5, 5, 11, 0, 
			.byte 0, 12, 45, 9, 29, 28, 46, 9, 29, 28, 47, 19, 0, 0, 0, 0, 
			.byte 0, 4, 5, 5, 5, 30, 5, 5, 5, 7, 5, 11, 0, 0, 0, 0, 
			.byte 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 

			.byte 0,0 ; safety pair of bytes to support a stack renderer
; source\levels\level01_room01.tmj
__level01_room01_tilesData:
			.byte 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
			.byte 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
			.byte 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
			.byte 0, 0, 255, 255, 255, 255, 255, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
			.byte 0, 0, 255, 0, 0, 0, 255, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
			.byte 0, 0, 255, 0, 0, 0, 255, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
			.byte 0, 0, 255, 0, 0, 0, 255, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
			.byte 0, 0, 255, 8, 0, 0, 255, 255, 255, 255, 255, 255, 255, 255, 255, 0, 
			.byte 255, 255, 255, 0, 19, 0, 255, 0, 0, 0, 0, 0, 0, 8, 255, 0, 
			.byte 4, 0, 0, 0, 0, 0, 255, 0, 0, 0, 27, 0, 3, 0, 255, 0, 
			.byte 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8, 255, 0, 
			.byte 255, 255, 0, 0, 0, 0, 255, 0, 3, 0, 0, 255, 255, 255, 255, 0, 
			.byte 0, 255, 8, 0, 19, 0, 255, 0, 0, 0, 8, 255, 0, 0, 0, 0, 
			.byte 0, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 0, 0, 0, 0, 
			.byte 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 

			.byte 0,0 ; safety pair of bytes to support a stack renderer
; source\levels\level01_room02.tmj
__level01_room02:
			.byte 0, 0, 0, 0, 0, 42, 43, 43, 44, 0, 0, 0, 0, 0, 0, 0, 
			.byte 0, 0, 0, 0, 0, 12, 24, 8, 19, 0, 0, 0, 0, 0, 0, 0, 
			.byte 0, 40, 33, 33, 33, 33, 24, 21, 33, 33, 33, 33, 33, 41, 0, 0, 
			.byte 0, 12, 16, 24, 24, 15, 24, 24, 24, 15, 16, 17, 14, 19, 0, 0, 
			.byte 0, 12, 28, 8, 24, 24, 24, 22, 24, 24, 28, 39, 45, 19, 0, 0, 
			.byte 0, 4, 5, 5, 37, 23, 38, 5, 53, 23, 34, 5, 5, 11, 0, 0, 
			.byte 0, 0, 12, 17, 14, 24, 24, 17, 46, 15, 16, 19, 0, 0, 0, 0, 
			.byte 0, 0, 12, 18, 24, 24, 24, 8, 46, 29, 28, 33, 33, 33, 41, 0, 
			.byte 0, 0, 12, 21, 24, 22, 24, 24, 46, 23, 24, 24, 25, 23, 33, 35, 
			.byte 0, 0, 12, 24, 14, 15, 16, 17, 46, 15, 24, 24, 24, 24, 22, 31, 
			.byte 0, 40, 10, 5, 7, 10, 5, 5, 52, 24, 24, 8, 9, 24, 24, 31, 
			.byte 0, 12, 34, 24, 24, 23, 34, 24, 22, 24, 34, 5, 5, 5, 5, 26, 
			.byte 0, 12, 13, 17, 24, 24, 16, 24, 14, 51, 47, 19, 0, 0, 0, 0, 
			.byte 0, 4, 5, 10, 30, 5, 28, 8, 10, 36, 5, 11, 0, 0, 0, 0, 
			.byte 0, 0, 0, 0, 0, 1, 2, 2, 3, 0, 0, 0, 0, 0, 0, 0, 

			.byte 0,0 ; safety pair of bytes to support a stack renderer
; source\levels\level01_room02.tmj
__level01_room02_tilesData:
			.byte 0, 0, 0, 0, 0, 255, 4, 4, 255, 0, 0, 0, 0, 0, 0, 0, 
			.byte 0, 0, 0, 0, 0, 255, 0, 0, 255, 0, 0, 0, 0, 0, 0, 0, 
			.byte 0, 255, 255, 255, 255, 255, 0, 0, 255, 255, 255, 255, 255, 255, 0, 0, 
			.byte 0, 255, 0, 0, 19, 0, 0, 0, 0, 0, 0, 0, 0, 255, 0, 0, 
			.byte 0, 255, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8, 8, 255, 0, 0, 
			.byte 0, 255, 255, 255, 255, 0, 255, 255, 255, 0, 0, 255, 255, 255, 0, 0, 
			.byte 0, 0, 255, 0, 0, 0, 0, 0, 255, 0, 0, 255, 0, 0, 0, 0, 
			.byte 0, 0, 255, 12, 0, 0, 11, 0, 255, 0, 0, 255, 255, 255, 255, 0, 
			.byte 0, 0, 255, 0, 0, 0, 27, 0, 255, 0, 0, 0, 0, 0, 255, 255, 
			.byte 0, 0, 255, 0, 11, 0, 0, 0, 255, 0, 0, 0, 19, 0, 0, 4, 
			.byte 0, 255, 255, 255, 255, 255, 255, 255, 255, 0, 0, 0, 0, 0, 0, 4, 
			.byte 0, 255, 0, 0, 0, 0, 0, 0, 0, 0, 0, 255, 255, 255, 255, 255, 
			.byte 0, 255, 8, 0, 0, 0, 0, 0, 0, 8, 8, 255, 0, 0, 0, 0, 
			.byte 0, 255, 255, 255, 255, 255, 0, 0, 255, 255, 255, 255, 0, 0, 0, 0, 
			.byte 0, 0, 0, 0, 0, 255, 4, 4, 255, 0, 0, 0, 0, 0, 0, 0, 
; source\levels\art\sprites_tiles_lv01.png
__sprites_tiles_lv01_tiles:
			.byte 0,0 ; safety pair of bytes to support a stack renderer
__sprites_tiles_lv01_tile0:
			.byte 8 ; mask
			.byte 4 ; counter
			.byte 255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,
			.byte 0,0 ; safety pair of bytes to support a stack renderer
__sprites_tiles_lv01_tile1:
			.byte 13 ; mask
			.byte 4 ; counter
			.byte 1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,1,0,1,1,1,1,5,5,5,5,5,5,5,5,253,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,216,248,248,248,248,248,248,248,248,248,0,255,255,255,255,255,255,255,255,255,254,254,254,255,254,255,255,255,222,171,118,34,2,2,6,6,6,6,6,6,6,6,254,
			.byte 0,0 ; safety pair of bytes to support a stack renderer
__sprites_tiles_lv01_tile2:
			.byte 9 ; mask
			.byte 4 ; counter
			.byte 128,0,8,0,0,0,0,0,0,64,64,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,8,20,0,0,0,0,0,0,0,0,0,0,0,0,132,174,117,251,255,255,255,255,255,255,254,221,170,119,34,0,0,0,0,0,0,0,0,
			.byte 0,0 ; safety pair of bytes to support a stack renderer
__sprites_tiles_lv01_tile3:
			.byte 13 ; mask
			.byte 4 ; counter
			.byte 191,160,160,160,160,160,160,160,160,128,128,128,128,128,0,0,0,0,0,0,0,0,0,128,128,128,128,128,128,128,128,128,0,31,31,31,31,31,31,31,31,31,29,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,127,96,96,96,96,96,96,96,96,64,64,66,71,106,221,255,255,255,255,127,127,127,127,255,255,255,255,255,255,255,255,255,
			.byte 0,0 ; safety pair of bytes to support a stack renderer
__sprites_tiles_lv01_tile4:
			.byte 13 ; mask
			.byte 4 ; counter
			.byte 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,253,5,4,5,4,5,4,253,252,5,4,7,4,5,4,253,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,248,248,248,248,248,248,0,0,248,248,248,248,248,248,0,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,7,7,7,7,7,7,255,255,7,7,7,7,7,7,254,
			.byte 0,0 ; safety pair of bytes to support a stack renderer
__sprites_tiles_lv01_tile5:
			.byte 13 ; mask
			.byte 4 ; counter
			.byte 255,0,0,126,60,0,63,127,63,0,63,127,128,128,128,255,175,1,1,1,254,252,0,252,254,252,0,124,254,0,0,255,0,0,0,0,0,0,0,0,0,0,0,0,127,127,127,0,0,254,254,254,0,0,0,0,0,0,0,0,0,0,0,0,0,255,129,255,189,31,191,127,63,128,63,127,128,128,128,255,175,1,1,1,254,252,0,252,255,252,249,124,255,1,255,0,
			.byte 0,0 ; safety pair of bytes to support a stack renderer
__sprites_tiles_lv01_tile6:
			.byte 15 ; mask
			.byte 4 ; counter
			.byte 255,0,0,126,56,0,0,64,0,0,0,0,152,128,128,240,15,1,1,25,8,0,0,0,2,0,0,28,126,0,0,255,0,0,0,0,1,7,31,31,31,31,31,63,39,48,15,0,0,240,12,228,244,248,248,248,248,248,224,128,0,0,0,0,0,0,0,0,1,7,31,31,31,31,31,31,31,0,0,0,0,0,0,248,248,248,248,248,248,248,224,128,0,0,0,0,0,255,129,255,190,24,163,103,39,167,39,71,223,255,245,255,255,207,255,251,234,228,228,228,231,196,25,124,255,1,255,0,
			.byte 0,0 ; safety pair of bytes to support a stack renderer
__sprites_tiles_lv01_tile7:
			.byte 15 ; mask
			.byte 4 ; counter
			.byte 255,0,0,124,52,0,48,120,48,0,48,112,128,128,128,255,47,1,1,1,14,12,0,12,14,28,0,0,0,0,0,255,0,0,0,0,0,0,1,0,7,3,7,7,3,1,0,0,0,192,128,192,224,224,192,224,0,128,0,0,0,0,0,0,0,0,0,0,1,0,0,3,1,3,7,7,123,125,126,0,0,222,190,222,224,224,192,128,192,0,128,128,0,0,0,0,0,255,128,253,182,31,179,124,59,134,62,127,135,131,129,255,239,225,193,225,254,252,96,92,47,220,121,66,215,111,255,0,
			.byte 0,0 ; safety pair of bytes to support a stack renderer
__sprites_tiles_lv01_tile8:
			.byte 1 ; mask
			.byte 4 ; counter
			.byte 255,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,0,1,0,0,0,0,0,232,
			.byte 0,0 ; safety pair of bytes to support a stack renderer
__sprites_tiles_lv01_tile9:
			.byte 1 ; mask
			.byte 4 ; counter
			.byte 0,0,0,0,0,0,255,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,244,1,1,1,1,1,63,
			.byte 0,0 ; safety pair of bytes to support a stack renderer
__sprites_tiles_lv01_tile10:
			.byte 13 ; mask
			.byte 4 ; counter
			.byte 255,0,0,127,63,0,49,123,49,0,63,127,128,128,128,255,175,1,1,1,254,252,0,252,254,252,0,0,128,0,0,255,0,0,0,0,0,0,0,0,0,0,0,0,127,127,127,0,0,254,254,254,0,0,0,0,0,0,0,0,0,0,0,0,0,255,128,255,191,31,177,123,49,128,63,127,128,128,128,255,175,1,1,1,254,252,0,252,255,252,249,66,215,111,255,0,
			.byte 0,0 ; safety pair of bytes to support a stack renderer
__sprites_tiles_lv01_tile11:
			.byte 13 ; mask
			.byte 4 ; counter
			.byte 191,32,32,96,160,32,32,191,63,160,160,32,160,32,160,191,0,128,128,128,128,128,128,128,128,128,128,128,128,128,128,128,0,31,31,31,31,31,31,0,0,31,31,31,31,31,31,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,127,224,224,224,224,224,224,255,255,224,224,224,224,224,224,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,
			.byte 0,0 ; safety pair of bytes to support a stack renderer
__sprites_tiles_lv01_tile12:
			.byte 13 ; mask
			.byte 4 ; counter
			.byte 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,253,5,5,5,5,5,5,5,5,5,5,5,5,5,5,253,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,248,248,248,248,248,248,248,248,248,248,248,248,248,248,0,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,254,6,6,6,6,6,6,6,6,6,6,6,6,6,6,254,
			.byte 0,0 ; safety pair of bytes to support a stack renderer
__sprites_tiles_lv01_tile13:
			.byte 15 ; mask
			.byte 4 ; counter
			.byte 0,0,0,0,0,8,6,32,50,78,66,80,40,80,96,64,0,0,0,0,0,0,96,0,0,0,64,0,0,0,0,0,0,0,0,8,16,16,32,1,0,0,9,4,0,0,0,0,0,0,0,0,0,0,144,64,128,128,32,0,0,0,0,0,0,0,0,0,0,8,6,32,50,78,66,80,40,80,96,64,0,0,0,0,0,0,96,0,0,0,64,0,0,0,0,0,0,0,8,20,40,46,95,118,114,255,230,251,252,248,240,224,0,0,0,0,0,240,104,176,64,96,208,96,0,0,0,0,
			.byte 0,0 ; safety pair of bytes to support a stack renderer
__sprites_tiles_lv01_tile14:
			.byte 0 ; mask
			.byte 4 ; counter
			.byte 
			.byte 0,0 ; safety pair of bytes to support a stack renderer
__sprites_tiles_lv01_tile15:
			.byte 1 ; mask
			.byte 4 ; counter
			.byte 255,128,128,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,128,
			.byte 0,0 ; safety pair of bytes to support a stack renderer
__sprites_tiles_lv01_tile16:
			.byte 1 ; mask
			.byte 4 ; counter
			.byte 1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,0,1,0,0,0,0,0,1,1,1,255,
			.byte 0,0 ; safety pair of bytes to support a stack renderer
__sprites_tiles_lv01_tile17:
			.byte 1 ; mask
			.byte 4 ; counter
			.byte 0,0,0,0,0,0,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,255,1,1,0,0,0,0,0,0,0,
			.byte 0,0 ; safety pair of bytes to support a stack renderer
__sprites_tiles_lv01_tile18:
			.byte 15 ; mask
			.byte 4 ; counter
			.byte 0,0,24,0,0,0,0,0,0,0,24,0,0,0,0,0,0,0,0,0,0,24,0,0,0,0,0,0,0,24,0,0,0,0,0,0,63,0,0,0,0,0,0,0,63,0,0,24,24,0,0,252,0,0,0,0,0,0,0,252,0,0,0,0,24,24,0,63,39,24,24,24,24,24,0,63,39,24,24,24,24,24,24,228,252,0,24,24,24,24,24,228,252,0,24,24,231,231,255,192,239,231,231,231,231,231,255,192,239,0,0,24,24,0,0,247,3,255,231,231,231,231,231,247,3,255,231,231,
			.byte 0,0 ; safety pair of bytes to support a stack renderer
__sprites_tiles_lv01_tile19:
			.byte 13 ; mask
			.byte 4 ; counter
			.byte 191,160,160,160,160,160,160,160,160,160,160,160,160,160,160,191,128,128,128,128,128,128,128,128,128,128,128,128,128,128,128,128,0,31,31,31,31,31,31,31,31,31,31,31,31,31,31,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,127,96,96,96,96,96,96,96,96,96,96,96,96,96,96,127,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,
			.byte 0,0 ; safety pair of bytes to support a stack renderer
__sprites_tiles_lv01_tile20:
			.byte 13 ; mask
			.byte 4 ; counter
			.byte 18,0,0,4,0,0,0,0,23,0,0,6,0,0,0,9,167,1,1,1,22,152,0,140,126,188,0,100,22,0,0,119,0,0,0,0,0,0,0,0,0,0,0,0,2,1,0,0,0,158,62,46,0,0,0,0,0,0,0,0,0,0,0,0,237,254,208,244,255,169,200,252,223,160,240,255,192,128,192,233,167,1,1,1,246,152,0,140,127,188,161,100,23,1,55,136,
			.byte 0,0 ; safety pair of bytes to support a stack renderer
__sprites_tiles_lv01_tile21:
			.byte 1 ; mask
			.byte 4 ; counter
			.byte 0,0,0,0,0,0,0,0,0,255,0,0,0,0,0,0,63,1,1,1,1,1,244,0,0,0,0,0,0,0,0,0,
			.byte 0,0 ; safety pair of bytes to support a stack renderer
__sprites_tiles_lv01_tile22:
			.byte 1 ; mask
			.byte 4 ; counter
			.byte 128,0,8,4,24,0,0,0,0,64,64,128,0,0,0,0,0,64,176,8,0,0,0,0,0,0,0,0,0,0,0,0,
			.byte 0,0 ; safety pair of bytes to support a stack renderer
__sprites_tiles_lv01_tile23:
			.byte 1 ; mask
			.byte 4 ; counter
			.byte 0,0,0,0,242,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,128,128,128,128,128,
			.byte 0,0 ; safety pair of bytes to support a stack renderer
__sprites_tiles_lv01_tile24:
			.byte 0 ; mask
			.byte 4 ; counter
			.byte 
			.byte 0,0 ; safety pair of bytes to support a stack renderer
__sprites_tiles_lv01_tile25:
			.byte 1 ; mask
			.byte 4 ; counter
			.byte 128,128,128,128,128,0,0,0,0,0,0,0,1,1,1,255,232,0,0,0,0,0,1,0,1,1,1,1,1,1,1,1,
			.byte 0,0 ; safety pair of bytes to support a stack renderer
__sprites_tiles_lv01_tile26:
			.byte 13 ; mask
			.byte 4 ; counter
			.byte 191,0,0,94,60,0,39,121,60,0,62,126,128,128,128,251,128,0,0,0,192,160,0,128,144,224,0,32,192,0,0,132,0,0,0,0,0,0,0,0,0,0,0,0,119,55,126,0,0,0,160,4,0,0,0,0,0,0,0,0,0,0,0,0,0,255,129,222,189,6,167,123,60,128,62,126,128,128,128,251,239,63,75,187,223,175,91,219,215,255,255,119,203,31,255,51,
			.byte 0,0 ; safety pair of bytes to support a stack renderer
__sprites_tiles_lv01_tile27:
			.byte 9 ; mask
			.byte 4 ; counter
			.byte 0,0,0,0,16,0,0,0,0,0,0,0,0,0,0,0,0,64,176,8,0,0,0,0,0,0,0,0,0,0,0,0,248,240,232,220,232,240,248,240,232,252,248,248,240,232,252,248,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
			.byte 0,0 ; safety pair of bytes to support a stack renderer
__sprites_tiles_lv01_tile28:
			.byte 1 ; mask
			.byte 4 ; counter
			.byte 250,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,183,0,0,0,0,0,0,0,0,0,0,0,
			.byte 0,0 ; safety pair of bytes to support a stack renderer
__sprites_tiles_lv01_tile29:
			.byte 1 ; mask
			.byte 4 ; counter
			.byte 0,0,0,0,0,0,0,0,0,0,0,237,128,128,128,128,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,95,
			.byte 0,0 ; safety pair of bytes to support a stack renderer
__sprites_tiles_lv01_tile30:
			.byte 15 ; mask
			.byte 4 ; counter
			.byte 255,0,0,126,60,0,60,124,60,0,56,120,128,128,128,255,175,1,1,1,14,12,0,28,30,28,0,60,254,0,0,255,0,0,0,0,0,0,1,1,0,1,2,2,1,0,0,0,0,0,0,192,32,32,192,128,64,64,128,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,124,127,127,0,0,254,254,30,0,0,0,0,0,0,0,0,0,0,0,0,0,255,129,255,188,29,190,126,61,130,62,126,131,128,128,255,175,1,1,161,94,92,96,220,127,60,89,188,255,1,255,0,
			.byte 0,0 ; safety pair of bytes to support a stack renderer
__sprites_tiles_lv01_tile31:
			.byte 9 ; mask
			.byte 4 ; counter
			.byte 128,0,8,4,24,0,0,0,0,64,64,128,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,55,15,31,15,23,59,23,15,31,47,119,47,31,47,119,43,
			.byte 0,0 ; safety pair of bytes to support a stack renderer
__sprites_tiles_lv01_tile32:
			.byte 13 ; mask
			.byte 4 ; counter
			.byte 0,0,0,0,0,0,0,9,0,0,0,0,0,0,0,1,207,0,127,3,1,1,1,1,189,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,9,22,11,0,3,0,0,0,0,0,0,124,150,238,46,222,0,0,0,0,0,0,0,0,255,242,178,223,253,197,160,255,224,224,192,192,160,216,255,0,0,47,127,3,1,1,1,1,253,0,158,62,191,66,31,251,
			.byte 0,0 ; safety pair of bytes to support a stack renderer
__sprites_tiles_lv01_tile33:
			.byte 13 ; mask
			.byte 4 ; counter
			.byte 0,0,0,0,0,0,0,255,128,128,128,128,192,255,0,255,255,0,255,3,1,1,1,1,255,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,127,127,127,127,63,0,0,0,0,0,0,252,254,254,254,254,0,0,0,0,0,0,0,0,255,127,193,127,127,63,0,255,128,128,128,128,192,255,255,0,0,255,255,3,1,1,1,1,255,0,254,190,191,66,255,255,
			.byte 0,0 ; safety pair of bytes to support a stack renderer
__sprites_tiles_lv01_tile34:
			.byte 1 ; mask
			.byte 4 ; counter
			.byte 0,0,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,79,1,1,1,1,
			.byte 0,0 ; safety pair of bytes to support a stack renderer
__sprites_tiles_lv01_tile35:
			.byte 13 ; mask
			.byte 4 ; counter
			.byte 0,0,0,0,0,0,0,255,128,128,128,128,192,254,0,156,168,0,192,0,0,0,0,0,128,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,123,127,87,110,51,0,0,0,0,0,0,48,48,80,0,198,0,0,0,0,0,0,0,0,250,125,193,95,127,47,0,255,128,128,128,128,192,254,245,1,85,62,255,78,79,13,95,25,229,111,123,79,175,227,191,127,
			.byte 0,0 ; safety pair of bytes to support a stack renderer
__sprites_tiles_lv01_tile36:
			.byte 15 ; mask
			.byte 4 ; counter
			.byte 255,0,0,112,48,0,48,112,32,0,32,112,128,128,128,255,175,1,1,1,126,60,0,60,126,252,0,0,0,0,0,255,0,0,0,7,7,0,2,2,7,8,8,7,0,0,0,0,0,0,0,0,0,128,128,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,127,127,127,0,0,254,254,254,0,0,0,0,0,0,0,0,0,0,0,0,0,255,143,249,187,31,177,117,44,145,49,123,128,128,128,255,175,1,1,1,254,252,192,188,127,252,249,194,215,239,255,0,
			.byte 0,0 ; safety pair of bytes to support a stack renderer
__sprites_tiles_lv01_tile37:
			.byte 15 ; mask
			.byte 4 ; counter
			.byte 0,127,7,3,2,114,2,2,2,18,2,0,0,0,0,0,0,0,0,0,72,72,72,72,72,72,72,72,252,252,248,0,0,0,0,120,112,0,0,120,112,0,96,104,13,5,0,0,0,52,181,129,0,1,1,1,1,1,1,1,1,1,3,0,0,8,4,1,5,109,5,1,5,13,101,120,31,7,0,0,0,124,252,128,52,180,180,180,180,180,180,180,180,160,0,0,255,247,251,182,234,146,250,182,234,242,250,239,109,29,7,0,126,183,183,255,203,74,74,74,74,74,74,74,74,94,252,255,
			.byte 0,0 ; safety pair of bytes to support a stack renderer
__sprites_tiles_lv01_tile38:
			.byte 15 ; mask
			.byte 4 ; counter
			.byte 0,31,48,44,0,0,0,0,2,18,18,18,0,0,0,0,0,0,0,0,0,64,72,64,64,64,72,64,64,224,254,0,0,192,142,145,145,142,196,252,128,128,128,0,129,173,44,0,0,0,160,176,22,6,0,14,30,0,0,14,30,0,0,0,0,0,0,40,44,32,1,1,1,45,45,44,1,63,62,0,0,0,224,248,30,166,176,160,128,160,182,32,0,160,2,0,255,255,241,198,195,215,126,30,254,210,210,211,255,237,237,126,0,224,184,182,247,95,79,87,109,95,73,215,237,95,253,255,
			.byte 0,0 ; safety pair of bytes to support a stack renderer
__sprites_tiles_lv01_tile39:
			.byte 14 ; mask
			.byte 4 ; counter
			.byte 0,0,0,0,0,0,0,0,8,4,2,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,64,32,16,0,0,0,0,0,0,0,0,0,1,0,0,24,4,2,1,0,0,0,0,0,0,0,128,0,0,0,128,192,32,24,0,0,0,0,0,0,0,0,0,1,2,9,20,34,25,4,2,1,0,0,0,0,0,128,64,128,0,128,64,32,152,68,40,16,0,0,
			.byte 0,0 ; safety pair of bytes to support a stack renderer
__sprites_tiles_lv01_tile40:
			.byte 13 ; mask
			.byte 4 ; counter
			.byte 0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,5,252,255,7,7,7,7,7,255,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,248,0,0,248,248,248,248,248,0,0,0,0,0,0,0,0,255,255,255,255,255,255,255,254,255,255,255,255,255,255,255,255,6,255,255,7,7,7,7,7,255,0,191,191,191,255,191,191,
			.byte 0,0 ; safety pair of bytes to support a stack renderer
__sprites_tiles_lv01_tile41:
			.byte 13 ; mask
			.byte 4 ; counter
			.byte 0,0,0,0,0,0,0,255,224,224,224,224,224,255,63,160,128,128,128,128,128,128,128,128,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,31,31,31,31,31,0,0,31,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,253,253,255,253,253,253,3,255,224,224,224,224,224,255,255,96,255,255,255,255,255,255,255,255,127,255,255,255,255,255,255,255,
			.byte 0,0 ; safety pair of bytes to support a stack renderer
__sprites_tiles_lv01_tile42:
			.byte 13 ; mask
			.byte 4 ; counter
			.byte 0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,253,5,5,5,5,5,5,5,5,1,1,1,1,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,248,248,248,248,248,248,248,248,248,184,0,0,0,0,0,255,255,255,254,254,254,254,255,255,255,255,255,255,255,255,255,254,6,6,6,6,6,6,6,6,2,2,66,226,87,186,255,
			.byte 0,0 ; safety pair of bytes to support a stack renderer
__sprites_tiles_lv01_tile43:
			.byte 9 ; mask
			.byte 4 ; counter
			.byte 0,0,0,0,0,0,0,0,0,0,16,40,0,0,0,0,0,64,176,8,0,0,0,0,0,0,0,0,0,0,0,0,255,255,127,187,85,238,68,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,33,117,174,223,255,255,
			.byte 0,0 ; safety pair of bytes to support a stack renderer
__sprites_tiles_lv01_tile44:
			.byte 13 ; mask
			.byte 4 ; counter
			.byte 0,0,128,128,128,128,128,160,160,160,160,160,160,160,160,191,128,128,128,128,128,128,128,128,128,0,0,0,0,0,0,0,0,0,0,0,0,27,31,31,31,31,31,31,31,31,31,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,255,251,85,110,68,64,64,96,96,96,96,96,96,96,96,127,255,255,255,255,255,255,255,255,255,127,127,127,255,127,255,255,
			.byte 0,0 ; safety pair of bytes to support a stack renderer
__sprites_tiles_lv01_tile45:
			.byte 14 ; mask
			.byte 4 ; counter
			.byte 0,0,0,2,6,12,16,0,0,0,3,0,0,1,1,0,0,0,200,128,128,224,64,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,40,16,0,1,0,0,0,2,0,0,0,240,48,8,8,24,32,0,0,0,0,0,0,0,0,0,0,0,2,5,8,51,68,40,17,2,0,3,2,0,2,1,240,8,4,68,116,4,152,96,0,0,0,128,0,0,0,0,
			.byte 0,0 ; safety pair of bytes to support a stack renderer
__sprites_tiles_lv01_tile46:
			.byte 13 ; mask
			.byte 4 ; counter
			.byte 191,160,160,160,160,160,160,160,160,160,160,160,160,160,160,191,128,128,128,128,128,128,128,128,128,128,128,128,128,128,128,192,0,31,31,31,31,31,31,31,31,31,31,31,31,31,31,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,127,96,96,96,96,96,96,96,96,96,96,96,96,96,96,127,148,218,220,218,212,218,220,218,212,218,220,218,212,218,220,186,
			.byte 0,0 ; safety pair of bytes to support a stack renderer
__sprites_tiles_lv01_tile47:
			.byte 15 ; mask
			.byte 4 ; counter
			.byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2,26,18,2,2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,32,4,8,52,2,2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2,26,18,2,2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3,63,95,51,19,75,53,5,2,0,0,0,0,0,0,0,
			.byte 0,0 ; safety pair of bytes to support a stack renderer
__sprites_tiles_lv01_tile48:
			.byte 15 ; mask
			.byte 4 ; counter
			.byte 0,0,30,0,0,30,0,0,30,0,0,30,0,0,30,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,30,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,30,30,0,30,30,0,30,30,0,30,30,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,33,63,63,33,33,63,33,33,63,33,33,63,33,33,63,30,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
			.byte 0,0 ; safety pair of bytes to support a stack renderer
__sprites_tiles_lv01_tile49:
			.byte 15 ; mask
			.byte 4 ; counter
			.byte 0,30,0,0,30,0,0,30,0,0,30,0,0,30,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,30,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,30,30,0,30,30,0,30,30,0,30,30,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,30,63,33,33,63,33,33,63,33,33,63,33,33,63,63,33,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
			.byte 0,0 ; safety pair of bytes to support a stack renderer
__sprites_tiles_lv01_tile50:
			.byte 10 ; mask
			.byte 4 ; counter
			.byte 0,0,8,7,1,1,1,1,0,7,15,0,0,0,0,0,0,0,0,0,0,224,192,0,0,0,0,0,192,32,0,0,0,0,31,11,3,3,2,2,7,11,23,15,0,0,0,0,0,0,0,0,224,208,160,192,128,128,128,192,160,240,0,0,
			.byte 0,0 ; safety pair of bytes to support a stack renderer
__sprites_tiles_lv01_tile51:
			.byte 15 ; mask
			.byte 4 ; counter
			.byte 0,0,0,31,10,10,10,10,10,2,0,16,2,0,0,0,0,0,0,64,8,0,64,80,80,80,80,80,248,0,0,0,0,63,96,64,64,64,64,64,64,64,76,79,76,108,63,0,0,252,54,50,242,50,2,2,2,2,2,2,2,6,252,0,0,0,0,0,21,21,21,21,21,17,16,0,1,0,0,0,0,0,0,128,0,8,136,168,168,168,168,168,0,0,0,0,127,192,191,191,234,170,234,234,234,238,239,247,182,183,192,127,254,3,237,109,239,247,119,87,87,87,85,87,253,253,3,254,
			.byte 0,0 ; safety pair of bytes to support a stack renderer
__sprites_tiles_lv01_tile52:
			.byte 13 ; mask
			.byte 4 ; counter
			.byte 191,32,32,96,160,32,32,191,63,160,160,32,160,32,160,191,0,128,192,192,128,128,128,192,192,128,128,128,128,128,128,192,0,31,31,31,31,31,31,0,0,31,31,31,31,31,31,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,127,224,224,224,224,224,224,255,255,224,224,224,224,224,224,255,240,152,156,154,212,218,220,154,148,218,220,218,212,218,220,186,
			.byte 0,0 ; safety pair of bytes to support a stack renderer
__sprites_tiles_lv01_tile53:
			.byte 13 ; mask
			.byte 4 ; counter
			.byte 253,1,4,16,0,0,1,255,224,224,224,224,224,255,63,160,128,192,192,128,128,128,128,128,64,128,0,0,0,0,128,0,0,0,0,0,0,0,0,0,31,31,31,31,31,0,0,31,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,252,131,109,125,124,2,255,224,224,224,224,224,255,255,96,148,154,156,218,212,218,220,218,20,58,28,218,212,172,80,192,
