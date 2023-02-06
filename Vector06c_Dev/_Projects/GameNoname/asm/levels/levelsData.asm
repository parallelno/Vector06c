; TODO: do we need it?
; list of adresses of compressed levels 
levelsAddr:		.word TEMP_ADDR, 0
; TODO: do we need it?
; current level index in levelsAddr
levelIdx:
				.byte 0
; current room index in roomsAddr of the current level
roomIdx:
				.byte 0 ; 0 - 127 ; TODO: find why it says it's <128

; the address table to tile graphics
roomTilesAddr:
				.storage ROOM_WIDTH * ROOM_HEIGHT * ADDR_LEN

; tile data format: 
; it's stored in roomTilesData
; %DDDDDfff for every tile
; fff	- func
; ddddd	- argument
; fff == 0, d == 0, nothing, walkable
; fff == 1, a slowness+damage pool. ddddd = damage
; fff == 2, a key. keyId = d
; fff == 3, a monster spawner, monsterId = d
;		monsterId = 0 - skeleton (tiledata = 3+0=3)
;		monsterId = 1 - vampire (tiledata = 3+1*8=11) 
;		monsterId = 2 - burner (tiledata = 3+2*8=19)
;		monsterId = 3 - knight horizontal walk (tiledata = 3+3*8=27)
;		monsterId = 4 - knight vertical walk (tiledata = 3+4*8=35)
;		monsterId = 5 - chest with money
;		monsterId = 6 - chest with monster
; fff == 4, teleport, roomId = d, go to 0-31 room , ex. tileData = %1100 (12) - teleport to the roomId=1, %100 (4) teleport to the roomId=0
; fff == 5, teleport, roomId = d+32, go to 32-63 room
; fff == 6, ???
; fff == 7, d == %11111, collision
; fff == 7, d == 0, no collision, restore background (tiledata = 7)
; fff == 7, d != %11111, ???

; this functions are used during a room initialization. check room.asm RoomInitTilesData func
roomFuncTable:		
			JMP_4(RoomTileDataCopy)
			JMP_4(RoomTileDataCopy)
			JMP_4(RoomTileDataCopy)
			JMP_4(RoomMonsterSpawn)
			JMP_4(RoomTileDataCopy)
			JMP_4(RoomTileDataCopy)
			JMP_4(RoomTileDataCopy)
			JMP_4(RoomTileDataCopy)

roomTilesData:
			.storage ROOM_WIDTH * ROOM_HEIGHT

; command that are handled by the level update func
LEVEL_COMMAND_NONE = 0
LEVEL_COMMAND_LOAD_DRAW_ROOM = 1
levelCommand:
			.byte LEVEL_COMMAND_NONE