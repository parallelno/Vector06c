; a code of a pressed key on the keyboard
; TODO: move it to buffers.asm
; low byte	- Down, Right, Up, Left, ЗБ (DEL), ВК (Enter), ПС (Alt), TAB (Tab)
; hi byte 	- SPC, ^, ], \, [, Z, Y, X
key_code:
			.word KEY_NO << 8 | ~KEY_NO
; key code of a previous update
key_code_old:
			.word KEY_NO << 8 | ~KEY_NO

; a code of a pressed control on the joystick
; joy_code formats:
; 	joystick "P": ABxxDULR (bit = 0 means pressed)
; 	joystick "C": BAxxDULR (bit = 0 means pressed)
; 	joystick "USPID": URDLABxx (bit = 1 means pressed)
; where:
;	A - fire 1 key
;	B - fire 2 key
;	U - up key
;	D - down key
;	L - left key
;	R - left key
;	x - N/A
joy_code:
			.byte KEY_NO
joy_code_old:
			.byte KEY_NO

border_color_idx:
			.byte TEMP_BYTE
scr_offset_y:
			.byte 255

; it is used to check how many updates needs to happened to sync with interruptions
game_updates_counter:
			.byte TEMP_BYTE

ram_disk_mode:
			.byte TEMP_BYTE

; a lopped counter increased every game update
game_update_counter:
			.byte TEMP_BYTE

; used for the movement
char_temp_x:	.word 0 ; temporal X
char_temp_y:	.word 0 ; temporal Y