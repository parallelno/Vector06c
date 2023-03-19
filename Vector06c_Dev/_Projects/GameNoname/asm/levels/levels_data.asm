; TODO: do we need it?
; list of adresses of compressed levels
levels_addr: .word TEMP_ADDR, 0
; TODO: do we need it?
; current level index in levels_addr
level_idx:
			.byte 0
; current room index in rooms_addr of the current level
room_idx:   .byte 0 ; 0 - ROOMS_MAX-1

; tiledata format:
; it's stored in room_tiledata
; %ffffDDDD, ffff - func_id, dddd - a func argument
; ffff == 0, walkable tile
;		d == 0 - walkable tile, no back restoration, no decal
;		d == 1 - walkable tile, restore back, no decal
;		d >= 2 - walkable tile, restore back + a decal drawn on top of the tile to make a background diverse. decal_walkable_id = d
;			decal_walkable_id == 2 - a bones (tiledata = 1)
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

; ffff == 6, a global item. a hero interacts with it when he steps on it. status of every item is stored globally. item_id = d. see buffers.asm->global_items for details

; ffff == 7, a resource. a hero interacts with it when he steps on it. status of every item in the room is stored. resource_id = d
;		resource_id == 0 - a coin (tiledata = 10*16+0 = 160)
;		resource_id == 1 - a potion blue
;		resource_id == 2 - a potion red
;	??? is it working to the items below ???
;		resource_id == 10 - a damage pool
;		resource_id == 11 - a slow pool

; every tiledata >= TILEDATA_COLLIDABLE is considered to be colladable (a hero and monster can't step on)

; ffff == 8, ???
; ffff == 9, ???
; ffff == 10, ???
; ffff == 11, ???

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

; ffff == 14, a decal collidable. it's drawn on top of the tile to make a background diverse. decal_collidable_id = d
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
			jmp_4(room_tiledata_monster_spawn)			; func_id = 1
			jmp_4(room_tiledata_copy)					; func_id = 2
			jmp_4(room_tiledata_copy)					; func_id = 3
			jmp_4(room_tiledata_copy)					; func_id = 4
			jmp_4(room_tiledata_copy)					; func_id = 5
			jmp_4(room_tiledata_item_spawn)				; func_id = 6
			jmp_4(room_tiledata_copy)					; func_id = 7
			jmp_4(room_tiledata_copy)					; func_id = 8
			jmp_4(room_tiledata_copy)					; func_id = 9
			jmp_4(room_tiledata_copy)					; func_id = 10
			jmp_4(room_tiledata_copy)					; func_id = 11
			jmp_4(room_tiledata_copy)					; func_id = 12
			jmp_4(room_tiledata_breakable_spawn)		; func_id = 13
			jmp_4(room_tiledata_decal_collidable_spawn)	; func_id = 14
			jmp_4(room_tiledata_back_spawn)				; func_id = 15

; command that are handled by the level update func
LEVEL_COMMAND_NONE = 0
LEVEL_COMMAND_LOAD_DRAW_ROOM = 1
level_command:
			.byte LEVEL_COMMAND_NONE