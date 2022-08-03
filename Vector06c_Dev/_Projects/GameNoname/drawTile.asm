;----------------------------------------------------------------
; draw a tile (16x16 pixels)
; in:
; BC	sprite data
; DE	screen address (x,y)
; use: A, HL, SP

; screen format
; 1st screen buff : draw 16 bites down, step one byte right, draw 16 bytes up.
; 2nd screen buff : same
; 3rd screen buff : same
; 4rd screen buff : same
		
DrawTile16x16:
			; store SP
			LXI		H, 0			; (12)
			DAD		SP				; (12)
			SHLD	@restoreSP + 1	; (20)
			; SP = BC
			MOV		H, B			; (8)
			MOV		L, C			; (8)
			; A contains a bit mask xxxxECA8, where the "8" bit says if a sprite needs to draw in $8000 buffer, the "A" bit in charge of $A000 buffer etc.
			MOV		A, M			; (8)
			; think how to make HL=HL+3 faster
			INX		H				; (8)
			INX		H				; (8)
			INX		H				; (8)
			SPHL					; (8)
			XCHG					; (4)
			MOV		E, A			; (8)
			MVI		D, 4			; (8)
									; (120) total

; HL - 1st screen buff XY
; SP - sprite data
; E - contains a bit mask xxxxECA8, where the "8" bit says if a sprite needs to draw in $8000 buffer, the "A" bit in charge of $A000 buffer etc.
; D - counter of screen buffers
@loop:
			MOV		A, E
			RRC
			MOV		E, A
			JNC		@doNotDraw

			DRAW_TILE_16x16_LINE()

@doNotDraw:	
			MVI		A, 32
			ADD		H
			MOV		H, A

			DCR		D
			JNZ		@loop

@restoreSP:	LXI		SP, TEMP_ADDR	; restore SP (12)
			RET
			.closelabels
			
			.macro DRAW_TILE_16x16_LINE()
		.loop 7
			POP B					; (12)
			MOV M,C					; (8)
			DCR L					; (8)
			MOV M,B					; (8)
			DCR L					; (8)
		.endloop
			POP B					; (12)
			MOV M,C					; (8)
			DCR L					; (8)
			MOV M,B					; (8)

			INR H					; (8)
		.loop 7
			POP B					; (12)
			MOV M,C					; (8)
			INR L					; (8)
			MOV M,B					; (8)
			INR L					; (8)
		.endloop
			POP B					; (12)
			MOV M,C					; (8)
			INR L					; (8)
			MOV M,B					; (8)
			DCR H					; (8) (704)		
			.endmacro
