RoomInit:
			call MonstersEraseRuntimeData
			call RoomInitTiles
			call RoomInitTilesData
			; erase a back buffer $a000-$ffff in the ram-disk
			; TODO: perhaps we do not need to erase a back buffer.
			; because we will restore a background tiles
			lxi b, $0000
			lxi d, $6000 / 128 - 1
			CALL_RAM_DISK_FUNC(__ClearMemSP, RAM_DISK_S2 | RAM_DISK_M2 | RAM_DISK_M_89)
			ret

; it copies the tile idxs of the current room into roomTilesData as a temp storrage
; then it converts idxs into tile gfx addrs
RoomInitTiles:
			; copy the tiles idxs from the ram-disk to the roomTilesData buffer
			lda roomIdx
			; double the room index to get an address offset in the level01_roomsAddr array
			rlc
			; double it again because there are two safety bytes in front of every room pointer
			rlc
			mov c, a
			mvi b, 0
			lxi h, level01_roomsAddr
			dad b

			xchg
			mvi a, RAM_DISK_S0
			call GetWordFromRamDisk
			mov d, b
			mov e, c

			lxi b, roomTilesData ; the tile data buffer is used as a temp buffer
			lxi h, RAM_DISK_S0<<8 | ROOM_WIDTH * ROOM_HEIGHT / 2
			call CopyFromRamDisk

			; convert tile idxs into tile gfx addrs
			lxi h, roomTilesData
			lxi b, roomTilesAddr
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
			lxi d, level01_tilesAddr
			; hl gets the tile graphics ponter
			dad d

			; copy the tile graphics addr to the current room tile graphics table
			push b
			xchg
			mvi a, RAM_DISK_S0
			call GetWordFromRamDisk
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

; copies the tiles data of the current room into the main memory.
; calls the tile data handler func to spawn spawn a monster, etc
RoomInitTilesData:
			; copy the tiles data from the ram-disk
			lda roomIdx
			; double a room index to get a room pointer
			rlc
			; double it again because there are two safety bytes in front of every pointer
			rlc
			mov c, a
			mvi b, 0
			lxi h, level01_roomsAddr
			dad b

			xchg
			mvi a, RAM_DISK_S0
			call GetWordFromRamDisk
			lxi h, ROOM_WIDTH * ROOM_HEIGHT + 2 ; tiles data is stored right after the tile addr tbl plus 2 safety bytes
			dad b

			xchg
			lxi b, roomTilesData
			lxi h, RAM_DISK_S0<<8 | ROOM_WIDTH * ROOM_HEIGHT / 2
			call CopyFromRamDisk

			; handle the tile data calling tile data funcs
			lxi h, roomTilesData
			mvi c, 0
@loop:
			mov b, m
			push b
			TILE_DATA_HANDLE_FUNC_CALL(roomFuncTable)
			pop b
			mov m, a
			inx h
			inr c
			mvi a, ROOM_WIDTH * ROOM_HEIGHT
			cmp c
			jnz @loop
			ret
			.closelabels


; this is a dummy tile data handler.
; it copies the tile data byte into the roomTilesData as it is
; input:
; b - tile data
; return:
; a - tile data that will be saved into the room tile data array
RoomTileDataCopy:
            ; just return the same tile data
			mov a, b
			ret
			.closelabels

; a tile data handler to spawn a monster by its id.
; input:
; c - tile idx in the roomTilesData array.
; a - monster id
RoomMonsterSpawn:
			; get a monster init func addr ptr
			lxi h, monstersInits
			rlc
			mov e, a
			mvi d, 0
			dad d
			; get a monster init func addr
			mov e, m
			inx h
			mov d, m
			; call a monster init func
			xchg
			pchl
			.closelabels

RoomDraw:
			; main scr
			CALL_RAM_DISK_FUNC(RoomDrawTiles, RAM_DISK_S0)

			; copy $a000-$ffff scr buffs to the ram-disk
			; TODO: optimization. think of making copy process while the gameplay started.
			lxi d, 0; SCR_BUFF1_ADDR + SCR_BUFF_LEN * 3
			lxi h, 0; SCR_BUFF1_ADDR + SCR_BUFF_LEN * 3
			lxi b, SCR_BUFF_LEN * 3 / 32
			mvi a, RAM_DISK_S2
			call CopyToRamDisk32

			; copy $a000-$ffff scr buffs to the back buffer2 (to restore the background in the back buffer)
			lxi d, 0; SCR_BUFF1_ADDR + SCR_BUFF_LEN * 3
			lxi h, 0; SCR_BUFF1_ADDR + SCR_BUFF_LEN * 3
			lxi b, SCR_BUFF_LEN * 3 / 32
			mvi a, RAM_DISK_S3
			call CopyToRamDisk32

			; convert roomTilesData into $8000 tiledata buffer in the ram-disk
			;call RoomTileDataBuff
			CALL_RAM_DISK_FUNC(RoomTileDataBuff, RAM_DISK_M3 | RAM_DISK_M_8F)
			ret


;=========================================================
; convert roomTilesData into the tiledata buffer in the ram-disk (bank 3 at $8000)
; call ex. CALL_RAM_DISK_FUNC(RoomTileDataBuff, RAM_DISK_M3 | RAM_DISK_M_8F)
RoomTileDataBuff:
			; set y = 0
			mvi e, 0
			lxi h, roomTilesData
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
; call ex. CALL_RAM_DISK_FUNC(RoomDrawTiles, RAM_DISK_S0)
; RAM_DISK_S0 - ram-disk activation command where stored tile gfx
RoomDrawTiles:
			; set y = 0
			mvi e, 0
			; set a pointer to the first item in the list of addrs of tile graphics
			lxi h, roomTilesAddr
@newLine
			; reset the x. it's a high byte of the first screen buffer addr
			mvi d, $80
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

; TODO: optimize. do not check if a actor is still inside the same tiles
; b - an actor posX
; c - an actor posY
; return: roomTileCollisionData. it's a list of collided tiles data
;
RoomCheckTileCollision:
			; clear only the last 2 bytes, because the first one will be overwritten anyway
			lxi h, 0
			shld roomTileCollisionData+2

			; mask
			mvi d, %00001111
			; check if we have to check bottom tiles
			mov a, c
            ana d
			cpi 2
			mvi a, OPCODE_XCHG
			jnc @checkBottom
			; do not check bottom tiles
			mvi a, OPCODE_RET
@checkBottom:
			sta @checkBottomTiles
			; check if we need to check up-right and bottom-right tiles
			mov a, b
			ana d
			jnz @ckeckRight
			; do not check right tiles
			mvi a, OPCODE_MOV_D_B
			sta @checkRightUpTile
			mvi a, OPCODE_RET
			sta @checkRightBottomTile
			jmp @check
@ckeckRight:
			mvi a, OPCODE_MOV_D_M
			sta @checkRightUpTile
			sta @checkRightBottomTile

@check:
			; get the index in the tile map table
			; use the posY
			mov a, c
			ani %11110000
			mov c, a

			; use the posX
			mov a, b
			rrc_(4)
			ana d
			add c

			mov c, a
			mvi b, 0
			lxi h, roomTilesData
			dad b
			; get the tile data where a top-left pixel of a sprite drawn
			mov e, m
			; get the tile data where a top-right pixel of a sprite drawn
			inx h
@checkRightUpTile:
			mov d, m
			xchg
			shld roomTileCollisionData
			mov a, l
			ora h
@checkBottomTiles:
			xchg
			; get the tile data where a bottom-left pixel of a sprite drawn
			mvi c, ROOM_WIDTH-1
			dad b
			mov e, m
			ora e
			; get the tile data where a bottom-right pixel of a sprite drawn
			inx h
@checkRightBottomTile:
			mov d, m
			ora d
			xchg
			shld roomTileCollisionData+2
			ret
roomTileCollisionData:
			.byte 0, 0, 0, 0,

; read a byte from a tiledata buffer in the ram-disk (bank 3 at $8000)
; call ex. CALL_RAM_DISK_FUNC(RoomTileDataBuffCheck, RAM_DISK_M3 | RAM_DISK_M_8F, false, false)
; in:
; de - scr addr
; h - width
;		00 - 8pxs,
;		01 - 16pxs,
;		10 - 24pxs,
;		11 - 32pxs
; l - height
; out:
; Z flag is ON if tile data == 0

RoomTileDataBuffCheck:
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
		; return Z=1 if all checked tile data is zero
		ret

; check collision in the tiledata buffer in the ram-disk (bank 3 at $8000)
; call ex. CALL_RAM_DISK_FUNC(RoomCheckTileCollision2, RAM_DISK_M3 | RAM_DISK_M_89, false, false)
; in:
; d - posX
; e - posY
; b - width
; c - height
; out:
; Z flag is ON if the tile data == TILE_DATA_COLLISION
RoomCheckTileCollision2:
		xchg
		shld @restorePos+1
		; calc the bottom left scr addr
		mvi a, %11110000
		ana h
		rrc_(3)
		adi $80
		mov h, a

		; check the bottom-left corner
		mov a, m
		cpi TILE_DATA_COLLISION
		rz
		; check the top-left corner
		mov a, l
		add c
		dcr a ; to be inside the AABB
		mov l, a
		mov a, m
		cpi TILE_DATA_COLLISION
		rz

@restorePos:
		lxi h, TEMP_WORD
		; calc the bottom right scr addr
		mov a, h
		add b
		dcr a ; to be inside the AABB
		ani %11110000
		rrc_(3)
		adi $80
		mov h, a

		; check the bottom right scr addr
		mov a, m
		cpi TILE_DATA_COLLISION
		rz
		; check the top-left corner
		mov a, l
		add c
		dcr a ; to be inside the AABB		
		mov l, a
		mov a, m
		cpi TILE_DATA_COLLISION
		rz
		; return Z=0 if no collision
		ret