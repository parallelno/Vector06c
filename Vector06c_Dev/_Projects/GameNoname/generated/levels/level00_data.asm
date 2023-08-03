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
			.byte 161,2,130,30,12,27,30,21,23,12,35,6,19,29,40,41,
			.byte 17,30,31,29,138,224,27,184,10,217,58,2,35,1,10,229,
			.byte 11,99,38,17,136,225,11,27,159,19,22,38,160,145,130,31,
			.byte 1,39,33,22,30,31,1,35,25,36,14,10,56,17,37,105,
			.byte 11,1,23,32,33,2,28,8,34,166,222,34,13,1,46,19,
			.byte 103,15,2,6,14,20,192,136,20,2,239,127,10,37,230,193,
			.byte 224,160,1,36,17,29,12,22,23,25,9,2,174,17,65,111,
			.byte 26,18,19,117,234,160,12,187,14,199,24,133,157,251,12,13,
			.byte 14,5,15,4,16,15,5,8,9,189,103,7,142,243,3,0,
			.byte 254,39,3,4,3,235,93,246,5,247,227,252,254,139,232,224,
			.byte 74,2,82,248,1,73,254,230,230,234,255,246,255,241,224,248,
			.byte 223,191,159,208,0,175,159,224,192,123,226,255,192,156,225,155,
			.byte 162,231,218,159,246,224,65,184,209,98,165,209,254,56,38,224,
			.byte 254,99,224,208,211,222,245,225,254,112,0,8,

__level00_resources_inst_data_ptrs:

__level00_containers_inst_data_ptrs:
