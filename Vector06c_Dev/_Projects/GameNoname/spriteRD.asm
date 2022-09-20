
; sharetable chunk of code to restore SP and 
; return a couple of parameters within HL, C
Ret_ramDisk__:
restoreSP_ramDisk__:
			lxi sp, TEMP_ADDR
			;RAM_DISK_OFF()
restoreRet_ramDisk__:
			jmp TEMP_ADDR
			.closelabels

; clear a N*16 pxs square on the screen,
; it clears 3 screen buffers from de addr and further
; in:
; de - scr addr
; hl - width, height
;	width:
;		00 - 8pxs,
;		01 - 16pxs,
;		10 - 24pxs,
;		11 - 32pxs,
__EraseSpriteSP:
			mov b, h
			; adjust Y
			mov a, e
			add l
			; because push decrements SP before store RP
			inr a
			mov e, a

			;RAM_DISK_ON(RAM_DISK0_B2_STACK_B2_8AF_RAM)
			; store ret addr
			pop h
			shld restoreRet_ramDisk__ + 1
			; store SP
			lxi h, 0
			dad sp
			shld restoreSP_ramDisk__ + 1

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
			EREASE_SPRITE_SP_COL()
@width24:
			EREASE_SPRITE_SP_COL()
@width16:
			EREASE_SPRITE_SP_COL()
@width8:
			EREASE_SPRITE_SP_COL(false)
			jmp Ret_ramDisk__
			.closelabels

.macro EREASE_SPRITE_SP_COL(nextColumn = true)
	col .var 0
	.loop 3
			col = col+1
			sphl
			PUSH_B(8)
		.if nextColumn == true || col < 3
			dad d
		.endif
	.endloop
		.if nextColumn == true
			; advance to the next column
			mvi a, $20*5+1
			add h
			mov h, a
		.endif
.endmacro
			.closelabels
