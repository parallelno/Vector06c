;----------------------------------------------------------------
; draw a sprite (24x24 pixels)
; author: parallelno
; method: zig-zag
; in:
; BC	sprite data
; DE	screen address (x,y)
; use: HL, SP

			.macro DRAW_EVEN_LINE(_moveOneLineDown = true)
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

			.macro DRAW_ODD_LINE(_moveOneLineDown = true)
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

			.function DS_parallelno2
DrawSprite24x24:
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

; HL - 1st screen buff XY
; SP - sprite data
; D - 1st screen buff X + 2
; E - 2nd screen buff X + 2
; A - 3rd screen buff X + 2

			DRAW_EVEN_LINE()	
			DRAW_ODD_LINE()	
			DRAW_EVEN_LINE()	
			DRAW_ODD_LINE()	
			DRAW_EVEN_LINE()	
			DRAW_ODD_LINE()	
			DRAW_EVEN_LINE()	
			DRAW_ODD_LINE()	
			DRAW_EVEN_LINE()	
			DRAW_ODD_LINE()	
			DRAW_EVEN_LINE()	
			DRAW_ODD_LINE()	
			DRAW_EVEN_LINE()	
			DRAW_ODD_LINE()	
			DRAW_EVEN_LINE()	
			DRAW_ODD_LINE()	
			DRAW_EVEN_LINE()	
			DRAW_ODD_LINE()	
			DRAW_EVEN_LINE()	
			DRAW_ODD_LINE()	
			DRAW_EVEN_LINE()	
			DRAW_ODD_LINE()	
			DRAW_EVEN_LINE()	
			DRAW_ODD_LINE( false)

@restoreSP:	LXI		SP, TEMP_ADDR	; restore SP (12)
			RET
			.endfunction

