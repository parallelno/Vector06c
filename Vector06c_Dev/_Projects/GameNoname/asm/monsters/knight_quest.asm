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
; a = TILEDATA_RESTORE_TILE
knight_quest_init:
			mov b, a ; temp
			; if ITEM_ID_FART is used, do not create a monster
			lda global_items + ITEM_ID_FART - 1	; because the first item_id = 1
			cpi ITEM_STATUS_USED
			jz @return

			mov a, b
			MONSTER_INIT(knight_quest_update, knight_draw, empty_func, KNIGHT_HEALTH, KNIGHT_STATUS_DETECT_HERO_INIT, knight_idle, False)
@return:
			mvi a, TILEDATA_RESTORE_TILE
			ret			

;========================================================
; anim and a gameplay logic update
; in:
; de - ptr to monster_update_ptr in the runtime data
knight_quest_update:
			; check if the hero has ITEM_ID_FART
			lda global_items + ITEM_ID_FART - 1	; because the first item_id = 1
			cpi ITEM_STATUS_ACQUIRED
			jc knight_quest_update_statuses ; ITEM_ID_FART is not acquired
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
			jmp knight_quest_update_statuses

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
			ACTOR_DESTROY()
			ret

knight_quest_update_statuses:
			; advance hl to monster_status
			LXI_H_TO_DIFF(monster_update_ptr, monster_status)
			dad d
			mov a, m
			; TODO: optimization. think of using a call table
			cpi KNIGHT_STATUS_MOVE
			jz knight_update_move
			cpi KNIGHT_STATUS_DETECT_HERO
			jz knight_update_detect_hero
			cpi KNIGHT_STATUS_DEFENCE
			jz knight_update_speedup
			cpi KNIGHT_STATUS_MOVE_INIT
			jz knight_update_move_init
			cpi KNIGHT_STATUS_DEFENCE_INIT
			jz knight_quest_update_defence_init
			cpi KNIGHT_STATUS_DETECT_HERO_INIT
			jz knight_update_detect_hero_init
			cpi MONSTER_STATUS_FREEZE
			jz monster_update_freeze
			ret

knight_quest_update_defence_init:
			; hl - ptr to monster_status
			mvi m, KNIGHT_STATUS_DEFENCE
			; advance hl to monster_status_timer
			inx h
			mvi m, KNIGHT_STATUS_DEFENCE_TIME
@check_anim_dir:
			; aim the monster to the hero dir
			; advance hl to monster_pos_x+1
			HL_ADVANCE_BY_DIFF_BC(monster_status_timer, monster_pos_x+1)
			lda hero_pos_x+1
			cmp m
			lxi d, knight_defence_l
			jc @dir_x_neg
@dir_x_positive:
			lxi d, knight_defence_r
@dir_x_neg:
			; advance hl to monster_anim_ptr
			HL_ADVANCE_BY_DIFF_BC(monster_pos_x+1, monster_anim_ptr)
			mov m, e
			inx h
			mov m, d

			; set the speed according to a monster_id (KNIGHT_HORIZ_ID / KNIGHT_VERT_ID)
			; advance hl to monster_id
			HL_ADVANCE_BY_DIFF_BC(monster_anim_ptr+1, monster_id)
			mov a, m
			cpi KNIGHT_VERT_ID
			jz @speed_vert
@speed_horiz:
			; advance hl to monster_speed_x
			HL_ADVANCE_BY_DIFF_BC(monster_id, monster_speed_x)
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
			HL_ADVANCE_BY_DIFF_BC(monster_id, monster_pos_y+1)
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