; max monsters in the room
MONSTERS_MAX = 15
MONSTER_RUNTIME_DATA_EMPTY = $fd00
MONSTER_RUNTIME_DATA_LAST = $fe00 ; the end of the last existing monster data
MONSTER_RUNTIME_DATA_END = $ff00 ; the end of the data

; monster init, update, and draw funcs has to be
; listed here
monstersInits:
            .word SkeletonInit
		.loop MONSTERS_MAX-1
			.word TEMP_ADDR
		.endloop

MONSTER_RUNTIME_DATA_LEN = 26
;MONSTERS_RUNTIME_DATA_LEN = MONSTER_RUNTIME_DATA_LEN * MONSTERS_MAX
; a list of monster runtime data structs.
monstersRuntimeData:
; TODO: rename monsterUpdate into monsterUpdatePtr
monsterUpdate:			.word TEMP_ADDR
; TODO: rename monsterDraw into monsterDrawPtr
monsterDraw:			.word TEMP_ADDR
monsterHealth:			.byte TEMP_BYTE
monsterStatus:			.byte TEMP_BYTE
monsterStatusTimer:		.byte TEMP_BYTE
monsterAnimTimer:		.byte TEMP_BYTE ; used to trigger to change an anim frame
; TODO: rename monsterAnimAddr into monsterAnimPtr
monsterAnimAddr:        .word TEMP_ADDR
monsterEraseScrAddr:	.word TEMP_WORD
monsterEraseScrAddrOld:	.word TEMP_ADDR
monsterEraseWH:			.word TEMP_WORD
monsterEraseWHOld:		.word TEMP_WORD
monsterPosX:			.word TEMP_WORD
monsterPosY:			.word TEMP_WORD
monsterSpeedX:			.word TEMP_WORD
monsterSpeedY:			.word TEMP_WORD
; the same structs for the rest of the monsters
.storage MONSTER_RUNTIME_DATA_LEN * (MONSTERS_MAX-1), 0
monstersRuntimeDataEnd:	.word MONSTER_RUNTIME_DATA_END