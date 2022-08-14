.include "globalConsts.asm"

			.org	$100
StartInit:
			di
			; dismount a quasi-disk
			xra		a
			out		$10
			; set entry points of a restart, and an interruption
			mvi		a, OPCODE_JMP
			STA		RESTART_ADDR
			STA		INT_ADDR
			lxi		h, StartInit
			shld 	RESTART_ADDR + 1
			lxi		h, Interruption2
			shld	INT_ADDR + 1
			; stack init
			lxi		sp, STACK_ADDR

			ei
			call ClearScr
            jmp     Start

