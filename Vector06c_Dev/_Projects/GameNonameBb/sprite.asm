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
/*
; clear a N*15 pxs square on the screen, 
; it clears 3 screen buffers from hl addr and further
; where: 
; 16 pxs width if a = 0
; 24 pxs width if a != 0
; input:
; hl - scr addr
; a - width marker
; use:
; bc, de

EraseSprite:
			mvi c, 2
			mvi b, 0
			
			ora a
			jz @width16
			inr c
@width16:		
			mov a, l
			sta @restoreY+1
			mov d, h
@loop:
			EraseSpriteVLine(15)
@restoreY
			mvi l, TEMP_BYTE
			mvi a, $20
			add h
			mov h, a
			jnc @loop
			inr d
			mov h, d
			dcr c
			jnz @loop
			ret
			.closelabels

.macro EraseSpriteVLine(_dy)
		.loop _dy-1
			mov m, b
			dcr l
		.endloop
			mov m, b
.endmacro
*/
/*
; clear a N*16 pxs square on the screen, 
; it uses PUSH!
; it clears 3 screen buffers from hl addr and further

; input:
; de - scr addr
; a - flag
;		flag=0, 16 pxs width
;		flag!=0, 24 pxs width

; use:
; bc, hl, sp

EraseSpriteSP:
			di
			lxi h, 0
			dad sp
			shld @restoreSP+1

			xchg
			; to prevent clearing below the sprite
			inr l
			inr l

			lxi b, 0
			lxi d, $2000

			; replaced with OPCODE_NOP if with == 24
			; replaced with OPCODE_NOP if with == 24
			ora a
			jz @width16
@width8:
			sphl
			PUSH_B(8)
			dad d
			sphl
			PUSH_B(8)
			dad d
			sphl
			PUSH_B(8)

			mov a, h
			sui $20*2-1
			mov h, a
@width16:
			sphl
			PUSH_B(8)
			dad d
			sphl
			PUSH_B(8)
			dad d
			sphl
			PUSH_B(8)

			mov a, h
			sui $20*2-1
			mov h, a			
@width24:
			sphl
			PUSH_B(8)
			dad d
			sphl
			PUSH_B(8)
			dad d
			sphl
			PUSH_B(8)
@restoreSP:
			lxi sp, TEMP_ADDR
			ei
			ret
			.closelabels
*/

; clear a N*16 pxs square on the screen, 
; it clears 3 screen buffers from de addr and further
; in:
; de - scr addr
; c - height/width packed WWHHHHHH
;	HHHHHH - height
;	WW - width
;		00 - 8pxs,
;		01 - 16pxs,
;		10 - 24pxs,
;		11 - 32pxs,
EraseSpriteSP:
			lxi h, 0
			dad sp
			shld RestoreSP + 1
			RAM_DISK_ON(RAM_DISK0_B2_STACK_B2_AF_RAM)
			xchg
			; because push decrements SP before store RP
			inr l

			mov a, c

			; (backbuff addr) = BC
			lxi b, 0
			; to move the next scr buff
			lxi d, $2000

			rlc
			jc @width24or32
			rlc
			jc @width16
			jmp @width8
@width24or32:
			rlc
			jnc @width24
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
; a - height/width packed HHHHHHWW
;	HHHHHH - height
;	WW - width
;		00 - 8pxs,
;		01 - 16pxs,
;		10 - 24pxs,
;		11 - 32pxs,
; a - extra height. the final height = HHHHHH + B
CopySpriteToScrV:
			; store sp
			lxi h, 0
			dad	sp
			shld RestoreSP + 1

			; HHHHHHWW + A
			add c

			; extract width
			rlc_(2)
			mov c, a	
			ani %11
			sta @restoreWidth+1

			; extract height multiplied by 4
			cma
			ana c

			; set up a copy routine
			mov c, a
			mvi b, 0
			lxi h, @copyRoutineAddrs-8; -8 because this func doesn't support height=0 and height=1
			dad b
			; adjust initial Y
			mov a, m
			add e
			mov e, a
			; get offsetY
			; it has to be even, because a copy routine adjust Y up even times always
			mov a, m
			ani %11111110
			inx h
			sta @moveYDown+1
			; if a height is odd number,
			; do not draw the last pixel in every column
			mov a, m
			inx h
			sta @h04+3
			; init a copy sequence
			mov b, m
			inx h
			mov h, m
			mov l, b
			shld @copyRoutine+1

			xchg
			
@restoreWidth:
			mvi d, TEMP_BYTE
@nextScrCol:
			mvi e, 3
@nextScrBuff:			
			RAM_DISK_ON(RAM_DISK0_B2_STACK_B2_AF_RAM)
			mov b, m
			dcr l
			mov c, m
			RAM_DISK_ON(RAM_DISK0_B2_STACK)
			mov m, c
			inr l
			mov m, b
			inr l
			sphl
@copyRoutine:
			jmp TEMP_ADDR
@h20:       COPY_SPRITE_TO_SCR_PB()		
@h18:       COPY_SPRITE_TO_SCR_PB()		
@h16:		COPY_SPRITE_TO_SCR_PB()
@h14:		COPY_SPRITE_TO_SCR_PB()
@h12:		COPY_SPRITE_TO_SCR_PB()
@h10:		COPY_SPRITE_TO_SCR_PB()
@h08:		COPY_SPRITE_TO_SCR_PB()
@h06:		COPY_SPRITE_TO_SCR_PB()
@h04:		COPY_SPRITE_TO_SCR_PB(false)
@h02:
			; set up the SP to prevent screen data corruption 
			; when we read into BC with mov b, m and mov c, m operations
			lxi sp, STACK_INTERRUPTION_ADDR
			; advance to the next scr buff
@moveYDown:
			; advance Y down and to the next scr buff
			lxi b, $1f00 ; the low byte will be overwritten
			dad b
			dcr e
			jnz @nextScrBuff
			; advance to the next column
			mvi a, -$20*3+1
			add h
			mov h, a
			dcr d
			jp @nextScrCol
			jmp RestoreSP

@copyRoutineAddrs:
			.word OPCODE_NOP <<8		| <(-00), @h02 ; height = 2
			.word OPCODE_NOP <<8		| <(-01), @h04 ; height = 3
			.word OPCODE_MOV_M_B <<8	| <(-02), @h04 ; height = 4
			.word OPCODE_NOP <<8		| <(-03), @h06 ; height = 5
			.word OPCODE_MOV_M_B <<8	| <(-04), @h06 ; height = 6
			.word OPCODE_NOP <<8		| <(-05), @h08 ; height = 7
			.word OPCODE_MOV_M_B <<8	| <(-06), @h08 ; height = 8
			.word OPCODE_NOP <<8		| <(-07), @h10 ; height = 9
			.word OPCODE_MOV_M_B <<8 	| <(-08), @h10 ; height = 10
			.word OPCODE_NOP <<8		| <(-09), @h12 ; height = 11
			.word OPCODE_MOV_M_B <<8 	| <(-10), @h12 ; height = 12
			.word OPCODE_NOP <<8		| <(-11), @h14 ; height = 13
			.word OPCODE_MOV_M_B <<8 	| <(-12), @h14 ; height = 14
			.word OPCODE_NOP <<8	 	| <(-13), @h16 ; height = 15
			.word OPCODE_MOV_M_B <<8 	| <(-14), @h16 ; height = 16
			.word OPCODE_NOP <<8 		| <(-15), @h18 ; height = 17
			.word OPCODE_MOV_M_B <<8 	| <(-16), @h18 ; height = 18
			.word OPCODE_NOP <<8 		| <(-17), @h20 ; height = 19
			.word OPCODE_MOV_M_B <<8	| <(-18), @h20 ; height = 20

.macro COPY_SPRITE_TO_SCR_PB(moveUp = true)
			pop b
			mov m, c
			inr l
			mov m, b
		.if moveUp == true
			inr l
		.endif
.endmacro
			.closelabels

; copy a sprite 16pxs height from the back buff to the screen
; in:
; de - scr addr
; c - height/width packed HHHHHHWW
;	HHHHHH - is not used
;	WW - width
;		00 - 8pxs,
;		10 - 16pxs,
;		01 - 24pxs,
CopySpriteToScr:
			; store sp
			lxi h, 0
			dad	sp
			shld RestoreSP + 1

			;RAM_DISK_ON(RAM_DISK0_B2_STACK)
			xchg
			lxi d, $ffff - 14 + 1
			dad d

			; to move the next scr buff
			mvi d, >($2000 - 15 + 1)

			; handle width
			mov a, c
			rlc
			jc @width16
			rlc
			jnc @width8
@width24:
			DRAW_SPRITE_FROM_BB_COL()
@width16:
			DRAW_SPRITE_FROM_BB_COL()
@width8:
			DRAW_SPRITE_FROM_BB_COL(false)
			jmp RestoreSP

.macro DRAW_SPRITE_FROM_BB_COL(nextColumn = true)
	col .var 0
	.loop 3
			col = col + 1
			RAM_DISK_ON(RAM_DISK0_B2_STACK_B2_AF_RAM)
			; read the first two bytes without a stack operation
			; to get safety bytes before using POP
			mov b, m
			dcr l
			mov c, m
			RAM_DISK_ON(RAM_DISK0_B2_STACK)
			mov m, c
			inr l
			mov m, b
			inr l

			sphl
		.loop 6
			pop b
			mov m, c
			inr l
			mov m, b
			inr l
		.endloop
			; TODO: think of storing bytes in the
			; back buff without switching between
			; scr buffs. because back buff
			; is a plane addr space
			; TODO: consider using masks only for
			; the first column
			; TODO: consider drawing a sprite into
			; the back buffer by columns
			pop b
			mov m, c
			; copy one more line of pixels to clean the screen behind the sprite
			inr l
			mov m, b
		.if nextColumn == true || col < 3
			; set up the SP to prevent screen data corruption 
			; when we read into BC with mov b, m and mov c, m operations
			lxi sp, STACK_INTERRUPTION_ADDR
			; TODO: consider not doing DAD for the last scr buff
			dad d
		.endif
	.endloop
		.if nextColumn == true
			; TODO: consider using BC to advance HL
			; advance to the next column
			mvi a, -$20*3+1
			add h
			mov h, a
		.endif
.endmacro
			.closelabels