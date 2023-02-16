room_init:
			call MonstersEraseRuntimeData
			call bullets_erase_runtime_data
			call backs_init
			call room_init_tiles_gfx
			call room_init_tiles_data
			; erase a back buffer $a000-$ffff in the ram-disk
			; TODO: perhaps we do not need to erase a back buffer.
			; because we will restore a background tiles
			lxi b, $0000
			lxi d, $6000 / 128 - 1
			CALL_RAM_DISK_FUNC(__ClearMemSP, __RAM_DISK_S_BACKBUFF | __RAM_DISK_M_CLEAR_MEM | RAM_DISK_M_89)
			ret

; it copies the tile idxs of the current room into room_tiles_data as a temporally,
; then it converts idxs into tile gfx ptrs
room_init_tiles_gfx:
			; copy the tiles idxs from the ram-disk to the room_tiles_data buffer
			lda room_idx
			; double the room index to get an address offset in the level01_roomsAddr array
			rlc
			; double it again because there are two safety bytes in front of every room pointer
			rlc
			mov c, a
			mvi b, 0
			lxi h, __level01_roomsAddr
			dad b

			xchg
			mvi a, <__RAM_DISK_S_LEVEL01
			call get_word_from_ram_disk
			mov d, b
			mov e, c

			lxi b, room_tiles_data ; the tile data buffer is used as a temp buffer
			lxi h, <__RAM_DISK_S_LEVEL01<<8 | ROOM_WIDTH * ROOM_HEIGHT / 2
			call copy_from_ram_disk

			; convert tile idxs into tile gfx addrs
			lxi h, room_tiles_data
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
			mvi a, <__RAM_DISK_S_LEVEL01
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
			; repeat if it's not done
			dcr a
			jnz @loop
			ret
			.closelabels

; copies the tiles data of the current room from the ram-disk into room_tiles_data.
; calls the tile data handler func to spawn spawn a monster, etc
room_init_tiles_data:
			; copy the tiles data from the ram-disk
			lda room_idx
			; double a room index to get a room pointer
			rlc
			; double it again because there are two safety bytes in front of every pointer
			rlc
			mov c, a
			mvi b, 0
			lxi h, __level01_roomsAddr
			dad b

			xchg
			mvi a, <__RAM_DISK_S_LEVEL01
			call get_word_from_ram_disk
			lxi h, ROOM_WIDTH * ROOM_HEIGHT + 2 ; tiles data is stored right after the tile addr tbl plus 2 safety bytes
			dad b

			xchg
			lxi b, room_tiles_data
			lxi h, <__RAM_DISK_S_LEVEL01<<8 | ROOM_WIDTH * ROOM_HEIGHT / 2
			call copy_from_ram_disk

			; handle the tile data calling tile data funcs
			lxi h, room_tiles_data
			mvi c, 0
@loop:
			mov b, m
			push b
			TILE_DATA_HANDLE_FUNC_CALL(room_func_table)
			pop b
			mov m, a ; save tile_data back into room_tiles_data. funcs (ex. burner_init etc.) can replace A with 0 to make it walkable
			inx h
			inr c
			mvi a, ROOM_WIDTH * ROOM_HEIGHT
			cmp c
			jnz @loop
			ret
			.closelabels


; this is a dummy tile data handler.
; it copies the tile data byte into the room_tiles_data as it is
; input:
; b - tile data
; out:
; a - tile_data that will be saved back into room_tiles_data
room_tile_data_copy:
            ; just return the same tile data
			mov a, b
			ret

room_draw:
			; main scr
			CALL_RAM_DISK_FUNC(room_draw_tiles, <__RAM_DISK_S_LEVEL01)

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

			; convert room_tiles_data into $8000 tiledata buffer in the ram-disk
			;call room_tile_data_buff
			CALL_RAM_DISK_FUNC(room_tile_data_buff, __RAM_DISK_M_BACKBUFF2 | RAM_DISK_M_8F)
			ret


;=========================================================
; convert room_tiles_data into the tiledata buffer in the ram-disk (bank 3 at $8000)
; call ex. CALL_RAM_DISK_FUNC(room_tile_data_buff, __RAM_DISK_M_BACKBUFF2 | RAM_DISK_M_8F)
room_tile_data_buff:
			; set y = 0
			mvi e, 0
			lxi h, room_tiles_data
@newLine
			; reset the x. it's a high byte of the first screen buffer addr
			mvi d, $80
@loop:
			; DE - screen addr
			; HL - tile graphics addr
			mov a, m
			inx h
			ROOM_DRAW_TILE_DATA()	

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
; draw a tile filled up with a tile data (16x16 pixels)
; input:
; c - tile data
; de - screen addr (x,y)
; out:
; d = d + 1
.macro ROOM_DRAW_TILE_DATA()
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

;=========================================================
; draw a room tiles. It might be a main screen, or a back buffer
; call ex. CALL_RAM_DISK_FUNC(room_draw_tiles, <__RAM_DISK_S_LEVEL01)
; __RAM_DISK_S_LEVEL01 - ram-disk activation command where tile gfx stored
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
			call DrawTile16x16
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

; check tiles if they need to be restored. It uses the tiledata buffer in the ram-disk (bank 3 at $8000)
; ex. CALL_RAM_DISK_FUNC(room_check_non_zero_tiles, __RAM_DISK_M_BACKBUFF2 | RAM_DISK_M_89, false, false)
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
room_check_non_zero_tiles:
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
			rnz
			; check the top-left corner
			mov b, h
			mov h, d
			cmp m
			rnz
			; check the bottom-right corner
			xchg
			mov h, b
			cmp m
			rnz
			; returns Z=1. this area do not need to be restored
			ret

; check if tiles are walkable.
; func uses the tiledata buffer in the ram-disk (bank 3 at $8000)
; call ex. CALL_RAM_DISK_FUNC(room_check_walkable_tiles, __RAM_DISK_M_BACKBUFF2 | RAM_DISK_M_89, false, false)
; in:
; d - posX
; e - posY
; b - width-1
; c - height-1
; out:
; Z flag is on when all tile data are walkable (tiledata fff == 0)
room_check_walkable_tiles:
			; calc the top-right corner addr
			mov a, d
			add b
			ani %11110000
			rrc_(3)
			adi >BACK_BUFF2_ADDR ; $80
			mov h, a
			mov a, e
			add c
			mov l, a

			; calc the bottom-left scr addr
			xchg
			mvi a, %11110000
			ana h
			rrc_(3)
			adi >BACK_BUFF2_ADDR ; $80
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
			ani TILE_DATA_FUNC_MASK
			ret

; collects tiledata of tiles which intersect with a sprite
; this func uses the tiledata buffer in the ram-disk (bank 3 at $8000)
; ex. CALL_RAM_DISK_FUNC(room_get_tile_data_around_sprite, __RAM_DISK_M_BACKBUFF2 | RAM_DISK_M_89, false, false)
; in:
; d - posX
; e - posY
; b - width-1
; c - height-1
; out:
room_tile_collision_data:
			; tile_data layout:
			; (bottom-left), (top-left), (top_right), (bottom-right)
			.byte 0, 0, 0, 0,		
; Z flag = 1 if all tiles have tile_data func==0
room_get_tile_data_around_sprite:
			; calc the top-right corner addr
			mov a, d
			add b
			ani %11110000
			rrc_(3)
			adi >BACK_BUFF2_ADDR ; $80
			mov h, a
			mov a, e
			add c
			mov l, a

			; calc the bottom-left scr addr
			xchg
			mvi a, %11110000
			ana h
			rrc_(3)
			adi >BACK_BUFF2_ADDR ; $80
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
			
			; tile_data layout in registers:
			; h (top-left), 	e (top_right)
			; l (bottom-left), 	d (bottom-right)

			; tile_data layout in room_tile_collision_data:
			; (bottom-left), (top-left), (top_right), (bottom-right)

			shld room_tile_collision_data
			xchg
			shld room_tile_collision_data+2

			mov a, h
			ora l
			ora d
			ora e
			ani TILE_DATA_FUNC_MASK
			ret
/*
; check a collision of sprite pixel against a tiledata
; this func uses the tiledata buffer in the ram-disk (bank 3 at $8000)
; call ex. CALL_RAM_DISK_FUNC(room_check_tile_data_collision_pxl, __RAM_DISK_M_BACKBUFF2 | RAM_DISK_M_89, false, false)
; in:
; d - posX
; e - posY
; b - offsetX
; c - offsetY
; out:
; Z flag = 1 if no collision
room_check_tile_data_collision_pxl:
			; calc the top-right corner addr
			mov a, d
			add b
			ani %11110000
			rrc_(3)
			adi $80
			mov h, a
			mov a, e
			add c
			mov l, a

			; check the collision
			mov a, m
			adi 1
			ret
*/
; collects a tiledata around a sprite if it's a collision data (equals $ff)
; this func uses the tiledata buffer in the ram-disk (bank 3 at $8000)
; ex. CALL_RAM_DISK_FUNC(room_check_tile_data_collision, __RAM_DISK_M_BACKBUFF2 | RAM_DISK_M_89, false, false)
; in:
; d - posX
; e - posY
; b - width-1
; c - height-1
; out:
; c - collision data x 4 to make a ptr to a jmp table with 4 byte alignment
		; a bits layout in C register:
		; 0,0,0,0, (bottom-left), (bottom-right), (top_right), (top-left), 0
		; if it's collision, bit is ON.
; Z flag = 1 if no collision

room_check_tile_data_collision:
			; calc the top-right corner addr
			mov a, d
			add b
			ani %11110000
			rrc_(3)
			adi $80
			mov h, a
			mov a, e
			add c
			mov l, a

			; calc the bottom left scr addr
			xchg
			mvi a, %11110000
			ana h
			rrc_(3)
			adi $80
			mov h, a

			; check the bottom-left corner
			mov a, m
			adi 1
			mvi a, 0
			ral
			mov c, a

			; check the bottom-right corner
			mov b, h ; tmp
			mov h, d

			mvi d, 1
			mov a, m
			add d
			mov a, c
			ral
			mov c, a

			; check the top-right scr addr
			mov l, e
			mov a, m
			add d
			mov a, c
			ral
			mov c, a

			; check the top-left corner
			mov h, b
			mov a, m
			add d
			mov a, c
			ral
			add a 
			add a
			mov c, a			
			ret
