toBank0addr0:
.incbin "generated\\bin\\ramDiskBank0_addr0.bin.zx0"
toBank0addr8000:
.incbin "generated\\bin\\ramDiskBank0_addr8000.bin.zx0"
toBank1addrA000:
.incbin "generated\\bin\\ramDiskBank1_addrA000.bin.zx0"

; ram-disk data has to keep the range from STACK_MIN_ADDR to STACK_MAIN_PROGRAM_ADDR-1 not used. 
; it can be corrupted by the subroutines which manipulate the stack

RamDiskInit:
			; unpack sprites to the ram-disk
			lxi b, $8000
			lxi h, $8000
			lxi d, toBank0addr0
			mvi a, RAM_DISK0_B0_STACK
			call UnpackToRamDisk
			; unpack tiles and levels to the ram-disk
			lxi b, $8000
			lxi h, $0000
			lxi d, toBank0addr8000
			mvi a, RAM_DISK0_B0_STACK
			call UnpackToRamDisk		
			
			; unpack music to the ram-disk
			lxi b, $a000
			lxi h, $0000
			lxi d, toBank1addrA000
			mvi a, RAM_DISK0_B1_STACK
			call UnpackToRamDisk

			ret
			.closelabels

;========================================
; unpack the data on the screen to
; BC addr (32K max), then copies a buffer 
; from $8000-$ffff (32K) into the ram-disk.
; input: 
; bc - unpacked data addr
; de - packed data addr
; hl - the destination addr in the ram_disk + $8000 (because it copies 32k data backward)
; a - ram-disk activation command
; use:
; bc, hl, a
UnpackToRamDisk:
			di
			push h
			push psw
			call dzx0
			; restore the destination addr
			pop psw
			pop d
			; store sp
			lxi h, $0000
			dad sp
			shld @restoreSp+1
			; copy unpacked data into the ram_disk
			xchg
			RAM_DISK_ON_BANK()			
			sphl
			; TODO: copy only necessary length of data
			lxi h, $ffff ; unpacked data screen addr + $7fff (because it copies the data backward)
			mvi e, $7f
@loop:
			mov b, m
			dcx h
			mov c, m
			dcx h			
			push b
			mov a, h
			cmp e
			jnz @loop

@restoreSp: lxi sp, TEMP_ADDR
			RAM_DISK_OFF()
			ei
			ret
			.closelabels