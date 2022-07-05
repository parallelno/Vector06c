.include "globals.asm"
            .org	$100
StartInit:
			DI
			; dismount a quasi-disk
			XRA		A
			out		$10
			; set entry points of a restart, and an interruption
			MVI		A, JMP_OPCODE
			STA		RESTART_ADDR
			STA		INT_ADDR
			LXI		H, StartInit
			SHLD 	RESTART_ADDR + 1
			LXI		H, Interruption2
			SHLD	INT_ADDR + 1
			; stack init
			LXI		SP, STACK_ADDR

			EI
			HLT
			CALL	SetPalette
   			; clear the screen
			LXI		B, $0000
			LXI     D, SCR_MEM_LEN / 32
			CALL	MemReset
            JMP     Start
