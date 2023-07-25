.include "asm\\globals\\controls_consts.asm"

action_code:
			.word ACTION_CODE_NO<<8 || ACTION_CODE_NO
action_code_old: = action_code + 1

controls_check:
			jmp controls_keys_check
controls_check_func_ptr: = controls_check + 1


controls_keys_check:
			; read key_code
			mvi a, PORT0_OUT_IN
			out 0
			; line 0
			mvi a, KEY_CODE_LINE_0 ; %1111_1110
			out 3
			in 2
			mov c, a
			; line 7
			mvi a, KEY_CODE_LINE_7 ; %0111_1111
			out 3
			in 2
			mov b, a

			mvi e, 1 ; to check overflow and then extract CY flag
			; D is used to store action_code
			; D reg initialization is redundant because it will be rotated over all of the bits

			; check ACTION_CODE_RIGHT
			mvi a, KEY_CODE_RIGHT
			ora c
			add e
			rar
			mov d, a
			; check ACTION_CODE_LEFT
			mvi a, KEY_CODE_LEFT
			ora c
			add e
			mov a, d
			rar
			mov d, a
			; check ACTION_CODE_UP
			mvi a, KEY_CODE_UP
			ora c
			add e
			mov a, d
			rar
			mov d, a
			; check ACTION_CODE_DOWN
			mvi a, KEY_CODE_DOWN
			ora c
			add e
			mov a, d
			rar
			mov d, a
			; check ACTION_CODE_RETURN
			mvi a, KEY_CODE_TAB
			ora c
			add e
			mov a, d
			rar
			stc
			rar ; ACTION_CODE_NOTUSED has always no action
			mov d, a
			; check ACTION_CODE_FIRE2
			mvi a, KEY_CODE_ALT
			ora c
			add e
			mov a, d
			rar
			mov d, a
			; check ACTION_CODE_FIRE1
			mvi a, KEY_CODE_SPACE
			ora b
			add e
			mov a, d
			rar
			sta action_code
			ret

controls_joy_check:
			; read joystick "P" code
			in $06
			ori ~ACTION_CODE_RETURN ; to set the bit to 1 representing a no action status
			mov c, a
			
			; read key_code
			mvi a, PORT0_OUT_IN
			out 0
			; line 0
			mvi a, KEY_CODE_LINE_0 ; %1111_1110
			out 3
			in 2
			; check ACTION_CODE_RETURN
			ani <(~KEY_CODE_TAB)
			jnz @key_return_not_pressed
			mvi a, ACTION_CODE_RETURN
			ana c ; set the bit to 0 representing an action
			mov c, a
@key_return_not_pressed:
			mov a, c
			sta action_code
			ret
