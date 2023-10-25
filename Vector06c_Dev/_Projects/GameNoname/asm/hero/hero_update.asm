.include "asm\\hero\\hero_update_dead.asm"

.macro HERO_UPDATE_ANIM(anim_speed)
			lxi h, hero_anim_timer
			mov a, m
			adi anim_speed
			mov m, a
			jnc @skipAnimUpdate
			lhld hero_anim_addr
			mov e, m
			inx h
			mov d, m
			dad d
			shld hero_anim_addr
@skipAnimUpdate:
.endmacro

hero_update:
			; check if a current animation is an attack
			lda hero_status
			cpi HERO_STATUS_ATTACK
			jz hero_attack_update
			cpi HERO_STATUS_IMPACTED
			cz hero_impacted_update
			cpi HERO_STATUS_INVINCIBLE
			cz hero_invincible_update
			ani ACTOR_STATUS_BIT_NON_GAMEPLAY ; TODO: bug???->> A reg has a broken status value now
			jnz hero_dead

			; check if an attack key is pressed
			lhld action_code
			; h - action_code_old
			; l - action_code

			mvi a, CONTROL_CODE_FIRE1
			ana l
			jnz hero_attack_start

			; if no arrow key is pressed, do IDLE
			mvi a, CONTROL_CODE_LEFT | CONTROL_CODE_RIGHT | CONTROL_CODE_UP | CONTROL_CODE_DOWN
			ana l
			jz hero_idle_update

			; some arrow keys got pressed
			; if the status was idle last time, start the move
			lda hero_status
			cpi HERO_STATUS_IDLE
			jz @check_move_keys

			; check if the same arrow keys pressed the prev update
			mov a, l
			;xra h ; it erases bits if they are equal in both action_code_old and action_code
			;ani CONTROL_CODE_LEFT | CONTROL_CODE_RIGHT | CONTROL_CODE_UP | CONTROL_CODE_DOWN
			cmp h
			jnz @check_move_keys
			
			; continue the same direction
			HERO_UPDATE_ANIM(HERO_ANIM_SPEED_MOVE)
			jmp hero_update_temp_pos

@check_move_keys:
			mvi a, HERO_STATUS_MOVE
			sta hero_status

			mov a, l
@set_anim_run_r:
			cpi CONTROL_CODE_RIGHT
			jnz @setAnimRunRU

			lxi h, HERO_RUN_SPEED
			shld hero_speed_x
			lxi h, 0
			shld hero_speed_y

			lxi h, hero_dir
			mov a, m
			ani HERO_DIR_HORIZ_RESET
			ori HERO_DIR_RIGHT
			mov m, a

			lxi h, hero_r_run
			shld hero_anim_addr
			jmp hero_update_temp_pos

@setAnimRunRU:
			cpi CONTROL_CODE_RIGHT | CONTROL_CODE_UP
			jnz @setAnimRunRD

			lxi h, HERO_RUN_SPEED_D
			shld hero_speed_x
			shld hero_speed_y

			mvi a, HERO_DIR_RIGHT | HERO_DIR_UP
			sta hero_dir
			lxi h, hero_r_run
			shld hero_anim_addr
			jmp hero_update_temp_pos

@setAnimRunRD:
			cpi CONTROL_CODE_RIGHT | CONTROL_CODE_DOWN
			jnz @set_anim_run_l

			lxi h, HERO_RUN_SPEED_D
			shld hero_speed_x
			LXI_H_NEG(HERO_RUN_SPEED_D)
			shld hero_speed_y

			mvi a, HERO_DIR_RIGHT | HERO_DIR_DOWN
			sta hero_dir
			lxi h, hero_r_run
			shld hero_anim_addr
			jmp hero_update_temp_pos

@set_anim_run_l:
			cpi CONTROL_CODE_LEFT
			jnz @setAnimRunLU

			LXI_H_NEG(HERO_RUN_SPEED)
			shld hero_speed_x
			lxi h, 0
			shld hero_speed_y

			lxi h, hero_dir
			mov a, m
			ani HERO_DIR_HORIZ_RESET
			ori HERO_DIR_LEFT
			mov m, a

			lxi h, hero_l_run
			shld hero_anim_addr
			jmp hero_update_temp_pos

@setAnimRunLU:
			cpi CONTROL_CODE_LEFT | CONTROL_CODE_UP
			jnz @setAnimRunLD

			LXI_H_NEG(HERO_RUN_SPEED_D)
			shld hero_speed_x
			lxi h, HERO_RUN_SPEED_D
			shld hero_speed_y

			mvi a, HERO_DIR_LEFT | HERO_DIR_UP
			sta hero_dir
			lxi h, hero_l_run
			shld hero_anim_addr
			jmp hero_update_temp_pos

@setAnimRunLD:
			cpi CONTROL_CODE_LEFT | CONTROL_CODE_DOWN
			jnz @setAnimRunU

			LXI_H_NEG(HERO_RUN_SPEED_D)
			shld hero_speed_x
			shld hero_speed_y

			mvi a, HERO_DIR_LEFT | HERO_DIR_DOWN
			sta hero_dir
			lxi h, hero_l_run
			shld hero_anim_addr
			jmp hero_update_temp_pos

@setAnimRunU:
			cpi CONTROL_CODE_UP
			jnz @setAnimRunD

			lxi h, 0
			shld hero_speed_x
			lxi h, HERO_RUN_SPEED
			shld hero_speed_y

			lxi h, hero_dir
			mov a, m
			ani HERO_DIR_VERT_RESET
			ori HERO_DIR_UP
			mov m, a
			rrc
			jnc @setAnimRunUfaceL

			lxi h, hero_r_run
			shld hero_anim_addr
			jmp hero_update_temp_pos
@setAnimRunUfaceL:
			lxi h, hero_l_run
			shld hero_anim_addr
			jmp hero_update_temp_pos
@setAnimRunD:
			cpi CONTROL_CODE_DOWN
			rnz

			lxi h, 0
			shld hero_speed_x
			LXI_H_NEG(HERO_RUN_SPEED)
			shld hero_speed_y

			lxi h, hero_dir
			mov a, m
			ani HERO_DIR_VERT_RESET
			ori HERO_DIR_DOWN
			mov m, a
			rrc
			jnc @setAnimRunDfaceL

			lxi h, hero_r_run
			shld hero_anim_addr
			jmp hero_update_temp_pos
@setAnimRunDfaceL:
			lxi h, hero_l_run
			shld hero_anim_addr

hero_update_temp_pos:
			; apply the hero speed
			lhld hero_pos_x
			xchg
			lhld hero_speed_x
			dad d
			shld char_temp_x
			mov b, h
			lhld hero_pos_y
			xchg
			lhld hero_speed_y
			dad d
			shld char_temp_y

			; check the collision tiles
			mov d, b ; pos_x
			mov e, h ; pos_y
			lxi b, (HERO_COLLISION_WIDTH-1)<<8 | HERO_COLLISION_HEIGHT-1
			call room_get_collision_tiledata
			ani TILEDATA_FUNC_MASK
			jz hero_no_collision_no_tiledata ; if there is no tiledata to analize, move a hero and return
			ani TILEDATA_COLLIDABLE
			jz hero_no_collision

@collides:
			; check if there is any collidable tiledata
			; hl - (top-left), (top-right)
			; de - (bottom-left), (bottom-right)
			; hero collision ptr bit layout:
			; (bottom-left), (bottom-right), (top_right), (top-left), 0, 0

			; check the bottom-left corner
			mvi b, 256-TILEDATA_COLLIDABLE
			mov a, e
			add b
			mvi a, 0
			ral
			mov c, a

			; check the bottom-right corner
			mov a, d
			add b
			mov a, c
			ral
			mov c, a

			; check the top-right corner
			mov a, h
			add b
			mov a, c
			ral
			mov c, a

			; check the top-left corner
			mov a, l
			add b
			mov a, c
			ral

			; handle a collision data around a hero
			; if a hero is inside the collision, move him out
			ADD_A(2) ; to make a jmp table ptr with a 4 byte allignment
			mov c, a
			mvi b, 0
			lxi h, hero_collision_func_table
			dad b
			pchl

; handle tiledata around a hero.
hero_check_tiledata:
			lxi h, hero_pos_x+1
			mov d, m
			INX_H(2)
			mov e, m
			TILEDATA_HANDLING(HERO_COLLISION_WIDTH, HERO_COLLISION_HEIGHT, hero_tile_func_tbl)
			ret

hero_attack_start:
			; set the status
			lxi h, hero_status
			mvi m, HERO_STATUS_ATTACK
			;advance hl to hero_status_timer
			inx h
			mvi m, HERO_STATUS_ATTACK_DURATION

			; reset anim timer
			A_TO_ZERO(NULL_BYTE)
			sta hero_anim_timer

			; speed = 0
			lxi h, 0
			shld hero_speed_x
			shld hero_speed_y

			lda game_ui_res_selected_id
			cpi RES_ID_SWORD
			jz @use_sword
			cpi RES_ID_SNOWFLAKE
			jz @use_snowflake
			cpi RES_ID_PIE
			jz @use_popsicle_pie
			cpi RES_ID_CABBAGE
			jz @use_cabbage
			jmp @use_sword ; TODO: revise that logic: ; use a sword after using a cabbage to handle triggers

@use_snowflake:
			lxi h, hero_res_snowflake
			mov a, m
			CPI_WITH_ZERO(0)
			rz
			dcr m
			lxi h, hero_res_sword
			call game_ui_res_select_and_draw
						
			call snowflake_init
			jmp @use_sword ; TODO: revise that logic: ; use a sword after using a cabbage to handle triggers

@use_cabbage:
			lxi h, hero_res_cabbage
			mov a, m
			CPI_WITH_ZERO(0)
			rz
			dcr m
			lxi h, hero_res_health
			mov a, m
			adi RES_CABBAGE_HEALTH_VAL
			CLAMP_A(RES_HEALTH_MAX)
			mov m, a
			lxi h, hero_res_sword
			call game_ui_res_select_and_draw
			jmp @use_sword ; TODO: revise that logic: ; use a sword after using a cabbage to handle triggers

@use_popsicle_pie:
			lxi h, hero_res_popsicle_pie
			mov a, m
			CPI_WITH_ZERO(0)
			rz
			dcr m
			lxi h, hero_res_snowflake
			mov a, m
			adi RES_POPSICLE_PIE_MANA_VAL
			CLAMP_A(RES_SNOWFLAKES_MAX)
			mov m, a
			lxi h, hero_res_sword
			call game_ui_res_select_and_draw
			; TODO: revise that logic: ; use a sword after using a popsicle to handle triggers
@use_sword:
			; set direction
			lda hero_dir
			rrc
			jnc @set_anim_attk_l

			lxi h, hero_r_attk
			shld hero_anim_addr
			jmp sword_init
@set_anim_attk_l:
			lxi h, hero_l_attk
			shld hero_anim_addr
			jmp sword_init

hero_attack_update:
			HERO_UPDATE_ANIM(HERO_ANIM_SPEED_ATTACK)
			lxi h, hero_status_timer
			dcr m
			rnz
			; if the timer == 0, set the status to Idle
			jmp hero_idle_start

hero_idle_start:
			; set status
			mvi a, HERO_STATUS_IDLE
			sta hero_status
			; reset the anim timer
			A_TO_ZERO(NULL_BYTE)
			sta hero_anim_timer

			; speed = 0
			lxi h, 0
			shld hero_speed_x
			shld hero_speed_y
			; set direction
			lda hero_dir
			rrc
			jnc @setAnimIdleL

			lxi h, hero_r_idle
			shld hero_anim_addr
			ret
@setAnimIdleL:
			lxi h, hero_l_idle
			shld hero_anim_addr
			ret

hero_idle_update:
			; check if the same keys pressed the prev update
			mov a, l
			cmp h
			jnz hero_idle_start
			HERO_UPDATE_ANIM(HERO_ANIM_SPEED_IDLE)
			ret

hero_invincible_start:
			; set the status
			lxi h, hero_status
			mvi m, HERO_STATUS_INVINCIBLE
			;advance hl to hero_status_timer
			inx h
			mvi m, HERO_STATUS_INVINCIBLE_DURATION
			; turn off reversed speed
			A_TO_ZERO(CONTROL_CODE_NO)
			sta action_code
			ret

hero_invincible_update:
			lxi h, hero_status_timer
			dcr m
			rnz
			jmp hero_idle_start


hero_impacted_update:
			lxi h, hero_status_timer
			dcr m
			jz hero_invincible_start
			; move the hero
			jmp hero_update_temp_pos


; handling the damage
; in:
; c - damage (positive number)
; uses:
; a, hl, de
hero_impacted:
			lda hero_status
			cpi HERO_STATUS_INVINCIBLE ; this is invincible + hero blinking status
			rz
			cpi HERO_STATUS_IMPACTED ; to handle it once per upcomming damage. it is also invincible
			rz

			lxi h, __sfx_bomb_attack
			CALL_RAM_DISK_FUNC(__sfx_play, __RAM_DISK_M_SOUND | RAM_DISK_M_8F)

			call hero_impacted_start

			lxi h, hero_res_health
			mov a, m
			sub c

			; clamp to 0
			jnc @no_clamp
			A_TO_ZERO(NULL_BYTE)
@no_clamp:
			mov m, a
			jnz @not_dead
			; dead
			mvi a, HERO_STATUS_DEATH_FADE_INIT_GB
			sta hero_status
@not_dead:
			jmp game_ui_draw_health_text


; uses:
; hl, de, a
hero_impacted_start:
			; set the status
			lxi h, hero_status
			mvi m, HERO_STATUS_IMPACTED
			;advance hl to hero_status_timer
			inx h
			mvi m, HERO_STATUS_IMPACTED_DURATION

			; set backward speed
			; check hero's horizontal direction
			lxi d, hero_dir
			ldax d
			ani HERO_DIR_HORIZ_MASK
			jz @no_horiz_move
			rrc
			lxi h, HERO_RUN_SPEED_IMPACTED_N
			jc @set_speed_x
			lxi h, HERO_RUN_SPEED_IMPACTED
@set_speed_x:
			shld hero_speed_x

			; check hero's vertical direction
@check_dir_vert:
			ldax d
			ani HERO_DIR_VERT_MASK
			jz @no_vert_move
			RRC_(3)
			lxi h, HERO_RUN_SPEED_IMPACTED_N
			jc @set_speed_y
			lxi h, HERO_RUN_SPEED_IMPACTED
@set_speed_y:
			shld hero_speed_y
			ret
@no_horiz_move:
			lxi h, 0
			jmp @set_speed_x
@no_vert_move:
			lxi h, 0
			jmp @set_speed_y