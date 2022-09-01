; hl - scr addr
; a - width
; a == 0, 2 bytes
; a != 0, 3 bytes

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
			stax d
			mvi a, 15
			add e
			mov e, a
			mvi a, 32
			add d
			mov d, a
			dcr b
			jnz Clear8x16Loop
			mvi a, -32-32-32
			add d
			mov d, a

			ret
		.closelabels
			
;----------------------------------------------------------------
; draw a sprite (16x15 pixels)
; input:
; BC	sprite data
; DE	screen address (x,y)
; use: A, HL, sp

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
			.macro POP_B_OR_M_FORWARD_16()
			pop b
			mov a, c
			ora m
			mov m, a
			inr h
			mov a, b
			ora m
			mov m, a
			.endmacro

			.macro POP_B_OR_M_BACKWARD_16()
			pop b
			mov a, c
			ora m
			mov m, a
			dcr h
			mov a, b
			ora m
			mov m, a
			.endmacro

			.macro DRAW_EVEN_LINE_16(_moveOneLineDown = true)
			; 1st screen space 
			POP_B_OR_M_FORWARD_16()
			; 2nd screen space 
			mov h, e		
			POP_B_OR_M_BACKWARD_16()
			; 3rd screen space 
			mov a, h
			adi $21
			mov h, a
			POP_B_OR_M_BACKWARD_16()

			.if _moveOneLineDown == true
			dcr	l
			.endif
			.endmacro

			.macro DRAW_ODD_LINE_16(_moveOneLineDown = true)
			; 3rd screen space 
			POP_B_OR_M_FORWARD_16()
			mov h, e        ; 2nd screen space 
			POP_B_OR_M_BACKWARD_16()
			mov h, d		    ; 1st screen space 
			POP_B_OR_M_BACKWARD_16()

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
			; store sp
			lxi		h, $0000			; (12)
			dad		sp				; (12)
			shld	@restoreSP + 1	; (20)
			; sp = BC
			mov		h, b			; (8)
			mov		l, c			; (8)
			sphl					; (8)
			; D, e, a are initial X for 
			; the 1st, the 2nd, the 3rd screen buffs
			xchg					; (4)
			mvi		a, 1			; (8)
			add 	h				; (4)
			mov 	d, a			; (8)
			adi     $20             ; (8)
			mov     e, a            ; (8)
			;adi 	$20				; (8)
									; (108) total

; HL - 1st screen buff XY
; sp - sprite data
; D - 1st screen buff X + 1
; E - 2nd screen buff X + 1
; A - 3rd screen buff X + 1

			DrawSprite16_M(DrawSprite16Height)
			
@restoreSP:	lxi		sp, TEMP_ADDR	; restore sp (12)
			ret
			.closelabels

;----------------------------------------------------------------
; draw a sprite (24x16 pixels)
; input:
; BC	sprite data
; DE	screen address (x,y)
; use: A, HL, sp

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
			pop b		; 1st screen space
			mov a, c
			ora m			
			mov m, a
			inr h
			mov a, b
			ora m			
			mov m, a
			inr h
			pop b
			mov a, c
			ora m			
			mov m, a
			mov h, e		; 2nd screen space
			mov a, b
			ora m			
			mov m, a
			dcr h
			pop b
			mov a, c
			ora m
			mov m, a
			dcr h
			mov a, b
			ora m			
			mov m, a
			mov a, h		; 3rd screen space 
			adi $22
			mov h, a
			pop b
			mov a, c
			ora m			
			mov m, a
			dcr h
			mov a, b
			ora m			
			mov m, a
			dcr h
			pop b
			mov a, c
			ora m			
			mov m, a
			.if _moveOneLineDown == true
			dcr	l
			.endif
			.endmacro

			.macro DRAW_ODD_LINE_24(_moveOneLineDown = true)
			mov a, b		; 3rd screen space
			ora m			
			mov m, a	
			inr h
			pop b
			mov a, c
			ora m			
			mov m, a
			inr h
			mov a, b
			ora m			
			mov m, a
			mov h, e		; 2nd screen space 
			pop b
			mov a, c
			ora m			
			mov m, a
			dcr h
			mov a, b
			ora m			
			mov m, a
			dcr h
			pop b
			mov a, c
			ora m			
			mov m, a
			mov h, d		; 1st screen space 
			mov a, b
			ora m			
			mov m, a
			dcr h
			pop b
			mov a, c
			ora m			
			mov m, a
			dcr h
			mov a, b
			ora m			
			mov m, a
			.if _moveOneLineDown == true
			dcr	l
			.endif			
			.endmacro

DrawSprite24x15:
			DrawSprite24Height = 15
			; store sp
			lxi		h, $0000			; (12)
			dad		sp				; (12)
			shld	@restoreSP + 1	; (20)
			; sp = BC
			mov		h, b			; (8)
			mov		l, c			; (8)
			sphl					; (8)
			; D, e, a are initial X for 
			; the 1st, the 2nd, the 3rd screen buffs
			xchg					; (4)
			mvi		a, 2			; (8)
			add 	h				; (4)
			mov 	d, a			; (8)
			adi     $20             ; (8)
			mov     e, a            ; (8)
			;adi 	$20				; (8)
									; (108) total

			.macro DrawSprite24_M(height)
		.loop (height - 1) / 2
			DRAW_EVEN_LINE_24()
			DRAW_ODD_LINE_24()	
		.endloop
			DRAW_EVEN_LINE_24(false)
			.endmacro									

; HL - 1st screen buff XY
; sp - sprite data
; D - 1st screen buff X + 2
; E - 2nd screen buff X + 2
; A - 3rd screen buff X + 2

			DrawSprite24_M(DrawSprite24Height)

@restoreSP:	lxi		sp, TEMP_ADDR	; restore sp (12)
			ret
			.closelabels

