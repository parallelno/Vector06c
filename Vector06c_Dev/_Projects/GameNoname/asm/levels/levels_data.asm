; tiledata format:
; it's stored in room_tiledata
; %ffffDDDD, ffff - func_id, dddd - a func argument
; ffff == 0, walkable tile
;		d == 0 - walkable tile, no back restoration, no decal
;		d == 1 - walkable tile, restore back, no decal
;		d >= 2 - walkable tile, restore back + a decal. it's drawn on top of tiles to increase background variety. decal_walkable_id = d
;			decal_walkable_id == 2 - a bones (tiledata = 1)
;			decal_walkable_id == 3 - a skull (tiledata = 2)

; ffff == 1, spawn a monster, monster_id = d
;		monster_id == 0 - skeleton (tiledata = 1*16+0=16)
;		monster_id == 1 - vampire (tiledata = 17)
;		monster_id == 2 - burner (tiledata = 18)
;		monster_id == 3 - knight horizontal walk (tiledata = 19)
;		monster_id == 4 - knight vertical walk (tiledata = 20)
;		monster_id == 5 - burner that run to the right
;		monster_id == 6 - burner that run to up
;		monster_id == 7 - monster chest (tiledata = 21)

; ffff == 2, teleport to 0-15 room_id, room_id = d
; ffff == 3, teleport to 16-31 room_id, room_id = d+16
; ffff == 4, teleport to 32-47 room_id, room_id = d+32
; ffff == 5, teleport to 48-63 room_id, room_id = d+48

; ffff == 6, a global item. a hero interacts with it when he steps on it. item_id = d. see buffers.asm->global_items for details
;		item_id = 0 - storytelling - an invisible tiledata to open a dialog window
;		item_id = 1 - key 0
;		item_id = 2 - key 1
;		item_id = 3 - key 2
;		item_id = 4 - key 3
;		item_id = 5 - key 4
;		item_id = 6 - key 5
; 		TODO: there should be invisible items like ones below
;		item_id == 15 - reserved for burner_right and burner_up state

; ffff == 7, a resource. a hero interacts with it when he steps on it. max instances in all rooms = RESOURCES_LEN/2-RESOURCES_UNIQUE_MAX. resource_id = d. see buffers.asm->resources_inst_data for details
;		resource_id == 0 - a coin (tiledata = 7*16+0 = 160)
;		resource_id == 1 - a potion blue
;		resource_id == 2 - a potion red
;		resource_id == 3 - clothes

; every tiledata >= TILEDATA_COLLIDABLE is considered to be colladable (a hero and monsters can't step on that tile)

; ffff == 8, ???
; ffff == 9, ???
; ffff == 10, triggers. activated when a hero hits it. trigger_id = d
;		trigger_id == 0 - when he hits his house door

; ffff == 11, collidable containers that leave rewards on the floor when a hero hits it. container_id = d
;		container_id == 0 - a small chest. small money reward
;		container_id == 1 - a big chest. big money reward
;		container_id == 2 - a chest with a weapon 1
;		container_id == 3 - a chest with a weapon 2
;		container_id == 4 - a chest with a weapon 3
;		container_id == 5 - a monster spawner chest. it spawns a chest monster when opened
;		container_id == 6 - a crate with a teleport under it to a unique location

; ffff == 12, doors. a hero interacts with it only when he hits it with a weapon. door_id = d
;		door_id == 0 - a door 1a
;		door_id == 1 - a door 1b
;		door_id == 2 - a door 2a
;		door_id == 3 - a door 2b
;		door_id == 4 - a door 3a
;		door_id == 5 - a door 3b
;		door_id == 6 - a door 4a
;		door_id == 7 - a door 4b

; ffff == 13, breakable items, a hero can only break it with a hit and get a random reward. a room tracks how many it was broken to manage a reward and a spawn rate. breakable_id = d
;		breakable_id == 0 - a barrel (tiledata = 13*16+0 = 208)
;		breakable_id == 1 - a crate

; ffff == 14, decals collidable. it's drawn on top of tiles to increase background variety. decal_collidable_id = d
;		decal_collidable_id == 0 - a spider web

; ffff == 15,
;		d == %1111 - collision (tiledata = TILEDATA_COLLISION)
;		d <  %1111 - collision + animated background, back_id = d
;	 		back_id == 0 - torch front (tiledata = 15*16+0=241)
;   	    back_id == 1 - flag front (tiledata = 161)
;   	    back_id == 2 - dialog_press_key (tiledata = 162)

; if tiledata > 0 then a tile is restored on the screen when a hero, a monster, or a bullet on it

; to init each tiledata in a room during a room initialization. check room.asm room_handle_room_tiledata func
room_tiledata_funcs:
			JMP_4(room_tiledata_decal_walkable_spawn)	; func_id = 0
			JMP_4(room_tiledata_monster_spawn)			; func_id = 1
			JMP_4(room_tiledata_copy)					; func_id = 2
			JMP_4(room_tiledata_copy)					; func_id = 3
			JMP_4(room_tiledata_copy)					; func_id = 4
			JMP_4(room_tiledata_copy)					; func_id = 5
			JMP_4(room_tiledata_item_spawn)				; func_id = 6
			JMP_4(room_tiledata_resource_spawn)			; func_id = 7
			JMP_4(room_tiledata_copy)					; func_id = 8
			JMP_4(room_tiledata_copy)					; func_id = 9
			JMP_4(room_tiledata_copy)					; func_id = 10
			JMP_4(room_tiledata_container_spawn)		; func_id = 11
			JMP_4(room_tiledata_door_spawn)				; func_id = 12
			JMP_4(room_tiledata_breakable_spawn)		; func_id = 13
			JMP_4(room_tiledata_decal_collidable_spawn)	; func_id = 14
			JMP_4(room_tiledata_back_spawn)				; func_id = 15

; level init data ptr and ram-disk access commands
levels_init_tbls_ptrs:
				.word level00_init_tbls, level01_init_tbls
; level00 init tbl
level00_init_tbls:
levels_ram_disk_s_data:				.byte __RAM_DISK_S_LEVEL00_DATA
levels_ram_disk_m_data: 			.byte __RAM_DISK_M_LEVEL00_DATA
levels_ram_disk_s_gfx:				.byte __RAM_DISK_S_LEVEL00_GFX
levels_ram_disk_m_gfx:				.byte __RAM_DISK_M_LEVEL00_GFX
levels_palette_ptr:					.word __level00_palette
levels_resources_inst_data_pptr:	.word __level00_resources_inst_data_ptrs
levels_containers_inst_data_pptr:	.word __level00_containers_inst_data_ptrs
levels_start_pos_ptr:				.word __level00_start_pos
levels_rooms_pptr:					.word __level00_rooms_addr
levels_tiles_pptr:					.word __level00_tiles_addr
; level01 init tbl
level01_init_tbls:
									.byte __RAM_DISK_S_LEVEL01_DATA
									.byte __RAM_DISK_M_LEVEL01_DATA
									.byte __RAM_DISK_S_LEVEL01_GFX
									.byte __RAM_DISK_M_LEVEL01_GFX
									.word __level01_palette
									.word __level01_resources_inst_data_ptrs
									.word __level01_containers_inst_data_ptrs
									.word __level01_start_pos
									.word __level01_rooms_addr
									.word __level01_tiles_addr