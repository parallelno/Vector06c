;================================================================
;	initialization levels data every game start
;
InitLevels:	
			xra a
			sta levelIdx
			ret

;================================================================
;	initialization level data every game start
;
InitLevel:
			hlt
			xra a
			sta roomIdx
			lxi		h, palette_sprites+15
            call	SetPalette
			mvi		a, 1
			sta borderColorIdx
			ret
			.closelabels

InitRoom:
			call InitRoomTiles
			ret
			
InitRoomTiles:
			lda roomIdx
			mov c, a
			mvi b, 0
			lxi h, roomsAddr
			dad b
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
			
@initRoomTilesLoop:
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
			jnz @initRoomTilesLoop
			ret
			.closelabels

DrawRoom:
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

			RET
			.closelabels