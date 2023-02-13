; TODO: do we need it?
; list of adresses of compressed levels 
levels_addr:		.word TEMP_ADDR, 0
; TODO: do we need it?
; current level index in levels_addr
level_idx:
				.byte 0
; current room index in roomsAddr of the current level
room_idx:
				.byte 0 ; 0 - 127 ; TODO: find why it says it's <128

; the address table of tile graphics
room_tiles_gfx_ptrs:
				.storage ROOM_WIDTH * ROOM_HEIGHT * ADDR_LEN

; tile data format: 
; it's stored in room_tiles_data
; %ffffDDDD for every tile, ffff - func_id, dddd - a func argument
; ffff == 0, d == 0, nothing, walkable
;		d = 1, a tile should be restored if a hero, a monster, or a bullet on it
; ffff == 1, a monster spawner, monster_id = d
;		monster_id = 0 - skeleton (tiledata = 1*16+0=16)
;		monster_id = 1 - vampire (tiledata = 1*16+1=17)
;		monster_id = 2 - burner (tiledata = 1*16+2=18)
;		monster_id = 3 - knight horizontal walk (tiledata = 1*16+3=19)
;		monster_id = 4 - knight vertical walk (tiledata = 1*16+4=20)
;		monster_id = 5 - chest with money
;		monster_id = 6 - chest with monster
; ffff == 2, teleport, room_id = d, go to 0-15 room , ex. teleport to the room_id=0 (tiledata = 2*16+0=32), to the room_id=1 (tiledata = 2*16+1=33), 
; ffff == 3, teleport, room_id = d+16, go to 16-31 room
; ffff == 4, teleport, room_id = d+32, go to 32-47 room
; ffff == 5, teleport, room_id = d+48, go to 48-63 room

; ffff == 8, a slowness+damage pool. ddddd = damage
; ffff == 9, a key. keyId = d
; ffff == 10, animated background
; 		back_id = 0 - torch front (tiledata = 10*16+0=160)

; ffff == 15, d == %1111, collision (tiledata = 255)
; ffff == 15, d == 0, no collision, restore background (tiledata = 15*16+0=240)
; ffff == 15, d != %1111, ???

room_tiles_data:
			.storage ROOM_WIDTH * ROOM_HEIGHT

; to init each tile data in a room during a room initialization. check room.asm room_init_tiles_data func
room_func_table:
			JMP_4(room_tile_data_copy) ; func_id = 0
			JMP_4(room_monster_spawn)
			JMP_4(room_tile_data_copy)
			JMP_4(room_tile_data_copy)
			JMP_4(room_tile_data_copy)
			JMP_4(room_tile_data_copy)
			JMP_4(room_tile_data_copy)
			JMP_4(room_tile_data_copy)
			JMP_4(room_tile_data_copy)
			JMP_4(room_tile_data_copy)
			JMP_4(room_tile_data_copy)
			JMP_4(room_tile_data_copy)
			JMP_4(room_tile_data_copy)
			JMP_4(room_tile_data_copy)
			JMP_4(room_tile_data_copy)
			JMP_4(room_tile_data_copy) ; func_id = 15

; command that are handled by the level update func
LEVEL_COMMAND_NONE = 0
LEVEL_COMMAND_LOAD_DRAW_ROOM = 1
level_command:
			.byte LEVEL_COMMAND_NONE