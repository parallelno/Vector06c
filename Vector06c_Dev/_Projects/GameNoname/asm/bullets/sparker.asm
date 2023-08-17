;=========================================================
; This is non-gameplay bullet
; It is used for one of the hero death 
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
;			updateAnim
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
; movement speed based on the hero pos. it goes to that direction.
sparker_init:
			lxi h, bullet_update_ptr+1
			mvi a, BULLET_RUNTIME_DATA_LEN
			call actor_get_empty_data_ptr

			; hl - ptr to bullet_update_ptr+1
			; advance hl to bullet_update_ptr
			dcx h
			mvi m, <sparker_update
			inx h 
			mvi m, >sparker_update
			; advance hl to bullet_draw_ptr
			inx h 
			mvi m, <sparker_draw
			inx h 
			mvi m, >sparker_draw

			; advance hl to bullet_id
			inx h
			; advance hl to bullet_status
			inx h
			mvi m, SPARKER_STATUS_MOVE
			; advance and set bullet_status_timer
			inx h
			mvi m, SPARKER_STATUS_MOVE_TIME
			; advance hl to bullet_anim_ptr
			INX_H(2)
			
			mvi m, <vfx4_spark
			inx h
			mvi m, >vfx4_spark

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
sparker_update:
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
			DCX_H(2)
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
			
			shld @sparker_pos_ptr+1
			; hl points to bullet_pos_x+1
			; advance hl to bullet_anim_timer
			LXI_B_TO_DIFF(bullet_anim_timer, bullet_pos_x+1)
			dad b
			mvi a, SPARKER_ANIM_SPEED_MOVE
			call actor_anim_update

			; check if it is time to spawn VFX
			lxi h, @vfx_spawn_rate
			dcr m
			rnz
			mvi m, VFX_SPAWN_RATE
			; draw vfx
			; bc - vfx scrXY
			; de - vfx_anim_ptr (ex. vfx_puff)
@sparker_pos_ptr:
			lxi h, TEMP_ADDR
			; hl points to bullet_pos_x+1			
			mov a, m
			; pos_x to scr_x
			; a - posX
			; scrX = posX/8 + $a0
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
			LXI_B_TO_DIFF(bullet_update_ptr+1, bullet_status_timer)
			dad b
			jmp actor_destroy
@vfx_spawn_rate:
			.byte VFX_SPAWN_RATE

; draw a sprite into a backbuffer
; in:
; de - ptr to bullet_draw_ptr in the runtime data
sparker_draw:
			BULLET_DRAW(sprite_get_scr_addr_vfx4, __RAM_DISK_S_VFX4)