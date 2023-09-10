__RAM_DISK_S_LEVEL00_DATA = RAM_DISK_S
__RAM_DISK_M_LEVEL00_DATA = RAM_DISK_M

			.word 0 ; safety pair of bytes for reading by POP B
__level00_start_pos:										; a hero starting pos
			.byte 140						; pos_y
			.byte 120						; pos_x

			.word 0 ; safety pair of bytes for reading by POP B
__level00_rooms_addr:
			.word __level00_home, 0, __level00_farm_fence, 0, __level00_road_to_friends_home, 0, __level00_friends_home, 0, __level00_friends_home_backyard, 0, __level00_friends_secret_place, 0, __level00_crossroad, 0, __level00_farm_entrance, 0, __level00_farm_storage, 0, __level00_loop, 0, __level00_dungeon_entrance, 0, __level00_abandoned_home, 0, __level00_lost_coins, 

			.word 0 ; safety pair of bytes for reading by POP B
; source\levels\level00_home.tmj
__level00_home:
			.byte 88,33,37,31,13,29,31,21,33,120,13,37,33,20,30,2,
			.byte 37,18,31,32,30,224,171,29,11,227,217,225,1,11,166,229,
			.byte 12,56,24,18,225,137,12,29,249,2,23,24,160,56,32,1,
			.byte 38,36,23,31,245,127,37,26,9,15,11,164,132,195,249,2,
			.byte 2,1,24,35,36,2,17,9,22,192,9,22,15,1,2,19,
			.byte 20,31,32,20,33,34,27,152,13,27,2,238,127,11,37,62,
			.byte 14,10,224,185,21,195,225,18,30,13,103,251,26,10,2,22,
			.byte 12,224,18,174,194,28,157,63,20,2,29,160,250,129,44,228,
			.byte 25,157,57,13,14,15,6,7,5,16,7,6,17,15,18,125,
			.byte 56,7,8,9,10,4,3,254,159,4,5,4,93,167,246,6,
			.byte 3,0,142,254,212,255,139,202,224,227,252,175,2,254,8,96,
			.byte 1,2,0,255,33,111,255,216,174,255,254,231,198,219,224,19,
			.byte 251,177,171,210,154,192,208,111,20,224,164,255,238,254,161,189,
			.byte 18,194,250,129,222,239,96,254,101,233,98,43,224,225,129,17,
			.byte 0,16,1,185,255,142,247,192,163,127,208,147,224,171,254,209,
			.byte 139,4,209,222,160,23,59,160,160,98,220,34,130,130,35,224,
			.byte 208,48,96,253,225,254,92,0,2,

			.word 0 ; safety pair of bytes for reading by POP B
; source\levels\level00_farm_fence.tmj
__level00_farm_fence:
			.byte 6,2,18,37,2,11,12,28,39,35,75,40,186,241,36,225,
			.byte 21,144,135,2,33,31,12,28,19,30,32,37,31,32,2,135,
			.byte 215,29,25,1,31,29,229,167,223,232,33,30,13,32,18,1,
			.byte 11,216,56,23,33,37,33,209,225,38,35,254,148,136,22,16,
			.byte 4,1,37,33,1,20,20,26,15,30,32,20,161,33,3,174,
			.byte 15,37,20,30,21,32,249,248,12,245,243,226,0,0,225,31,
			.byte 13,242,254,58,12,13,225,34,188,11,226,187,29,207,29,185,
			.byte 192,224,151,13,22,14,8,8,9,15,243,251,192,135,11,17,
			.byte 15,18,2,26,158,249,10,37,30,108,44,39,178,167,25,201,
			.byte 238,34,5,36,145,252,21,74,239,231,227,1,101,62,197,41,
			.byte 72,50,135,122,26,8,15,69,12,79,124,158,23,1,14,1,
			.byte 58,255,39,254,133,255,168,1,150,0,1,127,209,255,40,235,
			.byte 224,139,210,210,142,248,224,105,1,139,208,208,191,246,192,207,
			.byte 136,126,105,208,255,214,120,255,3,65,94,254,53,86,254,0,
			.byte 243,225,30,253,239,254,185,1,224,190,96,254,254,0,20,192,
			.byte 31,82,57,224,61,148,255,96,192,227,222,223,64,132,188,255,
			.byte 196,241,224,184,32,254,63,102,0,0,128,

			.word 0 ; safety pair of bytes for reading by POP B
; source\levels\level00_road_to_friends_home.tmj
__level00_road_to_friends_home:
			.byte 160,2,162,18,1,2,34,11,21,129,43,28,17,8,9,8,
			.byte 10,2,1,14,8,9,10,26,18,31,21,32,20,30,142,213,
			.byte 2,19,199,31,2,33,17,9,15,191,171,252,12,255,196,153,
			.byte 149,230,203,254,255,10,181,124,223,226,184,230,142,14,29,24,
			.byte 31,12,249,247,24,208,185,99,1,155,159,28,14,9,218,42,
			.byte 13,185,29,81,251,29,31,13,251,190,225,158,62,33,2,14,
			.byte 10,7,2,31,26,15,12,132,249,28,43,41,56,9,6,33,
			.byte 23,38,22,171,226,22,35,255,17,10,224,43,252,26,34,19,
			.byte 37,187,101,139,201,28,22,56,207,251,239,9,23,225,23,49,
			.byte 155,255,25,27,4,58,133,193,15,63,255,239,239,103,225,6,
			.byte 237,40,102,230,39,35,254,206,22,45,205,226,0,254,38,255,
			.byte 38,131,255,142,228,255,167,1,0,1,208,175,246,35,198,254,
			.byte 231,206,47,209,96,217,255,225,198,255,169,202,96,254,193,231,
			.byte 254,121,112,235,161,33,206,226,208,123,224,206,204,217,187,208,
			.byte 112,131,224,162,177,0,168,255,33,60,190,238,224,38,127,202,
			.byte 143,22,6,35,198,199,55,202,255,222,1,192,61,224,170,209,
			.byte 1,105,112,201,132,158,208,208,112,224,12,206,96,128,12,0,
			.byte 2,

			.word 0 ; safety pair of bytes for reading by POP B
; source\levels\level00_friends_home.tmj
__level00_friends_home:
			.byte 73,26,8,9,10,6,4,145,174,6,14,8,9,8,15,2,
			.byte 21,32,20,1,33,2,20,228,151,10,14,10,1,18,21,12,
			.byte 160,220,56,20,30,12,32,30,32,2,17,169,226,15,21,254,
			.byte 126,29,24,31,247,218,142,9,34,224,103,32,33,11,142,210,
			.byte 153,255,24,204,200,234,225,13,160,26,226,33,15,40,11,165,
			.byte 31,13,59,244,134,143,17,34,33,37,30,47,1,181,248,127,
			.byte 186,122,28,9,38,36,13,242,227,26,13,11,12,168,159,29,
			.byte 248,10,37,110,200,28,7,219,50,7,5,16,7,212,249,224,
			.byte 224,29,19,3,254,146,37,1,31,12,28,0,18,123,39,35,
			.byte 40,97,23,134,222,10,19,2,37,31,32,28,33,115,125,248,
			.byte 93,191,65,51,6,34,10,17,165,47,89,255,254,61,190,174,
			.byte 34,254,159,96,1,208,216,127,225,155,231,227,254,232,180,34,
			.byte 163,96,191,182,247,220,255,225,226,255,224,70,232,224,1,40,
			.byte 0,62,141,160,239,77,1,196,231,218,249,222,224,143,209,209,
			.byte 154,255,222,193,251,144,178,255,176,226,158,112,171,46,161,161,
			.byte 162,120,208,247,254,185,176,226,127,62,151,192,163,31,208,198,
			.byte 222,60,255,36,255,135,64,0,0,128,

			.word 0 ; safety pair of bytes for reading by POP B
; source\levels\level00_friends_home_backyard.tmj
__level00_friends_home_backyard:
			.byte 82,9,10,37,11,21,28,37,17,9,10,2,26,8,15,158,
			.byte 9,2,17,224,171,32,2,190,241,8,255,215,161,26,122,9,
			.byte 39,40,31,21,39,35,35,40,14,9,222,15,9,34,10,33,
			.byte 190,191,20,245,155,228,223,191,190,15,38,35,36,11,21,154,
			.byte 82,26,34,15,10,34,14,8,15,20,30,13,12,29,24,248,
			.byte 157,87,233,15,14,78,62,31,41,42,43,32,30,55,89,15,
			.byte 10,9,17,1,209,255,97,161,156,190,22,33,149,127,15,37,
			.byte 30,191,189,159,123,37,26,10,135,158,15,9,37,31,133,57,
			.byte 24,18,247,239,37,14,10,33,18,193,226,77,254,114,38,36,
			.byte 17,188,178,26,158,250,226,18,50,222,242,193,144,254,45,254,
			.byte 50,36,26,222,163,15,170,166,1,51,14,34,168,227,251,1,
			.byte 17,254,239,88,44,239,154,191,153,167,0,0,255,142,255,0,
			.byte 254,24,142,255,1,224,94,191,106,192,193,255,255,66,240,0,
			.byte 186,251,225,132,229,155,128,254,122,254,126,96,62,255,115,89,
			.byte 152,142,96,2,245,243,37,160,249,156,192,230,190,255,115,29,
			.byte 59,126,27,1,134,224,235,210,252,208,134,62,236,208,224,151,
			.byte 186,158,110,254,17,192,0,32,

			.word 0 ; safety pair of bytes for reading by POP B
; source\levels\level00_friends_secret_place.tmj
__level00_friends_secret_place:
			.byte 106,14,34,8,9,135,8,2,34,10,14,138,241,8,15,56,
			.byte 17,9,249,2,2,18,17,8,10,19,9,10,14,10,1,18,
			.byte 2,1,34,15,154,11,32,2,47,26,10,213,254,199,181,205,
			.byte 231,57,31,32,217,46,21,32,34,34,9,34,175,58,30,28,
			.byte 230,123,28,23,31,107,29,238,153,149,30,207,15,20,30,12,
			.byte 32,159,184,143,25,171,238,10,21,255,13,248,239,191,18,99,
			.byte 187,64,215,31,187,229,29,248,254,151,107,65,246,255,223,109,
			.byte 153,242,101,67,250,159,8,17,34,222,239,153,12,190,242,63,
			.byte 234,239,57,10,155,236,227,159,14,201,177,249,121,20,1,33,
			.byte 26,15,23,24,153,255,29,25,26,99,195,47,142,39,32,14,
			.byte 220,142,1,26,66,254,65,41,139,239,29,10,3,63,82,36,
			.byte 254,39,74,251,26,137,160,186,129,0,255,255,40,0,98,255,
			.byte 41,251,237,227,1,255,255,219,238,190,236,205,222,47,96,218,
			.byte 255,213,225,192,57,225,146,3,1,0,32,255,2,255,231,188,
			.byte 155,248,0,255,160,202,238,224,36,62,250,171,193,0,26,22,
			.byte 31,227,188,248,160,255,52,224,167,3,223,32,35,63,211,116,
			.byte 207,0,29,130,195,208,176,208,2,225,224,169,1,129,209,209,
			.byte 1,239,120,227,253,32,224,255,186,109,151,224,206,187,64,44,
			.byte 42,42,0,2,

			.word 0 ; safety pair of bytes for reading by POP B
; source\levels\level00_crossroad.tmj
__level00_crossroad:
			.byte 104,26,34,8,164,15,2,233,18,2,26,8,9,8,234,122,
			.byte 8,10,1,17,9,15,33,228,62,10,20,218,89,15,1,19,
			.byte 20,20,17,8,147,1,31,21,32,26,10,143,229,30,21,241,
			.byte 143,189,32,20,238,143,12,32,247,214,254,14,29,24,31,12,
			.byte 240,47,31,230,187,13,150,255,85,175,151,171,174,202,1,192,
			.byte 152,2,14,10,190,13,198,238,33,73,15,199,248,14,101,146,
			.byte 190,14,0,170,9,18,254,10,59,117,148,135,8,7,4,4,
			.byte 30,250,59,161,192,120,32,8,34,25,163,6,19,31,13,250,
			.byte 179,193,66,187,28,161,6,44,217,23,159,219,34,10,13,65,
			.byte 187,51,23,145,6,251,153,146,15,251,13,190,18,227,193,129,
			.byte 19,14,254,93,157,220,248,28,173,61,120,9,0,0,255,0,
			.byte 254,246,238,97,255,1,255,170,255,112,63,226,188,254,240,186,
			.byte 209,202,255,39,225,201,241,254,210,238,60,41,39,134,159,2,
			.byte 112,3,244,238,224,204,59,229,21,233,192,0,250,151,112,99,
			.byte 1,112,2,191,202,192,143,62,198,234,74,41,251,196,255,255,
			.byte 230,176,206,10,58,115,248,204,216,247,224,230,33,192,235,96,
			.byte 254,208,175,144,112,224,57,128,161,0,127,124,134,128,59,255,
			.byte 34,254,140,232,0,2,

			.word 0 ; safety pair of bytes for reading by POP B
; source\levels\level00_farm_entrance.tmj
__level00_farm_entrance:
			.byte 24,1,17,8,15,2,131,26,15,14,8,238,239,243,10,250,
			.byte 185,35,254,147,40,9,10,14,15,34,187,207,37,194,135,239,
			.byte 32,2,37,18,23,251,169,193,240,146,165,10,30,21,28,37,
			.byte 1,123,139,1,165,192,230,11,21,12,21,32,22,32,177,20,
			.byte 30,9,238,161,19,197,238,13,220,219,239,30,249,10,129,184,
			.byte 194,254,99,2,34,136,224,102,29,24,24,22,31,98,29,34,
			.byte 10,250,30,227,113,33,185,23,217,251,34,34,15,129,194,226,
			.byte 107,49,39,40,50,218,184,17,225,242,13,12,37,246,171,17,
			.byte 1,142,165,14,34,217,238,31,161,25,227,243,25,197,227,227,
			.byte 195,129,10,11,178,195,38,156,139,36,17,191,161,18,113,33,
			.byte 40,198,46,19,2,18,1,196,142,1,18,224,171,13,39,54,
			.byte 86,224,0,254,105,255,59,240,153,226,136,210,210,208,239,1,
			.byte 209,251,1,212,254,224,226,191,0,231,227,191,213,38,192,255,
			.byte 207,229,224,226,255,224,146,1,34,96,0,147,0,138,74,96,
			.byte 120,224,167,208,238,171,128,224,27,1,250,67,64,1,30,194,
			.byte 56,54,238,36,64,160,209,200,246,204,192,255,160,224,160,0,
			.byte 115,204,225,226,252,224,146,98,238,33,254,224,12,0,2,

			.word 0 ; safety pair of bytes for reading by POP B
; source\levels\level00_farm_storage.tmj
__level00_farm_storage:
			.byte 72,30,13,29,34,15,2,142,17,8,242,129,226,26,8,9,
			.byte 24,14,8,8,6,4,255,34,4,98,6,35,128,123,18,17,
			.byte 14,15,6,17,9,8,10,31,21,32,17,22,2,31,1,231,
			.byte 10,233,163,252,46,23,31,29,25,2,1,167,63,15,33,225,
			.byte 239,185,222,227,234,2,18,33,113,10,121,19,20,7,127,152,
			.byte 4,5,16,14,5,2,6,26,10,30,12,3,254,9,170,33,
			.byte 6,8,21,129,0,225,35,234,9,10,21,29,1,226,6,14,
			.byte 43,123,6,32,30,45,2,131,192,255,129,15,193,75,248,26,
			.byte 237,56,29,26,14,6,15,178,21,28,250,103,24,25,34,154,
			.byte 161,1,11,13,243,26,87,243,40,248,206,26,9,103,10,230,
			.byte 251,14,9,15,255,237,240,63,141,175,55,206,227,61,236,203,
			.byte 101,0,149,254,163,255,252,246,234,226,253,1,208,235,246,33,
			.byte 169,229,0,171,208,210,210,96,254,254,224,63,255,209,234,223,
			.byte 224,192,248,203,156,191,224,146,206,224,76,94,225,144,19,238,
			.byte 84,190,79,132,188,0,126,201,250,251,227,224,249,29,27,69,
			.byte 131,208,208,255,200,224,135,209,209,57,209,32,187,208,225,98,
			.byte 249,34,20,247,240,215,254,0,0,128,

			.word 0 ; safety pair of bytes for reading by POP B
; source\levels\level00_loop.tmj
__level00_loop:
			.byte 15,14,8,15,26,251,154,247,2,14,34,123,8,9,9,249,
			.byte 34,146,233,14,9,10,26,15,17,224,241,137,2,26,17,10,
			.byte 91,34,10,33,2,20,30,32,20,26,34,15,1,14,32,20,
			.byte 229,201,229,255,21,12,21,21,32,14,10,173,243,241,230,229,
			.byte 254,57,28,2,163,251,29,24,31,228,29,175,245,13,168,147,
			.byte 2,2,1,31,14,15,216,184,59,12,9,2,33,29,10,207,
			.byte 160,189,190,125,9,229,65,239,24,150,19,235,245,60,4,139,
			.byte 254,7,191,182,177,201,142,199,31,12,107,123,32,18,6,79,
			.byte 2,57,215,165,59,1,26,23,24,44,11,13,6,143,83,26,
			.byte 10,37,206,189,134,126,23,31,13,225,254,139,33,34,230,227,
			.byte 128,243,6,211,92,227,69,9,14,142,187,18,1,198,251,45,
			.byte 70,142,181,10,0,254,73,243,255,44,255,238,142,254,225,185,
			.byte 1,234,184,1,254,248,240,146,255,38,254,0,253,251,192,250,
			.byte 225,240,243,96,118,255,185,192,201,191,224,188,207,224,142,239,
			.byte 224,62,191,22,128,189,76,160,185,2,230,254,64,24,231,56,
			.byte 223,252,211,206,32,255,185,208,156,233,225,2,168,44,151,112,
			.byte 112,155,160,209,199,224,248,132,192,115,64,9,192,37,37,255,
			.byte 0,32,

			.word 0 ; safety pair of bytes for reading by POP B
; source\levels\level00_dungeon_entrance.tmj
__level00_dungeon_entrance:
			.byte 148,45,85,165,0,21,112,0,8,

			.word 0 ; safety pair of bytes for reading by POP B
; source\levels\level00_abandoned_home.tmj
__level00_abandoned_home:
			.byte 148,45,85,165,0,21,112,0,8,

			.word 0 ; safety pair of bytes for reading by POP B
; source\levels\level00_lost_coins.tmj
__level00_lost_coins:
			.byte 17,232,8,10,32,9,15,26,14,8,33,9,8,15,1,17,
			.byte 8,9,34,15,17,10,26,240,86,15,9,9,6,4,6,34,
			.byte 34,26,10,34,10,28,19,1,2,20,17,10,30,32,2,34,
			.byte 138,17,9,160,11,249,20,20,30,21,254,231,14,9,26,149,
			.byte 19,30,12,129,231,254,29,24,31,21,13,21,17,28,34,127,
			.byte 203,236,158,28,1,30,194,139,34,8,249,129,201,203,254,21,
			.byte 32,26,79,195,137,56,23,15,225,163,28,11,12,26,187,17,
			.byte 31,209,12,231,17,221,31,32,30,242,192,253,58,23,14,38,
			.byte 58,7,4,254,252,7,201,49,131,227,14,15,6,1,254,253,
			.byte 193,23,180,187,8,168,40,184,11,6,18,44,31,28,19,33,
			.byte 19,190,168,219,161,134,6,207,8,183,93,239,135,62,185,59,
			.byte 134,23,238,69,135,18,24,207,189,213,204,245,141,136,77,10,
			.byte 8,202,130,225,0,254,184,255,238,63,254,163,245,1,155,226,
			.byte 112,162,254,209,255,163,1,255,186,209,225,224,235,156,254,210,
			.byte 215,42,1,209,209,231,224,249,228,225,249,112,208,208,95,84,
			.byte 227,192,255,92,97,224,127,111,84,239,96,130,243,192,253,85,
			.byte 193,6,243,204,239,1,7,208,8,60,0,239,5,41,223,254,
			.byte 91,202,191,131,96,142,254,42,123,158,222,254,224,66,140,41,
			.byte 0,2,

__level00_resources_inst_data_ptrs:
			.byte 5, 61, 61, 61, 67, 
__level00_resources_inst_data:
			.byte 214, 2, 218, 2, 202, 2, 190, 6, 104, 6, 87, 6, 73, 6, 27, 6, 196, 9, 197, 9, 180, 9, 181, 9, 179, 12, 180, 12, 162, 12, 163, 12, 138, 12, 139, 12, 122, 12, 123, 12, 88, 12, 73, 12, 52, 12, 53, 12, 36, 12, 37, 12, 38, 12, 39, 12, 
			.byte 134, 4, 135, 4, 101, 4, 

__level00_containers_inst_data_ptrs:
			.byte 2, 4, 
__level00_containers_inst_data:
			.byte 168, 5, 
