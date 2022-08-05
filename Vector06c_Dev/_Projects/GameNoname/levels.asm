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
			call MonstersClearRoomData
			call RoomInitTiles
			call RoomInitTilesData
			call MonstersInit
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
			lxi h, tilesAddr
			; hl gets the tile graphics ponter
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

; input:
; b - tile data			
; return:
; a - tile data that will be saved into the room tile data array
LevelsTileDataCopy:
            ; just return the same tile data
            mov a, b
			ret
			.closelabels
; input:
; c - tile number idx in the room data array. it starts from left-top corner to right-bottom
; a - monster id
; return:
; a - tile data that will be saved into the room tile data array
LevelsMonstersSpawn:
			; get the monster funcs addr
			lxi h, monstersFuncs
			rlc
			mov e, a
			mvi d, 0
			dad d
			; get the monster init func addr
			mov e, m
			inx h
			mov d, m
			inx h
			xchg
			shld @storeInitFunc+1
			xchg			
			; get the monster update func addr
			mov e, m
			inx h
			mov d, m
			inx h
			xchg
			shld @storeUpdateFunc+1
			xchg
			; get the monster draw func addr
			mov e, m
			inx h
			mov d, m
			xchg
			shld @storeDrawFunc+1
			; convert tile idx into the posX
			mov a, c
			; posX = tile idx % ROOM_WIDTH * TILE_WIDTH
			ani %00001111
			rlc_(4)
			sta @savePosX+1
			; convert tile idx into the posY
			mov a, c
			; posY = tile idx % ROOM_WIDTH * TILE_WIDTH
			ani %11110000
			cma
			sui TILE_HEIGHT
			sta @savePosY+1

			; loop monstersUpdateFunc to find an empty slot
			; check only high byte if it's zero
			lxi h, monstersInitFunc + 1
			; c - doubled counter. 
			; it is used to get a draw func addr as well as a room sprite data addr
			; b = 0 for "dad b" below
			lxi b, 0
@loop:		
			mov a, m
			ora a
			jz @storeInitFunc
			inx h
			inx h
			inr c
			inr c
			mov a, c
			cpi MONSTERS_MAX * 2
			jnz @loop
			; return if there is no room for a new monster
			jmp @tileDataToZero

@storeInitFunc:
			lxi d, TEMP_ADDR
			; store a monster init func addr backwards from high byte to low
			mov m, d
			dcx h
			mov m, e

			; store a monster update func addr
			lxi h, monstersUpdateFunc
			dad b
@storeUpdateFunc:
			lxi d, TEMP_ADDR
			mov m, e
			inx h
			mov m, d

			; store a monster draw func addr
			lxi h, monstersDrawFunc
			dad b
@storeDrawFunc:
			lxi d, TEMP_ADDR
			mov m, e
			inx h
			mov m, d

			; divide the offset by 2 because the monsterRoomDataAddrOffsets contains bytes
			mov a, c
			rrc
			mov c, a
			; get the posX+1 addr
			lxi h, monsterRoomDataAddrOffsets
			dad b
			mov c, m
			lxi h, monsterPosX+1
			dad b
@savePosX:
			mvi m, TEMP_BYTE
			inx h
			inx h

@savePosY:
			mvi m, TEMP_BYTE

			; init monsterCleanScrAddr
			lxi h, monsterPosX+1
			dad b
			push b
			call GetSpriteScrAddr
			mov a, c
			pop b
			lxi h, monsterCleanScrAddr
			dad b
			mov m, e
			inx h
			mov m, d
			inx h
			mov m, a

			; store monsterRedrawTimer
			lxi h, monsterRedrawTimer
			dad b
@rndDraw:	; make monsterRedrawTimer for every spawned monster different to balance the cpu load
			mvi a, 4
			mov m, a
			rlc
			sta @rndDraw+1

@tileDataToZero:	
			; replace tile data with an empty tile
            xra a
			ret
			.closelabels
			
; copy the packed tiles data. 
; it also analizes the tiles data and initializes monsters and feeds up the monster pool if there is any monster in the room, etc
; input:
; hl - packed tiles data addr
; de - room tiles data
; uses:
; a, c

RoomInitTilesData:
			lxi d, roomTilesData
			mvi c, 0
@loop:
			mov b, m
			push d
			push b
			TILE_DATA_HANDLE_FUNC_CALL(roomFuncTable)
			pop b
			pop d
			stax d
			inx h
			inx d
			inr c
			mvi a, ROOM_WIDTH * ROOM_HEIGHT
			cmp c
			jnz @loop
			ret
			.closelabels

LevelUpdate:
			lda levelCommand
			ora a
			rz
			cpi LEVEL_COMMAND_LOAD_DRAW_ROOM
			jnz @nextCommandCheck
			; load a new room
			call RoomInit
			call RoomDraw
			call HeroInit
			xra a
			lda	interruptionCounter

			xra a
			sta levelCommand
			ret
@nextCommandCheck:
            ret

RoomDraw:
			call ClearScr
			; TODO: clean this func. add a description, comments, and constants
			; set Y
			mvi e, $ff - TILE_HEIGHT
			; set a pointer to the first item in the list of addrs of tile graphics
			lxi h, roomTilesAddr
@newLine
			; reset the X. it's an high byte of the first screen buffer addr
			mvi d, $80
@loop:
			; DE - screen addr
			; HL - tile graphics addr
			; A - counter
			mov c, m
			inx h
			mov b, m
			inx h
			push d
			push h
			call DrawTile16x16
			pop h
			pop d

			inr d
			inr d
			; repeat if x reaches the high byte of the second screen buffer addr
			mvi a, $a0
			cmp d
			jnz @loop

			mov a, e
			; move posY down to the next tile line
			sui TILE_HEIGHT
			mov e, a
			jnc @newLine
			ret
			.closelabels

; TODO: optimize to not check when the hero do not move ouside tile
; b - char posX
; c - char posY
; return: collidedRoomTilesData. it's a list with collided tiles data
;
collidedRoomTilesData:
			.byte 0, 0, 0, 0,
CheckRoomTilesCollision:
			; clear only the last 2 bytes, because the first one will be overwritten anyway
			lxi h, 0
			shld collidedRoomTilesData+2
			
			; mask
			mvi d, %00001111
			; check if we have to check bottom tiles
			mov a, c
            ana d
			cpi 14
			mvi a, OPCODE_XCHG
			jc @check
			; do not check bottom tiles
			mvi a, OPCODE_RET
@check:
			sta @checkBottomTiles

			; get the index in the tile map table
			; use the char posY
			mov a, c
			cma
			sui TILE_HEIGHT
			ani %11110000
			mov c, a

			; use the char posX
			mov a, b
			dcr a
			rrc_(4)
			ana d
			add c

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