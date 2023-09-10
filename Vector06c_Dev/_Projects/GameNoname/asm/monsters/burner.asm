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
;		if distance(mob, hero) < a dashing radius:
;			status = dash_prep
;			status_timer = dashPrepTime
;			anim to the hero dir
;		else:
;			update_anim
;			check mod-hero collision, impact if collides
; dash_prep:
;	decr status_timer
;	if status_timer == 0:
;		status = dash
;		anim = run
;		speed directly to the hero pos
;	else:
;		update_anim
;		check mod-hero collision, impact if collides
; dash:
;	decr status_timer
;	if status_timer == 0:
;		status = relax
;		status_timer = relax_time
;	else:
;		move a mob
;		update_anim
;		check mod-hero collision, impact if collides
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

BURNER_QUEST_SPEED		= $0200
; TODO: issue. BURNER_QUEST_SPEED constant does not affect the speed
BURNER_QUEST_MAX_POS_X	= 255 - 16
BURNER_QUEST_MAX_POS_Y	= 255 - 16 - 14

BURNER_QUEST_STATUS_ROOM_6	= 0
BURNER_QUEST_STATUS_ROOM_9	= 1
BURNER_QUEST_STATUS_ROOM_5	= 2
BURNER_QUEST_STATUS_ROOM_10	= 3

BURNER_QUEST_ROOM_IDS_END = $ff

burner_quest_room_ids:
			.byte ROOM_ID_6, ROOM_ID_9, ROOM_ID_5, ROOM_ID_10, BURNER_QUEST_ROOM_IDS_END
burner_quest_room_ids_end:
burner_quest_room_ids_len: = burner_quest_room_ids_end - burner_quest_room_ids

BURNER_DETECT_HERO_DISTANCE = 60

;========================================================
; called to spawn this monster
; in:
; c - tile_idx in the room_tiledata array.
; a - monster_id * 4
; out:
; a = 0
burner_init:
			; check a monster_id
			; if it is a BURNER_RIGHT_ID or BURNER_UP_ID, do an additional logic
			mvi b, BURNER_ID * 4
			cmp b
			jz @init ; if it is a BURNER_ID go init it, then return

			mov b, a ; temp

			; item_id_burner contains an index for burner_quest_room_ids array.
			; That array contains room_ids in a proper sequence where a player will see it.
			; when a burner shows up in a room, item_id_burner offsets to the next room_id
			lda global_items + ITEM_ID_BURNER_QUEST - 1; because the first item_id = 1
			HL_TO_A_PLUS_INT16(burner_quest_room_ids)
			lda room_id
			cmp m
			rnz ; if it is not dedicated room for a burner_quest

			; it is a dedicated room,
			; advance the index to the next dedicated room in a sequence
			lxi h, global_items + ITEM_ID_BURNER_QUEST - 1; because the first item_id = 1
			inr m

			mov a, b
			; a - monster_id * 4
			call @init

			; hl - ptr to monster_pos_y + 1
			; advance hl to monster_anim_ptr
			; set run_r anim
			HL_ADVANCE_BY_DIFF_B(monster_anim_ptr, monster_pos_y + 1)
			mvi m, <burner_dash
			inx h
			mvi m, >burner_dash

			; advance hl to monster_update_ptr
			HL_ADVANCE_BY_DIFF_B(monster_update_ptr, monster_anim_ptr + 1)
			mvi m, <burner_quest_update
			inx h
			mvi m, >burner_quest_update	

			; return TILEDATA_NO_COLLISION to make the tile walkable where a monster spawned
			A_TO_ZERO(TILEDATA_NO_COLLISION)
			ret
@init:
			MONSTER_INIT(burner_update, burner_draw, monster_impacted, BURNER_HEALTH, BURNER_STATUS_DETECT_HERO_INIT, burner_idle)

; update for BURNER_RIGHT_ID or BURNER_UP_ID
; anim and a gameplay logic update
; in:
; de - ptr to monster_update_ptr in the runtime data
burner_quest_update:
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

; uppdate for BURNER_ID
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
			HL_ADVANCE_BY_DIFF_B(monster_anim_ptr, monster_status_timer)
			mvi m, <burner_idle
			inx h
			mvi m, >burner_idle
			ret

burner_update_detect_hero:
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
			cpi BURNER_DETECT_HERO_DISTANCE
			jc @check_pos_y_diff
			jmp @update_anim_hero_detect_x
@check_neg_pos_x_diff:
			cpi -BURNER_DETECT_HERO_DISTANCE
			jnc @check_pos_y_diff
			jmp @update_anim_hero_detect_x
@check_pos_y_diff:
			; advance hl to monster_pos_y+1
			INX_H(2)
			; check hero-monster posY diff
			lda hero_pos_y+1
			sub m
			jc @check_neg_pos_y_diff
			cpi BURNER_DETECT_HERO_DISTANCE
			jc @hero_detected
			jmp @update_anim_hero_detect_y
@check_neg_pos_y_diff:
			cpi -BURNER_DETECT_HERO_DISTANCE
			jnc @hero_detected
			jmp @update_anim_hero_detect_y
@hero_detected:
			; hl = monster_pos_y+1
			; advance hl to monster_status
			HL_ADVANCE_BY_DIFF_B(monster_status, monster_pos_y+1)
			mvi m, BURNER_STATUS_DASH_PREP
			inx h
			mvi m, BURNER_STATUS_DASH_PREP_TIME
			; advance hl to monster_anim_ptr
			HL_ADVANCE_BY_DIFF_B(monster_anim_ptr, monster_status_timer)
			mvi m, <burner_dash
			inx h
			mvi m, >burner_dash
			ret
			
@update_anim_hero_detect_x:
			; advance hl to monster_anim_timer
			HL_ADVANCE_BY_DIFF_B(monster_anim_timer, monster_pos_x+1)
			mvi a, BURNER_ANIM_SPEED_DETECT_HERO
			jmp burner_update_anim_check_collision_hero
@update_anim_hero_detect_y:
			; advance hl to monster_anim_timer
			HL_ADVANCE_BY_DIFF_B(monster_anim_timer, monster_pos_y+1)
			mvi a, BURNER_ANIM_SPEED_DETECT_HERO
			jmp burner_update_anim_check_collision_hero

@set_move_init:
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
			mvi m, <BURNER_MOVE_SPEED_NEG
			inx h
			mvi m, >BURNER_MOVE_SPEED_NEG
			jmp @set_anim
@speed_y_positive:
			mov m, c
			inx h
			mov m, c
			inx h
			mvi m, <BURNER_MOVE_SPEED
			inx h
			mvi m, >BURNER_MOVE_SPEED
			jmp @set_anim
@speed_x_negative:
			mvi m, <BURNER_MOVE_SPEED_NEG
			inx h
			mvi m, >BURNER_MOVE_SPEED_NEG
			inx h
			mov m, c
			inx h
			mov m, c
			jmp @set_anim
@speed_x_positive:
			mvi m, <BURNER_MOVE_SPEED
			inx h
			mvi m, >BURNER_MOVE_SPEED
			inx h
			mov m, c
			inx h
			mov m, c
@set_anim:
			HL_ADVANCE_BY_DIFF_B(monster_anim_ptr, monster_speed_y+1)
			; a = rnd
			ora a
			; if rnd is positive (up or right movement), then play burner_run_r anim
			jp @set_anim_run_r
@set_anim_run_l:
			mvi m, <burner_run_l
			inx h
			mvi m, >burner_run_l
			ret
@set_anim_run_r:
			mvi m, <burner_run_r
			inx h
			mvi m, >burner_run_r
            ret

burner_update_move:
			; hl = monster_status
			; advance hl to monster_status_timer
			inx h
			dcr m
			jz @set_detect_hero_init
@update_movement:
			ACTOR_UPDATE_MOVEMENT_CHECK_TILE_COLLISION(monster_status_timer, monster_pos_x, BURNER_COLLISION_WIDTH, BURNER_COLLISION_HEIGHT, @set_move_init) 
			
			; hl points to monster_pos_y+1
			; advance hl to monster_anim_timer
			HL_ADVANCE_BY_DIFF_B(monster_anim_timer, monster_pos_y+1)
			mvi a, BURNER_ANIM_SPEED_MOVE
			jmp burner_update_anim_check_collision_hero

@set_move_init:
			pop h
			; hl points to monster_pos_x
			; advance hl to monster_status
			HL_ADVANCE_BY_DIFF_B(monster_status, monster_pos_x)
			mvi m, BURNER_STATUS_MOVE_INIT
			inx h
			mvi m, BURNER_STATUS_MOVE_TIME
			ret
@set_detect_hero_init:
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
			jz @set_move_init
			; advance hl to monster_anim_timer
			HL_ADVANCE_BY_DIFF_B(monster_anim_timer, monster_status_timer)
			mvi a, BURNER_ANIM_SPEED_RELAX
			jmp burner_update_anim_check_collision_hero
 @set_move_init:
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
			jz @set_dash
			; advance hl to monster_anim_timer
			HL_ADVANCE_BY_DIFF_B(monster_anim_timer, monster_status_timer)
			mvi a, BURNER_ANIM_SPEED_DASH_PREP
			jmp burner_update_anim_check_collision_hero
 @set_dash:
  			; hl - ptr to monster_status_timer
			mvi m, BURNER_STATUS_DASH_TIME
			; advance hl to monster_status
			dcx h
			mvi m, BURNER_STATUS_DASH
			; advance hl to monster_pos_x
			HL_ADVANCE_BY_DIFF_B(monster_pos_x, monster_status)
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
			jm @set_move_init
@apply_movement:
			ACTOR_UPDATE_MOVEMENT(monster_status_timer, monster_speed_y)
			; advance hl to monster_anim_timer
			HL_ADVANCE_BY_DIFF_B(monster_anim_timer, monster_pos_x+1)
			mvi a, BURNER_ANIM_SPEED_DASH
			jmp actor_anim_update
@set_move_init:
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