			.org	$100
StartInit:
			di
			RAM_DISK_OFF()
			mvi		a, OPCODE_JMP
			STA		RESTART_ADDR
			STA		INT_ADDR
			lxi		h, StartInit
			shld 	RESTART_ADDR + 1
			lxi		h, Interruption2
			shld	INT_ADDR + 1

			lxi sp, STACK_TMP_MAIN_PROGRAM_ADDR
			call RamDiskInit
			lxi sp, STACK_MAIN_PROGRAM_ADDR

			mvi a, RAM_DISK_M2 | RAM_DISK_M_8F
			out $10
			lxi b, $0000
			lxi d, $8000 / 128 - 9;/128 - 1			
			call __ClearMemSP
			xra a
			out $10			
dfdf:		jmp dfdf


			ei
            jmp     Start

