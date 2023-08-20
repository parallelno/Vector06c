
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
			mov b, h
			; adjust Y
			mov a, e
			add l
			mov e, a

			; store SP
			lxi h, 0
			dad sp
			shld restore_sp_ram_disk__ + 1

			xchg

			mov a, b

			; (backbuff addr) = BC
			lxi b, 0
			; to move the next scr buff
			lxi d, $2000

			rrc
			jc @width16or32
			rrc
			jc @width24
			jnc @width8
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
			; advance to the next column
			mvi a, $20*5+1
			add h
			mov h, a
		.endif
.endmacro
			
