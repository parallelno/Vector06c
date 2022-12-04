; ptr to the first bullet data in the sorted list
bulletRuntimeDataSorted:
			.word bulletUpdatePtr

BULLET_RUNTIME_DATA_LEN = 25

; a list of bullet runtime data structs.
bulletsRuntimeData:
bulletUpdatePtr:		.word TEMP_ADDR
bulletDrawPtr:			.word TEMP_ADDR
bulletStatus:			.byte TEMP_BYTE
bulletStatusTimer:		.byte TEMP_BYTE
bulletAnimTimer:		.byte TEMP_BYTE
bulletAnimPtr:			.word TEMP_ADDR
bulletEraseScrAddr:		.word TEMP_WORD
bulletEraseScrAddrOld:	.word TEMP_ADDR
bulletEraseWH:			.word TEMP_WORD
bulletEraseWHOld:		.word TEMP_WORD
bulletPosX:				.word TEMP_WORD
bulletPosY:				.word TEMP_WORD
bulletSpeedX:			.word TEMP_WORD
bulletSpeedY:			.word TEMP_WORD

; the same structs for the rest of the bullets
.storage BULLET_RUNTIME_DATA_LEN * (BULLETS_MAX-1), 0
bulletsRuntimeDataEnd:	.word BULLET_RUNTIME_DATA_END << 8