;=========================================================
; This is a non-gameplay bullet
; It is used for one of the hero death visual sequence
; statuses to spawn sparks along the line
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

SPARKER_MOVE_SPEED		= $0400				; low byte is a subpixel speed, high byte is a speed in pixels
SPARKER_MOVE_SPEED_NEG	= $ffff - $0400 + 1	; low byte is a subpixel speed, high byte is a speed in pixels

; statuses.
SPARKER_STATUS_MOVE = 0

; status duration in updates. can be 2,4,8,16,32, etc
; when updated do not forget update the code below (posDiffX / SPARKER_STATUS_MOVE_TIME) to match the new value
SPARKER_STATUS_MOVE_TIME	= 64

; animation speed (the less the slower, 0-255, 255 means the next frame is almost every update)
SPARKER_ANIM_SPEED_MOVE	= 130

; the rate when it is time to spawn a sparkle vfx.
VFX_SPAWN_RATE = 5

; in:
; bc - caster pos
sparker_init:
			mov l, c
			mov h, b
			shld sparker_init_speed + 1
			BULLET_INIT(sparker_update, vfx_draw4, SPARKER_STATUS_MOVE, SPARKER_STATUS_MOVE_TIME, vfx4_spark, sparker_init_speed)

; bullet_speed_x and bullet_speed_y are aimed toward the hero pos.
; in:
; de - ptr to bullet_speed_x
sparker_init_speed:
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
			; posDiffX / SPARKER_STATUS_MOVE_TIME (it uses the fact that HL>>5 the same as HL<<3)
			dad h
			dad h 
			;dad h
			; to fill up L with %1111 if pos_diff < 0
			;ani %111 ; <(%0000000011111111 / SPARKER_STATUS_DASH_TIME)
			ani %11 ; <(%0000000011111111 / SPARKER_STATUS_DASH_TIME)
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
			; posDiffY / SPARKER_STATUS_MOVE_TIME 
			dad h 
			dad h 
			;dad h 
			; to fill up L with %1111 if pos_diff < 0
			;ani %111 ; <(%0000000011111111 / SPARKER_STATUS_DASH_TIME)
			ani %11 ; <(%0000000011111111 / SPARKER_STATUS_DASH_TIME)
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
sparker_update:
			; advance to bullet_status_timer
			LXI_H_TO_DIFF(bullet_update_ptr, bullet_status_timer)
			dad d
			dcr m
			jz @die
@update_movement:
			ACTOR_UPDATE_MOVEMENT(bullet_status_timer, bullet_speed_y)
			; hl - ptr to bullet_pos_x+1
			
			shld @sparker_pos_ptr+1
			; hl points to bullet_pos_x+1
			; advance hl to bullet_anim_timer
			HL_ADVANCE(bullet_pos_x+1, bullet_anim_timer, BY_BC)
			mvi a, SPARKER_ANIM_SPEED_MOVE
			call actor_anim_update

			; check if it is time to spawn VFX
			lxi h, @vfx_spawn_rate
			dcr m
			rnz
			mvi m, VFX_SPAWN_RATE
			; draw vfx
			; bc - vfx scr_xy
			; de - vfx_anim_ptr (ex. vfx_puff)
@sparker_pos_ptr:
			lxi h, TEMP_ADDR
			; hl points to bullet_pos_x+1			
			mov a, m
			; pos_x to scr_x
			; a - pos_x
			; scr_x = pos_x/8 + $a0
			RRC_(3)
			ani %00011111
			adi SPRITE_X_SCR_ADDR		
			mov b, a

			; pos_y + rand val in the range (-3, 3)
			INX_H(2)
			mov c, m
			call random
			ani %0000_1111
			sbi 7
			add c
			mov c, a

			lxi d, vfx_reward
			call vfx_init
			ret
@die:
			; hl points to bullet_status_timer
			; advance hl to bullet_update_ptr+1
			HL_ADVANCE(bullet_status_timer, bullet_update_ptr+1, BY_BC)
			ACTOR_DESTROY()
			ret
@vfx_spawn_rate:
			.byte VFX_SPAWN_RATE
