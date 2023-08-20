__RAM_DISK_S_LEVEL00_DATA = RAM_DISK_S
__RAM_DISK_M_LEVEL00_DATA = RAM_DISK_M

			.word 0 ; safety pair of bytes for reading by POP B
__level00_start_pos:										; a hero starting pos
			.byte 140						; pos_y
			.byte 120						; pos_x

			.word 0 ; safety pair of bytes for reading by POP B
__level00_rooms_addr:
			.word __level00_room00, 0, __level00_room01, 

			.word 0 ; safety pair of bytes for reading by POP B
; source\levels\level00_room00.tmj
__level00_room00:
			.byte 88,7,37,32,13,30,32,23,33,120,13,37,7,21,31,2,
			.byte 37,19,32,33,31,224,171,30,11,227,217,225,1,11,166,229,
			.byte 12,56,25,19,225,137,12,30,249,2,24,25,160,24,33,1,
			.byte 38,36,24,32,33,1,37,27,9,15,11,56,195,72,2,2,
			.byte 1,25,35,36,2,18,9,22,226,189,22,15,152,2,20,21,
			.byte 131,21,7,34,28,227,68,28,2,238,255,127,11,37,62,14,
			.byte 10,224,170,23,1,2,19,31,13,24,25,27,10,2,160,12,
			.byte 186,19,194,239,29,157,21,117,232,128,13,235,44,26,144,157,
			.byte 228,13,14,15,6,16,5,17,16,6,18,15,19,125,226,7,
			.byte 8,9,10,4,3,254,126,4,5,4,93,246,158,6,3,0,
			.byte 254,59,212,255,139,202,227,218,254,2,164,0,97,129,1,2,
			.byte 0,255,33,190,255,216,186,255,254,63,0,16,198,219,224,208,
			.byte 251,177,171,210,147,192,233,224,255,255,158,241,143,161,17,20,
			.byte 162,57,218,187,96,254,225,227,224,235,83,18,198,224,36,19,
			.byte 0,59,94,194,224,190,209,98,151,209,251,56,38,129,254,143,
			.byte 224,208,222,79,225,213,254,192,0,32,

			.word 0 ; safety pair of bytes for reading by POP B
; source\levels\level00_room01.tmj
__level00_room01:
			.byte 104,2,19,2,64,137,27,34,15,34,15,2,21,21,2,7,
			.byte 21,31,35,40,14,8,9,10,19,34,7,2,32,12,33,21,
			.byte 31,13,33,22,1,2,19,21,27,9,15,20,11,23,254,12,
			.byte 30,23,215,212,120,9,34,1,191,121,23,30,32,33,23,254,
			.byte 142,18,10,123,127,24,25,2,251,187,255,220,181,117,234,155,
			.byte 141,26,15,14,22,8,32,218,238,94,254,131,11,12,18,39,
			.byte 190,61,32,158,59,15,40,78,184,65,18,123,131,37,11,186,
			.byte 243,19,194,238,29,187,13,224,120,243,227,14,18,93,26,2,
			.byte 230,51,192,188,30,155,178,168,160,159,37,31,12,60,239,110,
			.byte 197,156,195,38,35,36,227,243,26,233,207,197,1,203,153,31,
			.byte 243,224,131,232,225,254,129,37,23,134,37,24,1,2,0,86,
			.byte 135,255,134,222,160,34,132,1,114,1,208,206,49,254,63,189,
			.byte 192,125,146,240,224,190,178,191,96,31,157,249,80,58,58,225,
			.byte 19,232,57,224,14,191,171,176,177,228,91,192,238,145,209,224,
			.byte 88,33,192,193,194,195,111,96,254,187,114,76,130,62,12,97,
			.byte 98,99,100,206,214,228,226,30,246,112,224,224,32,254,252,224,
			.byte 0,2,

__level00_resources_inst_data_ptrs:
			.byte 4, NULL_PTR, 6, 10, 
__level00_resources_inst_data:
			.byte 217, 1, 
			.byte 185, 1, 35, 1, 

__level00_containers_inst_data_ptrs:
			.byte 4, 6, 8, 10, 
__level00_containers_inst_data:
			.byte 133, 1, 
			.byte 135, 1, 
			.byte 86, 1, 
