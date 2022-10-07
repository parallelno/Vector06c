keyCode:
			.word $0201 ; low byte - a key code, hi byte - a previous frame key code
anyKeyPressed:
			.byte TEMP_BYTE

borderColorIdx:
			.byte TEMP_BYTE
scrOffsetY:
			.byte 255

; it is used to check how many interruptions happened since the last game uppdate
interruptionCounter: 
			.byte TEMP_BYTE

ramDiskMode:
			.byte TEMP_BYTE

currentFps:
			.byte TEMP_BYTE
; a lopped counter increased every game draw
gameDrawsCounter:
			.byte TEMP_BYTE

; a lopped counter increased every game update
gameUpdateCounter:
			.byte TEMP_BYTE

; a counter decreased from INTS_PER_SEC to 0 every iterruption
intsPerSecCounter:
			.byte INTS_PER_SEC 

; used for the movement
charTempX:	.word 0 ; temporal X
charTempY:	.word 0 ; temporal Y