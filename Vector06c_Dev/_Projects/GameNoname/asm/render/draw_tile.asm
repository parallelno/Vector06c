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
			shld @restore_sp + 1
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
; SP - sprite data
; E - contains a bit mask xxxxECA8
;   "8" bit - draw in $8000 buffer
;   "A" bit - draw in $A000 buffer etc.
; D - counter of screen buffers
@loop:
			mov a, e
			rrc
			mov e, a
			jnc @erase_tile_buf

			DRAWTILE16x16_DRAW_BUF()
			jmp @next_buf

@erase_tile_buf:
			DRAWTILE16x16_ERASE_BUF()
@next_buf:
			; move X to the next scr buff
			mvi a, $20
			add h
			mov h, a

			dcr d
			jnz @loop
@restore_sp:		
			lxi sp, TEMP_ADDR
			ret
draw_tile_16x16_end:
			
			
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
			A_TO_ZERO(NULL)
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
			shld @restore_sp + 1
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
; SP - sprite data
; E - contains a bit mask xxxxECA8
;   "8" bit - draw in $8000 buffer
;   "A" bit - draw in $A000 buffer etc.
; D - counter of screen buffers

@loop:
			mvi a, >SCR_BUFF1_ADDR
			cmp h
			jnc @skip_buf

			mov a, e
			rrc
			mov e, a
			jnc @erase_tile_buf

			DRAWTILE16x16_DRAW_BUF()
			jmp @next_buf

@erase_tile_buf:
			DRAWTILE16x16_ERASE_BUF()
@next_buf:
			; move X to the next scr buff
			mvi a, $20
			add h
			mov h, a

			dcr d
			jnz @loop
@restore_sp:		
			lxi sp, TEMP_ADDR
			ret

@skip_buf:
			mov a, e
			rrc
			mov e, a
			jnc @next_buf
			DRAWTILE16x16_DRAW_BUF_SKIP()
			jmp @next_buf

.macro DRAWTILE16x16_DRAW_BUF_SKIP()
		.loop 16
			pop b
		.endloop
.endmacro
*/

; draws a tile into the screen, a backbuffer, a backbuffer2
; in:
; c - tile_idx
; out:
; bc - tile screen addr
draw_tile_16x16_buffs: 
			; calc tile gfx ptr
			mov l, c
			mvi h, 0
			lxi d, room_tiles_gfx_ptrs
			dad h
			dad d
			mov d, c
			; d - tile_idx
			; read a tile gfx ptr
			mov c, m
			inx h
			mov b, m

			; calc tile scr addr
			; d - tile_idx
			mvi a, %11110000
			ana d
			mov e, a
			; e - scr Y
			mvi a, %00001111
			ana d
			rlc
			adi >SCR_BUFF0_ADDR
			mov d, a
			; bc - a tile gfx ptr
			; de - a tile screen addr
			push b
			push d
			; draw a tile on the screen
			lda level_ram_disk_s_gfx
			CALL_RAM_DISK_FUNC_BANK(draw_tile_16x16)
			pop d
			pop b
			push b
			push d
			; draw a tile in the back buffer
			lda level_ram_disk_s_gfx
			ori __RAM_DISK_M_BACKBUFF | RAM_DISK_M_AF
			CALL_RAM_DISK_FUNC_BANK(draw_tile_16x16)
			pop d
			pop b
			push d
			; draw a tile in the back buffer2
			lda level_ram_disk_s_gfx
			ori __RAM_DISK_M_BACKBUFF2 | RAM_DISK_M_AF
			CALL_RAM_DISK_FUNC_BANK(draw_tile_16x16)

			pop b
			ret