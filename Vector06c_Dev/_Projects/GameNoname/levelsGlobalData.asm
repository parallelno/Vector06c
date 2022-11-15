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
; fff == 2, a key. keyId = d
; fff == 3, a monster spawner, monsterId = d
;		monsterId = 0 - skeleton (tiledata = 3)
;		monsterId = 1 - vampire (tiledata = 11) 
;		monsterId = 2 - flame (tiledata = 19)
;		monsterId = 3 - knight (tiledata = 27)
;		monsterId = 4 - chest with money
;		monsterId = 5 - chest with monster
; fff == 4, teleport, roomId = d, go to 0-31 room , ex. tileData = %1100 (12) - teleport to the roomId=1, %100 (4) teleport to the roomId=0
; fff == 5, teleport, roomId = d+32, go to 32-63 room
; fff == 6, ???
; fff == 7, d == %11111, collision
; fff == 7, d == 0, no collision, restore background (tiledata = 7)
; fff == 7, d != %11111, ???

; tileData - collision
TILE_DATA_COLLISION = %11111111

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