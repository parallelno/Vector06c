.setting "OmitUnusedFunctions", true

__RAM_DISK_M_CLEAR_MEM = RAM_DISK_M

;=================================================================
; clears a memory buffer aligned by $100
; the buffer length is <= $100
; input:
; hl - the buff addr
; a - a low byte of an addr the next after the buffer
; use:
; a, c
.function clear_mem_short()
			mvi c, 0
@loop:		mov m, c
			inr l
			cmp l
			jnz @loop
.endfunction