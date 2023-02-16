; animated background tiles. they are drawn directly on the screen.
; they have low anim speed and limited frame numbers.

; max backs in the room
BACKS_MAX = 10

BACK_RUNTIME_DATA_DESTR = $fc ; a back is ready to be destroyed
BACK_RUNTIME_DATA_EMPTY = $fd ; a back data is available for a new back
BACK_RUNTIME_DATA_LAST	= $fe ; the end of the last existing back data
BACK_RUNTIME_DATA_END	= $ff ; the end of the data

back_for_update_ptr:	.word TEMP_ADDR ; pointer to a runtime data of a back which will be drawn
back_for_draw_ptr:		.word TEMP_ADDR ; pointer to a runtime data of a back which will be drawn
; a list of back runtime data structs.
backs_runtime_data:
back_anim_ptr:			.word TEMP_ADDR
back_scr_addr:			.word TEMP_WORD
back_anim_timer:		.byte TEMP_BYTE
back_anim_timer_speed:	.byte TEMP_BYTE
back_runtime_data_end_addr:

BACK_RUNTIME_DATA_LEN = back_runtime_data_end_addr - backs_runtime_data

; the same structs for the rest of the backs
.storage BACK_RUNTIME_DATA_LEN * (BACKS_MAX-1), 0
backs_runtime_data_end_addr:	.word BACK_RUNTIME_DATA_END << 8


backs_init:
			; erase backs_runtime_data
			mvi a, BACK_RUNTIME_DATA_LAST
			sta back_anim_ptr + 1
			; set the first back in the runtime data to be updated and drawn
			lxi h, back_anim_ptr
			shld back_for_update_ptr
			shld back_for_draw_ptr
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
			jc @nextData
			cpi BACK_RUNTIME_DATA_LAST
			jnz @backsTooMany
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
@backsTooMany:
			; return bypassing a func that called this func
			pop psw
			ret
@nextData:
			lxi d, BACK_RUNTIME_DATA_LEN
			dad d
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

; a tile data handler to spawn an animated background tile by its id.
; input:
; b - tile data
; c - tile idx in the room_tiles_data array.
; a - back_id
; out:
; a - tile_data that will be saved back into room_tiles_data
backs_spawn:
			call backs_get_empty_data_ptr
			; hl - ptr to back_update_ptr+1
			; advance hl to back_anim_ptr
			dcx h
			push h
			; back_id to back_anim_ptr
			lxi h, backs_anims
			mov a, b
			ani TILE_DATA_ARG_MASK
			add a ; make a ptr to an anim which depends on back_id
			mov e, a
			mvi d, 0
			dad d
			; load an anim ptr
			mov e, m
			inx h
			mov d, m
			call random
			ani %11
			; advance to the next frame A reg times
			xchg
@nextFrame:
			; load an offset to the next frame
			mov e, m 
			inx h
			mov d, m
			; advance back_anim_ptr to the next frame
			dad d
			dcr a
			jnz @nextFrame

			xchg
			pop h
			; store it into back_anim_ptr
			mov m, e
			inx h
			mov m, d

			; advance hl to back_scr_addr
			inx h
			; scr_y = tile idx % ROOM_WIDTH
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
			xchg
			call random
			xchg
			mov m, a
			; advance hl to back_anim_timer_speed
			inx h
			mvi m, 50
			mvi a, TILE_DATA_COLLISION	
			ret

backs_update:
			lxi h, back_for_update_ptr
			; load ptr to back_anim_ptr
			mov e, m
			inx h
			mov d, m
			; advance hl to back_anim_timer_speed
			LXI_H_TO_DIFF(back_anim_timer_speed, back_anim_ptr)
			dad d
			mov a, m
			; advance hl to back_anim_timer
			dcx h
			; back_anim_timer += back_anim_timer_speed
			add m
			mov m, a
			jnc @updateBackForUpdatePtr
			; back_anim_timer got overloaded, so it needs to be drawn			
@updateBackForDrawPtr:
			LXI_D_TO_DIFF(back_anim_ptr, back_anim_timer)
			dad d
			shld back_for_draw_ptr

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
			; store back_anim_ptr
			xchg
			mov m, d
			dcx h
			mov m, e
			lxi d, BACK_RUNTIME_DATA_LEN + 1
			jmp @updateBackForUpdatePtr2
@updateBackForUpdatePtr:
			LXI_D_TO_DIFF(back_anim_ptr+1 + BACK_RUNTIME_DATA_LEN, back_anim_timer)
@updateBackForUpdatePtr2:
			dad d
			mov a, m
			cpi BACK_RUNTIME_DATA_EMPTY
			jc @thisIsNotTheEnd
@resetBackForUpdatePtr
			lxi h, back_anim_ptr
			shld back_for_update_ptr
			ret

@thisIsNotTheEnd:
			; store the next runtime data ptr to back_for_update_ptr
			dcx h
			shld back_for_update_ptr
			ret


backs_draw:
			lxi h, back_for_draw_ptr
			; check the back_anim_ptr stored in back_for_draw_ptr
			mov e, m
			inx h
			mov a, m
			ora e
			rz
			; if back_anim_ptr != 0, a frame was updated and it needs to draw
			mov d, m
			; de is a ptr to back_anim_ptr
			; erase back_for_draw_ptr to not draw it ugain until it goes to the next frame
			lxi h, 0
			shld back_for_draw_ptr
			xchg
			; load back_anim_ptr
			mov e, m
			inx h
			mov d, m
			xchg
			; hl points to an offset to the next frame
			; so advance hl to a frame ptr
			inx_h(2)
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

