.include "skeleton.asm"

; max monsters amount in the room
MONSTERS_MAX = 10

; all different monsters update and draw funcs has to be listed here for a room tile data init
monstersFuncs:
            .word SkeletonInit
			.word SkeletonUpdate
			.word SkeletonDraw
		.loop MONSTERS_MAX-1
			.word 0, 0
		.endloop

; offsets of the room sprite data in the 
MONSTERS_ROOM_SPRITE_DATA_LEN = 17
MONSTERS_ROOM_DATA_ADDR_OFFSET .var 0
monsterRoomDataAddrOffsets:
	.loop MONSTERS_MAX
		.byte MONSTERS_ROOM_DATA_ADDR_OFFSET
		MONSTERS_ROOM_DATA_ADDR_OFFSET = MONSTERS_ROOM_DATA_ADDR_OFFSET + MONSTERS_ROOM_SPRITE_DATA_LEN
	.endloop

; the data below gets updated every room init
;============================================================================================================
monstersRoomData:

MONSTERS_INIT_FUNC_LEN = WORD_LEN
MONSTERS_UPDATE_FUNC_LEN = WORD_LEN
MONSTERS_DRAW_FUNC_LEN = WORD_LEN
MONSTERS_ROOM_DATA_LEN = (MONSTERS_INIT_FUNC_LEN + MONSTERS_UPDATE_FUNC_LEN + MONSTERS_DRAW_FUNC_LEN + MONSTERS_ROOM_SPRITE_DATA_LEN) * MONSTERS_MAX

; monster init funcs in the current room
monstersInitFunc:
		.loop MONSTERS_MAX
			.word 0
		.endloop

; monster update funcs in the current room
monstersUpdateFunc:
		.loop MONSTERS_MAX
			.word 0
		.endloop

; monster draw funcs in the current room
monstersDrawFunc:
	.loop MONSTERS_MAX
			.word 0
	.endloop

; sprite data structs of the current room. do not change its layout
monstersRoomSpriteData:

MONSTER_INIT_POS_X			.var 120
MONSTER_INIT_POS_X_OFFSET	.var 24
; sprite data struc start.
monsterDirX:			.byte 1 ; 1-right, 0-left
monsterState:           .byte 0 ; 0 - idle
monsterStateCounter:    .byte 40
monsterAnimAddr:        .word 0
monsterRedrawTimer:		.byte 0 ; 0101_0101 means redraw on every second frame, 0000_0001 means redraw on very 8 frame.
monsterCleanScrAddr:	.word (SPRITE_X_SCR_ADDR + HERO_START_POS_X / 8 - 1) * 256 + HERO_START_POS_Y
monsterCleanFrameIdx2:	.byte 0 ; frame id * 2
monsterPosX:			.word MONSTER_INIT_POS_X * 256 + 0
monsterPosY:			.word 160 * 256 + 0
monsterSpeedX:			.word 0
monsterSpeedY:			.word 0
; sprite data struct end

; the same structs for the rest of the monsters in the current room
.loop MONSTERS_MAX - 1
	.byte 0
	.byte 0
	.byte 0
	.word 0
	.byte 0
	.word 0
	.byte 0
	.word 0
	.word 0
	.word 0
	.word 0
.endloop
;============================================================================================================
; end monstersRoomData

MonstersClearRoomData:
			lxi h, monstersRoomData
			lxi b, MONSTERS_ROOM_DATA_LEN
			call ClearMem
			ret
			.closelabels		

.macro MONSTERS_FUNCS_HANDLER(funcs)
			lxi h, funcs + (MONSTERS_MAX-1) * 2 + 1
			lxi b, MONSTERS_MAX-1 ; b=0 needs in the monsterDraw func
@loop:
			mov d, m
			dcx h
			mov e, m
			dcx h
			xra a
			ora d
			jz @skip
			push h
			push b
			xchg
			lxi d, @funcReturnAddr
			push d
			pchl ; call a monster update func
@funcReturnAddr:
			pop b
			pop h
@skip:
			dcr c
			jp @loop
			ret
			.closelabels
.endfunction

MonstersInit:
            MONSTERS_FUNCS_HANDLER(monstersInitFunc)

MonstersUpdate:
            MONSTERS_FUNCS_HANDLER(monstersUpdateFunc)

MonstersDraw:
            MONSTERS_FUNCS_HANDLER(monstersDrawFunc)
			