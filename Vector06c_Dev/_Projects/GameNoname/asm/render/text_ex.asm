/*
room_test:
			; TODO: test
			lxi b, 20
			lxi h, test_text_data
			
			CALL_RAM_DISK_FUNC(draw_text_ex, __RAM_DISK_S_FONT)
			
			;NOP_(16)
			lxi b, 5
			lxi h, test_text_data2
			CALL_RAM_DISK_FUNC(draw_text_ex, __RAM_DISK_S_FONT)
			ret

; TODO: test
test_text_data:
.encoding "screencode", "mixed"
			.text "The quick brown fox jumps over the lazy dog"
			.byte 0
test_text_data2:
.encoding "screencode", "mixed"
			.text "One Ring to Rule them all"
			.byte 0,
; TODO: end test
*/

; input:
; hl - text addr
; bc - screen pos
draw_text_ex:
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

			; add a posXY offset
			pop b
			dad b

			; calc a pxl shift
			mvi a, %111
			ana h
			; make a ptr to skip_dad dad h
			rlc
			adi <@skip_dad_ptrs
			mov e, a
			mvi a, >@skip_dad_ptrs
			aci 0
			mov d, a

			; read skip_ptr
			xchg
			mov a, m
			inx h
			mov h, m
			mov l, a
			shld @skip_dad + 1

			; de - scr pos
			; posXY to scr addr
			mvi a, %11111000
			ana d
			RRC_(3)
			adi >SCR_BUFF1_ADDR
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
			pop h ; restore posXY
			; advance a posXY to the next char
			dad b
			mov b, h
			mov c, l
			pop h
			jmp draw_text_ex

@skip_dad_ptrs:
			.word @shift0, @shift1,	@shift2, @shift3, @shift4, @shift5, @shift6, @shift7