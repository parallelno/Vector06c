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
rooms_death_rate: .storage ROOMS_MAX, 0 ; 0 means 100% chance to spawn a monster. 255 means no spawn
rooms_break_rate: .storage ROOMS_MAX, 0 ; 0 means 100% chance to spawn a breakable item. 255 means no spawn
rooms_runtime_data_end_addr:

; tile graphics pointer table
; the actual place defined in buffers.asm
;room_tiles_gfx_ptrs:
;			.storage ROOM_WIDTH * ROOM_HEIGHT * ADDR_LEN
;room_tiles_gfx_ptrs_end:

; tiledata buffer has to follow room_tiles_gfx_ptrs because they are unpacked together
;room_tiledata:
;			.storage ROOM_WIDTH * ROOM_HEIGHT
; the actual place defined in buffers.asm


; tiledata format:
; it's stored in room_tiledata
; %ffffDDDD, ffff - func_id, dddd - a func argument
; ffff == 0, walkable
;		d == 0 - no collision
;		d == 1 - no collision + restore back
;		d >= 2 - no collision + restore back + a decal drawn on top of the tile to make a background diverse. decal_walkable_id = d
;			decal_walkable_id == 2 - a bones (tiledata = 0*16+1 = 1)
;			decal_walkable_id == 3 - a skull (tiledata = 2)

; ffff == 1, spawn a monster, monster_id = d
;		monster_id == 0 - skeleton (tiledata = 1*16+0=16)
;		monster_id == 1 - vampire (tiledata = 17)
;		monster_id == 2 - burner (tiledata = 18)
;		monster_id == 3 - knight horizontal walk (tiledata = 19)
;		monster_id == 4 - knight vertical walk (tiledata = 20)
;		monster_id == 5 - monster chest (tiledata = 21)
; ffff == 2, teleport to 0-15 room_id, room_id = d
; ffff == 3, teleport to 16-31 room_id, room_id = d+16
; ffff == 4, teleport to 32-47 room_id, room_id = d+32
; ffff == 5, teleport to 48-63 room_id, room_id = d+48

; ffff == 10, a walkable item. a hero interacts with it only when he hits it with a weapon. status of every item in the room is stored. item_walkable_id = d
;		item_walkable_id == 0 - a key red
;		item_walkable_id == 1 - a key blue
;		item_walkable_id == 2 - a key 1
;		item_walkable_id == 3 - a key 2
;		item_walkable_id == 4 - a potion red 
;		item_walkable_id == 5 - a potion blue
;		item_walkable_id == 6 - an item 1
;		item_walkable_id == 7 - an item 2
;		item_walkable_id == 8 - an item 3
;		item_walkable_id == 9 - a coin (tiledata = 10*16+5 = 165) 
;		item_walkable_id == 10 - a damage pool.
;		item_walkable_id == 11 - a slow pool.

; ffff == 11, ???

; every tiledata >= TILEDATA_COLLIDABLE is considered to be colladable

; ffff == 12, a collidable item. a hero interacts with it only when he collids with it or hits it with a weapon. collidable_id = d
;		collidable_id == 0 - a small chest. small money reward
;		collidable_id == 1 - a big chest. big money reward
;		collidable_id == 2 - a chest with a weapon 1
;		collidable_id == 3 - a chest with a weapon 2
;		collidable_id == 4 - a chest with a weapon 3
;		collidable_id == 5 - a door 1a, there "a" and "b" mean left and right or top and bottom
;		collidable_id == 6 - a door 1b
;		collidable_id == 7 - a door 2a
;		collidable_id == 8 - a door 2b
;		collidable_id == 9 - a door 3a
;		collidable_id == 10 - a door 3b
;		collidable_id == 11 - a door 4a
;		collidable_id == 12 - a door 4b
;		collidable_id == 13 - a monster spawner chest. it spawns a chest monster when opened
;		collidable_id == 14 - a crate with a teleport under it to a unique location

; ffff == 13, a breakable item, a hero can only break it with a hit and get a random reward. a room tracks how many it was broken to manage a reward and a spawn rate. breakable_id = d
;		breakable_id == 0 - a barrel (tiledata = 13*16+0 = 208)
;		breakable_id == 1 - a crate

; ffff == 14, a collidable decal drawn on top of the tile to make a background diverse. decal_collidable_id = d
;		decal_collidable_id == 0 - a spider web

; ffff == 15,
;		d == %1111 - collision (tiledata = TILEDATA_COLLISION)
;		d <  %1111 - collision + animated background, back_id = d
;	 		back_id == 0 - torch front (tiledata = 15*16+0=241)
;   	    back_id == 1 - flag front (tiledata = 161)

; if tiledata > 0 then a tile is restored on the screen when a hero, a monster, or a bullet on it

; to init each tiledata in a room during a room initialization. check room.asm room_handle_room_tiledata func
room_tiledata_funcs:
			jmp_4(room_tiledata_decal_walkable_spawn)	; func_id = 0
			jmp_4(room_tiledata_monster_spawn)
			jmp_4(room_tiledata_copy)
			jmp_4(room_tiledata_copy)
			jmp_4(room_tiledata_copy)
			jmp_4(room_tiledata_copy)
			jmp_4(room_tiledata_copy)
			jmp_4(room_tiledata_copy)
			jmp_4(room_tiledata_copy)
			jmp_4(room_tiledata_copy)
			jmp_4(room_tiledata_copy)
			jmp_4(room_tiledata_copy)
			jmp_4(room_tiledata_copy)
			jmp_4(room_tiledata_breakable_spawn)
			jmp_4(room_tiledata_decal_collidable_spawn)
			jmp_4(room_tiledata_back_spawn)	; func_id = 15

; command that are handled by the level update func
LEVEL_COMMAND_NONE = 0
LEVEL_COMMAND_LOAD_DRAW_ROOM = 1
level_command:
			.byte LEVEL_COMMAND_NONE