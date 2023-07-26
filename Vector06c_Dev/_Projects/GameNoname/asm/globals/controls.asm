.include "asm\\globals\\controls_consts.asm"

action_code:
			.word CONTROL_CODE_NO<<8 || CONTROL_CODE_NO
action_code_old: = action_code + 1

controls_check:
			jmp controls_keys_check
controls_check_func_ptr: = controls_check + 1
controls_check_func_ptr_flipped:
			.word controls_joy_check


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

			; check CONTROL_CODE_RIGHT
			mvi a, KEY_CODE_RIGHT
			ora c
			add e
			rar
			mov d, a
			; check CONTROL_CODE_LEFT
			mvi a, KEY_CODE_LEFT
			ora c
			add e
			mov a, d
			rar
			mov d, a
			; check CONTROL_CODE_UP
			mvi a, KEY_CODE_UP
			ora c
			add e
			mov a, d
			rar
			mov d, a
			; check CONTROL_CODE_DOWN
			mvi a, KEY_CODE_DOWN
			ora c
			add e
			mov a, d
			rar
			mov d, a
			; check CONTROL_CODE_RETURN
			mvi a, KEY_CODE_TAB
			ora c
			add e
			mov a, d
			rar
			mov d, a
			; check CONTROL_CODE_KEY_SPACE			
			mvi a, KEY_CODE_SPACE
			ora b
			add e
			mov a, d
			rar
			mov d, a
			; check CONTROL_CODE_FIRE2
			mvi a, KEY_CODE_ALT
			ora c
			add e
			mov a, d
			rar
			mov d, a
			; check CONTROL_CODE_FIRE1
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
			ori ~(CONTROL_CODE_KEY_SPACE && CONTROL_CODE_RETURN) ; set the default value (no action)
			mov e, a
			
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

			; check CONTROL_CODE_RETURN
			mvi a, ~KEY_CODE_TAB
			ana c
			jnz @key_return_not_pressed
			mvi a, CONTROL_CODE_RETURN
			ana e ; set the bit to 0 representing an action
			mov e, a
@key_return_not_pressed:

			; check CONTROL_CODE_RETURN
			mvi a, ~KEY_CODE_SPACE
			ana b
			jnz @key_space_not_pressed
			mvi a, CONTROL_CODE_KEY_SPACE
			ana e ; set the bit to 0 representing an action
			mov e, a
@key_space_not_pressed:

			mov a, e
			sta action_code
			ret

; return control_preset value
; out:
; a - control_preset value
controls_get_preset:
			lhld controls_check_func_ptr
			mov a, l
			cpi <controls_keys_check
			jnz @preset_joystic
			mov a, h
			cpi >controls_keys_check
			jnz @preset_joystic
			mvi a, CONTROL_PRESET_KEYBOARD
			ret
@preset_joystic:
			mvi a, CONTROL_PRESET_JOYSTICK
			ret

controls_flip_preset:
			lhld controls_check_func_ptr
			xchg
			lhld controls_check_func_ptr_flipped
			
			shld controls_check_func_ptr
			xchg
			shld controls_check_func_ptr_flipped
			rnz