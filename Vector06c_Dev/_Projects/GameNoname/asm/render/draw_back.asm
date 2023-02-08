;----------------------------------------------------------------
; draw a background sprite (8xN, 16xN pixels)
; input:
; bc - back sprite data addr
; de - $80 screen addr
; use: a, hl, sp

; data format:
; .word - two safety bytes to prevent a data corruption by the interruption  func
; .byte -   0 means width=8 pxls
;			1 means width=16 pxls
; .byte - height
; pixel format:
; $80 screen buff : two bytes from left to right
; $a0 screen buff : same
; $c0 screen buff : same
; $e0 screen buff : same
; repeat for the next line above.
DRAW_BACK_SPRITE_8 = 0
DRAW_BACK_SPRITE_16 = 1

draw_back_v:
			; store sp
			lxi h, $0000
			dad sp
			shld @restoreSP + 1
			; sp = BC
			mov h, b
			mov l, c
			sphl
			pop b
			xchg
			mov d, b
			xra a
			cmp e
			jnz @drawWidth16
@drawWidth8:			
; TODO: support width = 8
			jmp @restoreSP

; hl - scr addr
; sp - pixel data
; d - height
@drawWidth16:
			mov a, h
			sta @scr8+1
			adi $20
			sta @scrA+1
			adi $20
			mov e, a
			adi $20
			
@nextLine:
			pop b					; (12)
			mov m, c				; (8)
			inr h					; (8)
			mov m, b				; (8)
@scrA:		mvi h, TEMP_BYTE		; (8)

			pop b					; (12)
			mov m, c				; (8)
			inr h					; (8)
			mov m, b				; (8)
@scrC:		mov h, e				; (8)

			pop b					; (12)
			mov m, c				; (8)
			inr h					; (8)
			mov m, b				; (8)
@scrE:		mov h, a				; (8)

			pop b					; (12)
			mov m, c				; (8)
			inr h					; (8)
			mov m, b				; (8)
@scr8:		mvi h, TEMP_BYTE		; (8)
			
			inr l
			dcr d
			jnz @nextLine

@restoreSP:		
			lxi sp, TEMP_ADDR
			ret