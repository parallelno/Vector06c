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
			lxi		sp, STACK_MAIN_PROGRAM_ADDR
			ei
            jmp     Start

