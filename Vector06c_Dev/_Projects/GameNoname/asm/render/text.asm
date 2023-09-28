/*
; 8-bit integer to ASCII (hex)
; in:
; a - byte to convert
; hl - text ptr (2 bytes buffer)
; modified:
; bc, de, a

int_to_ascii_hex:
			mov e, a ; tmp
			lxi b, $0f30 ; $30 - char 0 code
			
			ana b
			cpi $0a ; to adjust chars codes
			jc @below10
			sui $39 ; adjust a char code
@below10:
			add c
			inx h
			mov m, a
			dcx h

			mov a, e
			RRC_(4)
			ana b
			cpi $0a ; to adjust chars codes
			jc @below10a
			sui $39 ; adjust a char code
@below10a:
			add c
			mov m, a
			ret
*/
; 8-bit integer to ASCII (decimal)
; in: 
; hl - number to convert
; de - location of ASCII string (3 bytes buffer)
; use:
; bc, a
int16_to_ascii_dec:
			LXI_B( -10000)
			call int8_to_ascii_dec_decr
			lxi b, 10000
			dad b
			LXI_B( -1000)
			call int8_to_ascii_dec_decr
			lxi b, 1000
			dad b
int8_to_ascii_dec:
			LXI_B( -100)
			call int8_to_ascii_dec_decr
			lxi b, 100
			dad b
			LXI_B( -10)
			call int8_to_ascii_dec_decr
			mvi a, 10 + $30; '0';
			add l
			stax d
			ret
int8_to_ascii_dec_decr:
			mvi	a, $30 - 1; '0'-1
@loop:		inr	a
			dad	b
			jc @loop
			stax d
			inx	d
			ret


; draw int8 as an acii text
; in:
; bc - scr addr
; hl - int8 ptr
draw_text_int8_ptr:
			mov l, m
; in:
; l - int8
draw_text_int8:	
			mvi h, 0
			lxi d, draw_text_buff_3
			push b
			call int8_to_ascii_dec
			pop b
			; bc - text scr addr
			lxi h, draw_text_buff_2
			jmp draw_text

; draw int8 as an acii text
; in:
; bc - scr addr
; hl - int16
draw_text_int16:
			lxi d, draw_text_buff_5
			push b
			call int16_to_ascii_dec
			pop b
			; bc - text scr addr
			lxi h, draw_text_buff_5
			jmp draw_text

; asci text buffer with a nul terminator
draw_text_buff_5:
			.byte $30, $30
draw_text_buff_3:
			.byte $30,
draw_text_buff_2:
			.byte $30, $30, 0
; input:
; hl - text addr
; bc - screen addr
draw_text:
			; get a char
			mov e, m
			; return if its code 0
			A_TO_ZERO(NULL_BYTE)
			cmp e
			rz
			inx h
			; a = 0
			mov d, a
			push h

			; get the char gfx addr
			xchg
			; code * 8
			dad h
			dad h
			dad h
			lxi d, test_font - 384 ; 384 - to exclude alhabet and leave only numbers
			dad d
			xchg

			; store SP
			lxi h, 0
			dad sp
			shld draw_text_restore_sp + 1
			; HL - char gfx addr
			xchg
			; DE - scr addr
			mov d, b
			mov e, c
			; load BC to prevent an interuption func to corrupt the font data
			mov c, m
			inx h
			mov b, m
			inx h
			sphl
			xchg
			DRAW_CHAR()
draw_text_restore_sp:
			lxi sp, TEMP_ADDR
			; move XY to the next char pos
			lxi b, $0106
			dad b
			mov b, h
			mov c, l

			pop h
			jmp draw_text

.macro DRAW_CHAR()
	line .var 0
	.loop 4
			line = line + 1
		.if line > 1
			pop b
		.endif
			mov m, c
		.if line < 4
			dcr l
			mov m, b
			dcr l
		.endif
	.endloop
.endmacro


test_font:
/*
			; space ($00)
			.byte 0,0,0,0
			.byte 0,0,0,0
			; A ($01)
			.byte %0011100
			.byte %0100010
			.byte %1000001
			.byte %1111111
			.byte %1000001
			.byte %1000001
			.byte %1000001
			.byte 0
			; B ($02)
			.byte %1111110
			.byte %1000001
			.byte %1000001
			.byte %1111111
			.byte %1000001
			.byte %1000001
			.byte %1111110
			.byte 0
			; C ($03)
			.byte %0011110
			.byte %0100001
			.byte %1000000
			.byte %1000000
			.byte %1000000
			.byte %1000001
			.byte %0111110
			.byte 0	
			; D ($04)
			.byte %1111110
			.byte %1000001
			.byte %1000001
			.byte %1000001
			.byte %1000001
			.byte %1000001
			.byte %1111110
			.byte 0	
			; E ($05)
			.byte %1111110
			.byte %1000001
			.byte %1000000
			.byte %1111100
			.byte %1000000
			.byte %1000001
			.byte %1111110
			.byte 0	
			; F ($06)
			.byte %1111110
			.byte %1000001
			.byte %1000000
			.byte %1111100
			.byte %1000000
			.byte %1000000
			.byte %1000000
			.byte 0	
			; rest of the alphabet
			.storage 8*$29, 0
*/
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
/*
			; heart ($3A)
			.byte %0110110
			.byte %1111101
			.byte %1111101
			.byte %1111111
			.byte %0111110
			.byte %0011100
			.byte %0001000
			.byte 0				
*/