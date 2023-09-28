__RAM_DISK_S_TILED_IMAGES_DATA = RAM_DISK_S
__RAM_DISK_M_TILED_IMAGES_DATA = RAM_DISK_M

TILED_IMG_SCR_BUFFS = 4
TILED_IMG_TILE_H = 8
TILE_IMG_TILE_LEN = TILED_IMG_TILE_H * TILED_IMG_SCR_BUFFS + 2 ; 8*4 bytes + a couple of safety bytes

__TILED_IMAGES_FRAME_INGAME_DIALOG_COPY_LEN = 22
			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_frame_ingame_dialog:
			.byte __TILED_IMAGES_MAIN_MENU_BACK2_COPY_LEN, __RAM_DISK_S_TILED_IMAGES_DATA
			.word __tiled_images_tile1 - TILE_IMG_TILE_LEN
			.word SCR_BUFF0_ADDR + (0<<8 | 0)	; scr addr
			.word SCR_BUFF0_ADDR + (32<<8 | 64)	; scr addr end
			.byte 8,255,9,30,10,7,255,5,30,6,4,255,5,30,6,4,255,5,30,6,4,255,5,30,6,4,255,5,30,6,4,255,
			.byte 5,30,6,1,255,2,30,3,

__TILED_IMAGES_MAIN_MENU_BACK2_COPY_LEN = 99
			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_main_menu_back2:
			.byte __TILED_IMAGES_MAIN_MENU_BACK2_COPY_LEN, __RAM_DISK_S_TILED_IMAGES_DATA
			.word __tiled_images_tile1 - TILE_IMG_TILE_LEN
			.word SCR_BUFF0_ADDR + (0<<8 | 0)	; scr addr
			.word SCR_BUFF0_ADDR + (32<<8 | 136)	; scr addr end
			.byte 31,32,33,34,35,36,37,35,36,33,34,36,37,35,36,33,34,35,36,38,37,35,36,33,34,35,36,34,35,36,39,31,
			.byte 24,25,26,27,26,27,28,26,27,27,26,27,28,26,27,26,27,26,27,29,28,26,27,27,29,26,27,29,26,27,30,24,
			.byte 18,19,20,21,20,21,20,21,20,21,20,21,20,21,20,21,20,21,20,21,20,20,20,21,21,20,20,21,21,21,22,23,
			.byte 11,15,255,0,28,13,14,17,12,255,0,28,16,14,11,15,255,0,28,16,14,11,15,255,0,28,13,14,11,12,255,0,
			.byte 28,16,14,11,12,255,0,28,13,14,11,15,255,0,28,16,14,11,12,255,0,28,13,14,11,15,255,0,28,16,14,11,
			.byte 12,255,0,28,13,14,11,15,255,0,28,16,14,11,12,255,0,28,13,14,11,15,255,0,28,16,14,11,12,255,0,28,
			.byte 13,14,

__TILED_IMAGES_MAIN_MENU_BACK1_COPY_LEN = 80
			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_main_menu_back1:
			.byte __TILED_IMAGES_MAIN_MENU_BACK2_COPY_LEN, __RAM_DISK_S_TILED_IMAGES_DATA
			.word __tiled_images_tile1 - TILE_IMG_TILE_LEN
			.word SCR_BUFF0_ADDR + (0<<8 | 136)	; scr addr
			.word SCR_BUFF0_ADDR + (32<<8 | 0)	; scr addr end
			.byte 11,15,255,0,28,16,30,30,12,255,0,28,13,23,18,15,255,0,28,16,14,11,12,255,0,28,13,14,11,15,255,0,
			.byte 28,16,14,11,15,255,0,28,13,14,11,12,255,0,28,16,14,11,15,255,0,28,13,14,11,12,255,0,28,16,14,11,
			.byte 15,255,0,28,13,14,11,12,255,0,28,16,14,11,15,255,0,28,13,14,11,12,255,0,28,13,14,11,40,41,42,41,
			.byte 42,41,41,42,42,41,42,42,42,41,41,42,42,41,41,42,42,41,42,42,41,42,42,41,42,42,14,18,19,19,29,28,
			.byte 26,27,29,28,26,27,29,28,27,26,27,26,27,29,28,26,27,26,31,27,28,28,26,27,18,23,23,

__TILED_IMAGES_TITLE1_COPY_LEN = 93
			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_title1:
			.byte __TILED_IMAGES_MAIN_MENU_BACK2_COPY_LEN, __RAM_DISK_S_TILED_IMAGES_DATA
			.word __tiled_images_tile1 - TILE_IMG_TILE_LEN
			.word SCR_BUFF0_ADDR + (4<<8 | 160)	; scr addr
			.word SCR_BUFF0_ADDR + (27<<8 | 232)	; scr addr end
			.byte 166,167,168,169,170,255,171,15,172,0,0,151,152,153,154,155,156,157,158,159,160,159,161,
			.byte 160,159,159,160,160,159,156,162,163,164,165,0,132,133,134,135,136,137,138,139,140,141,142,
			.byte 143,144,145,146,138,147,148,0,149,150,0,0,0,116,117,118,0,119,120,0,121,122,123,
			.byte 124,125,0,126,120,127,128,129,130,131,0,0,0,97,98,99,100,101,102,0,103,104,105,
			.byte 106,107,108,109,110,111,112,113,114,115,0,0,0,78,0,79,80,81,82,83,84,85,86,
			.byte 87,88,89,90,91,92,93,0,94,95,96,255,0,4,64,65,66,67,68,69,70,71,72,
			.byte 73,74,75,76,77,255,0,5,255,0,4,50,51,52,53,54,55,56,57,58,59,60,61,
			.byte 62,63,255,0,5,255,0,5,43,44,45,255,0,7,46,47,48,49,255,0,4,

__TILED_IMAGES_FRAME_MAIN_MENU_COPY_LEN = 54
			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_frame_main_menu:
			.byte __TILED_IMAGES_MAIN_MENU_BACK2_COPY_LEN, __RAM_DISK_S_TILED_IMAGES_DATA
			.word __tiled_images_tile1 - TILE_IMG_TILE_LEN
			.word SCR_BUFF0_ADDR + (9<<8 | 56)	; scr addr
			.word SCR_BUFF0_ADDR + (23<<8 | 160)	; scr addr end
			.byte 41,42,41,42,42,41,42,41,42,41,42,41,42,0,
			.byte 8,255,9,11,10,15,7,12,255,0,10,6,12,4,
			.byte 15,255,0,10,6,15,4,12,255,0,10,6,12,4,
			.byte 15,255,0,10,6,15,4,12,255,0,10,6,12,4,
			.byte 15,255,0,10,6,15,4,12,255,0,10,6,12,4,
			.byte 15,255,0,10,6,15,4,12,255,0,10,6,12,4,
			.byte 173,42,41,42,41,42,41,41,42,41,42,6,15,1,
			.byte 255,2,11,3,12,

__TILED_IMAGES_FRAME_INGAME_TOP_COPY_LEN = 31
			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_frame_ingame_top:
			.byte __TILED_IMAGES_MAIN_MENU_BACK2_COPY_LEN, __RAM_DISK_S_TILED_IMAGES_DATA
			.word __tiled_images_tile1 - TILE_IMG_TILE_LEN
			.word SCR_BUFF0_ADDR + (0<<8 | 240)	; scr addr
			.word SCR_BUFF0_ADDR + (32<<8 | 0)	; scr addr end
			.byte 185,186,187,188,188,188,189,190,188,188,188,189,190,188,189,190,188,188,189,190,188,191,192,193,194,255,188,6,195,174,175,176,
			.byte 177,177,177,178,179,177,177,177,178,179,177,178,179,177,177,178,179,177,180,181,182,183,255,177,6,184,

__TILED_IMAGES_RES_MANA_COPY_LEN = 6
			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_res_mana:
			.byte __TILED_IMAGES_MAIN_MENU_BACK2_COPY_LEN, __RAM_DISK_S_TILED_IMAGES_DATA
			.word __tiled_images_tile1 - TILE_IMG_TILE_LEN
			.word SCR_BUFF0_ADDR + (6<<8 | 240)	; scr addr
			.word SCR_BUFF0_ADDR + (10<<8 | 0)	; scr addr end
			.byte 198,199,188,188,
			.byte 196,197,177,177,

__TILED_IMAGES_RES_SWORD_COPY_LEN = 4
			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_res_sword:
			.byte __TILED_IMAGES_MAIN_MENU_BACK2_COPY_LEN, __RAM_DISK_S_TILED_IMAGES_DATA
			.word __tiled_images_tile1 - TILE_IMG_TILE_LEN
			.word SCR_BUFF0_ADDR + (11<<8 | 240)	; scr addr
			.word SCR_BUFF0_ADDR + (13<<8 | 0)	; scr addr end
			.byte 202,203,
			.byte 200,201,

__TILED_IMAGES_RES_POTION_HEALTH_COPY_LEN = 6
			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_res_potion_health:
			.byte __TILED_IMAGES_MAIN_MENU_BACK2_COPY_LEN, __RAM_DISK_S_TILED_IMAGES_DATA
			.word __tiled_images_tile1 - TILE_IMG_TILE_LEN
			.word SCR_BUFF0_ADDR + (14<<8 | 240)	; scr addr
			.word SCR_BUFF0_ADDR + (18<<8 | 0)	; scr addr end
			.byte 205,206,188,188,
			.byte 204,197,177,177,

__TILED_IMAGES_RES_POTION_MANA_COPY_LEN = 6
			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_res_potion_mana:
			.byte __TILED_IMAGES_MAIN_MENU_BACK2_COPY_LEN, __RAM_DISK_S_TILED_IMAGES_DATA
			.word __tiled_images_tile1 - TILE_IMG_TILE_LEN
			.word SCR_BUFF0_ADDR + (14<<8 | 240)	; scr addr
			.word SCR_BUFF0_ADDR + (18<<8 | 0)	; scr addr end
			.byte 209,210,188,188,
			.byte 207,208,177,177,

__TILED_IMAGES_RES_CLOTHES_COPY_LEN = 6
			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_res_clothes:
			.byte __TILED_IMAGES_MAIN_MENU_BACK2_COPY_LEN, __RAM_DISK_S_TILED_IMAGES_DATA
			.word __tiled_images_tile1 - TILE_IMG_TILE_LEN
			.word SCR_BUFF0_ADDR + (14<<8 | 240)	; scr addr
			.word SCR_BUFF0_ADDR + (18<<8 | 0)	; scr addr end
			.byte 213,214,188,188,
			.byte 211,212,177,177,

__TILED_IMAGES_RES_CABBAGE_COPY_LEN = 6
			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_res_cabbage:
			.byte __TILED_IMAGES_MAIN_MENU_BACK2_COPY_LEN, __RAM_DISK_S_TILED_IMAGES_DATA
			.word __tiled_images_tile1 - TILE_IMG_TILE_LEN
			.word SCR_BUFF0_ADDR + (14<<8 | 240)	; scr addr
			.word SCR_BUFF0_ADDR + (18<<8 | 0)	; scr addr end
			.byte 217,218,188,188,
			.byte 215,216,177,177,

__TILED_IMAGES_RES_TNT_COPY_LEN = 6
			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_res_tnt:
			.byte __TILED_IMAGES_MAIN_MENU_BACK2_COPY_LEN, __RAM_DISK_S_TILED_IMAGES_DATA
			.word __tiled_images_tile1 - TILE_IMG_TILE_LEN
			.word SCR_BUFF0_ADDR + (14<<8 | 240)	; scr addr
			.word SCR_BUFF0_ADDR + (18<<8 | 0)	; scr addr end
			.byte 221,222,188,188,
			.byte 219,220,177,177,

__TILED_IMAGES_ITEM_KEY_0_COPY_LEN = 4
			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_item_key_0:
			.byte __TILED_IMAGES_MAIN_MENU_BACK2_COPY_LEN, __RAM_DISK_S_TILED_IMAGES_DATA
			.word __tiled_images_tile1 - TILE_IMG_TILE_LEN
			.word SCR_BUFF0_ADDR + (18<<8 | 240)	; scr addr
			.word SCR_BUFF0_ADDR + (20<<8 | 0)	; scr addr end
			.byte 225,226,
			.byte 223,224,

__TILED_IMAGES_ITEM_KEY_1_COPY_LEN = 4
			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_item_key_1:
			.byte __TILED_IMAGES_MAIN_MENU_BACK2_COPY_LEN, __RAM_DISK_S_TILED_IMAGES_DATA
			.word __tiled_images_tile1 - TILE_IMG_TILE_LEN
			.word SCR_BUFF0_ADDR + (18<<8 | 240)	; scr addr
			.word SCR_BUFF0_ADDR + (20<<8 | 0)	; scr addr end
			.byte 229,230,
			.byte 227,228,

__TILED_IMAGES_ITEM_KEY_2_COPY_LEN = 4
			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_item_key_2:
			.byte __TILED_IMAGES_MAIN_MENU_BACK2_COPY_LEN, __RAM_DISK_S_TILED_IMAGES_DATA
			.word __tiled_images_tile1 - TILE_IMG_TILE_LEN
			.word SCR_BUFF0_ADDR + (18<<8 | 240)	; scr addr
			.word SCR_BUFF0_ADDR + (20<<8 | 0)	; scr addr end
			.byte 233,234,
			.byte 231,232,

__TILED_IMAGES_ITEM_KEY_3_COPY_LEN = 4
			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_item_key_3:
			.byte __TILED_IMAGES_MAIN_MENU_BACK2_COPY_LEN, __RAM_DISK_S_TILED_IMAGES_DATA
			.word __tiled_images_tile1 - TILE_IMG_TILE_LEN
			.word SCR_BUFF0_ADDR + (18<<8 | 240)	; scr addr
			.word SCR_BUFF0_ADDR + (20<<8 | 0)	; scr addr end
			.byte 237,238,
			.byte 235,236,

__TILED_IMAGES_RES_EMPTY_MANA_COPY_LEN = 6
			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_res_empty_mana:
			.byte __TILED_IMAGES_MAIN_MENU_BACK2_COPY_LEN, __RAM_DISK_S_TILED_IMAGES_DATA
			.word __tiled_images_tile1 - TILE_IMG_TILE_LEN
			.word SCR_BUFF0_ADDR + (6<<8 | 240)	; scr addr
			.word SCR_BUFF0_ADDR + (10<<8 | 0)	; scr addr end
			.byte 189,190,188,188,
			.byte 178,179,177,177,

__TILED_IMAGES_RES_EMPTY_SWORD_COPY_LEN = 4
			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_res_empty_sword:
			.byte __TILED_IMAGES_MAIN_MENU_BACK2_COPY_LEN, __RAM_DISK_S_TILED_IMAGES_DATA
			.word __tiled_images_tile1 - TILE_IMG_TILE_LEN
			.word SCR_BUFF0_ADDR + (11<<8 | 240)	; scr addr
			.word SCR_BUFF0_ADDR + (13<<8 | 0)	; scr addr end
			.byte 189,190,
			.byte 178,179,

__TILED_IMAGES_RES_EMPTY_COPY_LEN = 6
			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_res_empty:
			.byte __TILED_IMAGES_MAIN_MENU_BACK2_COPY_LEN, __RAM_DISK_S_TILED_IMAGES_DATA
			.word __tiled_images_tile1 - TILE_IMG_TILE_LEN
			.word SCR_BUFF0_ADDR + (14<<8 | 240)	; scr addr
			.word SCR_BUFF0_ADDR + (18<<8 | 0)	; scr addr end
			.byte 189,190,188,188,
			.byte 178,179,177,177,

__TILED_IMAGES_ITEM_KEY_EMPTY_COPY_LEN = 4
			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_item_key_empty:
			.byte __TILED_IMAGES_MAIN_MENU_BACK2_COPY_LEN, __RAM_DISK_S_TILED_IMAGES_DATA
			.word __tiled_images_tile1 - TILE_IMG_TILE_LEN
			.word SCR_BUFF0_ADDR + (18<<8 | 240)	; scr addr
			.word SCR_BUFF0_ADDR + (20<<8 | 0)	; scr addr end
			.byte 189,190,
			.byte 178,179,

