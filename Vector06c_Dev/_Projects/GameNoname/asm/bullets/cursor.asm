;=========================================================
; This is a non-gameplay bullet object
; It is used in the main menu as a cursor to select the option
;=========================================================
CURSOR_STATUS_IDLE		= 0
CURSOR_STATUS_IDLE_TIME	= 0


CURSOR_MOVE_SPEED_MAX		= 14

; animation speed (the less the slower, 0-255, 255 means the next frame is almost every update)
CURSOR_ANIM_SPEED_MOVE	= 30


; in:
; bc - pos
; movement speed based on the hero pos. it goes to that direction.
cursor_init:
			BULLET_INIT(cursor_update, bomb_draw, CURSOR_STATUS_IDLE, CURSOR_STATUS_IDLE_TIME, bomb_run, empty_func)
			
; anim and a gameplay logic update
; in:
; de - ptr to bullet_update_ptr 
cursor_update:
			; de - ptr to bullet_update_ptr
			; advance hl to bullet_pos_y+1
			HL_ADVANCE(bullet_update_ptr, bullet_pos_y+1, BY_HL_FROM_DE)
			; calc a bullet velocity which is = (hero_pos_y - bullet_pos_y) / 4
			lda hero_pos_y+1
			sub m
			jc @move_down
			inr a
			inr a
			; move up
			RRC_(2)
			ani %0011_1111
			; clamp to max speed
			cpi CURSOR_MOVE_SPEED_MAX
			jc @no_clamp
			mvi a, CURSOR_MOVE_SPEED_MAX
@no_clamp:
			jmp @apply_pos
@move_down:			
			RRC_(2)
			ori %1100_0000
			; clamp to max speed
			cpi -CURSOR_MOVE_SPEED_MAX
			jnc @no_clamp2
			mvi a, -CURSOR_MOVE_SPEED_MAX
@no_clamp2:
@apply_pos:
			; add velocity to the bullet pos
			add m
			mov m, a

			; hl points to bullet_pos_y+1
			; advance hl to bullet_anim_timer
			HL_ADVANCE(bullet_pos_y+1, bullet_anim_timer, BY_BC)
			mvi a, CURSOR_ANIM_SPEED_MOVE
			call actor_anim_update
			ret
@die:
			; hl points to bullet_status_timer
			; advance hl to bullet_update_ptr+1
			HL_ADVANCE(bullet_status_timer, bullet_update_ptr+1, BY_BC)
			ACTOR_DESTROY()
			ret
@vfx_spawn_rate:
			.byte VFX_SPAWN_RATE