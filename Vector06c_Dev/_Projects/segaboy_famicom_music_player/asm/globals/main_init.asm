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

			; joystick "P" init
			mvi	a, $83		; control byte
			out	4		; initialize the I/O controller
			mvi	a, $9F		; bits to check Joystick-P, both P1 and P2
			out	5		; set Joystick-P query bits

			ei
            jmp main_start