; mob AI:
; init:
;	status = moveForward
;	statusTimer = moveForwardTimer
;	speed = caster dir
; moveForward:
;	decr statusTimer
;	if statusTimer = 0
;		status = moveBackward
;		statusTimer = moveBackwardTimer
;	else:
;		try to move a mob
;		if mob collides with tiles:
;			if status = moveBackward:
;				die
;			else:
;				status = moveBackward
;		else:
;			accept new pos
;			updateAnim
;			check mod-hero collision, impact if collides
; moveBackward:
;	decr statusTimer
;	if statusTimer = 0
;		death
;	else:
;		try to move a mob
;		if mob collides with tiles:
;			death
;		else:
;			accept new pos
;			updateAnim
;			check mod-hero collision, impact if collides


BOMB_SLOW_MOVE_SPEED		= $0400				; low byte is a subpixel speed, high byte is a speed in pixels
BOMB_SLOW_MOVE_SPEED_NEG	= $ffff - $0400 + 1	; low byte is a subpixel speed, high byte is a speed in pixels

; statuses.
BOMB_SLOW_STATUS_MOVE_THROW = 0

; status duration in updates.
BOMB_SLOW_STATUS_MOVE_TIME	= 32

; animation speed (the less the slower, 0-255, 255 means the next frame is almost every update)
BOMB_SLOW_ANIM_SPEED_MOVE	= 130

; gameplay
BOMB_SLOW_DAMAGE = 1
BOMB_SLOW_COLLISION_WIDTH	= 10
BOMB_SLOW_COLLISION_HEIGHT	= 10

; in:
; bc - caster pos
; a - projectileId
bomb_slow_init:
			sta @bullet_id+1
			call bullets_get_empty_data_ptr
			; hl - ptr to bullet_update_ptr+1
			; advance hl to bullet_update_ptr
			dcx h
			mvi m, <bomb_slow_update
			inx h 
			mvi m, >bomb_slow_update
			; advance hl to bullet_draw_ptr
			inx h 
			mvi m, <bomb_slow_draw
			inx h 
			mvi m, >bomb_slow_draw

			; advance hl to bullet_id
			inx h
@bullet_id:	mvi a, TEMP_BYTE
			mov m, a

			; advance hl to bullet_status
			inx h
			mvi m, BOMB_SLOW_STATUS_MOVE_THROW
			; advance and set bullet_status_timer
			inx h
			mvi m, BOMB_SLOW_STATUS_MOVE_TIME
			; advance hl to bullet_anim_ptr
			inx_h(2)
			
			; a - bullet_id
			cpi BOMB_SLOW_ID
			jz @bombSlow
@bombDmg:
			mvi m, <bomb_slow_dmg
			inx h
			mvi m, >bomb_slow_dmg
			jmp @eraseScrAddr
@bombSlow:
			mvi m, <bomb_slow_run
			inx h
			mvi m, >bomb_slow_run			
@eraseScrAddr:
			mov a, b
			; a - posX
			; scrX = posX/8 + $a0
			rrc_(3)
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
			
			; b = posX
			; c = posY	
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
			; posDiffX / BOMB_SLOW_STATUS_MOVE_TIME (it uses the fact that HL>>5 the same as HL<<3)
			dad h
			dad h 
			dad h
			; to fill up L with %1111 if pos_diff < 0
			ani %111 ; <(%0000000011111111 / BOMB_SLOW_STATUS_DASH_TIME)
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
			; posDiffY / BOMB_SLOW_STATUS_MOVE_TIME 
			dad h 
			dad h 
			dad h 
			; to fill up L with %1111 if pos_diff < 0
			ani %111 ; <(%0000000011111111 / BOMB_SLOW_STATUS_DASH_TIME)
			ora l 
			mov l, a
			xchg
			; advance hl to speedX
			inx h 
			pop b ; speedX
			mov m, c 
			inx h 
			mov m, b
			; advance hl to speedY
			inx h
			mov m, e
			inx h 
			mov m, d	
			ret
			
; anim and a gameplay logic update
; in:
; de - ptr to bullet_update_ptr in the runtime data
bomb_slow_update:
			; advance to bullet_status_timer
			LXI_H_TO_DIFF(bullet_status_timer, bullet_update_ptr)
			dad d
@updateMove:
			dcr m
			jz @die
@updateMovement:
			; hl - ptr to bullet_status_timer
			; advance hl to bullet_speed_y+1
			LXI_B_TO_DIFF(bullet_speed_y+1, bullet_status_timer)
			dad b
			; bc <- speedY
			mov b, m
			dcx h
			mov c, m
			dcx h
			; stack <- speedX
			mov d, m
			dcx h
			mov e, m
			dcx h
			push d
			; de <- posY
			mov d, m
			dcx h
			mov e, m
			; (posY) <- posY + speedY
			xchg
			dad b
			xchg
			; pos = hero_pos-pos/8
			mov m, e
			inx h 
			mov m, d
			dcx_h(2)
			; hl points to speedX+1
			; de <- posX
			mov d, m
			dcx h
			mov e, m
			; (posX) <- posX + speedX
			xchg
			pop b
			dad b
			xchg
			mov m, e
			inx h 
			mov m, d
			
			; hl points to bullet_pos_x+1
			; advance hl to bullet_anim_timer
			LXI_B_TO_DIFF(bullet_anim_timer, bullet_pos_x+1)
			dad b
			mvi a, BOMB_SLOW_ANIM_SPEED_MOVE
			BULLET_UPDATE_ANIM_CHECK_COLLISION_HERO(BOMB_SLOW_COLLISION_WIDTH, BOMB_SLOW_COLLISION_HEIGHT, BOMB_SLOW_DAMAGE)	
@dieAfterDamage:
			; advance hl to bullet_update_ptr+1
			LXI_B_TO_DIFF(bullet_update_ptr+1, bullet_pos_y+1)
			dad b
			jmp bullets_destroy
@die:
			; hl points to bullet_status_timer
			; advance hl to bullet_update_ptr+1
			LXI_B_TO_DIFF(bullet_update_ptr+1, bullet_status_timer)
			dad b
			jmp bullets_destroy

; draw a sprite into a backbuffer
; in:
; de - ptr to bullet_draw_ptr in the runtime data
bomb_slow_draw:
			BULLET_DRAW(sprite_get_scr_addr_bomb_slow, __RAM_DISK_S_BOMB_SLOW)