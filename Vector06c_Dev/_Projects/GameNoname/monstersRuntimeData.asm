; max monsters amount in the room
MONSTERS_MAX = 10

; monster init, update, and draw funcs has to be 
; listed here
monstersFuncs:
            .word SkeletonInit
			.word SkeletonUpdate
			.word SkeletonDraw
		.loop MONSTERS_MAX-1
			.word 0, 0, 0
		.endloop

MONSTERS_ROOM_SPRITE_DATA_LEN = 21
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
monstersInitFunc:
		.loop MONSTERS_MAX
			.word 0
		.endloop

; monster update funcs in the current room
monstersUpdateFunc:
		.loop MONSTERS_MAX
			.word 0
		.endloop

; monster draw funcs in the current room
monstersDrawFunc:
	.loop MONSTERS_MAX
			.word 0
	.endloop

; sprite data structs of the current room. do not change its layout
monstersRoomSpriteData:
; TODO: consider copying certain monster's data from its place 
; to a common place where it can be addressed within just labels 
; without using relative pointers.
monsterDirX:			.byte 1 ; 1-right, 0-left
monsterState:           .byte 0 ; 0 - idle
monsterStateCounter:    .byte 40
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
