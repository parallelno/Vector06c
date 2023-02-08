; a tile data handler. 
; tileData should be in the format: DDDDDfff
;		fff is a handler func idx in the funcTable
;		DDDDD is an argument for a handler func
; call a handler func with DDDDD stored in a, b = tileData, c = tileIdx
; input:
; hl - a pointer to a tile data in a format DDDDDfff.

; keeps hl unchanged
; use:
; de, a
; bc - depends on the func in the funcTable
.macro TILE_DATA_HANDLE_FUNC_CALL(funcTable, skipFuncZero = false)
			mov a, m
			push h	
			; extract a function
			ani TILE_DATA_FUNC_MASK
		.if skipFuncZero
			; if funcId == 0, that means it is an walkable (non-interactable) tile, we skip it.
			jz @funcReturnAddr
		.endif
			add_a(2) ; to make a ptr to a jmp table with 4 byte allignment
			mov e, a
			mvi d, 0
			; extract a func argument
			mov a, m
			rrc_(3)
			ani %00011111
			lxi h, funcTable
			dad d
			lxi d, @funcReturnAddr
			push d
			pchl
@funcReturnAddr:
			pop h
.endmacro