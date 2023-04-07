
; input:
; hl - text addr
; bc - screen pos
draw_text2:
			; get a char code
			mov e, m
			; return if its code 0
			xra a
			cmp e
			rz
			mov d, a ; d = 0
			inx h
			push h ; preserve the text data ptr
			push b ; preserve posXY

			; get a char gfx pptr
			xchg
			dad h
			lxi d, test_font2 - ADDR_LEN ; because there is no char_code = 0
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

			; add a posXY offset
			pop b
			dad b

			; calc a pxl shift
			mvi a, %111
			ana h
			; make a JMP_4 ptr to a draw routine from it
			RLC_(2)
			adi <@draw_funcs
			mov e, a
			mvi a, >@draw_funcs
			aci 0
			mov d, a
			; posXY to scr addr
			mvi a, %11111000
			ana h
			RRC_(3)
			adi >SCR_BUFF1_ADDR
			mov h, a
			xchg
			pchl

@advancePos:
			; bc - a pos offset
@restoreSP:
			lxi sp, TEMP_ADDR
			pop h ; restore posXY
			; advance a posXY to the next char
			dad b
			mov b, h
			mov c, l
			pop h
			jmp draw_text2

@draw_funcs:
			JMP_4(@shift0)
			JMP_4(@shift1)
			JMP_4(@shift2)
			JMP_4(@shift3)
			JMP_4(@shift4)
			JMP_4(@shift5)
			JMP_4(@shift6)
			JMP_4(@shift7)

@shift0:	DRAW_CHAR2(0)
@shift1:	DRAW_CHAR2(7)
@shift2:	DRAW_CHAR2(6)
@shift3:	DRAW_CHAR2(5)
@shift4:	DRAW_CHAR2(4)
@shift5:	DRAW_CHAR2(3)
@shift6:	DRAW_CHAR2(2)
@shift7:	DRAW_CHAR2(1)

.macro DRAW_CHAR2(shift)
@loop:
			; de - scr addr
			; shift a pair of gfx bytes
			pop b
			; check if it is the end of the char gfx
			xra a
			ora b
			jnz @advancePos
		.if shift > 0
			mov l, c
			mov h, b
			DAD_H(shift)
			ldax d
			ora h
			stax d
			inr d
			ldax d
			ora l
			stax d
			dcr d
		.endif
		.if shift == 0
			ldax d
			ora c
			stax d
		.endif
			inr e
			jmp @loop

.endmacro


test_font2:
			.word __font_A, __font_p, __font_i
