; a newly inited room uses this list to call a monster Init func
; it's ordered by monsterId (see tile data format in levelsData.asm)
monstersInits:
monstersInit0:JMP_4(SkeletonInit)
monstersInit1:JMP_4(VampireInit)
monstersInit2:JMP_4(BurnerInit)
monstersInit3:JMP_4(KnightInit)
monstersInit4:JMP_4(KnightInit)

SkeletonId = (monstersInit0-monstersInits) / JMP_4_LEN
VampireId = (monstersInit1-monstersInits) / JMP_4_LEN
BurnerId = (monstersInit2-monstersInits) / JMP_4_LEN
KnighHorizId = (monstersInit3-monstersInits) / JMP_4_LEN
KnighVertId = (monstersInit4-monstersInits) / JMP_4_LEN

; ptr to the first monster data in the sorted list
monsterRuntimeDataSorted:
			.word monsterUpdatePtr

; a list of monster runtime data structs.
; TODO: optimization. consider using jmp_4 instead of func ptrs like monsterUpdatePtr
monstersRuntimeData:
monsterUpdatePtr:		.word TEMP_ADDR
monsterDrawPtr:			.word TEMP_ADDR
monsterImpactPtr:		.word TEMP_WORD ; called by hero bullet, another monster, etc. to affect this monster
monsterId:				.byte TEMP_BYTE
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
monsterDataEnd:

MONSTER_RUNTIME_DATA_LEN = monsterDataEnd - monstersRuntimeData

; the same structs for the rest of the monsters
.storage MONSTER_RUNTIME_DATA_LEN * (MONSTERS_MAX-1), 0
monstersRuntimeDataEnd:	.word MONSTER_RUNTIME_DATA_END << 8