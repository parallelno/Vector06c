; clear a memory buffer using stack operations
; can be used to clear ram-disk memory as well
; input:
; bc - the last byte addr of an erased buffer + 1
; de - length/128 - 1
; a - ram disk activation command

; use:
; hl
__ClearMemSP:
			; store the return addr
			pop h
			shld __restoreRet_ramDisk + 1
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
			.closelabels