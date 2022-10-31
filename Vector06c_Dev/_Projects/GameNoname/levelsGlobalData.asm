; list of adresses of compressed levels 
levelsAddr:		.word TEMP_ADDR, 0

; current level index in levelsAddr
levelIdx:
				.byte 0
; current room index in roomsAddr of the current level
roomIdx:
				.byte 0 ; 0 - 127 ; find why it says it's <128

; the address table to tile graphics
roomTilesAddr:
				.storage ROOM_WIDTH * ROOM_HEIGHT * 2

; tile data format: 
; it's stored in roomTilesData
; %DDDDDfff for every tile
; fff	- func
; ddddd	- argument
; fff == 0, d == 0, nothing, walkable
; fff == 1, a slowness+damage pool. ddddd = damage
; fff == 2, d any, a key with d keyId
; fff == 3, d any, a monster spawner, ddddd is a monsterId
;		monsterId = 0 - skeleton (tiledata = 3)
;		monsterId = 1 - vampire (tiledata = 7) 
;		monsterId = 2 - flame (tiledata = 11)
;		monsterId = 3 - knight (tiledata = 15)
;		monsterId = 4 - chest with money
;		monsterId = 5 - chest with monster
; fff == 4, d any, go to 0-31 room with d roomId, %1100 (12) - go to the roomId=1 room, %100 (4)
; fff == 5, d any, go to 32-63 room with d+32 roomId
; fff == 6, d == 0, ???
; fff == 7, d == %11111, collision
; fff == 7, d != %11111, ???

; this functions are used when the room initialized. check room.asm RoomInitTilesData func
roomFuncTable:		
			.word RoomTileDataCopy, RoomTileDataCopy, RoomMonsterSpawn, RoomTileDataCopy, RoomTileDataCopy, RoomTileDataCopy, RoomTileDataCopy

roomTilesData:
			.storage ROOM_WIDTH * ROOM_HEIGHT

; command that are handled by the level update func
LEVEL_COMMAND_NONE = 0
LEVEL_COMMAND_LOAD_DRAW_ROOM = 1
levelCommand:
			.byte LEVEL_COMMAND_NONE