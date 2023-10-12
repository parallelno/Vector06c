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
			CPI_WITH_ZERO(HERO_WEAPON_NONE)
			jz @no_sword

			lxi h, bullet_update_ptr+1
			mvi e, BULLET_RUNTIME_DATA_LEN
			call actor_get_empty_data_ptr
			rnz ; return because too many objects

			; hl - ptr to bullet_update_ptr+1

			dcx h
			mvi m, <sword_update
			inx h
			mvi m, >sword_update
			inx h
			mvi m, <sword_draw
			inx h
			mvi m, >sword_draw

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
			mvi m, SWORD_STATUS_INVIS_TIME

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
@no_sword:
			; get a hero pos
			lxi h, hero_pos_x+1
			mov d, m
			INX_H(2)
			mov e, m

			; check direction
			lda hero_dir_x
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
			mvi m, SWORD_STATUS_ATTACK_TIME
			; advance and set bullet_status
			dcx h
			mvi m, SWORD_STATUS_ATTACK

			; advance and reset bullet_anim_timer
			INX_H(2)
			mvi m, 0
			; advance and set bullet_anim_ptr
			inx h
			lda hero_dir_x
			rrc
			jnc @attkL
@attkR:
			mvi m, < sword_attk_r
			inx h
			mvi m, > sword_attk_r

			; check enemies-attk01 sprite collision
			; hl - ptr to bullet_anim_ptr+1
			; advance hl to bullet_pos_x+1
			HL_ADVANCE_BY_DIFF_BC(bullet_pos_x+1, bullet_anim_ptr+1)
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
			HL_ADVANCE_BY_DIFF_BC(bullet_pos_x+1, bullet_anim_ptr+1)
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
			HL_ADVANCE_BY_DIFF_BC(monster_impacted_ptr, monster_update_ptr+1)
			mov e, m
			inx h
			mov d, m
			xchg
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