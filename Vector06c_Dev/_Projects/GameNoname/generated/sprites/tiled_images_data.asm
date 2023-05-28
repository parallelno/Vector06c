__RAM_DISK_S_TILED_IMAGES_DATA = RAM_DISK_S
__RAM_DISK_M_TILED_IMAGES_DATA = RAM_DISK_M

__TILED_IMAGES_FRAME_INGAME_DIALOG_COPY_LEN = 24
			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_frame_ingame_dialog:
			.word SCR_BUFF0_ADDR + (0<<8 | 0)	; scr addr
			.word SCR_BUFF0_ADDR + (32<<8 | 64)	; scr addr end
			.byte 7,255,8,30,9,4,255,5,30,6,4,255,5,30,6,4,255,5,30,6,4,255,5,30,6,4,255,5,30,6,4,255,
			.byte 5,30,6,1,255,2,30,3,

__TILED_IMAGES_FRAME_MAIN_MENU_COPY_LEN = 34
			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_frame_main_menu:
			.word SCR_BUFF0_ADDR + (10<<8 | 80)	; scr addr
			.word SCR_BUFF0_ADDR + (23<<8 | 176)	; scr addr end
			.byte 7,255,8,11,9,4,255,5,11,6,4,255,5,
			.byte 11,6,4,255,5,11,6,4,255,5,11,6,4,
			.byte 255,5,11,6,4,255,5,11,6,4,255,5,11,
			.byte 6,4,255,5,11,6,4,255,5,11,6,4,255,
			.byte 5,11,6,1,255,2,11,3,

__TILED_IMAGES_TITLE_COPY_LEN = 91
			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_title:
			.word SCR_BUFF0_ADDR + (5<<8 | 176)	; scr addr
			.word SCR_BUFF0_ADDR + (28<<8 | 248)	; scr addr end
			.byte 0,129,130,131,132,255,133,14,134,0,0,0,119,120,121,122,123,255,124,14,125,126,127,
			.byte 128,0,0,102,103,104,105,106,107,108,109,110,0,111,112,113,114,107,115,116,0,117,118,
			.byte 0,0,0,85,86,87,88,89,90,0,91,92,93,94,95,0,96,90,97,98,99,100,101,
			.byte 0,0,0,66,67,68,69,70,71,0,72,73,74,75,76,77,78,79,80,81,82,83,84,
			.byte 0,0,0,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,0,63,64,
			.byte 65,255,0,4,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,255,0,4,255,
			.byte 0,4,17,18,19,20,21,22,23,24,25,26,27,28,29,30,255,0,5,255,0,5,10,
			.byte 11,12,255,0,7,13,14,15,16,255,0,4,

__TILED_IMAGES_FRAME_INGAME_TOP_COPY_LEN = 29
			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_frame_ingame_top:
			.word SCR_BUFF0_ADDR + (0<<8 | 240)	; scr addr
			.word SCR_BUFF0_ADDR + (32<<8 | 0)	; scr addr end
			.byte 150,151,152,153,153,153,154,155,255,153,9,156,157,158,159,160,161,255,153,4,162,163,153,153,164,135,136,137,138,138,138,139,
			.byte 140,255,138,9,141,142,143,144,145,146,255,138,4,147,148,138,138,149,

