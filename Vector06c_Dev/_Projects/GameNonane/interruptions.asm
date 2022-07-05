;----------------------------------------------------------------
; The interruption sub which supports stack manipulations in 
; the main program without stopping it.

; If the main program is doing "POP RP" operation to read the data, 
; and an interruption happens, then i8080 performs "PUSH PC" corrupting 
; the data SP is pointing to. The interruption sub below restores the 
; corrupted data using the BC register pair. To make it work the main
; program has to use only POP B when it reads the stack data. Also the
; data read by stack has to have two extra bytes 0,0 in back of the
; actual data at the addresses dataPointer-1, dataPointer-2, to not let
; the "PUSH PC" corrupts the data before BC pair gets it.

			.function Interruption2F
Interruption2:
			; restore the Stack
			XTHL
			SHLD	@return + 1
			POP		H
			SHLD	@restoreHL + 1
			LXI		H, 2
			PUSH    PSW
			DAD		SP
			POP     PSW
			SHLD	@restoreSP + 1
			PUSH	B
			LXI		SP, STACK_TEMP_ADDR
			PUSH	PSW
			PUSH	B
			PUSH	D

			; common interruption logic
			; MVI		A, PORT0_OUT_OUT
			; OUT		0
			; LDA  	1					; borderColorIdx
			; OUT		2
			; LDA		vScroll
			; OUT		3

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

            ; end common interruption logic
			POP		H
			POP		D
			POP		B
			POP		PSW
			EI
			RET
			.endfunction