;=========================================================
; This is a quest bullet
; init: it gives a hero ITEM_ID_FART
; it lasts some certain time, then destroys itself
; when dies: it makes ITEM_ID_FART used
; when it is alive, it constantly spawns puff vfx 
; the quest to scary away knight_quest monster
;=========================================================

; statuses.
FART_STATUS_LIFE_TIME	= 10

fart_init:
; Init for non-preshifted VFX (x coord aligned to 8 pixels )
; in:
; bc - vfx screen addr
; de - anim_ptr (ex. vfx_puff)
; it utilizes bullet runtime data
;vfx_init:
			push d ; store vfx_anim_ptrs

			lxi h, bullet_update_ptr+1
			mvi e, BULLET_RUNTIME_DATA_LEN
			call actor_get_empty_data_ptr
			pop d ; d - vfx_anim_ptr
			rnz ; return because too many objects

			; hl - ptr to bullet_update_ptr+1
			; advance hl to bullet_update_ptr
			dcx h
			mvi m, <fart_update
			inx h 
			mvi m, >fart_update
			; advance hl to bullet_draw_ptr
			inx h 
			mvi m, <vfx_draw
			inx h 
			mvi m, >vfx_draw

			; advance hl to bullet_status_timer
			MVI_A_TO_DIFF(bullet_status_timer, bullet_draw_ptr + 1)
			add l
			mov l, a

			mvi m, FART_STATUS_LIFE_TIME

			; advance hl to bullet_anim_ptr
			INX_H(2)
			
			; de - vfx_anim_ptr
			mov m, e
			inx h			
			mov m, d

			; make a proper scr addr
			mvi a, %00011111
			ana b
			ori SPRITE_X_SCR_ADDR
			mov b, a

			mvi d, 2
			mvi e, 0
			; bc - screen addr
			; d = 2, anim ptr offset. used in a draw func
			; e = 0 and SPRITE_W_PACKED_MIN
			; hl - ptr to bullet_erase_scr_addr_old			
			
			; advance hl to bullet_erase_scr_addr
			inx h
			mov m, c
			inx h
			mov m, b
			; advance hl to bullet_erase_scr_addr_old
			inx h
			mov m, c
			inx h
			mov m, b
			; advance hl to bullet_erase_wh
			inx h
			mvi m, SPRITE_H_MIN
			inx h
			mov m, e
			; advance hl to bullet_erase_wh_old
			inx h
			mvi m, SPRITE_H_MIN
			inx h
			mov m, e
			; advance hl to bullet_pos_x
			inx h
			inx h
			mov m, b
			; advance hl to bullet_pos_y
			inx h
			mov m, d
			inx h
			mov m, c
			ret
			
; anim and a gameplay logic update
; in:
; de - ptr to bullet_update_ptr in the runtime data
fart_update:
			; advance to bullet_status_timer
			MVI_A_TO_DIFF(bullet_status_timer, bullet_update_ptr)
			add e
			mov e, a
			xchg
			; hl - ptr to bullet_update_ptr in the runtime data
@fraction_timer:
			mvi a, 1
			rlc
			sta @fraction_timer + 1
			jnc @update_movement

			dcr m
			jz @die

@update_movement:
			; hl - ptr to bullet_status_timer
			; advance hl to bullet_speed_y + 1
			MVI_A_TO_DIFF(bullet_pos_x + 1, bullet_status_timer)
			add l
			mov l, a

			; update pos
			xchg
			lhld hero_erase_scr_addr
			xchg

			mov m, d
			; advance hl to bullet_pos_y + 1
			INX_H(2)
			mov m, e

			MVI_A_TO_DIFF(bullet_anim_timer, bullet_pos_y + 1)
			add l
			mov l, a
			; update_anim
			mvi a, SPARKER_ANIM_SPEED_MOVE
			call actor_anim_update
			ret
@die:
			; time is over, destroy fart vfx, if the fart hasn't been used yet (acquired), make it not_acquired
			lxi d, global_items + ITEM_ID_FART - 1	; because the first item_id = 1
			ldax d
			cpi ITEM_STATUS_USED
			jz @actor_destroy
			; remove ITEM_ID_FART
			A_TO_ZERO(ITEM_STATUS_NOT_ACQUIRED)
			stax d

@actor_destroy:
			; hl points to bullet_status_timer
			; advance hl to bullet_update_ptr + 1
			MVI_A_TO_DIFF(bullet_update_ptr + 1, bullet_status_timer)
			add l
			mov l, a

			jmp actor_destroy
