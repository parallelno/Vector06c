__RAM_DISK_S_TILED_IMAGES_DATA = RAM_DISK_S
__RAM_DISK_M_TILED_IMAGES_DATA = RAM_DISK_M


			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_tiled_imgs_addr:
			.word __tiled_images_frame_ingame_top, 0, __tiled_images_frame_main_menu, 0, __tiled_images_frame_ingame_dialog, 

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_frame_ingame_dialog:
			.byte 0, 1 ; pos_y, pos_x
			.byte 4,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,
			.byte 4,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,
			.byte 4,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,
			.byte 1,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_frame_main_menu:
			.byte 80, 5 ; pos_y, pos_x
			.byte 0,0,0,0,0,4,5,5,5,5,5,5,5,5,5,5,5,6,0,0,0,0,
			.byte 0,0,0,0,0,4,5,5,5,5,5,5,5,5,5,5,5,6,0,0,0,0,
			.byte 0,0,0,0,0,4,5,5,5,5,5,5,5,5,5,5,5,6,0,0,0,0,
			.byte 0,0,0,0,0,4,5,5,5,5,5,5,5,5,5,5,5,6,0,0,0,0,
			.byte 0,0,0,0,0,4,5,5,5,5,5,5,5,5,5,5,5,6,0,0,0,0,
			.byte 0,0,0,0,0,4,5,5,5,5,5,5,5,5,5,5,5,6,0,0,0,0,
			.byte 0,0,0,0,0,4,5,5,5,5,5,5,5,5,5,5,5,6,0,0,0,0,
			.byte 0,0,0,0,0,4,5,5,5,5,5,5,5,5,5,5,5,6,0,0,0,0,
			.byte 0,0,0,0,0,4,5,5,5,5,5,5,5,5,5,5,5,6,0,0,0,0,
			.byte 0,0,0,0,0,4,5,5,5,5,5,5,5,5,5,5,5,6,0,0,0,0,
			.byte 0,0,0,0,0,1,2,2,2,2,2,2,2,2,2,2,2,3,0,0,0,0,
			.byte 0,131,132,133,134,135,135,135,135,135,135,135,135,135,135,135,135,135,135,136,0,0,
			.byte 121,122,123,124,125,126,126,126,126,126,126,126,126,126,126,126,126,126,126,127,128,129,
			.byte 0,0,103,104,105,106,107,108,109,110,111,0,112,113,114,115,116,117,118,0,119,120,
			.byte 0,0,85,86,87,88,89,90,0,91,92,93,94,95,0,96,97,98,99,100,101,102,
			.byte 0,0,66,67,68,69,70,71,0,72,73,74,75,76,77,78,79,80,81,82,83,84,
			.byte 0,0,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,0,63,64,
			.byte 0,0,0,0,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,0,0,0,
			.byte 0,0,0,0,17,18,19,20,21,22,23,24,25,26,27,28,29,30,0,0,0,0,
			.byte 0,0,0,0,0,10,11,12,0,0,0,0,0,0,0,13,14,15,16,0,0,0,

			.word 0 ; safety pair of bytes for reading by POP B
__tiled_images_frame_ingame_top:
			.byte 224, 0 ; pos_y, pos_x
			.byte 4,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,
			.byte 4,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,
			.byte 1,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,
