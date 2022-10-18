			.org	$100
StartInit:
			di
			RAM_DISK_OFF()
			mvi a, OPCODE_JMP
			sta RESTART_ADDR
			sta INT_ADDR
			lxi h, StartInit
			shld RESTART_ADDR + 1
			lxi h, Interruption2
			shld INT_ADDR + 1
			lxi sp, STACK_TMP_MAIN_PROGRAM_ADDR
			call RamDiskInit
			lxi sp, STACK_MAIN_PROGRAM_ADDR
			ei
            jmp Start

