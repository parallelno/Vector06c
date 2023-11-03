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

SNOWFLAKE_SPEED		= $200

; funcs to handle the tiledata. tiledata format is in level_data.asm->room_tiledata
snowflake_tile_func_tbl:
			RET_4()							; func_id == 1 ; spawn a monster
			RET_4()							; func_id == 2 ; teleport
			RET_4()							; func_id == 3 ; teleport
			RET_4()							; func_id == 4 ; teleport
			RET_4()							; func_id == 5 ; teleport
			RET_4()							; func_id == 6
			RET_4()							; func_id == 7
			RET_4()							; func_id == 8
			RET_4()							; func_id == 9
			JMP_4( sword_func_triggers)		; func_id == 10
			JMP_4( sword_func_container)	; func_id == 11
			JMP_4( sword_func_door)			; func_id == 12
			JMP_4( sword_func_breakable)	; func_id == 13 ; breakable
			RET_4()							; func_id == 14
			RET_4()							; func_id == 15 ; collision

snowflake_init:
			; advance hl to bullet_pos_x+1
			lxi h, hero_pos_x+1
			mov b, m
			; advance hl to bullet_pos_y+1
			INX_H(2)
			mov c, m
			; bc - hero_pos
			BULLET_INIT(snowflake_update, snowflake_draw, ACTOR_STATUS_BIT_INVIS, SNOWFLAKE_STATUS_INVIS_TIME, snowflake_run, snowflake_init_speed)
; the move dir along with the hero dir
; in:
; de - ptr to bullet_speed_x	
snowflake_init_speed:
			xchg
			; hl - ptr to bullet_speed_x
			; check hero's horizontal direction
			lxi b, hero_dir
			ldax b
			ani HERO_DIR_HORIZ_MASK
			cpi HERO_DIR_LEFT ; check the dir_h bit. if it is disabled, no horiz move.
			lxi d, 0
			jc @set_speed_x
			LXI_D_NEG(SNOWFLAKE_SPEED)
			jz @set_speed_x
			lxi d, SNOWFLAKE_SPEED
@set_speed_x:
			call @set_speed

			; check hero's vertical direction
@check_dir_vert:
			ldax b
			ani HERO_DIR_VERT_MASK
			cpi HERO_DIR_DOWN ; check the dir_v bit. if it is disabled, no vert move.
			lxi d, 0
			jc @set_speed
			LXI_D_NEG(SNOWFLAKE_SPEED)
			jz @set_speed
			lxi d, SNOWFLAKE_SPEED
@set_speed:
			mov m, e
			inx h
			mov m, d
			inx h
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
			; advance hl and decr bullet_status_timer
			inx h
			; check if it's time to die
			dcr m
			jnz @update_movement
			HL_ADVANCE_BY_DIFF_DE(bullet_status_timer, bullet_update_ptr+1)
			jmp actor_destroy

@update_movement:
			ACTOR_UPDATE_MOVEMENT_CHECK_TILE_COLLISION(bullet_status_timer, bullet_pos_x, SNOWFLAKE_COLLISION_WIDTH, SNOWFLAKE_COLLISION_HEIGHT, @die) 

			; hl points to bullet_pos_y+1
			; advance hl to bullet_anim_timer
			HL_ADVANCE_BY_DIFF_BC(bullet_pos_y+1, bullet_anim_timer)
			mvi a, SNOWFLAKE_ANIM_SPEED_ATTACK
			call actor_anim_update
			; hl points to *_anim_ptr
@check_monster_collision:
			; check sprite collision
			; hl - ptr to bullet_anim_ptr
			; advance hl to bullet_pos_x+1
			HL_ADVANCE_BY_DIFF_BC(bullet_anim_ptr, bullet_pos_x+1)
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
			ret

@die:
			; hl - ptr to bullet_pos_x
			HL_ADVANCE_BY_DIFF_DE(bullet_pos_x, bullet_update_ptr+1)
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
			ret	


; draw a sprite into a backbuffer
; in:
; de - ptr to bullet_draw_ptr in the runtime data
snowflake_draw:
			BULLET_DRAW(sprite_get_scr_addr_snowflake, __RAM_DISK_S_SNOWFLAKE)