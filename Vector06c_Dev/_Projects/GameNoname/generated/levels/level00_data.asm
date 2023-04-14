__RAM_DISK_S_LEVEL00_DATA = RAM_DISK_S
__RAM_DISK_M_LEVEL00_DATA = RAM_DISK_M

			.word 0 ; safety pair of bytes for reading by POP B
__level00_start_pos:										; a hero starting pos
			.byte 160						; pos_y
			.byte 48						; pos_x

			.word 0 ; safety pair of bytes for reading by POP B
__level00_rooms_addr:
			.word __level00_room00, 

			.word 0 ; safety pair of bytes for reading by POP B
; source\levels\level00_room00.tmj
__level00_room00:
			.byte 152,0,145,2,0,143,2,37,222,161,3,33,97,35,36,20,
			.byte 21,31,8,9,10,11,37,6,147,27,28,26,23,29,30,167,
			.byte 216,32,33,34,224,174,246,26,15,16,5,254,152,24,132,25,
			.byte 5,227,141,20,22,222,196,253,162,23,14,15,242,166,30,4,
			.byte 17,18,7,19,145,230,13,230,126,7,7,6,60,243,7,228,
			.byte 230,36,12,2,2,56,200,205,192,191,1,41,147,39,248,218,
			.byte 246,4,124,250,40,2,115,126,11,1,146,194,245,32,254,164,
			.byte 1,120,224,191,255,254,232,224,16,40,3,57,216,232,238,46,
			.byte 32,99,1,113,161,134,18,143,178,168,125,128,255,226,96,94,
			.byte 224,83,248,98,0,246,26,56,192,193,160,171,17,114,218,128,
			.byte 2,80,232,65,19,105,99,15,254,92,0,2,

__level00_resources_inst_data_ptrs:
			.byte NULL_PTR, 4, 6, 8, 
__level00_resources_inst_data:
			.byte 67, 0, 
			.byte 165, 0, 

__level00_containers_inst_data_ptrs:
			.byte NULL_PTR, NULL_PTR, 4, 6, 
__level00_containers_inst_data:
			.byte 77, 0, 
