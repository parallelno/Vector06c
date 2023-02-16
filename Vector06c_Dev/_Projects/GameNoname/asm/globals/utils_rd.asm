; clear a memory buffer using stack operations
; can be used to clear ram-disk memory as well
; ex. CALL_RAM_DISK_FUNC(__clear_mem_sp, __RAM_DISK_S_BACKBUFF | __RAM_DISK_M_CLEAR_MEM | RAM_DISK_M_89)
; input:
; bc - the last byte addr of an erased buffer + 1
; de - length/128 - 1
; a - ram disk activation command

; use:
; hl
__RAM_DISK_M_CLEAR_MEM = RAM_DISK_M

__clear_mem_sp:
			; store SP
			lxi h, 0
			dad sp
			shld restoreSP_ramDisk__ + 1

			mov h, b
			mov l, c		
			sphl
			lxi b, $0000
			mvi a, $ff
@loop:
			push_b(64)
			dcx d
			cmp d
			jnz @loop
			jmp Ret_ramDisk__
