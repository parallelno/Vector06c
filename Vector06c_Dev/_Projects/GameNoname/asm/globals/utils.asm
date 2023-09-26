.include "asm\\globals\\rnd.asm"
.include "asm\\globals\\utils_unpacker.asm"

; sharetable chunk of code to restore SP
; and dismount the ram-disk
; cc = 56
restore_sp:
			lxi sp, TEMP_ADDR
			RAM_DISK_OFF()
			ret
			

; clear a memory buffer
; input:
; hl - addr to clear
; bc - length
; use:
; a
clear_mem:
@loop:
			A_TO_ZERO(NULL_BYTE)
			mov m, a
			inx h
			dcx b
			ora c
			ora b
			jnz @loop
			ret		

; fill up an aligned memory buffer with a byte.
; a buffer has to be stored in one $100 block of memory
; buffer len <=256
; input:
; hl - addr to clear
; a - the next addr (a low byte of address) after a buffer
; c - filler, if fill_mem_short is called
; use:
; a
clear_mem_short:
			mvi c, 0
fill_mem_short:
@loop:		mov m, c
			inr l
			cmp l
			jnz @loop
			ret

; copy a memory buffer
; input:
; hl - source
; de - destination
; bc - length
; use:
; a
copy_mem:
@loop:		mov a, m
			stax d
			inx h
			inx d
			dcx b

			mov a, c
			ora b
			jnz @loop
			ret

; clear a memory buffer using stack operations
; can be used to clear ram-disk memory as well
; input:
; bc - the last addr of a erased buffer + 1
; de - length/32 - 1
; a - ram disk activation command
; 		a = 0 to clear the main memory
; use:
; hl

.macro CLEAR_MEM_SP(disable_int)
		.if disable_int
			di
		.endif
			call clear_mem_sp
		.if disable_int
			ei
		.endif			
.endmacro

clear_mem_sp:
			lxi h, $0000
			dad sp
			shld clear_mem_sp_restoreSP + 1
			mov h, b
			mov l, c
			RAM_DISK_ON_BANK()
clear_mem_sp_filler:
			lxi b, $0000
			sphl
			mvi a, $ff
clear_mem_sp_loop:
			PUSH_B(16)
			dcx d
			cmp d
			jnz clear_mem_sp_loop
clear_mem_sp_restoreSP:
			lxi sp, TEMP_WORD
			RAM_DISK_OFF()
			ret

; fill a memory buffer with a word using stack operations
; can be used to clear ram-disk memory as well
; input:
; hl - a filler word
; bc - the last addr of a erased buffer + 1
; de - length/32 - 1
; a - ram disk activation command
; 		a = 0 to clear the main memory
fill_mem_sp:
			shld clear_mem_sp_filler + 1
			call clear_mem_sp
			lxi h, 0
			shld clear_mem_sp_filler + 1
			ret
/*		
; clear a memory buffer using stack operations
; can be used to clear ram-disk memory as well
; input:
; bc - the last addr of a erased buffer + 1
; de - length/32 - 1
; a - ram disk activation command
; 		a = 0 to clear the main memory
clear_ram_disk:
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
*/
; erase a block in the screen buff
; in:
; hl - scr_addr
; b - width/8
; c - height
erase_screen_block:
			mov a, c
			add l
			mov c, l
@loop:
			mvi m, 0
			inr l
			cmp l
			jnz @loop
			
			inr h
			mov l, c

			dcr b
			jnz @loop
			ret


;copy the pallete from a ram-disk, then requet for using it
; in:
; de - ram-disk palette addr
; h - ram-disk activation command
copy_palette_request_update:
			lxi b, palette
			COPY_FROM_RAM_DISK(PALETTE_COLORS)
			lxi h, palette_update_request
			mvi m, PALETTE_UPD_REQ_YES
			ret

; Set palette
; input: hl - the addr of the last item in the palette
; use: hl, b, a
set_palette:
			hlt
set_palette_int:			; call it from an interruption routine
			mvi	a, PORT0_OUT_OUT
			out	0
			mvi	b, PALETTE_COLORS - 1

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
			
/*
; Set palette copied from the ram-disk w/o blocking interruptions
; input:
; de - the addr of the first item in the palette
; a - ram-disk activation command
; use:
; hl, bc, a

set_palette_from_ram_disk:
			hlt
			; store sp
			lxi h, $0000
			dad sp
			shld restore_sp+1
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
			jmp restore_sp
*/

; Read a word from the ram-disk w/o blocking interruptions
; input:
; de - data addr in the ram-disk
; a - ram-disk activation command
; use:
; hl, de, a
; out:
; bc - data
; cc = 148
get_word_from_ram_disk:
			RAM_DISK_ON_BANK()
			; store sp
			lxi h, $0000
			dad sp
			shld @restore_sp+1
			; copy unpacked data into the ram_disk
			xchg
			sphl
			pop b ; bc has to be used when interruptions is on
@restore_sp:
			lxi sp, TEMP_ADDR
			RAM_DISK_OFF()
			ret

/*
; a special version of a func above for accessing addr $8000 and higher
; cc = 100
get_word_from_scr_ram_disk:
			RAM_DISK_ON_BANK()
			xchg
			mov c, m
			inx h
			mov b, m
			RAM_DISK_OFF()
			ret
*/

;========================================
; fast copy a buffer into the ram-disk.
; if interruptions are ON, it corrupts a pair of bytes at target addr-2 !!!
; input:
; de - source addr + data length
; hl - target addr + data length
; bc - buffer length / 32
; a - ram-disk activation command
; use:
; all
copy_to_ram_disk32:
			shld @restoreTargetAddr+1
			; store sp
			lxi h, $0000
			dad sp
			shld @restore_sp+1
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

@restore_sp:
			lxi sp, TEMP_ADDR
			RAM_DISK_OFF()
			ret

; Copy data (max 510) from the ram-disk to ram w/o blocking interruptions
; input:
; h - ram-disk activation command
; l - data length / 2
; de - data addr in the ram-disk
; bc - destination addr

; this macro is for checking if the length fits the range 1-510
.macro COPY_FROM_RAM_DISK(length)
		.if length > 255*2
			.error "The length is bigger than supported (510)"
		.endif
		.if length > 0
			mvi l, length/2
			call copy_from_ram_disk
		.endif
.endmacro

; ? check if it is more efficient to copy a data stored
; in $8000 and higher with a direct access via mov
; research:
; using stack ops to copy data adds 128 cc overhead
; replacing pop with mov_(2), inx_(2), adds 8 cc per byte overhead
; that said, copying with pop becomes efficient if a copy len > 16
; it is very often case. No need a direct access via mov
copy_from_ram_disk:
			; store sp
			push h
			lxi h, $0002
			dad sp
			shld restore_sp+1
			; copy unpacked data into the ram_disk
			xchg
			pop d
			mov a, d
			RAM_DISK_ON_BANK()
			sphl
			mov l, c
			mov h, b
@loop:
			pop b
			mov m, c
			inx h
			mov m, b
			inx h
			dcr e
			jnz @loop
			jmp restore_sp

; empty func
func_ret:	ret