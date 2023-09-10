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
KNIGHT_STATUS_DETECT_HERO_INIT	= 0
KNIGHT_STATUS_DETECT_HERO		= 1
KNIGHT_STATUS_DEFENCE_INIT		= 2
KNIGHT_STATUS_DEFENCE			= 3
KNIGHT_STATUS_MOVE_INIT			= 4
KNIGHT_STATUS_MOVE				= 5

; status duration in updates.
KNIGHT_STATUS_DETECT_HERO_TIME	= 100
KNIGHT_STATUS_DEFENCE_TIME		= 30
KNIGHT_STATUS_MOVE_TIME			= 50

; animation speed (the less the slower, 0-255, 255 means the next frame is almost every update)
KNIGHT_ANIM_SPEED_DETECT_HERO	= 10
KNIGHT_ANIM_SPEED_DEFENCE		= 100
KNIGHT_ANIM_SPEED_MOVE			= 50

; gameplay
KNIGHT_DAMAGE = 1
KNIGHT_HEALTH = 1

KNIGHT_COLLISION_WIDTH	= 15
KNIGHT_COLLISION_HEIGHT	= 10

KNIGHT_MOVE_SPEED		= $0060
KNIGHT_MOVE_SPEED_NEG	= $ffff - $60 + 1

KNIGHT_DEFENCE_SPEED		= $0100
KNIGHT_DEFENCE_SPEED_NEG	= $ffff - $100 + 1

KNIGHT_DETECT_HERO_DISTANCE = 60

;========================================================
; called to spawn this monster
; in:
; c - tile_idx in the room_tiledata array.
; a - monster_id * 4
; out:
; a = 0
knight_init:

/*
			; check a monster_id
			; if it is a KNIGHT_QUEST_ID do an additional logic
			mvi b, KNIGHT_ID * 4
			cmp b
			jz @init ; if it is a KNIGHT_ID go init it, then return

			mov b, a ; temp

			; when a hero grad more than aome amount of cabbages,
			; he gets a special item item_id_fart and a weapon that looks like
			; farting that lasts some time. when a hero comes over the 
			; a monster with a monster_id = KNIGHT_QUEST_ID a monster runs 
			; away to the right size of the screen.
			
			; check if a hero has item_id_fart
			lda global_items + ITEM_ID_KNIGHT_QUEST - 1; because the first item_id = 1
			cpi ITEM_STATUS_USED
			rz ; return if item_id_fart was used

			mov a, b
			; a - monster_id * 4
			call @init

			; hl - ptr to monster_pos_y + 1
			; advance hl to monster_anim_ptr
			; set run_r anim
			HL_ADVANCE_BY_DIFF_B(monster_anim_ptr, monster_pos_y + 1)
			mvi m, <knight_defence_r
			inx h
			mvi m, >knight_defence_r

			; advance hl to monster_update_ptr
			HL_ADVANCE_BY_DIFF_B(monster_update_ptr, monster_anim_ptr + 1)
			mvi m, <knight_quest_update
			inx h
			mvi m, >knight_quest_update

			; return TILEDATA_NO_COLLISION to make the tile walkable where a monster spawned
			A_TO_ZERO(TILEDATA_NO_COLLISION)
			ret
@init:
*/
			MONSTER_INIT(knight_update, knight_draw, monster_impacted, KNIGHT_HEALTH, KNIGHT_STATUS_DETECT_HERO_INIT, knight_idle)
			;ret

/*
; update for KNIGHT_QUEST_ID
; anim and a gameplay logic update
; in:
; de - ptr to monster_update_ptr in the runtime data
knight_quest_update:
			; store de
			push d
			; advance hl to monster_id
			LXI_H_TO_DIFF(monster_id, monster_update_ptr)
			dad d
			; check what burner it is
			mov a, m
			cpi BURNER_RIGHT_ID
			jz @burner_right
@burner_up:			
			; advance hl to monster_speed_y + 1
			HL_ADVANCE_BY_DIFF_B(monster_pos_y + 1, monster_id)
			; hl - ptr to monster_pos_y + 1
			; increase pos_y
			mov a, m
			adi >BURNER_QUEST_SPEED
			mov m, a

			; advance hl to monster_update_ptr
			pop h

			; check if a burner hits the screen border
			cpi BURNER_QUEST_MAX_POS_Y
			jnc @death
			jmp @update_anim

@burner_right:
			; advance hl to monster_pos_x + 1
			HL_ADVANCE_BY_DIFF_B(monster_pos_x + 1, monster_id)
			; hl - ptr to monster_pos_x + 1
			; increase pos_x
			mov a, m
			adi >BURNER_QUEST_SPEED
			mov m, a

			; advance hl to monster_update_ptr
			pop h

			; check if a burner hits the screen border
			cpi BURNER_QUEST_MAX_POS_X
			jnc @death
@update_anim:
			; hl points to monster_update_ptr
			; advance hl to monster_anim_timer
			HL_ADVANCE_BY_DIFF_B(monster_anim_timer, monster_update_ptr)

			mvi a, BURNER_ANIM_SPEED_MOVE
			jmp burner_update_anim_check_collision_hero
@death:
			; hl points to monster_update_ptr
			; advance hl to monster_update_ptr + 1
			inx h
			; mark this monster dead death
			jmp actor_destroy
*/
; update for BURNER_ID
; anim and a gameplay logic update
; in:
; de - ptr to monster_update_ptr in the runtime data
knight_update:
			; advance hl to monster_status
			LXI_H_TO_DIFF(monster_status, monster_update_ptr)
			dad d
			mov a, m
			; TODO: optimization. think of using a call table
			cpi KNIGHT_STATUS_MOVE
			jz knight_update_move
			cpi KNIGHT_STATUS_DETECT_HERO
			jz knight_update_detect_hero
			cpi KNIGHT_STATUS_DEFENCE
			jz knight_update_defence			
			cpi KNIGHT_STATUS_MOVE_INIT
			jz knight_update_move_init
			cpi KNIGHT_STATUS_DEFENCE_INIT
			jz knight_update_defence_init
			cpi KNIGHT_STATUS_DETECT_HERO_INIT
			jz knight_update_detect_hero_init
			ret

knight_update_detect_hero_init:
			; hl = monster_status
			mvi m, KNIGHT_STATUS_DETECT_HERO
			inx h
			mvi m, KNIGHT_STATUS_DETECT_HERO_TIME
			HL_ADVANCE_BY_DIFF_B(monster_anim_ptr, monster_status_timer)
			mvi m, <knight_idle
			inx h
			mvi m, >knight_idle
			ret

knight_update_detect_hero:
			; hl = monster_status
			; advance hl to monster_status_timer
			inx h
			dcr m
			jz @set_move_init
@check_mob_hero_distance:
			; advance hl to monster_pos_x+1
			HL_ADVANCE_BY_DIFF_B(monster_pos_x+1, monster_status_timer)
			; check hero-monster posX diff
			lda hero_pos_x+1
			sub m
			jc @check_neg_pos_x_diff
			cpi KNIGHT_DETECT_HERO_DISTANCE
			jc @check_pos_y_diff
			jmp @update_anim_hero_detect_x
@check_neg_pos_x_diff:
			cpi -KNIGHT_DETECT_HERO_DISTANCE
			jnc @check_pos_y_diff
			jmp @update_anim_hero_detect_x
@check_pos_y_diff:
			; advance hl to monster_pos_y+1
			INX_H(2)
			; check hero-monster posY diff
			lda hero_pos_y+1
			sub m
			jc @check_neg_pos_y_diff
			cpi KNIGHT_DETECT_HERO_DISTANCE
			jc @hero_detected
			jmp @update_anim_hero_detect_y
@check_neg_pos_y_diff:
			cpi -KNIGHT_DETECT_HERO_DISTANCE
			jnc @hero_detected
			jmp @update_anim_hero_detect_y
@hero_detected:
			; hl = monster_pos_y+1
			; advance hl to monster_status
			HL_ADVANCE_BY_DIFF_B(monster_status, monster_pos_y+1)
			mvi m, KNIGHT_STATUS_DEFENCE_INIT
			ret
			
@update_anim_hero_detect_x:
			; advance hl to monster_anim_timer
			HL_ADVANCE_BY_DIFF_B(monster_anim_timer, monster_pos_x+1)
			mvi a, KNIGHT_ANIM_SPEED_DETECT_HERO
			jmp knight_update_anim_check_collision_hero
@update_anim_hero_detect_y:
			; advance hl to monster_anim_timer
			HL_ADVANCE_BY_DIFF_B(monster_anim_timer, monster_pos_y+1)
			mvi a, KNIGHT_ANIM_SPEED_DETECT_HERO
			jmp knight_update_anim_check_collision_hero

@set_move_init:
 			; hl - ptr to monster_status_timer
			mvi m, KNIGHT_STATUS_MOVE_TIME ; TODO: use a rnd number instead of a const
			; advance hl to monster_status
			dcx h
			mvi m, KNIGHT_STATUS_MOVE_INIT
			ret

knight_update_defence_init:
			; hl - ptr to monster_status
			mvi m, KNIGHT_STATUS_DEFENCE
			; advance hl to monster_status_timer
			inx h
			mvi m, KNIGHT_STATUS_DEFENCE_TIME
@check_anim_dir:
			; aim the monster to the hero dir
			; advance hl to monster_pos_x+1
			HL_ADVANCE_BY_DIFF_B(monster_pos_x+1, monster_status_timer)
			lda hero_pos_x+1
			cmp m
			lxi d, knight_defence_l
			jc @dir_x_neg
@dir_x_positive:			
			lxi d, knight_defence_r
@dir_x_neg:
			; advance hl to monster_anim_ptr
			HL_ADVANCE_BY_DIFF_B(monster_anim_ptr, monster_pos_x+1)
			mov m, e
			inx h
			mov m, d

			; set the speed according to a monster_id (KNIGHT_HORIZ_ID / KNIGHT_VERT_ID)
			; advance hl to monster_id
			HL_ADVANCE_BY_DIFF_B(monster_id, monster_anim_ptr+1)
			mov a, m		
			cpi <KNIGHT_HORIZ_ID
			jnz @speed_vert
@speed_horiz:
			; advance hl to monster_speed_x
			HL_ADVANCE_BY_DIFF_B(monster_speed_x, monster_id)
			; dir positive if e == knight_defence_r and vise versa
			mvi a, <knight_defence_r
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
			HL_ADVANCE_BY_DIFF_B(monster_pos_y+1, monster_id)
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

knight_update_defence:
			; hl = monster_status
			; advance hl to monster_status_timer
			inx h
			dcr m
			jz @set_detect_hero_init
@update_movement:
			ACTOR_UPDATE_MOVEMENT_CHECK_TILE_COLLISION(monster_status_timer, monster_pos_x, KNIGHT_COLLISION_WIDTH, KNIGHT_COLLISION_HEIGHT, @collided_with_tiles) 
			
			; hl points to monster_pos_y+1
			; advance hl to monster_anim_timer
			HL_ADVANCE_BY_DIFF_B(monster_anim_timer, monster_pos_y+1)
			mvi a, KNIGHT_ANIM_SPEED_DEFENCE
			jmp knight_update_anim_check_collision_hero

@collided_with_tiles:
			pop h
			; hl points to monster_pos_x
			; advance hl to monster_status
			HL_ADVANCE_BY_DIFF_B(monster_status, monster_pos_x)
			mvi m, KNIGHT_STATUS_DEFENCE_INIT
			ret
@set_detect_hero_init:
 			; hl - ptr to monster_status_timer
			mvi m, KNIGHT_STATUS_DETECT_HERO_TIME ; TODO: seems unnecessary code
			; advance hl to monster_status
			dcx h
			mvi m, KNIGHT_STATUS_DETECT_HERO_INIT
			ret	

knight_update_move_init:
			; hl = monster_status
			mvi m, KNIGHT_STATUS_MOVE
			; advance hl to monster_status_timer

			; advance hl to monster_speed_x
			LXI_D_TO_DIFF(monster_id, monster_status)
			dad d
			mov a, m
			cpi <KNIGHT_HORIZ_ID
			lxi b, (%10000000)<<8 ; tmp c = 0 
			jnz @vertical_movement
			mvi b, %00000000
@vertical_movement:			
			xchg
			call random
			ani %01111111 ; to clear the last bit
			ora b
			; advance hl to monster_speed_x
			LXI_H_TO_DIFF(monster_speed_x, monster_id)
			dad d

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
			HL_ADVANCE_BY_DIFF_B(monster_anim_ptr, monster_speed_y+1)
			; a = rnd
			;ora a
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
			HL_ADVANCE_BY_DIFF_B(monster_anim_timer, monster_pos_y+1)
			mvi a, KNIGHT_ANIM_SPEED_MOVE
			jmp knight_update_anim_check_collision_hero

@set_move_init:
			pop h
			; hl points to monster_pos_x
			; advance hl to monster_status
			HL_ADVANCE_BY_DIFF_B(monster_status, monster_pos_x)
			mvi m, KNIGHT_STATUS_MOVE_INIT
			ret
@set_detect_hero_init:
 			; hl - ptr to monster_status_timer
			mvi m, KNIGHT_STATUS_DETECT_HERO_TIME ; TODO: seems unnecessary code
			; advance hl to monster_status
			dcx h
			mvi m, KNIGHT_STATUS_DETECT_HERO_INIT
			ret


; in:
; hl - monster_anim_timer
; a - anim speed
knight_update_anim_check_collision_hero:
			call actor_anim_update
			MONSTER_CHECK_COLLISION_HERO(KNIGHT_COLLISION_WIDTH, KNIGHT_COLLISION_HEIGHT, KNIGHT_DAMAGE)


; draw a sprite into a backbuffer
; in:
; de - ptr to monster_draw_ptr in the runtime data
knight_draw:
			MONSTER_DRAW(sprite_get_scr_addr_knight, __RAM_DISK_S_KNIGHT)