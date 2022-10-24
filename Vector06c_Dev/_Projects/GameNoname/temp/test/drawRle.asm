;----------------------------------------------------------------
; draw an RLE compressed picture
; input: hl - sprite data
; use: A, HL, de, B

;			to draw image faster, use 0 color index as the most popular color in the image
;			verticalLineScreenAddr1 - the lowest addr of the line, x addr, y addr
;			verticalLineScreenAddr2 - gaps are allowed between lines, lines don't have to be lined up
;			REPEAT_CODE - %RRRRRRRC
;						RRRRRRR - repeater (0-127), 
;						if C = 1, the next RRRRRRR data bytes are unique
;						if C = 0, the next byte needs to be duplicated RRRRRRR times
			DRAW_RLE_END_LINE	= 0 ; the end of the line code
			DRAW_RLE_END		= 0 ; the end of drawing code

; data: 	.dw verticalLineScreenAddr1
;			.db REPEAT_CODE, data, REPEAT_CODE, data,..., DRAW_RLE_END_LINE,
;           ...
;			.dw verticalLineScreenAddr2
;			.db REPEAT_CODE, data, REPEAT_CODE, data,..., DRAW_RLE_END_LINE,
;			.db DRAW_RLE_END,

DrawRLE:
@nextLine:
            ; de - screen addr
			mov a, m
			ora a
			rz       ; if repeat x == 0, stop  
			mov d, a
			inx h
			mov e, m
			inx h
@nextChunk:
			; a - repeat code
			mov a, m
			inx h
			ora a 			; if repeat code == 0, go to the next  line; also reset CY flag
			jz @nextLine
			rar		
			mov b, a		; b - counter
			jnc @dupBytes

			; a - data, b - counter
@nextUniqueByte:
			mov a, m
			inx h
			stax d
			inr e
			dcr b
			jnz @nextUniqueByte
			jmp @nextChunk

@dupBytes:
            mov a, m
			inx h
			ora a ; if data = 0, do not draw, just advance L
			jz @skipBytes

			xchg
@nextDupByte:
			mov m, a
			inr l
			dcr b
			jnz @nextDupByte
			xchg
			jmp @nextChunk
@skipBytes:
			; if a == 0, do not draw, just advance to the pos
			add e ;mov a, e
			add b
			mov e, a
			jmp @nextChunk	
			.closelabels