.include "drawSprite2.asm"
; data
.include "chars/hero.dasm"

; the first screen buffer X
HERO_START_POS_X = 160
HERO_START_POS_Y = 190
HERO_RUN_SPEED = $0100 ; it's a dword, low byte is a subpixel speed

; save heroX, heroY, heroSpeedX, heroSpeedY data layout because it is a struct
heroX:				.word HERO_START_POS_X * 256 + 0
heroY:				.word HERO_START_POS_Y * 256 + 0
heroSpeedX:			.word 0
heroSpeedY:			.word 0

heroDirX:			.byte 1 ; 1-right, 0-left
heroCleanScrAddr:	.word (SPRITE_X_SCR_ADDR + HERO_START_POS_X / 8) * 256 + HERO_START_POS_Y
heroCleanFrameIdx2:	.byte 0 ; frame id * 2
heroRedrawTimer:	.byte 0 ; 0101_0101 means redraw on every second frame, 0000_0001 means redraw on very 8 frame.

heroFuncTable:		.word 0, 0, 0, HeroMoveTeleport, 0, 0, 0, 0 ; hero uses these funcs to handle the tile data. more info is in levelGlobalData.dasm->roomTilesData 


HeroInit:
			lxi h, heroX+1
			call GetSpriteScrAddr
			;xchg
			mov a, c
			shld heroCleanScrAddr
			sta heroCleanFrameIdx2
			ret
			.closelabels
HeroStop:
			lxi h, 0
			shld heroSpeedX	
			shld heroSpeedY
			shld keyCode
			ret
			.closelabels

; hl - posXY
HeroSetPos:
			mov a, h
			sta heroX+1
			mov a, l
			sta heroY+1
			ret
			.closelabels

			.macro CHECK_HERO_REDRAW(timer)
			lxi h, keyCode+1
			cmp m
			jz HeroMove
			mvi a, timer
			sta heroRedrawTimer
			.endmacro		
			
HeroUpdate:
			lda keyCode

			; if no key pressed, play idle
			cpi $ff
			jnz @setAnimRunR
			
			; if it's the same key as the prev frame, return
			CHECK_HERO_REDRAW(ROT_TIMER_0p125)

			lxi h, 0
			shld heroSpeedX
			shld heroSpeedY

			lxi h, GetSpriteAddr
			shld HeroDrawSpriteAddrFunc+1

			lda heroDirX
			ora a
			jz @setAnimIdleL

			lxi h, hero_idle_r
			shld HeroDrawAnimAddr+1
			jmp HeroMove
@setAnimIdleL
			lxi h, hero_idle_l
			shld HeroDrawAnimAddr+1
			jmp HeroMove

@setAnimRunR:
			cpi KEY_RIGHT
			jnz @setAnimRunL
			
			CHECK_HERO_REDRAW(ROT_TIMER_0p5)

			lxi h, HERO_RUN_SPEED
			shld heroSpeedX
			lxi h, 0
			shld heroSpeedY

			mvi a, 1
			sta heroDirX
			lxi h, hero_run_r0
			shld HeroDrawAnimAddr+1
			lxi h, GetSpriteAddr
			shld HeroDrawSpriteAddrFunc+1
			jmp HeroMove
@setAnimRunL:
			cpi KEY_LEFT
			jnz @setAnimRunU

			CHECK_HERO_REDRAW(ROT_TIMER_0p5)

			lxi h, $ffff - HERO_RUN_SPEED + 1
			shld heroSpeedX
			lxi h, 0
			shld heroSpeedY

			xra a
			sta heroDirX
			lxi h, hero_run_l0
			shld HeroDrawAnimAddr+1
			lxi h, GetSpriteAddr
			shld HeroDrawSpriteAddrFunc+1	
			jmp HeroMove
@setAnimRunU:
			cpi KEY_UP
			jnz @setAnimRunD

			CHECK_HERO_REDRAW(ROT_TIMER_0p5)

			lxi h, 0
			shld heroSpeedX
			lxi h, HERO_RUN_SPEED
			shld heroSpeedY

			lxi h, GetSpriteAddrRunV
			shld HeroDrawSpriteAddrFunc+1

			lda heroDirX
			ora a
			jz @setAnimRunUL

			lxi h, hero_run_r0
			shld HeroDrawAnimAddr+1
			jmp HeroMove
@setAnimRunUL:
			lxi h, hero_run_l0
			shld HeroDrawAnimAddr+1
			jmp HeroMove
@setAnimRunD:
			cpi KEY_DOWN
			rnz

			CHECK_HERO_REDRAW(ROT_TIMER_0p5)

			lxi h, 0
			shld heroSpeedX
			lxi h, $ffff - HERO_RUN_SPEED + 1
			shld heroSpeedY		

			lxi h, GetSpriteAddrRunV
			shld HeroDrawSpriteAddrFunc+1
			
			lda heroDirX
			ora a
			jz @setAnimRunDL
			lxi h, hero_run_r0
			shld HeroDrawAnimAddr+1		
			jmp HeroMove
@setAnimRunDL:
			lxi h, hero_run_l0
			shld HeroDrawAnimAddr+1
			jmp HeroMove

HeroMove:
			; apply the hero speed
			lhld heroX
			xchg
			lhld heroSpeedX
			dad d
			mov b, h
			shld charTempX
			lhld heroY
			xchg
			lhld heroSpeedY
			dad d
			mov c, h
			shld charTempY
			; check collided tiles data
			call CheckTilesCollision
			; check if any tiles collide
			
			cpi $ff
			rz ; return if any of the tiles were collision
			ora a ; if all the tiles data == 0, means no collision.
			jnz @collides
@updatePos:			
			lhld charTempX
			shld heroX
			lhld charTempY
			shld heroY
			ret
@collides:
			; handle collided tiles data
			lxi h, collidedTilesData
			mvi c, 4
HeroMoveLoop:
			mov a, m
			push h	
			; extract a function
			ani %00000111
			jz HeroMoveFuncRet
			dcr a ; we do not need to handle funcId == 0
			rlc
			mov e, a
			mvi d, 0
			; extract a func argument
			mov a, m
			rrc_(3)
			ani %00011111

			lxi h, heroFuncTable
			dad d
			mov e, m
			inx h
			mov d, m
			xchg
			pchl
HeroMoveFuncRet:
			pop h
			inx h
			dcr c
			jnz HeroMoveLoop
			ret
			.closelabels

; a - roomId
HeroMoveTeleport:
			pop h
			; update a room id to teleport there
			sta roomIdx
			; is the teleport of the left or right side?
			lda heroX+1
			cpi (ROOM_WIDTH - 2 ) * TILE_WIDTH
			jnc @teleportLR
			cpi TILE_WIDTH + 2
			jc @teleportLR
			; is the teleport of the top or bottom side?
			mvi c, 2
			lda heroY+1
			cpi (ROOM_HEIGHT - 2 ) * TILE_WIDTH
			jnc @teleportB
			cpi TILE_HEIGHT * 2 + 2
			jc @teleportT
			jmp @donotMoveHero

@teleportLR
			; if the hero is on the right, move him to the left and vice versa
			lda heroX+1
			cma
			sui 14
			sta heroX+1
			jmp @donotMoveHero

			; if the hero is on the top, move him down vice versa
@teleportB:
			mvi c, 0
@teleportT:
			lda heroY+1
			cma
			sub c
			sta heroY+1
			jmp @donotMoveHero	

@donotMoveHero
			mvi a, LEVEL_COMMAND_LOAD_DRAW_ROOM
			sta levelCommand
			ret
			.closelabels

HeroDraw:	
			lxi h, heroRedrawTimer
			mov a, m
			rrc
			mov m, a
			rnc

			lhld heroCleanScrAddr
			lda heroCleanFrameIdx2
			call CleanSprite

			lxi h, heroX+1
			call GetSpriteScrAddr
			;xchg
			mov a, c
			shld heroCleanScrAddr
			sta heroCleanFrameIdx2
			xchg
HeroDrawAnimAddr:
			lxi h, hero_idle_r
HeroDrawSpriteAddrFunc:			
			call GetSpriteAddr

			ora a
			jz DrawSprite16x15
			jmp	DrawSprite24x15