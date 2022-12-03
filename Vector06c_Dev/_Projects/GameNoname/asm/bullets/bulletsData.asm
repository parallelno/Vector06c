; max bullets in the room
BULLETS_MAX = 15

BULLET_RUNTIME_DATA_DESTR = $fc ; a bullet is ready to be destroyed
BULLET_RUNTIME_DATA_EMPTY = $fd ; a bullet data is available for a new bullet
BULLET_RUNTIME_DATA_LAST = $fe ; the end of the last existing bullet data
BULLET_RUNTIME_DATA_END = $ff ; the end of the data

; statuses.
; a status describes what set of animations and behavior is active
; for ex. HERO_STATUS_ATTACK plays hero_attk_r or hero_attk_l depending on the direction and it spawns a weapon trail
BULLET_STATUS_INVIS = $ff

; a newly inited room uses this list to find an Init func
; of a bullet that has to be spawn
bulletsInits:
			.word SkeletonInit

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