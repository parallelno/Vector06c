room_init:
			call monsters_erase_runtime_data
			call bullets_erase_runtime_data
			call backs_init
			call room_data_copy
			call room_init_tiles_gfx
			call room_draw_on_scr
			call room_handle_room_tiledata
			; erase a back buffer $a000-$ffff in the ram-disk
			; TODO: perhaps we do not need to erase a back buffer.
			; because we will restore a background tiles
			lxi b, $0000
			lxi d, $6000 / 128 - 1
			CALL_RAM_DISK_FUNC(__clear_mem_sp, __RAM_DISK_S_BACKBUFF | __RAM_DISK_M_CLEAR_MEM | RAM_DISK_M_89)

			call room_draw_on_backbuffs

			; convert room_tiledata into BACKBUFF2 buffer
			;call room_init_tiledata_buff
			;CALL_RAM_DISK_FUNC(room_init_tiledata_buff, __RAM_DISK_M_BACKBUFF2 | RAM_DISK_M_8F)
			ret

; uncompress room gfx tile idx buffer + room tiledata buffer into the room_tiles_gfx_ptrs + offset
; offset = (size of room_tiles_gfx_ptrs buffer) / 2. the result of the copy operation is
; after copying room tile idxs occupy the second half of the room_tiles_gfx_ptrs, and
; after copying room tiledata occupies the room_tiledata
; packed room data has to be stored into $8000-$FFFF segment to be properly unzipped
room_data_copy:
			; convert a room_idx into the room gfx tile idx buffer addr like __level01_room00 or __level01_room01, etc
			lda room_idx
			; double the room index to get an address offset in the level01_rooms_addr array
			rlc
			; double it again because there are two safety bytes in front of every room pointer
			rlc
			mov c, a
			mvi b, 0
			lxi h, __level01_rooms_addr
			dad b

			; load a pointer to a room gfx tile idx buffer
			xchg
			mvi a, <__RAM_DISK_S_LEVEL01_DATA
			call get_word_from_ram_disk
			mov d, b
			mov e, c

			; copy room gfx tile idxs + room tiledata into the room_tiles_gfx_ptrs + offset
			; offset = (room_tiles_gfx_ptrs_end - room_tiles_gfx_ptrs) / 2
			lxi b, room_tiles_gfx_ptrs + (room_tiles_gfx_ptrs_end - room_tiles_gfx_ptrs) / 2
			CALL_RAM_DISK_FUNC(dzx0, __RAM_DISK_M_LEVEL01_DATA | RAM_DISK_M_8F)
			ret

; convert room gfx tile idxs into room gfx tile ptrs
room_init_tiles_gfx:
			lxi h, room_tiles_gfx_ptrs + (room_tiles_gfx_ptrs_end - room_tiles_gfx_ptrs) / 2
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
			lxi d, __level01_tilesAddr
			; hl gets the tile graphics ponter
			dad d

			; copy the tile graphics addr to the current room tile graphics table
			push b
			xchg
			mvi a, <__RAM_DISK_S_LEVEL01_GFX
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
			TILEDATA_HANDLE_FUNC_CALL(room_tiledata_funcs)
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

; a tiledata handler to spawn a monster by its id.
; input:
; b - tiledata
; c - tile idx in the room_tiledata array.
; a - monster_id
; out:
; a - tiledata that will be saved back into room_tiledata
room_tiledata_monster_spawn:
			; get a monster init func addr ptr
			lxi h, monsters_inits
			add_a(2) ; to make a jmp_4 ptr
			mov e, a
			mvi d, 0
			dad d
			; call a monster init func
			pchl

; a tiledata handler for a collision + spawn an animated back by its id.
; if id == TILEDATA_FUNC_ID_COLLISION, it does not spawn an animated back
; input:
; b - tiledata
; c - tile idx in the room_tiledata array.
; a - back_id
; out:
; a - tiledata that will be saved back into room_tiledata
room_tiledata_back_spawn:
			cpi TILEDATA_FUNC_ID_COLLISION
			jnz backs_spawn
			mvi a, TILEDATA_COLLISION
			ret

; a tiledata handler for non-collision + draw a decal.
; input:
; b - tiledata
; c - tile idx in the room_tiledata array.
; a - decal_walkable_id
; out:
; a - tiledata that will be saved back into room_tiledata
room_tiledata_decal_walkable_spawn:
			; if decal_id < 2, then just copy tiledata
			cpi TILEDATA_RESTORE_TILE + 1
			jc room_tiledata_copy

			add_a(2) ; to make a jmp_4 ptr
			sta @restoreA+1
			; scr_y = tile idx % ROOM_WIDTH
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

			lxi h, __decals_walkable_gfx_ptrs - JMP_4_LEN * 2 ; make decal_id == 2 corelates to 0 addr offset
@restoreA:	lxi d, TEMP_BYTE
			dad d
			xchg
			; de pptr to a sprite
			mvi a, <__RAM_DISK_S_DECALS
			call get_word_from_ram_disk
			pop d
			; bc - sprite addr
			; de - scr addr
			CALL_RAM_DISK_FUNC(draw_decal_v, <__RAM_DISK_S_DECALS)
			mvi a, TILEDATA_RESTORE_TILE
			ret

; a tiledata handler for a collision + draw a decal.
; input:
; b - tiledata
; c - tile idx in the room_tiledata array.
; a - decal_collidable_id
; out:
; a - tiledata that will be saved back into room_tiledata
room_tiledata_decal_collidable_spawn:
			add_a(2) ; to make a jmp_4 ptr
			sta @restoreA+1
			; scr_y = tile idx % ROOM_WIDTH
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

			lxi h, __decals_collidable_gfx_ptrs
@restoreA:	lxi d, TEMP_BYTE
			dad d
			xchg
			; de pptr to a sprite
			mvi a, <__RAM_DISK_S_DECALS
			call get_word_from_ram_disk
			pop d
			; bc - sprite addr
			; de - scr addr
			CALL_RAM_DISK_FUNC(draw_decal_v, <__RAM_DISK_S_DECALS)
			mvi a, TILEDATA_COLLISION
			ret

; a tiledata handler for breakable items.
; input:
; b - tiledata
; c - tile idx in the room_tiledata array.
; a - breakable_id
; out:
; a - tiledata that will be saved back into room_tiledata
room_tiledata_breakable_spawn:
			add_a(2) ; to make a jmp_4 ptr
			sta @restoreA+1
			; scr_y = tile idx % ROOM_WIDTH
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

			lxi h, __breakable_gfx_ptrs
@restoreA:	lxi d, TEMP_BYTE
			dad d
			xchg
			; de pptr to a sprite
			mvi a, <__RAM_DISK_S_DECALS
			call get_word_from_ram_disk
			pop d
			; bc - sprite addr
			; de - scr addr
			CALL_RAM_DISK_FUNC(draw_decal_v, <__RAM_DISK_S_DECALS)
			mvi a, TILEDATA_BREAKABLE
			ret

room_draw_on_scr:
			; main scr
			CALL_RAM_DISK_FUNC(room_draw_tiles, <__RAM_DISK_S_LEVEL01_GFX)
			ret
room_draw_on_backbuffs:
			; copy $a000-$ffff scr buffs to the ram-disk back buffer
			; TODO: optimization. think of making copy process while the gameplay started.
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
/*
;=========================================================
; convert room_tiledata into the tiledata buffer in the ram-disk
; call ex. CALL_RAM_DISK_FUNC(room_init_tiledata_buff, __RAM_DISK_M_BACKBUFF2 | RAM_DISK_M_8F)
room_init_tiledata_buff:
			; set y = 0
			mvi e, 0
			lxi h, room_tiledata
@newLine
			; reset the x. it's a high byte of the first screen buffer addr
			mvi d, $80
@loop:
			; DE - screen addr
			; HL - tile graphics addr
			mov a, m
			inx h
			ROOM_DRAW_TILEDATA()

			; x = x + 1
			inr d
			; repeat if x reaches the high byte of the second screen buffer addr
			mvi a, $a0
			cmp d
			jnz @loop

			; move posY up to the next tile line
			mvi a, TILE_HEIGHT
			add e
			mov e, a
			cpi ROOM_HEIGHT * TILE_HEIGHT
			jc @newLine
			ret

;----------------------------------------------------------------
; draw a tile filled up with a tiledata (16x16 pixels)
; input:
; c - tiledata
; de - screen addr (x,y)
; out:
; d = d + 1
.macro ROOM_DRAW_TILEDATA()
		.loop 15
			stax d
			inr e
		.endloop
			stax d

			inr d
		.loop 15
			stax d
			dcr e
		.endloop
			stax d
.endmacro
*/
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
			mvi d, >SCR_BUFF0_ADDR ; $80
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
			inr_d(2)
			; repeat if x reaches the high byte of the second screen buffer addr
			mvi a, $a0
			cmp d
			jnz @loop

			; move posY up to the next tile line
			mvi a, TILE_HEIGHT
			add e
			mov e, a
			cpi ROOM_HEIGHT * TILE_HEIGHT
			jc @newLine
			ret
/*
; check tiles if they need to be restored. It uses the tiledata buffer in the ram-disk
; ex. CALL_RAM_DISK_FUNC(room_check_tiledata_restorable, __RAM_DISK_M_BACKBUFF2 | RAM_DISK_M_89, false, false)
; in:
; de - back buffer2 scr addr
; h - width
;		00 - 8pxs,
;		01 - 16pxs,
;		10 - 24pxs,
;		11 - 32pxs
; l - height
; out:
; Z flag is OFF if an area needs to be restored
; change:
; a, hl, de, b
; old wrong 120 - 236 cc
; 144 - 244 cc
room_check_tiledata_restorable:
			xchg
			xra a
			; check the bottom-left corner
			cmp m
			rnz
			; check the top-right corner
			xchg
			dad d
			dcr l ; to be inside the AABB
			cmp m
			rnz		; 184 cc if returns
			; check the top-left corner
			mov b, h
			mov h, d
			cmp m
			rnz		; 216 cc if reterns
			; check the bottom-right corner
			xchg
			mov h, b
			cmp m
			; returns Z=1. this area do not need to be restored
			ret		; 244 cc
*/
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
room_check_tiledata_restorable_v2:
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
/*
; check if tiles are walkable.
; func uses the tiledata buffer in the ram-disk
; call ex. CALL_RAM_DISK_FUNC(room_check_tiledata_walkable, __RAM_DISK_M_BACKBUFF2 | RAM_DISK_M_89, false, false)
; in:
; d - posX
; e - posY
; b - width-1
; c - height-1
; out:
; Z flag is on when all tiledata are walkable (tiledata ffff == 0)
; 292 cc
; mov RP + call + body = 320 cc
room_check_tiledata_walkable:
			; calc the top-right corner addr
			mov a, d
			add b
			ani %11110000
			rrc_(3)
			adi >BACK_BUFF2_ADDR
			mov h, a
			mov a, e
			add c
			mov l, a

			; calc the bottom-left scr addr
			xchg
			mvi a, %11110000
			ana h
			rrc_(3)
			adi >BACK_BUFF2_ADDR
			mov h, a

			; check the bottom-left corner
			mov a, m
			; check the bottom-right corner
			mov b, h ; tmp
			mov h, d
			ora m
			; check the top-right scr addr
			mov l, e
			ora m
			; check the top-left corner
			mov h, b
			ora m
			ani TILEDATA_FUNC_MASK
			ret
*/
; check if tiles are walkable.
; in:
; d - posX
; e - posY
; b - width-1
; c - height-1
; out:
; Z flag is on when all tiledata are walkable (tiledata func == 0)
; mov+call+body 28+24+176=228 - 28+24+240=292 cc
room_check_tiledata_walkable_v2:
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

@tileSizeW2H2:
			rrc_(4)
			ora l
			mov l, a
			mvi h, >room_tiledata

			; check bottom-left corner
			mov a, m
			; check bottom-right corner
			inx h ; check the next tile instead of (x+dx) because there is no sprites wider 32 pxls
			ora m
			; check top-right corner
			lxi b, ROOM_WIDTH
			dad b
			ora m
			; check top-left corner
			dcx h
			ora m
			ani TILEDATA_FUNC_MASK
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
			rrc_(4)
			ora l
			mov l, a
			mvi h, >room_tiledata

			; check bottom-left corner
			mov a, m
			; check bottom-right corner
			inx h ; check the next tile instead of (x+dx) because there is no sprites wider 32 pxls
			ora m
			ani TILEDATA_FUNC_MASK
			ret
@tileSizeW1H1:
			rrc_(4)
			ora l
			mov l, a
			mvi h, >room_tiledata

			; check bottom-left corner
			mov a, m
			ani TILEDATA_FUNC_MASK
			ret

@tileSizeW1H2:
			rrc_(4)
			ora l
			mov l, a
			mvi h, >room_tiledata

			; check bottom-left corner
			mov a, m
			; check top-left corner
			lxi b, ROOM_WIDTH
			dad b
			ora m
			ani TILEDATA_FUNC_MASK
			ret
/*
; check if tiles are walkable.
; in:
; a - posX
; e - posY
; b - width-1
; c - height-1
; out:
; Z flag is on when all tiledata are walkable (tiledata ffff == 0)
; v1. mov RP + call + body = 320 cc
; v2. 28+24+176=228 - 28+24+240=292 cc
; v3. 20+24+124=168 - 20+24+292=336
room_check_tiledata_walkable_v3:
			mov d, a
			ani %11110000
			rrc_(4)
			mov h, a
			mvi a, %11110000
			ana e
			mov l, a

			xchg
			dad b
			; hl - top-right corner posXY
			; d = x in tiles
			; e, a = y in tiles * 32
			mvi b, >room_tiledata

			; check bottom-left corner
			ora d
			mov c, a
			ldax b
			ani TILEDATA_FUNC_MASK
			rnz			; 168

			; get x+dx in tiles
			mvi a, %11110000
			ana h
			rrc_(4)
			mov h, a
			; h, a = x+dx in tiles

			; check bottom-right corner
			ora e
			mov c, a
			ldax b
			mvi e, TILEDATA_FUNC_MASK
			ana e
			rnz			; 244

			; get y+dy in tiles
			mvi a, %11110000
			ana l
			mov l, a
			; l, a = y+dy in tiles

			; check top-right corner
			ora h
			mov c, a
			ldax b
			ana e
			rnz			; 296

			; check top-left corner
			mov a, d
			ora l
			mov c, a
			ldax b
			ana e
			ret		; 336
*/
/*
; collects tiledata of tiles that intersect with a sprite
; this func uses the tiledata buffer in the ram-disk
; ex. CALL_RAM_DISK_FUNC(room_get_tiledata, __RAM_DISK_M_BACKBUFF2 | RAM_DISK_M_89, false, false)
; in:
; d - posX
; e - posY
; b - width-1
; c - height-1
; out: room_get_tiledata_buff
; hl - (room_get_tiledata_buff+2)
; de - (room_get_tiledata_buff)
room_get_tiledata_buff:
			; tiledata layout:
			; (bottom-left), (top-left), (top-right), (bottom-right)
			.byte 0, 0, 0, 0,
; Z flag = 1 if all tiles have tiledata func==0
; 364 cc
room_get_tiledata:
			; calc the top-right corner addr
			mov a, d
			add b
			ani %11110000
			rrc_(3)
			adi >BACK_BUFF2_ADDR
			mov h, a
			mov a, e
			add c
			mov l, a

			; calc the bottom-left scr addr
			xchg
			mvi a, %11110000
			ana h
			rrc_(3)
			adi >BACK_BUFF2_ADDR
			mov h, a

			; check the bottom-left corner
			mov c, m
			; check the bottom-right corner
			mov b, h ; tmp
			mov h, d
			mov d, m
			; check the top-right scr addr
			mov l, e
			mov e, m
			; check the top-left corner
			mov h, b
			mov h, m
			mov l, c

			; tiledata layout in registers:
			; h (top-left), 	e (top_right)
			; l (bottom-left), 	d (bottom-right)

			; tiledata layout in room_get_tiledata_buff:
			; (bottom-left), (top-left), (top_right), (bottom-right)

			shld room_get_tiledata_buff
			xchg
			shld room_get_tiledata_buff+2

			mov a, h
			ora l
			ora d
			ora e
			ani TILEDATA_FUNC_MASK
			ret
*/
; collects tiledata of tiles that intersect with a sprite
; in:
; d - posX
; e - posY
; b - width-1
; c - height-1
; out: room_get_tiledata_buff
; hl - (room_get_tiledata_buff+2)
; de - (room_get_tiledata_buff)
room_get_tiledata_buff2:
			; tiledata layout:
			; (bottom-left), (bottom-right), (top-left), (top-right)
			.byte 0, 0, 0, 0,
; Z flag = 1 if all tiles have tiledata func==0
; 24+224=248 - 24+316 =340 cc
room_get_tiledata2:
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

			rrc_(4)
			ora l

			mov l, a
			mvi h, >room_tiledata

			xra a
			mov e, m
			ora e
			inx h
			mov d, m
			ora d
			lxi b, ROOM_WIDTH
			dad b
			xchg
			shld room_get_tiledata_buff2
			xchg
			mov b, m
			ora b
			dcx h
			mov l, m
			ora l
			mov h, b
			shld room_get_tiledata_buff2+2
			ani TILEDATA_FUNC_MASK
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
			rrc_(4)
			ora l

			mov l, a
			mvi h, >room_tiledata

			xra a
			mov e, m
			ora e
			inx h
			mov d, m
			ora d

			; bottom two corners points to the same tiledata as the top two corners
			xchg
			shld room_get_tiledata_buff2
			shld room_get_tiledata_buff2+2
			ani TILEDATA_FUNC_MASK
			ret

@tileSizeW1H1:
			rrc_(4)
			ora l

			mov l, a
			mvi h, >room_tiledata

			; all four corners points tothe same tiledata
			mov a, m
			mov l, a
			mov h, a
			shld room_get_tiledata_buff2
			shld room_get_tiledata_buff2+2
			ani TILEDATA_FUNC_MASK
			ret

@tileSizeW1H2:
			rrc_(4)
			ora l

			mov l, a
			mvi h, >room_tiledata

			xra a
			mov e, m
			mvi d, 0
			ora e
			lxi b, ROOM_WIDTH
			dad b
			xchg
			shld room_get_tiledata_buff2
			xchg
			mov l, m
			ora l
			mov h, d
			shld room_get_tiledata_buff2+2
			ani TILEDATA_FUNC_MASK
			ret