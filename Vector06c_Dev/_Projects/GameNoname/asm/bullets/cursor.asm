;=========================================================
; This is non-gameplay bullet
; It is used in the main menu as a cursor to select the option
;=========================================================

; bullet AI:
; init:
;	status = move_forward
;	status_timer = moveForwardTimer
;	speed = caster dir
; move_forward:
;	decr status_timer
;	if status_timer = 0
;		death
;	else:
;		try to move a bullet
;		if bullet collides with tiles:
;			death
;		else:
;			accept new pos
;			update_anim
;			check bullet-hero collision, 
;			if bullet collides with hero:
;				impact hero
;				death

CURSOR_MOVE_SPEED_MAX		= 14

; statuses.
;CURSOR_STATUS_MOVE = 0

; status duration in updates. can be 2,4,8,16,32, etc
; when updated do not forget update the code below (posDiffX / CURSOR_STATUS_MOVE_TIME) to match the new value
;CURSOR_STATUS_MOVE_TIME	= 64

; animation speed (the less the slower, 0-255, 255 means the next frame is almost every update)
CURSOR_ANIM_SPEED_MOVE	= 30


; in:
; bc - pos
; movement speed based on the hero pos. it goes to that direction.
cursor_init:
			lxi h, bullet_update_ptr+1
			mvi a, BULLET_RUNTIME_DATA_LEN
			call actor_get_empty_data_ptr

			; hl - ptr to bullet_update_ptr+1
			; advance hl to bullet_update_ptr
			dcx h
			mvi m, <cursor_update
			inx h 
			mvi m, >cursor_update
			; advance hl to bullet_draw_ptr
			inx h 
			mvi m, <bomb_draw
			inx h 
			mvi m, >bomb_draw

			LXI_D_TO_DIFF(bullet_anim_ptr, bullet_draw_ptr+1)
			dad d

			mvi m, <bomb_run
			inx h
			mvi m, >bomb_run

			mov a, b
			; a - posX
			; scrX = posX/8 + $a0
			RRC_(3)
			ani %00011111
			adi SPRITE_X_SCR_ADDR
			mvi e, 0
			; a = scrX
			; b = posX
			; c = posY			
			; e = 0 and SPRITE_W_PACKED_MIN
			; hl - ptr to bullet_erase_scr_addr_old			
			
			; advance hl to bullet_erase_scr_addr
			inx h
			mov m, c
			inx h
			mov m, a
			; advance hl to bullet_erase_scr_addr_old
			inx h
			mov m, c
			inx h
			mov m, a
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
			mov m, e
			inx h
			mov m, b
			; advance hl to bullet_pos_y
			inx h
			mov m, e
			inx h
			mov m, c
			ret
			
; anim and a gameplay logic update
; in:
; de - ptr to bullet_update_ptr in the runtime data
cursor_update:
			; de - ptr to bullet_update_ptr
			; advance hl to bullet_pos_y+1
			LXI_H_TO_DIFF(bullet_pos_y+1, bullet_update_ptr)
			dad d
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
			LXI_B_TO_DIFF(bullet_anim_timer, bullet_pos_y+1)
			dad b
			mvi a, CURSOR_ANIM_SPEED_MOVE
			call actor_anim_update
			ret
@die:
			; hl points to bullet_status_timer
			; advance hl to bullet_update_ptr+1
			LXI_B_TO_DIFF(bullet_update_ptr+1, bullet_status_timer)
			dad b
			jmp actor_destroy
@vfx_spawn_rate:
			.byte VFX_SPAWN_RATE