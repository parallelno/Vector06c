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

			MVI A, PORT0_OUT_IN
			OUT 0
			XRA A
			OUT 3
			IN 2
			inr a
			STA anyKeyPressed
			MVI a, $fe
			OUT 3
			IN 2
			sta keyCode
			
			mvi a, PORT0_OUT_OUT
			OUT 0
			lda borderColorIdx
			OUT 2
			lda scrOffsetY
			OUT 3
			
			lxi h, interruptionCounter
			inr m

			; end common interruption logic
			POP		D
			POP		B
			POP		PSW
@restoreHL:	LXI		H, TEMP_ADDR
@restoreSP:	LXI		SP, TEMP_ADDR
			EI
@return:	JMP		TEMP_ADDR
			.closelabels

;----------------------------------------------------------------
; Common interruption sub
/*
Interruption1:
			PUSH	PSW
			PUSH	B
			PUSH	D
			PUSH	H

			; common interruption logic
	MVI A, PORT0_OUT_IN
	OUT 0
	XRA A
	OUT 3
	IN 2
	STA anyKeyPressed
	MVI A,$FE
	OUT 3
	IN 2
	STA keyCode

	mvi a, PORT0_OUT_OUT
	OUT 0
	lda borderColorIdx
	OUT 2
	lda scrOffsetY
	OUT 3
			; end common interruption logic
			POP		H
			POP		D
			POP		B
			POP		PSW
			EI
			RET
			.closelabels
*/