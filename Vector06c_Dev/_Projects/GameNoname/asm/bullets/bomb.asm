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

BOMB_MOVE_SPEED		= $0400				; low byte is a subpixel speed, high byte is a speed in pixels
BOMB_MOVE_SPEED_NEG	= $ffff - $0400 + 1	; low byte is a subpixel speed, high byte is a speed in pixels

; statuses.
BOMB_STATUS_MOVE_THROW = 0

; status duration in updates.
; when updated do not forget update the code below (posDiffX / SPARKER_STATUS_MOVE_TIME) to match the new value
BOMB_STATUS_MOVE_TIME	= 32

; animation speed (the less the slower, 0-255, 255 means the next frame is almost every update)
BOMB_ANIM_SPEED_MOVE	= 130

; gameplay
BOMB_DAMAGE = 1
BOMB_COLLISION_WIDTH	= 10
BOMB_COLLISION_HEIGHT	= 10

; in:
; bc - caster pos
; a - bullet_id
; movement speed based on the hero pos. it goes to that direction.
bomb_init:
			sta @bullet_id+1

			lxi h, bullet_update_ptr+1
			mvi e, BULLET_RUNTIME_DATA_LEN
			call actor_get_empty_data_ptr
			rnz ; return because too many objects

			; hl - ptr to bullet_update_ptr+1
			; advance hl to bullet_update_ptr
			dcx h
			mvi m, <bomb_update
			inx h 
			mvi m, >bomb_update
			; advance hl to bullet_draw_ptr
			inx h 
			mvi m, <bomb_draw
			inx h 
			mvi m, >bomb_draw

			; advance hl to bullet_id
			inx h
@bullet_id:	mvi a, TEMP_BYTE
			mov m, a

			; advance hl to bullet_status
			inx h
			mvi m, BOMB_STATUS_MOVE_THROW
			; advance and set bullet_status_timer
			inx h
			mvi m, BOMB_STATUS_MOVE_TIME
			; advance hl to bullet_anim_ptr
			INX_H(2)
			
			; a - bullet_id
			cpi BOMB_SLOW_ID
			jz @bomb_slow
@bomb_dmg:
			mvi m, <bomb_dmg
			inx h
			mvi m, >bomb_dmg
			jmp @eraseScrAddr
@bomb_slow:
			mvi m, <bomb_run
			inx h
			mvi m, >bomb_run			
@eraseScrAddr:
			mov a, b
			; a - pos_x
			; scr_x = pos_x/8 + $a0
			RRC_(3)
			ani %00011111
			adi SPRITE_X_SCR_ADDR
			mvi e, 0
			; a = scr_x
			; b = pos_x
			; c = pos_y			
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
			
			; b = pos_x
			; c = pos_y	
			; set a projectile speed towards the hero
			; pos_diff =  hero_pos - burnerPosX
			; speed = pos_diff / VAMPIRE_STATUS_DASH_TIME			
			lda hero_pos_x+1
			sub b
			mov e, a
			mvi a, 0
			; if posDiffX < 0, then d = $ff, else d = 0
			sbb a
			mov d, a
			xchg
			; posDiffX / BOMB_STATUS_MOVE_TIME (it uses the fact that HL>>5 the same as HL<<3)
			dad h
			dad h 
			dad h
			; to fill up L with %1111 if pos_diff < 0
			ani %111 ; <(%0000000011111111 / BOMB_STATUS_DASH_TIME)
			ora l 
			mov l, a
			push h
			xchg
			; do the same for Y
			lda hero_pos_y+1
			sub c
			mov e, a 
			mvi a, 0
			; if posDiffY < 0, then d = $ff, else d = 0
			sbb a
			mov d, a 
			xchg
			; posDiffY / BOMB_STATUS_MOVE_TIME 
			dad h 
			dad h 
			dad h 
			; to fill up L with %1111 if pos_diff < 0
			ani %111 ; <(%0000000011111111 / BOMB_STATUS_DASH_TIME)
			ora l 
			mov l, a
			xchg
			; advance hl to speed_x
			inx h 
			pop b ; speed_x
			mov m, c 
			inx h 
			mov m, b
			; advance hl to speed_y
			inx h
			mov m, e
			inx h 
			mov m, d	
			ret
			
; anim and a gameplay logic update
; in:
; de - ptr to bullet_update_ptr in the runtime data
bomb_update:
			; advance to bullet_status_timer
			LXI_H_TO_DIFF(bullet_update_ptr, bullet_status_timer)
			dad d
			dcr m
			jz @die
@update_movement:
			ACTOR_UPDATE_MOVEMENT(bullet_status_timer, bullet_speed_y)
			; hl - ptr to bullet_pos_x+1
			; advance hl to bullet_anim_timer
			HL_ADVANCE_BY_DIFF_BC(bullet_pos_x+1, bullet_anim_timer)
			mvi a, BOMB_ANIM_SPEED_MOVE
			BULLET_UPDATE_ANIM_CHECK_COLLISION_HERO(BOMB_COLLISION_WIDTH, BOMB_COLLISION_HEIGHT, BOMB_DAMAGE)	
@die_after_damage:
			; advance hl to bullet_update_ptr+1
			HL_ADVANCE_BY_DIFF_BC(bullet_pos_y+1, bullet_update_ptr+1)
			jmp actor_destroy
@die:
			; hl points to bullet_status_timer
			; advance hl to bullet_update_ptr+1
			HL_ADVANCE_BY_DIFF_BC(bullet_status_timer, bullet_update_ptr+1)
			jmp actor_destroy

; draw a sprite into a backbuffer
; in:
; de - ptr to bullet_draw_ptr in the runtime data
bomb_draw:
			BULLET_DRAW(sprite_get_scr_addr_bomb, __RAM_DISK_S_BOMB)