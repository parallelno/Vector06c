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

.macro INR_M(i)
		.loop i
			inr m
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

.macro ADD_A(i)
		.loop i
			add a
		.endloop
.endmacro

.macro DAD_H(i)
		.loop i
			dad h
		.endloop
.endmacro

.macro LXI_B(val)
	.if val < 0
		lxi b, $ffff + val + 1
	.endif
	.if val >= 0
		lxi b, val
	.endif
.endmacro

.macro LXI_D(val)
	.if val < 0
		lxi d, $ffff + val + 1
	.endif
	.if val >= 0
		lxi d, val
	.endif
.endmacro

.macro LXI_H(val)
	.if val < 0
		lxi h, $ffff + val + 1
	.endif
	.if val >= 0
		lxi h, val
	.endif
.endmacro

.macro MVI_A_TO_DIFF(offset_from, offset_to)
		offset_addr = offset_to - offset_from
		.if offset_addr > 0
			mvi a, <offset_addr
		.endif
		.if offset_addr < 0
			mvi a, <($ffff + offset_addr + 1)
		.endif
.endmacro

.macro LXI_B_TO_DIFF(offset_from, offset_to)
		offset_addr = offset_to - offset_from
		.if offset_addr > 0
			lxi b, offset_addr
		.endif
		.if offset_addr < 0
			lxi b, $ffff + offset_addr + 1
		.endif
.endmacro

.macro LXI_D_TO_DIFF(offset_from, offset_to)
		offset_addr = offset_to - offset_from
		.if offset_addr > 0
			lxi d, offset_addr
		.endif
		.if offset_addr < 0
			lxi d, $ffff + offset_addr + 1
		.endif
.endmacro

.macro LXI_H_TO_DIFF(offset_from, offset_to)
		offset_addr = offset_to - offset_from
		.if offset_addr > 0
			lxi h, offset_addr
		.endif
		.if offset_addr < 0
			lxi h, $ffff + offset_addr + 1
		.endif
.endmacro
/*
.macro HL_FROM_TO_BY_BC(offset_from, offset_to)
		offset_addr = offset_to - offset_from

		LXI_B_TO_DIFF(offset_from, offset_to)
		dad b

		.if (offset_addr >= -2) && (offset_addr <= 2)
			;.error "HL_ADVANCE(" offset_from ", " offset_to") has too small diff (" offset_addr "). Use BC_FROM_TO instead."
		.endif					
.endmacro
*/
/*
.macro HL_FROM_TO_BY_DE(offset_from, offset_to)
		offset_addr = offset_to - offset_from

		LXI_D_TO_DIFF(offset_from, offset_to)
		dad d

		.if (offset_addr >= -2) && (offset_addr <= 2)
			.error "HL_FROM_TO_BY_DE(" offset_from ", " offset_to") has too small diff (" offset_addr "). Use HL_FROM_TO instead."
		.endif			
.endmacro
*/

; it advances HL by the diff equals to (addr_to - addr_from)
; if reg_pair is provided, it uses dad h, overvise it uses inx h/dcx h
; it validates the diff suggesting improvements
; supports only: REG_BC, REG_DE, REG_HL_DAD_B, REG_HL_DAD_D
.macro HL_ADVANCE(addr_from, addr_to, reg_pair = REG_NONE)
		diff_addr = addr_to - addr_from
		
	.if reg_pair == REG_NONE
		.if diff_addr > 0 && diff_addr <= 2
			.loop diff_addr
				inx h
			.endloop
		.endif
		.if diff_addr >= -2 && diff_addr < 0
			.loop -diff_addr
				dcx h
			.endloop
		.endif
	.endif
	.if diff_addr < -2 || diff_addr > 2
		.if reg_pair == REG_BC
				LXI_B_TO_DIFF(addr_from, addr_to)
				dad b
		.endif
		.if reg_pair == REG_DE
				LXI_D_TO_DIFF(addr_from, addr_to)
				dad d
		.endif
		.if reg_pair == REG_HL_DAD_B
				LXI_H_TO_DIFF(addr_from, addr_to)
				dad b
		.endif
		.if reg_pair == REG_HL_DAD_D
				LXI_H_TO_DIFF(addr_from, addr_to)
				dad d
		.endif		
	.endif
		; validations
		.if reg_pair == REG_NONE && (diff_addr < -2 || diff_addr > 2)
			.error "HL_ADVANCE(" addr_from ", " addr_to") with diff (" diff_addr ") is outside of the required range of [-2, 2]. Use REG_BC, REG_DE, REG_HL_DAD_D as the third argument."
		.endif		
		.if (reg_pair == REG_BC || reg_pair == REG_DE || reg_pair == REG_HL_DAD_B || reg_pair == REG_HL_DAD_D )  && diff_addr >= -2 && diff_addr <= 2
			.error "HL_ADVANCE(" addr_from ", " addr_to") with diff (" diff_addr ") is in too short range [-2, 2]. Keep the third argument as REG_NONE or undefined."
		.endif
		.if diff_addr == 0
			.error "HL_ADVANCE(" addr_from ", " addr_to") with diff (" diff_addr ") is detected. It's redundant operation."
		.endif	
		.if reg_pair == REG_A || reg_pair == REG_B || reg_pair == REG_C || reg_pair == REG_D || reg_pair == REG_E || reg_pair == REG_H || reg_pair == REG_L || reg_pair == REG_HL || reg_pair == REG_PSW || reg_pair == REG_PC || reg_pair == REG_SP
			.error "HL_ADVANCE() with unsupported regs is detected"
		.endif				
.endmacro

.macro LXI_H_NEG(val)
		lxi h, $ffff - val + 1
.endmacro

.macro LXI_D_NEG(val)
		lxi d, $ffff - val + 1
.endmacro

; to replace xra a with a meaningful macro
.macro A_TO_ZERO(int8_const, useXRA = true)
		.if int8_const != 0
			.error "A_TO_ZERO macros was used with a non-zero constant = ", int8_const
		.endif
		.if useXRA
			xra a
		.endif
		.if useXRA == false
			mvi a, 0
		.endif
.endmacro

; hl = a + int16_const
; 36 cc
.macro HL_TO_A_PLUS_INT16(int16_const)
			adi <int16_const
			mov l, a
			aci >int16_const
			sub l
			mov h, a
.endmacro

; bc = a + int16_const
; 36 cc
.macro BC_TO_A_PLUS_INT16(int16_const)
			adi <int16_const
			mov c, a
			aci >int16_const
			sub c
			mov b, a
.endmacro

; bc = a * 2 + int16_const
; cc = 40
.macro BC_TO_AX2_PLUS_INT16(int16_const)
			add a
			adi <int16_const
			mov c, a
			aci >int16_const
			sub c
			mov b, a
.endmacro
; de = a * 2 + int16_const
; cc = 40
.macro DE_TO_AX2_PLUS_INT16(int16_const)
			add a
			adi <int16_const
			mov e, a
			aci >int16_const
			sub e
			mov d, a
.endmacro
; hl = a * 2 + int16_const
; cc = 40
.macro HL_TO_AX2_PLUS_INT16(int16_const)
			add a
			adi <int16_const
			mov l, a
			aci >int16_const
			sub l
			mov h, a
.endmacro

; cc = 44 
.macro HL_TO_AX4_PLUS_INT16(int16_const)
			ADD_A(2)
			adi <int16_const
			mov l, a
			aci >int16_const
			sub l
			mov h, a
.endmacro

.macro CPI_WITH_ZERO(int8_const = 0)
		.if int8_const != 0
			.error "CPI_WITH_ZERO macros was used with a non-zero constant = ", int8_const
		.endif
		ora a
.endmacro

;================================== ALL RAM_DISK_* macros has to be placed BEFORE lxi sp, *, and sphl! ;==================================
; restore the ram-disk mode
.macro RAM_DISK_RESTORE()
			lda ram_disk_mode
			out $10
.endmacro
; mount the ram-disk w/o storing mode
.macro RAM_DISK_ON_NO_RESTORE(command)
			mvi a, <command
			out $10
.endmacro
; mount the ram-disk
; command is a ram disk activation command
.macro RAM_DISK_ON(command)
			mvi a, <command
			sta ram_disk_mode
			out $10
.endmacro
; mount the ram-disk
; a - ram disk activation command
; 28
.macro RAM_DISK_ON_BANK()
			sta ram_disk_mode
			out $10
.endmacro

.macro RAM_DISK_ON_BANK_NO_RESTORE()
			out $10
.endmacro

; dismount the ram-disk
; has to be in the main program only and be placed after lxi sp, ADDR or sphl
; cc 32
.macro RAM_DISK_OFF(useXRA = true)
			A_TO_ZERO(RAM_DISK_OFF_CMD, useXRA)
			sta ram_disk_mode			
			out $10
.endmacro
; dismount the ram-disk w/o storing mode
; should be used inside the interruption call or with disabled interruptions
.macro RAM_DISK_OFF_NO_RESTORE(useXRA = true)
			A_TO_ZERO(RAM_DISK_OFF_CMD, useXRA)
			out $10
.endmacro
;==================================================================================================
.macro CALL_RAM_DISK_FUNC(func_addr, _command, disable_int = false, useXRA = true)
		.if disable_int
			di
		.endif
			RAM_DISK_ON(_command)
			call func_addr
			RAM_DISK_OFF(useXRA)
		.if disable_int
			ei
		.endif
.endmacro

; a - ram disk activation command
.macro CALL_RAM_DISK_FUNC_BANK(func_addr, disable_int = false, useXRA = true)
		.if disable_int
			di
		.endif
			RAM_DISK_ON_BANK()
			call func_addr
			RAM_DISK_OFF(useXRA)
		.if disable_int
			ei
		.endif
.endmacro

.macro CALL_RAM_DISK_FUNC_NO_RESTORE(func_addr, _command, disable_int = false, useXRA = true)
		.if disable_int
			di
		.endif
			RAM_DISK_ON_NO_RESTORE(_command)
			call func_addr
			RAM_DISK_OFF_NO_RESTORE(useXRA)
		.if disable_int
			ei
		.endif
.endmacro

.macro DEBUG_BORDER_LINE(_borderColorIdx = 1)
		.if SHOW_CPU_HIGHLOAD_ON_BORDER
			mvi a, PORT0_OUT_OUT
			out 0
			mvi a, _borderColorIdx
			out 2
			lda scr_offset_y
			out 3
		.endif
.endmacro

.macro DEBUG_HLT()
		.if SHOW_CPU_HIGHLOAD_ON_BORDER
			hlt
		.endif
.endmacro
		
; for a jmp table with 4 byte allignment
.macro	JMP_4(DST_ADDR)
			jmp DST_ADDR
			nop
.endmacro
; for a jmp table with 4 byte allignment
.macro RET_4() ; 
			ret
			NOP_(3)
.endmacro

.macro CLAMP_A(val_max = $ff)
			cpi val_max + 1
			jc @no_clamp
			mvi a, val_max
@no_clamp:
.endmacro

.macro CLAMP_M(val_max = $ff)
			mov a, m
			cpi val_max + 1
			jc @no_clamp
			mvi m, val_max
@no_clamp:
.endmacro

; cc often 40
; cc rare 28
.macro INR_CLAMP_M(val_max = $ff)
			mov a, m
			cpi val_max
			jz @clamp
			inr m
@clamp:
.endmacro

; cc often 48
; cc rare 40
.macro INR_WRAP_M(val_max = $ff, no_wrap)
			inr m
			mvi a, val_max
			sub m
			jnz no_wrap
			mov m, a
.endmacro

.macro CHECK_GAME_UPDATE_COUNTER(@game_updates_required)
			; check if an interuption happened
			lxi h, @game_updates_required
			mov a, m
			ora a
			rz
			dcr m
.endmacro

.macro TEXT(string, end_code = _EOD_)
.encoding "screencode", "mixed"
			.text string
			.byte end_code
.endmacro



