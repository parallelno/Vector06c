
; common chunk of code to restore SP and 
; return a couple of parameters within HL, C
ret_ram_disk__:
restore_sp_ram_disk__:
			lxi sp, TEMP_ADDR
			ret
			

; clear a N*16 pxs square on the screen,
; it clears 3 screen buffers from de addr and further
; ex. CALL_RAM_DISK_FUNC(__erase_sprite, __RAM_DISK_S_BACKBUFF | __RAM_DISK_M_ERASE_SPRITE | RAM_DISK_M_8F)
; in:
; de - scr addr
; hl - width, height
;	width:
;		00 - 8pxs,
;		01 - 16pxs,
;		10 - 24pxs,
;		11 - 32pxs,
__RAM_DISK_M_ERASE_SPRITE = RAM_DISK_M

__erase_sprite: 
			mov a, h
			mvi h, 0
			xchg
			; d = 0
			; e - height
			; hl - scr addr
			dad d
			xchg
			; de - scr addr
			; h - 0
			; l - height
			; a - width (0-3)

			; store SP
			mov l, h
			dad sp
			shld restore_sp_ram_disk__ + 1

			xchg
			; hl - scr addr

			lxi b, 0				; filler
			lxi d, $2000 			; to move the next scr buff

			rrc
			jc @width16or32
			rrc
			jc @width24
			jmp @width8
@width16or32:
			rrc
			jnc @width16

@width32:
			ERASE_SPRITE_SP_COL()
@width24:
			ERASE_SPRITE_SP_COL()
@width16:
			ERASE_SPRITE_SP_COL()
@width8:
			ERASE_SPRITE_SP_COL(false)
			jmp ret_ram_disk__
			

.macro ERASE_SPRITE_SP_COL(next_column = true)

	; TODO: issue. there is an problem with this macro
	; when it erases the last two bytes with PUSH B
	; an interruption call erases two more bytes below it.
	; there is one solution balow, but it costly
	; think of a better solution.
	col .var 0
	.loop 3
			col = col+1
			sphl
			PUSH_B(8)
		.if next_column == true || col < 3
			dad d
		.endif
	.endloop
		.if next_column == true
			; advance to the next column of the first scr buff
			mvi a, $20*5+1
			add h
			mov h, a
		.endif

/*
	col .var 0
	.loop 3
			col = col+1
			sphl
			PUSH_B(7)
		.if next_column == true || col < 3
			dad d
		.endif
	.endloop
		.if next_column == true

			; erase last two bytes without stack ops to fix the issue 
			; when the interruption func writes outside of the tile
			lxi h, (<(-$20*3))<<8 | <(-1)
			dad sp
			; hl points to the second sprite line from below in the first scr buff
			; a = $20*5+1 to advance to the next buffer
			; bc = 0
			; de = $2000
			mvi m, 0
			dcr l
			mvi m, 0
			; move to the seconf scr buff
			dad d
			mvi m, 0
			inr l
			mvi m, 0
			; move to the seconf scr buff
			dad d
			mvi m, 0
			dcr l
			mvi m, 0			

			; advance to the next column of the first scr buff
			lxi h, 
			dad sp
			; 144
			
			;w16 cc 1092
			;w24 cc 1524
		.endif
*/

				
.endmacro
			
