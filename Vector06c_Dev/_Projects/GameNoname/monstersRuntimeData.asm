; max monsters in the room
MONSTERS_MAX = 15
MONSTER_RUNTIME_DATA_DESTROY = $fc ; a monster is ready to be destroyed
MONSTER_RUNTIME_DATA_EMPTY = $fd ; a monster data is available for a new monster
MONSTER_RUNTIME_DATA_LAST = $fe ; the end of the last existing monster data
MONSTER_RUNTIME_DATA_END = $ff ; the end of the data

; a newly inited room uses this list to find an Init func
; of a monster that has to be spawn
monstersInits:
			.word SkeletonInit

MONSTER_RUNTIME_DATA_LEN = 26
; a list of monster runtime data structs.
monstersRuntimeData:
monsterUpdatePtr:		.word TEMP_ADDR
monsterDrawPtr:			.word TEMP_ADDR
monsterHealth:			.byte TEMP_BYTE
monsterStatus:			.byte TEMP_BYTE
monsterStatusTimer:		.byte TEMP_BYTE
monsterAnimTimer:		.byte TEMP_BYTE
monsterAnimPtr:			.word TEMP_ADDR
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
monstersRuntimeDataEnd:	.word MONSTER_RUNTIME_DATA_END << 8