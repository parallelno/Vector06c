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
			.byte 88,36,39,31,15,32,31,25,33,120,15,39,36,22,24,27,
			.byte 39,19,31,12,24,224,171,32,7,227,217,225,23,7,166,229,
			.byte 14,78,28,19,39,1,14,32,193,126,27,29,28,160,71,12,
			.byte 23,40,38,9,31,6,23,39,20,5,1,7,251,164,195,22,
			.byte 151,131,12,37,38,27,13,5,26,228,192,224,26,1,31,33,
			.byte 34,35,103,248,22,36,0,30,68,59,30,27,24,14,111,7,
			.byte 143,37,4,9,224,171,25,7,174,194,32,103,31,20,9,27,
			.byte 26,14,224,225,15,227,15,14,6,21,22,117,23,24,249,160,
			.byte 129,19,27,28,28,4,7,14,15,4,1,16,17,11,18,17,
			.byte 16,13,1,19,20,5,7,4,5,9,10,8,136,254,8,10,
			.byte 11,10,12,13,7,0,8,161,2,251,212,6,185,195,2,254,
			.byte 103,6,0,1,194,224,163,3,255,33,130,254,34,255,0,102,
			.byte 210,255,1,159,0,173,223,224,235,254,250,209,192,105,208,59,
			.byte 226,254,160,129,254,231,224,207,226,209,167,255,96,230,226,119,
			.byte 0,43,243,174,159,194,224,161,255,166,0,131,119,161,127,208,
			.byte 247,192,171,254,209,138,160,209,94,163,103,255,160,160,219,34,
			.byte 0,216,254,238,224,208,148,254,81,192,0,32,

			.word 0 ; safety pair of bytes for reading by POP B
; source\levels\level00_farm_fence.tmj
__level00_farm_fence:
			.byte 6,27,19,39,27,7,14,6,42,37,75,43,186,241,38,225,
			.byte 25,144,135,27,36,31,14,6,21,24,12,39,31,12,27,135,
			.byte 215,32,3,23,31,32,229,167,223,232,36,24,15,12,19,23,
			.byte 7,216,56,29,36,39,36,209,225,40,37,254,148,136,26,18,
			.byte 10,23,39,36,23,22,22,20,1,24,12,22,161,36,8,174,
			.byte 1,39,22,24,25,12,249,248,14,245,243,226,2,2,225,31,
			.byte 15,242,254,58,14,15,225,0,188,7,226,187,32,207,32,185,
			.byte 192,224,151,15,26,4,41,41,5,1,243,251,192,135,11,13,
			.byte 1,19,27,20,158,249,9,39,24,108,44,42,178,167,3,201,
			.byte 238,0,5,38,145,252,25,74,239,231,227,23,101,62,197,41,
			.byte 72,50,135,122,20,41,1,69,14,79,124,151,29,23,4,0,
			.byte 0,255,39,168,254,255,90,1,137,0,1,103,209,255,40,248,
			.byte 235,224,184,210,210,248,230,224,152,1,187,208,208,246,252,192,
			.byte 136,246,126,159,208,214,226,120,255,34,65,94,251,53,86,0,
			.byte 251,243,225,30,246,239,254,230,1,224,251,96,254,0,248,20,
			.byte 192,124,82,228,224,247,148,255,96,192,143,222,64,126,132,243,
			.byte 255,196,198,224,224,32,254,252,102,0,2,

			.word 0 ; safety pair of bytes for reading by POP B
; source\levels\level00_road_to_friends_home.tmj
__level00_road_to_friends_home:
			.byte 160,27,162,19,23,27,0,7,25,129,43,6,13,41,5,41,
			.byte 9,27,23,4,41,5,9,20,19,31,25,12,22,24,142,213,
			.byte 27,21,199,31,27,36,13,5,1,235,171,252,14,255,196,153,
			.byte 253,230,203,254,255,9,181,124,223,226,184,230,142,14,32,28,
			.byte 31,14,249,247,28,208,185,99,23,185,151,6,4,5,170,218,
			.byte 15,185,32,81,251,32,31,15,251,72,225,158,62,36,27,4,
			.byte 9,17,27,31,20,1,14,132,249,6,43,41,56,5,16,36,
			.byte 29,40,26,171,226,26,37,255,13,9,224,43,252,20,0,21,
			.byte 39,187,101,139,201,6,26,56,207,251,239,5,29,225,29,49,
			.byte 155,255,3,30,10,58,133,193,1,63,255,239,239,103,225,16,
			.byte 237,40,162,230,42,37,254,203,26,176,56,43,254,137,255,38,
			.byte 160,255,227,228,174,255,1,145,235,208,246,35,254,198,231,206,
			.byte 155,209,209,96,255,105,225,198,235,254,96,239,138,35,231,158,
			.byte 254,112,122,161,33,243,226,158,208,224,243,254,174,217,208,112,
			.byte 231,224,251,162,60,175,225,0,134,127,144,231,225,38,248,202,
			.byte 22,242,6,51,198,199,202,127,222,243,1,192,218,224,209,166,
			.byte 1,156,112,153,132,224,208,208,112,224,204,96,224,128,192,0,
			.byte 32,

			.word 0 ; safety pair of bytes for reading by POP B
; source\levels\level00_friends_home.tmj
__level00_friends_home:
			.byte 73,20,41,5,9,16,10,145,174,16,4,41,5,41,1,27,
			.byte 25,12,22,23,36,27,22,228,151,9,4,9,23,19,25,14,
			.byte 160,220,56,22,24,14,12,24,12,27,13,169,226,1,25,254,
			.byte 126,32,28,31,239,218,142,5,0,224,103,12,36,7,142,210,
			.byte 153,255,28,204,200,234,225,15,160,20,226,36,1,43,7,165,
			.byte 31,15,59,244,134,143,13,0,36,39,24,47,23,181,248,127,
			.byte 186,122,6,5,40,38,15,242,227,20,13,7,14,168,159,32,
			.byte 248,9,39,110,200,6,17,219,50,17,11,18,17,212,249,224,
			.byte 224,32,21,8,254,146,39,23,31,14,6,2,18,123,42,37,
			.byte 43,5,29,134,222,10,21,27,39,31,32,6,36,115,125,248,
			.byte 93,191,65,51,16,0,9,13,165,47,41,255,254,41,0,98,
			.byte 34,1,103,96,1,208,222,216,225,238,0,226,254,126,180,138,
			.byte 34,96,59,182,255,247,220,225,255,226,224,254,134,224,130,1,
			.byte 131,0,238,141,160,77,254,1,196,218,127,222,152,224,255,209,
			.byte 209,154,222,255,193,144,191,178,176,249,226,112,226,171,161,161,
			.byte 231,162,143,208,254,123,176,151,226,249,62,192,122,31,208,60,
			.byte 222,99,255,36,200,255,64,112,0,8,

			.word 0 ; safety pair of bytes for reading by POP B
; source\levels\level00_friends_home_backyard.tmj
__level00_friends_home_backyard:
			.byte 82,5,9,39,7,25,6,39,13,5,9,27,20,41,1,158,
			.byte 5,27,13,224,171,12,27,190,241,41,255,215,161,20,122,5,
			.byte 42,43,31,25,42,37,37,43,4,5,222,15,5,0,9,36,
			.byte 190,191,22,245,155,228,223,191,190,1,40,37,38,7,25,154,
			.byte 82,20,0,1,9,0,4,41,1,22,24,15,14,32,28,248,
			.byte 157,87,233,1,4,78,62,31,33,34,35,12,24,55,89,15,
			.byte 9,5,13,23,209,255,97,161,156,190,22,33,21,127,1,39,
			.byte 24,191,189,159,121,39,20,9,135,158,15,5,39,31,133,57,
			.byte 28,19,247,239,39,4,9,59,19,193,226,77,254,114,40,38,
			.byte 13,188,178,20,158,250,226,19,50,222,242,193,144,254,45,254,
			.byte 50,38,20,222,163,1,170,168,23,51,4,0,168,227,195,23,
			.byte 13,254,239,88,44,236,154,224,54,226,0,0,255,35,255,255,
			.byte 0,18,35,255,1,151,224,154,191,192,193,255,144,255,188,0,
			.byte 186,62,225,132,249,155,128,127,122,159,254,96,143,255,119,89,
			.byte 163,152,96,2,188,79,37,160,254,156,192,121,190,191,119,174,
			.byte 198,126,225,1,224,184,210,255,225,1,208,62,187,208,224,37,
			.byte 186,231,110,132,254,112,0,8,

			.word 0 ; safety pair of bytes for reading by POP B
; source\levels\level00_friends_secret_place.tmj
__level00_friends_secret_place:
			.byte 106,4,0,41,5,135,41,27,0,9,4,138,241,41,1,57,
			.byte 13,5,249,121,27,19,13,41,9,21,5,221,57,9,1,19,
			.byte 27,23,0,223,47,7,12,27,27,20,9,213,254,199,181,205,
			.byte 231,62,31,12,217,173,59,0,20,251,13,142,227,24,6,231,
			.byte 14,25,6,29,31,163,249,32,229,149,126,24,25,12,22,24,
			.byte 14,12,159,143,227,3,219,9,25,187,255,15,248,191,191,19,
			.byte 193,65,174,100,31,221,255,32,249,159,227,255,55,96,223,251,
			.byte 159,153,151,13,231,135,231,41,13,0,250,222,159,14,238,230,
			.byte 158,186,19,50,62,9,31,227,125,10,20,1,31,32,43,27,
			.byte 22,36,142,239,29,28,187,11,32,3,0,23,248,129,47,39,
			.byte 235,12,4,220,23,42,191,36,122,1,20,15,138,239,32,10,
			.byte 3,47,166,103,242,105,39,166,243,75,171,251,251,101,129,0,
			.byte 163,255,255,255,245,240,63,224,238,254,255,112,112,208,218,225,
			.byte 35,1,1,155,222,96,252,235,181,224,254,211,255,225,100,3,
			.byte 1,0,136,255,2,63,79,167,255,160,196,186,232,160,155,1,
			.byte 2,167,79,36,232,171,193,0,41,22,47,0,99,252,224,128,
			.byte 254,51,224,159,3,32,123,67,2,189,152,224,248,222,121,0,
			.byte 112,176,112,2,224,32,224,1,208,112,209,192,251,120,209,205,
			.byte 227,192,243,154,229,43,224,179,0,96,136,42,42,192,0,32,

			.word 0 ; safety pair of bytes for reading by POP B
; source\levels\level00_crossroad.tmj
__level00_crossroad:
			.byte 104,20,0,41,164,1,27,233,19,27,20,41,5,41,234,122,
			.byte 41,9,23,13,5,1,36,228,62,9,22,218,89,1,23,21,
			.byte 22,22,13,41,147,23,31,25,12,20,9,143,229,24,25,241,
			.byte 143,189,12,22,238,143,14,12,247,214,254,14,32,28,31,14,
			.byte 240,47,31,230,187,15,150,255,63,175,151,171,174,202,23,192,
			.byte 152,27,4,9,190,15,198,238,36,73,1,61,248,4,101,146,
			.byte 190,4,0,170,5,19,254,9,59,181,148,135,41,17,10,10,
			.byte 24,250,59,161,192,120,12,41,0,25,163,16,21,31,15,250,
			.byte 179,193,66,187,6,161,16,44,217,29,159,219,0,9,15,65,
			.byte 187,51,29,145,16,251,103,146,1,251,13,190,19,227,193,129,
			.byte 21,4,254,93,79,220,248,6,173,239,120,5,0,0,255,0,
			.byte 254,246,238,97,255,1,255,170,255,112,63,226,188,254,240,186,
			.byte 209,202,255,39,225,201,241,254,210,238,60,41,39,134,159,2,
			.byte 112,3,244,238,224,204,59,229,21,233,192,0,250,151,112,99,
			.byte 1,112,2,191,202,192,143,62,198,234,74,41,251,196,255,255,
			.byte 230,176,206,10,58,115,248,204,216,247,224,230,161,192,235,96,
			.byte 254,208,175,144,112,224,57,128,161,0,127,124,134,128,59,255,
			.byte 34,254,140,232,0,2,

			.word 0 ; safety pair of bytes for reading by POP B
; source\levels\level00_farm_entrance.tmj
__level00_farm_entrance:
			.byte 24,23,13,41,1,27,131,20,1,4,41,238,239,243,9,250,
			.byte 185,37,254,147,43,5,9,4,1,0,187,207,39,194,135,239,
			.byte 12,27,39,19,29,251,169,193,240,146,165,9,24,25,6,39,
			.byte 23,123,141,23,165,192,230,7,25,14,25,12,26,12,231,22,
			.byte 24,5,238,161,21,197,238,15,220,219,239,24,249,9,129,184,
			.byte 194,254,99,27,0,136,224,102,32,28,28,26,31,98,32,0,
			.byte 9,250,24,227,113,36,185,29,217,251,0,0,1,49,162,226,
			.byte 107,49,42,43,50,218,184,13,225,242,15,14,37,246,171,13,
			.byte 23,142,165,4,0,217,238,31,147,3,23,243,3,197,227,227,
			.byte 195,129,9,7,178,195,40,156,139,38,13,191,161,19,113,33,
			.byte 40,198,46,21,27,19,23,196,142,23,19,224,171,15,42,54,
			.byte 86,224,0,254,105,255,59,240,153,226,136,210,210,208,239,1,
			.byte 209,251,1,212,254,224,226,207,207,219,175,212,38,192,255,207,
			.byte 229,224,248,255,224,164,1,136,96,0,164,0,226,74,158,96,
			.byte 224,41,208,251,171,128,134,224,254,1,67,64,135,1,142,194,
			.byte 54,59,36,168,64,209,50,246,51,192,63,160,232,224,0,28,
			.byte 248,204,226,127,224,36,98,187,33,254,131,224,0,0,128,

			.word 0 ; safety pair of bytes for reading by POP B
; source\levels\level00_farm_storage.tmj
__level00_farm_storage:
			.byte 72,24,15,32,0,1,27,142,13,41,242,129,226,20,41,5,
			.byte 28,4,41,41,16,10,255,0,10,98,16,37,128,123,19,13,
			.byte 4,1,16,13,5,41,9,31,25,12,13,26,27,31,23,231,
			.byte 9,233,163,252,46,29,31,32,3,27,23,167,63,1,36,225,
			.byte 239,185,222,227,234,27,19,36,113,9,121,21,22,17,127,152,
			.byte 10,11,18,14,11,27,16,20,9,24,14,8,254,9,170,36,
			.byte 16,41,25,129,2,225,35,234,5,9,25,32,23,226,16,14,
			.byte 69,123,16,12,24,45,27,131,190,255,129,15,193,75,248,26,
			.byte 237,56,32,20,4,16,15,178,25,6,250,103,28,3,0,154,
			.byte 161,23,7,15,243,20,87,243,40,248,206,20,5,103,10,230,
			.byte 251,4,5,1,255,237,240,63,225,211,55,206,227,61,236,203,
			.byte 101,0,149,254,163,255,252,246,234,226,253,1,208,235,246,33,
			.byte 169,229,0,171,208,210,210,96,254,254,224,63,255,209,234,223,
			.byte 224,192,248,203,156,191,224,146,206,224,76,94,225,144,23,238,
			.byte 84,190,79,132,188,0,126,201,250,251,227,224,249,29,27,69,
			.byte 131,208,208,255,200,224,135,209,209,57,209,32,187,208,225,98,
			.byte 248,34,20,228,240,254,130,34,28,0,2,

			.word 0 ; safety pair of bytes for reading by POP B
; source\levels\level00_loop.tmj
__level00_loop:
			.byte 15,4,41,1,20,251,154,247,27,4,0,126,41,5,5,249,
			.byte 243,40,1,4,11,9,20,1,13,5,13,9,27,170,249,13,
			.byte 41,133,239,36,27,22,24,12,22,20,0,1,23,4,243,22,
			.byte 201,151,229,25,14,25,25,12,20,9,255,173,243,241,229,152,
			.byte 254,231,6,27,163,32,28,31,238,228,32,245,190,15,168,79,
			.byte 27,27,23,31,4,1,184,97,252,14,5,27,36,4,97,160,
			.byte 227,189,4,9,168,29,9,239,9,28,150,183,235,245,60,10,
			.byte 139,254,17,191,182,177,201,142,171,31,14,107,115,12,19,16,
			.byte 232,242,37,230,131,29,28,44,7,143,13,16,27,227,203,195,
			.byte 209,13,57,134,238,29,31,15,224,8,254,175,229,128,99,16,
			.byte 20,57,92,178,1,31,13,189,123,1,19,23,196,254,137,71,
			.byte 167,38,228,254,159,255,44,255,238,56,254,235,225,1,155,234,
			.byte 1,143,254,240,137,255,38,63,137,143,254,197,219,225,240,188,
			.byte 96,118,255,185,192,239,201,224,188,243,224,251,142,224,239,184,
			.byte 22,128,239,76,160,111,2,51,255,230,64,191,24,58,207,254,
			.byte 210,127,65,128,142,208,208,156,250,224,2,10,44,137,112,112,
			.byte 60,160,188,209,224,127,132,135,192,37,66,143,37,37,75,0,
			.byte 0,128,

			.word 0 ; safety pair of bytes for reading by POP B
; source\levels\level00_dungeon_entrance.tmj
__level00_dungeon_entrance:
			.byte 81,232,27,0,1,29,20,9,20,5,5,9,5,41,1,0,
			.byte 4,41,10,10,9,10,17,41,41,1,9,7,12,20,0,214,
			.byte 58,23,41,3,21,198,68,170,36,22,24,15,25,13,1,15,
			.byte 5,4,5,36,4,9,19,23,24,32,28,31,25,25,32,4,
			.byte 1,5,41,40,16,21,255,25,12,191,227,199,231,135,127,1,
			.byte 16,29,175,200,14,197,227,85,73,27,23,146,77,23,20,10,
			.byte 17,25,17,158,4,20,17,69,110,22,4,13,97,18,16,8,
			.byte 25,8,16,13,41,16,9,3,36,227,1,3,31,0,16,31,
			.byte 127,16,41,248,235,1,57,255,21,20,87,237,131,179,117,13,
			.byte 253,191,229,4,151,149,190,175,25,225,77,31,5,17,19,1,
			.byte 10,137,187,254,39,15,187,242,145,17,251,235,183,223,1,184,
			.byte 33,4,237,139,13,9,2,158,254,225,242,13,236,227,1,248,
			.byte 226,99,234,175,4,0,254,104,255,171,37,255,134,228,73,209,
			.byte 1,255,1,1,255,167,2,255,235,255,143,225,159,192,228,142,
			.byte 112,112,251,225,3,224,186,0,228,252,0,195,106,255,207,144,
			.byte 228,227,72,138,202,255,185,224,38,63,69,40,60,92,255,164,
			.byte 222,11,3,229,117,190,143,16,1,130,253,123,160,247,38,230,
			.byte 219,194,241,0,130,189,0,224,34,162,162,92,0,2,

			.word 0 ; safety pair of bytes for reading by POP B
; source\levels\level00_abandoned_home.tmj
__level00_abandoned_home:
			.byte 41,4,5,40,41,3,20,41,0,41,25,9,13,5,1,21,
			.byte 5,13,17,10,254,235,244,57,17,13,215,224,41,16,8,254,
			.byte 174,16,169,120,21,16,0,181,126,36,3,23,22,22,231,217,
			.byte 98,9,29,4,23,21,24,12,22,24,15,25,12,13,9,16,
			.byte 238,159,154,145,250,25,255,248,31,12,29,16,37,37,153,166,
			.byte 138,32,31,25,233,216,251,12,16,3,130,31,191,239,24,224,
			.byte 187,189,8,145,4,235,163,160,14,232,21,149,31,171,14,9,
			.byte 255,160,205,36,190,29,223,113,230,23,242,50,32,4,239,126,
			.byte 1,29,28,113,97,231,36,209,32,28,20,178,115,17,247,231,
			.byte 17,3,17,16,10,251,254,20,161,238,229,16,20,5,9,8,
			.byte 254,242,227,215,140,3,191,79,23,173,245,239,234,0,254,88,
			.byte 128,224,0,104,255,120,226,111,1,254,143,209,255,226,110,209,
			.byte 224,55,243,131,186,174,171,19,162,255,185,148,187,252,159,3,
			.byte 235,224,2,191,239,32,130,174,236,16,99,142,16,224,96,227,
			.byte 255,224,194,195,180,230,155,224,255,255,162,50,232,103,32,190,
			.byte 208,167,136,230,222,232,2,224,239,177,112,254,193,255,16,155,
			.byte 176,205,198,251,113,42,52,140,200,102,12,0,2,

			.word 0 ; safety pair of bytes for reading by POP B
; source\levels\level00_lost_coins.tmj
__level00_lost_coins:
			.byte 17,232,41,9,12,5,1,20,4,41,36,5,41,1,23,13,
			.byte 41,5,0,1,13,9,20,240,86,1,5,5,16,10,16,0,
			.byte 0,20,9,0,9,6,21,23,27,22,13,9,24,12,27,0,
			.byte 138,13,5,160,7,249,22,22,24,25,254,231,4,5,20,149,
			.byte 21,24,14,129,231,254,32,28,31,25,15,25,13,6,0,127,
			.byte 203,236,158,6,23,24,194,139,0,41,249,129,201,203,254,25,
			.byte 12,20,79,195,137,56,29,1,225,163,6,7,14,20,187,17,
			.byte 31,209,14,231,17,221,31,12,24,242,192,253,58,29,4,38,
			.byte 58,17,10,254,252,17,201,49,131,227,4,1,16,23,187,253,
			.byte 31,19,16,174,180,41,168,202,184,2,16,19,44,31,6,21,
			.byte 36,21,239,168,219,161,161,16,179,41,183,251,93,135,62,206,
			.byte 185,134,251,29,69,135,19,179,24,189,243,213,13,141,34,77,
			.byte 9,41,51,131,225,251,254,184,255,238,63,254,163,245,1,155,
			.byte 226,112,162,254,209,255,163,1,255,186,209,225,224,235,156,254,
			.byte 210,90,187,209,189,1,159,224,228,231,225,112,208,208,231,95,
			.byte 84,143,192,92,253,97,224,255,111,84,191,96,130,207,192,85,
			.byte 247,193,6,207,204,1,188,7,208,8,243,0,191,5,41,223,
			.byte 91,250,202,191,96,14,254,57,42,239,158,254,121,224,10,41,
			.byte 48,0,8,

__level00_resources_inst_data_ptrs:
			.byte 9, 95, 95, 95, 95, 95, 95, 95, 105, 
__level00_resources_inst_data:
			.byte 214, 2, 218, 2, 202, 2, 184, 5, 167, 5, 169, 5, 36, 5, 37, 5, 19, 5, 20, 5, 190, 6, 104, 6, 87, 6, 73, 6, 27, 6, 196, 9, 197, 9, 180, 9, 181, 9, 73, 10, 56, 10, 57, 10, 59, 10, 179, 11, 180, 11, 181, 11, 182, 11, 179, 12, 180, 12, 162, 12, 163, 12, 138, 12, 139, 12, 122, 12, 123, 12, 88, 12, 73, 12, 52, 12, 53, 12, 36, 12, 37, 12, 38, 12, 39, 12, 
			.byte 125, 0, 94, 0, 134, 4, 135, 4, 101, 4, 

__level00_containers_inst_data_ptrs:
			.byte 3, 5, 7, 
__level00_containers_inst_data:
			.byte 168, 5, 
			.byte 178, 11, 
