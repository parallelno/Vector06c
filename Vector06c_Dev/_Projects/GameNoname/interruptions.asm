
.macro RND_TEST()
RND_TEST_ST_ADDR = $8000
@addr:	
		lxi h, RND_TEST_ST_ADDR
		push h
		call Random
		pop h
		mov m, a
		inx h
		mov a, h
		cpi $a0
		jnz @cont
		lxi h, RND_TEST_ST_ADDR
@cont:
		shld @addr+1
.endmacro

.macro INTERRUPTION_MAIN_LOGIC()
			; interruption logic

			mvi a, PORT0_OUT_IN
			out 0
			xra a
			out 3
			IN 2
			inr a
			sta anyKeyPressed
			mvi a, $fe
			out 3
			IN 2
			sta keyCode
			
			mvi a, PORT0_OUT_OUT
			out 0
			lda borderColorIdx
			out 2
			lda scrOffsetY
			out 3
			
			lxi h, interruptionCounter
			inr m
.endmacro

;----------------------------------------------------------------
; The interruption sub which supports stack manipulations in 
; the main program without stopping it.

; If the main program is doing "pop RP" operation to read the data, 
; and an interruption happens, then i8080 performs "push PC" corrupting 
; the data sp is pointing to. The interruption sub below restores the 
; corrupted data using the BC register pair. To make it work the main
; program has to use only pop B when it reads the stack data. Also the
; data read by stack has to have two extra bytes 0,0 in back of the
; actual data at the addresses dataPointer-1, dataPointer-2, to not let
; the "push PC" corrupts the data before BC pair gets it.

Interruption2:
			; restore the Stack
			xthl
			shld @return + 1
			pop h
			shld @restoreHL + 1
			lxi h, 2
			; store AF bcause dad psw change it
			push psw
			dad sp
			; restore AF
			pop psw
			shld @restoreSP + 1
			push b
			lxi sp, STACK_TEMP_ADDR
			push psw
			push b
			push d

			INTERRUPTION_MAIN_LOGIC()
			;RND_TEST()

			pop d
			pop b
			pop psw
@restoreHL:	lxi		h, TEMP_ADDR
@restoreSP:	lxi		sp, TEMP_ADDR
			ei
@return:	jmp TEMP_ADDR
			.closelabels

;----------------------------------------------------------------
; Common interruption sub
/*
Interruption1:
			push psw
			push b
			push d
			push h

			INTERRUPTION_MAIN_LOGIC()

			pop h
			pop d
			pop b
			pop psw
			ie
			ret
			.closelabels
*/