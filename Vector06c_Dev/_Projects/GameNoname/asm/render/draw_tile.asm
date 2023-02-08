;----------------------------------------------------------------
; draw a tile (16x16 pixels)
; input:
; bc - tile data addr
; de - screen addr (x,y)
; use: a, hl, sp

; tile graphics format:
; .byte - a bit mask xxxxECA8, where the "8" bit says if a sprite needs to be drawn in the $8000 buffer, the "A" bit in charge of $A000 buffer etc.
; .byte 4 - needs for a counter
; screen format
; 1st screen buff : draw 16 bytes down, step one byte right, draw 16 bytes up.
; 2nd screen buff : same
; 3rd screen buff : same
; 4rd screen buff : same

DrawTile16x16:
			; store sp
			lxi h, $0000		; (12)
			dad sp				; (12)
			shld @restoreSP + 1	; (20)
			; sp = BC
			mov h, b			; (8)
			mov l, c			; (8)
			sphl					; (8)
			; get a mask and a counter
			pop b					; (12)
			xchg					; (4)
			mov e, c			; (8)
			mov d, b			; (8)
									; (100) total

; HL - 1st screen buff XY
; sp - sprite data
; E - contains a bit mask xxxxECA8
;   "8" bit - draw in $8000 buffer
;   "A" bit - draw in $A000 buffer etc.
; D - counter of screen buffers
@loop:
			mov a, e
			rrc
			mov e, a
			jnc @eraseTileBuf

			DRAWTILE16x16_DRAW_BUF()
			jmp @nextBuf

@eraseTileBuf:
			DRAWTILE16x16_ERASE_BUF()
@nextBuf:
			; move X to the next scr buff
			mvi a, $20
			add h
			mov h, a

			dcr d
			jnz @loop
@restoreSP:		
			lxi sp, TEMP_ADDR
			ret
			.closelabels
			
.macro DRAWTILE16x16_DRAW_BUF()
		.loop 7
			pop b					; (12)
			mov m, c				; (8)
			inr l					; (8)
			mov m, b				; (8)
			inr l					; (8)
		.endloop
			pop b					; (12)
			mov m, c				; (8)
			inr l					; (8)
			mov m, b				; (8)

			inr h					; (8)
		.loop 7
			pop b					; (12)
			mov m, c				; (8)
			dcr l					; (8)
			mov m, b				; (8)
			dcr l					; (8)
		.endloop
			pop b					; (12)
			mov m, c				; (8)
			dcr l					; (8)
			mov m, b				; (8)
			dcr h					; (8) (704)		
.endmacro

.macro DRAWTILE16x16_ERASE_BUF()
			xra a
		.loop 15
			mov m, a
			inr l
		.endloop
			mov m, a
			inr h		
		.loop 15
			mov m, a
			dcr l				
		.endloop
			mov m, a 
			dcr h		
.endmacro
