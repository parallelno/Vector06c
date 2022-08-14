;----------------------------------------------------------------
; draw a tile (16x16 pixels)
; in:
; BC	sprite data
; DE	screen address (x,y)
; use: A, HL, sp

; screen format
; 1st screen buff : draw 16 bites down, step one byte right, draw 16 bytes up.
; 2nd screen buff : same
; 3rd screen buff : same
; 4rd screen buff : same
		
DrawTile16x16:
			; store sp
			lxi		h, $0000			; (12)
			dad		sp				; (12)
			shld	@restoreSP + 1	; (20)
			; sp = BC
			mov		h, b			; (8)
			mov		l, c			; (8)
			; A contains a bit mask xxxxECA8, where the "8" bit says if a sprite needs to draw in $8000 buffer, the "A" bit in charge of $A000 buffer etc.
			mov		a, m			; (8)
			; think how to make HL=HL+3 faster
			INX		h				; (8)
			INX		h				; (8)
			INX		h				; (8)
			sphl					; (8)
			xchg					; (4)
			mov		e, a			; (8)
			mvi		d, 4			; (8)
									; (120) total

; HL - 1st screen buff XY
; sp - sprite data
; E - contains a bit mask xxxxECA8, where the "8" bit says if a sprite needs to draw in $8000 buffer, the "A" bit in charge of $A000 buffer etc.
; D - counter of screen buffers
@loop:
			mov		a, e
			rrc
			mov		e, a
			jnc		@doNotDraw

			DRAW_TILE_16x16_LINE()

@doNotDraw:	
			mvi		a, 32
			add		h
			mov		h, a

			dcr		d
			JNZ		@loop

@restoreSP:	lxi		sp, TEMP_ADDR	; restore sp (12)
			RET
			.closelabels
			
			.macro DRAW_TILE_16x16_LINE()
		.loop 7
			pop b					; (12)
			mov m, c					; (8)
			dcr l					; (8)
			mov m, b					; (8)
			dcr l					; (8)
		.endloop
			pop b					; (12)
			mov m, c					; (8)
			dcr l					; (8)
			mov m, b					; (8)

			inr h					; (8)
		.loop 7
			pop b					; (12)
			mov m, c					; (8)
			INR l					; (8)
			mov m, b					; (8)
			INR l					; (8)
		.endloop
			pop b					; (12)
			mov m, c					; (8)
			INR l					; (8)
			mov m, b					; (8)
			dcr h					; (8) (704)		
			.endmacro
