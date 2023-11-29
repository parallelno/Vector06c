room_init:
			call monsters_init
			call bullets_init
			call backs_init
			call room_unpack
			call backup_tiledata
			call breakables_room_status_init
			call room_init_tiles_gfx
			call room_draw_tiles
			call room_handle_room_tiledata
			call room_copy_scr_to_backbuffs
			ret

; must be called for teleporting into the other room
; h - level_id
; l - room_id
; a - global request
room_teleport:
			sta global_request
			push h
			call breakables_room_status_store
			pop h
			shld room_id
			ret

; redraw room after dialog shown
; it uses data inited in the room_draw
ROOM_TILEDATA_HANDLING_ALL			= OPCODE_JMP
ROOM_TILEDATA_HANDLING_NO_MONSTERS	= OPCODE_JNZ
ROOM_DIALOG_TILE_HEIGHT = 4
room_redraw:
			call backs_init
			mvi c, ROOM_WIDTH * ROOM_DIALOG_TILE_HEIGHT
			call restore_doors_containers_tiledata_ex
			mvi a, ROOM_DIALOG_TILE_HEIGHT * TILE_HEIGHT
			call room_draw_tiles_ex

			mvi a, ROOM_TILEDATA_HANDLING_NO_MONSTERS
			sta room_handle_room_tiledata_check
			mvi a, ROOM_WIDTH * ROOM_DIALOG_TILE_HEIGHT
			call room_handle_room_tiledata_ex
			mvi a, ROOM_TILEDATA_HANDLING_ALL
			sta room_handle_room_tiledata_check
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

; it copies the room tiledata into room_tiledata_backup
; for room_redraw and storing states of breakable objects
backup_tiledata:
			lxi h, room_tiledata
			lxi d, room_tiledata_backup
			lxi b, ROOM_TILEDATA_BACKUP_LEN
			jmp copy_mem

; copies door and containr tiledata from room_tiledata_backup to room_tiledata
restore_doors_containers_tiledata:
			mvi c, ROOM_TILEDATA_LEN
restore_doors_containers_tiledata_ex:
			lxi h, room_tiledata_backup
			mvi b, TILEDATA_FUNC_MASK
			lxi d, (TILEDATA_FUNC_ID_DOORS<<4)<<8 | TILEDATA_FUNC_ID_CONTAINERS<<4
@loop:
			mov a, m
			ana b
			cmp e
			jz @copy_tiledata
			cmp d
			jnz @next
@copy_tiledata:
			mov a, m
			mvi h, >room_tiledata
			mov m, a
			mvi h, >room_tiledata_backup
@next:
			inx h
			dcr c
			jnz @loop
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
			; hl - current room gfx tile_idxs
			; bc - current room gfx tile ptrs
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

; calls the tiledata handler func to spawn a back, breakable, monster, etc
room_handle_room_tiledata:
			mvi a, ROOM_TILEDATA_LEN
; in:
; a = the tile_id to stop handling
room_handle_room_tiledata_ex:
			sta @last_tile_id+1

			; handle the tiledata calling tiledata funcs
			lxi h, room_tiledata
			mvi c, 0
@loop:
			push b
			push h
			mov b, m
			; b - tiledata
			; extract a function
			mvi a, TILEDATA_FUNC_MASK
			ana b

			; check if this func skippable
			cpi TILEDATA_FUNC_ID_MONSTERS<<4
@check:
			jmp @no_skip
			mvi a, TILEDATA_RESTORE_TILE
			jmp @func_ret_addr

@no_skip:
			RRC_(2) ; to make a jmp table ptr with a 4 byte allignment
			HL_TO_A_PLUS_INT16(room_tiledata_funcs)
			; extract a func argument
			mvi a, TILEDATA_ARG_MASK
			ana b
			lxi d, @func_ret_addr
			push d
			pchl
@func_ret_addr:
			pop h
			pop b
			mov m, a ; save tiledata returned by individual handle func (ex. backs_spawn) back into room_tiledata.
			inx h
			inr c
@last_tile_id:
			mvi a, TEMP_BYTE
			cmp c
			jnz @loop
			ret
room_handle_room_tiledata_check = @check

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

; a tiledata handler. it returns tiledata = TILEDATA_NO_COLLISION.
; it copies the tiledata byte into the room_tiledata as it is
; input:
; b - tiledata
; out:
; a - tiledata that will be saved back into room_tiledata
room_tiledata_erase:
			A_TO_ZERO(TILEDATA_NO_COLLISION)
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

			;ROOM_SPAWN_RATE_CHECK(rooms_spawn_rate_breakables, @no_spawn)
			ROOM_DECAL_DRAW(__breakable_gfx_ptrs)
@restore_tiledata:
			mvi a, TEMP_BYTE
			ret
@no_spawn:
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
			; check if it's storytelling dialog tiledata
			CPI_WITH_ZERO(TILEDATA_STORYTELLING)
			jz @restore_tiledata

			ADD_A(2) ; to make a JMP_4 ptr
			sta room_decal_draw_ptr_offset+1

			; check global item status
			mvi h, >global_items
			RRC_(2)
			adi <global_items - 1 ; because the first item_id = 1
			mov l, a
			mov a, m
			CPI_WITH_ZERO(ITEM_STATUS_NOT_ACQUIRED)
			mvi a, TILEDATA_RESTORE_TILE
			rnz ; status != 0 means this item was picked up

			ROOM_DECAL_DRAW(__items_gfx_ptrs - WORD_LEN * 2) ;  subtraction of 2*WORD_LEN needs because there is no gfx for item_id=0 and there is a safety word after every pointer. check __items_gfx_ptrs:
@restore_tiledata:
			mvi a, TEMP_BYTE
			ret

; a tiledata handler. spawn resources.
; input:
; b - tiledata
; c - tile_idx in the room_tiledata array.
; a - res_id
; out:
; a - tiledata that will be saved back into room_tiledata
room_tiledata_resource_spawn:
			lxi h, @restore_tiledata+1
			mov m, b

			lxi h, room_id
			mov d, m

			mov l, a
			ADD_A(2) ; res_id to JMP_4 ptr
			sta room_decal_draw_ptr_offset+1

			; find a resource
			; d - room_id
			; l - res_id
			; c - tile_idx
			FIND_INSTANCE(@picked_up, resources_inst_data_ptrs)
			; resource is found, means it is not picked up
			; c = tile_idx
			ROOM_DECAL_DRAW(__resources_gfx_ptrs)
@restore_tiledata:
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

			; c - tile_idx in the room_tiledata array
			ROOM_DECAL_DRAW(__containers_gfx_ptrs)
@tiledata:	mvi a, TEMP_BYTE
			ret
@opened:
			; draw an opened container
			; c - tile_idx in the room_tiledata array			
			ROOM_DECAL_DRAW(__containers_opened_gfx_ptrs)
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

			; requirement for ROOM_DECAL_DRAW
			ADD_A(2) ; to make a JMP_4 ptr
			sta room_decal_draw_ptr_offset + 1

			; check the global item status
			mvi a, %00001110
			ana b
			rrc
			adi <global_items ; because the first door_id = 0
			mov l, a
			mvi h, >global_items
			mov a, m
			cpi <ITEM_STATUS_USED
			jz @opened	; status == ITEM_STATUS_USED means a door is opened

			; c - tile_idx in the room_tiledata array
			ROOM_DECAL_DRAW(__doors_gfx_ptrs)
@tiledata:
			mvi a, TEMP_BYTE
			ret
@opened:
			; draw an opened door
			; c - tile_idx in the room_tiledata array
			push b
			ROOM_DECAL_DRAW(__doors_opened_gfx_ptrs)
			pop b
			call draw_tile_16x16_buffs
			mvi a, TILEDATA_RESTORE_TILE
			ret

room_copy_scr_to_backbuffs:
			; copy $a000-$ffff scr buffs to the ram-disk back buffer
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
; requires: store entity_id*4 into room_decal_draw_ptr_offset+1 addr prior calling this
; in:
; c - tile_idx in the room_tiledata array.
; use:
; hl - ptr to the graphics, ex. __doors_gfx_ptrs
; backbuffers = true means draw onto backbuffers as well
.macro ROOM_DECAL_DRAW(gfx_ptrs, backbuffers = false, _jmp = false)
			lxi h, gfx_ptrs
		.if backbuffers
			A_TO_ZERO(OPCODE_NOP)
			sta room_decal_draw_backbuffers
		.endif
		.if backbuffers == false
			mvi a, OPCODE_RET
			sta room_decal_draw_backbuffers
		.endif
		.if _jmp == false
			call room_decal_draw
		.endif
		.if _jmp
			jmp room_decal_draw
		.endif		
.endmacro

; draw a decal onto the screen, and backbuffers
; ex. ROOM_DECAL_DRAW(__containers_gfx_ptrs, true)
; requires: store item_id*4 into room_decal_draw_ptr_offset+1 addr prior calling this
; in:
; hl - ptr to the graphics, ex. __doors_gfx_ptrs
; c - tile_idx in the room_tiledata array.
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

; requires: store item_id*4 into room_decal_draw_ptr_offset+1 addr prior calling this
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
			ret		; mutable. do not change

			push b
			push d
			CALL_RAM_DISK_FUNC(draw_decal_v, <__RAM_DISK_S_DECALS | __RAM_DISK_M_BACKBUFF | RAM_DISK_M_AF)
			pop d
			pop b
			CALL_RAM_DISK_FUNC(draw_decal_v, <__RAM_DISK_S_DECALS | __RAM_DISK_M_BACKBUFF2 | RAM_DISK_M_AF)
			ret

;=========================================================
; draw a room tiles. It might be a main screen, or a back buffer
; call ex. call room_draw_tiles
room_draw_tiles:
			mvi a, ROOM_HEIGHT * TILE_HEIGHT
; in:
; a - tile pos_y to stop drawing
room_draw_tiles_ex:
			sta @last_tile_id+1

			lda level_ram_disk_s_gfx
			RAM_DISK_ON_BANK()

			; set y = 0
			mvi e, 0
			; set a pointer to the first item in the list of addrs of tile graphics
			lxi h, room_tiles_gfx_ptrs
@new_line
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

			; move pos_y up to the next tile line
			mvi a, TILE_HEIGHT
			add e
			mov e, a
@last_tile_id:			
			cpi TEMP_BYTE
			jc @new_line
			RAM_DISK_OFF()
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
			CPI_WITH_ZERO(TILEDATA_NO_COLLISION)
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
			CPI_WITH_ZERO(TILEDATA_NO_COLLISION)
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
			CPI_WITH_ZERO(TILEDATA_NO_COLLISION)
			rnz		; 240 cc if returns

			; check top-left corner
			mov a, b
			ora l
			mov e, a
			ldax d
			CPI_WITH_ZERO(TILEDATA_NO_COLLISION)
			ret		; 280 cc

; collects tiledata of tiles that intersect with a sprite
; if several tile corners stays on the same tile,
; they all read same tiledata to let collision logic works properly
; in:
; d - pos_x
; e - pos_y
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
; d - pos_x
; e - pos_y
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
