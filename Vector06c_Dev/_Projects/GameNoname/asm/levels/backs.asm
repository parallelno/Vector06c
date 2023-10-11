; animated background tiles. they are drawn directly on the screen.
; they have low anim speed and limited frame numbers.
; they do not have an alpha channel

backs_init:
			; erase runtime_data
			mvi a, ACTOR_RUNTIME_DATA_LAST
			sta back_anim_ptr + 1
			; set the last marker byte of runtime_data
			mvi a, ACTOR_RUNTIME_DATA_END
			sta backs_runtime_data_end_marker + 1
			
			; set the first back in the runtime data to be updated and drawn
			lxi h, backs_runtime_data + 1
			shld back_runtime_data_ptr_update
			
			; disable drawing
			mvi a, BACK_DRAW_DISABLED
			sta backs_draw
			ret

; a tiledata handler to spawn an animated background tile by its id.
; input:
; b - tiledata
; c - tile_idx in the room_tiledata array.
; a - back_id (not used)
; out:
; a - tiledata that will be saved back into room_tiledata
backs_spawn:
			lxi h, back_anim_ptr + 1
			mvi e, BACK_RUNTIME_DATA_LEN
			call actor_get_empty_data_ptr
			rnz ; return because too many objects

			; hl - ptr to back_update_ptr+1
			; advance hl to back_anim_ptr
			dcx h
			push h
			; back_id to back_anim_ptr
			lxi h, backs_anims
			mov a, b
			ani TILEDATA_ARG_MASK
			add a ; make a ptr to an anim which depends on back_id
			mov e, a
			mvi d, 0
			dad d
			; load an anim ptr
			mov e, m
			inx h
			mov d, m
			call random
			ani %11 ; advance to a frame N = rnd(256) % 4
			; advance to the next frame A reg times
			xchg
@next_frame:
			; load an offset to the next frame
			mov e, m 
			inx h
			mov d, m
			; advance back_anim_ptr to the next frame
			dad d
			dcr a
			jnz @next_frame

			xchg
			pop h
			; store it into back_anim_ptr
			mov m, e
			inx h
			mov m, d

			; advance hl to back_scr_addr
			inx h
			; scr_y = tile_idx % ROOM_WIDTH
			mvi a, %11110000
			ana c
			mov m, a
			; advance hl to back_scr_addr+1
			inx h
			; c - tile_idx
			; scr_x = tile_idx % ROOM_WIDTH * TILE_WIDTH_B + SCR_ADDR
			mvi a, %00001111
			ana c
			rlc
			adi >SCR_ADDR
			mov m, a
			; advance hl to back_anim_timer and reset it
			inx h
			xchg	; save hl
			call random
			xchg	; restore hl
			mov m, a
			; advance hl to back_anim_timer_speed
			inx h
			; TODO: use different speeds or do not store unique back_anim_timer_speed for every back
			; if you do not store unique back_anim_timer_speed for every back
			; then you save one dcx h per frame and one byte per back. small improvements. that's why it is here.
			mvi m, BACK_ANIM_TIMER_SPEED
			mvi a, TILEDATA_COLLISION	
			ret

backs_update:
back_runtime_data_ptr_update: = backs_update+1
			lxi h, backs_runtime_data + 1
			mov a, m
			cpi ACTOR_RUNTIME_DATA_EMPTY
			jz @set_next_back
			cpi ACTOR_RUNTIME_DATA_LAST
			jz @set_first_back

@update_anim:
			; advance hl to back_anim_timer_speed
			MVI_A_TO_DIFF(back_anim_ptr+1, back_anim_timer_speed)
			add l
			mov l, a

			mov a, m
			; advance hl to back_anim_timer
			dcx h
			; back_anim_timer += back_anim_timer_speed
			add m
			mov m, a
			jnc @set_next_back ; if back_anim_timer is not overloaded, set the next back for the next update
			
@set_draw_ptr:
			; back_anim_timer got overloaded, so it needs to be drawn			
			MVI_A_TO_DIFF(back_anim_timer, back_anim_ptr + 1)
			add l
			mov l, a

			; go to the next frame
			; load back_anim_ptr
			mov d, m
			; advance hl to back_anim_ptr
			dcx h 
			mov e, m
			
			; store ptr to back_anim_ptr into back_runtime_data_ptr_draw
			shld back_runtime_data_ptr_draw
			; enable drawing
			mvi a, BACK_DRAW_ENABLED
			sta backs_draw
			
			xchg
			; load an offset to the next frame
			mov c, m
			inx h 
			mov b, m 
			; advance back_anim_ptr to the next frame
			dad b
			xchg
			; store the next frame ptr to back_anim_ptr
			mov m, e
			; advance hl to back_anim_ptr + 1
			inx h
			mov m, d
			MVI_A_TO_DIFF(back_anim_ptr+1, back_anim_ptr + 1 + BACK_RUNTIME_DATA_LEN)
			jmp @advance_and_save_ptr
@set_first_back:
			mvi a, <backs_runtime_data + 1
			jmp @save_ptr
@set_next_back:
			; back_anim_timer is not overloaded, set the next back for the next update
			MVI_A_TO_DIFF(back_anim_timer, back_anim_ptr + 1 + BACK_RUNTIME_DATA_LEN)
@advance_and_save_ptr:
			add l
			mov l, a			
@save_ptr:	sta back_runtime_data_ptr_update			
			ret

backs_draw:
back_runtime_data_ptr_draw: = backs_draw + 1
			lxi h, backs_runtime_data ; this can be replaced with OPCODE_RET is no draw needed
			mvi a, BACK_DRAW_ENABLED ; disable to not draw until it needs
			sta backs_draw
			; hl - ptr to back_anim_ptr
			; load back_anim_ptr
			mov e, m
			inx h
			mov d, m
			xchg
			; hl points to an offset to the next frame
			; so advance hl to a frame ptr
			INX_H(2)
			; load a frame addr
			mov c, m
			inx h
			mov b, m
			xchg
			; advance hl to back_scr_addr
			inx h
			; load back_scr_addr
			mov e, m
			inx h
			mov d, m
			CALL_RAM_DISK_FUNC(draw_back_v, __RAM_DISK_S_BACKS)
			ret

