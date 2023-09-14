__RAM_DISK_S_LEVEL01_DATA = RAM_DISK_S
__RAM_DISK_M_LEVEL01_DATA = RAM_DISK_M

			.word 0 ; safety pair of bytes for reading by POP B
__level01_start_pos:										; a hero starting pos
			.byte 160						; pos_y
			.byte 48						; pos_x

			.word 0 ; safety pair of bytes for reading by POP B
__level01_rooms_addr:
			.word __level01_room00, 0, __level01_room01, 0, __level01_room02_a, 

			.word 0 ; safety pair of bytes for reading by POP B
; source\levels\level01_room00.tmj
__level01_room00:
			.byte 130,0,40,41,45,133,42,0,131,32,19,44,34,216,232,14,
			.byte 39,12,4,12,25,26,29,31,242,142,12,13,224,132,239,35,
			.byte 23,23,24,37,22,23,43,37,28,239,38,136,142,14,17,253,
			.byte 58,28,22,245,15,143,16,42,160,138,39,3,10,40,23,23,
			.byte 40,36,3,13,154,22,36,19,174,24,36,249,242,38,72,121,
			.byte 33,22,20,255,227,33,24,19,58,163,72,27,28,131,227,29,
			.byte 27,30,26,232,59,56,248,19,21,196,248,20,16,97,57,249,
			.byte 20,24,175,241,230,19,20,21,223,18,4,13,251,217,253,14,
			.byte 142,89,14,15,242,151,16,17,18,3,10,7,8,142,43,0,
			.byte 5,245,19,9,8,10,11,8,7,2,1,3,2,187,94,245,
			.byte 4,143,253,5,6,233,37,94,185,1,228,121,251,188,255,34,
			.byte 34,224,59,250,135,198,255,255,224,242,226,168,102,2,112,112,
			.byte 38,16,97,130,255,235,1,254,17,254,93,242,224,62,160,33,
			.byte 194,195,35,18,1,163,29,19,222,90,79,38,241,114,158,241,
			.byte 68,121,240,232,59,113,118,48,96,202,16,176,177,178,249,20,
			.byte 38,33,34,1,10,98,120,60,185,33,239,155,208,209,209,3,
			.byte 175,62,240,58,252,244,232,128,240,95,84,229,254,48,0,8,

			.word 0 ; safety pair of bytes for reading by POP B
; source\levels\level01_room01.tmj
__level01_room01:
			.byte 128,0,8,167,39,12,4,12,13,134,224,72,35,37,48,20,
			.byte 29,38,73,33,32,20,20,44,23,42,107,15,185,221,34,128,
			.byte 35,4,13,150,224,62,46,35,156,231,42,85,3,12,40,229,
			.byte 79,81,34,4,40,4,25,20,23,34,35,47,37,20,23,43,
			.byte 20,7,20,47,19,20,19,44,31,25,21,190,116,249,81,58,
			.byte 14,17,238,190,30,254,46,16,14,81,122,8,33,22,235,37,
			.byte 184,36,249,15,22,33,46,4,2,0,1,27,213,174,208,32,
			.byte 244,140,27,2,225,120,96,1,12,3,5,9,42,41,8,7,
			.byte 8,6,32,174,1,3,2,1,3,166,225,254,10,255,121,218,
			.byte 38,255,209,1,174,208,224,90,0,164,2,47,112,182,240,128,
			.byte 241,224,160,0,231,254,203,236,18,138,184,99,157,209,178,255,
			.byte 246,231,152,207,16,11,48,188,32,37,164,147,18,203,145,255,
			.byte 185,161,241,234,235,192,241,255,77,42,233,143,207,255,224,246,
			.byte 243,32,154,70,240,201,76,12,0,2,

			.word 0 ; safety pair of bytes for reading by POP B
; source\levels\level01_room02_a.tmj
__level01_room02_a:
			.byte 130,0,40,41,45,133,42,0,131,32,20,19,34,216,224,104,
			.byte 39,12,8,12,25,251,26,31,243,239,13,164,222,185,35,21,
			.byte 74,20,43,20,249,249,21,15,14,150,25,41,17,14,36,20,
			.byte 20,16,36,14,17,10,7,2,146,32,39,33,12,28,20,227,
			.byte 247,4,13,234,226,0,110,25,27,23,161,167,27,37,31,4,
			.byte 226,70,35,22,234,132,19,158,21,47,20,89,58,13,46,128,
			.byte 251,16,139,252,135,255,17,29,44,31,3,184,9,9,51,8,
			.byte 70,71,72,73,39,8,69,17,133,238,29,0,1,3,4,5,
			.byte 65,66,67,68,6,243,69,184,249,90,58,1,61,62,63,64,
			.byte 2,204,114,5,7,8,128,32,158,57,58,59,60,168,243,27,
			.byte 96,130,53,54,55,56,66,11,49,50,51,52,48,62,188,32,
			.byte 226,46,255,250,225,230,255,255,224,158,242,206,152,209,33,17,
			.byte 166,18,47,209,114,224,158,3,208,1,44,224,255,248,112,255,
			.byte 240,255,162,162,224,241,192,193,167,241,222,128,90,79,78,106,
			.byte 17,171,16,20,136,128,247,2,1,254,247,169,44,62,225,115,
			.byte 21,219,208,12,195,120,204,55,176,127,28,149,254,48,0,8,

__level01_resources_inst_data_ptrs:
			.byte 4, 12, 14, 18, 
__level01_resources_inst_data:
			.byte 51, 0, 52, 0, 82, 1, 74, 2, 
			.byte 138, 0, 
			.byte 116, 0, 60, 2, 

__level01_containers_inst_data_ptrs:
			.byte 4, 6, 8, 12, 
__level01_containers_inst_data:
			.byte 151, 0, 
			.byte 152, 0, 
			.byte 153, 0, 141, 1, 
