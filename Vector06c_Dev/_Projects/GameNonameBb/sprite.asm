.include "drawSprite.asm"

; input:
; hl - animation addr, for example hero_idle_r
; c - idx in the animation
; return:
; bc - sprite addr
; a - width marker. 0 - means a sprite width is 2 bytes , != 0 means 3 bytes
GetSpriteAddr:
			mov a, c
			mvi b, 0
			dad b
			mov c, m
			inx h
			mov b, m
			ret

; this's a special version of GetSpriteAddr for a vertical & horizontal movement.
; input:
; hl - animation addr, for example hero_idle_r
; c - idx in the animation
; e - pos Y
; return:
; bc - sprire addr
; a - width marker. 0 - means a sprite width is 2 bytes , != 0 means 3 bytes
GetSpriteAddrRunV:
			mov a, e
			ani	%0000011
			rlc_(3)
			add c
			mov c, a
			mvi b, 0
			dad b
			mov c, m
			inx h
			mov b, m
			ani %110
			ret

; input:
; hl - addr to posX+1 (high byte in 16-bit pos)
; return:
; de - sprite screen addr
; c - idx in the animaion
; use: a
GetSpriteScrAddr:
			; convert XY to screen addr + frame idx
			mov		a, m
			; extract the anim frame idx
			ani		%0000110
			mov 	c, a
			; extract the hero X screen addr
			mov		a, m
			rrc_(3)
			ani		%00011111
			adi		SPRITE_X_SCR_ADDR
			inx h
			inx h
			; copying posY
			mov e, m
			mov	d, a
			ret
			.closelabels

; clear a N*16 pxs square on the screen,
; it clears 3 screen buffers from de addr and further
; in:
; de - scr addr
; hl - width, height
;	width:
;		00 - 8pxs,
;		01 - 16pxs,
;		10 - 24pxs,
;		11 - 32pxs,
EraseSpriteSP2:
			mov b, h
			; adjust Y
			mov a, e
			add l
			; because push decrements SP before store RP
			inr a
			mov e, a

			lxi h, 0
			dad sp
			shld RestoreSP + 1
			RAM_DISK_ON(RAM_DISK0_B2_STACK_B2_AF_RAM)
			xchg

			mov a, b

			; (backbuff addr) = BC
			lxi b, 0
			; to move the next scr buff
			lxi d, $2000

			rrc
			jc @width16or32
			rrc
			jc @width24
			jnc @width8
@width16or32:
			rrc
			jnc @width16

@width32:
			EREASE_SPRITE_SP_COL()
@width24:
			EREASE_SPRITE_SP_COL()
@width16:
			EREASE_SPRITE_SP_COL()
@width8:
			EREASE_SPRITE_SP_COL(false)
			jmp RestoreSP
			.closelabels

.macro EREASE_SPRITE_SP_COL(nextColumn = true)
	col .var 0
	.loop 3
			col = col+1
			sphl
			PUSH_B(8)
		.if nextColumn == true || col < 3
			dad d
		.endif
	.endloop
		.if nextColumn == true
			; advance to the next column
			mvi a, $20*5+1
			add h
			mov h, a
		.endif
.endmacro
			.closelabels

; copy a sprite from the back buff to the screen
; in:
; de - scr addr
; h - width
;		00 - 8pxs,
;		01 - 16pxs,
;		10 - 24pxs,
;		11 - 32pxs
; l - height
CopySpriteToScrV2:
			; adjust initial Y
			inr e

			; set up a copy routine
			mov a, l
			rlc
			mov c, a
			mov a, h
			mvi b, 0

			; store sp
			lxi h, 0
			dad	sp
			shld RestoreSP + 1

			; continue setting up a copy routine
			lxi h, @copyRoutineAddrs-8
			dad b
			mov b, m
			inx h
			mov h, m
			mov l, b
			pchl

@h04:
@h05:		COPY_SPRITE_TO_SCR(5)
@h06:		COPY_SPRITE_TO_SCR(6)
@h07:		COPY_SPRITE_TO_SCR(7)
@h08:		COPY_SPRITE_TO_SCR(8)
@h09:
@h10:
@h11:
@h12:
@h13:		COPY_SPRITE_TO_SCR(13)
@h14:		COPY_SPRITE_TO_SCR(14)
@h15:		COPY_SPRITE_TO_SCR(15)
@h16:		COPY_SPRITE_TO_SCR(16)
@h17:		COPY_SPRITE_TO_SCR(17)
@h18:		COPY_SPRITE_TO_SCR(18)
@h19:		COPY_SPRITE_TO_SCR(19)
@h20:		COPY_SPRITE_TO_SCR(20)

@copyRoutineAddrs:
			.word @h04
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
			.word @h20
			.word @h20
			.word @h20

.macro COPY_SPRITE_TO_SCR_PB(secondByte = true)
			pop b
			mov m, c
		.if secondByte == true
			inr l
			mov m, b
			inr l
		.endif
.endmacro
.macro COPY_SPRITE_TO_SCR(height)
			xchg
			mov d, a
nextColumn:
			RAM_DISK_ON(RAM_DISK0_B2_STACK_B2_AF_RAM)
			; read without a stack operations because
			; we need fill up BC prior to use POP B
			mov b, m
			dcr l
			mov c, m
			RAM_DISK_ON(RAM_DISK0_B2_STACK)
			mov m, c
			inr l
			mov m, b
			inr l
			sphl
		.loop height / 2 - 1
			COPY_SPRITE_TO_SCR_PB()
		.endloop
		heightOdd = (height / 2)*2 != height
		.if heightOdd
			COPY_SPRITE_TO_SCR_PB(false)
		.endif

			; assign SP to prevent screen data corruption
			; when we use mov b, m and mov c, m commands.
			; a corruption might happen because we fill up B and C with
			; more than one command
			lxi sp, STACK_INTERRUPTION_ADDR
			; advance Y down and to the next scr buff
			lxi b, $2000-height+2
			dad b
			jnc nextColumn
			; advance Y to the next column
			mvi a, -$20*3+1
			add h
			mov h, a
			dcr d
			jp nextColumn
			jmp RestoreSP
.endmacro
			.closelabels