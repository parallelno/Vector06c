; return : 
; a - random byte
Rnd8:
			lda interruptionCounter+1
			adc a
			ral
			xri %00101101
			sta interruptionCounter+1
			ret

; uses:
; hl, a
ClearScr:
			lxi h, $8000
			xra a
@loop:
			mov m, a
			inx h
			cmp h
			jnz @loop
			ret
			.closelabels
; clear the buffer
; input:
; hl - addr to clear
; bc - length
; uses:
; a
ClearMem:
@loop:
			xra a
			mov m, a
			inx h
			dcx b
			ora c
			ora b
			jnz @loop
			ret
			.closelabels


INIT_COLOR_IDX = 15
; Set palette
; in: hl - the addr of the last item in the palette
; use: hl, b, a
SetPalette:
			hlt
			mvi	a, PORT0_OUT_OUT
			out	0
			mvi	b, INIT_COLOR_IDX

@loop:		mov	a, b
			out	2
			mov a, m
			out $0c
			push psw
			pop psw
			push psw
			pop psw
			dcx h
			dcr b
			out $0c

			jp	@loop
			ret
			.closelabels

		