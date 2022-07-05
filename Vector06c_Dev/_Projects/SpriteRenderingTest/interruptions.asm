;----------------------------------------------------------------
; The interruption sub which supports stack manipulations in 
; the main program without stopping it.

; If the main program use POP operation to read the data, 
; and an interruption happens, then i8080 performs "PUSH PC" 
; corrupting the data SP pointing to. This interruption sub 
; restores corrupted data using the BC register pair, so to 
; make it work the main program has to use only POP B when 
; it reads the stack data.
; Also the data read by stack has to have two extra bytes 0,0 
; in back of the actual data at the adresses dataPointer-1, 
; dataPointer-2, to not let the "PUSH PC" corrupts the data 
; before BC pair gets it.

			.function Interruption2F
Interruption2:
			; restore the Stack
			XTHL
			SHLD	@return + 1
			POP		H
			SHLD	@restoreHL + 1
			PUSH    PSW
			LXI		H, 2
			DAD		SP
			SHLD	@restoreSP + 1
			POP     PSW
			PUSH	B
			
			LXI		SP, STACK_TEMP_ADDR
			PUSH	PSW
			PUSH	B
			PUSH	D

			; common interruption logic
			LHLD	TIMER_COUNTER_ADDR
			DCX		H
			SHLD	TIMER_COUNTER_ADDR
			MOV		A, H
			ORA		L
			JNZ		@doNotStopTimer

			STA	TIMER_STOP_FLAG_ADDR	; запись 00 в фдаг остановки вывода спрайтов

@doNotStopTimer:
            ; end common interruption logic
			POP		D
			POP		B
			POP		PSW
@restoreHL:	LXI		H, TEMP_ADDR
@restoreSP:	LXI		SP, TEMP_ADDR
			EI
@return:	JMP		TEMP_ADDR
			.endfunction


;----------------------------------------------------------------
; Common interruption sub
;
			.function Interruption1F
Interruption1:
			PUSH	PSW
			PUSH	B
			PUSH	D
			PUSH	H

			; common interruption logic
			LHLD	TIMER_COUNTER_ADDR
			DCX		H
			SHLD	TIMER_COUNTER_ADDR
			MOV		A, H
			ORA		L
			JNZ	@doNotStopTimer
			; set the flag to 0
			STA	TIMER_STOP_FLAG_ADDR

@doNotStopTimer:
            ; end common interruption logic
			POP		H
			POP		D
			POP		B
			POP		PSW
			EI
			RET
			.endfunction