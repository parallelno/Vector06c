; clear a N*15 pxs square on the screen, 
; where: 
; N = 16 pxs if a = 0
; N = 24 pxs if a != 0
; input:
; hl - scr addr
; a - width marker
; used:
; bc, de
.macro CleanSpriteVLine()
		.loop 14
			mov m, b
			dcr l
		.endloop
			mov m, b
.endmacro
			
CleanSprite:
			ora a
			mvi c, 2
			mvi b, 0
			
			jz @init
			inr c
@init:		
			mov a, l
			sta @restoreY+1
			mov d, h
			mvi e, $20
		
@loop:
			CleanSpriteVLine()
@restoreY
			mvi l, TEMP_BYTE
			mov a, e
			add h
			mov h, a
			jnc @loop
			inr d
			mov h, d
			dcr c
			jnz @loop
			ret
			.closelabels


Clear8x16:
			mvi b, 3

Clear8x16Loop:
			sub a
		.loop 15
			stax d
			dcr e
		.endloop
			stax D
			mvi a, 15
			add e
			mov e, a
			mvi a, 32
			add D
			mov d, a
			dcr b
			jnz Clear8x16Loop
			mvi a, -32-32-32
			add D
			mov d, a

			ret
			.closelabels
			
;----------------------------------------------------------------
; draw a sprite (16x15 pixels)
; in:
; BC	sprite data
; DE	screen address (x,y)
; use: A, HL, SP

; screen format
; DRAW_EVEN_LINE()
; 1st screen buff : 1 -> 2
; 2nd screen buff : 4 <-(3)
; 3rd screen buff : 6 <-(5)
; y--
; DRAW_ODD_LINE()
; 3nd screen buff : 7 -> 8
; 2nd screen buff : 10 <- (9)
; 1st screen buff : 12 <- (11)
; y--
; repeat

.macro DRAW_EVEN_LINE_16(_moveOneLineDown = true)
			POP B		; 1st screen space 
			MOV M,C
			INR H
			MOV M,B
			MOV H,E		; 2nd screen space 
			POP B
			MOV M,C
			DCR H
			MOV M,B
			MOV H,A		; 3rd screen space 
			POP B
			MOV M,C
			DCR H
			MOV M,B
		.if _moveOneLineDown == true
			DCR	L
		.endif
.endmacro

.macro DRAW_ODD_LINE_16(_moveOneLineDown = true)
			POP B		; 3rd screen space 
			MOV M,C
			INR H
			MOV M,B
			MOV H,E		; 2nd screen space 
			POP B
			MOV M,C
			DCR H
			MOV M,B
			MOV H,D		; 1st screen space 
			POP B
			MOV M,C
			DCR H
			MOV M,B
		.if _moveOneLineDown == true
			dcr	l
		.endif			
.endmacro

.macro DrawSprite16_M(height)
		.loop (height - 1) / 2
			DRAW_EVEN_LINE_16()	
			DRAW_ODD_LINE_16()
		.endloop
			DRAW_EVEN_LINE_16(false)
.endmacro

DrawSprite16x15:
			DrawSprite16Height = 15
			; store SP
			LXI		H, 0			; (12)
			DAD		SP				; (12)
			SHLD	@restoreSP + 1	; (20)
			; SP = BC
			MOV		H, B			; (8)
			MOV		L, C			; (8)
			SPHL					; (8)
			; D, E, A are initial X for 
			; the 1st, the 2nd, the 3rd screen buffs
			XCHG					; (4)
			MVI		A, 1			; (8)
			ADD 	H				; (4)
			MOV 	D, A			; (8)
			ADI     $20             ; (8)
			MOV     E, A            ; (8)
			ADI 	$20				; (8)
									; (108) total

; HL - 1st screen buff XY
; SP - sprite data
; D - 1st screen buff X + 1
; E - 2nd screen buff X + 1
; A - 3rd screen buff X + 1

			DrawSprite16_M(DrawSprite16Height)
			
@restoreSP:	
			lxi		sp, TEMP_ADDR	; restore SP (12)
			ret
			.closelabels

;----------------------------------------------------------------
; draw a sprite (24x16 pixels)
; in:
; BC	sprite data
; DE	screen address (x,y)
; use: A, HL, SP

; screen format
; DRAW_EVEN_LINE()
; 1st screen buff : 1 -> 2 -> 3
; 2nd screen buff : 4 <- 5 <- (6)
; 3rd screen buff : 7 <- 8 <- (9)
; y--
; DRAW_ODD_LINE()
; 3nd screen buff : 12 -> 11 -> 10
; 2nd screen buff : 13 <- 14 <- (15)
; 1st screen buff : 18 <- 17 <- (16)
; y--
; repeat

.macro DRAW_EVEN_LINE_24(_moveOneLineDown = true)
			POP B		; 1st screen space 
			MOV M,C
			INR H
			MOV M,B
			INR H
			POP B
			MOV M,C
			MOV H,E		; 2nd screen space 
			MOV M,B
			DCR H
			POP B
			MOV M,C
			DCR H
			MOV M,B
			MOV H,A		; 3rd screen space 
			POP B
			MOV M,C
			DCR H
			MOV M,B
			DCR H
			POP B
			MOV M,C
		.if _moveOneLineDown == true
			DCR	L
		.endif
.endmacro

.macro DRAW_ODD_LINE_24(_moveOneLineDown = true)
			MOV M,B		; 3rd screen space 
			INR H
			POP B
			MOV M,C
			INR H
			MOV M,B
			MOV H,E		; 2nd screen space 
			POP B
			MOV M,C
			DCR H
			MOV M,B
			DCR H
			POP B
			MOV M,C
			MOV H,D		; 1st screen space 
			MOV M,B
			DCR H
			POP B
			MOV M,C
			DCR H
			MOV M,B
		.if _moveOneLineDown == true
			DCR	L
		.endif			
.endmacro

DrawSprite24x15:
			DrawSprite24Height = 15
			; store SP
			LXI		H, 0			; (12)
			DAD		SP				; (12)
			SHLD	@restoreSP + 1	; (20)
			; SP = BC
			MOV		H, B			; (8)
			MOV		L, C			; (8)
			SPHL					; (8)
			; D, E, A are initial X for 
			; the 1st, the 2nd, the 3rd screen buffs
			XCHG					; (4)
			MVI		A, 2			; (8)
			ADD 	H				; (4)
			MOV 	D, A			; (8)
			ADI     $20             ; (8)
			MOV     E, A            ; (8)
			ADI 	$20				; (8)
									; (108) total

			.macro DrawSprite24_M(height)
		.loop (height - 1) / 2
			DRAW_EVEN_LINE_24()
			DRAW_ODD_LINE_24()	
		.endloop
			DRAW_EVEN_LINE_24(false)
			.endmacro									

; HL - 1st screen buff XY
; SP - sprite data
; D - 1st screen buff X + 2
; E - 2nd screen buff X + 2
; A - 3rd screen buff X + 2

			DrawSprite24_M(DrawSprite24Height)

@restoreSP:	
			lxi sp, TEMP_ADDR	; restore SP (12)
			ret
			.closelabels

