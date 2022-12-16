; ptr to the first bullet data in the sorted list
bulletRuntimeDataSorted:
			.word bulletUpdatePtr

BULLET_RUNTIME_DATA_LEN = 25

; a list of bullet runtime data structs.
bulletsRuntimeData:
bulletUpdatePtr:		.word TEMP_ADDR ; $2375
bulletDrawPtr:			.word TEMP_ADDR ; 
bulletStatus:			.byte TEMP_BYTE
bulletStatusTimer:		.byte TEMP_BYTE ; $2375
bulletAnimTimer:		.byte TEMP_BYTE ; $237b
bulletAnimPtr:			.word TEMP_ADDR ; $237c
bulletEraseScrAddr:		.word TEMP_WORD
bulletEraseScrAddrOld:	.word TEMP_ADDR
bulletEraseWH:			.word TEMP_WORD
bulletEraseWHOld:		.word TEMP_WORD ; 
bulletPosX:				.word TEMP_WORD ; $2386
bulletPosY:				.word TEMP_WORD ; $2388
bulletSpeedX:			.word TEMP_WORD ; 238a
bulletSpeedY:			.word TEMP_WORD ; $238c

; the same structs for the rest of the bullets
.storage BULLET_RUNTIME_DATA_LEN * (BULLETS_MAX-1), 0
bulletsRuntimeDataEnd:	.word BULLET_RUNTIME_DATA_END << 8