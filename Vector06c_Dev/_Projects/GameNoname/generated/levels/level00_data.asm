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
			.byte 88,26,39,31,15,32,31,25,33,120,15,39,20,9,24,29,
			.byte 39,19,31,12,24,224,169,32,136,7,20,5,233,23,7,229,
			.byte 14,142,27,19,193,34,5,9,126,29,28,27,160,30,12,40,
			.byte 37,30,37,255,235,23,214,1,248,189,164,95,23,22,22,24,
			.byte 13,37,38,29,13,5,30,192,147,30,26,31,34,35,36,131,
			.byte 103,22,26,0,33,231,68,33,21,24,142,115,4,7,37,62,
			.byte 4,9,224,174,25,7,194,190,5,103,23,122,29,30,14,161,
			.byte 25,168,19,105,15,14,4,21,22,130,22,23,24,166,12,26,
			.byte 27,27,34,14,15,133,166,1,16,17,11,18,17,16,13,1,
			.byte 19,20,7,4,5,142,10,8,254,32,34,10,11,10,12,13,
			.byte 7,0,8,135,2,238,212,6,195,229,2,254,159,6,0,1,
			.byte 224,10,3,142,255,33,254,8,137,255,0,154,210,255,1,0,
			.byte 127,173,224,127,235,250,249,209,192,164,208,255,197,254,238,157,
			.byte 244,187,159,25,142,250,214,112,233,255,96,232,224,162,255,119,
			.byte 43,1,238,222,160,63,80,255,225,184,224,255,15,194,234,193,
			.byte 112,208,254,94,128,63,192,160,65,209,158,208,208,209,224,126,
			.byte 48,33,160,160,248,143,22,246,254,24,224,208,0,255,0,84,
			.byte 192,0,32,

			.word 0 ; safety pair of bytes for reading by POP B
; source\levels\level00_farm_fence.tmj
__level00_farm_fence:
			.byte 6,29,19,39,29,7,14,6,42,37,75,43,186,241,38,225,
			.byte 25,148,158,29,26,31,14,6,21,24,12,39,24,25,12,26,
			.byte 24,183,86,32,3,23,31,32,39,32,31,25,25,25,15,12,
			.byte 19,23,232,216,62,28,26,39,26,209,213,243,40,132,134,123,
			.byte 30,10,17,23,40,32,249,22,22,20,1,135,245,47,22,26,
			.byte 8,8,1,39,119,238,117,111,14,140,158,12,2,2,225,47,
			.byte 31,15,254,35,14,15,171,225,0,7,203,226,32,186,207,32,
			.byte 225,9,72,31,15,30,4,41,41,17,10,4,5,192,57,11,
			.byte 60,13,1,19,16,20,9,253,227,217,108,33,155,236,43,3,
			.byte 16,29,0,36,140,216,178,176,109,123,16,23,0,197,15,227,
			.byte 41,72,39,135,20,41,1,160,101,14,230,124,57,28,20,101,
			.byte 234,0,255,39,254,255,22,162,1,0,1,89,248,209,255,40,
			.byte 235,224,166,210,100,210,210,1,248,234,235,208,208,216,208,158,
			.byte 192,132,78,123,135,208,232,114,96,191,34,65,94,254,53,86,
			.byte 250,96,243,224,135,0,250,252,225,1,74,0,90,1,23,206,
			.byte 86,224,79,180,63,128,159,192,226,60,96,239,24,196,60,224,
			.byte 110,32,254,15,102,192,0,32,

			.word 0 ; safety pair of bytes for reading by POP B
; source\levels\level00_road_to_friends_home.tmj
__level00_road_to_friends_home:
			.byte 80,174,24,4,1,23,29,0,1,7,25,25,6,13,41,5,
			.byte 41,9,4,13,0,41,41,5,9,19,31,25,12,22,24,213,
			.byte 58,26,20,214,191,26,190,170,252,14,235,4,198,29,190,254,
			.byte 203,254,110,9,181,124,29,19,23,226,231,184,152,142,59,32,
			.byte 27,31,14,249,27,222,208,99,230,23,185,6,4,5,94,218,
			.byte 170,15,32,150,13,5,32,31,15,32,31,126,158,78,26,29,
			.byte 4,9,10,17,61,63,1,14,132,202,167,238,78,5,26,16,
			.byte 9,40,30,171,60,30,37,255,228,193,13,206,19,41,16,32,
			.byte 39,29,198,30,24,6,30,10,10,157,123,9,16,19,225,28,
			.byte 224,49,45,203,3,33,15,16,105,20,250,249,193,254,231,23,
			.byte 103,33,10,16,202,159,162,57,42,37,254,142,30,19,74,184,
			.byte 0,254,137,255,38,160,255,227,228,173,255,1,186,249,208,246,
			.byte 255,35,198,231,130,203,208,209,209,96,255,217,225,198,234,254,
			.byte 96,62,138,248,35,231,254,243,112,175,161,33,226,57,208,239,
			.byte 224,254,58,217,208,238,112,224,127,18,186,60,225,0,247,134,
			.byte 254,144,225,8,254,4,230,124,43,200,196,255,198,199,212,108,
			.byte 115,198,191,25,166,218,224,209,134,112,112,118,112,112,6,63,
			.byte 208,208,223,221,131,192,248,88,128,48,0,8,

			.word 0 ; safety pair of bytes for reading by POP B
; source\levels\level00_friends_home.tmj
__level00_friends_home:
			.byte 73,20,41,5,9,16,10,145,163,16,4,41,5,41,1,29,
			.byte 25,12,22,23,26,29,22,13,164,208,233,4,9,23,19,25,
			.byte 14,220,122,22,24,14,12,24,12,29,216,56,1,25,254,159,
			.byte 32,27,31,239,163,218,13,0,153,224,227,12,26,7,210,191,
			.byte 153,27,204,250,200,211,15,146,20,5,26,1,43,7,35,31,
			.byte 15,251,152,206,158,161,26,39,24,143,255,23,181,127,186,135,
			.byte 6,5,40,38,15,174,242,20,13,58,7,14,159,32,143,9,
			.byte 39,110,140,6,17,158,225,17,11,18,244,190,16,224,120,32,
			.byte 21,8,254,36,132,39,23,31,14,6,2,158,42,37,43,39,
			.byte 225,28,222,130,21,29,39,31,136,6,26,28,254,125,93,191,
			.byte 65,90,16,0,9,13,5,0,5,242,255,254,150,0,38,34,
			.byte 1,125,96,1,208,216,238,225,0,226,231,254,232,180,34,163,
			.byte 96,191,182,247,220,229,224,255,211,224,255,135,236,192,251,141,
			.byte 160,191,77,1,196,159,218,222,230,224,63,209,209,154,255,222,
			.byte 193,144,239,178,176,254,226,112,120,171,185,161,161,162,227,208,
			.byte 222,254,176,229,226,254,62,192,94,31,143,208,222,24,242,255,
			.byte 36,255,64,28,0,2,

			.word 0 ; safety pair of bytes for reading by POP B
; source\levels\level00_friends_home_backyard.tmj
__level00_friends_home_backyard:
			.byte 82,5,9,39,7,25,6,39,13,5,9,29,20,41,1,158,
			.byte 5,29,13,224,171,12,29,190,241,41,255,215,161,20,122,5,
			.byte 42,43,31,25,42,37,37,43,4,5,222,15,5,0,9,26,
			.byte 190,191,22,245,155,228,223,191,190,1,40,37,38,7,25,154,
			.byte 82,20,0,1,9,0,4,41,1,22,24,15,14,32,27,120,
			.byte 87,233,1,4,78,57,31,34,35,36,12,24,55,63,23,29,
			.byte 19,21,13,23,107,97,251,161,156,40,249,93,33,21,254,1,
			.byte 39,24,191,189,223,126,39,20,9,135,15,120,5,39,31,133,
			.byte 231,27,19,247,39,4,9,191,59,19,193,77,137,254,202,40,
			.byte 38,13,188,203,20,158,232,226,19,242,131,224,203,144,248,45,
			.byte 254,202,38,20,222,142,1,198,227,47,4,0,62,168,195,63,
			.byte 23,13,239,88,203,236,179,154,54,131,0,0,255,35,136,255,
			.byte 255,0,72,142,255,1,224,94,191,106,192,193,255,255,66,240,
			.byte 0,186,251,225,132,229,155,128,254,122,254,126,96,62,255,119,
			.byte 89,153,137,25,243,96,2,37,160,249,156,192,230,190,255,119,
			.byte 174,126,27,1,134,224,227,210,255,1,208,134,62,236,208,224,
			.byte 151,186,158,110,254,17,192,0,32,

			.word 0 ; safety pair of bytes for reading by POP B
; source\levels\level00_friends_secret_place.tmj
__level00_friends_secret_place:
			.byte 106,4,0,41,5,135,41,29,0,9,4,138,241,41,1,56,
			.byte 13,5,249,10,29,19,13,41,9,21,20,5,90,9,1,19,
			.byte 29,23,0,1,105,7,12,29,47,20,9,1,21,24,4,181,
			.byte 238,205,231,31,223,40,7,13,62,7,15,13,0,245,213,224,
			.byte 6,231,239,25,6,28,31,199,32,217,151,151,24,25,12,22,
			.byte 24,14,12,224,159,143,231,3,4,9,26,227,25,15,25,238,
			.byte 255,191,19,230,251,119,59,31,191,229,32,249,159,135,201,23,
			.byte 28,13,1,5,239,222,12,183,158,151,13,13,28,71,255,41,
			.byte 93,188,171,153,14,4,204,109,243,204,255,223,190,203,31,227,
			.byte 151,90,20,1,31,32,20,29,22,227,26,49,28,27,130,187,
			.byte 32,3,0,23,203,167,14,254,39,181,179,221,62,23,20,67,
			.byte 99,252,20,41,139,251,205,11,3,41,255,199,103,105,39,47,
			.byte 166,221,46,100,221,110,1,9,29,255,143,255,245,255,240,37,
			.byte 238,131,255,112,112,208,248,218,225,142,1,1,222,111,96,235,
			.byte 243,181,224,230,211,231,96,25,3,242,224,32,255,2,255,63,
			.byte 189,160,235,150,25,191,232,161,158,142,25,2,225,191,36,61,
			.byte 251,160,193,0,160,22,255,223,227,214,247,128,254,51,224,96,
			.byte 15,16,139,96,2,247,117,224,224,222,229,0,112,176,112,224,
			.byte 134,1,208,112,209,1,3,239,120,209,227,223,160,154,62,43,
			.byte 224,91,0,56,96,140,42,42,0,2,

			.word 0 ; safety pair of bytes for reading by POP B
; source\levels\level00_crossroad.tmj
__level00_crossroad:
			.byte 104,20,0,41,153,1,10,249,20,41,5,237,235,122,41,9,
			.byte 23,13,5,1,26,228,62,9,22,218,89,1,23,21,22,22,
			.byte 13,41,147,23,31,25,12,20,9,142,229,24,25,241,111,13,
			.byte 1,12,238,143,14,12,247,214,254,14,32,27,31,14,240,47,
			.byte 31,246,184,15,167,251,23,28,237,220,235,171,202,23,166,192,
			.byte 19,4,1,47,15,172,187,26,73,1,190,5,4,43,146,47,
			.byte 4,0,170,5,19,191,9,59,143,236,7,203,17,187,207,24,
			.byte 59,29,254,160,117,24,138,16,21,63,31,15,179,193,171,66,
			.byte 6,178,161,16,217,201,28,219,251,0,9,15,65,51,28,191,
			.byte 145,16,129,146,191,1,13,190,190,19,193,129,239,21,68,79,
			.byte 239,220,6,173,135,239,5,0,0,255,0,143,254,238,102,255,
			.byte 1,255,26,255,163,112,251,226,254,203,240,209,175,202,39,225,
			.byte 255,201,241,210,227,238,41,39,152,132,38,25,2,112,3,238,
			.byte 2,224,204,33,159,112,3,21,25,1,224,102,25,112,2,127,
			.byte 105,192,227,62,250,198,74,187,41,254,255,12,210,243,233,10,
			.byte 255,58,6,207,224,192,204,246,185,41,192,186,96,254,235,208,
			.byte 144,100,206,224,128,104,0,95,124,225,128,142,255,34,254,227,
			.byte 232,0,0,128,

			.word 0 ; safety pair of bytes for reading by POP B
; source\levels\level00_farm_entrance.tmj
__level00_farm_entrance:
			.byte 24,23,13,41,1,29,143,20,1,241,238,239,243,9,250,185,
			.byte 37,254,147,43,13,9,4,1,0,187,207,39,194,151,239,12,
			.byte 29,39,19,28,0,41,238,193,240,165,73,9,24,25,6,39,
			.byte 23,238,141,23,192,151,7,25,14,25,12,30,12,143,115,22,
			.byte 24,103,187,161,21,197,15,187,220,219,24,190,249,9,129,194,
			.byte 225,254,142,29,0,224,33,153,32,27,27,30,31,139,32,0,
			.byte 9,24,234,227,113,26,239,28,217,20,63,238,49,162,106,155,
			.byte 29,42,43,206,227,255,1,124,7,15,14,37,139,184,23,142,
			.byte 165,4,0,217,238,31,131,3,23,250,3,167,164,227,13,129,
			.byte 9,7,178,195,40,158,171,38,5,191,161,19,113,33,40,198,
			.byte 46,21,29,19,23,196,142,23,19,224,171,15,42,54,86,224,
			.byte 0,254,105,255,59,240,153,226,136,210,210,208,239,1,209,251,
			.byte 1,212,255,224,227,47,240,219,175,212,38,192,255,207,229,224,
			.byte 248,255,224,164,1,136,96,0,164,0,226,74,158,96,224,41,
			.byte 208,251,171,128,134,224,254,1,67,64,135,1,142,194,54,59,
			.byte 36,168,64,209,50,246,51,192,63,160,232,224,0,28,248,204,
			.byte 226,127,224,36,98,187,33,254,131,224,0,0,128,

			.word 0 ; safety pair of bytes for reading by POP B
; source\levels\level00_farm_storage.tmj
__level00_farm_storage:
			.byte 72,24,15,32,0,1,29,142,13,41,242,129,226,20,41,5,
			.byte 27,4,41,41,16,10,255,0,10,98,16,37,133,38,19,13,
			.byte 4,1,16,13,5,41,9,31,25,12,23,31,32,31,23,16,
			.byte 13,9,32,29,224,28,231,227,3,28,23,29,167,1,26,185,
			.byte 226,239,227,22,28,3,117,19,26,169,113,9,227,21,22,17,
			.byte 132,234,250,29,30,20,9,24,14,8,254,9,170,26,16,41,
			.byte 25,129,2,225,35,234,5,9,25,32,23,226,16,14,69,123,
			.byte 16,12,24,45,29,131,190,255,129,15,193,75,248,254,237,123,
			.byte 32,20,4,16,28,223,6,200,227,250,158,27,3,0,161,107,
			.byte 23,7,15,20,202,87,243,23,35,20,5,59,103,10,155,251,
			.byte 4,5,1,252,237,240,255,225,175,55,227,59,61,236,46,101,
			.byte 0,254,86,147,255,206,234,255,162,208,209,1,46,33,204,226,
			.byte 235,210,210,187,96,230,155,224,255,249,208,224,62,193,177,254,
			.byte 224,138,246,57,224,185,255,76,122,225,23,66,142,255,190,79,
			.byte 132,187,0,158,207,2,224,167,0,249,29,27,69,131,208,208,
			.byte 255,200,224,134,209,209,252,208,130,251,190,225,98,242,34,148,
			.byte 92,129,68,192,0,32,

			.word 0 ; safety pair of bytes for reading by POP B
; source\levels\level00_loop.tmj
__level00_loop:
			.byte 15,4,41,1,20,251,154,247,29,4,0,126,41,5,5,249,
			.byte 243,40,1,4,79,9,20,1,13,5,13,9,19,9,13,253,
			.byte 128,195,167,9,26,29,22,24,12,22,20,22,23,4,190,243,
			.byte 22,201,229,78,25,14,25,25,12,13,172,255,243,241,229,152,
			.byte 254,231,6,29,155,32,27,31,238,228,32,245,190,15,168,79,
			.byte 29,29,23,31,4,1,184,97,252,14,5,29,26,4,97,160,
			.byte 227,189,4,9,168,29,9,239,9,27,150,183,131,245,20,0,
			.byte 1,10,139,254,17,184,182,149,225,23,29,199,42,31,14,32,
			.byte 31,12,19,16,13,9,29,9,226,65,20,28,142,44,7,79,
			.byte 236,16,187,20,203,165,209,13,57,134,59,28,31,15,16,29,
			.byte 16,8,249,175,229,128,191,16,211,167,179,19,31,119,35,189,
			.byte 1,19,255,113,255,45,71,238,167,38,254,73,243,255,44,255,
			.byte 238,142,254,225,185,1,234,184,1,254,226,235,209,208,163,38,
			.byte 255,224,137,143,254,197,219,225,240,188,96,118,255,184,193,239,
			.byte 201,224,188,243,224,251,142,224,239,184,22,192,254,76,50,98,
			.byte 25,2,27,0,251,64,24,252,58,254,247,210,251,65,128,208,
			.byte 254,19,163,224,130,2,162,44,112,112,160,224,242,160,234,209,
			.byte 224,2,31,209,243,207,132,220,192,150,66,60,37,37,75,0,
			.byte 2,

			.word 0 ; safety pair of bytes for reading by POP B
; source\levels\level00_dungeon_entrance.tmj
__level00_dungeon_entrance:
			.byte 86,29,0,1,28,20,9,20,5,5,9,5,1,22,24,20,
			.byte 168,10,41,9,10,17,41,104,1,9,7,12,22,24,25,234,
			.byte 4,23,199,21,174,41,26,231,161,15,249,14,25,15,13,4,
			.byte 235,251,57,19,23,24,32,27,31,197,248,32,4,1,143,199,
			.byte 255,16,21,173,164,248,227,117,129,63,10,1,16,28,201,167,
			.byte 248,197,85,73,62,29,23,13,9,121,91,123,25,17,10,197,
			.byte 17,155,69,22,4,13,135,39,16,8,25,8,16,129,239,185,
			.byte 16,9,3,4,5,1,3,31,0,103,40,12,16,41,5,1,
			.byte 4,175,13,1,20,87,249,237,41,117,239,13,20,0,229,4,
			.byte 151,239,149,175,25,225,231,77,127,19,1,10,238,137,254,39,
			.byte 238,15,242,145,254,17,235,183,225,42,1,31,4,62,45,203,
			.byte 230,2,254,124,7,25,13,236,184,1,248,142,11,18,234,42,
			.byte 4,246,0,254,138,255,37,184,255,228,101,138,209,25,96,1,
			.byte 1,1,255,2,14,234,239,143,96,255,143,190,228,142,112,112,
			.byte 251,239,3,194,224,46,0,228,191,25,121,106,59,235,24,249,
			.byte 255,45,100,62,219,65,57,224,0,38,63,250,147,224,191,71,
			.byte 25,225,222,14,159,33,3,0,107,16,239,130,224,160,127,31,
			.byte 68,111,224,194,61,130,61,224,34,162,162,92,0,2,

			.word 0 ; safety pair of bytes for reading by POP B
; source\levels\level00_abandoned_home.tmj
__level00_abandoned_home:
			.byte 41,4,5,40,9,3,20,41,0,41,25,9,13,5,1,13,
			.byte 5,13,17,10,190,13,215,242,174,17,215,120,41,16,8,254,
			.byte 42,16,22,5,41,21,16,0,1,21,26,3,23,22,249,231,
			.byte 217,136,9,28,4,95,21,24,12,22,24,15,25,12,13,9,
			.byte 16,159,187,154,145,25,232,255,248,126,12,28,16,37,37,153,
			.byte 138,155,32,31,25,167,216,12,16,3,238,130,31,239,254,24,
			.byte 224,189,239,8,145,4,47,175,160,14,21,162,149,31,175,14,
			.byte 9,160,254,205,36,251,28,223,113,23,152,242,201,32,4,239,
			.byte 251,1,28,27,113,97,26,158,209,32,27,20,115,203,17,247,
			.byte 17,140,3,17,16,238,160,20,20,251,239,251,20,46,103,8,
			.byte 254,95,227,40,215,3,203,79,23,254,173,245,234,245,0,254,
			.byte 136,224,0,6,135,255,134,226,248,1,254,246,208,255,226,227,
			.byte 208,224,125,243,186,232,169,25,239,163,25,185,251,148,252,190,
			.byte 159,3,225,145,187,2,239,32,250,130,236,255,25,193,182,249,
			.byte 225,162,227,224,194,195,180,230,13,224,62,255,3,195,50,58,
			.byte 67,32,11,16,185,136,222,186,2,224,59,177,112,254,255,193,
			.byte 206,155,243,176,198,127,113,53,53,140,200,102,12,0,2,

			.word 0 ; safety pair of bytes for reading by POP B
; source\levels\level00_lost_coins.tmj
__level00_lost_coins:
			.byte 17,232,41,9,12,5,1,20,4,41,26,5,41,1,23,13,
			.byte 41,5,0,1,13,9,20,240,86,1,5,5,16,10,16,0,
			.byte 0,20,9,0,9,6,21,23,29,22,13,9,24,12,29,0,
			.byte 138,13,5,160,7,249,22,22,24,25,254,231,4,5,20,149,
			.byte 21,24,14,129,231,254,32,27,31,25,15,25,13,6,0,127,
			.byte 203,236,158,6,23,24,194,139,0,41,249,129,201,203,254,25,
			.byte 12,20,79,195,137,56,28,1,225,163,6,7,14,20,187,17,
			.byte 31,209,14,231,17,221,31,12,24,242,192,253,58,28,4,38,
			.byte 58,17,10,254,252,17,201,49,131,227,4,1,16,23,191,253,
			.byte 31,19,243,187,181,41,168,40,184,11,16,19,44,31,6,21,
			.byte 26,21,190,168,219,161,134,16,207,41,183,93,239,135,62,185,
			.byte 59,134,28,238,69,135,19,24,207,189,213,204,13,141,136,77,
			.byte 9,41,207,131,251,132,254,160,255,227,242,155,226,112,162,254,
			.byte 209,255,163,1,255,222,241,225,232,235,145,19,231,226,227,230,
			.byte 1,209,185,189,1,224,254,228,225,127,112,208,208,194,248,184,
			.byte 192,255,92,97,223,224,111,255,84,96,250,130,193,16,127,57,
			.byte 193,223,6,204,51,246,191,208,8,254,10,1,160,111,41,3,
			.byte 254,163,202,191,131,96,142,254,42,123,158,222,254,224,66,140,
			.byte 41,0,2,

__level00_resources_inst_data_ptrs:
			.byte 9, 109, 109, 109, 109, 109, 109, 111, 121, 
__level00_resources_inst_data:
			.byte 98, 0, 99, 0, 82, 0, 215, 2, 216, 2, 217, 2, 198, 2, 199, 2, 201, 2, 202, 2, 184, 5, 167, 5, 169, 5, 36, 5, 37, 5, 19, 5, 20, 5, 104, 6, 87, 6, 73, 6, 27, 6, 196, 9, 197, 9, 205, 9, 180, 9, 181, 9, 73, 10, 56, 10, 57, 10, 59, 10, 179, 11, 180, 11, 181, 11, 182, 11, 179, 12, 180, 12, 162, 12, 163, 12, 138, 12, 139, 12, 122, 12, 123, 12, 88, 12, 73, 12, 52, 12, 53, 12, 36, 12, 37, 12, 38, 12, 39, 12, 
			.byte 200, 2, 
			.byte 125, 0, 94, 0, 134, 4, 135, 4, 101, 4, 

__level00_containers_inst_data_ptrs:
			.byte 3, 5, 7, 
__level00_containers_inst_data:
			.byte 168, 5, 
			.byte 178, 11, 
