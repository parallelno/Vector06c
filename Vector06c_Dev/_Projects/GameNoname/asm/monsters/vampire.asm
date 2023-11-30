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
;		if distance(mob, hero) < a casting radius:
;			status = cast_prep
;			status_timer = castPrepTime
;			anim = cast
;		else:
;			update_anim
;			check mod-hero collision, impact if collides
; cast_prep:
;	decr status_timer
;	if status_timer == 0:
;		status = cast
;		anim = cast
;	else:
;		update_anim
;		check mod-hero collision, impact if collides
; cast:
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
VAMPIRE_STATUS_DETECT_HERO_INIT	= MONSTER_STATUS_INIT
VAMPIRE_STATUS_DETECT_HERO		= 1
VAMPIRE_STATUS_SHOOT_PREP		= 2
VAMPIRE_STATUS_SHOOT			= 3
VAMPIRE_STATUS_RELAX			= 4
VAMPIRE_STATUS_MOVE_INIT		= 5
VAMPIRE_STATUS_MOVE				= 6

; status duration in updates.
VAMPIRE_STATUS_DETECT_HERO_TIME	= 50
VAMPIRE_STATUS_SHOOT_PREP_TIME	= 30
VAMPIRE_STATUS_RELAX_TIME		= 25
VAMPIRE_STATUS_MOVE_TIME		= 55

; animation speed (the less the slower, 0-255, 255 means the next frame is almost every update)
VAMPIRE_ANIM_SPEED_DETECT_HERO	= 30
VAMPIRE_ANIM_SPEED_RELAX		= 20
VAMPIRE_ANIM_SPEED_MOVE			= 50
VAMPIRE_ANIM_SPEED_SHOOT_PREP	= 1

; gameplay
VAMPIRE_DAMAGE = 1
VAMPIRE_HEALTH = 5

VAMPIRE_COLLISION_WIDTH		= 15
VAMPIRE_COLLISION_HEIGHT	= 10

VAMPIRE_MOVE_SPEED		= $00c0
VAMPIRE_MOVE_SPEED_NEG	= $ffff - $c0 + 1

VAMPIRE_DETECT_HERO_DISTANCE = 90

;========================================================
; spawn and init a monster
; in:
; c - tile_idx in the room_tiledata array.
; a - monster_id * 4
; out:
; a = TILEDATA_RESTORE_TILE
vampire_init:
			MONSTER_INIT(vampire_update, vampire_draw, monster_impacted, VAMPIRE_HEALTH, VAMPIRE_STATUS_DETECT_HERO_INIT, vampire_idle)

;========================================================
; anim and a gameplay logic update
; in:
; de - ptr to monster_update_ptr 
vampire_update:
			; advance hl to monster_status
			LXI_H_TO_DIFF(monster_update_ptr, monster_status)
			dad d
			mov a, m
			; a - monster_status
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
			cpi MONSTER_STATUS_FREEZE
			jz monster_update_freeze
			ret

vampire_update_detect_hero_init:
			; hl = monster_status
			mvi m, VAMPIRE_STATUS_DETECT_HERO
			inx h
			mvi m, VAMPIRE_STATUS_DETECT_HERO_TIME
			HL_ADVANCE_BY_DIFF_BC(monster_status_timer, monster_anim_ptr)
			mvi m, <vampire_idle
			inx h
			mvi m, >vampire_idle
			ret

vampire_update_detect_hero:
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
			cpi VAMPIRE_DETECT_HERO_DISTANCE
			jc @check_pos_y_diff
			jmp @update_anim_hero_detect_x
@check_neg_pos_x_diff:
			cpi -VAMPIRE_DETECT_HERO_DISTANCE
			jnc @check_pos_y_diff
			jmp @update_anim_hero_detect_x
@check_pos_y_diff:
			; advance hl to monster_pos_y+1
			INX_H(2)
			; check hero-monster pos_y diff
			lda hero_pos_y+1
			sub m
			jc @check_neg_pos_y_diff
			cpi VAMPIRE_DETECT_HERO_DISTANCE
			jc @hero_detected
			jmp @update_anim_hero_detect_y
@check_neg_pos_y_diff:
			cpi -VAMPIRE_DETECT_HERO_DISTANCE
			jnc @hero_detected
			jmp @update_anim_hero_detect_y
@hero_detected:
			; hl = monster_pos_y+1
			; advance hl to monster_status
			HL_ADVANCE_BY_DIFF_BC(monster_pos_y+1, monster_status)
			mvi m, VAMPIRE_STATUS_SHOOT_PREP
			inx h
			mvi m, VAMPIRE_STATUS_SHOOT_PREP_TIME
			; advance hl to monster_anim_ptr
			HL_ADVANCE_BY_DIFF_BC(monster_status_timer, monster_anim_ptr)
			mvi m, <vampire_cast
			inx h
			mvi m, >vampire_cast
			ret
@update_anim_hero_detect_x:
			; advance hl to monster_anim_timer
			HL_ADVANCE_BY_DIFF_BC(monster_pos_x+1, monster_anim_timer)
			mvi a, VAMPIRE_ANIM_SPEED_DETECT_HERO
			jmp vampire_update_anim_check_collision_hero
@update_anim_hero_detect_y:
			; advance hl to monster_anim_timer
			HL_ADVANCE_BY_DIFF_BC(monster_pos_y+1, monster_anim_timer)
			mvi a, VAMPIRE_ANIM_SPEED_DETECT_HERO
			jmp vampire_update_anim_check_collision_hero

@set_move_init:
 			; hl - ptr to monster_status_timer
			mvi m, VAMPIRE_STATUS_MOVE_TIME
			; advance hl to monster_status
			dcx h
			mvi m, VAMPIRE_STATUS_MOVE_INIT
			ret

vampire_update_move_init:
			; hl = monster_status
			mvi m, VAMPIRE_STATUS_MOVE
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
			mvi m, <VAMPIRE_MOVE_SPEED_NEG
			inx h
			mvi m, >VAMPIRE_MOVE_SPEED_NEG
			jmp @set_anim
@speed_y_positive:
			mov m, c
			inx h
			mov m, c
			inx h
			mvi m, <VAMPIRE_MOVE_SPEED
			inx h
			mvi m, >VAMPIRE_MOVE_SPEED
			jmp @set_anim
@speed_x_negative:
			mvi m, <VAMPIRE_MOVE_SPEED_NEG
			inx h
			mvi m, >VAMPIRE_MOVE_SPEED_NEG
			inx h
			mov m, c
			inx h
			mov m, c
			jmp @set_anim
@speed_x_positive:
			mvi m, <VAMPIRE_MOVE_SPEED
			inx h
			mvi m, >VAMPIRE_MOVE_SPEED
			inx h
			mov m, c
			inx h
			mov m, c
@set_anim:
			HL_ADVANCE_BY_DIFF_BC(monster_speed_y+1, monster_anim_ptr)
			; a = rnd
			CPI_WITH_ZERO(0)
			; if rnd is positive (up or right movement), then play vampire_run_r anim
			jp @set_anim_run_r
@set_anim_run_l:
			mvi m, <vampire_run_l
			inx h
			mvi m, >vampire_run_l
			ret
@set_anim_run_r:
			mvi m, <vampire_run_r
			inx h
			mvi m, >vampire_run_r
            ret

vampire_update_move:
			; hl = monster_status
			; advance hl to monster_status_timer
			inx h
			dcr m
			jz @set_detect_hero_init
@update_movement:
			ACTOR_UPDATE_MOVEMENT_CHECK_TILE_COLLISION(monster_status_timer, monster_pos_x, VAMPIRE_COLLISION_WIDTH, VAMPIRE_COLLISION_HEIGHT, @set_move_init) 
			
			; hl points to monster_pos_y+1
			; advance hl to monster_anim_timer
			HL_ADVANCE_BY_DIFF_BC(monster_pos_y+1, monster_anim_timer)
			mvi a, VAMPIRE_ANIM_SPEED_MOVE
			jmp vampire_update_anim_check_collision_hero

@set_move_init:
			; hl points to monster_pos_x
			; advance hl to monster_status
			HL_ADVANCE_BY_DIFF_BC(monster_pos_x, monster_status)
			mvi m, VAMPIRE_STATUS_MOVE_INIT
			inx h
			mvi m, VAMPIRE_STATUS_MOVE_TIME
			ret
@set_detect_hero_init:
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
			jz @set_move_init
			; advance hl to monster_anim_timer
			HL_ADVANCE_BY_DIFF_BC(monster_status_timer, monster_anim_timer)
			mvi a, VAMPIRE_ANIM_SPEED_RELAX
			jmp vampire_update_anim_check_collision_hero
 @set_move_init:
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
			jz @set_shoot
			; advance hl to monster_anim_timer
			HL_ADVANCE_BY_DIFF_BC(monster_status_timer, monster_anim_timer)
			mvi a, VAMPIRE_ANIM_SPEED_SHOOT_PREP
			jmp vampire_update_anim_check_collision_hero
 @set_shoot:
  			; hl - ptr to monster_status_timer
			; advance hl to monster_status
			dcx h
			mvi m, VAMPIRE_STATUS_SHOOT
			
			lxi h, __sfx_vampire_attack
			CALL_RAM_DISK_FUNC(__sfx_play, __RAM_DISK_M_SOUND | RAM_DISK_M_8F)
			ret

vampire_update_shoot:
			; hl = monster_status
			mvi m, VAMPIRE_STATUS_RELAX
			; advance hl to monster_status_timer
			inx h
			mvi m, VAMPIRE_STATUS_RELAX_TIME

			; advance hl to monster_pos_x+1
			HL_ADVANCE_BY_DIFF_BC(monster_status_timer, monster_pos_x+1)
			mov b, m
			INX_H(2)
			mov c, m
			jmp bomb_dmg_init

; in:
; hl - monster_anim_timer
; a - anim speed
vampire_update_anim_check_collision_hero:
			call actor_anim_update
			MONSTER_CHECK_COLLISION_HERO(VAMPIRE_COLLISION_WIDTH, VAMPIRE_COLLISION_HEIGHT, VAMPIRE_DAMAGE)

; draw a sprite into a backbuffer
; in:
; de - ptr to monster_draw_ptr 
vampire_draw:
			MONSTER_DRAW(sprite_get_scr_addr_vampire, __RAM_DISK_S_VAMPIRE)