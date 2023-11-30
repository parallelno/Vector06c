; this is a subset of utills required only for unpacker
.include "asm\\common\\zx0.asm"

;========================================
; copy a buffer into the ram-disk
; disable INTERRUPTIONS before calling it!
; input:
; de - source addr + data length
; hl - target addr + data length
; bc - buffer length / 2
; a - ram-disk activation command
; use:
; all
copy_to_ram_disk:
			shld @restoreTargetAddr+1
			; store sp
			lxi h, $0000
			dad sp
			shld @restore_sp+1
			RAM_DISK_ON_BANK_NO_RESTORE()
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

@restore_sp:
			lxi sp, TEMP_ADDR
			RAM_DISK_OFF_NO_RESTORE()
			ret
copy_to_ram_disk_end:

.macro COPY_TO_RAM_DISK(count)
		.loop count
			dcx h
			mov d, m
			dcx h
			mov e, m
			push d
		.endloop
.endmacro
