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
			ani ACTOR_STATUS_BIT_NON_GAMEPLAY ; A reg has a broken status value now
			jnz hero_dead


			; check if an attack key pressed
			lhld key_code
			mvi a, KEY_SPACE
			cmp h
			jz hero_attack_start

			; check if no arrow key pressed
			mvi a, KEY_LEFT & KEY_RIGHT & KEY_UP & KEY_DOWN
			ora l
			inr a
			jz hero_idle_update

@checkMoveKeys:
			; check if the same arrow keys pressed the prev update
			lda key_code_old
			cmp l
			jnz @moveKeysPressed

			; update a move anim
			HERO_UPDATE_ANIM(HERO_ANIM_SPEED_MOVE)
			jmp hero_update_temp_pos

@moveKeysPressed:
			mov a, l
@setAnimRunR:
			cpi KEY_RIGHT
			jnz @setAnimRunRU

			lxi h, HERO_RUN_SPEED
			shld hero_speed_x
			lxi h, 0
			shld hero_speed_y

			lxi h, hero_dir_x
			mov a, m
			ani HERO_DIR_HORIZ_RESET
			ori HERO_DIR_RIGHT
			mov m, a

			lxi h, hero_r_run
			shld hero_anim_addr
			jmp hero_update_temp_pos

@setAnimRunRU:
			cpi KEY_RIGHT & KEY_UP
			jnz @setAnimRunRD

			lxi h, HERO_RUN_SPEED_D
			shld hero_speed_x
			shld hero_speed_y

			mvi a, HERO_DIR_RIGHT | HERO_DIR_UP
			sta hero_dir_x
			lxi h, hero_r_run
			shld hero_anim_addr
			jmp hero_update_temp_pos

@setAnimRunRD:
			cpi KEY_RIGHT & KEY_DOWN
			jnz @setAnimRunL

			lxi h, HERO_RUN_SPEED_D
			shld hero_speed_x
			LXI_H_NEG(HERO_RUN_SPEED_D)
			shld hero_speed_y

			mvi a, HERO_DIR_RIGHT | HERO_DIR_DOWN
			sta hero_dir_x
			lxi h, hero_r_run
			shld hero_anim_addr
			jmp hero_update_temp_pos

@setAnimRunL:
			cpi KEY_LEFT
			jnz @setAnimRunLU

			LXI_H_NEG(HERO_RUN_SPEED)
			shld hero_speed_x
			lxi h, 0
			shld hero_speed_y

			lxi h, hero_dir_x
			mov a, m
			ani HERO_DIR_HORIZ_RESET
			ori HERO_DIR_LEFT
			mov m, a

			lxi h, hero_l_run
			shld hero_anim_addr
			jmp hero_update_temp_pos

@setAnimRunLU:
			cpi KEY_LEFT & KEY_UP
			jnz @setAnimRunLD

			LXI_H_NEG(HERO_RUN_SPEED_D)
			shld hero_speed_x
			lxi h, HERO_RUN_SPEED_D
			shld hero_speed_y

			mvi a, HERO_DIR_LEFT | HERO_DIR_UP
			sta hero_dir_x
			lxi h, hero_l_run
			shld hero_anim_addr
			jmp hero_update_temp_pos

@setAnimRunLD:
			cpi KEY_LEFT & KEY_DOWN
			jnz @setAnimRunU

			LXI_H_NEG(HERO_RUN_SPEED_D)
			shld hero_speed_x
			shld hero_speed_y

			mvi a, HERO_DIR_LEFT | HERO_DIR_DOWN
			sta hero_dir_x
			lxi h, hero_l_run
			shld hero_anim_addr
			jmp hero_update_temp_pos

@setAnimRunU:
			cpi KEY_UP
			jnz @setAnimRunD

			lxi h, 0
			shld hero_speed_x
			lxi h, HERO_RUN_SPEED
			shld hero_speed_y

			lxi h, hero_dir_x
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
			cpi KEY_DOWN
			rnz

			lxi h, 0
			shld hero_speed_x
			LXI_H_NEG(HERO_RUN_SPEED)
			shld hero_speed_y

			lxi h, hero_dir_x
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
			mov d, b ; posX
			mov e, h ; posY
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
			TILEDATA_HANDLING2(HERO_COLLISION_WIDTH, HERO_COLLISION_HEIGHT, hero_tile_func_tbl)
			ret

hero_attack_start:
			; set the status
			lxi h, hero_status
			mvi m, HERO_STATUS_ATTACK
			;advance hl to hero_status_timer
			inx h
			mvi m, HERO_STATUS_ATTACK_DURATION

			; reset anim timer
			xra a
			sta hero_anim_timer

			; speed = 0
			lxi h, 0
			shld hero_speed_x
			shld hero_speed_y
			; set direction
			lda hero_dir_x
			rrc
			jnc @setAnimAttkL

			lxi h, hero_r_attk
			shld hero_anim_addr
			jmp  hero_sword_init
@setAnimAttkL:
			lxi h, hero_l_attk
			shld hero_anim_addr
			jmp hero_sword_init

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
			; reset anim timer
			xra a
			sta hero_anim_timer

			; speed = 0
			lxi h, 0
			shld hero_speed_x
			shld hero_speed_y
			; set direction
			lda hero_dir_x
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
			lda key_code_old
			cmp l
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
			ret

hero_invincible_update:
			lxi h, hero_status_timer
			dcr m
			rnz
			jmp hero_idle_start

hero_impacted_start:
			; set the status
			lxi h, hero_status
			mvi m, HERO_STATUS_IMPACTED
			;advance hl to hero_status_timer
			inx h
			mvi m, HERO_STATUS_IMPACTED_DURATION

			; set backward speed
			; check hero's horizontal direction
			lxi d, hero_dir_x
			ldax d
			ani HERO_DIR_HORIZ_MASK
			jz @no_horiz_move
			rrc
			lxi h, HERO_RUN_SPEED_IMPACTED_N
			jc @set_speed_x_n
@set_speed_x_p:
			lxi h, HERO_RUN_SPEED_IMPACTED
@set_speed_x_n:
			shld hero_speed_x

			; check hero's vertical direction
@check_dir_vert:
			ldax d
			ani HERO_DIR_VERT_MASK
			jz @no_vert_move
			RRC_(3)
			lxi h, HERO_RUN_SPEED_IMPACTED_N
			jc @set_speed_y_n
@set_speed_y_p:
			lxi h, HERO_RUN_SPEED_IMPACTED
@set_speed_y_n:
			shld hero_speed_y
			ret
@no_horiz_move:
			lxi h, 0
			shld hero_speed_x
			jmp @check_dir_vert
@no_vert_move:
			lxi h, 0
			shld hero_speed_y
			ret


hero_impacted_update:
			lxi h, hero_status_timer
			dcr m
			jz hero_invincible_start
			; move the hero
			jmp hero_update_temp_pos


; handle the damage
; in:
; c - damage (positive number)
hero_impacted:
			lda hero_status
			cpi HERO_STATUS_INVINCIBLE
			rz
			cpi HERO_STATUS_IMPACTED
			rz

			lxi h, __sfx_bomb_attack
			CALL_RAM_DISK_FUNC_NO_RESTORE(__sfx_play, __RAM_DISK_M_SOUND | RAM_DISK_M_8F)

			call hero_impacted_start

			lxi h, hero_health
			mov a, m
			sub c
			jc @dead
			jz @dead
			mov m, a
			call game_ui_draw_health
			ret
@dead:
			mvi m, 0
			; check if he dies
			call game_ui_draw_health
			; hero's dead

			; set the status
			lxi h, hero_status
			mvi m, HERO_STATUS_DEATH_FADE_INIT_GB
			ret

hero_dead:
			lda hero_status
			cpi HERO_STATUS_DEATH_FADE_INIT_GB
			jz hero_dead_fade_init_gb
			cpi HERO_STATUS_DEATH_FADE_GB
			jz hero_dead_fade_gb
			cpi HERO_STATUS_DEATH_FADE_R
			jz hero_dead_fade_r
			cpi HERO_STATUS_DEATH_FALL_ANIM
			jz hero_dead_fade_fall_anim
			ret

hero_dead_fade_init_gb:
			KILL_ALL_MONSTERS()
			KILL_ALL_BULLETS()

			; set the status
			lxi h, hero_status
			mvi m, HERO_STATUS_DEATH_FADE_GB
			ret

HERO_STATUS_DEATH_FADE_UPDATE_RATE = %00010001
HERO_STATUS_DEATH_FADE_GB_TIMER = 7
hero_dead_fade_gb:
			; fade out a pallete
			; do a palette animation only every Nth frame
@anim_rate:
			mvi a, HERO_STATUS_DEATH_FADE_UPDATE_RATE
			rrc
			sta @anim_rate + 1
			rnc

			lxi h, palette
			mvi c, PALETTE_COLORS

@fade_gb_counter:
			mvi a, HERO_STATUS_DEATH_FADE_GB_TIMER
			ora a
			jz @next_status
			dcr a
			sta @fade_gb_counter + 1

@loop_bg:
			mov a, m
			rrc
			ani %01011000
			mov b, a
			mov a, m
			ani %00000111
			ora b
			mov m, a

			inx h
			dcr c
			jnz @loop_bg

@update_palette:
			lxi h, palette_update_request
			mvi m, PALETTE_UPD_REQ_YES
			ret

@next_status:
			; reset a fade timer
			lxi h, @fade_gb_counter + 1
			mvi m, HERO_STATUS_DEATH_FADE_GB_TIMER

			; set the status
			lxi h, hero_status
			mvi m, HERO_STATUS_DEATH_FADE_R

			; draw vfx
			; bc - vfx scrXY
			; de - vfx_anim_ptr (ex. vfx_puff)
			lxi h, hero_pos_x + 1
			mov b, m
			INX_H(2)
			mov c, m
			lxi d, vfx4_hero_death
			call vfx_init4			
			ret

HERO_STATUS_DEATH_FADE_R_TIMER = 7
hero_dead_fade_r:
			HERO_UPDATE_ANIM(HERO_ANIM_SPEED_ATTACK)
			; fade out R channel
			; do a palette animation only every Nth frame
@anim_rate:
			mvi a, HERO_STATUS_DEATH_FADE_UPDATE_RATE
			rrc
			sta @anim_rate + 1
			rnc

			lxi h, palette
			mvi c, PALETTE_COLORS

@fade_r_counter:
			mvi a, HERO_STATUS_DEATH_FADE_R_TIMER
			ora a
			jz @next_status
			dcr a
			sta @fade_r_counter + 1

@loop_r:
			mov a, m
			ora a
			jz @next
			dcr m
@next:			
			inx h
			dcr c
			jnz @loop_r

@update_palette:
			lxi h, palette_update_request
			mvi m, PALETTE_UPD_REQ_YES
			ret

@next_status:
			; reset a fade timer
			lxi h, @fade_r_counter + 1
			mvi m, HERO_STATUS_DEATH_FADE_R_TIMER

			; set the status
			lxi h, hero_status
			mvi m, HERO_STATUS_DEATH_FALL_ANIM
			;advance hl to hero_status_timer
			inx h
			mvi m, HERO_STATUS_DEATH_FALL_ANIM_DURATION
			
			; kill all the backs

			; erase the screen

			; apply a palette

			; create an actor to move it to the right and spawn vfx_reward sparkle effects


			ret


hero_dead_fade_fall_anim:

			ret