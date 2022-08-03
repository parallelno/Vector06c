.include "skeleton.asm"
; max monsters amount in the room
monstersMax = 3
monstersUpdateFunc:
            .loop monstersMax
			.word SkeletonUpdate
			.endloop
monstersDrawFunc:
            .loop monstersMax
			.word SkeletonDraw
			.endloop

monsterRoomDataSize = 13
monsterRoomDataAddrOffset .var 0
monsterRoomDataAddrOffsets:
            .loop monstersMax
            .byte monsterRoomDataAddrOffset
			monsterRoomDataAddrOffset = monsterRoomDataAddrOffset + monsterRoomDataSize
			.endloop

monsterInitPosX			.var 120
monsterInitPosXOffset	.var 24

monstersRoomData:
monsterDirX:			.byte 1 ; 1-right, 0-left
monsterRedrawTimer:		.byte 1 ; 0101_0101 means redraw on every second frame, 0000_0001 means redraw on very 8 frame.
monsterCleanScrAddr:	.word (SPRITE_X_SCR_ADDR + HERO_START_POS_X / 8 - 1) * 256 + HERO_START_POS_Y
monsterCleanFrameIdx2:	.byte 0 ; frame id * 2
monsterPosX:			.word monsterInitPosX * 256 + 0
monsterPosY:			.word 160 * 256 + 0
monsterSpeedX:			.word 0
monsterSpeedY:			.word 0
; the same sprite data dupped 4 times.

.loop monstersMax - 1
    monsterInitPosX = monsterInitPosX + monsterInitPosXOffset
	.byte 1
	.byte 1	
	.word (SPRITE_X_SCR_ADDR + HERO_START_POS_X / 8 ) * 256 + HERO_START_POS_Y
	.byte 0
	.word monsterInitPosX * 256 + 0
	.word 160 * 256 + 0
	.word 0
	.word 0	
.endloop

MonstersDraw:
			lxi h, monstersDrawFunc + (monstersMax-1) * 2 + 1
			lxi b, monstersMax-1 ; b=0 needs in the monsterDraw func
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
			
