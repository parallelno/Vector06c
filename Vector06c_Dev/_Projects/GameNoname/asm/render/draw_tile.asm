;----------------------------------------------------------------
; draw a tile (16x16 pixels)
; input:
; bc - a tile gfx ptr
; de - screen addr
; use: a, hl, sp

; tile gfx format:
; .byte - a bit mask xxxxECA8, where the "8" bit says if a sprite needs to be drawn in the $8000 buffer, the "A" bit in charge of $A000 buffer etc.
; .byte 4 - needs for a counter
; screen format
; SCR_BUFF0_ADDR : draw 16 bytes down, step one byte right, draw 16 bytes up.
; SCR_BUFF1_ADDR : same
; SCR_BUFF2_ADDR : same
; SCR_BUFF3_ADDR : same

draw_tile_16x16:
			; store sp
			lxi h, $0000
			dad sp
			shld @restoreSP + 1
			; sp = BC
			mov h, b
			mov l, c
			sphl
			; get a mask and a counter
			pop b
			xchg
			mov e, c
			mov d, b

; HL - screen buff addr
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
/*
;----------------------------------------------------------------
; draw a tile (16x16 pixels) skipping SCR_BUFF0_ADDR
; input:
; bc - a tile gfx ptr
; de - screen addr
; use: a, hl, sp

; tile gfx format:
; .byte - a bit mask xxxxECA8, where the "8" bit says if a sprite needs to be drawn in the $8000 buffer, the "A" bit in charge of $A000 buffer etc.
; .byte 4 - needs for a counter
; screen format
; SCR_BUFF0_ADDR : draw 16 bytes down, step one byte right, draw 16 bytes up.
; SCR_BUFF1_ADDR : same
; SCR_BUFF2_ADDR : same
; SCR_BUFF3_ADDR : same

draw_tile_16x16_back_buff:
			; store sp
			lxi h, $0000
			dad sp
			shld @restoreSP + 1
			; sp = BC
			mov h, b
			mov l, c
			sphl
			; get a mask and a counter
			pop b
			xchg
			mov e, c
			mov d, b

; HL - screen buff addr
; sp - sprite data
; E - contains a bit mask xxxxECA8
;   "8" bit - draw in $8000 buffer
;   "A" bit - draw in $A000 buffer etc.
; D - counter of screen buffers

@loop:
			mvi a, >SCR_BUFF1_ADDR
			cmp h
			jnc @skipBuf

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

@skipBuf:
			mov a, e
			rrc
			mov e, a
			jnc @nextBuf
			DRAWTILE16x16_DRAW_BUF_SKIP()
			jmp @nextBuf

.macro DRAWTILE16x16_DRAW_BUF_SKIP()
		.loop 16
			pop b
		.endloop
.endmacro
*/