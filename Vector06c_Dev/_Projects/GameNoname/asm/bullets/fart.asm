;=========================================================
; This is a quest bullet
; init: it gives a hero ITEM_ID_FART
; it lasts some certain time, then destroys itself
; when dies: it sets its status ITEM_STATUS_USED
; when it's alive, it constantly spawns puff vfx
; the quest to scary away knight_quest monster
;=========================================================

; statuses.
FART_STATUS_LIFE		= 0
FART_STATUS_LIFE_TIME	= 20

; Init for non-preshifted VFX (x coord aligned to 8 pixels )
; in:
; bc - vfx screen addr
fart_init:
			BULLET_INIT(fart_update, vfx_draw, FART_STATUS_LIFE, FART_STATUS_LIFE_TIME, vfx_puff_loop, fart_init_pos)

; vfx_draw func used for this fart bullet requires a specific pos_y and pos_x format
; this function provides it
; in:
; de - ptr to bullet_speed_x
fart_init_pos:
			LXI_H_TO_DIFF(bullet_speed_x, bullet_pos_x + 1)
			dad d
			; hl - ptr to bullet_pos_x + 1
			mov a, m
			; a - pos_x
			; make a scr addr
			ani %00011111
			ori SPRITE_X_SCR_ADDR
			mov m, a
			; advance hl to bullet_pos_y
			inx h
			mvi m, 2 ; anim ptr offset. used in the vfx_draw func
			ret

; anim and a gameplay logic update
; in:
; de - ptr to bullet_update_ptr in the runtime data
fart_update:
			; advance to bullet_status_timer
			MVI_A_TO_DIFF(bullet_update_ptr, bullet_status_timer)
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
			MVI_A_TO_DIFF(bullet_status_timer, bullet_pos_x + 1)
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

			MVI_A_TO_DIFF(bullet_pos_y + 1, bullet_anim_timer)
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
			MVI_A_TO_DIFF(bullet_status_timer, bullet_update_ptr + 1)
			add l
			mov l, a

			jmp actor_destroy
