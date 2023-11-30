; this is a quest mod identical to burner, but with different behavior
; it is spawned once for every screen where its spawner
; it runs only up until the top edge of the screen


BURNER_QUEST_SPEED		= $0200
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

;========================================================
; spawn and init a monster
; in:
; c - tile_idx in the room_tiledata array.
; a - monster_id * 4
; out:
; a = TILEDATA_RESTORE_TILE
burner_quest_init:
			mov b, a ; temp

			; item_id_burner contains an index for burner_quest_room_ids array.
			; That array contains room_ids in a proper sequence where a player will see it.
			; when a burner shows up in a room, item_id_burner offsets to the next room_id
			lda global_items + ITEM_ID_BURNER_QUEST - 1; because the first item_id = 1
			HL_TO_A_PLUS_INT16(burner_quest_room_ids)
			lda room_id
			cmp m
			jnz @return; if it is not dedicated room for a burner_quest

			; it is a dedicated room,
			; advance the index to the next dedicated room in a sequence
			lxi h, global_items + ITEM_ID_BURNER_QUEST - 1; because the first item_id = 1
			inr m

			mov a, b
			MONSTER_INIT(burner_quest_update, burner_draw, empty_func, BURNER_HEALTH, BURNER_STATUS_DETECT_HERO_INIT, burner_dash)
@return:
			mvi a, TILEDATA_RESTORE_TILE
			ret
;========================================================
; anim and a gameplay logic update
; in:
; de - ptr to monster_update_ptr in the runtime data
burner_quest_update:
			; store de
			push d
			; advance hl to monster_id
			LXI_H_TO_DIFF(monster_update_ptr, monster_id)
			dad d
			; check what burner it is
			mov a, m
			cpi BURNER_RIGHT_ID
			jz @burner_right
@burner_up:			
			; advance hl to monster_speed_y + 1
			HL_ADVANCE_BY_DIFF_BC(monster_id, monster_pos_y + 1)
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
			HL_ADVANCE_BY_DIFF_BC(monster_id, monster_pos_x + 1)
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
			HL_ADVANCE_BY_DIFF_BC(monster_update_ptr, monster_anim_timer)

			mvi a, BURNER_ANIM_SPEED_MOVE
			jmp burner_update_anim_check_collision_hero
@death:
			; hl points to monster_update_ptr
			; advance hl to monster_update_ptr + 1
			inx h
			; mark this monster dead death
			ACTOR_DESTROY()
			ret
