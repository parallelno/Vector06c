.include "asm\\globals\\rnd.asm"
.include "asm\\globals\\zx0.asm"

; sharetable chunk of code to restore SP
; and dismount the ram-disk
RestoreSP:
			lxi sp, TEMP_ADDR
			RAM_DISK_OFF()
			ret
			.closelabels

; clear a memory buffer
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

; clear a memory buffer using stack operations
; can be used to clear ram-disk memory as well
; input:
; bc - the last addr of a erased buffer + 1
; de - length/32 - 1
; a - ram disk activation command
; 		a = 0 to clear the main memory
; use:
; hl

; TODO: optimize. make it works without stopping (di/ei) interruptions.
.macro CLEAR_MEM_SP(disableInt)
		.if disableInt
			di
		.endif
			call ClearMemSP
		.if disableInt
			ei
		.endif			
.endmacro

ClearMemSP:
			lxi h, $0000
			dad sp
			shld @restoreSP + 1
			mov h, b
			mov l, c
			RAM_DISK_ON_BANK()
			lxi b, $0000
			sphl
			mvi a, $ff
@loop:
			push_b(16)
			dcx d
			cmp d
			jnz @loop
@restoreSP:
			lxi sp, TEMP_WORD
			RAM_DISK_OFF()
			ret
			.closelabels

ClearRamDisk:
			lxi b, $0000
			lxi d, $10000/32 - 1
			mvi a, RAM_DISK_S0
			push b
			push d
			CLEAR_MEM_SP(false)
			pop d
			pop b

			mvi a, RAM_DISK_S1
			push b
			push d
			CLEAR_MEM_SP(false)
			pop d
			pop b

			mvi a, RAM_DISK_S2
			push b
			push d
			CLEAR_MEM_SP(false)
			pop d
			pop b

			mvi a, RAM_DISK_S3
			CLEAR_MEM_SP(false)
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

; Set palette copied from the ram-disk w/o blocking interruptions
; input:
; de - the addr of the first item in the palette
; a - ram-disk activation command
; use:
; hl, bc, a
PALETTE_COLORS = 16

SetPaletteFromRamDisk:
			hlt
			; store sp
			lxi h, $0000
			dad sp
			shld RestoreSP+1
			; copy unpacked data into the ram_disk
			xchg
			RAM_DISK_ON_BANK()
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
			jmp RestoreSP
			.closelabels

; Read a word from the ram-disk w/o blocking interruptions
; input:
; de - data addr in the ram-disk
; a - ram-disk activation command
; use:
; hl
; out:
; bc - data

; TODO: optimize. make a special version of that func for accessing $8000 and higher with a direct access
GetWordFromRamDisk:
			; store sp
			lxi h, $0000
			dad sp
			shld RestoreSP+1
			; copy unpacked data into the ram_disk
			xchg
			RAM_DISK_ON_BANK()
			sphl
			pop b ; bc has to be used when interruptions is on
			jmp RestoreSP
			.closelabels

;========================================
; copy a buffer into the ram-disk.
; if interruptions are ON, it corrupts a pair of bytes at target addr-2 !!!
; input:
; de - source addr + data length
; hl - target addr + data length
; bc - buffer length / 2
; a - ram-disk activation command
; use:
; all
CopyToRamDisk:
			shld @restoreTargetAddr+1
			; store sp
			lxi h, $0000
			dad sp
			shld @restoreSP+1
			RAM_DISK_ON_BANK()
@restoreTargetAddr:
			lxi h, TEMP_WORD
			sphl
			xchg
@loop:
			COPY_TO_RAM_DISK(1)
			dcx b
			mov a, b
			ora c
			jnz @loop

@restoreSP:
			lxi sp, TEMP_ADDR
			RAM_DISK_OFF()
			ret

.macro COPY_TO_RAM_DISK(count)
		.loop count
			dcx h
			mov d, m
			dcx h
			mov e, m
			push d
		.endloop
.endmacro

;========================================
; copy a buffer into the ram-disk.
; if interruptions are ON, it corrupts a pair of bytes at target addr-2 !!!
; input:
; de - source addr + data length
; hl - target addr + data length
; bc - buffer length / 32
; a - ram-disk activation command
; use:
; all
CopyToRamDisk32:
			shld @restoreTargetAddr+1
			; store sp
			lxi h, $0000
			dad sp
			shld @restoreSP+1
			RAM_DISK_ON_BANK()
@restoreTargetAddr:
			lxi h, TEMP_WORD
			sphl
			xchg
@loop:
			COPY_TO_RAM_DISK(16)
			dcx b
			mov a, b
			ora c
			jnz @loop

@restoreSP:
			lxi sp, TEMP_ADDR
			RAM_DISK_OFF()
			ret

; Copy data (max 512) from the ram-disk to ram w/o blocking interruptions
; input:
; h - ram-disk activation command
; l - data length / 2
; de - data addr in the ram-disk
; bc - destination addr

; TODO: optimize. check if it is more efficient to copy a data stored
; in $8000 and higher with a direct access like mov
CopyFromRamDisk:
			; store sp
			push h
			lxi h, $0002
			dad sp
			shld RestoreSP+1
			; copy unpacked data into the ram_disk
			xchg
			pop d
			mov a, d
			RAM_DISK_ON_BANK()
			sphl
			;mov a, e
			mov l, c
			mov h, b
@loop:
			pop b ; bc has to be used when interruptions is on
			mov m, c
			inx h
			mov m, b
			inx h
			dcr e;a
			jnz @loop
			jmp RestoreSP