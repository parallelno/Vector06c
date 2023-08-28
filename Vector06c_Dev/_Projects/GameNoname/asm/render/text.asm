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


; draw an FPS counter every second on the screen at FPS_SCR_ADDR addr
; works only in the interruption func and in the
; main program when the ram-disk is dismount
; in:
; A - fps
; uses:
; BC, DE, HL
FPS_SCR_ADDR = $bdfb
draw_fps:
			lhld DrawText_restoreSP+1
			shld @tmp_restore_sp
			;lxi h, @fps_text
			;call int_to_ascii_hex
			mov l, a
			mvi h, 0
			lxi d, @fps_text_hi
			call int8_to_ascii_dec	

			lxi h, @fps_text
			lxi b, FPS_SCR_ADDR
			call draw_text
			lhld @tmp_restore_sp
			shld DrawText_restoreSP+1
			ret

@fps_text_hi:
			.byte $30
@fps_text:
			.byte $30, $30, 0
@tmp_restore_sp:
            .word TEMP_ADDR

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
			mvi d, 0 // TODO: mov d, a ;optimization
			push h

			; get the char gfx addr
			xchg
			; code * 8
			dad h
			dad h
			dad h
			lxi d, test_font
			dad d
			xchg

			; store SP
			lxi h, 0
			dad sp
			shld DrawText_restoreSP + 1
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
DrawText_restoreSP:
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
			; space ($00)
			.byte 0,0,0,0
			.byte 0,0,0,0
			; A ($01)
			.byte %00011100
			.byte %00100010
			.byte %01000001
			.byte %01111111
			.byte %01000001
			.byte %01000001
			.byte %01000001
			.byte 0
			; B ($02)
			.byte %01111110
			.byte %01000001
			.byte %01000001
			.byte %01111111
			.byte %01000001
			.byte %01000001
			.byte %01111110
			.byte 0
			; C ($03)
			.byte %00011110
			.byte %00100001
			.byte %01000000
			.byte %01000000
			.byte %01000000
			.byte %01000001
			.byte %00111110
			.byte 0	
			; D ($04)
			.byte %01111110
			.byte %01000001
			.byte %01000001
			.byte %01000001
			.byte %01000001
			.byte %01000001
			.byte %01111110
			.byte 0	
			; E ($05)
			.byte %01111110
			.byte %01000001
			.byte %01000000
			.byte %01111100
			.byte %01000000
			.byte %01000001
			.byte %01111110
			.byte 0	
			; F ($06)
			.byte %01111110
			.byte %01000001
			.byte %01000000
			.byte %01111100
			.byte %01000000
			.byte %01000000
			.byte %01000000
			.byte 0	
			; rest of the alphabet
			.storage 8*$29, 0
			; 0 ($30)
			.byte %00111110
			.byte %01000011
			.byte %01000101
			.byte %01001001
			.byte %01010001
			.byte %01100001
			.byte %00111110
			.byte 0	
			; 1 ($31)
			.byte %00001100
			.byte %00010100
			.byte %00100100
			.byte %00000100
			.byte %00000100
			.byte %00000100
			.byte %00001110
			.byte 0	
			; 2 ($32)
			.byte %00111110
			.byte %01000001
			.byte %00000110
			.byte %00111000
			.byte %01000000
			.byte %01000000
			.byte %01111111
			.byte 0	
			; 3 ($33)
			.byte %00111110
			.byte %01000001
			.byte %00000001
			.byte %00000110
			.byte %00000001
			.byte %01000001
			.byte %00111110
			.byte 0	
			; 4 ($34)
			.byte %00001110
			.byte %00010010
			.byte %00100010
			.byte %01000010
			.byte %01111111
			.byte %00000010
			.byte %00000010
			.byte 0	
			; 5 ($35)
			.byte %01111111
			.byte %01000000
			.byte %01000000
			.byte %01111110
			.byte %00000001
			.byte %01000001
			.byte %00111110
			.byte 0	
			; 6 ($36)
			.byte %00111110
			.byte %01000001
			.byte %01000000
			.byte %01111110
			.byte %01000001
			.byte %01000001
			.byte %00111110
			.byte 0	
			; 7 ($37)
			.byte %00111111
			.byte %01000001
			.byte %00000010
			.byte %00000100
			.byte %00001000
			.byte %00010000
			.byte %00010000
			.byte 0	
			; 8 ($38)
			.byte %00111110
			.byte %01000001
			.byte %01000001
			.byte %00111110
			.byte %01000001
			.byte %01000001
			.byte %00111110
			.byte 0	
			; 9 ($39)
			.byte %00111110
			.byte %01000001
			.byte %01000001
			.byte %01111111
			.byte %00000010
			.byte %00000100
			.byte %00111000
			.byte 0	
			; heart ($3A)
			.byte %00110110
			.byte %01111101
			.byte %01111101
			.byte %01111111
			.byte %00111110
			.byte %00011100
			.byte %00001000
			.byte 0				