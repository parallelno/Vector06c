
test_text_data:
			.byte 1, 2, 3, 3, 2, 2, 1, 1, 3, 2, 1, 0,

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
			.word test_font_A, test_font_B, test_font_C

			.word 0 ; a safety pair of bytes to prevent data corruption by the interuption subroutine
test_font_A:
			; A ($01)
			.word 0 ; a posXY offset
			.word %10001000
			.word %10001000
			.word %10001000
			.word %11111000
			.word %10001000
			.word %01010000
			.word %01010000
			.word %01010000
			.word %01010000
			.word %00100000
			.word %00100000
			.word 6<<8, ; a posXY offset to the next char. usually width+spacing


			.word 0 ; a safety pair of bytes to prevent data corruption by the interuption subroutine
test_font_B:
			; B ($02)
			.word -2 ; a posXY offset
			.word %10000000
			.word %10000000
			.word %10110000
			.word %11001000
			.word %10001000
			.word %10001000
			.word %10001000
			.word %10001000
			.word %11001000
			.word %10110000
			.word 6<<8, ; a posXY offset to the next char. usually width+spacing


			.word 0 ; a safety pair of bytes to prevent data corruption by the interuption subroutine
test_font_C:
			; C ($03)
			.word 0 ; a posXY offset
			.word %10000000
			.word %10000000
			.word %10000000
			.word %10000000
			.word %10000000
			.word %10000000
			.word %10000000
			.word %00000000
			.word %10000000
			.word %10000000
			.word 2<<8, ; a posXY offset to the next char. usually width+spacing


			; D ($04)
			.byte %11111100
			.byte %10000010
			.byte %10000010
			.byte %10000010
			.byte %10000010
			.byte %10000010
			.byte %11111100
			.byte 0
			; E ($05)
			.byte %11111100
			.byte %10000010
			.byte %10000000
			.byte %11111000
			.byte %10000000
			.byte %10000010
			.byte %11111100
			.byte 0
			; F ($06)
			.byte %11111100
			.byte %10000010
			.byte %10000000
			.byte %11111000
			.byte %10000000
			.byte %10000000
			.byte %10000000
			.byte 0
			; rest of the alphabet
			.storage 8*$29, 0
			; 0 ($30)
			.byte %01111100
			.byte %10000110
			.byte %10001010
			.byte %10010010
			.byte %10100010
			.byte %11000010
			.byte %01111100
			.byte 0
			; 1 ($31)
			.byte %00011000
			.byte %00101000
			.byte %01001000
			.byte %00001000
			.byte %00001000
			.byte %00001000
			.byte %00011100
			.byte 0
			; 2 ($32)
			.byte %01111100
			.byte %10000010
			.byte %00001100
			.byte %01110000
			.byte %10000000
			.byte %10000000
			.byte %11111110
			.byte 0
			; 3 ($33)
			.byte %01111100
			.byte %10000010
			.byte %00000010
			.byte %00001100
			.byte %00000010
			.byte %10000010
			.byte %01111100
			.byte 0
			; 4 ($34)
			.byte %00011100
			.byte %00100100
			.byte %01000100
			.byte %10000100
			.byte %11111110
			.byte %00000100
			.byte %00000100
			.byte 0
			; 5 ($35)
			.byte %11111110
			.byte %10000000
			.byte %10000000
			.byte %11111100
			.byte %00000010
			.byte %10000010
			.byte %01111100
			.byte 0
			; 6 ($36)
			.byte %01111100
			.byte %10000010
			.byte %10000000
			.byte %11111100
			.byte %10000010
			.byte %10000010
			.byte %01111100
			.byte 0
			; 7 ($37)
			.byte %01111110
			.byte %10000010
			.byte %00000100
			.byte %00001000
			.byte %00010000
			.byte %00100000
			.byte %00100000
			.byte 0
			; 8 ($38)
			.byte %01111100
			.byte %10000010
			.byte %10000010
			.byte %01111100
			.byte %10000010
			.byte %10000010
			.byte %01111100
			.byte 0
			; 9 ($39)
			.byte %01111100
			.byte %10000010
			.byte %10000010
			.byte %11111110
			.byte %00000100
			.byte %00001000
			.byte %01110000
			.byte 0
			; heart ($3A)
			.byte %01101100
			.byte %11111010
			.byte %11111010
			.byte %11111110
			.byte %01111100
			.byte %00111000
			.byte %00010000
			.byte 0