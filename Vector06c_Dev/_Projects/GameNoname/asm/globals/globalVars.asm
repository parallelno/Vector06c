
; low byte	- Down, Right, Up, Left, ЗБ (DEL), ВК (Enter), ПС (Alt), TAB (Tab)
; hi byte 	- SPC, ^, ], \, [, Z, Y, X
keyCode:
			.word KEY_NO << 8 | ~KEY_NO
; key code of a previous update
keyCodeOld:
			.word KEY_NO << 8 | ~KEY_NO

borderColorIdx:
			.byte TEMP_BYTE
scrOffsetY:
			.byte 255

; it is used to check how many updates needs to happened to sync with Interruptions
updateRequestCounter:
			.byte TEMP_BYTE

ramDiskMode:
			.byte TEMP_BYTE
; it gets updated every second
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