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
knight_heavy_init:
			MONSTER_INIT( knight_heavy_update, knight_draw, empty_func, KNIGHT_HEALTH, KNIGHT_STATUS_DETECT_HERO_INIT, knight_idle, False)
@return:
			mvi a, TILEDATA_RESTORE_TILE
			ret			

;========================================================
; anim and a gameplay logic update
; in:
; de - ptr to monster_update_ptr 
knight_heavy_update:
			push d
			call knight_heavy_check_panic
			pop h
			; hl - ptr to monster_update_ptr

			; advance hl to monster_status
			HL_ADVANCE(monster_update_ptr, monster_status, REG_DE)
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
			jz knight_heavy_update_defence_init
			cpi KNIGHT_STATUS_DETECT_HERO_INIT
			jz knight_update_detect_hero_init
			cpi KNIGHT_STATUS_PANIC
			jz knight_update_panic
			cpi MONSTER_STATUS_FREEZE
			jz monster_update_freeze
			ret

; checks if a hero has game_status_fart acquired,
; if so, check the distance to him,
; if so, panic!
; in:
; de - ptr to monster_update_ptr 
; uses:
; de, a
knight_heavy_check_panic:
			xchg
			shld @restore_hl+1
			; check if the hero has game_status_fart
			lda game_status_fart
			CPI_WITH_ZERO(GAME_STATUS_NOT_ACQUIRED)
			rz
			; hl - ptr to monster_update_ptr
			
			; check a hero-to-monster distance
			; advance hl to monster_pos_x+1
			HL_ADVANCE(monster_update_ptr, monster_pos_x+1, REG_DE)
			; hl - ptr to monster_pos_x+1
			mvi c, KNIGHT_QUEST_DETECT_HERO_DISTANCE
			call actor_to_hero_distance
			rnc ; return if it's too distanced
			
			; set the panic state
@restore_hl:
			lxi h, TEMP_ADDR
			; hl - ptr to monster_update_ptr
			; advance hl to monster_status
			HL_ADVANCE(monster_update_ptr, monster_status, REG_DE)
			mvi m, KNIGHT_STATUS_PANIC
			ret

; in:
; hl - ptr to monster_status
knight_update_panic:
			; this monster goes up to the edge of the screen, then dies
			; advance hl to monster_speed_y + 1
			HL_ADVANCE(monster_status, monster_pos_y + 1, REG_DE)
			; hl - ptr to monster_pos_y + 1

			; increase pos_y
			mov a, m
			adi >KNIGHT_QUEST_SPEED
			mov m, a

			; check if a knight hits the screen border
			cpi KNIGHT_QUEST_MAX_POS_Y
			jnc @death
			; hl points to monster_pos_y + 1
			; advance hl to monster_anim_timer
			HL_ADVANCE(monster_pos_y + 1, monster_anim_timer, REG_BC)
			mvi a, BURNER_ANIM_SPEED_MOVE
			jmp knight_update_anim_check_collision_hero
@death:
			; hl points to monster_pos_y + 1
			; advance hl to monster_update_ptr + 1
			HL_ADVANCE(monster_pos_y + 1, monster_update_ptr + 1, REG_DE)
			; mark this monster dead death
			ACTOR_DESTROY()
			ret

; in:
; hl - ptr to monster_status
knight_heavy_update_defence_init:
			mvi m, KNIGHT_STATUS_DEFENCE
			; advance hl to monster_status_timer
			inx h
			mvi m, KNIGHT_STATUS_DEFENCE_TIME
@check_anim_dir:
			; aim the monster to the hero dir
			; advance hl to monster_pos_x+1
			HL_ADVANCE(monster_status_timer, monster_pos_x+1, REG_BC)
			lda hero_pos_x+1
			cmp m
			lxi d, knight_defence_l
			jc @dir_x_neg
@dir_x_positive:
			lxi d, knight_defence_r
@dir_x_neg:
			; advance hl to monster_anim_ptr
			HL_ADVANCE(monster_pos_x+1, monster_anim_ptr, REG_BC)
			mov m, e
			inx h
			mov m, d

			; set the speed according to a monster_id (KNIGHT_HORIZ_ID / KNIGHT_VERT_ID)
			; advance hl to monster_id
			HL_ADVANCE(monster_anim_ptr+1, monster_id, REG_BC)
			mov a, m
			cpi KNIGHT_VERT_ID
			jz @speed_vert
@speed_horiz:
			; advance hl to monster_speed_x
			HL_ADVANCE(monster_id, monster_speed_x, REG_BC)
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
			HL_ADVANCE(monster_id, monster_pos_y+1, REG_BC)
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