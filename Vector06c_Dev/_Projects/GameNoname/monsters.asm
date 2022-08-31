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

MONSTERS_FUNCS_NO_PARAM = $ff

.macro MONSTERS_FUNCS_HANDLER(funcs, flag, noRet = false)
			lxi h, funcs + (MONSTERS_MAX-1) * 2 + 1
			; bc - monster idx, used in a func
			lxi b, MONSTERS_MAX-1
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
		.if flag != MONSTERS_FUNCS_NO_PARAM
			mvi a, flag
		.endif
			pchl ; call a monster update func
@funcReturnAddr:
			pop b
			pop h
@skip:
			dcr c
			jp @loop
		.if noRet == false
			ret
		.endif
			.closelabels
.endfunction

MonstersInit:
            MONSTERS_FUNCS_HANDLER(monstersInitFunc, MONSTERS_FUNCS_NO_PARAM)

MonstersUpdate:
            MONSTERS_FUNCS_HANDLER(monstersUpdateFunc, MONSTERS_FUNCS_NO_PARAM)

; think of reusing this func as a macro to replace MONSTERS_FUNCS_HANDLER in the monstersDraw func
; in:
; a - flag
;	flag=OPCODE_JC to draw a sprite with Y>MONSTER_DRAW_Y_THRESHOLD, 
;	flag=OPCODE_JNC to draw a sprite with Y<=MONSTER_DRAW_Y_THRESHOLD, 
MonstersClear:
			sta @checkY
			lxi h, monsterRedrawTimer
			mvi c, MONSTERS_MAX
@loop:
			mov a, m
			inx h			
			rrc
			jnc @skip

			; de <- (monsterCleanScrAddr)
			mov e, m

			; to support two-interations rendering
			mvi a, MONSTER_DRAW_Y_THRESHOLD
			cmp e
@checkY
			; replaced with jnc to erase sprites above MONSTER_DRAW_Y_THRESHOLD
			; replaced with jc to erase sprites below MONSTER_DRAW_Y_THRESHOLD
			jnc @skip

			inx h
			mov d, m

			; a <- (monsterCleanFrameIdx2)
			inx h
			mov a, m
			
			push h
			push b

			; get anim addr
			lxi b, $ffff-5+1
			dad b

			
			; c = monsterCleanFrameIdx2
			mov c, a

			mov a, m
			inx h
			mov h, m
			mov l, a
			call GetSpriteAddrRunV
			call EraseSpriteV

			pop b
			pop h
			lxi d, MONSTERS_ROOM_SPRITE_DATA_LEN-3
			jmp @next
@skip:
			lxi d, MONSTERS_ROOM_SPRITE_DATA_LEN-1
@next:
			dad d
			dcr c
			jnz @loop
			ret
			.closelabels

MONSTERS_DRAW_TOP = OPCODE_RNC
MONSTERS_DRAW_BOTTOM = OPCODE_RC
NO_RET = true
MonstersDrawBottom:
			mvi a, OPCODE_JC
			call MonstersClear
			MONSTERS_FUNCS_HANDLER(monstersDrawFunc, MONSTERS_DRAW_BOTTOM)

MonstersDrawTop:			
			mvi a, OPCODE_JNC
			call MonstersClear						
			MONSTERS_FUNCS_HANDLER(monstersDrawFunc, MONSTERS_DRAW_TOP, NO_RET)

@MonstersRedrawTimerUpdate:
			lxi h, monsterRedrawTimer
			lxi d, MONSTERS_ROOM_SPRITE_DATA_LEN	
			mvi c, MONSTERS_MAX
@loop:
			mov a, m
			rrc
			mov m, a
			dad d
			dcr c
			jnz @loop
			ret
