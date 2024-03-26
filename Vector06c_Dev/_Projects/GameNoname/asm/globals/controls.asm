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
			mvi a, PORT0_OUT_IN
			out 0
			; line 0
			mvi a, KEY_CODE_ROW_0
			out 3
			in 2
			mov c, a

			; line 7
			mvi a, KEY_CODE_ROW_7
			out 3
			in 2

			ral 								; extract KEY_CODE_SPACE
			mov a, c
			ral 								; add KEY_CODE_SPACE to the key row 0
			ani %111 ; bits: alt, tab, space, but inverset
			HL_TO_A_PLUS_INT16(keys_to_controls_alt_tab_space)

			mov e, m
			
			mvi a, %1111_0000
			ana c
			RRC_(4)
			HL_TO_A_PLUS_INT16(keys_to_controls_arrows)
			mov a, m
			ora e
			sta action_code
			ret
keys_to_controls_arrows: 
			; bits that form an offset in this tbl: down, right, up, left. they are inversed
			; bits of data: 0,0,0,0, CONTROL_CODE_DOWN, CONTROL_CODE_UP, CONTROL_CODE_LEFT, CONTROL_CODE_RIGHT
			.byte %1111 ; none
			.byte %1101 ; 
			.byte %1011 ; 
			.byte %1001 ; 
			.byte %1110 ; 
			.byte %1100 ; 
			.byte %1010 ; 
			.byte %1000 ; 

			.byte %0111 ; right + up + left
			.byte %0101 ; right + up
			.byte %0011 ; 
			.byte %0001 ; 
			.byte %0110 ; 
			.byte %0100 ; 
			.byte %0010	; right + up + down
			.byte 0		; right + up + left + down
			
keys_to_controls_alt_tab_space: 
			; bits that form an offset in this tbl: alt, tab, space. they are inversed
			; bits of data: CONTROL_CODE_FIRE1, CONTROL_CODE_FIRE2, CONTROL_CODE_KEY_SPACE, CONTROL_CODE_RETURN, 0,0,0,0
			.byte %1111_0000 ; none
			.byte %0101_0000 ; space
			.byte %1110_0000 ; tab
			.byte %0100_0000 ; tab + space
			.byte %1011_0000 ; alt
			.byte %0001_0000 ; alt + space
			.byte %1010_0000 ; alt + tab
			.byte 0			 ; alt + space + tab			
			

controls_joy_check:
			; read joystick "P" code
			in $06
			ori ~(CONTROL_CODE_KEY_SPACE && CONTROL_CODE_RETURN) ; set the default value (no action)
			mov e, a
			
			; read key_code
			mvi a, PORT0_OUT_IN
			out 0
			; line 0
			mvi a, KEY_CODE_ROW_0
			out 3
			in 2
			mov c, a
			; line 7
			mvi a, KEY_CODE_ROW_7
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
			cma
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