; ptr to the first bullet data in the sorted list
bullet_runtime_data_sorted:
			.word bullet_update_ptr

; a list of bullet runtime data structs.
bullets_runtime_data:
bullet_update_ptr:			.word TEMP_ADDR 
bullet_draw_ptr:			.word TEMP_ADDR  
bullet_id:					.byte TEMP_BYTE
bullet_status:				.byte TEMP_BYTE
bullet_status_timer:		.byte TEMP_BYTE 
bullet_anim_timer:			.byte TEMP_BYTE 
bullet_anim_ptr:			.word TEMP_ADDR 
bullet_erase_scr_addr:		.word TEMP_WORD
bullet_erase_scr_addr_old:	.word TEMP_ADDR
bullet_erase_wh:			.word TEMP_WORD
bullet_erase_wh_old:		.word TEMP_WORD 
bullet_pos_x:				.word TEMP_WORD 
bullet_pos_y:				.word TEMP_WORD 
bullet_speed_x:				.word TEMP_WORD 
bullet_speed_y:				.word TEMP_WORD 
bullet_runtime_data_end_addr:

BULLET_RUNTIME_DATA_LEN = bullet_runtime_data_end_addr-bullets_runtime_data

; the same structs for the rest of the bullets
.storage BULLET_RUNTIME_DATA_LEN * (BULLETS_MAX-1), 0
bulletsRuntimeDataEnd:		.word BULLET_RUNTIME_DATA_END << 8