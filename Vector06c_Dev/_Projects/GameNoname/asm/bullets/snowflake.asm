; statuses.
; a status describes what set of animations and behavior is active
; for ex. HERO_STATUS_ATTACK plays hero_attk_r or hero_attk_l depending on the direction and it spawns a weapon trail
SNOWFLAKE_STATUS_ATTACK = 0

; duration of statuses (in update_durations)
SNOWFLAKE_STATUS_INVIS_TIME		= 6
SNOWFLAKE_STATUS_ATTACK_TIME	= 35

; animation speed (the less the slower, 0-255, 255 means next frame every update)
SNOWFLAKE_ANIM_SPEED_ATTACK	= 90

; gameplay
SNOWFLAKE_DAMAGE = 1
SNOWFLAKE_COLLISION_WIDTH	= 12
SNOWFLAKE_COLLISION_HEIGHT	= 12

SNOWFLAKE_COLLISION_OFFSET_X = <(-3)
SNOWFLAKE_COLLISION_OFFSET_Y = <(0)

; funcs to handle the tiledata. tiledata format is in level_data.asm->room_tiledata
snowflake_tile_func_tbl:
			RET_4()								; func_id == 1 ; spawn a monster
			RET_4()								; func_id == 2 ; teleport
			RET_4()								; func_id == 3 ; teleport
			RET_4()								; func_id == 4 ; teleport
			RET_4()								; func_id == 5 ; teleport
			RET_4()								; func_id == 6
			RET_4()								; func_id == 7
			RET_4()								; func_id == 8
			RET_4()								; func_id == 9
			JMP_4( sword_func_triggers)		; func_id == 10
			JMP_4( sword_func_container)	; func_id == 11
			JMP_4( sword_func_door)			; func_id == 12
			JMP_4( sword_func_breakable)	; func_id == 13 ; breakable
			RET_4()								; func_id == 14
			RET_4()								; func_id == 15 ; collision

snowflake_init:
			lxi h, bullet_update_ptr+1
			mvi e, BULLET_RUNTIME_DATA_LEN
			call actor_get_empty_data_ptr
			rnz ; return because too many objects

			; hl - ptr to bullet_update_ptr+1

			dcx h
			mvi m, <snowflake_update
			inx h
			mvi m, >snowflake_update
			inx h
			mvi m, <snowflake_draw
			inx h
			mvi m, >snowflake_draw

			; advance hl to bullet_id
			inx h
			; do not set bullet_id because it is unnecessary for this weapon
;@bullet_id:
			;mvi a, TEMP_BYTE
			;mov m, a

			; advance hl to bullet_status
			inx h
			mvi m, ACTOR_STATUS_BIT_INVIS
			; advance and set bullet_status_timer
			inx h
			mvi m, SNOWFLAKE_STATUS_INVIS_TIME

			; tmp b = 0
			mvi b, 0
			; advance hl to bullet_pos_y+1
			LXI_D_TO_DIFF(bullet_status_timer, bullet_pos_y+1)
			dad d
			; set pos_y
			lda hero_pos_y+1
			; tmp c = pos_y
			mov c, a
			; set pos_y
			mov m, a
			dcx h
			mov m, b
			; advance hl to bullet_pos_x+1
			dcx h
			; set pos_x
			lda hero_pos_x+1

			mov m, a
			dcx h
			mov m, b

			; advance hl to bullet_erase_wh_old+1
			dcx h
			; set the mimimum supported width
			;mvi m, 1 ; width = 8
			mov m, b ; width = 8
			; advance hl to bullet_erase_wh_old
			dcx h
			; set the mimimum supported height
			mvi m, SPRITE_COPY_TO_SCR_H_MIN
			; advance hl to bullet_erase_scr_addr_old+1
			LXI_D_TO_DIFF(bullet_erase_wh_old, bullet_erase_scr_addr_old+1)
			dad d
			; a - pos_x
			; scr_x = pos_x/8 + $a0
			RRC_(3)
			ani %00011111
			adi SPRITE_X_SCR_ADDR
			mov m, a
			; advance hl to bullet_erase_scr_addr_old
			dcx h
			; c = pos_y
			mov m, c
			ret

; anim and a gameplay logic update
; in:
; de - ptr to bullet_update_ptr in the runtime data
snowflake_update:
			; advance to bullet_status
			LXI_H_TO_DIFF(bullet_update_ptr, bullet_status)
			dad d
			mov a, m
			ani ACTOR_STATUS_BIT_INVIS
			jnz @delay_update

			; hl - ptr to bullet_status
			; advance and decr bullet_status_timer
			inx h
			; check if it's time to die
			dcr m
			jz @die

@update_movement:

@attk_anim_update:
			; advance to bullet_anim_timer
			inx h
			mvi a, SNOWFLAKE_ANIM_SPEED_ATTACK
			jmp actor_anim_update

@die:
			LXI_D_TO_DIFF(bullet_status_timer, bullet_update_ptr+1)
			dad d
			jmp actor_destroy

@delay_update:
			; hl - ptr to bullet_status
			; advance and decr bullet_status_timer
			inx h
			dcr m
			rnz

			; hl - ptr to bullet_status_duration
			; set the attack
			mvi m, SNOWFLAKE_STATUS_ATTACK_TIME
			; advance and set bullet_status
			dcx h
			mvi m, SNOWFLAKE_STATUS_ATTACK

			; advance and reset bullet_anim_timer
			INX_H(2)
			mvi m, 0
			; advance and set bullet_anim_ptr
			inx h
			mvi m, <snowflake_run
			inx h
			mvi m, >snowflake_run

/*
@check_monster_collision:
			; check sprite collision
			; hl - ptr to bullet_anim_ptr+1
			; advance hl to bullet_pos_x+1
			HL_ADVANCE_BY_DIFF_BC(bullet_anim_ptr+1, bullet_pos_x+1)
			; add a collision offset
			mov d, m
			INX_H(2)
			mov e, m
			lxi h, SNOWFLAKE_COLLISION_OFFSET_X<<8 | SNOWFLAKE_COLLISION_OFFSET_Y
			dad d

			; store pos_xy
			push h
			; check if a bullet collides with a monster
			mvi a, SNOWFLAKE_COLLISION_WIDTH-1
			mvi c, SNOWFLAKE_COLLISION_HEIGHT-1
			call monsters_get_first_collided

			; hl - ptr to a collided monster_update_ptr+1
			mov a, m
			cpi ACTOR_RUNTIME_DATA_DESTR
			pop d
			; de - pos_xy
			; if a monster's alive, check the tile it is on.
			jnc @check_tiledata

			; advance hl to monster_impacted_ptr
			HL_ADVANCE_BY_DIFF_BC(monster_update_ptr+1, monster_impacted_ptr)
			mov e, m
			inx h
			mov d, m
			xchg
			; call a monster_impact func
			pchl
@check_tiledata:
			; de - pos_xy
			TILEDATA_HANDLING(SNOWFLAKE_COLLISION_WIDTH, SNOWFLAKE_COLLISION_HEIGHT, snowflake_tile_func_tbl)
			*/
			ret

; draw a sprite into a backbuffer
; in:
; de - ptr to bullet_draw_ptr in the runtime data
snowflake_draw:
			BULLET_DRAW(sprite_get_scr_addr_snowflake, __RAM_DISK_S_SNOWFLAKE)