; ptr to the first bullet data in the sorted list
bullet_runtime_data_sorted:
			.word bullet_update_ptr

; a list of bullet runtime data structs.
bulletsRuntimeData:
bullet_update_ptr:		.word TEMP_ADDR 
bullet_draw_ptr:		.word TEMP_ADDR  
bullet_id:				.byte TEMP_BYTE
bullet_status:			.byte TEMP_BYTE
bullet_status_timer:		.byte TEMP_BYTE 
bullet_anim_timer:		.byte TEMP_BYTE 
bulletAnimPtr:			.word TEMP_ADDR 
bulletEraseScrAddr:		.word TEMP_WORD
bulletEraseScrAddrOld:	.word TEMP_ADDR
bulletEraseWH:			.word TEMP_WORD
bulletEraseWHOld:		.word TEMP_WORD 
bulletPosX:				.word TEMP_WORD 
bulletPosY:				.word TEMP_WORD 
bulletSpeedX:			.word TEMP_WORD 
bulletSpeedY:			.word TEMP_WORD 
bulletRuntimeDataEnd:

BULLET_RUNTIME_DATA_LEN = bulletRuntimeDataEnd-bulletsRuntimeData ;25

; the same structs for the rest of the bullets
.storage BULLET_RUNTIME_DATA_LEN * (BULLETS_MAX-1), 0
bulletsRuntimeDataEnd:	.word BULLET_RUNTIME_DATA_END << 8