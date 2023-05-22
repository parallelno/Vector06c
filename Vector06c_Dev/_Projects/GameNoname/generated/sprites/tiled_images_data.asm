__RAM_DISK_S_TILED_IMAGES_DATA = RAM_DISK_S
__RAM_DISK_M_TILED_IMAGES_DATA = RAM_DISK_M

__TILED_IMAGES_FRAME_INGAME_DIALOG_LEN = 150
__TILED_IMAGES_FRAME_INGAME_DIALOG_SCR_ADDR = SCR_BUFF0_ADDR + (1<<8 | 0)
__TILED_IMAGES_FRAME_INGAME_DIALOG_SCR_ADDR_END = SCR_BUFF0_ADDR + (31<<8 | 40)
			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_frame_ingame_dialog:
			.byte 7,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,9,
			.byte 4,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,6,
			.byte 4,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,6,
			.byte 4,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,6,
			.byte 1,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,3,

__TILED_IMAGES_FRAME_MAIN_MENU_LEN = 156
__TILED_IMAGES_FRAME_MAIN_MENU_SCR_ADDR = SCR_BUFF0_ADDR + (10<<8 | 80)
__TILED_IMAGES_FRAME_MAIN_MENU_SCR_ADDR_END = SCR_BUFF0_ADDR + (23<<8 | 176)
			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_frame_main_menu:
			.byte 7,8,8,8,8,8,8,8,8,8,8,8,9,
			.byte 4,5,5,5,5,5,5,5,5,5,5,5,6,
			.byte 4,5,5,5,5,5,5,5,5,5,5,5,6,
			.byte 4,5,5,5,5,5,5,5,5,5,5,5,6,
			.byte 4,5,5,5,5,5,5,5,5,5,5,5,6,
			.byte 4,5,5,5,5,5,5,5,5,5,5,5,6,
			.byte 4,5,5,5,5,5,5,5,5,5,5,5,6,
			.byte 4,5,5,5,5,5,5,5,5,5,5,5,6,
			.byte 4,5,5,5,5,5,5,5,5,5,5,5,6,
			.byte 4,5,5,5,5,5,5,5,5,5,5,5,6,
			.byte 4,5,5,5,5,5,5,5,5,5,5,5,6,
			.byte 1,2,2,2,2,2,2,2,2,2,2,2,3,

__TILED_IMAGES_TITLE_LEN = 207
__TILED_IMAGES_TITLE_SCR_ADDR = SCR_BUFF0_ADDR + (5<<8 | 176)
__TILED_IMAGES_TITLE_SCR_ADDR_END = SCR_BUFF0_ADDR + (28<<8 | 248)
			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_title:
			.byte 0,131,132,133,134,135,135,135,135,135,135,135,135,135,135,135,135,135,135,136,0,0,0,
			.byte 121,122,123,124,125,126,126,126,126,126,126,126,126,126,126,126,126,126,126,127,128,129,130,
			.byte 0,0,103,104,105,106,107,108,109,110,111,0,112,113,114,115,116,117,118,0,119,120,0,
			.byte 0,0,85,86,87,88,89,90,0,91,92,93,94,95,0,96,97,98,99,100,101,102,0,
			.byte 0,0,66,67,68,69,70,71,0,72,73,74,75,76,77,78,79,80,81,82,83,84,0,
			.byte 0,0,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,0,63,64,65,
			.byte 0,0,0,0,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,0,0,0,0,
			.byte 0,0,0,0,17,18,19,20,21,22,23,24,25,26,27,28,29,30,0,0,0,0,0,
			.byte 0,0,0,0,0,10,11,12,0,0,0,0,0,0,0,13,14,15,16,0,0,0,0,

__TILED_IMAGES_FRAME_INGAME_TOP_LEN = 128
__TILED_IMAGES_FRAME_INGAME_TOP_SCR_ADDR = SCR_BUFF0_ADDR + (0<<8 | 224)
__TILED_IMAGES_FRAME_INGAME_TOP_SCR_ADDR_END = SCR_BUFF0_ADDR + (32<<8 | 256)
			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_frame_ingame_top:
			.byte 7,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,9,
			.byte 4,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,6,
			.byte 4,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,6,
			.byte 1,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,3,

