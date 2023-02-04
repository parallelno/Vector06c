; a newly inited room uses this list to find an Init func of a monster that has to be spawn
; it's ordered by monsterId (see tile data format in levelsData.asm)
monstersInits:
			JMP_4(SkeletonInit)
			JMP_4(VampireInit)
			JMP_4(BurnerInit)
			JMP_4(KnightInit)

; ptr to the first monster data in the sorted list
monsterRuntimeDataSorted:
			.word monsterUpdatePtr

MONSTER_RUNTIME_DATA_LEN = 33

; a list of monster runtime data structs.
monstersRuntimeData:
monsterUpdatePtr:		.word TEMP_ADDR
monsterDrawPtr:			.word TEMP_ADDR
monsterImpactPtr:		.word TEMP_WORD ; called by hero bullet, another monster, etc. to affect this monster
monsterType:			.byte TEMP_BYTE
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
monsterDataPrevPPtr:	.word TEMP_WORD
monsterDataNextPPtr:	.word TEMP_WORD

; the same structs for the rest of the monsters
.storage MONSTER_RUNTIME_DATA_LEN * (MONSTERS_MAX-1), 0
monstersRuntimeDataEnd:	.word MONSTER_RUNTIME_DATA_END << 8