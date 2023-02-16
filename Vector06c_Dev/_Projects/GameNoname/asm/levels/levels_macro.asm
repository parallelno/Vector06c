; a tile data handler. 
; tile_data should be in the format: ffffDDDD
;		ffff is a func_id oh a func handler in the func_table
;		DDDD is a func argument
; call a handler func with DDDD stored in a, bc passed in the func depends on the context
; input:
; hl - a pointer to a tile data in a format ffffDDDD.
; keeps hl unchanged
; use:
; de, a
; bc - depends on the func in the func_table
.macro TILE_DATA_HANDLE_FUNC_CALL(func_table, skipFuncZero = false)
			mov a, m
			push h	
			; extract a function
			ani TILE_DATA_FUNC_MASK
		.if skipFuncZero
			; if func_id == 0, that means it is an walkable (non-interactable) tile, we skip it.
			jz @funcReturnAddr
		.endif
			rrc_(2) ; to make a jmp table ptr with a 4 byte allignment
			mov e, a
			mvi d, 0
			; extract a func argument
			mov a, m
			ani TILE_DATA_ARG_MASK
			lxi h, func_table
			dad d
			lxi d, @funcReturnAddr
			push d
			pchl
@funcReturnAddr:
			pop h
.endmacro