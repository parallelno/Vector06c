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
;		if distance(mob, hero) < a casting radius:
;			status = castPrep
;			statusTimer = castPrepTime
;			anim = cast
;		else:
;			updateAnim
;			check mod-hero collision, impact if collides
; castPrep:
;	decr statusTimer
;	if statusTimer == 0:
;		status = cast
;		anim = cast
;	else:
;		updateAnim
;		check mod-hero collision, impact if collides
; cast:
;	status = relax
;	statusTimer = relaxTime
;	spawn a projectile along the mob dir
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
VAMPIRE_STATUS_DETECT_HERO_INIT	= 0
VAMPIRE_STATUS_DETECT_HERO			= 1
VAMPIRE_STATUS_SHOOT_PREP			= 2
VAMPIRE_STATUS_SHOOT				= 3
VAMPIRE_STATUS_RELAX				= 4
VAMPIRE_STATUS_MOVE_INIT			= 5
VAMPIRE_STATUS_MOVE				= 6

; status duration in updates.
VAMPIRE_STATUS_DETECT_HERO_TIME	= 50
VAMPIRE_STATUS_SHOOT_PREP_TIME		= 30
VAMPIRE_STATUS_RELAX_TIME			= 25
VAMPIRE_STATUS_MOVE_TIME			= 55

; animation speed (the less the slower, 0-255, 255 means the next frame is almost every update)
VAMPIRE_ANIM_SPEED_DETECT_HERO	= 30
VAMPIRE_ANIM_SPEED_RELAX		= 20
VAMPIRE_ANIM_SPEED_MOVE		= 50
VAMPIRE_ANIM_SPEED_SHOOT_PREP	= 1

; gameplay
VAMPIRE_DAMAGE = 1
VAMPIRE_HEALTH = 1

VAMPIRE_COLLISION_WIDTH	= 15
VAMPIRE_COLLISION_HEIGHT	= 10

VAMPIRE_MOVE_SPEED		= $00c0
VAMPIRE_MOVE_SPEED_NEG	= $ffff - $c0 + 1

VAMPIRE_DETECT_HERO_DISTANCE = 90

;========================================================
; called to spawn this monster
; in:
; c - tile idx in the room_tiledata array.
; a - monster id * 4
; out:
; a = 0
vampire_init:
			MONSTER_INIT(vampire_update, vampire_draw, monster_impacted, VAMPIRE_HEALTH, VAMPIRE_STATUS_DETECT_HERO_INIT, vampire_idle)
			ret

; anim and a gameplay logic update
; in:
; de - ptr to monster_update_ptr in the runtime data
vampire_update:
			; advance hl to monster_status
			LXI_H_TO_DIFF(monster_status, monster_update_ptr)
			dad d
			mov a, m
			; TODO: optimization. think of using a call table
			cpi VAMPIRE_STATUS_MOVE
			jz vampire_update_move
			cpi VAMPIRE_STATUS_DETECT_HERO
			jz vampire_update_detect_hero
			cpi VAMPIRE_STATUS_RELAX
			jz vampire_update_relax
			cpi VAMPIRE_STATUS_SHOOT_PREP
			jz vampire_update_shoot_prep
			cpi VAMPIRE_STATUS_MOVE_INIT
			jz vampire_update_move_init
			cpi VAMPIRE_STATUS_DETECT_HERO_INIT
			jz vampire_update_detect_hero_init
			cpi VAMPIRE_STATUS_SHOOT
			jz vampire_update_shoot
			ret

vampire_update_detect_hero_init:
			; hl = monster_status
			mvi m, VAMPIRE_STATUS_DETECT_HERO
			inx h
			mvi m, VAMPIRE_STATUS_DETECT_HERO_TIME
			LXI_B_TO_DIFF(monster_anim_ptr, monster_status_timer)
			dad b
			mvi m, <vampire_idle
			inx h
			mvi m, >vampire_idle
			ret

vampire_update_detect_hero:
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
			cpi VAMPIRE_DETECT_HERO_DISTANCE
			jc @checkPosYDiff
			jmp @updateAnimHeroDetectX
@checkNegPosXDiff:
			cpi -VAMPIRE_DETECT_HERO_DISTANCE
			jnc @checkPosYDiff
			jmp @updateAnimHeroDetectX
@checkPosYDiff:
			; advance hl to monster_pos_y+1
			inx_h(2)
			; check hero-monster posY diff
			lda hero_pos_y+1
			sub m
			jc @checkNegPosYDiff
			cpi VAMPIRE_DETECT_HERO_DISTANCE
			jc @heroDetected
			jmp @updateAnimHeroDetectY
@checkNegPosYDiff:
			cpi -VAMPIRE_DETECT_HERO_DISTANCE
			jnc @heroDetected
			jmp @updateAnimHeroDetectY
@heroDetected:
			; hl = monster_pos_y+1
			; advance hl to monster_status
			LXI_B_TO_DIFF(monster_status, monster_pos_y+1)
			dad b
			mvi m, VAMPIRE_STATUS_SHOOT_PREP
			inx h
			mvi m, VAMPIRE_STATUS_SHOOT_PREP_TIME
			; advance hl to monster_anim_ptr
			LXI_B_TO_DIFF(monster_anim_ptr, monster_status_timer)
			dad b
			mvi m, <vampire_cast
			inx h
			mvi m, >vampire_cast
			ret
@updateAnimHeroDetectX:
			; advance hl to monster_anim_timer
			LXI_B_TO_DIFF(monster_anim_timer, monster_pos_x+1)
			dad b
			mvi a, VAMPIRE_ANIM_SPEED_DETECT_HERO
			jmp vampire_update_anim_check_collision_hero
@updateAnimHeroDetectY:
			; advance hl to monster_anim_timer
			LXI_B_TO_DIFF(monster_anim_timer, monster_pos_y+1)
			dad b
			mvi a, VAMPIRE_ANIM_SPEED_DETECT_HERO
			jmp vampire_update_anim_check_collision_hero

@setMoveInit:
 			; hl - ptr to monster_status_timer
			mvi m, VAMPIRE_STATUS_MOVE_TIME
			; advance hl to monster_status
			dcx h
			mvi m, VAMPIRE_STATUS_MOVE_INIT
			ret

vampire_update_move_init:
			; hl = monster_status
			mvi m, VAMPIRE_STATUS_MOVE
			;inx h
			;mvi m, VAMPIRE_STATUS_MOVE_TIME ; TODO: use a rnd number instead of a const

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
			mvi m, <VAMPIRE_MOVE_SPEED_NEG
			inx h
			mvi m, >VAMPIRE_MOVE_SPEED_NEG
			jmp @setAnim
@speedYp:
			mov m, c
			inx h
			mov m, c
			inx h
			mvi m, <VAMPIRE_MOVE_SPEED
			inx h
			mvi m, >VAMPIRE_MOVE_SPEED
			jmp @setAnim
@speedXn:
			mvi m, <VAMPIRE_MOVE_SPEED_NEG
			inx h
			mvi m, >VAMPIRE_MOVE_SPEED_NEG
			inx h
			mov m, c
			inx h
			mov m, c
			jmp @setAnim
@speedXp:
			mvi m, <VAMPIRE_MOVE_SPEED
			inx h
			mvi m, >VAMPIRE_MOVE_SPEED
			inx h
			mov m, c
			inx h
			mov m, c
@setAnim:
			LXI_B_TO_DIFF(monster_anim_ptr, monster_speed_y+1)
			dad b
			; a = rnd
			ora a
			; if rnd is positive (up or right movement), then play vampire_run_r anim
			jp @setAnimRunR
@setAnimRunL:
			mvi m, <vampire_run_l
			inx h
			mvi m, >vampire_run_l
			ret
@setAnimRunR:
			mvi m, <vampire_run_r
			inx h
			mvi m, >vampire_run_r
            ret

vampire_update_move:
			; hl = monster_status
			; advance hl to monster_status_timer
			inx h
			dcr m
			jz @setDetectHeroInit
@updateMovement:
			ACTOR_UPDATE_MOVEMENT_CHECK_TILE_COLLISION(monster_status_timer, monster_pos_x, VAMPIRE_COLLISION_WIDTH, VAMPIRE_COLLISION_HEIGHT, @setMoveInit) 
			
			; hl points to monster_pos_y+1
			; advance hl to monster_anim_timer
			LXI_B_TO_DIFF(monster_anim_timer, monster_pos_y+1)
			dad b
			mvi a, VAMPIRE_ANIM_SPEED_MOVE
			jmp vampire_update_anim_check_collision_hero

@setMoveInit:
			pop h
			; hl points to monster_pos_x
			; advance hl to monster_status
			LXI_B_TO_DIFF(monster_status, monster_pos_x)
			dad b
			mvi m, VAMPIRE_STATUS_MOVE_INIT
			inx h
			mvi m, VAMPIRE_STATUS_MOVE_TIME
			ret
@setDetectHeroInit:
 			; hl - ptr to monster_status_timer
			; advance hl to monster_status
			dcx h
			mvi m, VAMPIRE_STATUS_DETECT_HERO_INIT
			ret

vampire_update_relax:
			; hl = monster_status
			; advance hl to monster_status_timer
			inx h
			dcr m
			jz @setMoveInit
			; advance hl to monster_anim_timer
			LXI_B_TO_DIFF(monster_anim_timer, monster_status_timer)
			dad b
			mvi a, VAMPIRE_ANIM_SPEED_RELAX
			jmp vampire_update_anim_check_collision_hero
 @setMoveInit:
 			; hl - ptr to monster_status_timer
			mvi m, VAMPIRE_STATUS_MOVE_TIME
			; advance hl to monster_status
			dcx h
			mvi m, VAMPIRE_STATUS_MOVE_INIT
			ret

vampire_update_shoot_prep:
			; hl = monster_status
			; advance hl to monster_status_timer
			inx h
			dcr m
			jz @setShoot
			; advance hl to monster_anim_timer
			LXI_B_TO_DIFF(monster_anim_timer, monster_status_timer)
			dad b
			mvi a, VAMPIRE_ANIM_SPEED_SHOOT_PREP
			jmp vampire_update_anim_check_collision_hero
 @setShoot:
  			; hl - ptr to monster_status_timer
			; advance hl to monster_status
			dcx h
			mvi m, VAMPIRE_STATUS_SHOOT
			
			lxi h, __sfx_vampire_attack
			CALL_RAM_DISK_FUNC_NO_RESTORE(__sfx_play, __RAM_DISK_M_SOUND | RAM_DISK_M_8F)
			ret

vampire_update_shoot:
			; hl = monster_status
			mvi m, VAMPIRE_STATUS_RELAX
			; advance hl to monster_status_timer
			inx h
			mvi m, VAMPIRE_STATUS_RELAX_TIME

			; advance hl to monster_pos_x+1
			LXI_B_TO_DIFF(monster_pos_x+1, monster_status_timer)
			dad b
			mov b, m
			inx_h(2)
			mov c, m
			mvi a, BOMB_DMG_ID
			jmp bomb_init

; in:
; hl - monster_anim_timer
; a - anim speed
vampire_update_anim_check_collision_hero:
			call actor_anim_update
			MONSTER_CHECK_COLLISION_HERO(VAMPIRE_COLLISION_WIDTH, VAMPIRE_COLLISION_HEIGHT, VAMPIRE_DAMAGE)

; draw a sprite into a backbuffer
; in:
; de - ptr to monster_draw_ptr in the runtime data
vampire_draw:
			MONSTER_DRAW(sprite_get_scr_addr_vampire, __RAM_DISK_S_VAMPIRE)