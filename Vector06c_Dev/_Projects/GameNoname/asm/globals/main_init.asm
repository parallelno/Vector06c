			.org	$100
main_init:
			/* it is done in the unpacker
			di
			RAM_DISK_OFF()
			mvi a, OPCODE_JMP
			sta RESTART_ADDR
			sta INT_ADDR
			*/

			lxi h, main_start
			shld RESTART_ADDR + 1
			lxi h, interruption
			shld INT_ADDR + 1
			lxi sp, STACK_MAIN_PROGRAM_ADDR
			
			mvi a, GLOBAL_REQ_MAIN_MENU
			sta global_request

			; joystick "P" init
			mvi	a, $83		; control byte
			out	4		; initialize the I/O controller
			mvi	a, $9F		; bits to check Joystick-P, both P1 and P2
			out	5		; set Joystick-P query bits

			ei
            jmp main_start