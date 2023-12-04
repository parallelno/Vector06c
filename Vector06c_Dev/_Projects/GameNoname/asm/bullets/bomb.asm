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
bomb_dmg_init:
			mov l, c
			mov h, b
			shld bomb_init_speed + 1
			BULLET_INIT(bomb_update, bomb_draw, BOMB_STATUS_MOVE_THROW, BOMB_STATUS_MOVE_TIME, bomb_dmg, bomb_init_speed)
; bullet_speed_x and bullet_speed_y are aimed toward the hero pos.
; in:
; de - ptr to bullet_speed_x
bomb_init_speed:
			lxi b, TEMP_WORD
			xchg
			; b = pos_x
			; c = pos_y
			; hl - ptr to bullet_speed_x
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
; de - ptr to bullet_update_ptr 
bomb_update:
			; advance to bullet_status_timer
			HL_ADVANCE(bullet_update_ptr, bullet_status_timer, BY_HL_FROM_DE)
			dcr m
			jz @die
@update_movement:
			ACTOR_UPDATE_MOVEMENT(bullet_status_timer, bullet_speed_y)
			; hl - ptr to bullet_pos_x+1
			; advance hl to bullet_anim_timer
			HL_ADVANCE(bullet_pos_x+1, bullet_anim_timer, BY_BC)
			mvi a, BOMB_ANIM_SPEED_MOVE
			BULLET_UPDATE_ANIM_CHECK_COLLISION_HERO(BOMB_COLLISION_WIDTH, BOMB_COLLISION_HEIGHT, BOMB_DAMAGE)
@die_after_damage:
			; advance hl to bullet_update_ptr+1
			HL_ADVANCE(bullet_pos_y+1, bullet_update_ptr+1, BY_BC)
			ACTOR_DESTROY()
			ret
@die:
			; hl points to bullet_status_timer
			; advance hl to bullet_update_ptr+1
			HL_ADVANCE(bullet_status_timer, bullet_update_ptr+1, BY_BC)
			ACTOR_DESTROY()
			ret

; draw a sprite into a backbuffer
; in:
bomb_draw:
; de - ptr to bullet_draw_ptr 
			ACTOR_DRAW(sprite_get_scr_addr_bomb, __RAM_DISK_S_BOMB, false)