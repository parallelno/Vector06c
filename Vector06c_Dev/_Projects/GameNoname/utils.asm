.include "rnd.asm"
.include "zx0.asm"
; use:
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
; use:
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
; input: hl - the addr of the last item in the palette
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

; Set palette copied from the ram-disk
; input: 
; de - the addr of the first item in the palette
; use: 
; hl, bc, a
PALETTE_COLORS = 16

SetPaletteFromRamDisk:
			hlt
			; store sp
			lxi h, $0000
			dad sp
			shld @restoreSp+1
			; copy unpacked data into the ram_disk
			xchg
			RAM_DISK_ON()
			sphl

			mvi	a, PORT0_OUT_OUT
			out	0
			mvi e, $00
@loop:		
			pop b
			; even color
			mov	a, e
			out	2
			mov a, c
			out $0c
			xthl ; delay 24
			xthl ; delay 24
			inr e ; counter plus delay 8
			inr h ; delay 8
			dcr h ; delay 8
			out $0c
			; odd color
			mov	a, e
			out	2
			mov a, b
			out $0c
			xthl ; delay 24
			xthl ; delay 24
			inr e ; counter plus delay 8
			inr h ; delay 8
			dcr h ; delay 8		
			out $0c
			mov a, e
			cpi PALETTE_COLORS
			jnz	@loop

@restoreSp: lxi sp, TEMP_ADDR
			RAM_DISK_OFF()
			ret
			.closelabels

; Read a word from the ram-disk
; input: 
; de - data addr in the ram-disk
; use: 
; hl
; out:
; bc - data
GetWordFromRamDisk:
			; store sp
			lxi h, $0000
			dad sp
			shld @restoreSp+1
			; copy unpacked data into the ram_disk
			xchg
			RAM_DISK_ON()
			sphl
			pop b ; bc has to be used when interruptions is on

@restoreSp: lxi sp, TEMP_ADDR
			RAM_DISK_OFF()
			ret
			.closelabels

; Read copy data (max 512) from the ram-disk to ram
; input: 
; de - data addr in the ram-disk
; bc - destination addr
; a - data length / 2
; use: 
; hl
CopyDataFromRamDisk:
			; store sp
			lxi h, $0000
			dad sp
			shld @restoreSp+1
			; copy unpacked data into the ram_disk
			xchg
			mov e, a
			RAM_DISK_ON()
			mov a, e
			sphl
			mov l, c
			mov h, b
@loop:
			pop b ; bc has to be used when interruptions is on
			mov m, c
			inx h
			mov m, b
			inx h
			dcr a
			jnz @loop

@restoreSp: lxi sp, TEMP_ADDR
			RAM_DISK_OFF()
			ret
			.closelabels