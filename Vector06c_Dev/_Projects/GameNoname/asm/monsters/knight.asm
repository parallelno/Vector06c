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
;		if distance(mob, hero) < a defence radius:
;			status = defence_prep
;		else:
;			update_anim
;			check mod-hero collision, impact if collides
; defence_prep:
;	status = defence
;	status_timer = defence_time
;	anim = run to the hero dir
;
; defence:
;	if distance(mob, hero) < a defence radius:
;		try to move a mob toward a hero, reset one coord to move along one axis
;		if mob do not collides with tiles:
;			accept new pos
;		update_anim
;		check mod-hero collision, impact if collides
;	else:
;		status = detectHeroInit
; move_init:
;	status = move
;	status_timer = random
;	speed = random dir only along one axis
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
KNIGHT_STATUS_DETECT_HERO_INIT	= MONSTER_STATUS_INIT
KNIGHT_STATUS_DETECT_HERO		= 1
KNIGHT_STATUS_DEFENCE_INIT		= 2
KNIGHT_STATUS_DEFENCE			= 3
KNIGHT_STATUS_MOVE_INIT			= 4
KNIGHT_STATUS_MOVE				= 5
KNIGHT_STATUS_PANIC				= 6

; status duration in updates.
KNIGHT_STATUS_DETECT_HERO_TIME	= 100
KNIGHT_STATUS_DEFENCE_TIME		= 30
KNIGHT_STATUS_MOVE_TIME			= 50

; animation speed (the less the slower, 0-255, 255 means the next frame is almost every update)
KNIGHT_ANIM_SPEED_DETECT_HERO	= 10
KNIGHT_ANIM_SPEED_DEFENCE		= 100
KNIGHT_ANIM_SPEED_MOVE			= 50

; gameplay
KNIGHT_DAMAGE = 3
KNIGHT_HEALTH = 10

KNIGHT_COLLISION_WIDTH	= 15
KNIGHT_COLLISION_HEIGHT	= 10

KNIGHT_MOVE_SPEED		= $0060
KNIGHT_MOVE_SPEED_NEG	= $ffff - $60 + 1

KNIGHT_DEFENCE_SPEED		= $0100
KNIGHT_DEFENCE_SPEED_NEG	= $ffff - $100 + 1

KNIGHT_DETECT_HERO_DISTANCE = 60

;========================================================
; spawn and init a monster
; in:
; c - tile_idx in the room_tiledata array.
; a - monster_id * 4
; out:
; a = TILEDATA_RESTORE_TILE
knight_init:
			MONSTER_INIT(knight_update, knight_draw, monster_impacted, KNIGHT_HEALTH, KNIGHT_STATUS_DETECT_HERO_INIT, knight_idle)

;========================================================
; anim and a gameplay logic update
; in:
; de - ptr to monster_update_ptr 
knight_update:
			; advance hl to monster_status
			HL_ADVANCE(monster_update_ptr, monster_status, BY_HL_FROM_D)
			mov a, m
			cpi KNIGHT_STATUS_MOVE
			jz knight_update_move
			cpi KNIGHT_STATUS_DETECT_HERO
			jz knight_update_detect_hero
			cpi KNIGHT_STATUS_DEFENCE
			jz knight_update_speedup
			cpi KNIGHT_STATUS_MOVE_INIT
			jz knight_update_move_init
			cpi KNIGHT_STATUS_DEFENCE_INIT
			jz knight_update_speedup_init
			cpi KNIGHT_STATUS_DETECT_HERO_INIT
			jz knight_update_detect_hero_init
			cpi MONSTER_STATUS_FREEZE
			jz monster_update_freeze
			ret

; in:
; hl - ptr to monster_status
knight_update_detect_hero_init:
			; hl = monster_status
			mvi m, KNIGHT_STATUS_DETECT_HERO
			inx h
			mvi m, KNIGHT_STATUS_DETECT_HERO_TIME
			HL_ADVANCE(monster_status_timer, monster_anim_ptr)
			mvi m, <knight_idle
			inx h
			mvi m, >knight_idle
			ret

; in:
; hl - ptr to monster_status
knight_update_detect_hero:
			MONSTER_UPDATE_DETECT_HERO( KNIGHT_DETECT_HERO_DISTANCE, KNIGHT_STATUS_DEFENCE_INIT, NULL, NULL, KNIGHT_ANIM_SPEED_DETECT_HERO, knight_update_anim_check_collision_hero, KNIGHT_STATUS_MOVE_INIT, KNIGHT_STATUS_MOVE_TIME)

; in:
; hl - ptr to monster_status
knight_update_speedup_init:
			; hl - ptr to monster_status
			mvi m, KNIGHT_STATUS_DEFENCE
			; advance hl to monster_status_timer
			inx h
			mvi m, KNIGHT_STATUS_DEFENCE_TIME
@check_anim_dir:
			; aim the monster to the hero dir
			; advance hl to monster_pos_x+1
			HL_ADVANCE(monster_status_timer, monster_pos_x+1, BY_BC)
			lda hero_pos_x+1
			cmp m
			lxi d, knight_run_l
			jc @dir_x_neg
@dir_x_positive:
			lxi d, knight_run_r
@dir_x_neg:
			; advance hl to monster_anim_ptr
			HL_ADVANCE(monster_pos_x+1, monster_anim_ptr, BY_BC)
			mov m, e
			inx h
			mov m, d

			; set the speed according to a monster_id (KNIGHT_HORIZ_ID / KNIGHT_VERT_ID)
			; advance hl to monster_id
			HL_ADVANCE(monster_anim_ptr+1, monster_id, BY_BC)
			mov a, m
			cpi KNIGHT_VERT_ID
			jz @speed_vert
@speed_horiz:
			; advance hl to monster_speed_x
			HL_ADVANCE(monster_id, monster_speed_x, BY_BC)
			; dir positive if e == knight_run_r and vise versa
			mvi a, <knight_run_r
			cmp e
			lxi d, KNIGHT_DEFENCE_SPEED_NEG
			jnz @speed_x_neg
@speed_x_positive:
			lxi d, KNIGHT_DEFENCE_SPEED
@speed_x_neg:
			mov m, e
			inx h
			mov m, d
			; advance hl to monster_speed_y
			inx h
			A_TO_ZERO(NULL_BYTE)
			mov m, a
			inx h
			mov m, a
			ret
@speed_vert:
			; advance hl to monster_pos_y+1
			HL_ADVANCE(monster_id, monster_pos_y+1, BY_BC)
			lda hero_pos_y+1
			cmp m
			lxi d, KNIGHT_DEFENCE_SPEED_NEG
			jc @speed_y_neg
@speed_y_positive:
			lxi d, KNIGHT_DEFENCE_SPEED
@speed_y_neg:
			; advance hl to monster_speed_x
			inx h
			A_TO_ZERO(NULL_BYTE)
			mov m, a
			inx h
			mov m, a
			; advance hl to monster_speed_y
			inx h
			mov m, e
			inx h
			mov m, d
			ret

; in:
; hl - ptr to monster_status
knight_update_speedup:
			; hl = monster_status
			; advance hl to monster_status_timer
			inx h
			dcr m
			jnz @update_movement
			; defence time is over
 			; hl - ptr to monster_status_timer
			; advance hl to monster_status
			dcx h
			mvi m, KNIGHT_STATUS_DETECT_HERO_INIT
			ret

@update_movement:
			ACTOR_UPDATE_MOVEMENT_CHECK_TILE_COLLISION(monster_status_timer, monster_pos_x, KNIGHT_COLLISION_WIDTH, KNIGHT_COLLISION_HEIGHT, @collided_with_tiles)

			; hl points to monster_pos_y+1
			; advance hl to monster_anim_timer
			HL_ADVANCE(monster_pos_y+1, monster_anim_timer, BY_BC)
			mvi a, KNIGHT_ANIM_SPEED_DEFENCE
			jmp knight_update_anim_check_collision_hero

@collided_with_tiles:
			; hl points to monster_pos_x
			; advance hl to monster_status
			HL_ADVANCE(monster_pos_x, monster_status, BY_BC)
			mvi m, KNIGHT_STATUS_DEFENCE_INIT
			; hl points to monster_status
			; advance hl to monster_anim_timer
			HL_ADVANCE(monster_status, monster_anim_timer)
			mvi a, KNIGHT_ANIM_SPEED_DEFENCE
			jmp knight_update_anim_check_collision_hero			

; in:
; hl - ptr to monster_status
knight_update_move_init:
			; hl = monster_status
			mvi m, KNIGHT_STATUS_MOVE
			; advance hl to monster_status_timer

			; advance hl to monster_id
			HL_ADVANCE(monster_status, monster_id, BY_DE)
			mov a, m
			cpi KNIGHT_VERT_ID
			lxi b, (%10000000)<<8 ; tmp c = 0 
			jz @vertical_movement
			mvi b, %00000000
@vertical_movement:			
			xchg
			call random
			ani %01111111 ; to clear the last bit
			ora b
			; advance hl to monster_speed_x
			HL_ADVANCE(monster_id, monster_speed_x, BY_HL_FROM_D)

			cpi $40
			jc @speed_x_positive
			cpi $80
			jc @speed_x_negative
			cpi $c0
			jc @speed_y_positive
@speed_y_negative:
			mov m, c
			inx h
			mov m, c
			inx h
			mvi m, <KNIGHT_MOVE_SPEED_NEG
			inx h
			mvi m, >KNIGHT_MOVE_SPEED_NEG
			jmp @set_anim
@speed_y_positive:
			mov m, c
			inx h
			mov m, c
			inx h
			mvi m, <KNIGHT_MOVE_SPEED
			inx h
			mvi m, >KNIGHT_MOVE_SPEED
			jmp @set_anim
@speed_x_negative:
			mvi m, <KNIGHT_MOVE_SPEED_NEG
			inx h
			mvi m, >KNIGHT_MOVE_SPEED_NEG
			inx h
			mov m, c
			inx h
			mov m, c
			jmp @set_anim
@speed_x_positive:
			mvi m, <KNIGHT_MOVE_SPEED
			inx h
			mvi m, >KNIGHT_MOVE_SPEED
			inx h
			mov m, c
			inx h
			mov m, c
@set_anim:
			HL_ADVANCE(monster_speed_y+1, monster_anim_ptr, BY_BC)
			; a = rnd
			adi $40
			; if rnd is positive (up or right movement), then play knight_run_r anim
			jp @set_anim_run_r
@set_anim_run_l:
			mvi m, <knight_run_l
			inx h
			mvi m, >knight_run_l
			ret
@set_anim_run_r:
			mvi m, <knight_run_r
			inx h
			mvi m, >knight_run_r
            ret

; in:
; hl - ptr to monster_status
knight_update_move:
			; hl = monster_status
			; advance hl to monster_status_timer
			inx h
			dcr m
			jz @set_detect_hero_init
@update_movement:
			ACTOR_UPDATE_MOVEMENT_CHECK_TILE_COLLISION(monster_status_timer, monster_pos_x, KNIGHT_COLLISION_WIDTH, KNIGHT_COLLISION_HEIGHT, @set_move_init)

			; hl points to monster_pos_y+1
			; advance hl to monster_anim_timer
			HL_ADVANCE(monster_pos_y+1, monster_anim_timer, BY_BC)
			mvi a, KNIGHT_ANIM_SPEED_MOVE
			jmp knight_update_anim_check_collision_hero

@set_move_init:
			; hl points to monster_pos_x
			; advance hl to monster_status
			HL_ADVANCE(monster_pos_x, monster_status, BY_BC)
			mvi m, KNIGHT_STATUS_MOVE_INIT
			ret
@set_detect_hero_init:
 			; hl - ptr to monster_status_timer
			; advance hl to monster_status
			dcx h
			mvi m, KNIGHT_STATUS_DETECT_HERO_INIT
			ret


; in:
; hl - monster_anim_timer
; a - anim speed
; bc, de, hl, a
knight_update_anim_check_collision_hero:
			call actor_anim_update
			MONSTER_CHECK_COLLISION_HERO(KNIGHT_COLLISION_WIDTH, KNIGHT_COLLISION_HEIGHT, KNIGHT_DAMAGE)

; draw a sprite into a backbuffer
; in:
; de - ptr to monster_draw_ptr 
knight_draw:
			MONSTER_DRAW(sprite_get_scr_addr_knight, __RAM_DISK_S_KNIGHT)