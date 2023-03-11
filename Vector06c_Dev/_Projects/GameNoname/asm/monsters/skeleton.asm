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
;		if distance(mob, hero) < a shooting radius:
;			status = shootPrep
;			statusTimer = shootPrepTime
;			anim to the hero dir
;		else:
;			updateAnim
;			check mod-hero collision, impact if collides
; shootPrep:
;	decr statusTimer
;	if statusTimer == 0:
;		status = shoot
;	else:
;		updateAnim
;		check mod-hero collision, impact if collides
; shoot:
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
SKELETON_STATUS_DETECT_HERO_INIT	= 0
SKELETON_STATUS_DETECT_HERO			= 1
SKELETON_STATUS_SHOOT_PREP			= 2
SKELETON_STATUS_SHOOT				= 3
SKELETON_STATUS_RELAX				= 4
SKELETON_STATUS_MOVE_INIT			= 5
SKELETON_STATUS_MOVE				= 6

; status duration in updates.
SKELETON_STATUS_DETECT_HERO_TIME	= 50
SKELETON_STATUS_SHOOT_PREP_TIME		= 10
SKELETON_STATUS_RELAX_TIME			= 25
SKELETON_STATUS_MOVE_TIME			= 50

; animation speed (the less the slower, 0-255, 255 means the next frame is almost every update)
SKELETON_ANIM_SPEED_DETECT_HERO	= 30
SKELETON_ANIM_SPEED_RELAX		= 20
SKELETON_ANIM_SPEED_MOVE		= 50
SKELETON_ANIM_SPEED_SHOOT_PREP	= 1

; gameplay
SKELETON_DAMAGE = 1
SKELETON_HEALTH = 1

SKELETON_COLLISION_WIDTH	= 15
SKELETON_COLLISION_HEIGHT	= 10

SKELETON_MOVE_SPEED		= $0100
SKELETON_MOVE_SPEED_NEG	= $ffff - $100 + 1

SKELETON_DETECT_HERO_DISTANCE = 60

;========================================================
; called to spawn this monster
; in:
; c - tile idx in the room_tiledata array.
; a - monster id * 4
; out:
; a = 0
skeleton_init:
			MONSTER_INIT(skeleton_update, skeleton_draw, monster_impacted, SKELETON_HEALTH, SKELETON_STATUS_DETECT_HERO_INIT, skeleton_idle)
			ret

; anim and a gameplay logic update
; in:
; de - ptr to monster_update_ptr in the runtime data
skeleton_update:
			; advance hl to monster_status
			LXI_H_TO_DIFF(monster_status, monster_update_ptr)
			dad d
			mov a, m
			; TODO: optimization. think of using a call table
			cpi SKELETON_STATUS_MOVE
			jz skeleton_update_move
			cpi SKELETON_STATUS_DETECT_HERO
			jz skeleton_update_detect_hero
			cpi SKELETON_STATUS_RELAX
			jz skeleton_update_relax
			cpi SKELETON_STATUS_SHOOT_PREP
			jz skeleton_update_shoot_prep
			cpi SKELETON_STATUS_MOVE_INIT
			jz skeleton_update_move_init
			cpi SKELETON_STATUS_DETECT_HERO_INIT
			jz skeleton_update_detect_hero_init
			cpi SKELETON_STATUS_SHOOT
			jz skeleton_update_shoot
			ret

skeleton_update_detect_hero_init:
			; hl = monster_status
			mvi m, SKELETON_STATUS_DETECT_HERO
			inx h
			mvi m, SKELETON_STATUS_DETECT_HERO_TIME
			LXI_B_TO_DIFF(monster_anim_ptr, monster_status_timer)
			dad b
			mvi m, <skeleton_idle
			inx h
			mvi m, >skeleton_idle
			ret

skeleton_update_detect_hero:
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
			cpi SKELETON_DETECT_HERO_DISTANCE
			jc @checkPosYDiff
			jmp @updateAnimHeroDetectX
@checkNegPosXDiff:
			cpi -SKELETON_DETECT_HERO_DISTANCE
			jnc @checkPosYDiff
			jmp @updateAnimHeroDetectX
@checkPosYDiff:
			; advance hl to monster_pos_y+1
			inx_h(2)
			; check hero-monster posY diff
			lda hero_pos_y+1
			sub m
			jc @checkNegPosYDiff
			cpi SKELETON_DETECT_HERO_DISTANCE
			jc @detectsHero
			jmp @updateAnimHeroDetectY
@checkNegPosYDiff:
			cpi -SKELETON_DETECT_HERO_DISTANCE
			jnc @detectsHero
			jmp @updateAnimHeroDetectY
@detectsHero:
			; hl = monster_pos_y+1
			; advance hl to monster_status
			LXI_B_TO_DIFF(monster_status, monster_pos_y+1)
			dad b
			mvi m, SKELETON_STATUS_SHOOT_PREP
			inx h
			mvi m, SKELETON_STATUS_SHOOT_PREP_TIME
			; advance hl to monster_anim_ptr
			LXI_B_TO_DIFF(monster_anim_ptr, monster_status_timer)
			dad b
			mvi m, <skeleton_idle
			inx h
			mvi m, >skeleton_idle
			ret
@updateAnimHeroDetectX:
			; advance hl to monster_anim_timer
			LXI_B_TO_DIFF(monster_anim_timer, monster_pos_x+1)
			dad b
			mvi a, SKELETON_ANIM_SPEED_DETECT_HERO
			jmp skeleton_update_anim_check_collision_hero
@updateAnimHeroDetectY:
			; advance hl to monster_anim_timer
			LXI_B_TO_DIFF(monster_anim_timer, monster_pos_y+1)
			dad b
			mvi a, SKELETON_ANIM_SPEED_DETECT_HERO
			jmp skeleton_update_anim_check_collision_hero

@setMoveInit:
 			; hl - ptr to monster_status_timer
			mvi m, SKELETON_STATUS_MOVE_TIME
			; advance hl to monster_status
			dcx h
			mvi m, SKELETON_STATUS_MOVE_INIT
			ret

skeleton_update_move_init:
			; hl = monster_status
			mvi m, SKELETON_STATUS_MOVE
			;inx h
			;mvi m, SKELETON_STATUS_MOVE_TIME ; TODO: use a rnd number instead of a const

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
			mvi m, <SKELETON_MOVE_SPEED_NEG
			inx h
			mvi m, >SKELETON_MOVE_SPEED_NEG
			jmp @setAnim
@speedYp:
			mov m, c
			inx h
			mov m, c
			inx h
			mvi m, <SKELETON_MOVE_SPEED
			inx h
			mvi m, >SKELETON_MOVE_SPEED
			jmp @setAnim
@speedXn:
			mvi m, <SKELETON_MOVE_SPEED_NEG
			inx h
			mvi m, >SKELETON_MOVE_SPEED_NEG
			inx h
			mov m, c
			inx h
			mov m, c
			jmp @setAnim
@speedXp:
			mvi m, <SKELETON_MOVE_SPEED
			inx h
			mvi m, >SKELETON_MOVE_SPEED
			inx h
			mov m, c
			inx h
			mov m, c
@setAnim:
			LXI_B_TO_DIFF(monster_anim_ptr, monster_speed_y+1)
			dad b
			; a = rnd
			ora a
			; if rnd is positive (up or right movement), then play skeleton_run_r anim
			jp @setAnimRunR
@setAnimRunL:
			mvi m, <skeleton_run_l
			inx h
			mvi m, >skeleton_run_l
			ret
@setAnimRunR:
			mvi m, <skeleton_run_r
			inx h
			mvi m, >skeleton_run_r
            ret

skeleton_update_move:
			; hl = monster_status
			; advance hl to monster_status_timer
			inx h
			dcr m
			jz @setDetectHeroInit
@updateMovement:
			ACTOR_UPDATE_MOVEMENT_CHECK_TILE_COLLISION(monster_status_timer, monster_pos_x, SKELETON_COLLISION_WIDTH, SKELETON_COLLISION_HEIGHT, @setMoveInit) 
			
			; hl points to monster_pos_y+1
			; advance hl to monster_anim_timer
			LXI_B_TO_DIFF(monster_anim_timer, monster_pos_y+1)
			dad b
			mvi a, SKELETON_ANIM_SPEED_MOVE
			jmp skeleton_update_anim_check_collision_hero

@setMoveInit:
			pop h
			; hl points to monster_pos_x
			; advance hl to monster_status
			LXI_B_TO_DIFF(monster_status, monster_pos_x)
			dad b
			mvi m, SKELETON_STATUS_MOVE_INIT
			inx h
			mvi m, SKELETON_STATUS_MOVE_TIME
			ret
@setDetectHeroInit:
 			; hl - ptr to monster_status_timer
			mvi m, SKELETON_STATUS_MOVE_TIME
			; advance hl to monster_status
			dcx h
			mvi m, SKELETON_STATUS_DETECT_HERO_INIT
			ret

skeleton_update_relax:
			; hl = monster_status
			; advance hl to monster_status_timer
			inx h
			dcr m
			jz @setMoveInit
			; advance hl to monster_anim_timer
			LXI_B_TO_DIFF(monster_anim_timer, monster_status_timer)
			dad b
			mvi a, SKELETON_ANIM_SPEED_RELAX
			jmp skeleton_update_anim_check_collision_hero
 @setMoveInit:
 			; hl - ptr to monster_status_timer
			mvi m, SKELETON_STATUS_MOVE_TIME
			; advance hl to monster_status
			dcx h
			mvi m, SKELETON_STATUS_MOVE_INIT
			ret

skeleton_update_shoot_prep:
			; hl = monster_status
			; advance hl to monster_status_timer
			inx h
			dcr m
			jz @setShoot
			; advance hl to monster_anim_timer
			LXI_B_TO_DIFF(monster_anim_timer, monster_status_timer)
			dad b
			mvi a, SKELETON_ANIM_SPEED_SHOOT_PREP
			jmp skeleton_update_anim_check_collision_hero
 @setShoot:
  			; hl - ptr to monster_status_timer
			; advance hl to monster_status
			dcx h
			mvi m, SKELETON_STATUS_SHOOT
			ret

skeleton_update_shoot:
			; hl = monster_status
			mvi m, SKELETON_STATUS_RELAX
			; advance hl to monster_status_timer
			inx h
			mvi m, SKELETON_STATUS_RELAX_TIME

			LXI_B_TO_DIFF(monster_speed_x, monster_status_timer)
			dad b
			mov a, m
			inx h
			ora m
			jz @shootVert
			mov a, m
			ora a
			mvi a, BULLET_DIR_R
			jp @shootRight
@shootLeft:
			mvi a, BULLET_DIR_L
@shootRight:
			LXI_B_TO_DIFF(monster_pos_x+1, monster_speed_x+1)
			jmp @setBulletPos
@shootVert:
			; advance hl to monster_speed_y+1
			inx_h(2)
			mov a, m
			ora a
			mvi a, BULLET_DIR_U
			jp @shootUp
@shootDown:
			mvi a, BULLET_DIR_D
@shootUp:
			LXI_B_TO_DIFF(monster_pos_x+1, monster_speed_y+1)
@setBulletPos:
			dad b
			mov b, m
			inx_h(2)
			mov c, m
			jmp scythe_init

; in:
; hl - monster_anim_timer
; a - anim speed
skeleton_update_anim_check_collision_hero:
			call actor_anim_update
			MONSTER_CHECK_COLLISION_HERO(SKELETON_COLLISION_WIDTH, SKELETON_COLLISION_HEIGHT, SKELETON_DAMAGE)

; draw a sprite into a backbuffer
; in:
; de - ptr to monster_draw_ptr in the runtime data
skeleton_draw:
			MONSTER_DRAW(sprite_get_scr_addr_skeleton, __RAM_DISK_S_SKELETON)