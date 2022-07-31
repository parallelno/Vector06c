.include "drawSprite.asm"
; data
.include "chars/hero.dasm"

; the first screen buffer X
HERO_X_SCR_ADDR	= $a0
HERO_START_POS_X = 100
HERO_START_POS_Y = 170
HERO_RUN_SPEED = $0100 ; it's a dword, low byte is a subpixel speed

ROT_TIMER_0p125 = %0000_0001 ; that timer is rotated to the right.
ROT_TIMER_0p25	= %0001_0001 ; it will trigger something when the lowest bit is 1
ROT_TIMER_0p5	= %0101_0101 ; this value means that something will happen every second frame
ROT_TIMER_0p75	= %1101_1101
ROT_TIMER_1p0	= %1111_1111
;ROT_TIMER_ONCE	= %0000_0011 ; draw just once. useful for idle anims
;ROT_TIMER_NOP	= %0000_0000 ; no draw

; save heroX, heroY, heroSpeedX, heroSpeedY data layout because it is a struct
heroX:				.word HERO_START_POS_X * 256 + 0
heroY:				.word HERO_START_POS_Y * 256 + 0
heroSpeedX:			.word 0
heroSpeedY:			.word 0
heroTempX:			.word 0 ; temporal X
heroTempY:			.word 0 ; temporal Y

heroDirX:			.byte 1 ; 1-right, 0-left
heroCleanScrAddr:	.word (HERO_X_SCR_ADDR + HERO_START_POS_X / 8) * 256 + HERO_START_POS_Y
heroCleanFrameIdx2:	.byte 0 ; frame id * 2
heroRedrawTimer:	.byte 0 ; 0101_0101 means redraw on every second frame, 0000_0001 means redraw on very 8 frame.

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

			lxi h, GetHeroSpriteAddr
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
			lxi h, GetHeroSpriteAddr
			lxi h, hero_run_r0
			shld HeroDrawAnimAddr+1
			lxi h, GetHeroSpriteAddr
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
			lxi h, GetHeroSpriteAddr
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

			lxi h, GetHeroRunVSpriteAddr
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

			lxi h, GetHeroRunVSpriteAddr
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
			shld heroTempX
			lhld heroY
			xchg
			lhld heroSpeedY
			dad d
			mov c, h
			shld heroTempY
			; check collided tiles data
			call CheckTilesCollision
			; check if any tiles collide
			ora a
			jnz @collides
			lhld heroTempX
			shld heroX
			lhld heroTempY
			shld heroY
			ret
@collides:
			; handle collided tiles data
			cpi $ff
			rz
			; extract function
			lxi h, roomIdx
			inr m
			call RoomInit
			call RoomDraw
			xra a
			lda	interruptionCounter
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

			call GetHeroScrAddr
			mov a, c
			shld heroCleanScrAddr
			sta heroCleanFrameIdx2
			xchg
HeroDrawAnimAddr:
			lxi h, hero_idle_r
HeroDrawSpriteAddrFunc:			
			call GetHeroSpriteAddr

			ora a
			jz DrawSprite16x15
			jmp	DrawSprite24x15

GetHeroSpriteAddr:
			mvi b, 0
			dad b
			mov c, m
			inx h
			mov b, m
			ret

GetHeroRunVSpriteAddr:
			mov a, e
			ani	%0000011
			rlc
			rlc
			rlc
			add c
			mov c, a
			mvi b, 0
			dad b
			mov c, m
			inx h
			mov b, m
			ani %110
			ret	

GetHeroScrAddr:
			; convert XY to screen addr + frame idx
			lxi h, heroX+1
			mov		a, m
			; extract the anim frame idx
			ani		%0000110
			mov 	c, a
			; extract the hero X screen addr
			mov		a, m
			rrc
			rrc
			rrc
			ani		%00011111
			adi		HERO_X_SCR_ADDR
			inx h
			inx h
			mov l, m
			mov	h, a
			ret