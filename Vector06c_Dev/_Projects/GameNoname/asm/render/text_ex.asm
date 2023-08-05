; draw a text with kerning. blend func - OR
; input:
; hl - text addr
; bc - pos_xy
draw_text_ex_scr0:
			mvi a, >SCR_BUFF0_ADDR
			jmp draw_text_ex
draw_text_ex_scr3:
			mvi a, >SCR_BUFF3_ADDR
			jmp draw_text_ex
draw_text_ex_scr2:
			mvi a, >SCR_BUFF2_ADDR
			jmp draw_text_ex
draw_text_ex_scr1:
			mvi a, >SCR_BUFF1_ADDR
; draw a text with kerning. blend func - OR
; a - scr buff high addr, ex: >SCR_BUFF0_ADDR
draw_text_ex:
			sta @scr_buff_addr+1
@next_char:			
			; get a char code
			mov e, m
			; return if its code 0
			xra a
			cmp e
			rz
			mov d, a ; d = 0
			inx h
			push h ; preserve the text data ptr
			push b ; preserve pos_xy

			; get a char gfx pptr
			xchg
			dad h
			lxi d, font_gfx_ptrs - ADDR_LEN ; because there is no char_code = 0
			dad d
			; hl points to char gfx ptr
			; get a char gfx ptr
			mov e, m
			inx h
			mov d, m

			; preserve SP
			lxi h, 0
			dad sp
			shld @restoreSP + 1
			xchg
			; hl points to a char gfx
			sphl
			mov h, b
			mov l, c
			; hl - scr pos

			; add a pos_xy offset
			pop b
			dad b

			; calc a pxl shift
			mvi a, %111
			ana h
			; make a ptr to skip_dad dad h
			; de = a * 2 + @skip_dad_ptrs
			DE_TO_AX2_PLUS_INT16(@skip_dad_ptrs)

			; read skip_ptr
			xchg
			mov a, m
			inx h
			mov h, m
			mov l, a
			shld @skip_dad + 1

			; de - scr pos
			; pos_xy to scr addr
			mvi a, %11111000
			ana d
			RRC_(3)
@scr_buff_addr:			
			adi TEMP_ADDR;>SCR_BUFF1_ADDR
			mov d, a

			; draw a char
@loop:
			; de - scr addr
			; shift a pair of gfx bytes
			pop b
			; check if it is the end of the char gfx
			xra a
			ora b
			jnz @advancePos
			mov l, c
			mov h, b
@skip_dad:	jmp TEMP_ADDR

@shift1:	dad h
@shift2:	dad h
@shift3:	dad h
@shift4:	dad h
@shift5:	dad h
@shift6:	dad h
@shift7:	dad h

			ldax d
			ora h
			stax d
			inr d
			ldax d
			ora l
			stax d
			dcr d
			inr e
			jmp @loop

@shift0:
			ldax d
			ora c
			stax d
			inr e
			jmp @loop			

@advancePos:
			; bc - a pos offset
@restoreSP:
			lxi sp, TEMP_ADDR
			pop h ; restore pos_xy
			; advance a pos_xy to the next char
			dad b
			mov b, h
			mov c, l
			pop h
			jmp @next_char

@skip_dad_ptrs:
			.word @shift0, @shift1,	@shift2, @shift3, @shift4, @shift5, @shift6, @shift7