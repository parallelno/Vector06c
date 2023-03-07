; TODO: do we need it?
; list of adresses of compressed levels
levels_addr: .word TEMP_ADDR, 0
; TODO: do we need it?
; current level index in levels_addr
level_idx:
			.byte 0
; current room index in rooms_addr of the current level
room_idx:   .byte 0 ; 0 - ROOMS_MAX-1

; rooms runtime data
rooms_runtime_data:
room_death_rate: .byte 0 ; 0 means 100% chance to spawn a monster. 255 means no spawn
room_runtime_data_end_addr:

ROOM_RUNTIME_DATA_LEN = room_runtime_data_end_addr - rooms_runtime_data
; the same structs for the rest of the monsters
.storage ROOM_RUNTIME_DATA_LEN * (ROOMS_MAX-1), 0
rooms_runtime_data_end_addr:

; the address table of tile graphics
room_tiles_gfx_ptrs:
			.storage ROOM_WIDTH * ROOM_HEIGHT * ADDR_LEN
room_tiles_gfx_ptrs_end:

; tile_data format:
; it's stored in room_tiles_data
; %ffffDDDD, ffff - func_id, dddd - a func argument
; ffff == 0, walkable
;		d == 0 - no collision
;		d == 1 - no collision + restore back
;		d >= 2 - no collision + restore back + a decal drawn on top of the tile to make a background diverse. decal_id = d
;			decal_id == 2 - a bones (tiledata = 0*16+1 = 1)
;			decal_id == 3 - a skull (tiledata = 2)

; ffff == 1, spawn a monster, monster_id = d
;		monster_id == 0 - skeleton (tiledata = 1*16+0=16)
;		monster_id == 1 - vampire (tiledata = 17)
;		monster_id == 2 - burner (tiledata = 18)
;		monster_id == 3 - knight horizontal walk (tiledata =19)
;		monster_id == 4 - knight vertical walk (tiledata = 20)
;		monster_id == 5 - monster chest (tiledata = 21)
; ffff == 2, teleport, room_id = d, go to 0-15 room, ex. teleport to the room_id=0 (tiledata = 2*16+0=32), to the room_id=1 (tiledata = 2*16+1=33),
; ffff == 3, teleport, room_id = d+16, go to 16-31 room
; ffff == 4, teleport, room_id = d+32, go to 32-47 room
; ffff == 5, teleport, room_id = d+48, go to 48-63 room

; ffff == 10, an item. item_id = d ; a hero interacts with an them only when he collids with it.
;		item_id == 0 - a red potion
;		item_id == 1 - a blue potion
;		item_id == 2 - an item X1
;		item_id == 3 - an item X2
;		item_id == 4 - an item X3
;		item_id == 5 - a coin (tiledata = 10*16+5 = 165)
;		item_id == 6 - a small chest. small money reward
;		item_id == 7 - a big chest. big money reward
;		item_id == 8 - a chest with a weapon 1
;		item_id == 9 - a chest with a weapon 2
;		item_id == 10 - a chest with a weapon 3
;		item_id == 11 - a monster spawner chest. it spawns a chest monster when opened
;		item_id == 12 - a barrel
;		item_id == 13 - a crate
;		item_id == 14 - a crate with a teleport under it to a unique location

; ffff == 11, keys/doors. keydoor_id = d ; a hero interacts with a key only when he collids with it. a door is a collider only. no collision when it's opened.
;		keydoor_id == 0 - a red key
;		keydoor_id == 1 - a blue key
;		keydoor_id == 2 - a X1 key
;		keydoor_id == 3 - a X2 key
;		keydoor_id == 4 - a red door horizontal L
;		keydoor_id == 5 - a red door horizontal R
;		keydoor_id == 6 - a blue door vertical U
;		keydoor_id == 7 - a blue door vertical D
;		keydoor_id == 8 - a X1 door vertical L
;		keydoor_id == 9 - a X1 door vertical R
;		keydoor_id == 10 - a X2 door vertical L
;		keydoor_id == 11 - a X2 door vertical R

; ffff == 12, ????

; ffff == 13, a damage pool. dddd = damage

; ffff == 14, collision with a decal drawn on top of the tile to make a background diverse. decal_id = d
;		decal_id == 0 - a spider net

; ffff == 15,
;		d == %1111 - collision (tiledata = TILE_DATA_COLLISION)
;		d <  %1111 - collision + animated background, back_id = d
;	 		back_id == 0 - torch front (tiledata = 15*16+0=241)
;   	    back_id == 1 - flag front (tiledata = 161)

; if tiledata > 0 then a tile is restored when a hero, a monster, or a bullet are on it

; tiledata buffer has to follow room_tiles_gfx_ptrs because they are unpacked together
room_tiles_data:
			.storage ROOM_WIDTH * ROOM_HEIGHT

; to init each tile data in a room during a room initialization. check room.asm room_init_tiles_data func
room_tiledata_funcs:
			JMP_4(room_tiledata_decal_walkable_spawn)	; func_id = 0
			JMP_4(room_tiledata_monster_spawn)
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
			JMP_4(room_tiledata_decal_collision_spawn)
			JMP_4(room_tiledata_back_spawn)	; func_id = 15

; command that are handled by the level update func
LEVEL_COMMAND_NONE = 0
LEVEL_COMMAND_LOAD_DRAW_ROOM = 1
level_command:
			.byte LEVEL_COMMAND_NONE