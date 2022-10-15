.macro INTERRUPTION_MAIN_LOGIC()
			; keyboard check
			mvi a, PORT0_OUT_IN
			out 0
			mvi a, %11111110
			out 3
			in 2
			sta keyCode
			mvi a, %01111111
			out 3
			in 2
			sta keyCode+1		
			; a border color, scrolling set up
			mvi a, PORT0_OUT_OUT
			out 0
			;lda borderColorIdx
			;out 2
			lda scrOffsetY
			out 3
			; used in the main program to keep the update synced with interuption
			lxi h, interruptionCounter
			inr m

			; fps update
			lxi h, intsPerSecCounter
			dcr m
			jnz @skipSavingFps
			lxi h, gameDrawsCounter
			mov a, m
			mvi m, 0			
			sta currentFps
			call DrawFps
			lxi h, intsPerSecCounter
			mvi m, INTS_PER_SEC
@skipSavingFps:
			
.endmacro

;----------------------------------------------------------------
; The interruption sub which supports stack manipulations in 
; the main program without di/ei.

; If the main program is doing "pop RP" operation to read some data, 
; and an interruption happens, then i8080 performs "push PC" 
; corrupting the data where sp was pointing to. The interruption sub 
; below restores the corrupted data using BC register pair. To make
; it works the main program has to use only pop B when it needs to
; use the stack to manipulate the data, also the data read by stack
; has to have two extra bytes 0,0 stored in front of the actual data
; to not let the "push PC" corrupts the data before BC pair gets it.

Interruption2:
			; get the return addr which this interruption call stored into the stack
			xthl
			shld @return + 1
			pop h
			shld @restoreHL + 1
			; store psw as the first element in the interruption stack
			; because the following dad psw corrupts it
			push psw
			pop h
			shld STACK_INTERRUPTION_ADDR-2
			
			lxi h, 0
			dad sp
			shld @restoreSP + 1

			; restore two bytes that were corrupted by this interruption call
			push b

			; dismount ram disks to not damage the ram-disk data with the interruption stack
			RAM_DISK_OFF_NO_RESTORE()
			lxi sp, STACK_INTERRUPTION_ADDR-2
			push b
			push d


			call GCPlayerUpdate
			INTERRUPTION_MAIN_LOGIC()

			pop d
			pop b
			pop psw
			mov l, a
			; restore the ram-disk mode
			; ramDiskMode doesn't guarantee that a ram-disk is in this mode already. that mode could be applied only after the next command in the main program
			RAM_DISK_RESTORE()
			; restore A
			mov a, l

@restoreHL:	lxi		h, TEMP_WORD
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