			.org	$100
main_init:
			di
			RAM_DISK_OFF()
			mvi a, OPCODE_JMP
			sta RESTART_ADDR
			sta INT_ADDR
			lxi h, main_init
			shld RESTART_ADDR + 1
			lxi h, interruption
			shld INT_ADDR + 1
			lxi sp, STACK_TMP_MAIN_PROGRAM_ADDR
			call ram_disk_init
			lxi sp, STACK_MAIN_PROGRAM_ADDR
			ei
            jmp main_start

