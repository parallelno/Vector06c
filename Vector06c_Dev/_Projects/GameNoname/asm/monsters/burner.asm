; mob AI:
; init:
;	 status = detectHeroInit
; detectHeroInit:
;	status = detectHero
;	statusTimer = detectHeroTime
;	anim = idle.
; detectHero:
;	decr statusTimer
;	if statusTimer == 0:
;		status = moveInit
;	else:
;		if distance(mob, hero) < a dashing radius:
;			status = dashPrep
;			statusTimer = dashPrepTime
;			anim to the hero dir
;		else:
;			updateAnim
;			check mod-hero collision, impact if collides
; dashPrep:
;	decr statusTimer
;	if statusTimer == 0:
;		status = dash
;		anim = run
;		speed directly to the hero pos
;	else:
;		updateAnim
;		check mod-hero collision, impact if collides
; dash:
;	decr statusTimer
;	if statusTimer == 0:
;		status = relax
;		statusTimer = relaxTime
;	else:
;		move a mob
;		updateAnim
;		check mod-hero collision, impact if collides
; relax:
;	decr statusTimer
;	if statusTimer == 0:
;		status = moveInit
;	else:
;		updateAnim
;		check mod-hero collision, impact if collides
; moveInit:
;	status = move
;	statusTimer = random
;	speed = random dir
;	set anim along the dir
; move:
;	decr statusTimer
;	if statusTimer = 0
;		status = detectHeroInit
;	else:
;		try to move a mob
;		if mob collides with tiles:
;			status = moveInit
;		else:
;			accept new pos
;			updateAnim
;			check mod-hero collision, impact if collides


; statuses.
BURNER_STATUS_DETECT_HERO_INIT	= 0 * JMP_4_LEN
BURNER_STATUS_DETECT_HERO		= 1 * JMP_4_LEN
BURNER_STATUS_DASH_PREP			= 2 * JMP_4_LEN
BURNER_STATUS_DASH				= 3 * JMP_4_LEN
BURNER_STATUS_RELAX				= 4 * JMP_4_LEN
BURNER_STATUS_MOVE_INIT			= 5 * JMP_4_LEN
BURNER_STATUS_MOVE				= 6 * JMP_4_LEN

; status duration in updates.
BURNER_STATUS_DETECT_HERO_TIME	= 50
BURNER_STATUS_DASH_PREP_TIME	= 10
BURNER_STATUS_DASH_TIME			= 16
BURNER_STATUS_RELAX_TIME		= 25
BURNER_STATUS_MOVE_TIME			= 60

; animation speed (the less the slower, 0-255, 255 means the next frame is almost every update)
BURNER_ANIM_SPEED_DETECT_HERO	= 50
BURNER_ANIM_SPEED_RELAX			= 20
BURNER_ANIM_SPEED_MOVE			= 60
BURNER_ANIM_SPEED_DASH_PREP		= 100
BURNER_ANIM_SPEED_DASH			= 150

; gameplay
BURNER_DAMAGE = 1
BURNER_HEALTH = 1

BURNER_COLLISION_WIDTH	= 15
BURNER_COLLISION_HEIGHT	= 10

BURNER_MOVE_SPEED		= $0100
BURNER_MOVE_SPEED_NEG	= $ffff - $100 + 1

BURNER_DETECT_HERO_DISTANCE = 60

;========================================================
; called to spawn this monster
; in:
; c - tile_idx in the room_tiledata array.
; a - monster_id * 4
; out:
; a = 0
burner_init:
			MONSTER_INIT(burner_update, burner_draw, monster_impacted, BURNER_HEALTH, BURNER_STATUS_DETECT_HERO_INIT, burner_idle)
			ret
			

; anim and a gameplay logic update
; in:
; de - ptr to monster_update_ptr in the runtime data
burner_update:
			; advance hl to monster_status
			LXI_H_TO_DIFF(monster_status, monster_update_ptr)
			dad d
			mov a, m
			cpi BURNER_STATUS_MOVE
			jz burner_update_move
			cpi BURNER_STATUS_DETECT_HERO
			jz burner_update_detect_hero
			cpi BURNER_STATUS_DASH
			jz burner_update_dash		
			cpi BURNER_STATUS_RELAX
			jz burner_update_relax
			cpi BURNER_STATUS_DASH_PREP
			jz burner_update_dash_prep
			cpi BURNER_STATUS_MOVE_INIT
			jz burner_update_move_init
			cpi BURNER_STATUS_DETECT_HERO_INIT
			jz burner_update_detect_hero_init
			ret

burner_update_detect_hero_init:
			; hl = monster_status
			mvi m, BURNER_STATUS_DETECT_HERO
			inx h
			mvi m, BURNER_STATUS_DETECT_HERO_TIME
			LXI_B_TO_DIFF(monster_anim_ptr, monster_status_timer)
			dad b
			mvi m, <burner_idle
			inx h
			mvi m, >burner_idle
			ret

burner_update_detect_hero:
			; hl = monster_status
			; advance hl to monster_status_timer
			inx h
			dcr m
			jz @setMoveInit
@checkMobHeroDistance:
			; advance hl to monster_pos_x+1
			LXI_B_TO_DIFF(monster_pos_x+1, monster_status_timer)
			dad b
			; check hero-monster posX diff
			lda hero_pos_x+1
			sub m
			jc @checkNegPosXDiff
			cpi BURNER_DETECT_HERO_DISTANCE
			jc @checkPosYDiff
			jmp @updateAnimHeroDetectX
@checkNegPosXDiff:
			cpi -BURNER_DETECT_HERO_DISTANCE
			jnc @checkPosYDiff
			jmp @updateAnimHeroDetectX
@checkPosYDiff:
			; advance hl to monster_pos_y+1
			INX_H(2)
			; check hero-monster posY diff
			lda hero_pos_y+1
			sub m
			jc @checkNegPosYDiff
			cpi BURNER_DETECT_HERO_DISTANCE
			jc @heroDetected
			jmp @updateAnimHeroDetectY
@checkNegPosYDiff:
			cpi -BURNER_DETECT_HERO_DISTANCE
			jnc @heroDetected
			jmp @updateAnimHeroDetectY
@heroDetected:
			; hl = monster_pos_y+1
			; advance hl to monster_status
			LXI_B_TO_DIFF(monster_status, monster_pos_y+1)
			dad b
			mvi m, BURNER_STATUS_DASH_PREP
			inx h
			mvi m, BURNER_STATUS_DASH_PREP_TIME
			; advance hl to monster_anim_ptr
			LXI_B_TO_DIFF(monster_anim_ptr, monster_status_timer)
			dad b
			mvi m, <burner_dash
			inx h
			mvi m, >burner_dash
			ret
			
@updateAnimHeroDetectX:
			; advance hl to monster_anim_timer
			LXI_B_TO_DIFF(monster_anim_timer, monster_pos_x+1)
			dad b
			mvi a, BURNER_ANIM_SPEED_DETECT_HERO
			jmp burner_update_anim_check_collision_hero
@updateAnimHeroDetectY:
			; advance hl to monster_anim_timer
			LXI_B_TO_DIFF(monster_anim_timer, monster_pos_y+1)
			dad b
			mvi a, BURNER_ANIM_SPEED_DETECT_HERO
			jmp burner_update_anim_check_collision_hero

@setMoveInit:
 			; hl - ptr to monster_status_timer
			mvi m, BURNER_STATUS_MOVE_TIME ; TODO: use a rnd number instead of a const
			; advance hl to monster_status
			dcx h
			mvi m, BURNER_STATUS_MOVE_INIT
			ret

burner_update_move_init:
			; hl = monster_status
			mvi m, BURNER_STATUS_MOVE

			xchg
			call random
			; advance hl to monster_speed_x
			LXI_H_TO_DIFF(monster_speed_x, monster_status)
			dad d

			mvi c, 0 ; tmp c=0
			cpi $40
			jc @speedXp
			cpi $80
			jc @speedYp
			cpi $c0
			jc @speedXn
@speedYn:
			mov m, c
			inx h
			mov m, c
			inx h
			mvi m, <BURNER_MOVE_SPEED_NEG
			inx h
			mvi m, >BURNER_MOVE_SPEED_NEG
			jmp @setAnim
@speedYp:
			mov m, c
			inx h
			mov m, c
			inx h
			mvi m, <BURNER_MOVE_SPEED
			inx h
			mvi m, >BURNER_MOVE_SPEED
			jmp @setAnim
@speedXn:
			mvi m, <BURNER_MOVE_SPEED_NEG
			inx h
			mvi m, >BURNER_MOVE_SPEED_NEG
			inx h
			mov m, c
			inx h
			mov m, c
			jmp @setAnim
@speedXp:
			mvi m, <BURNER_MOVE_SPEED
			inx h
			mvi m, >BURNER_MOVE_SPEED
			inx h
			mov m, c
			inx h
			mov m, c
@setAnim:
			LXI_B_TO_DIFF(monster_anim_ptr, monster_speed_y+1)
			dad b
			; a = rnd
			ora a
			; if rnd is positive (up or right movement), then play burner_run_r anim
			jp @setAnimRunR
@setAnimRunL:
			mvi m, <burner_run_l
			inx h
			mvi m, >burner_run_l
			ret
@setAnimRunR:
			mvi m, <burner_run_r
			inx h
			mvi m, >burner_run_r
            ret

burner_update_move:
			; hl = monster_status
			; advance hl to monster_status_timer
			inx h
			dcr m
			jz @setDetectHeroInit
@updateMovement:
			ACTOR_UPDATE_MOVEMENT_CHECK_TILE_COLLISION(monster_status_timer, monster_pos_x, BURNER_COLLISION_WIDTH, BURNER_COLLISION_HEIGHT, @setMoveInit) 
			
			; hl points to monster_pos_y+1
			; advance hl to monster_anim_timer
			LXI_B_TO_DIFF(monster_anim_timer, monster_pos_y+1)
			dad b
			mvi a, BURNER_ANIM_SPEED_MOVE
			jmp burner_update_anim_check_collision_hero

@setMoveInit:
			pop h
			; hl points to monster_pos_x
			; advance hl to monster_status
			LXI_B_TO_DIFF(monster_status, monster_pos_x)
			dad b
			mvi m, BURNER_STATUS_MOVE_INIT
			inx h
			mvi m, BURNER_STATUS_MOVE_TIME
			ret
@setDetectHeroInit:
 			; hl - ptr to monster_status_timer
			; advance hl to monster_status
			dcx h
			mvi m, BURNER_STATUS_DETECT_HERO_INIT
			ret

burner_update_relax:
			; hl = monster_status
			; advance hl to monster_status_timer
			inx h
			dcr m
			jz @setMoveInit
			; advance hl to monster_anim_timer
			LXI_B_TO_DIFF(monster_anim_timer, monster_status_timer)
			dad b
			mvi a, BURNER_ANIM_SPEED_RELAX
			jmp burner_update_anim_check_collision_hero
 @setMoveInit:
 			; hl - ptr to monster_status_timer
			mvi m, BURNER_STATUS_MOVE_TIME
			; advance hl to monster_status
			dcx h
			mvi m, BURNER_STATUS_MOVE_INIT
			ret

burner_update_dash_prep:
			; hl = monster_status
			; advance hl to monster_status_timer
			inx h
			dcr m
			jz @setDash
			; advance hl to monster_anim_timer
			LXI_B_TO_DIFF(monster_anim_timer, monster_status_timer)
			dad b
			mvi a, BURNER_ANIM_SPEED_DASH_PREP
			jmp burner_update_anim_check_collision_hero
 @setDash:
  			; hl - ptr to monster_status_timer
			mvi m, BURNER_STATUS_DASH_TIME
			; advance hl to monster_status
			dcx h
			mvi m, BURNER_STATUS_DASH
			; advance hl to monster_pos_x
			LXI_B_TO_DIFF(monster_pos_x, monster_status)
			dad b
			; reset sub pixel posX
			mvi m, 0
			; advance hl to posX+1
			inx h
			; pos_diff =  hero_pos - burnerPosX
			; speed = pos_diff / BURNER_STATUS_DASH_TIME
			lda hero_pos_x+1
			sub m
			mov e, a 
			mvi a, 0
			; if posDiffX < 0, then d = $ff, else d = 0
			sbb a
			mov d, a
			xchg
			; posDiffX / BURNER_STATUS_DASH_TIME 
			dad h 
			dad h 
			dad h 
			dad h
			; to fill up L with %1111 if pos_diff < 0
			ani %1111 ; <(%0000000011111111 / BURNER_STATUS_DASH_TIME)
			ora l
			mov l, a
			push h
			xchg
			; advance hl to posY
			inx h
			; reset sub pixel posY
			mvi m, 0
			; advance hl to posY+1
			inx h
			; do the same for Y
			lda hero_pos_y+1
			sub m
			mov e, a 
			mvi a, 0
			; if posDiffY < 0, then d = $ff, else d = 0
			sbb a
			mov d, a 
			xchg
			; posDiffY / BURNER_STATUS_DASH_TIME 
			dad h 
			dad h 
			dad h 
			dad h 
			; to fill up L with %1111 if pos_diff < 0
			ani %1111 ; <(%0000000011111111 / BURNER_STATUS_DASH_TIME)
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

burner_update_dash:
			; hl = monster_status
			; advance hl to monster_status_timer
			inx h
			dcr m
			jm @setMoveInit
@applyMovement:
			ACTOR_UPDATE_MOVEMENT(monster_status_timer, monster_speed_y)
			; advance hl to monster_anim_timer
			LXI_B_TO_DIFF(monster_anim_timer, monster_pos_x+1)
			dad b
			mvi a, BURNER_ANIM_SPEED_DASH
			jmp actor_anim_update
@setMoveInit:
			; hl points to monster_status_timer
			mvi m, BURNER_STATUS_MOVE_TIME			
			; advance hl to monster_status
			dcx h
			mvi m, BURNER_STATUS_MOVE_INIT
			ret	


; in:
; hl - monster_anim_timer
; a - anim speed
burner_update_anim_check_collision_hero:
			call actor_anim_update
			MONSTER_CHECK_COLLISION_HERO(BURNER_COLLISION_WIDTH, BURNER_COLLISION_HEIGHT, BURNER_DAMAGE)

; draw a sprite into a backbuffer
; in:
; de - ptr to monster_draw_ptr in the runtime data
burner_draw:
			MONSTER_DRAW(sprite_get_scr_addr_burner, __RAM_DISK_S_BURNER)