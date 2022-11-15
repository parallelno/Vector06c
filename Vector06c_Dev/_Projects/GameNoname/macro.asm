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

.macro RAL_(i)
		.loop i
			ral
		.endloop
.endmacro

.macro RLC_(i)
		.loop i
			rlc
		.endloop
.endmacro

.macro PUSH_B(i)
		.loop i
			push b
		.endloop
.endmacro

.macro PUSH_H(i)
		.loop i
			push h
		.endloop
.endmacro

.macro POP_H(i)
		.loop i
			pop h
		.endloop
.endmacro

.macro INR_D(i)
		.loop i
			inr d
		.endloop
.endmacro

.macro INX_H(i)
		.loop i
			inx h
		.endloop
.endmacro

.macro INX_D(i)
		.loop i
			inx d
		.endloop
.endmacro

.macro DCX_H(i)
		.loop i
			dcx h
		.endloop
.endmacro

.macro INR_L(i)
		.loop i
			inr l
		.endloop
.endmacro

.macro INR_H(i)
		.loop i
			inr h
		.endloop
.endmacro

.macro INR_A(i)
		.loop i
			inr a
		.endloop
.endmacro

.macro NOP_(i)
		.loop i
			nop
		.endloop
.endmacro

.macro LXI_B_TO_DIFF(offsetTo, offsetFrom)
		offsetAddr = offsetTo - offsetFrom
		.if offsetAddr > 0
			lxi b, offsetAddr
		.endif
		.if offsetAddr < 0
			lxi b, $ffff + offsetAddr + 1
		.endif
.endmacro

.macro LXI_D_TO_DIFF(offsetTo, offsetFrom)
		offsetAddr = offsetTo - offsetFrom
		.if offsetAddr > 0
			lxi d, offsetAddr
		.endif
		.if offsetAddr < 0
			lxi d, $ffff + offsetAddr + 1
		.endif
.endmacro

.macro LXI_H_TO_DIFF(offsetTo, offsetFrom)
		offsetAddr = offsetTo - offsetFrom
		.if offsetAddr > 0
			lxi h, offsetAddr
		.endif
		.if offsetAddr < 0
			lxi h, $ffff + offsetAddr + 1
		.endif
.endmacro


;================================== ALL RAM_DISK_* macros has to be placed BEFORE lxi sp, *, and sphl! ;==================================
; has to be placed right BEFORE lxi sp, addr, and sphl
; mount the ram-disk w/o storing mode
.macro RAM_DISK_ON_NO_RESTORE(_command)
			mvi a, _command
			out $10
.endmacro
; restore the ram-disk mode
.macro RAM_DISK_RESTORE()
			lda ramDiskMode
			out $10
.endmacro
; mount the ram-disk
; has to be placed right BEFORE lxi sp, addr, and sphl
.macro RAM_DISK_ON(_command)
			mvi a, _command
			sta ramDiskMode
			out $10
.endmacro
; mount the ram-disk
; has to be placed right BEFORE lxi sp, addr, and sphl
; a - ram disk activation command
.macro RAM_DISK_ON_BANK()
			sta ramDiskMode
			out $10
.endmacro

.macro RAM_DISK_ON_BANK_NO_RESTORE()
			out $10
.endmacro

; dismount the ram-disk
; has to be in the main program only and be placed after lxi sp, ADDR or sphl
.macro RAM_DISK_OFF(useXRA = true)
		.if useXRA
			xra a
		.endif
		.if useXRA == false
			mvi a, 0
		.endif
			sta ramDiskMode			
			out $10
.endmacro
; dismount the ram-disk w/o storing mode
; should be used inside the interruption call or with disabled interruptions
.macro RAM_DISK_OFF_NO_RESTORE(useXRA = true)
		.if useXRA
			xra a
		.endif
		.if useXRA == false
			mvi a, 0
		.endif
			out $10
.endmacro
;==================================================================================================
.macro CALL_RAM_DISK_FUNC(funcAddr, _command, disableInt = false, useXRA = true)
		.if disableInt
			di
		.endif
			RAM_DISK_ON(_command)
			call funcAddr
			RAM_DISK_OFF(useXRA)
		.if disableInt
			ei
		.endif
.endmacro

.macro CALL_RAM_DISK_FUNC_NO_RESTORE(funcAddr, _command, disableInt = false, useXRA = true)
		.if disableInt
			di
		.endif
			RAM_DISK_ON_NO_RESTORE(_command)
			call funcAddr
			RAM_DISK_OFF_NO_RESTORE(useXRA)
		.if disableInt
			ei
		.endif
.endmacro

.macro DEBUG_BORDER_LINE(_borderColorIdx = 1)
		.if SHOW_CPU_HIGHLOAD_ON_BORDER
			mvi a, PORT0_OUT_OUT
			out 0
			mvi a, _borderColorIdx
			out 2
			lda scrOffsetY
			out 3
		.endif
.endmacro

.macro DEBUG_HLT()
		.if SHOW_CPU_HIGHLOAD_ON_BORDER
			hlt
		.endif
.endmacro

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
		