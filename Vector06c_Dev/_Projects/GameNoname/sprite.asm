; get a sprite data addr
; in:
; hl - animPtr
; c - preshifted sprite idx*2 offset based on posX then +2
; out:
; bc - ptr to a sprite
GetSpriteAddr:
			mvi b, 0
			dad b
			mov c, m
			inx h
			mov b, m
			ret
			.closelabels

; in:
; hl - ptr to posX+1 (high byte in 16-bit pos)
; out:
; de - sprite screen addr
; c - preshifted sprite idx*2 offset based on posX then +2
; hl - ptr to posY+1
; use: a
GetSpriteScrAddr8:
			; calc screen addr X
			mov	a, m
			ani PRESHIFTED_SPRITES_8 - 1
			rlc
			adi 2 ; because there are two bytes of nextFrameOffset in front of sprite ptrs
			mov	c, a
			mov	a, m
			rrc_(3)
			ani		%00011111
			adi		SPRITE_X_SCR_ADDR
			inx h
			inx h
			; de - sprite screen addr
			mov e, m
			mov	d, a
			ret
			.closelabels
GetSpriteScrAddr4:
			; calc screen addr X
			mov	a, m
			ani (PRESHIFTED_SPRITES_4 - 1) * 2
			adi 2 ; because there are two bytes of nextFrameOffset in front of sprite ptrs
			mov	c, a
			mov	a, m
			rrc_(3)
			ani		%00011111
			adi		SPRITE_X_SCR_ADDR
			inx h
			inx h
			; de - sprite screen addr
			mov e, m
			mov	d, a
			ret
			.closelabels

; copy a sprite from the back buff to the screen
; in:
; de - scr addr
; b - width
;		00 - 8pxs,
;		01 - 16pxs,
;		10 - 24pxs,
;		11 - 32pxs
; c - height
COPY_SPRITE_W_MIN = %0
COPY_SPRITE_W_MAX = %11
COPY_SPRITE_H_MIN = 5
COPY_SPRITE_H_MAX = 20

CopySpriteToScrV:
			; store sp
			lxi h, 0
			dad	sp
			shld RestoreSP + 1

			; Y -= 1 because we start copying bytes with dec Y
			inr e
/*
			; w=max(h, COPY_SPRITE_H_MAX)
			mvi a, COPY_SPRITE_W_MAX
			cmp b
			jnc @skipMaxW
@maxW:
			mvi b, COPY_SPRITE_W_MAX
@skipMaxW:
*/
			; h=max(h, COPY_SPRITE_H_MAX)
			mov a, c
			cpi COPY_SPRITE_H_MAX
			jc @skipMaxH
@maxH:
			mvi a, COPY_SPRITE_H_MAX
@skipMaxH:

			; BC = an offset in the copy routine table
			rlc
			mov c, a
			mov a, b ; temp a = width
			mvi b, 0

			; hl - an addr of a copy routine
			lxi h, @copyRoutineAddrs - COPY_SPRITE_H_MIN * WORD_LEN
			dad b
			mov b, m
			inx h
			mov h, m
			mov l, b

			; run the copy routine
			pchl

@h05:		COPY_SPRITE_TO_SCR(5)
@h06:		COPY_SPRITE_TO_SCR(6)
@h07:		COPY_SPRITE_TO_SCR(7)
@h08:		COPY_SPRITE_TO_SCR(8)
@h09:		COPY_SPRITE_TO_SCR(9)
@h10:		COPY_SPRITE_TO_SCR(10)
@h11:		COPY_SPRITE_TO_SCR(11)
@h12:		COPY_SPRITE_TO_SCR(12)
@h13:		COPY_SPRITE_TO_SCR(13)
@h14:		COPY_SPRITE_TO_SCR(14)
@h15:		COPY_SPRITE_TO_SCR(15)
@h16:		COPY_SPRITE_TO_SCR(16)
@h17:		COPY_SPRITE_TO_SCR(17)
@h18:		COPY_SPRITE_TO_SCR(18)
@h19:		COPY_SPRITE_TO_SCR(19)
@h20:		COPY_SPRITE_TO_SCR(20)

@copyRoutineAddrs:
			.word @h05
			.word @h06
			.word @h07
			.word @h08
			.word @h09
			.word @h10
			.word @h11
			.word @h12
			.word @h13
			.word @h14
			.word @h15
			.word @h16
			.word @h17
			.word @h18
			.word @h19
			.word @h20		

.macro COPY_SPRITE_TO_SCR_PB(moveUp = true)
			pop b
			mov m, c
			inr l
			mov m, b
		.if moveUp == true
			inr l
		.endif
.endmacro
.macro COPY_SPRITE_TO_SCR_B()
			pop b
			mov m, c
.endmacro

.macro COPY_SPRITE_TO_SCR_LOOP(height, heightOdd)
	.if heightOdd
		.loop height / 2 - 1
			COPY_SPRITE_TO_SCR_PB()
		.endloop
			COPY_SPRITE_TO_SCR_B()
	.endif
	.if heightOdd == false
		.loop height / 2 - 2
			COPY_SPRITE_TO_SCR_PB()
		.endloop
			COPY_SPRITE_TO_SCR_PB(false)
	.endif			
.endmacro

.macro COPY_SPRITE_TO_SCR(height)
			heightOdd = (height / 2)*2 != height
			; hl - scr addr
			xchg
			; d - width
			mov d, a			
			; to restore X
			mov e, h

@nextColumn:
			RAM_DISK_ON(RAM_DISK_S2 | RAM_DISK_M2 | RAM_DISK_M_8F)
			; read without a stack operations because
			; we need fill up BC prior to use POP B
			mov b, m
			dcr l
			mov c, m
			RAM_DISK_ON(RAM_DISK_S2)

			mov m, c
			inr l
			mov m, b
			inr l
			sphl

			COPY_SPRITE_TO_SCR_LOOP(height, heightOdd)

			; advance Y to the bottom of the sprite, X to the next scr buff
	.if heightOdd
			lxi h, $2000-height+2-1-1
	.endif
	.if heightOdd == false
			lxi h, $2000-height+2-1
	.endif
			dad sp

			jnc @nextColumn
			; advance Y to the next column
			inr e
			mov h, e
			dcr d
			jp @nextColumn
			jmp RestoreSP
.endmacro

; copy a sprite from backbuff1 to backbuff2
; in:
; de - scr addr
; h - width
;		00 - 8pxs,
;		01 - 16pxs,
;		10 - 24pxs,
;		11 - 32pxs
; l - height

CopySpriteToScrV2:
			; Y -= 1 because we start copying bytes with dec Y
			inr e

			; h=min(h, COPY_SPRITE_H_MAX)
			mov a, l
			cpi COPY_SPRITE_H_MAX
			jc @doNotSetMin
@setMin:
			mvi a, COPY_SPRITE_H_MAX
@doNotSetMin:

			; BC = an offset in the copy routine table
			rlc
			mov c, a
			mvi b, 0
			; temp a = width
			mov a, h

			; store sp
			lxi h, 0
			dad	sp
			shld RestoreSP + 1

			; hl - an addr of a copy routine
			lxi h, @copyRoutineAddrs - COPY_SPRITE_H_MIN * WORD_LEN
			dad b
			mov b, m
			inx h
			mov h, m
			mov l, b

			; run the copy routine
			pchl

@h05:		COPY_SPRITE_TO_SCR2(5)
@h06:		COPY_SPRITE_TO_SCR2(6)
@h07:		COPY_SPRITE_TO_SCR2(7)
@h08:		COPY_SPRITE_TO_SCR2(8)
@h09:		COPY_SPRITE_TO_SCR2(9)
@h10:		COPY_SPRITE_TO_SCR2(10)
@h11:		COPY_SPRITE_TO_SCR2(11)
@h12:		COPY_SPRITE_TO_SCR2(12)
@h13:		COPY_SPRITE_TO_SCR2(13)
@h14:		COPY_SPRITE_TO_SCR2(14)
@h15:		COPY_SPRITE_TO_SCR2(15)
@h16:		COPY_SPRITE_TO_SCR2(16)
@h17:		COPY_SPRITE_TO_SCR2(17)
@h18:		COPY_SPRITE_TO_SCR2(18)
@h19:		COPY_SPRITE_TO_SCR2(19)
@h20:		COPY_SPRITE_TO_SCR2(20)

@copyRoutineAddrs:
			.word @h05
			.word @h06
			.word @h07
			.word @h08
			.word @h09
			.word @h10
			.word @h11
			.word @h12
			.word @h13
			.word @h14
			.word @h15
			.word @h16
			.word @h17
			.word @h18
			.word @h19
			.word @h20		

.macro COPY_SPRITE_TO_SCR_PB2(moveUp = true)
			pop b
			mov m, c
			inr l
			mov m, b
		.if moveUp == true
			inr l
		.endif
.endmacro
.macro COPY_SPRITE_TO_SCR_B2()
			pop b
			mov m, c
.endmacro

.macro COPY_SPRITE_TO_SCR_LOOP2(height)
			heightOdd = (height / 2)*2 != height

	.if heightOdd
		.loop height / 2 - 1
			COPY_SPRITE_TO_SCR_PB()
		.endloop
			COPY_SPRITE_TO_SCR_B()
	.endif
	.if heightOdd == false
		.loop height / 2 - 2
			COPY_SPRITE_TO_SCR_PB()
		.endloop
			COPY_SPRITE_TO_SCR_PB(false)
	.endif			
.endmacro

.macro COPY_SPRITE_TO_SCR2(height)
			; hl - scr addr
			xchg
			; d - width
			mov d, a
@nextColumn:
			RAM_DISK_ON(RAM_DISK_S3 | RAM_DISK_M2 | RAM_DISK_M_8F)
			; read without a stack operations because
			; we need fill up BC prior to use POP B
			mov b, m
			dcr l
			mov c, m
			RAM_DISK_ON(RAM_DISK_S3 | RAM_DISK_M2 | RAM_DISK_M_8F)

			mov m, c
			inr l
			mov m, b
			inr l
			sphl

			COPY_SPRITE_TO_SCR_LOOP2(height)

			; assign SP to prevent screen data corruption
			; when we use mov b, m and mov c, m commands.
			; a corruption might happen because we fill up B and C with
			; more than one command (mov b,m/mov c,m)
			lxi sp, STACK_INTERRUPTION_ADDR
			; advance Y down and to the next scr buff
			lxi b, $2000-height+2
			dad b

			jnc @nextColumn
			; advance Y to the next column
			mvi a, -$20*3+1
			add h
			mov h, a
			dcr d
			jp @nextColumn
			jmp RestoreSP
.endmacro

