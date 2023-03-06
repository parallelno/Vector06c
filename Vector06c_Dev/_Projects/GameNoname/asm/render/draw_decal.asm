;----------------------------------------------------------------
; draw a decal sprite with an alpha (8xN, 16xN pixels)
; input:
; bc - decal sprite data addr
; de - screen addr, d=[$80, $9f]
; use: a, hl, sp

; data format:
; .word - two safety bytes to prevent a data corruption by the interruption  func
; .byte - height
; .byte - width
; 		0 - one byte width,
;		1 - two bytes width,
; pixel format:
; oddLine:
; 1st screen buff : 1 -> 2
; 2nd screen buff : 4 <- 3
; 3rd screen buff : 6 <- 5
; 4rd screen buff : 8 <- 7
; y++
; evenLine:
; 4rd screen buff : 7 -> 8
; 3nd screen buff : 10 <- 9
; 2st screen buff : 12 <- 11
; 1st screen buff : 14 <- 13
; y++
; repeat for the next lines of the art data

.macro DRAW_DECAL_V_M(backward = false)
			pop b
			mov a, m
			ana e
			ora c
			mov m, a
		.if backward = false			
			inr h
		.endif
		.if backward
			dcr h
		.endif
			mov a, m
			ana d
			ora b
			mov m, a
.endmacro

draw_back_v:
			; store sp
			lxi h, $0000
			dad sp
			shld @restoreSP + 1
			; sp = BC
			mov h, b
			mov l, c
			sphl
			xchg
			; b - offset_x
			; c - offset_y
			pop b
			dad b
			pop b
			mov a, c
			dcr b
			jz @drawWidth16
@drawWidth8:
; TODO: support width = 8
			jmp @restoreSP

; hl - scr addr
; sp - pixel data
; a - height

@width16 = 2
@drawWidth16:
			; store a max Y to end the loop
			add l
			sta @maxY1+1
			sta @maxY2+1
			; store X addr to be able to restore it
			mov a, h
			adi @width16-1
			sta @scr82 + 1
			adi $20
			sta @scrA + 1
			sta @scrA2 + 1
			adi $20
			mov e, a
			adi $20

@oddLine:
			pop b ; an alpha
			mov e, c
			mov d, b
@scr8:
			DRAW_DECAL_V_M()
@scrA:		mvi h, TEMP_BYTE

			DRAW_DECAL_V_M(true)
@scrC:		mov h, e

			DRAW_DECAL_V_M(true)
@scrE:		mov h, a

			DRAW_DECAL_V_M(true)

			inr l
@maxY1:		mvi a, TEMP_BYTE
			cmp l
			jz @restoreSP

@evenLine:
			pop b ; an alpha
			mov e, c
			mov d, b
@scrE2:
			DRAW_DECAL_V_M()
@scrC2:		mov h, e

			DRAW_DECAL_V_M(true)
@scrA2:		mvi h, TEMP_BYTE

			DRAW_DECAL_V_M(true)
@scr82:		mvi h, TEMP_BYTE

			DRAW_DECAL_V_M(true)

			inr l
@maxY2:		mvi a, TEMP_BYTE
			cmp l
			jnz @oddLine

@restoreSP:
			lxi sp, TEMP_ADDR
			ret