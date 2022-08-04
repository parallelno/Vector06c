.include "skeleton.asm"
; max monsters amount in the room
MONSTERS_MAX = 5
monstersUpdateFunc:
	.loop MONSTERS_MAX
		.word SkeletonUpdate
	.endloop

EVERY_NEXT_MONSTER	.var 1

monstersDrawFunc:
	.loop MONSTERS_MAX
		.if EVERY_NEXT_MONSTER==1
			.word SkeletonDraw
		.endif
		.if EVERY_NEXT_MONSTER==0
			.word 0
		.endif
		EVERY_NEXT_MONSTER = 1 - EVERY_NEXT_MONSTER
	.endloop

MONSTER_ROOM_DATA_SIZE = 13
MONSTER_ROOM_DATA_ARRD_OFFSET .var 0
monsterRoomDataAddrOffsets:
	.loop MONSTERS_MAX
		.byte MONSTER_ROOM_DATA_ARRD_OFFSET
		MONSTER_ROOM_DATA_ARRD_OFFSET = MONSTER_ROOM_DATA_ARRD_OFFSET + MONSTER_ROOM_DATA_SIZE
	.endloop

MONSTER_INIT_POS_X			.var 120
MONSTER_INIT_POS_X_OFFSET	.var 24

; this's a struc. do not change the layout
monstersRoomData:
monsterDirX:			.byte 1 ; 1-right, 0-left
monsterRedrawTimer:		.byte 1 ; 0101_0101 means redraw on every second frame, 0000_0001 means redraw on very 8 frame.
monsterCleanScrAddr:	.word (SPRITE_X_SCR_ADDR + HERO_START_POS_X / 8 - 1) * 256 + HERO_START_POS_Y
monsterCleanFrameIdx2:	.byte 0 ; frame id * 2
monsterPosX:			.word MONSTER_INIT_POS_X * 256 + 0
monsterPosY:			.word 160 * 256 + 0
monsterSpeedX:			.word 0
monsterSpeedY:			.word 0
; the same sprite data dupped 4 times.

MONSTER_REDRAW_TIMER_V	.var 1

.loop MONSTERS_MAX - 1
	MONSTER_INIT_POS_X = MONSTER_INIT_POS_X + MONSTER_INIT_POS_X_OFFSET
	MONSTER_REDRAW_TIMER_V = MONSTER_REDRAW_TIMER_V * 2
	.byte 1
	.byte MONSTER_REDRAW_TIMER_V
	.word (SPRITE_X_SCR_ADDR + HERO_START_POS_X / 8 ) * 256 + HERO_START_POS_Y
	.byte 0
	.word MONSTER_INIT_POS_X * 256 + 0
	.word 160 * 256 + 0
	.word 0
	.word 0
.endloop

MonstersDraw:
			lxi h, monstersDrawFunc + (MONSTERS_MAX-1) * 2 + 1
			lxi b, MONSTERS_MAX-1 ; b=0 needs in the monsterDraw func
@loop:
			mov d, m
			dcx h
			mov e, m
			dcx h
			xra A
			ora d
			jz @skip
			push h
			push b
			xchg
			lxi d, @funcReturnAddr
			push d
			pchl ; call a monsterDraw func
@funcReturnAddr:
			pop b
			pop h
@skip:
			dcr c
			jp @loop
			ret
			.closelabels
			
MonstersSpawn:
			ret