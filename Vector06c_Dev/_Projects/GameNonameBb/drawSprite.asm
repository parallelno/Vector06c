; sharetable chunk of code to restore SP and 
; return a couple of parameters within HL, C
DrawSpriteRet:
drawSpriteScrAddr:
			lxi h, TEMP_ADDR
drawSpriteWidthHeight:
; d - width
;		00 - 8pxs,
;		01 - 16pxs,
;		10 - 24pxs,
;		11 - 32pxs,
; e - height
			lxi d, TEMP_WORD
RestoreSP:
			lxi sp, TEMP_ADDR
			RAM_DISK_OFF()
			ret
			.closelabels
/*
; sharetable chunk of code to restore SP and 
; return a couple of parameters within HL, C
DrawSpriteRet:
drawSpriteScrAddr:
			lxi h, TEMP_ADDR
drawSpriteWidthHeight:
;   height/width packed WWHHHHHH
;	HHHHHH - height
;	WW - width
;		00 - 8pxs,
;		01 - 16pxs,
;		10 - 24pxs,
;		11 - 32pxs,
			mvi c, TEMP_BYTE
RestoreSP:
			lxi sp, TEMP_ADDR
			RAM_DISK_OFF()
			ret
			.closelabels
*/
; copy a sprite from the back buff to the screen
; in:
; input:
; bc	sprite data
; de	screen address (in the $8000 screen buffer)
; use: a, hl, sp
;   HHHHHWWX
;	HHHHH - height
;	WW - width
;		00 - 8pxs,
;		01 - 16pxs,
;		10 - 24pxs,
;		11 - 32pxs,
DrawSpriteVM2:
			; store sp
			lxi h, 0
			dad	sp
			shld RestoreSP + 1
			; sp = BC
			mov	h, b
			mov	l, c
			RAM_DISK_ON(RAM_DISK0_B0_STACK_B2_AF_RAM)
			sphl
			xchg
			; b - offsetX
			; c - offsetY
			pop b
			dad b
			; store a sprite screen addr to return it from this func
			shld drawSpriteScrAddr+1
			; b - width, c - height
			pop b

			mov a, b
			; store sprite width
			sta drawSpriteWidthHeight+2
			rrc
			jc @width16
			rrc
			jc @width24
			jmp @width8
@width16:
			; set up a copy routine
			mvi d, 0
			lxi h, @copyRoutineAddrs-8; -8 because this func doesn't support height=0 and height=1
			mov a, c
			; store sprite height
			sta drawSpriteWidthHeight+1	
			rlc_(2)
			mov e, a
			dad d
			; if a height is an odd number,
			; do not draw the last pixel in every column
			mov a, m
			inx h
			sta @h01
			mov a, m
			inx h
			sta @h01+4
			; init a copy sequence
			mov a, m
			inx h
			mov h, m
			mov l, a
			shld @copyRoutine+1

			; restore a sprite screen addr
			lhld drawSpriteScrAddr+1
			; to restore Y
			mov e, l
			
@nextScrBuff:
			mvi d, 1
@nextCol:			
@copyRoutine:
			jmp TEMP_ADDR	
@h16:		DRAW_SPRITE_BYTE_MASK()
@h15:		DRAW_SPRITE_BYTE_MASK()
@h14:		DRAW_SPRITE_BYTE_MASK()
@h13:		DRAW_SPRITE_BYTE_MASK()
@h12:		DRAW_SPRITE_BYTE_MASK()
@h11:		DRAW_SPRITE_BYTE_MASK()
@h10:		DRAW_SPRITE_BYTE_MASK()
@h09:		DRAW_SPRITE_BYTE_MASK()
@h08:		DRAW_SPRITE_BYTE_MASK()
@h07:		DRAW_SPRITE_BYTE_MASK()
@h06:		DRAW_SPRITE_BYTE_MASK()
@h05:		DRAW_SPRITE_BYTE_MASK()
@h04:		DRAW_SPRITE_BYTE_MASK()
@h03:		DRAW_SPRITE_BYTE_MASK()
@h02:		DRAW_SPRITE_BYTE_MASK()
@h01:		DRAW_SPRITE_BYTE_MASK(false)
			mov l, e
			inr h
			dcr d
			jp @nextCol
			; advance to the next scr buff
			mvi a, $20-2
			add h
			mov h, a
			jnc @nextScrBuff
			jmp DrawSpriteRet

@width24:
			; set up a copy routine
			mvi d, 0
			lxi h, @copyRoutineAddrs-8; -8 because this func doesn't support height=0 and height=1
			mov a, c
			; store sprite height
			sta drawSpriteWidthHeight+1	
			rlc_(2)
			mov e, a
			dad d
			; if a height is an odd number,
			; do not draw the last pixel in every column
			mov a, m
			inx h
			sta @24h01
			mov a, m
			inx h
			sta @24h01+4
			; init a copy sequence
			mov a, m
			inx h
			mov h, m
			mov l, a
			shld @copyRoutine24+1

			; restore a sprite screen addr
			lhld drawSpriteScrAddr+1
			; to restore Y
			mov e, l
			
@nextScrBuff24:
			mvi d, 2
@nextCol24:			
@copyRoutine24:
			jmp TEMP_ADDR	
@24h16:		DRAW_SPRITE_BYTE_MASK()
@24h15:		DRAW_SPRITE_BYTE_MASK()
@24h14:		DRAW_SPRITE_BYTE_MASK()
@24h13:		DRAW_SPRITE_BYTE_MASK()
@24h12:		DRAW_SPRITE_BYTE_MASK()
@24h11:		DRAW_SPRITE_BYTE_MASK()
@24h10:		DRAW_SPRITE_BYTE_MASK()
@24h09:		DRAW_SPRITE_BYTE_MASK()
@24h08:		DRAW_SPRITE_BYTE_MASK()
@24h07:		DRAW_SPRITE_BYTE_MASK()
@24h06:		DRAW_SPRITE_BYTE_MASK()
@24h05:		DRAW_SPRITE_BYTE_MASK()
@24h04:		DRAW_SPRITE_BYTE_MASK()
@24h03:		DRAW_SPRITE_BYTE_MASK()
@24h02:		DRAW_SPRITE_BYTE_MASK()
@24h01:		DRAW_SPRITE_BYTE_MASK(false)
			mov l, e
			inr h
			dcr d
			jp @nextCol24
			; advance to the next scr buff
			mvi a, $20-3
			add h
			mov h, a
			jnc @nextScrBuff24
			jmp DrawSpriteRet
@width8:
			; set up a copy routine
			mvi d, 0
			lxi h, @copyRoutineAddrs-8; -8 because this func doesn't support height=0 and height=1
			mov a, c
			; store sprite height
			sta drawSpriteWidthHeight+1	
			rlc_(2)
			mov e, a
			dad d
			; if a height is an odd number,
			; do not draw the last pixel in every column
			mov a, m
			inx h
			sta @8h01
			mov a, m
			inx h
			sta @8h01+4
			; init a copy sequence
			mov a, m
			inx h
			mov h, m
			mov l, a
			shld @copyRoutine8+1

			; restore a sprite screen addr
			lhld drawSpriteScrAddr+1
			; to restore Y
			mov e, l

@nextScrBuff8:
@nextCol8:			
@copyRoutine8:
			jmp TEMP_ADDR	
@8h16:		DRAW_SPRITE_BYTE_MASK()
@8h15:		DRAW_SPRITE_BYTE_MASK()
@8h14:		DRAW_SPRITE_BYTE_MASK()
@8h13:		DRAW_SPRITE_BYTE_MASK()
@8h12:		DRAW_SPRITE_BYTE_MASK()
@8h11:		DRAW_SPRITE_BYTE_MASK()
@8h10:		DRAW_SPRITE_BYTE_MASK()
@8h09:		DRAW_SPRITE_BYTE_MASK()
@8h08:		DRAW_SPRITE_BYTE_MASK()
@8h07:		DRAW_SPRITE_BYTE_MASK()
@8h06:		DRAW_SPRITE_BYTE_MASK()
@8h05:		DRAW_SPRITE_BYTE_MASK()
@8h04:		DRAW_SPRITE_BYTE_MASK()
@8h03:		DRAW_SPRITE_BYTE_MASK()
@8h02:		DRAW_SPRITE_BYTE_MASK()
@8h01:		DRAW_SPRITE_BYTE_MASK(false)
			mov l, e
			; advance to the next scr buff
			mvi a, $20
			add h
			mov h, a
			jnc @nextScrBuff8
			jmp DrawSpriteRet

@copyRoutineAddrs:
			.word OPCODE_NOP<<8		| OPCODE_NOP	, @h02 ; height = 2
			.word OPCODE_NOP<<8		| OPCODE_NOP	, @h04 ; height = 3
			.word OPCODE_MOV_M_B<<8	| OPCODE_POP_B	, @h04 ; height = 4
			.word OPCODE_NOP<<8		| OPCODE_NOP	, @h06 ; height = 5
			.word OPCODE_MOV_M_B<<8	| OPCODE_POP_B	, @h06 ; height = 6
			.word OPCODE_NOP<<8		| OPCODE_NOP	, @h08 ; height = 7
			.word OPCODE_MOV_M_B<<8	| OPCODE_POP_B	, @h08 ; height = 8
			.word OPCODE_NOP<<8		| OPCODE_NOP	, @h10 ; height = 9
			.word OPCODE_MOV_M_B<<8	| OPCODE_POP_B	, @h10 ; height = 10
			.word OPCODE_NOP<<8		| OPCODE_NOP	, @h12 ; height = 11
			.word OPCODE_MOV_M_B<<8	| OPCODE_POP_B	, @h12 ; height = 12
			.word OPCODE_NOP<<8		| OPCODE_NOP	, @h14 ; height = 13
			.word OPCODE_MOV_M_B<<8	| OPCODE_POP_B	, @h14 ; height = 14
			.word OPCODE_NOP<<8		| OPCODE_NOP	, @h16 ; height = 15
			.word OPCODE_MOV_M_B<<8	| OPCODE_POP_B	, @h16 ; height = 16

.macro DRAW_SPRITE_BYTE_MASK(moveUp = true)
			pop b
			mov a, m
			ana b
			ora c
			mov m, a
		.if moveUp == true
			inr l
		.endif
.endmacro
			.closelabels

; =============================================
; Draw a sprite with a mask in three consiquence screen buffs with offsetX and offsetY
; width is 1-3 bytes
; height is 0-255
; offsetX is 0-1 bytes
; offsetY is 0-31 pixels down
; it uses sp to read the sprite data

; input:
; bc	sprite data
; de	screen address
; use: a, hl, sp

; the sprite format:
; 0, 0 - safety bytes
; height
; %YYYYYWWX
			; X - offsetX. 0 - no offset, 1 - one byte offset to the right
			; WW - width. 0 - one byte width, 1 - two bytes width, 2 - three bytes width
			; YYYYY - offsetY down
; art data:
; 1st screen buff : 1 -> 2
; 2nd screen buff : 4 <- 3
; 3rd screen buff : 6 <- 5
; y--
; 3rd screen buff : 7 -> 8
; 2nd screen buff : 10 <- 9
; 1st screen buff : 12 <- 11
; y--
; repeat the next lines of the art data
.macro DrawSpriteVM_B()
			pop b
			mov a, m
			ana c
			ora b
			mov m, a
.endmacro

DrawSpriteVM:
			; store sp
			lxi h, 0
			dad	sp
			shld RestoreSP + 1
			; sp = BC
			mov	h, b
			mov	l, c
			RAM_DISK_ON(RAM_DISK0_B0_STACK_B2_AF_RAM)
			sphl
			xchg
			; b - %YYYYYWWX
			; 		X - offsetX. 0 - no offset, 1 - one byte offset to the right
			; 		WW - width. 0 - one byte width, 1 - two bytes width, 2 - three bytes width
			; 		YYYYY - offsetY down
			; c - height
			pop b
			mov a, b
			rrc
			jnc @noOffsetX
			inr h
@noOffsetX:
			rrc
			jc @width16
			rrc
			jnc @width8

@width24:
			; get offsetY and apply it to X
			ani %11111
			sub l
			cma
			inr a
			mov l, a
			; store sprite screen addr to return it from this func
			shld drawSpriteScrAddr+1
			; store sprite width and height packed as WWHHHHHH
			mvi a, %10000000
			ora c
			sta drawSpriteWidthHeight+1

			; save the high screen byte to restore X
			mvi a, 2
			add h
			sta @w24oddScr1+1
			adi $20
			mov d, a
			adi $20
			sta @w24evenScr3+1
			; height counter
			mov e, c

@w24evenScr1:
			DrawSpriteVM_B()
			inr h
			DrawSpriteVM_B()
			inr h
			DrawSpriteVM_B()

@w24evenScr2:
			mov h, d
			DrawSpriteVM_B()
			dcr h
			DrawSpriteVM_B()
			dcr h
			DrawSpriteVM_B()

@w24evenScr3:
			mvi h, TEMP_BYTE
			DrawSpriteVM_B()
			dcr h
			DrawSpriteVM_B()
			dcr h
			DrawSpriteVM_B()
			dcr l
			dcr e
			jz DrawSpriteRet

@w24oddScr3:
			DrawSpriteVM_B()
			inr h
			DrawSpriteVM_B()
			inr h
			DrawSpriteVM_B()
@w24oddScr2:
			mov h, d
			DrawSpriteVM_B()
			dcr h
			DrawSpriteVM_B()
			dcr h
			DrawSpriteVM_B()
@w24oddScr1:
			mvi h, TEMP_BYTE
			DrawSpriteVM_B()
			dcr h
			DrawSpriteVM_B()
			dcr h
			DrawSpriteVM_B()
			dcr l
			dcr e
			jnz @w24evenScr1
			jmp DrawSpriteRet
;------------------------------------------------
@width16:
			; get offsetY and apply it to X
			rrc
			ani %11111
			sub l
			cma
			inr a
			mov l, a
			; store hl to return it from this func
			shld drawSpriteScrAddr+1
			; store sprite width and height packed as WWHHHHHH
			mvi a, %01000000
			ora c
			sta drawSpriteWidthHeight+1

			; save the high screen byte to restore X
			mvi a, 1
			add h
			sta @w16oddScr1+1
			adi $20
			mov d, a
			adi $20
			sta @w16evenScr3+1
			; counter
			mov e, c

@w16evenScr1:
			DrawSpriteVM_B()
			inr h
			DrawSpriteVM_B()
@w16evenScr2:
			mov h, d
			DrawSpriteVM_B()
			dcr h
			DrawSpriteVM_B()
@w16evenScr3:
			mvi h, TEMP_BYTE
			DrawSpriteVM_B()
			dcr h
			DrawSpriteVM_B()
			dcr l
			dcr e
			jz DrawSpriteRet

@w16oddScr3:
			DrawSpriteVM_B()
			inr h
			DrawSpriteVM_B()
@w16oddScr2:
			mov h, d
			DrawSpriteVM_B()
			dcr h
			DrawSpriteVM_B()
@w16oddScr1:
			mvi h, TEMP_BYTE
			DrawSpriteVM_B()
			dcr h
			DrawSpriteVM_B()
			dcr	l
			dcr e
			jnz @w16evenScr1
			jmp DrawSpriteRet
;-------------------------------------------------
@width8:
			; get offsetY and apply it to X
			ani %11111
			sub l
			cma
			inr a
			mov l, a
			; store hl to return it from this func
			shld drawSpriteScrAddr+1
			; store sprite width and height packed as WWHHHHHH
			mov a, c
			sta drawSpriteWidthHeight+1

			; save the high screen byte to restore X
			mov a, h
			sta @w8oddScr1+1
			adi $20
			mov d, a
			adi $20
			sta @w8evenScr3+1
			; counter
			mov e, c

@w8evenScr1:
			DrawSpriteVM_B()
@w8evenScr2:
			mov h, d
			DrawSpriteVM_B()
@w8evenScr3:
			mvi h, TEMP_BYTE
			DrawSpriteVM_B()
			dcr l
			dcr e
			jz DrawSpriteRet
@w8oddScr3:
			DrawSpriteVM_B()
@w8oddScr2:
			mov h, d
			DrawSpriteVM_B()
@w8oddScr1:
			mvi h, TEMP_BYTE
			DrawSpriteVM_B()
			dcr	l
			dcr e
			jnz @w8evenScr1
			jmp DrawSpriteRet
			.closelabels

/*
; =============================================
; Draw a sprite in three consiquence screen buffs with offsetX and offsetY
; width is 1-3 bytes
; height is 0-255
; offsetX is 0-1 bytes
; offsetY is 0-31 pixels down
; it uses sp to read the sprite data

; input:
; bc	sprite data
; de	screen address (in the $8000 screen buffer)
; use: a, hl, sp

; the sprite format:
; 0, 0 - safety bytes
; height
; %YYYYYWWX
			; X - offsetX. 0 - no offset, 1 - one byte offset to the right
			; WW - width. 0 - one byte width, 1 - two bytes width, 2 - three bytes width
			; YYYYY - offsetY down
; art data:
; 1st screen buff : 1 -> 2
; 2nd screen buff : 4 <- 3
; 3rd screen buff : 6 <- 5
; y--
; 3rd screen buff : 7 -> 8
; 2nd screen buff : 10 <- 9
; 1st screen buff : 12 <- 11
; y--
; repeat the next lines of the art data
.macro DrawSpriteV_B()
			pop b
			mov m, b
.endmacro

DrawSpriteV:
			; store sp
			lxi h, 0
			dad	sp
			shld RestoreSP + 1
			; sp = BC
			mov	h, b
			mov	l, c
			RAM_DISK_ON(RAM_DISK0_B0_STACK_B2_AF_RAM)
			sphl
			xchg
			; b - %YYYYYWWX
			; 		X - offsetX. 0 - no offset, 1 - one byte offset to the right
			; 		WW - width. 0 - one byte width, 1 - two bytes width, 2 - three bytes width
			; 		YYYYY - offsetY down
			; c - height
			pop b
			mov a, b
			rrc
			jnc @noOffsetX
			inr h
@noOffsetX:
			rrc
			jc @width16
			rrc
			jnc @width8

@width24:
			; get offsetY and apply it to X
			ani %11111
			sub l
			cma
			inr a
			mov l, a
			; store sprite screen addr to return it from this func
			shld drawSpriteScrAddr+1
			; store sprite width and height packed as WWHHHHHH
			mvi a, %01000000
			ora c
			sta drawSpriteWidthHeight+1

			; save the high screen byte to restore X
			mvi a, 2
			add h
			sta @w24oddScr1+1
			adi $20
			mov d, a
			adi $20
			sta @w24evenScr3+1
			; height counter
			mov e, c

@w24evenScr1:
			DrawSpriteV_B()
			inr h
			DrawSpriteV_B()
			inr h
			DrawSpriteV_B()

@w24evenScr2:
			mov h, d
			DrawSpriteV_B()
			dcr h
			DrawSpriteV_B()
			dcr h
			DrawSpriteV_B()

@w24evenScr3:
			mvi h, TEMP_BYTE
			DrawSpriteV_B()
			dcr h
			DrawSpriteV_B()
			dcr h
			DrawSpriteV_B()
			dcr l
			dcr e
			jz DrawSpriteRet

@w24oddScr3:
			DrawSpriteV_B()
			inr h
			DrawSpriteV_B()
			inr h
			DrawSpriteV_B()
@w24oddScr2:
			mov h, d
			DrawSpriteV_B()
			dcr h
			DrawSpriteV_B()
			dcr h
			DrawSpriteV_B()
@w24oddScr1:
			mvi h, TEMP_BYTE
			DrawSpriteV_B()
			dcr h
			DrawSpriteV_B()
			dcr h
			DrawSpriteV_B()
			dcr l
			dcr e
			jnz @w24evenScr1
			jmp DrawSpriteRet
;------------------------------------------------
@width16:
			; get offsetY and apply it to X
			rrc
			ani %11111
			sub l
			cma
			inr a
			mov l, a
			; store hl to return it from this func
			shld drawSpriteScrAddr+1
			; store sprite width and height packed as WWHHHHHH
			mvi a, %10000000
			ora c
			sta drawSpriteWidthHeight+1

			; save the high screen byte to restore X
			mvi a, 1
			add h
			sta @w16oddScr1+1
			adi $20
			mov d, a
			adi $20
			sta @w16evenScr3+1
			; counter
			mov e, c

@w16evenScr1:
			DrawSpriteV_B()
			inr h
			DrawSpriteV_B()
@w16evenScr2:
			mov h, d
			DrawSpriteV_B()
			dcr h
			DrawSpriteV_B()
@w16evenScr3:
			mvi h, TEMP_BYTE
			DrawSpriteV_B()
			dcr h
			DrawSpriteV_B()
			dcr l
			dcr e
			jz DrawSpriteRet

@w16oddScr3:
			DrawSpriteV_B()
			inr h
			DrawSpriteV_B()
@w16oddScr2:
			mov h, d
			DrawSpriteV_B()
			dcr h
			DrawSpriteV_B()
@w16oddScr1:
			mvi h, TEMP_BYTE
			DrawSpriteV_B()
			dcr h
			DrawSpriteV_B()
			dcr	l
			dcr e
			jnz @w16evenScr1
			jmp DrawSpriteRet
;-------------------------------------------------
@width8:
			; get offsetY and apply it to X
			ani %11111
			sub l
			cma
			inr a
			mov l, a
			; store hl to return it from this func
			shld drawSpriteScrAddr+1
			; store sprite width and height packed as WWHHHHHH
			mov a, c
			sta drawSpriteWidthHeight+1

			; save the high screen byte to restore X
			mov a, h
			sta @w8oddScr1+1
			adi $20
			mov d, a
			adi $20
			sta @w8evenScr3+1
			; counter
			mov e, c

@w8evenScr1:
			DrawSpriteV_B()
@w8evenScr2:
			mov h, d
			DrawSpriteV_B()
@w8evenScr3:
			mvi h, TEMP_BYTE
			DrawSpriteV_B()
			dcr l
			dcr e
			jz DrawSpriteRet
@w8oddScr3:
			DrawSpriteV_B()
@w8oddScr2:
			mov h, d
			DrawSpriteV_B()
@w8oddScr1:
			mvi h, TEMP_BYTE
			DrawSpriteV_B()
			dcr	l
			dcr e
			jnz @w8evenScr1
			jmp DrawSpriteRet
			.closelabels
*/
