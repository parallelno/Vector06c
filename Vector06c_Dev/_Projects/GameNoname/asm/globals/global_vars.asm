
border_color_idx:
			.byte TEMP_BYTE
scr_offset_y:
			.byte 255

; it is used to check how many updates needs to happened to sync with interruptions
game_updates_counter:
			.byte TEMP_BYTE

; a lopped counter increased every game update
game_update_counter:
			.byte TEMP_BYTE

; used for the movement
char_temp_x:	.word 0 ; temporal X
char_temp_y:	.word 0 ; temporal Y
