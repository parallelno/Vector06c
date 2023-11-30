; mob AI:
; init:
;	 status = detectHeroInit
; detectHeroInit:
;	status = detect_hero
;	status_timer = detectHeroTime
;	anim = idle.
; detect_hero:
;	decr status_timer
;	if status_timer == 0:
;		status = move_init
;	else:
;		if distance(mob, hero) < a shooting radius:
;			status = shoot_prep
;			status_timer = shootPrepTime
;			anim to the hero dir
;		else:
;			update_anim
;			check mod-hero collision, impact if collides
; shoot_prep:
;	decr status_timer
;	if status_timer == 0:
;		status = shoot
;	else:
;		update_anim
;		check mod-hero collision, impact if collides
; shoot:
;	status = relax
;	status_timer = relax_time
;	spawn a projectile along the mob dir
; relax:
;	decr status_timer
;	if status_timer == 0:
;		status = move_init
;	else:
;		update_anim
;		check mod-hero collision, impact if collides
; move_init:
;	status = move
;	status_timer = random
;	speed = random dir
;	set anim along the dir
; move:
;	decr status_timer
;	if status_timer = 0
;		status = detectHeroInit
;	else:
;		try to move a mob
;		if mob collides with tiles:
;			status = move_init
;		else:
;			accept new pos
;			update_anim
;			check mod-hero collision, impact if collides

; statuses.
SKELETON_STATUS_DETECT_HERO_INIT	= MONSTER_STATUS_INIT
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
SKELETON_HEALTH = 3

SKELETON_COLLISION_WIDTH	= 15
SKELETON_COLLISION_HEIGHT	= 10

SKELETON_MOVE_SPEED		= $0100
SKELETON_MOVE_SPEED_NEG	= $ffff - $100 + 1

SKELETON_DETECT_HERO_DISTANCE = 60

;========================================================
; spawn and init a monster
; in:
; c - tile_idx in the room_tiledata array.
; a - monster_id * 4
; out:
; a = TILEDATA_RESTORE_TILE
skeleton_init:
			MONSTER_INIT(skeleton_update, skeleton_draw, monster_impacted, SKELETON_HEALTH, SKELETON_STATUS_DETECT_HERO_INIT, skeleton_idle)

;========================================================
; anim and a gameplay logic update
; in:
; de - ptr to monster_update_ptr 
skeleton_update:
			; advance hl to monster_status
			LXI_H_TO_DIFF(monster_update_ptr, monster_status)
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
			cpi MONSTER_STATUS_FREEZE
			jz monster_update_freeze			
			ret

skeleton_update_detect_hero_init:
			; hl = monster_status
			mvi m, SKELETON_STATUS_DETECT_HERO
			inx h
			mvi m, SKELETON_STATUS_DETECT_HERO_TIME
			HL_ADVANCE_BY_DIFF_BC(monster_status_timer, monster_anim_ptr)
			mvi m, <skeleton_idle
			inx h
			mvi m, >skeleton_idle
			ret

skeleton_update_detect_hero:
			; hl = monster_status
			; advance hl to monster_status_timer
			inx h
			dcr m
			jz @set_move_init
@check_mob_hero_distance:
			; advance hl to monster_pos_x+1
			HL_ADVANCE_BY_DIFF_BC(monster_status_timer, monster_pos_x+1)
			; check hero-monster pos_x diff
			lda hero_pos_x+1
			sub m
			jc @check_neg_pos_x_diff
			cpi SKELETON_DETECT_HERO_DISTANCE
			jc @check_pos_y_diff
			jmp @update_anim_hero_detect_x
@check_neg_pos_x_diff:
			cpi -SKELETON_DETECT_HERO_DISTANCE
			jnc @check_pos_y_diff
			jmp @update_anim_hero_detect_x
@check_pos_y_diff:
			; advance hl to monster_pos_y+1
			INX_H(2)
			; check hero-monster pos_y diff
			lda hero_pos_y+1
			sub m
			jc @check_neg_pos_y_diff
			cpi SKELETON_DETECT_HERO_DISTANCE
			jc @detect_hero
			jmp @update_anim_hero_detect_y
@check_neg_pos_y_diff:
			cpi -SKELETON_DETECT_HERO_DISTANCE
			jnc @detect_hero
			jmp @update_anim_hero_detect_y
@detect_hero:
			; hl = monster_pos_y+1
			; advance hl to monster_status
			HL_ADVANCE_BY_DIFF_BC(monster_pos_y+1, monster_status)
			mvi m, SKELETON_STATUS_SHOOT_PREP
			inx h
			mvi m, SKELETON_STATUS_SHOOT_PREP_TIME
			; advance hl to monster_anim_ptr
			HL_ADVANCE_BY_DIFF_BC(monster_status_timer, monster_anim_ptr)
			mvi m, <skeleton_idle
			inx h
			mvi m, >skeleton_idle
			ret
@update_anim_hero_detect_x:
			; advance hl to monster_anim_timer
			HL_ADVANCE_BY_DIFF_BC(monster_pos_x+1, monster_anim_timer)
			mvi a, SKELETON_ANIM_SPEED_DETECT_HERO
			jmp skeleton_update_anim_check_collision_hero
@update_anim_hero_detect_y:
			; advance hl to monster_anim_timer
			HL_ADVANCE_BY_DIFF_BC(monster_pos_y+1, monster_anim_timer)
			mvi a, SKELETON_ANIM_SPEED_DETECT_HERO
			jmp skeleton_update_anim_check_collision_hero

@set_move_init:
 			; hl - ptr to monster_status_timer
			mvi m, SKELETON_STATUS_MOVE_TIME
			; advance hl to monster_status
			dcx h
			mvi m, SKELETON_STATUS_MOVE_INIT
			ret

skeleton_update_move_init:
			; hl = monster_status
			mvi m, SKELETON_STATUS_MOVE
			xchg
			call random
			; advance hl to monster_speed_x
			LXI_H_TO_DIFF(monster_status, monster_speed_x)
			dad d

			mvi c, 0 ; tmp c=0
			cpi $40
			jc @speed_x_positive
			cpi $80
			jc @speed_y_positive
			cpi $c0
			jc @speed_x_negative
@speed_y_negative:
			mov m, c
			inx h
			mov m, c
			inx h
			mvi m, <SKELETON_MOVE_SPEED_NEG
			inx h
			mvi m, >SKELETON_MOVE_SPEED_NEG
			jmp @set_anim
@speed_y_positive:
			mov m, c
			inx h
			mov m, c
			inx h
			mvi m, <SKELETON_MOVE_SPEED
			inx h
			mvi m, >SKELETON_MOVE_SPEED
			jmp @set_anim
@speed_x_negative:
			mvi m, <SKELETON_MOVE_SPEED_NEG
			inx h
			mvi m, >SKELETON_MOVE_SPEED_NEG
			inx h
			mov m, c
			inx h
			mov m, c
			jmp @set_anim
@speed_x_positive:
			mvi m, <SKELETON_MOVE_SPEED
			inx h
			mvi m, >SKELETON_MOVE_SPEED
			inx h
			mov m, c
			inx h
			mov m, c
@set_anim:
			HL_ADVANCE_BY_DIFF_BC(monster_speed_y+1, monster_anim_ptr)
			; a = rnd
			CPI_WITH_ZERO(0)
			; if rnd is positive (up or right movement), then play skeleton_run_r anim
			jp @set_anim_run_r
@set_anim_run_l:
			mvi m, <skeleton_run_l
			inx h
			mvi m, >skeleton_run_l
			ret
@set_anim_run_r:
			mvi m, <skeleton_run_r
			inx h
			mvi m, >skeleton_run_r
            ret

skeleton_update_move:
			; hl = monster_status
			; advance hl to monster_status_timer
			inx h
			dcr m
			jz @set_detect_hero_init
@update_movement:
			ACTOR_UPDATE_MOVEMENT_CHECK_TILE_COLLISION(monster_status_timer, monster_pos_x, SKELETON_COLLISION_WIDTH, SKELETON_COLLISION_HEIGHT, @set_move_init) 
			
			; hl points to monster_pos_y+1
			; advance hl to monster_anim_timer
			HL_ADVANCE_BY_DIFF_BC(monster_pos_y+1, monster_anim_timer)
			mvi a, SKELETON_ANIM_SPEED_MOVE
			jmp skeleton_update_anim_check_collision_hero

@set_move_init:
			; hl points to monster_pos_x
			; advance hl to monster_status
			HL_ADVANCE_BY_DIFF_BC(monster_pos_x, monster_status)
			mvi m, SKELETON_STATUS_MOVE_INIT
			inx h
			mvi m, SKELETON_STATUS_MOVE_TIME
			ret
@set_detect_hero_init:
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
			jz @set_move_init
			; advance hl to monster_anim_timer
			HL_ADVANCE_BY_DIFF_BC(monster_status_timer, monster_anim_timer)
			mvi a, SKELETON_ANIM_SPEED_RELAX
			jmp skeleton_update_anim_check_collision_hero
 @set_move_init:
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
			jz @set_shoot
			; advance hl to monster_anim_timer
			HL_ADVANCE_BY_DIFF_BC(monster_status_timer, monster_anim_timer)
			mvi a, SKELETON_ANIM_SPEED_SHOOT_PREP
			jmp skeleton_update_anim_check_collision_hero
 @set_shoot:
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

			HL_ADVANCE_BY_DIFF_BC(monster_status_timer, monster_speed_x)
			mov a, m
			inx h
			ora m
			jz @shoot_vert
			mov a, m
			CPI_WITH_ZERO(0)
			mvi a, BULLET_DIR_R
			jp @shoot_right
@shoot_left:
			mvi a, BULLET_DIR_L
@shoot_right:
			LXI_B_TO_DIFF(monster_speed_x+1, monster_pos_x+1)
			jmp @set_bullet_pos
@shoot_vert:
			; advance hl to monster_speed_y+1
			INX_H(2)
			mov a, m
			CPI_WITH_ZERO(0)
			mvi a, BULLET_DIR_U
			jp @shoot_up
@shoot_down:
			mvi a, BULLET_DIR_D
@shoot_up:
			LXI_B_TO_DIFF(monster_speed_y+1, monster_pos_x+1)
@set_bullet_pos:
			dad b
			mov b, m
			INX_H(2)
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
; de - ptr to monster_draw_ptr 
skeleton_draw:
			MONSTER_DRAW(sprite_get_scr_addr_skeleton, __RAM_DISK_S_SKELETON)