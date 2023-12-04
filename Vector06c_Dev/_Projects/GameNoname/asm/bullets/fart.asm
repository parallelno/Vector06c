;=========================================================
; This is a quest bullet
; init: it gives a hero game_status_fart
; it lasts some certain time, then destroys itself
; when dies: it sets its status GAME_STATUS_USED
; when it's alive, it constantly spawns puff vfx
; the quest to scary away knight_heavy monster
;=========================================================

; statuses.
FART_STATUS_LIFE		= 0
FART_STATUS_LIFE_TIME	= 20

; init for non-preshifted VFX (x coord aligned to 8 pixels )
fart_init:
			lxi h, hero_erase_scr_addr 
			mov c, m
			inx h
			mov b, m

			BULLET_INIT(fart_update, vfx_draw, FART_STATUS_LIFE, FART_STATUS_LIFE_TIME, vfx_puff_loop, fart_init_post)
			ret			

; vfx_draw func used for this fart bullet requires a specific pos_y and pos_x format
; this function provides it
; in:
; de - ptr to bullet_speed_x
fart_init_post:
			HL_ADVANCE(bullet_speed_x, bullet_pos_x + 1, BY_HL_FROM_DE)
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
			; a hero got fart
			mvi a, GAME_STATUS_ACQUIRED
			sta game_status_fart
			ret

; anim and a gameplay logic update
; in:
; de - ptr to bullet_update_ptr 
fart_update:
			; advance to bullet_status_timer
			MVI_A_TO_DIFF(bullet_update_ptr, bullet_status_timer)
			add e
			mov e, a
			xchg
			; hl - ptr to bullet_update_ptr 
@fraction_timer:
			mvi a, 1
			rlc
			sta @fraction_timer + 1
			jnc @update_movement

			dcr m
			jz @die ; time is over

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
			; make game_status_fart not_acquired
			A_TO_ZERO(GAME_STATUS_NOT_ACQUIRED)
			sta game_status_fart
			; destroy fart vfx
			; hl points to bullet_status_timer
			; advance hl to bullet_update_ptr + 1
			MVI_A_TO_DIFF(bullet_status_timer, bullet_update_ptr + 1)
			add l
			mov l, a
			ACTOR_DESTROY()
			ret
