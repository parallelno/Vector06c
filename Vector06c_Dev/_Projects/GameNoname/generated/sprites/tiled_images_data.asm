__RAM_DISK_S_TILED_IMAGES_DATA = RAM_DISK_S
__RAM_DISK_M_TILED_IMAGES_DATA = RAM_DISK_M

__TILED_IMAGES_FRAME_INGAME_DIALOG_COPY_LEN = 22
			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_frame_ingame_dialog:
			.word SCR_BUFF0_ADDR + (0<<8 | 0)	; scr addr
			.word SCR_BUFF0_ADDR + (32<<8 | 64)	; scr addr end
			.byte 8,255,9,30,10,7,255,5,30,6,4,255,5,30,6,4,255,5,30,6,4,255,5,30,6,4,255,5,30,6,4,255,
			.byte 5,30,6,1,255,2,30,3,

__TILED_IMAGES_MAIN_MENU_BACK2_COPY_LEN = 99
			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_main_menu_back2:
			.word SCR_BUFF0_ADDR + (0<<8 | 0)	; scr addr
			.word SCR_BUFF0_ADDR + (32<<8 | 136)	; scr addr end
			.byte 31,32,33,34,35,36,37,35,36,33,34,36,37,35,36,33,34,35,36,38,37,35,36,33,34,35,36,34,35,36,39,31,
			.byte 24,25,26,27,26,27,28,26,27,27,26,27,28,26,27,26,27,26,27,29,28,26,27,27,29,26,27,29,26,27,30,24,
			.byte 18,19,20,21,20,21,20,21,20,21,20,21,20,21,20,21,20,21,20,21,20,20,20,21,21,20,20,21,21,21,22,23,
			.byte 11,15,255,0,28,13,14,17,12,255,0,28,16,14,11,15,255,0,28,16,14,11,15,255,0,28,13,14,11,12,255,0,
			.byte 28,16,14,11,12,255,0,28,13,14,11,15,255,0,28,16,14,11,12,255,0,28,13,14,11,15,255,0,28,16,14,11,
			.byte 12,255,0,28,13,14,11,15,255,0,28,16,14,11,12,255,0,28,13,14,11,15,255,0,28,16,14,11,12,255,0,28,
			.byte 13,14,

__TILED_IMAGES_MAIN_MENU_BACK1_COPY_LEN = 82
			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_main_menu_back1:
			.word SCR_BUFF0_ADDR + (0<<8 | 136)	; scr addr
			.word SCR_BUFF0_ADDR + (32<<8 | 0)	; scr addr end
			.byte 11,15,44,255,0,26,43,16,30,30,12,255,0,27,44,13,23,18,15,255,0,28,16,14,11,12,255,0,28,13,14,11,
			.byte 15,255,0,28,16,14,11,15,255,0,28,13,14,11,12,255,0,28,16,14,11,15,255,0,28,13,14,11,12,255,0,28,
			.byte 16,14,11,15,255,0,28,13,14,11,12,255,0,28,16,14,11,15,255,0,28,13,14,11,12,255,0,26,43,44,13,14,
			.byte 11,40,41,42,41,42,41,41,42,42,41,42,42,42,41,41,42,42,41,41,42,42,41,42,42,41,42,42,41,42,42,14,
			.byte 18,19,19,29,28,26,27,29,28,26,27,29,28,27,26,27,26,27,29,28,26,27,26,31,27,28,28,26,27,18,23,23,

__TILED_IMAGES_TITLE2_COPY_LEN = 86
			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_title2:
			.word SCR_BUFF0_ADDR + (2<<8 | 24)	; scr addr
			.word SCR_BUFF0_ADDR + (30<<8 | 160)	; scr addr end
			.byte 0,60,68,69,46,255,0,9,64,53,255,0,10,49,0,255,0,27,45,255,0,22,68,255,0,5,255,0,
			.byte 9,56,255,0,11,65,66,67,255,0,4,62,63,255,0,7,53,56,255,0,10,64,53,255,0,5,255,0,
			.byte 23,58,255,0,4,0,0,61,57,255,0,16,45,0,0,55,0,0,62,63,255,0,4,60,255,0,15,56,
			.byte 50,51,52,53,0,0,0,0,0,59,58,255,0,17,46,255,0,6,255,0,28,255,0,28,255,0,27,56,
			.byte 0,58,255,0,26,0,55,255,0,23,56,0,57,0,0,53,255,0,18,51,0,54,49,0,0,0,49,0,
			.byte 0,0,50,51,52,255,0,13,46,255,0,4,45,0,0,0,45,0,0,46,255,0,15,47,48,255,0,6,

__TILED_IMAGES_TITLE1_COPY_LEN = 115
			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_title1:
			.word SCR_BUFF0_ADDR + (2<<8 | 160)	; scr addr
			.word SCR_BUFF0_ADDR + (30<<8 | 240)	; scr addr end
			.byte 0,0,193,194,195,196,197,255,198,15,199,255,0,5,0,0,178,179,180,181,182,183,184,185,186,187,186,188,
			.byte 187,186,186,187,187,186,183,189,190,191,192,0,0,0,0,0,0,159,160,161,162,163,164,165,166,167,168,169,
			.byte 170,171,172,173,165,174,175,0,176,177,0,61,57,0,255,0,4,143,144,145,0,146,147,0,148,149,150,151,
			.byte 152,0,153,147,154,155,156,157,158,255,0,4,255,0,4,124,125,126,127,128,129,0,130,131,132,133,134,135,
			.byte 136,137,138,139,140,141,142,255,0,4,255,0,4,105,0,106,107,108,109,110,111,112,113,114,115,116,117,118,
			.byte 119,120,0,121,122,123,0,0,0,255,0,4,61,57,91,92,93,94,95,96,97,98,99,100,101,102,103,104,
			.byte 0,51,255,0,6,58,255,0,5,77,78,79,80,81,82,83,84,85,86,87,88,89,90,46,255,0,5,64,
			.byte 53,55,255,0,6,71,72,73,255,0,7,74,75,76,47,48,255,0,4,62,63,0,53,255,0,23,70,0,
			.byte 0,

__TILED_IMAGES_FRAME_MAIN_MENU_COPY_LEN = 54
			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_frame_main_menu:
			.word SCR_BUFF0_ADDR + (9<<8 | 56)	; scr addr
			.word SCR_BUFF0_ADDR + (23<<8 | 160)	; scr addr end
			.byte 41,42,41,42,42,41,42,41,42,41,42,41,42,0,
			.byte 8,255,9,11,10,15,7,12,255,0,10,6,12,4,
			.byte 15,255,0,10,6,15,4,12,255,0,10,6,12,4,
			.byte 15,255,0,10,6,15,4,12,255,0,10,6,12,4,
			.byte 15,255,0,10,6,15,4,12,255,0,10,6,12,4,
			.byte 15,255,0,10,6,15,4,12,255,0,10,6,12,4,
			.byte 200,42,41,42,41,42,41,41,42,41,42,6,15,1,
			.byte 255,2,11,3,12,

__TILED_IMAGES_FRAME_INGAME_TOP_COPY_LEN = 21
			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_frame_ingame_top:
			.word SCR_BUFF0_ADDR + (0<<8 | 240)	; scr addr
			.word SCR_BUFF0_ADDR + (32<<8 | 0)	; scr addr end
			.byte 212,213,214,255,215,12,216,217,218,219,255,215,7,220,221,215,215,215,222,201,202,203,255,204,12,205,206,207,208,255,204,7,
			.byte 209,210,204,204,204,211,

__TILED_IMAGES_RES_SWORD_COPY_LEN = 6
			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_res_sword:
			.word SCR_BUFF0_ADDR + (6<<8 | 240)	; scr addr
			.word SCR_BUFF0_ADDR + (10<<8 | 0)	; scr addr end
			.byte 225,226,215,215,
			.byte 223,224,204,204,

__TILED_IMAGES_RES_MANA_COPY_LEN = 6
			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_res_mana:
			.word SCR_BUFF0_ADDR + (6<<8 | 240)	; scr addr
			.word SCR_BUFF0_ADDR + (10<<8 | 0)	; scr addr end
			.byte 229,230,215,215,
			.byte 227,228,204,204,

__TILED_IMAGES_RES_POTION_HEALTH_COPY_LEN = 6
			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_res_potion_health:
			.word SCR_BUFF0_ADDR + (6<<8 | 240)	; scr addr
			.word SCR_BUFF0_ADDR + (10<<8 | 0)	; scr addr end
			.byte 233,234,215,215,
			.byte 231,232,204,204,

__TILED_IMAGES_RES_POTION_MANA_COPY_LEN = 6
			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_res_potion_mana:
			.word SCR_BUFF0_ADDR + (6<<8 | 240)	; scr addr
			.word SCR_BUFF0_ADDR + (10<<8 | 0)	; scr addr end
			.byte 237,238,215,215,
			.byte 235,236,204,204,

__TILED_IMAGES_RES_CLOTHES_COPY_LEN = 6
			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_res_clothes:
			.word SCR_BUFF0_ADDR + (6<<8 | 240)	; scr addr
			.word SCR_BUFF0_ADDR + (10<<8 | 0)	; scr addr end
			.byte 241,70,215,215,
			.byte 239,240,204,204,

__TILED_IMAGES_RES_CABBAGE_COPY_LEN = 6
			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_res_cabbage:
			.word SCR_BUFF0_ADDR + (6<<8 | 240)	; scr addr
			.word SCR_BUFF0_ADDR + (10<<8 | 0)	; scr addr end
			.byte 244,245,215,215,
			.byte 242,243,204,204,

__TILED_IMAGES_RES_TNT_COPY_LEN = 6
			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_res_tnt:
			.word SCR_BUFF0_ADDR + (6<<8 | 240)	; scr addr
			.word SCR_BUFF0_ADDR + (10<<8 | 0)	; scr addr end
			.byte 248,249,215,215,
			.byte 246,247,204,204,

