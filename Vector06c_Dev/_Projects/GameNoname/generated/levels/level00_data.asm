__RAM_DISK_S_LEVEL00_DATA = RAM_DISK_S
__RAM_DISK_M_LEVEL00_DATA = RAM_DISK_M

			.word 0 ; safety pair of bytes for reading by POP B
__level00_start_pos:										; a hero starting pos
			.byte 140						; pos_y
			.byte 120						; pos_x

			.word 0 ; safety pair of bytes for reading by POP B
__level00_rooms_addr:
			.word __level00_room00, 

			.word 0 ; safety pair of bytes for reading by POP B
; source\levels\level00_room00.tmj
__level00_room00:
			.byte 161,2,130,32,13,30,32,23,23,13,37,7,21,31,35,39,
			.byte 19,32,33,31,138,224,30,184,11,217,58,2,37,1,11,229,
			.byte 12,99,25,19,136,225,12,30,159,2,24,25,160,145,131,33,
			.byte 1,38,36,24,32,33,1,37,27,9,15,11,224,195,105,62,
			.byte 1,25,35,36,2,18,9,22,224,104,22,15,1,224,20,21,
			.byte 103,248,21,7,34,28,192,142,28,2,127,227,11,37,14,10,
			.byte 154,224,1,128,146,19,31,13,24,25,27,10,2,235,19,194,
			.byte 29,191,157,21,117,128,163,13,174,44,26,157,67,13,14,15,
			.byte 6,16,5,17,16,6,18,15,19,147,125,7,8,9,10,4,
			.byte 3,137,254,250,4,5,4,93,246,120,6,3,0,254,239,212,
			.byte 139,255,202,227,254,106,2,145,0,152,1,2,1,121,230,186,
			.byte 255,246,188,255,224,126,223,191,39,208,2,231,175,224,222,192,
			.byte 226,255,192,156,248,155,162,121,218,231,246,208,224,188,19,192,
			.byte 91,209,138,98,209,95,56,238,38,254,6,61,224,208,222,63,
			.byte 225,254,87,0,0,128,

__level00_resources_inst_data_ptrs:

__level00_containers_inst_data_ptrs:
