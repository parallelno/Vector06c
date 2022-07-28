.include "drawSprite2.asm"
; data
.include "chars/hero.dasm"

; the first screen buffer X
HERO_X_SCR_ADDR	= $a0
HERO_START_POS_X = 40
HERO_START_POS_Y = 170
HERO_RUN_SPEED = 1 * 256

ROT_TIMER_0p125 = %0000_0001 ; that timer is rotated to the right.
ROT_TIMER_0p25	= %0001_0001 ; it will trigger something when the lowest bit is 1
ROT_TIMER_0p5	= %0101_0101 ; this value means that something will happen every second frame
ROT_TIMER_0p75	= %1101_1101
ROT_TIMER_1p0	= %1111_1111
;ROT_TIMER_ONCE	= %0000_0011 ; draw just once. useful for idle anims
;ROT_TIMER_NOP	= %0000_0000 ; no draw

; save heroY and heroX data layout because heroXY can be read as a double word
heroX:				.word HERO_START_POS_X * 256 + 0
heroY:				.word HERO_START_POS_Y * 256 + 0

heroSpeedX:			.word 0
heroSpeedY:			.word 0

heroDirX:			.byte 1 ; 1-right, 0-left
heroCleanScrAddr:	.word (HERO_X_SCR_ADDR + HERO_START_POS_X / 8) * 256 + HERO_START_POS_Y
heroCleanFrameIdx2:	.byte 0 ; frame id * 2
heroRedrawTimer:	.byte 0 ; 0101_0101 means redraw on every second frame, 0000_0001 means redraw on very 8 frame.

			.macro CHECK_HERO_REDRAW(timer)
			lhld keyCode
			mov a, l
			cmp h
			jz MoveHero
			mvi a, timer
			sta heroRedrawTimer
			.endmacro
			
UpdateHero:
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
			shld DrawHeroSpriteAddrFunc+1

			lda heroDirX
			ora a
			jz @setAnimIdleL

			lxi h, hero_idle_r
			shld DrawHeroAnimAddr+1
			jmp MoveHero
@setAnimIdleL
			lxi h, hero_idle_l
			shld DrawHeroAnimAddr+1
			jmp MoveHero

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
			shld DrawHeroAnimAddr+1
			lxi h, GetHeroSpriteAddr
			shld DrawHeroSpriteAddrFunc+1
			jmp MoveHero
@setAnimRunL:
			cpi KEY_LEFT
			jnz @setAnimRunU

			CHECK_HERO_REDRAW(ROT_TIMER_0p5)

			lxi h, ~HERO_RUN_SPEED
			shld heroSpeedX
			lxi h, 0
			shld heroSpeedY

			xra a
			sta heroDirX
			lxi h, hero_run_l0
			shld DrawHeroAnimAddr+1
			lxi h, GetHeroSpriteAddr
			shld DrawHeroSpriteAddrFunc+1	
			jmp MoveHero
@setAnimRunU:
			cpi KEY_UP
			jnz @setAnimRunD

			CHECK_HERO_REDRAW(ROT_TIMER_0p5)

			lxi h, 0
			shld heroSpeedX
			lxi h, HERO_RUN_SPEED
			shld heroSpeedY

			lxi h, GetHeroRunVSpriteAddr
			shld DrawHeroSpriteAddrFunc+1

			lda heroDirX
			ora a
			jz @setAnimRunUL

			lxi h, hero_run_r0
			shld DrawHeroAnimAddr+1
			jmp MoveHero
@setAnimRunUL:
			lxi h, hero_run_l0
			shld DrawHeroAnimAddr+1
			jmp MoveHero
@setAnimRunD:
			cpi KEY_DOWN
			rnz

			CHECK_HERO_REDRAW(ROT_TIMER_0p5)

			lxi h, 0
			shld heroSpeedX
			lxi h, ~HERO_RUN_SPEED
			shld heroSpeedY		

			lxi h, GetHeroRunVSpriteAddr
			shld DrawHeroSpriteAddrFunc+1
			
			lda heroDirX
			ora a
			jz @setAnimRunDL
			lxi h, hero_run_r0
			shld DrawHeroAnimAddr+1		
			jmp MoveHero
@setAnimRunDL:
			lxi h, hero_run_l0
			shld DrawHeroAnimAddr+1
			jmp MoveHero

MoveHero:
			lhld heroX
			xchg
			lhld heroSpeedX
			dad d
			shld heroX

			lhld heroY
			xchg
			lhld heroSpeedY
			dad d
			shld heroY
			ret
			.closelabels


DrawHero:	
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
DrawHeroAnimAddr:
			lxi h, hero_idle_r
DrawHeroSpriteAddrFunc:			
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