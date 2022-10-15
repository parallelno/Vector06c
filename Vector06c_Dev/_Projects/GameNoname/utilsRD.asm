; clear a memory buffer using stack operations
; can be used to clear ram-disk memory as well
; input:
; bc - the last addr of a erased buffer + 1
; de - length/128 - 1
; a - ram disk activation command
; 		a = 0 to clear the main memory
; use:
; hl

__ClearMemSP:
			; store ret addr
			pop h
			shld restoreRet_ramDisk__ + 1
			; store SP
			lxi h, 0
			dad sp
			shld restoreSP_ramDisk__ + 1

			;RAM_DISK_ON_BANK()
			mov h, b
			mov l, c			
			sphl
			lxi b, 0

			// mvi a, RAM_DISK_M2 | RAM_DISK_M_8F
			// out $10

			mvi a, $ff

@loop:
			push_b(64)
			dcx d
			cmp d
			jnz @loop
			jmp Ret_ramDisk__
			.closelabels