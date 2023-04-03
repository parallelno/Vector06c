; animated background tiles. they are drawn directly on the screen.
; they have low anim speed and limited frame numbers.
; they do not have an alpha channel

; max backs in the room
BACKS_MAX = 10

BACK_RUNTIME_DATA_DESTR = $fc ; a back is ready to be destroyed
BACK_RUNTIME_DATA_EMPTY = $fd ; a back data is available for a new back
BACK_RUNTIME_DATA_LAST	= $fe ; the end of the last existing back data
BACK_RUNTIME_DATA_END	= $ff ; the end of the data

BACK_NO_DRAW			= 0 ; it is stored in back_runtime_data_ptr_draw+1 to prevent back drawing every next update

BACKS_AMIN_TIMER_SPEED	= 50


backs_init:
			; erase backs_runtime_data
			mvi a, BACK_RUNTIME_DATA_LAST
			sta back_anim_ptr + 1
			; set the last marker byte of backs_runtime_data
			mvi a, BACK_RUNTIME_DATA_END
			sta backs_runtime_data_end_marker + 1
			; set the first back in the runtime data to be updated and drawn
			lxi h, backs_runtime_data
			shld back_runtime_data_ptr_update
			mvi a, BACK_NO_DRAW
			sta back_runtime_data_ptr_draw
			ret

; look up the empty spot in the back runtime data
; in:
; none
; return:
; hl - a ptr to back_anim_ptr + 1 of an empty back runtime data
; uses:
; de, a

; TODO: optimize. use a last_removed_back_runtime_data_ptr as a starter to find an empty data
backs_get_empty_data_ptr:
			lxi h, back_anim_ptr + 1
@loop:
			mov a, m
			cpi BACK_RUNTIME_DATA_EMPTY
			; return if it is an empty data
			rz
			jc @next_data
			cpi BACK_RUNTIME_DATA_LAST
			jnz @backs_too_many
			; it is the end of the last back data
			xchg
			lxi h, BACK_RUNTIME_DATA_LEN
			dad d
			mvi a, BACK_RUNTIME_DATA_END
			cmp m
			xchg
			; if the next after the last data is end, then just return
			rz
			; if not the end, then set it as the last
			xchg
			mvi m, BACK_RUNTIME_DATA_LAST
			xchg
			; TODO: optimize. store hl into last_removed_back_runtime_data_ptr
			ret
@backs_too_many:
			; return bypassing a func that called this func
			pop psw
			ret
@next_data:
			mvi a, <BACK_RUNTIME_DATA_LEN
			add l
			mov l, a
			jmp @loop

back_to_next_frame:
			xchg
			; load an offset to the next frame
			mov e, m 
			inx h
			mov d, m
			; advance back_anim_ptr to the next frame
			dad d
			; store back_anim_ptr
			xchg
			ret

; a tiledata handler to spawn an animated background tile by its id.
; input:
; b - tiledata
; c - tile_idx in the room_tiledata array.
; a - back_id
; out:
; a - tiledata that will be saved back into room_tiledata
backs_spawn:
			call backs_get_empty_data_ptr
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
			mvi m, BACKS_AMIN_TIMER_SPEED
			mvi a, TILEDATA_COLLISION	
			ret

backs_update:
back_runtime_data_ptr_update: = backs_update+1
			lxi h, backs_runtime_data
			; check if hl points to BACK_RUNTIME_DATA_LAST
			; advance hl to back_anim_ptr+1
			inx h
			mov a, m
			cpi BACK_RUNTIME_DATA_EMPTY
			jz @set_next_back
			cpi BACK_RUNTIME_DATA_LAST
			jnz @update_anim
@set_first_back:
			mvi a, <backs_runtime_data
			sta back_runtime_data_ptr_update
			ret	

@update_anim:
			; advance hl to back_anim_timer_speed
			MVI_A_TO_DIFF(back_anim_timer_speed, back_anim_ptr+1)
			add l
			mov l, a

			mov a, m
			; advance hl to back_anim_timer
			dcx h
			; back_anim_timer += back_anim_timer_speed
			add m
			mov m, a
			jnc @set_next_back2
			; back_anim_timer got overloaded, so it needs to be drawn			
@set_draw_ptr:
			MVI_A_TO_DIFF(back_anim_ptr, back_anim_timer)
			add l
			mov l, a
			shld back_runtime_data_ptr_draw

			; go to the next frame
			; load back_anim_ptr
			mov e, m
			inx h 
			mov d, m
			xchg
			; load an offset to the next frame
			mov c, m 
			inx h 
			mov b, m 
			; advance back_anim_ptr to the next frame
			dad b
			xchg
			; store the next frame ptr to back_anim_ptr
			mov m, d
			dcx h
			mov m, e
@set_next_back3:
			MVI_A_TO_DIFF(back_anim_ptr + BACK_RUNTIME_DATA_LEN, back_anim_ptr)
			add l
			sta back_runtime_data_ptr_update
			ret
@set_next_back:
			MVI_A_TO_DIFF(back_anim_ptr + BACK_RUNTIME_DATA_LEN, back_anim_ptr+1)
			add l
			mov l, a			
			sta back_runtime_data_ptr_update
			ret
@set_next_back2:
			MVI_A_TO_DIFF(back_anim_ptr + BACK_RUNTIME_DATA_LEN, back_anim_timer)
			add l
			mov l, a			
			sta back_runtime_data_ptr_update			
			ret	

backs_draw:
back_runtime_data_ptr_draw: = backs_draw + 1
			lxi h, TEMP_ADDR
			xra a
			ora h
			; if back_anim_ptr == 0, no draw needed
			rz
			; frame was updated and it needs to draw
			; hl - ptr to back_anim_ptr
			; erase back_runtime_data_ptr_draw to not draw it again until it goes to the next frame
			mvi a, BACK_NO_DRAW
			sta back_runtime_data_ptr_draw + 1
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
			CALL_RAM_DISK_FUNC(draw_back_v, <__RAM_DISK_S_BACKS)
			ret

