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
			lxi d, level01_palette_sprites_tiles_lv01
            call SetPaletteFromRamDisk
			mvi a, 1
			sta borderColorIdx
			xra a
			sta roomIdx
			
			lxi d, level01_startPos
			call GetWordFromRamDisk
			call HeroSetPos
			call HeroInit
			ret
			.closelabels

RoomInit:
			call MonstersClearRoomData
			call RoomInitTiles
			call RoomInitTilesData
			call MonstersInit
			; erase $a000-$ffff buffer in the ram-disk
			lxi d, $0000
			lxi b, $6000 / 128 - 1
			CALL_RAM_DISK_FUNC(__ClearMemSP, RAM_DISK0_B2_STACK_B2_8AF_RAM)
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
			call GetWordFromRamDisk
			mov d, b
			mov e, c

			lxi b, roomTilesData ; the tile data buffer is used as a temp buffer
			mvi a, ROOM_WIDTH * ROOM_HEIGHT / 2
			call CopyDataFromRamDisk

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
			
; copy the tiles data of the current room into the main memory
; then it analizes the tiles data and calls monster init funcs, 
; feeds up the monster pool if there is any monster in the room
;
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
			call GetWordFromRamDisk
			lxi h, ROOM_WIDTH * ROOM_HEIGHT + 2 ; tiles data is stored right after the tile addr tbl plus 2 safety bytes
			dad b

			xchg
			lxi b, roomTilesData
			mvi a, ROOM_WIDTH * ROOM_HEIGHT / 2
			call CopyDataFromRamDisk

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


; this is a handler of the RoomInitTilesData
; it copies the tile data byte into the roomTilesData as it is
; input:
; b - tile data
; return:
; a - tile data that will be saved into the room tile data array
LevelsTileDataCopy:
            ; just return the same tile data
			mov a, b
			ret
			.closelabels

; this is a handler of the RoomInitTilesData
; it spawns a monster according to the argument which is a part of the tile data byte. 
; for the details on tile data format see levelsGlobalData.asm->tile data format
; then it stores zero into the roomTilesData
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

			; init monsterEraseScrAddr
			lxi h, monsterPosX+1
			dad b
			push b
			call GetSpriteScrAddr
			mov a, c
			pop b
			lxi h, monsterEraseScrAddr
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
			mvi a, %1000100
			mov m, a
			rlc
			sta @rndDraw+1

@tileDataToZero:	
			; replace the tile data with an empty tile
            xra a
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
			; reset the command
			xra a
			sta levelCommand
			ret
@nextCommandCheck:
            ret

RoomDraw:
			; clear the screen
			lxi d, $0000
			lxi b, $8000 / 32 - 1
			xra a
			call ClearMemSP
			; TODO: make the code below work to use __ClearMemSP instead of ClearMemSP
			; lxi d, $0000
			; lxi b, $8000 / 128
			;CALL_RAM_DISK_FUNC(__ClearMemSP, RAM_DISK0_B2_8AF_RAM)

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

			; x = x + 2
			inr d
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
			.closelabels

; TODO: optimize. do not check if the hero still inside the same tiles
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
			; use the char posY
			mov a, c
			ani %11110000
			mov c, a

			; use the char posX
			mov a, b
			rrc_(4)
			ana d
			add c

			mov c, a
			mvi b, 0
			lxi h, roomTilesData
			dad b
			; get data of a tile where a top-left pixel of a sprite drawn
			mov e, m
			; get data of a tile where a top-right pixel of a sprite drawn
			inx h
@checkRightUpTile:
			mov d, m
			xchg
			shld collidedRoomTilesData
			mov a, l
			ora h
@checkBottomTiles:			
			xchg
			; get data of a tile where a bottom-left pixel of a sprite drawn
			mvi c, ROOM_WIDTH-1
			dad b
			mov e, m
			ora e
			; get data of a tile where a bottom-right pixel of a sprite drawn
			inx h
@checkRightBottomTile:
			mov d, m
			ora d
			xchg
			shld collidedRoomTilesData+2
			ret
			.closelabels