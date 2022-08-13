.macro HLT_(i)
			.loop i
			hlt
			.endloop
.endmacro

.macro RRC_(i)
			.loop i
			rrc
			.endloop
.endmacro

.macro RLC_(i)
			.loop i
			rlc
			.endloop
.endmacro

.macro PUSH_B(i)
			.loop i
			push B
			.endloop
.endmacro

.macro INR_D(i)
			.loop i
			inr D
			.endloop
.endmacro

.macro DCX_H(i)
			.loop i
			dcx h
			.endloop
.endmacro


.macro BORDER_LINE(borderColorIdx = 1)
			mvi a, PORT0_OUT_OUT
			OUT 0
			mvi a, borderColorIdx
			OUT 2
			lda scrOffsetY
			OUT 3
.endmacro

; gets DDDDDfff from (hl), extracts fff which is a func idx in the funcTable
; call that func with DDDDD as an argument
; input:
; hl - addr to the tile data
; keeps hl unchanged
; a - tile data func argument
; uses:
; de
.macro TILE_DATA_HANDLE_FUNC_CALL(funcTable)
			mov a, m
			push h	
			; extract a function
			ani %00000111
			; if it's %000, that means it is an empty tile and we can skip it.
			jz @funcReturnAddr
			dcr a ; we do not need to handle funcId == 0
			rlc
			mov e, a
			mvi d, 0
			; extract a func argument
			mov a, m
			rrc_(3)
			ani %00011111
			; get the func addr which handles that tile data
			lxi h, funcTable
			dad d
			mov e, m
			inx h
			mov d, m
			xchg
			lxi d, @funcReturnAddr
			push d
			pchl
@funcReturnAddr:
			pop h		
.endmacro
		