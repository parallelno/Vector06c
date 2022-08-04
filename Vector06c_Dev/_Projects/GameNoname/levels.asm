;================================================================
;	initialization levels data every game start
;
LevelsInit:	
			xra a
			sta levelIdx
			ret

;================================================================
;	initialization level data every game start
;
LevelInit:
			hlt
			lxi h, palette_sprites_tiles_lv01+15
            call SetPalette
			mvi a, 1
			sta borderColorIdx
			xra a
			sta roomIdx	
			lhld startPos
			call HeroSetPos
			call HeroInit	
			ret
			.closelabels

RoomInit:
			call HeroStop
			call RoomInitTiles
			call RoomInitTilesData
			ret
			
RoomInitTiles:
			lda roomIdx
			rlc
			mov c, a
			mvi b, 0
			lxi h, roomsAddr
			dad b
			mov e, m
			inx h
			mov d, m
			xchg
			lxi b, roomTilesAddr
			mvi a, ROOM_WIDTH * ROOM_HEIGHT
			; hl - current room tile indexes for tilesAddr list
			; bc - current room tile graphics table
			; a - counter
			
@loop:
			; get the tile index into de
			push psw
			mov e, m
			mvi d, 0
			inx h
			push h
			lxi h, tilesAddr
			; get the tile graphics ponter into hl
			dad d
			dad d
			; copy the tile graphics addr to the current room tile graphics table
			mov a, m
			stax b
			inx h
			inx b
			mov a, m
			stax b
			inx b
			pop h
			pop psw
			; repeat if it's not done
			dcr a
			jnz @loop
			ret
			.closelabels

; copy the packed tiles data. 
; it also analizes the tiles data and initializes monsters and feeds up the monster pool if there is any monster in the room, etc
; hl - packed tiles data addr
; 
RoomInitTilesData:
			lxi d, roomTilesData
			mvi c, ROOM_WIDTH * ROOM_HEIGHT
@loop:
			mov a, m
			
			;TILE_DATA_HANDLE_FUNC_CALL()

			stax d
			inx h
			inx d
			dcr c
			jnz @loop
			ret
			.closelabels

LevelUpdate:
			lda levelCommand
			ora a
			rz
			cpi LEVEL_COMMAND_LOAD_DRAW_ROOM
			; load a new room
			call RoomInit
			call RoomDraw
			call HeroInit
			xra a
			lda	interruptionCounter

			xra a
			sta levelCommand
			ret

RoomDraw:
			call ClearScr
			; TODO: clean this func. add a description, comments, and constants
			; set Y
			mvi e, $ff - 16
			; set a pointer to the first item in the list of addrs of tile graphics
			lxi h, roomTilesAddr
@newLine
			; reset the X
			mvi d, $80
@loop:
			; DE - screen addr
			; HL - tile graphics addr
			; A - counter
			mov c, M
			inx H
			mov b, M
			inx H
			push D
			push h
			call DrawTile16x16
			pop h
			pop D

			inr D
			inr D
			; repeat if X != $a0 (end of the)
			mvi a, $a0
			cmp d
			jnz @loop

			mov a, e
			sui 16
			mov e, a
			jnc @newLine

			ret
			.closelabels

; TODO: optimize to not check when the hero do not move ouside tile
; bc - posXY
; return: collidedRoomTilesData. it's a list with collided tiles data
;
collidedRoomTilesData:
			.byte 0, 0, 0, 0,
CheckRoomTilesCollision:
			; clear only the last 2 bytes, because the first one will be overwritten anyway
			lxi h, 0
			shld collidedRoomTilesData+2
			
			mvi d, $0f
			; check if we have to check bottom tiles
			mov a, c
            ana d
			cpi 14
			mvi a, $eb	; opcode "xchg,"
			jc @check
			; do not check bottom tiles
			mvi a, $c9		; opcode "ret"
@check:
			sta @checkBottomTiles
						
			; get tileY
			mov a, c
			cma
			rrc_(4)
			ana d
			mov e, a

			; get tileX
			mov a, b
			dcr a
			rrc_(4)
			ana d
			; get the offset in the tile map table
			mvi d, ROOM_WIDTH
@loop:
			dcr e
			jz @afterloop
			add d
			jmp @loop
@afterloop			
			mov c, a
			mvi b, 0
			lxi h, roomTilesData
			dad b
			; get data of a tile where a top-left pixel of a sprite drawn
			mov e, m
			mov a, e 
			; get data of a tile where a top-right pixel of a sprite drawn
			inx h
			mov d, m
			ora d
			xchg
			shld collidedRoomTilesData
@checkBottomTiles:			
			xchg
			; get data of a tile where a bottom-left pixel of a sprite drawn
			mvi c, ROOM_WIDTH-1
			dad b
			mov e, m
			ora e
			; get data of a tile where a bottom-right pixel of a sprite drawn
			inx h
			mov d, m
			ora d
			xchg
			shld collidedRoomTilesData+2
			ret
			.closelabels