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
; %DDDDDfff for every tile
; fff	- func (0-7)
; ddddd	- argument (0-31)
; fff == 0, d == 0, nothing, walkable
; fff == 1, a slowness+damage pool. ddddd = damage
; fff == 2, a key. keyId = d
; fff == 3, a monster spawner, monster_id = d
;		monster_id = 0 - skeleton (tiledata = 3+0=3)
;		monster_id = 1 - vampire (tiledata = 3+1*8=11) 
;		monster_id = 2 - burner (tiledata = 3+2*8=19)
;		monster_id = 3 - knight horizontal walk (tiledata = 3+3*8=27)
;		monster_id = 4 - knight vertical walk (tiledata = 3+4*8=35)
;		monster_id = 5 - chest with money
;		monster_id = 6 - chest with monster
; fff == 4, teleport, roomId = d, go to 0-31 room , ex. tileData = %1100 (12) - teleport to the roomId=1, %100 (4) teleport to the roomId=0
; fff == 5, teleport, roomId = d+32, go to 32-63 room
; fff == 6, animated background
; 		monster_id = 0 - torch front (tile_data = 6+)
; fff == 7, d == %11111, collision
; fff == 7, d == 0, no collision, restore background (tiledata = 7)
; fff == 7, d != %11111, ???

room_tiles_data:
			.storage ROOM_WIDTH * ROOM_HEIGHT

; to init each tile data in a room during a room initialization. check room.asm room_init_tiles_data func
room_func_table:		
			JMP_4(room_tile_data_copy)
			JMP_4(room_tile_data_copy)
			JMP_4(room_tile_data_copy)
			JMP_4(room_monster_spawn)
			JMP_4(room_tile_data_copy)
			JMP_4(room_tile_data_copy)
			JMP_4(room_tile_data_copy)
			JMP_4(room_tile_data_copy)

; command that are handled by the level update func
LEVEL_COMMAND_NONE = 0
LEVEL_COMMAND_LOAD_DRAW_ROOM = 1
level_command:
			.byte LEVEL_COMMAND_NONE