
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

			CALL_RAM_DISK_FUNC_NO_RESTORE(__sound_update, __RAM_DISK_S_SOUND | __RAM_DISK_M_SOUND | RAM_DISK_M_8F)

;======================================================================================================================			
;
;			interruption main logic start
;
			call controls_check

			;check for a palette update
palette_update_request_:
			mvi a, PALETTE_UPD_REQ_NO ; this constant value is mutable, do not replace it with xra a
			CPI_WITH_ZERO(PALETTE_UPD_REQ_NO)
			jz @no_palette_update
			; set a palette
			; hl - the addr of the last item in the palette
			lxi h, palette + PALETTE_COLORS - 1
			call set_palette_int
			; reset update
			A_TO_ZERO(PALETTE_UPD_REQ_NO)
			sta palette_update_request

@no_palette_update:			
			; a border color, scrolling set up
			mvi a, PORT0_OUT_OUT
			out 0
			lda border_color_idx
			out 2
			lda scr_offset_y
			out 3
			; used in the main program to keep the update synced with interuption
@update_skipper:
			mvi a, %01010101
			rrc
			sta @update_skipper+1
			jnc @skip_update
			lxi h, game_updates_counter
			inr m
@skip_update:
			; fps update
			lxi h, ints_per_sec_counter
			dcr m

			jnz interruption_no_fps_update
			; a second is over
interruption_fps:
			lxi h, TEMP_WORD
			; hl - fps
			mov a, l
			lxi h, 0
			shld interruption_fps + 1
			; draw fps
			; a - <fps
			call draw_fps
			lxi h, ints_per_sec_counter
			mvi m, INTS_PER_SEC
interruption_no_fps_update:				
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

ints_per_sec_counter:
			.byte INTS_PER_SEC

; a lopped counter increased every game draw call
game_draws_counter = interruption_fps + 1
palette_update_request = palette_update_request_ + 1