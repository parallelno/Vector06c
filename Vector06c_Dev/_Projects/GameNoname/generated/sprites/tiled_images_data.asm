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

__TILED_IMAGES_MAIN_MENU_BACK2_COPY_LEN = 96
			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_main_menu_back2:
			.byte __TILED_IMAGES_MAIN_MENU_BACK2_COPY_LEN, __RAM_DISK_S_TILED_IMAGES_DATA
			.word __tiled_images_tile1 - TILE_IMG_TILE_LEN
			.word SCR_BUFF0_ADDR + (0<<8 | 0)	; scr addr
			.word SCR_BUFF0_ADDR + (32<<8 | 128)	; scr addr end
			.byte 30,31,32,33,34,35,36,34,35,32,33,35,36,34,35,32,33,34,35,37,36,34,35,32,33,34,35,33,34,35,38,30,
			.byte 23,24,25,26,25,26,27,25,26,26,25,26,27,25,26,25,26,25,26,28,27,25,26,26,28,25,26,28,25,26,29,23,
			.byte 17,18,19,20,19,20,19,20,19,20,19,20,19,20,19,20,19,20,19,20,19,19,19,20,20,19,19,20,20,20,21,22,
			.byte 11,12,255,0,28,16,14,11,15,255,0,28,13,14,11,12,255,0,28,13,14,11,12,255,0,28,16,14,11,15,255,0,
			.byte 28,13,14,11,15,255,0,28,16,14,11,12,255,0,28,13,14,11,15,255,0,28,16,14,11,12,255,0,28,13,14,11,
			.byte 15,255,0,28,16,14,11,12,255,0,28,13,14,11,15,255,0,28,16,14,11,12,255,0,28,13,14,

__TILED_IMAGES_MAIN_MENU_BACK1_COPY_LEN = 83
			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_main_menu_back1:
			.byte __TILED_IMAGES_MAIN_MENU_BACK2_COPY_LEN, __RAM_DISK_S_TILED_IMAGES_DATA
			.word __tiled_images_tile1 - TILE_IMG_TILE_LEN
			.word SCR_BUFF0_ADDR + (0<<8 | 128)	; scr addr
			.word SCR_BUFF0_ADDR + (32<<8 | 0)	; scr addr end
			.byte 11,12,255,0,28,16,14,11,12,255,0,28,13,29,29,15,255,0,28,16,22,17,12,255,0,28,13,14,11,15,255,0,
			.byte 28,16,14,11,12,255,0,28,13,14,11,12,255,0,28,16,14,11,15,255,0,28,13,14,11,12,255,0,28,16,14,11,
			.byte 15,255,0,28,13,14,11,12,255,0,28,16,14,11,15,255,0,28,13,14,11,12,255,0,28,16,14,11,15,255,0,28,
			.byte 16,14,11,39,40,41,40,41,40,40,41,41,40,41,41,41,40,40,41,41,40,40,41,41,40,41,41,40,41,41,40,41,
			.byte 41,14,17,18,18,28,27,25,26,28,27,25,26,28,27,26,25,26,25,26,28,27,25,26,25,30,26,27,27,25,26,17,
			.byte 22,22,

__TILED_IMAGES_TITLE1_COPY_LEN = 93
			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_title1:
			.byte __TILED_IMAGES_MAIN_MENU_BACK2_COPY_LEN, __RAM_DISK_S_TILED_IMAGES_DATA
			.word __tiled_images_tile1 - TILE_IMG_TILE_LEN
			.word SCR_BUFF0_ADDR + (4<<8 | 160)	; scr addr
			.word SCR_BUFF0_ADDR + (27<<8 | 232)	; scr addr end
			.byte 165,166,167,168,169,255,170,15,171,0,0,150,151,152,153,154,155,156,157,158,159,158,160,
			.byte 159,158,158,159,159,158,155,161,162,163,164,0,131,132,133,134,135,136,137,138,139,140,141,
			.byte 142,143,144,145,137,146,147,0,148,149,0,0,0,115,116,117,0,118,119,0,120,121,122,
			.byte 123,124,0,125,119,126,127,128,129,130,0,0,0,96,97,98,99,100,101,0,102,103,104,
			.byte 105,106,107,108,109,110,111,112,113,114,0,0,0,77,0,78,79,80,81,82,83,84,85,
			.byte 86,87,88,89,90,91,92,0,93,94,95,255,0,4,63,64,65,66,67,68,69,70,71,
			.byte 72,73,74,75,76,255,0,5,255,0,4,49,50,51,52,53,54,55,56,57,58,59,60,
			.byte 61,62,255,0,5,255,0,5,42,43,44,255,0,7,45,46,47,48,255,0,4,

__TILED_IMAGES_FRAME_MAIN_MENU_COPY_LEN = 54
			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_frame_main_menu:
			.byte __TILED_IMAGES_MAIN_MENU_BACK2_COPY_LEN, __RAM_DISK_S_TILED_IMAGES_DATA
			.word __tiled_images_tile1 - TILE_IMG_TILE_LEN
			.word SCR_BUFF0_ADDR + (9<<8 | 56)	; scr addr
			.word SCR_BUFF0_ADDR + (23<<8 | 160)	; scr addr end
			.byte 40,41,40,41,41,40,41,40,41,40,41,40,41,0,
			.byte 8,255,9,11,10,12,7,15,255,0,10,6,15,4,
			.byte 12,255,0,10,6,12,4,15,255,0,10,6,15,4,
			.byte 12,255,0,10,6,12,4,15,255,0,10,6,15,4,
			.byte 12,255,0,10,6,12,4,15,255,0,10,6,15,4,
			.byte 12,255,0,10,6,12,4,15,255,0,10,6,15,4,
			.byte 172,41,40,41,40,41,40,40,41,40,41,6,12,1,
			.byte 255,2,11,3,15,

__TILED_IMAGES_FRAME_INGAME_TOP_COPY_LEN = 22
			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_frame_ingame_top:
			.byte __TILED_IMAGES_MAIN_MENU_BACK2_COPY_LEN, __RAM_DISK_S_TILED_IMAGES_DATA
			.word __tiled_images_tile1 - TILE_IMG_TILE_LEN
			.word SCR_BUFF0_ADDR + (0<<8 | 240)	; scr addr
			.word SCR_BUFF0_ADDR + (32<<8 | 0)	; scr addr end
			.byte 183,184,185,186,186,187,255,186,12,187,186,186,188,189,190,191,255,186,6,192,173,174,175,176,176,177,255,176,12,177,176,176,
			.byte 178,179,180,181,255,176,6,182,

__TILED_IMAGES_RES_MANA_COPY_LEN = 6
			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_res_mana:
			.byte __TILED_IMAGES_MAIN_MENU_BACK2_COPY_LEN, __RAM_DISK_S_TILED_IMAGES_DATA
			.word __tiled_images_tile1 - TILE_IMG_TILE_LEN
			.word SCR_BUFF0_ADDR + (6<<8 | 240)	; scr addr
			.word SCR_BUFF0_ADDR + (10<<8 | 0)	; scr addr end
			.byte 195,196,186,186,
			.byte 193,194,176,176,

__TILED_IMAGES_RES_SWORD_COPY_LEN = 6
			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_res_sword:
			.byte __TILED_IMAGES_MAIN_MENU_BACK2_COPY_LEN, __RAM_DISK_S_TILED_IMAGES_DATA
			.word __tiled_images_tile1 - TILE_IMG_TILE_LEN
			.word SCR_BUFF0_ADDR + (6<<8 | 240)	; scr addr
			.word SCR_BUFF0_ADDR + (10<<8 | 0)	; scr addr end
			.byte 199,200,186,186,
			.byte 197,198,176,176,

__TILED_IMAGES_RES_POTION_HEALTH_COPY_LEN = 6
			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_res_potion_health:
			.byte __TILED_IMAGES_MAIN_MENU_BACK2_COPY_LEN, __RAM_DISK_S_TILED_IMAGES_DATA
			.word __tiled_images_tile1 - TILE_IMG_TILE_LEN
			.word SCR_BUFF0_ADDR + (6<<8 | 240)	; scr addr
			.word SCR_BUFF0_ADDR + (10<<8 | 0)	; scr addr end
			.byte 202,203,186,186,
			.byte 201,194,176,176,

__TILED_IMAGES_RES_POTION_MANA_COPY_LEN = 6
			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_res_potion_mana:
			.byte __TILED_IMAGES_MAIN_MENU_BACK2_COPY_LEN, __RAM_DISK_S_TILED_IMAGES_DATA
			.word __tiled_images_tile1 - TILE_IMG_TILE_LEN
			.word SCR_BUFF0_ADDR + (6<<8 | 240)	; scr addr
			.word SCR_BUFF0_ADDR + (10<<8 | 0)	; scr addr end
			.byte 206,207,186,186,
			.byte 204,205,176,176,

__TILED_IMAGES_RES_TNT_COPY_LEN = 6
			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_res_tnt:
			.byte __TILED_IMAGES_MAIN_MENU_BACK2_COPY_LEN, __RAM_DISK_S_TILED_IMAGES_DATA
			.word __tiled_images_tile1 - TILE_IMG_TILE_LEN
			.word SCR_BUFF0_ADDR + (6<<8 | 240)	; scr addr
			.word SCR_BUFF0_ADDR + (10<<8 | 0)	; scr addr end
			.byte 210,211,186,186,
			.byte 208,209,176,176,

__TILED_IMAGES_RES_CLOTHES_COPY_LEN = 6
			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_res_clothes:
			.byte __TILED_IMAGES_MAIN_MENU_BACK2_COPY_LEN, __RAM_DISK_S_TILED_IMAGES_DATA
			.word __tiled_images_tile1 - TILE_IMG_TILE_LEN
			.word SCR_BUFF0_ADDR + (6<<8 | 240)	; scr addr
			.word SCR_BUFF0_ADDR + (10<<8 | 0)	; scr addr end
			.byte 214,215,186,186,
			.byte 212,213,176,176,

__TILED_IMAGES_RES_CABBAGE_COPY_LEN = 6
			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_res_cabbage:
			.byte __TILED_IMAGES_MAIN_MENU_BACK2_COPY_LEN, __RAM_DISK_S_TILED_IMAGES_DATA
			.word __tiled_images_tile1 - TILE_IMG_TILE_LEN
			.word SCR_BUFF0_ADDR + (6<<8 | 240)	; scr addr
			.word SCR_BUFF0_ADDR + (10<<8 | 0)	; scr addr end
			.byte 218,219,186,186,
			.byte 216,217,176,176,

__TILED_IMAGES_ITEM_KEY_0_COPY_LEN = 4
			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_item_key_0:
			.byte __TILED_IMAGES_MAIN_MENU_BACK2_COPY_LEN, __RAM_DISK_S_TILED_IMAGES_DATA
			.word __tiled_images_tile1 - TILE_IMG_TILE_LEN
			.word SCR_BUFF0_ADDR + (19<<8 | 240)	; scr addr
			.word SCR_BUFF0_ADDR + (21<<8 | 0)	; scr addr end
			.byte 222,223,
			.byte 220,221,

__TILED_IMAGES_ITEM_KEY_1_COPY_LEN = 4
			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_item_key_1:
			.byte __TILED_IMAGES_MAIN_MENU_BACK2_COPY_LEN, __RAM_DISK_S_TILED_IMAGES_DATA
			.word __tiled_images_tile1 - TILE_IMG_TILE_LEN
			.word SCR_BUFF0_ADDR + (19<<8 | 240)	; scr addr
			.word SCR_BUFF0_ADDR + (21<<8 | 0)	; scr addr end
			.byte 226,227,
			.byte 224,225,

__TILED_IMAGES_ITEM_KEY_2_COPY_LEN = 4
			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_item_key_2:
			.byte __TILED_IMAGES_MAIN_MENU_BACK2_COPY_LEN, __RAM_DISK_S_TILED_IMAGES_DATA
			.word __tiled_images_tile1 - TILE_IMG_TILE_LEN
			.word SCR_BUFF0_ADDR + (19<<8 | 240)	; scr addr
			.word SCR_BUFF0_ADDR + (21<<8 | 0)	; scr addr end
			.byte 230,231,
			.byte 228,229,

__TILED_IMAGES_ITEM_KEY_3_COPY_LEN = 4
			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_item_key_3:
			.byte __TILED_IMAGES_MAIN_MENU_BACK2_COPY_LEN, __RAM_DISK_S_TILED_IMAGES_DATA
			.word __tiled_images_tile1 - TILE_IMG_TILE_LEN
			.word SCR_BUFF0_ADDR + (19<<8 | 240)	; scr addr
			.word SCR_BUFF0_ADDR + (21<<8 | 0)	; scr addr end
			.byte 234,235,
			.byte 232,233,

__TILED_IMAGES_RES_EMPTY_COPY_LEN = 5
			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_res_empty:
			.byte __TILED_IMAGES_MAIN_MENU_BACK2_COPY_LEN, __RAM_DISK_S_TILED_IMAGES_DATA
			.word __tiled_images_tile1 - TILE_IMG_TILE_LEN
			.word SCR_BUFF0_ADDR + (6<<8 | 240)	; scr addr
			.word SCR_BUFF0_ADDR + (10<<8 | 0)	; scr addr end
			.byte 255,186,4,255,
			.byte 176,4,

__TILED_IMAGES_ITEM_EMPTY_COPY_LEN = 4
			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_item_empty:
			.byte __TILED_IMAGES_MAIN_MENU_BACK2_COPY_LEN, __RAM_DISK_S_TILED_IMAGES_DATA
			.word __tiled_images_tile1 - TILE_IMG_TILE_LEN
			.word SCR_BUFF0_ADDR + (19<<8 | 240)	; scr addr
			.word SCR_BUFF0_ADDR + (21<<8 | 0)	; scr addr end
			.byte 186,186,
			.byte 176,176,

