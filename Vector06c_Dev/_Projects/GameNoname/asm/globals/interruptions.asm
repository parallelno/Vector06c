.include "asm\\globals\\sfx.asm"

.macro INTERRUPTION_MAIN_LOGIC()
			; keyboard check
			mvi a, PORT0_OUT_IN
			out 0
			mvi a, %11111110
			out 3
			in 2
			sta key_code
			mvi a, %01111111
			out 3
			in 2
			sta key_code+1		
			; a border color, scrolling set up
			mvi a, PORT0_OUT_OUT
			out 0
			lda border_color_idx
			out 2
			lda scr_offset_y
			out 3
			; used in the main program to keep the update synced with interuption
@updateSkipper:
			mvi a, %01010101
			rrc
			sta @updateSkipper+1
			jnc @skipUpdate
			lxi h, update_request_counter
			inr m
@skipUpdate:
			; fps update
			lxi h, ints_per_sec_counter
			dcr m
			jnz @skipSavingFps
/*
; TODO: test
			lxi h, game_draws_counter
			mov c, m
			mvi b, 0
@test_fps_counter:
			lxi h, 0
			dad b
			shld @test_fps_counter+1

@test_counter_in_sec:			
			mvi a, 200
			dcr a
			sta @test_counter_in_sec+1
@loop:
			jz @loop
; test end
*/

			lxi h, game_draws_counter
			mov a, m
			mvi m, 0			
			sta current_fps
			call draw_fps
			lxi h, ints_per_sec_counter
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

interruption:
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

			CALL_RAM_DISK_FUNC_NO_RESTORE(__gcplayer_update, __RAM_DISK_S_GCPLAYER | __RAM_DISK_M_GCPLAYER | RAM_DISK_M_8F)
			INTERRUPTION_MAIN_LOGIC()

			call sfx_play
			
			pop d
			pop b
			pop psw
			mov l, a
			; restore the ram-disk mode
			; ram_disk_mode doesn't guarantee that a ram-disk is in this mode already. that mode could be applied only after the next command in the main program
			RAM_DISK_RESTORE()
			; restore A
			mov a, l

@restoreHL:	lxi		h, TEMP_WORD
@restoreSP:	lxi		sp, TEMP_ADDR
			ei
@return:	jmp TEMP_ADDR
			