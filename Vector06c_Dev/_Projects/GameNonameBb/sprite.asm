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
/*
; copy a sprite from the back buff to the screen
; in:
; de - scr addr
; b - width
;		00 - 8pxs,
;		01 - 16pxs,
;		10 - 24pxs,
;		11 - 32pxs
; c - height
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
			; if a height is an odd number,
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
			; assign SP to prevent screen data corruption
			; when we use MOV with BC (mov b, m and mov c, m) commands
			; corruption might happen because we fill up B and C with 
			; more than one command
			lxi sp, STACK_INTERRUPTION_ADDR
@moveYDown:
			; advance Y down and to the next scr buff
			lxi b, $1f00 ; the low byte will be overwritten
			dad b
			dcr e
			jnz @nextScrBuff
			; advance Y to the next column
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

.macro COPY_SPRITE_TO_SCR_PB(moveUp = true, second = true)
			pop b
			mov m, c
		.if second == true
			inr l
			mov m, b
		.endif
		.if moveUp == true
			inr l
		.endif
.endmacro
			.closelabels
*/
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
			mov a, h
			sta @restoreWidth+1
			; set up a copy routine
			mov a, l
			rlc_(2)
			mov l, a
			mvi h, 0
			lxi b, @copyRoutineAddrs-8; -8 because this func doesn't support height=0 and height=1
			dad b
			; adjust initial Y
			
			; get offsetY
			inr e
			; it has to be even, because a copy routine adjust Y up even times always
			mov a, m
			ani %11111110
			inx h
			sta @moveYDown+1
			; if a height is an odd number,
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

			; store sp
			lxi h, 0
			dad	sp
			shld RestoreSP + 1

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
			; assign SP to prevent screen data corruption
			; when we use MOV with BC (mov b, m and mov c, m) commands
			; corruption might happen because we fill up B and C with 
			; more than one command
			lxi sp, STACK_INTERRUPTION_ADDR
@moveYDown:
			; advance Y down and to the next scr buff
			lxi b, $1f00 ; the low byte will be overwritten
			dad b
			dcr e
			jnz @nextScrBuff
			; advance Y to the next column
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

.macro COPY_SPRITE_TO_SCR_PB(moveUp = true, second = true)
			pop b
			mov m, c
		.if second == true
			inr l
			mov m, b
		.endif
		.if moveUp == true
			inr l
		.endif
.endmacro
			.closelabels