; convert a byte into a two byte buffer fill up with ascii codes.
; in:
; a - byte
; hl - text ptr (2 bytes buffer)
; modified:
; bc, de, a

HexToAskii:
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
			rrc_(4)
			ana b
			cpi $0a ; to adjust chars codes
			jc @below10a
			sui $39 ; adjust a char code
@below10a:
			add c
			mov m, a
			ret


; draw an FPS counter every second on the screen at FPS_SCR_ADDR addr
; works only in the interruption func and in the
; main program when the ram-disk is dismount
; in:
; A - fps
; uses:
; BC, DE, HL
FPS_SCR_ADDR = $a0ff
DrawFps:
			lhld DrawText_restoreSP+1
			shld @tmpRestoreSP
			lxi h, @fpsText
			call HexToAskii

			lxi b, FPS_SCR_ADDR
			call DrawText
			lhld @tmpRestoreSP
			shld DrawText_restoreSP+1
			ret

@fpsText:
			.byte 1,1,0
@tmpRestoreSP:
            .word TEMP_ADDR

; input:
; hl - text addr
; bc - screen addr
DrawText:
			; get a char
			mov e, m
			; return if its code 0
			xra a
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
			lxi d, testFont
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
			jmp DrawText
			.closelabels
			

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


testFont:
			; space ($00)
			.byte 0,0,0,0
			.byte 0,0,0,0
			; A ($01)
			.byte %00111000
			.byte %01000100
			.byte %10000010
			.byte %11111110
			.byte %10000010
			.byte %10000010
			.byte %10000010
			.byte 0
			; B ($02)
			.byte %11111100
			.byte %10000010
			.byte %10000010
			.byte %11111110
			.byte %10000010
			.byte %10000010
			.byte %11111100
			.byte 0
			; C ($03)
			.byte %00111100
			.byte %01000010
			.byte %10000000
			.byte %10000000
			.byte %10000000
			.byte %10000010
			.byte %01111100
			.byte 0	
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