keyCode:
			.word $0201 ; low byte - a key code, hi byte - a previous frame key code
anyKeyPressed:
			.byte 0

borderColorIdx:
			.byte 0
scrOffsetY:
			.byte 255

; it is used to check how many interruptions happened since the last game uppdate
interruptionCounter: 
			.byte 0

; used for the movement
charTempX:	.word 0 ; temporal X
charTempY:	.word 0 ; temporal Y