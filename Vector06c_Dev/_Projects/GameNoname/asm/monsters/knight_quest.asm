; this is a quest mod identical to knight, but with different behavior
; it spawns only if the quest was not complite
; it runs away if a hero with fart nearby

KNIGHT_QUEST_DETECT_HERO_DISTANCE	= 60
KNIGHT_QUEST_SPEED					= $0400
KNIGHT_QUEST_MAX_POS_Y				= 255 - 16 - 14

;========================================================
; spawn and init a monster
; in:
; c - tile_idx in the room_tiledata array.
; a - monster_id * 4
; out:
; a = 0
knight_quest_init:
			mov b, a ; temp
			; if ITEM_ID_FART is used, do not create a monster
			lda global_items + ITEM_ID_FART - 1	; because the first item_id = 1
			cpi ITEM_STATUS_USED
			rz

			mov a, b
			MONSTER_INIT(knight_quest_update, knight_draw, empty_func, KNIGHT_HEALTH, KNIGHT_STATUS_DETECT_HERO_INIT, knight_idle, False)

;========================================================
; anim and a gameplay logic update
; in:
; de - ptr to monster_update_ptr in the runtime data
knight_quest_update:
			; check if the hero has ITEM_ID_FART
			lda global_items + ITEM_ID_FART - 1	; because the first item_id = 1
			cpi ITEM_STATUS_ACQUIRED
			jc knight_update ; ITEM_ID_FART is not acquired
			jnz @run_up ; ITEM_ID_FART is used

			push d
			; check hero to monster distance
@check_mob_hero_distance:
			; advance hl to monster_pos_x+1
			LXI_H_TO_DIFF(monster_update_ptr, monster_pos_x+1)
			dad d
			; check hero-monster pos_x diff
			lda hero_pos_x+1
			sub m
			jc @check_neg_pos_x_diff
			cpi KNIGHT_QUEST_DETECT_HERO_DISTANCE
			jc @check_pos_y_diff
			jmp @hero_no_detected
@check_neg_pos_x_diff:
			cpi -KNIGHT_QUEST_DETECT_HERO_DISTANCE
			jnc @check_pos_y_diff
			jmp @hero_no_detected
@check_pos_y_diff:
			; advance hl to monster_pos_y+1
			INX_H(2)
			; check hero-monster pos_y diff
			lda hero_pos_y+1
			sub m
			jc @check_neg_pos_y_diff
			cpi KNIGHT_QUEST_DETECT_HERO_DISTANCE
			jc @hero_detected
			jmp @hero_no_detected
@check_neg_pos_y_diff:
			cpi -KNIGHT_QUEST_DETECT_HERO_DISTANCE
			jnc @hero_detected
			jmp @hero_no_detected
@hero_detected:
			; mob is about to run up
			; set the status of ITEM_ID_FART used
			mvi a, ITEM_STATUS_USED
			sta global_items + ITEM_ID_FART - 1	; because the first item_id = 1
@hero_no_detected:
			pop d
			; d - monster_update_ptr
			jmp knight_update

@run_up:
			; de - ptr to monster_update_ptr
			push d
			; this monster goes up to the edge of the screen, then dies
			; advance hl to monster_speed_y + 1
			LXI_H_TO_DIFF(monster_update_ptr, monster_pos_y + 1)
			dad d

			; hl - ptr to monster_pos_y + 1
			; increase pos_y
			mov a, m
			adi >KNIGHT_QUEST_SPEED
			mov m, a

			; advance hl to monster_update_ptr
			pop h

			; check if a knight hits the screen border
			cpi KNIGHT_QUEST_MAX_POS_Y
			jnc @death
			; hl points to monster_update_ptr
			; advance hl to monster_anim_timer
			HL_ADVANCE_BY_DIFF_BC(monster_update_ptr, monster_anim_timer)

			mvi a, BURNER_ANIM_SPEED_MOVE
			jmp knight_update_anim_check_collision_hero
@death:
			; hl points to monster_update_ptr
			; advance hl to monster_update_ptr + 1
			inx h
			; mark this monster dead death
			jmp actor_destroy
