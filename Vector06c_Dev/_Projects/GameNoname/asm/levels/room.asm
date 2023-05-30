room_init:
			call monsters_init
			call bullets_init
			call backs_init
			call room_unpack
			call room_init_tiles_gfx
			lda level_ram_disk_s_gfx
			CALL_RAM_DISK_FUNC_BANK(room_draw_tiles)
			call room_handle_room_tiledata
			call room_copy_scr_to_backbuffs
			ret


; uncompress room gfx tile_idx buffer + room tiledata buffer into the room_tiles_gfx_ptrs + offset
; offset = (size of room_tiles_gfx_ptrs buffer) / 2. the result of the copy operation is
; after copying room tile_idxs occupy the second half of the room_tiles_gfx_ptrs, and
; after copying room tiledata occupies the room_tiledata
; packed room data has to be stored into $8000-$FFFF segment to be properly unzipped
room_unpack:
			; convert a room_id into the room gfx tile_idx buffer addr like __level01_room00 or __level01_room01, etc
			lda room_id
			; double the room index to get an address offset in the level01_rooms_addr array
			rlc
			; double it again because there are two safety bytes in front of every room pointer
			rlc
			mov c, a
			mvi b, 0
			lhld level_rooms_pptr
			dad b

			; load a pointer to a room gfx tile_idx buffer
			xchg
			lda level_ram_disk_s_data
			; TODO: why is it called without CALL_RAM_DISK_FUNC???
			call get_word_from_ram_disk
			mov d, b
			mov e, c

			; copy room gfx tile_idxs + room tiledata into the room_tiles_gfx_ptrs + offset
			; offset = ROOM_TILES_GFX_PTRS_LEN / 2
			lxi b, room_tiles_gfx_ptrs + ROOM_TILES_GFX_PTRS_LEN / 2
			lda level_ram_disk_m_data
			ori RAM_DISK_M_8F
			CALL_RAM_DISK_FUNC_BANK(dzx0)
			ret

; convert room gfx tile_idxs into room gfx tile ptrs
room_init_tiles_gfx:
			lhld level_tiles_pptr
			shld @gfx_tiles_addr + 1
			lda level_ram_disk_s_gfx
			sta @ram_disk_s_gfx + 1

			lxi h, room_tiles_gfx_ptrs + ROOM_TILES_GFX_PTRS_LEN / 2
			lxi b, room_tiles_gfx_ptrs
			mvi a, ROOM_WIDTH * ROOM_HEIGHT
			; hl - current room tile indexes
			; bc - current room tile graphics table
			; a - counter
@loop:
			; de gets the tile index
			push psw
			mov e, m
			mvi d, 0
			inx h
			push h
			xchg
			; double the tile index to get a tile graphics pointer
			dad h
			; double it again because there are two safety bytes in front of every pointer
			dad h
@gfx_tiles_addr:
			lxi d, TEMP_WORD
			; hl gets the tile graphics ponter
			dad d

			; copy the tile graphics addr to the current room tile graphics table
			push b
			xchg
@ram_disk_s_gfx:
			mvi a, TEMP_BYTE
			call get_word_from_ram_disk
			mov a, c
			mov e, b
			pop b

			stax b
			inx b
			mov a, e
			stax b
			inx b
			pop h
			pop psw
			dcr a
			jnz @loop
			ret

; calls the tiledata handler func to spawn spawn a monster, etc
room_handle_room_tiledata:
			; handle the tiledata calling tiledata funcs
			lxi h, room_tiledata
			mvi c, 0
@loop:
			mov b, m
			push b
			TILEDATA_HANDLING(room_tiledata_funcs)
			pop b
			mov m, a ; save tiledata back into room_tiledata. funcs (ex. burner_init etc.) can replace A with 0 to make it walkable
			inx h
			inr c
			mvi a, ROOM_WIDTH * ROOM_HEIGHT
			cmp c
			jnz @loop
			ret

; a tiledata handler. it just copies the tiledata.
; it copies the tiledata byte into the room_tiledata as it is
; input:
; b - tiledata
; out:
; a - tiledata that will be saved back into room_tiledata
room_tiledata_copy:
            ; just return the same tiledata
			mov a, b
			ret

; a tiledata handler. spawn a monster.
; input:
; b - tiledata
; c - tile_idx in the room_tiledata array.
; a - monster_id
; out:
; a - tiledata that will be saved back into room_tiledata
room_tiledata_monster_spawn:
			; get a monster init func addr ptr
			lxi h, monsters_inits
			ADD_A(2) ; to make a JMP_4 ptr
			mov e, a
			mvi d, 0
			dad d
			; call a monster init func
			pchl

; a tiledata handler. spawn an animated back + collision.
; if id == TILEDATA_FUNC_ID_COLLISION, it does not spawn an animated back
; input:
; b - tiledata
; c - tile_idx in the room_tiledata array.
; a - back_id
; out:
; a - tiledata that will be saved back into room_tiledata
room_tiledata_back_spawn:
			cpi TILEDATA_FUNC_ID_COLLISION
			jnz backs_spawn
			mvi a, TILEDATA_COLLISION
			ret

; a tiledata handler. spawn a walkable decal.
; input:
; b - tiledata
; c - tile_idx in the room_tiledata array.
; a - decal_walkable_id
; out:
; a - tiledata that will be saved back into room_tiledata
room_tiledata_decal_walkable_spawn:
			; if decal_id < 2, then just copy tiledata
			cpi TILEDATA_RESTORE_TILE + 1
			jc room_tiledata_copy

			ADD_A(2) ; to make a JMP_4 ptr
			sta room_decal_draw_ptr_offset+1
			ROOM_DECAL_DRAW(__decals_walkable_gfx_ptrs - JMP_4_LEN * 2)
			mvi a, TILEDATA_RESTORE_TILE
			ret

; a tiledata handler. spawn a collidable decals.
; input:
; b - tiledata
; c - tile_idx in the room_tiledata array.
; a - decal_collidable_id
; out:
; a - tiledata that will be saved back into room_tiledata
room_tiledata_decal_collidable_spawn:
			ADD_A(2) ; to make a JMP_4 ptr
			sta room_decal_draw_ptr_offset+1
			ROOM_DECAL_DRAW(__decals_collidable_gfx_ptrs)
			mvi a, TILEDATA_COLLISION
			ret

; a tiledata handler. spawn breakables.
; input:
; b - tiledata
; c - tile_idx in the room_tiledata array.
; a - breakable_id
; out:
; a - tiledata that will be saved back into room_tiledata
room_tiledata_breakable_spawn:
			lxi h, @restore_tiledata+1
			mov m, b

			ADD_A(2) ; to make a JMP_4 ptr
			sta room_decal_draw_ptr_offset+1

			ROOM_SPAWN_RATE_CHECK(rooms_spawn_rate_breakables, @noSpawn)
			ROOM_DECAL_DRAW(__breakable_gfx_ptrs)
@restore_tiledata:
			mvi a, TEMP_BYTE
			ret
@noSpawn:
			mvi a, TILEDATA_RESTORE_TILE
			ret			

; a tiledata handler. spawn items.
; input:
; b - tiledata
; c - tile_idx in the room_tiledata array.
; a - item_id
; out:
; a - tiledata that will be saved back into room_tiledata
room_tiledata_item_spawn:
			lxi h, @restore_tiledata+1
			mov m, b

			ADD_A(2) ; to make a JMP_4 ptr
			sta room_decal_draw_ptr_offset+1

			; check global item status
			mvi h, >global_items
			RRC_(2)
			adi <global_items
			mov l, a
			mov a, m
			ora a
			mvi a, TILEDATA_RESTORE_TILE
			rnz ; status != 0 means this item was picked up

			ROOM_DECAL_DRAW(__items_gfx_ptrs)
@restore_tiledata:
			mvi a, TEMP_BYTE
			ret

; a tiledata handler. spawn resources.
; input:
; b - tiledata
; c - tile_idx in the room_tiledata array.
; a - resource_id
; out:
; a - tiledata that will be saved back into room_tiledata
room_tiledata_resource_spawn:
			lxi h, @restoreTiledata+1
			mov m, b

			lxi h, room_id
			mov d, m

			mov l, a
			ADD_A(2) ; resource_id to JMP_4 ptr
			sta room_decal_draw_ptr_offset+1

			; find a resource
			FIND_INSTANCE(@picked_up, resources_inst_data_ptrs)
			; resource is found, means it is not picked up
			; c = tile_idx
			ROOM_DECAL_DRAW(__resources_gfx_ptrs)
@restoreTiledata:
			mvi a, TEMP_BYTE
			ret
@picked_up:
			; no need to draw a resource
			mvi a, TILEDATA_RESTORE_TILE
			ret

; a tiledata handler. spawn container.
; input:
; b - tiledata
; c - tile_idx in the room_tiledata array.
; a - container_id
; out:
; a - tiledata that will be saved back into room_tiledata
room_tiledata_container_spawn:
			lxi h, @tiledata+1
			mov m, b

			lxi h, room_id
			mov d, m

			mov l, a
			ADD_A(2) ; container_id to JMP_4 ptr
			sta room_decal_draw_ptr_offset+1

			; find a container
			FIND_INSTANCE(@opened, containers_inst_data_ptrs)

			ROOM_DECAL_DRAW(__containers_gfx_ptrs, true)
@tiledata:	mvi a, TEMP_BYTE
			ret
@opened:
			; draw an opened container
			ROOM_DECAL_DRAW(__containers_opened_gfx_ptrs, true)
			mvi a, TILEDATA_RESTORE_TILE
			ret

; a tiledata handler. spawn doors.
; input:
; b - tiledata
; c - tile_idx in the room_tiledata array.
; a - door_id
; out:
; a - tiledata that will be saved back into room_tiledata
room_tiledata_door_spawn:
			lxi h, @tiledata + 1
			mov m, b

			ADD_A(2) ; to make a JMP_4 ptr
			sta room_decal_draw_ptr_offset+1

			; check global item status
			mvi h, >global_items
			mvi a, %00001110
			ana b
			rrc

			adi <global_items
			mov l, a
			mov a, m
			cpi <ITEM_STATUS_USED
			jz @opened	; status != ITEM_STATUS_NOT_ACQUIRED means a door is opened

			ROOM_DECAL_DRAW(__doors_gfx_ptrs, true)
@tiledata:
			mvi a, TEMP_BYTE
			ret
@opened:
			; draw an opened door
			ROOM_DECAL_DRAW(__doors_opened_gfx_ptrs, true)
			mvi a, TILEDATA_RESTORE_TILE
			ret

room_copy_scr_to_backbuffs:
			; copy $a000-$ffff scr buffs to the ram-disk back buffer
			; TODO: optimization. think of making copy process while the gameplay started.
			; or do not copy tile gfx for non-restorable tiles
			lxi d, 0; SCR_BUFF1_ADDR + SCR_BUFF_LEN * 3
			lxi h, 0; SCR_BUFF1_ADDR + SCR_BUFF_LEN * 3
			lxi b, SCR_BUFF_LEN * 3 / 32
			mvi a, __RAM_DISK_S_BACKBUFF
			call copy_to_ram_disk32

			; copy $a000-$ffff scr buffs to the ram-disk back buffer2 (to restore the background in the back buffer)
			lxi d, 0; SCR_BUFF1_ADDR + SCR_BUFF_LEN * 3
			lxi h, 0; SCR_BUFF1_ADDR + SCR_BUFF_LEN * 3
			lxi b, SCR_BUFF_LEN * 3 / 32
			mvi a, __RAM_DISK_S_BACKBUFF2
			call copy_to_ram_disk32
			ret

;=========================================================
; draw a decal onto the screen, and backbuffers
; in:
; hl - ptr to the graphics, ex. __doors_gfx_ptrs
; c - tile_idx in the room_tiledata array.
; save item_id*4 into room_decal_draw_ptr_offset+1 addr
; backbuffers = true means draw onto backbuffers as well
.macro ROOM_DECAL_DRAW(gfx_ptrs, backbuffers = false)
			lxi h, gfx_ptrs
		.if backbuffers
			xra a
			sta room_decal_draw_backbuffers
		.endif
		.if backbuffers == false
			mvi a, OPCODE_RET
			sta room_decal_draw_backbuffers
		.endif
			call room_decal_draw
.endmacro

; draw a decal onto the screen, and backbuffers
; ex. ROOM_DECAL_DRAW(__containers_gfx_ptrs, true)
; in:
; hl - ptr to the graphics, ex. __doors_gfx_ptrs
; c - tile_idx in the room_tiledata array.
; save item_id*4 into room_decal_draw_ptr_offset+1 addr
room_decal_draw:
			; scr_y = tile_idx % ROOM_WIDTH
			mvi a, %11110000
			ana c
			mov e, a
			; c - tile_idx
			; scr_x = tile_idx % ROOM_WIDTH * TILE_WIDTH_B + SCR_ADDR
			mvi a, %00001111
			ana c
			rlc
			adi >SCR_ADDR
			mov d, a
			; de - scr addr
			push d
			
room_decal_draw_ptr_offset:
			lxi d, TEMP_WORD
			dad d
			xchg
			; de pptr to a sprite
			mvi a, <__RAM_DISK_S_DECALS
			call get_word_from_ram_disk
			pop d
			; bc - sprite addr
			; de - scr addr
			push b
			push d
			CALL_RAM_DISK_FUNC(draw_decal_v, <__RAM_DISK_S_DECALS)
			pop d
			pop b
room_decal_draw_backbuffers:
			ret

			push b
			push d
			CALL_RAM_DISK_FUNC(draw_decal_v, <__RAM_DISK_S_DECALS | __RAM_DISK_M_BACKBUFF | RAM_DISK_M_AF)
			pop d
			pop b
			CALL_RAM_DISK_FUNC(draw_decal_v, <__RAM_DISK_S_DECALS | __RAM_DISK_M_BACKBUFF2 | RAM_DISK_M_AF)
			ret	

;=========================================================
; draw a room tiles. It might be a main screen, or a back buffer
; call ex. CALL_RAM_DISK_FUNC(room_draw_tiles, <__RAM_DISK_S_LEVEL01_GFX)
; __RAM_DISK_S_LEVEL01_GFX - ram-disk activation command where tile gfx stored
room_draw_tiles:
			; set y = 0
			mvi e, 0
			; set a pointer to the first item in the list of addrs of tile graphics
			lxi h, room_tiles_gfx_ptrs
@newLine
			; reset the x. it's a high byte of the first screen buffer addr
			mvi d, >SCR_BUFF0_ADDR
@loop:
			; DE - screen addr
			; HL - tile graphics addr
			mov c, m
			inx h
			mov b, m
			inx h
			push d
			push h
			call draw_tile_16x16
			pop h
			pop d

			; x = x + 2
			INR_D(2)
			; repeat if x reaches the high byte of the second screen buffer addr
			mvi a, >SCR_BUFF1_ADDR
			cmp d
			jnz @loop

			; move posY up to the next tile line
			mvi a, TILE_HEIGHT
			add e
			mov e, a
			cpi ROOM_HEIGHT * TILE_HEIGHT
			jc @newLine
			ret

; check tiles if they need to be restored.
; all gfx of tiledata that are > 0, need to be restored if there is a sprite on it
; in:
; de - scr addr
; h - width
;		00 - 8pxs,
;		01 - 16pxs,
;		10 - 24pxs,
;		11 - 32pxs
; l - height
; out:
; Z flag == 0 if this area needs to be restored
; v2. 124 - 280
room_check_tiledata_restorable:
			; convert scr addr to room_tiles_gfx_ptrs offset
			mvi a, %00011110
			ana d
			rrc
			mov b, a
			mvi a, %11110000
			ana e
			mov c, a
			; b = x in tiles
			; c, a = y in tiles * 32

			dad d
			; hl - top-right corner scr addr
			mvi d, >room_tiledata

			; check bottom-left corner
			ora b
			mov e, a
			ldax d
			ora a
			rnz			; 124 cc if returns

			; get x+dx in tiles
			mvi a, %00011110
			ana h
			rrc
			mov h, a
			; h, a = x+dx in tiles

			; check bottom-right corner
			ora c
			mov e, a
			ldax d
			ora a
			rnz		; 180 cc if returns

			; get y+dy in tiles
			dcr l ; to be inside the AABB
			mvi a, %11110000
			ana l
			mov l, a
			; l, a = y+dy in tiles

			; check top-right corner
			ora h
			mov e, a
			ldax d
			ora a
			rnz		; 240 cc if returns

			; check top-left corner
			mov a, b
			ora l
			mov e, a
			ldax d
			ora a
			ret		; 280 cc

; collects tiledata of tiles that intersect with a sprite
; if several tile corners stays on the same tile,
; they all read same tiledata to let collision logic works properly
; in:
; d - posX
; e - posY
; b - width-1
; c - height-1
; out:
; hl - (top-left), (top-right)
; de - (bottom-left), (bottom-right)
; a - "OR" operation on tiledata of all tiles that intersect with a sprite
room_get_collision_tiledata:
			; calc y in tiles
			mvi a, %11110000
			ana e
			mov l, a
			; l = y in tiles

			; calc y+dy in tiles
			mov a, e
			add c
			ani %11110000
			cmp l
			; if y = y+dy, do not top two corners
			jz @tileSizeH1

			; calc x+dx in tiles
			mov a, d
			add b
			ani %11110000
			mov h, a
			; h = x+dx in tiles
			mvi a, %11110000
			ana d
			; a = x in tiles
			cmp h
			jz @tileSizeW1H2

			RRC_(4)
			ora l
			mov l, a
			mvi h, >room_tiledata

			mov e, m
			inx h
			mov d, m
			lxi b, ROOM_WIDTH
			dad b
			mov a, m
			dcx h
			mov l, m
			mov h, a

			ora l
			ora d
			ora e
			ret

@tileSizeH1:
			; calc x+dx in tiles
			mov a, d
			add b
			ani %11110000
			mov h, a
			; h = x+dx in tiles
			mvi a, %11110000
			ana d
			; a = x in tiles
			cmp h
			jz @tileSizeW1H1

@tileSizeW2H1:
			RRC_(4)
			ora l
			mov l, a
			mvi h, >room_tiledata

			mov e, m
			inx h
			mov d, m
			mov h, d
			mov l, e

			mov a, d
			ora e
			ret

@tileSizeW1H1:
			RRC_(4)
			ora l
			mov l, a
			mvi h, >room_tiledata

			; all four corners in the same tile
			mov h, m
			mov l, h
			mov d, h
			mov e, h

			mov a, h
			ret

@tileSizeW1H2:
			RRC_(4)
			ora l
			mov l, a
			mvi h, >room_tiledata

			mov e, m
			lxi b, ROOM_WIDTH
			dad b
			mov l, m
			mvi h, 0
			mov d, h

			mov a, e
			ora l
			ret

; collects idxs of tiles that intersect with a sprite
; if 2+ corners are in the same tile, only one idx is stored
; in:
; d - posX
; e - posY
; b - width-1
; c - height-1
; out: room_get_tiledata_buff
; hl - ptr to the last tile_idx in the array room_get_tiledata_idxs
			.byte TILE_IDX_INVALID
; tile_idxs that intersect with a sprite. max = 4, can be less when 2+ corners are in the same tile
room_get_tiledata_idxs:
			.byte 0,0,0,0
; Z flag = 1 if all tiles have tiledata func==0
; 24+224=248 - 24+316 =340 cc
room_get_tiledata:
			; calc y in tiles
			mvi a, %11110000
			ana e
			mov l, a
			; l = y in tiles

			; calc y+dy in tiles
			mov a, e
			add c
			ani %11110000
			cmp l
			; if y = y+dy, do not top two corners
			jz @tileSizeH1

			; calc x+dx in tiles
			mov a, d
			add b
			ani %11110000
			mov h, a
			; h = x+dx in tiles
			mvi a, %11110000
			ana d
			; a = x in tiles
			cmp h
			jz @tileSizeW1H2

			RRC_(4)
			ora l

			; store tile_idxs
			lxi h, room_get_tiledata_idxs
			mov m, a
			inx h
			inr a
			mov m, a
			inx h
			adi ROOM_WIDTH-1
			mov m, a
			inx h
			inr a
			mov m, a
			ret

@tileSizeH1:
			; calc x+dx in tiles
			mov a, d
			add b
			ani %11110000
			mov h, a
			; h = x+dx in tiles
			mvi a, %11110000
			ana d
			; a = x in tiles
			cmp h
			jz @tileSizeW1H1

@tileSizeW2H1:
			RRC_(4)
			ora l

			; store tile_idxs
			lxi h, room_get_tiledata_idxs
			mov m, a
			inx h
			inr a
			mov m, a
			ret

@tileSizeW1H1:
			RRC_(4)
			ora l

			; store tile_idxs
			lxi h, room_get_tiledata_idxs
			mov m, a
			ret

@tileSizeW1H2:
			RRC_(4)
			ora l

			; store tile_idxs
			lxi h, room_get_tiledata_idxs
			mov m, a
			inx h
			adi ROOM_WIDTH
			mov m, a
			ret

; fill up the tile_data_buff with tiledata = 1 
; (walkable tile, restore back, no decal)
; in:
; c - tiledata to fill
room_fill_tiledata:
			lxi h, room_tiledata
			mvi a, <room_tiledata_end
			call fill_mem_short
			ret