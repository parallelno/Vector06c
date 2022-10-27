; max monsters amount in the room
MONSTERS_MAX = 12

; monster init, update, and draw funcs has to be 
; listed here
monstersFuncs:
            .word SkeletonInit
			.word SkeletonUpdate
			.word SkeletonDraw
		.loop MONSTERS_MAX-1
			.word 0, 0, 0
		.endloop

MONSTERS_ROOM_SPRITE_DATA_LEN = 22
MONSTERS_ROOM_DATA_ADDR_OFFSET .var 0
monsterRoomDataAddrOffsets:
	.loop MONSTERS_MAX
		.byte MONSTERS_ROOM_DATA_ADDR_OFFSET
		MONSTERS_ROOM_DATA_ADDR_OFFSET = MONSTERS_ROOM_DATA_ADDR_OFFSET + MONSTERS_ROOM_SPRITE_DATA_LEN
	.endloop

; the data below is updated every room init
;============================================================================================================
monstersRoomData:

MONSTERS_INIT_FUNC_LEN = WORD_LEN
MONSTERS_UPDATE_FUNC_LEN = WORD_LEN
MONSTERS_DRAW_FUNC_LEN = WORD_LEN
MONSTERS_FUNCS_LEN = MONSTERS_INIT_FUNC_LEN + MONSTERS_UPDATE_FUNC_LEN + MONSTERS_DRAW_FUNC_LEN
MONSTERS_ROOM_DATA_LEN = (MONSTERS_FUNCS_LEN + MONSTERS_ROOM_SPRITE_DATA_LEN) * MONSTERS_MAX

; monster init funcs in the current room
monstersInitFuncs:
		.loop MONSTERS_MAX
			.word 0
		.endloop

; monster update funcs in the current room
monstersUpdateFuncs:
		.loop MONSTERS_MAX
			.word 0
		.endloop

; monster draw funcs in the current room
monstersDrawFuncs:
	.loop MONSTERS_MAX
			.word 0
	.endloop

; sprite data structs of the current room. do not change its layout
monstersRoomSpriteData:
monsterHealth:			.byte TEMP_BYTE
monsterStatus:			.byte HERO_STATUS_IDLE
monsterStatusTimer:		.byte 0
monsterAnimTimer:		.byte TEMP_BYTE ; used to trigger to change an anim frame
monsterAnimAddr:        .word TEMP_ADDR
monsterEraseScrAddr:	.word TEMP_WORD
monsterEraseScrAddrOld:	.word TEMP_ADDR
monsterEraseWH:			.word TEMP_WORD
monsterEraseWHOld:		.word TEMP_WORD
monsterPosX:			.word TEMP_WORD
monsterPosY:			.word TEMP_WORD
monsterSpeedX:			.word TEMP_WORD
monsterSpeedY:			.word TEMP_WORD

; the same structs for the rest of the monsters in the current room
.storage MONSTERS_ROOM_SPRITE_DATA_LEN * (MONSTERS_MAX-1)
;============================================================================================================
; end of monstersRoomData
