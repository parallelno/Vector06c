.include "asm\\bullets\\sword_tile_funcs.asm"

; statuses.
; a status describes what set of animations and behavior is active
; for ex. HERO_STATUS_ATTACK plays hero_attk_r or hero_attk_l depending on the direction and it spawns a weapon trail
SWORD_STATUS_ATTACK = 0

; duration of statuses (in update_durations)
SWORD_STATUS_INVIS_TIME	= 6
SWORD_STATUS_ATTACK_TIME	= 6

; animation speed (the less the slower, 0-255, 255 means next frame every update)
SWORD_ANIM_SPEED_ATTACK	= 150

; gameplay
SWORD_DAMAGE = 1
SWORD_COLLISION_WIDTH	= 15
SWORD_COLLISION_HEIGHT	= 25
SWORD_COLLISION_OFFSET_X_R = 8
SWORD_COLLISION_OFFSET_Y_R = <(-4)

SWORD_COLLISION_OFFSET_X_L = <(-7)
SWORD_COLLISION_OFFSET_Y_L = <(-4)

; funcs to handle the tiledata. tiledata format is in level_data.asm->room_tiledata
sword_tile_func_tbl:
			RET_4()								; func_id == 1 ; spawn a monster
			RET_4()								; func_id == 2 ; teleport
			RET_4()								; func_id == 3 ; teleport
			RET_4()								; func_id == 4 ; teleport
			RET_4()								; func_id == 5 ; teleport
			RET_4()								; func_id == 6
			RET_4()								; func_id == 7
			RET_4()								; func_id == 8
			RET_4()								; func_id == 9
			JMP_4( sword_func_triggers)			; func_id == 10
			JMP_4( sword_func_container)		; func_id == 11
			JMP_4( sword_func_door)				; func_id == 12
			JMP_4( sword_func_breakable)		; func_id == 13 ; breakable
			RET_4()								; func_id == 14
			RET_4()								; func_id == 15 ; collision

sword_init:
			; prevent a sword from spawning if it's not available
			lda hero_res_sword
			CPI_WITH_ZERO(RES_EMPTY)
			jz @no_sword

			; advance hl to bullet_pos_x+1
			lxi h, hero_pos_x+1
			mov b, m
			; advance hl to bullet_pos_y+1
			INX_H(2)
			mov c, m
			; bc - hero_pos
			BULLET_INIT(sword_update, sword_draw, ACTOR_STATUS_BIT_INVIS, SWORD_STATUS_INVIS_TIME, NULL_BYTE, empty_func)

@no_sword:
			; if no sword, do not init a sword, check and handle the collision
			; get a hero pos
			lxi h, hero_pos_x+1
			mov d, m
			INX_H(2)
			mov e, m

			; check direction
			lda hero_dir
			rrc
			lxi h, SWORD_COLLISION_OFFSET_X_L<<8 | SWORD_COLLISION_OFFSET_Y_L
			jnc @left
@right:
			lxi h, SWORD_COLLISION_OFFSET_X_R<<8 | SWORD_COLLISION_OFFSET_Y_R
@left:
			dad d
			xchg
			; de - pos_xy
			TILEDATA_HANDLING(SWORD_COLLISION_WIDTH, SWORD_COLLISION_HEIGHT, sword_tile_func_tbl)
			ret


; anim and a gameplay logic update
; in:
; de - ptr to bullet_update_ptr in the runtime data
sword_update:
			; advance to bullet_status
			LXI_H_TO_DIFF(bullet_update_ptr, bullet_status)
			dad d
			mov a, m
			ani ACTOR_STATUS_BIT_INVIS
			jnz @delay_update

@attk_update:
			; hl - ptr to bullet_status
			; advance and decr bullet_status_timer
			inx h
			; check if it's time to die
			dcr m
			jz @die

@attk_anim_update:
			; advance to bullet_anim_timer
			inx h
			mvi a, SWORD_ANIM_SPEED_ATTACK
			jmp actor_anim_update

@die:
			HL_ADVANCE_BY_DIFF_DE(bullet_status_timer, bullet_update_ptr+1)
			jmp actor_destroy

@delay_update:
			; hl - ptr to bullet_status
			; advance and decr bullet_status_timer
			inx h
			dcr m
			rnz

			; hl - ptr to bullet_status_duration
			; set the attack
			mvi m, SWORD_STATUS_ATTACK_TIME
			; advance and set bullet_status
			dcx h
			mvi m, SWORD_STATUS_ATTACK

			; advance and reset bullet_anim_timer
			INX_H(2)
			mvi m, 0
			; advance and set bullet_anim_ptr
			inx h
			lda hero_dir
			rrc
			jnc @attkL
@attkR:
			mvi m, < sword_attk_r
			inx h
			mvi m, > sword_attk_r

			; check enemies-attk01 sprite collision
			; hl - ptr to bullet_anim_ptr+1
			; advance hl to bullet_pos_x+1
			HL_ADVANCE_BY_DIFF_BC(bullet_anim_ptr+1, bullet_pos_x+1)
			; add a collision offset
			mov d, m
			INX_H(2)
			mov e, m
			lxi h, SWORD_COLLISION_OFFSET_X_R<<8 | SWORD_COLLISION_OFFSET_Y_R
			dad d
			jmp @check_monster_collision
@attkL:
			mvi m, < sword_attk_l
			inx h
			mvi m, > sword_attk_l

			; check enemies-attk01 sprite collision
			; hl - ptr to bullet_anim_ptr+1
			; advance hl to bullet_pos_x+1
			HL_ADVANCE_BY_DIFF_BC(bullet_anim_ptr+1, bullet_pos_x+1)
			; add a collision offset
			mov d, m
			INX_H(2)
			mov e, m
			lxi h, SWORD_COLLISION_OFFSET_X_L<<8 | SWORD_COLLISION_OFFSET_Y_L
			dad d

@check_monster_collision:
			; store pos_xy
			push h
			; check if a bullet collides with a monster
			mvi a, SWORD_COLLISION_WIDTH-1
			mvi c, SWORD_COLLISION_HEIGHT-1
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
			mvi c, HERO_WEAPON_ID_SWORD
			; call a monster_impact func
			pchl
@check_tiledata:
			; de - pos_xy
			TILEDATA_HANDLING(SWORD_COLLISION_WIDTH, SWORD_COLLISION_HEIGHT, sword_tile_func_tbl)
			ret

; draw a sprite into a backbuffer
; in:
; de - ptr to bullet_draw_ptr in the runtime data
sword_draw:
			BULLET_DRAW(sprite_get_scr_addr_sword, __RAM_DISK_S_SWORD)