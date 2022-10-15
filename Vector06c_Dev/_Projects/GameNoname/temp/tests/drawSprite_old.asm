
			
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
			lxi h, $0000			; (12)
			dad sp				; (12)
			shld @restoreSP + 1	; (20)
			; sp = BC
			mov h, b			; (8)
			mov l, c			; (8)
			sphl					; (8)
			; D, e, a are initial X for 
			; the 1st, the 2nd, the 3rd screen buffs
			xchg					; (4)
			mvi a, 1			; (8)
			add h				; (4)
			mov d, a			; (8)
			adi $20             ; (8)
			mov e, a            ; (8)
			adi $20				; (8)
									; (108) total

; HL - 1st screen buff XY
; sp - sprite data
; D - 1st screen buff X + 1
; E - 2nd screen buff X + 1
; A - 3rd screen buff X + 1

			DrawSprite16_M(DrawSprite16Height)
			
@restoreSP:	
			lxi sp, TEMP_ADDR	; restore sp (12)
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
			mov m, c
			inr h
			mov m, b
			inr h
			pop b
			mov m, c
			mov h, e		; 2nd screen space 
			mov m, b
			dcr h
			pop b
			mov m, c
			dcr h
			mov m, b
			mov h, a		; 3rd screen space 
			pop b
			mov m, c
			dcr h
			mov m, b
			dcr h
			pop b
			mov m, c
		.if _moveOneLineDown == true
			dcr	l
		.endif
.endmacro

.macro DRAW_ODD_LINE_24(_moveOneLineDown = true)
			mov m, b		; 3rd screen space 
			inr h
			pop b
			mov m, c
			inr h
			mov m, b
			mov h, e		; 2nd screen space 
			pop b
			mov m, c
			dcr h
			mov m, b
			dcr h
			pop b
			mov m, c
			mov h, d		; 1st screen space 
			mov m, b
			dcr h
			pop b
			mov m, c
			dcr h
			mov m, b
		.if _moveOneLineDown == true
			dcr	l
		.endif			
.endmacro

DrawSprite24x15:
			DrawSprite24Height = 15
			; store sp
			lxi		h, $0000		; (12)
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
			adi 	$20				; (8)
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

@restoreSP:	
			lxi sp, TEMP_ADDR	; restore sp (12)
			ret
			.closelabels

