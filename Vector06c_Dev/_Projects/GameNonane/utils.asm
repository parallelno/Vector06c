
ClearScr:
			lxi h, $8000
			xra A
@loop:
			mov m, a
			inx h
			cmp h
			jnz @loop
			ret
			.closelabels

INIT_COLOR_IDX = 15
; Set palette
; in: hl - the addr of the last item in the palette
; use: hl, b, a
SetPalette:
			MVI		A, PORT0_OUT_OUT
			OUT		0
			MVI		B, INIT_COLOR_IDX

@loop:		MOV		A, B
			OUT		2
			MOV		A,M
			OUT     $0C
	PUSH PSW
	POP  PSW
	PUSH PSW
	POP  PSW
	dcx h
	DCR  b
	OUT     $0C

			JP		@loop
			ret
			.closelabels

		