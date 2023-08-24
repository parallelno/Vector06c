
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
interruption:
			; get the return addr which this interruption call stored into the stack
			xthl
			shld interruption_return + 1
			pop h
			shld interruption_restoreHL + 1
			; store psw as the first element in the interruption stack
			; because the following dad psw corrupts it
			push psw
			pop h
			shld STACK_INTERRUPTION_ADDR-2
			
			lxi h, 0
			dad sp
			shld interruption_restoreSP + 1

			; restore two bytes that were corrupted by this interruption call
			push b

			; dismount ram disks to not damage the ram-disk data with the interruption stack
			RAM_DISK_OFF_NO_RESTORE()
			lxi sp, STACK_INTERRUPTION_ADDR-2
			push b
			push d

			call music_player_segaboy_loop

;======================================================================================================================			
;
;			; interruption main logic end

			pop d
			pop b
			pop psw
			mov l, a
			; restore the ram-disk mode
			; ram_disk_mode doesn't guarantee that a ram-disk is in this mode already. that mode could be applied only after the next command in the main program
			RAM_DISK_RESTORE()
			; restore A
			mov a, l

interruption_restoreHL:	
			lxi		h, TEMP_WORD
interruption_restoreSP:	
			lxi		sp, TEMP_ADDR
			ei
interruption_return:	
			jmp TEMP_ADDR