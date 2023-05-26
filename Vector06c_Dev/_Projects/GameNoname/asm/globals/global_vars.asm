
; TODO: move it to buffers.asm
; low byte	- Down, Right, Up, Left, ЗБ (DEL), ВК (Enter), ПС (Alt), TAB (Tab)
; hi byte 	- SPC, ^, ], \, [, Z, Y, X
key_code:
			.word KEY_NO << 8 | ~KEY_NO
; key code of a previous update
key_code_old:
			.word KEY_NO << 8 | ~KEY_NO

palette_update_request:
			.byte PALETTE_UPD_REQ_NO

border_color_idx:
			.byte TEMP_BYTE
scr_offset_y:
			.byte 255

; it is used to check how many updates needs to happened to sync with interruptions
requested_updates:
			.byte TEMP_BYTE

ram_disk_mode:
			.byte TEMP_BYTE
; it gets updated every second
current_fps:
			.byte TEMP_BYTE
; a lopped counter increased every game draw
game_draws_counter:
			.byte TEMP_BYTE

; a lopped counter increased every game update
game_update_counter:
			.byte TEMP_BYTE

; a counter decreased from INTS_PER_SEC to 0 every iterruption
ints_per_sec_counter:
			.byte INTS_PER_SEC 

; used for the movement
char_temp_x:	.word 0 ; temporal X
char_temp_y:	.word 0 ; temporal Y