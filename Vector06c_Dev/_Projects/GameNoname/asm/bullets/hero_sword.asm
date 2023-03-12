; statuses.
; a status describes what set of animations and behavior is active
; for ex. HERO_STATUS_ATTACK plays hero_attk_r or hero_attk_l depending on the direction and it spawns a weapon trail
HERO_SWORD_STATUS_ATTACK = 0

; duration of statuses (in updateDurations)
HERO_SWORD_STATUS_INVIS_DURATION	= 6
HERO_SWORD_STATUS_ATTACK_DURATION	= 8

; animation speed (the less the slower, 0-255, 255 means next frame every update)
HERO_SWORD_ANIM_SPEED_ATTACK	= 50

; gameplay
HERO_SWORD_DAMAGE = 1
HERO_SWORD_COLLISION_WIDTH	= 11
HERO_SWORD_COLLISION_HEIGHT	= 16
HERO_SWORD_COLLISION_OFFSET_X_R = 8
HERO_SWORD_COLLISION_OFFSET_Y_R = 0

HERO_SWORD_COLLISION_OFFSET_X_L = <(-3)
HERO_SWORD_COLLISION_OFFSET_Y_L = 0

; funcs to handle the tiledata. tiledata format is in level_data.asm->room_tiledata
hero_sword_tile_func_table:
			ret_4()								; func_id == 1 ; spawn a monster
			ret_4()								; func_id == 2 ; teleport
			ret_4()								; func_id == 3 ; teleport
			ret_4()								; func_id == 4 ; teleport
			ret_4()								; func_id == 5 ; teleport
			ret_4()								; func_id == 6
			ret_4()								; func_id == 7
			ret_4()								; func_id == 8
			ret_4()								; func_id == 9
			ret_4()								; func_id == 10
			ret_4()								; func_id == 11
			ret_4()								; func_id == 12
			jmp_4( hero_sword_func_breakable)	; func_id == 13 ; breakable
			ret_4()								; func_id == 14
			ret_4()								; func_id == 15 ; collision

hero_sword_init:
			call bullets_get_empty_data_ptr
			; hl - ptr to bullet_update_ptr+1

			dcx h
			mvi m, <hero_sword_update
			inx h
			mvi m, >hero_sword_update
			inx h
			mvi m, <hero_sword_draw
			inx h
			mvi m, >hero_sword_draw

			; advance hl to bullet_id
			inx h
			; do not set bullet_id because it is unnecessary for this weapon
;@bullet_id:
			;mvi a, TEMP_BYTE
			;mov m, a

			; advance hl to bullet_status
			inx h
			mvi m, BULLET_STATUS_INVIS
			; advance and set bullet_status_timer
			inx h
			mvi m, HERO_SWORD_STATUS_INVIS_DURATION

			; tmp b = 0
			mvi b, 0
			; advance hl to bullet_pos_y+1
			LXI_D_TO_DIFF(bullet_pos_y+1, bullet_status_timer)
			dad d
			; set posY
			lda hero_pos_y+1
			; tmp c = posY
			mov c, a
			; set posY
			mov m, a
			dcx h
			mov m, b
			; advance hl to bullet_pos_x+1
			dcx h
			; set posX
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
			mvi m, 5
			; advance hl to bullet_erase_scr_addr_old+1
			LXI_D_TO_DIFF(bullet_erase_scr_addr_old+1, bullet_erase_wh_old)
			dad d
			; a - posX
			; scrX = posX/8 + $a0
			rrc_(3)
			ani %00011111
			adi SPRITE_X_SCR_ADDR
			mov m, a
			; advance hl to bullet_erase_scr_addr_old
			dcx h
			; c = posY
			mov m, c
			ret


; anim and a gameplay logic update
; in:
; de - ptr to bullet_update_ptr in the runtime data
hero_sword_update:
			; advance to bullet_status
			LXI_H_TO_DIFF(bullet_status, bullet_update_ptr)
			dad d
			mov a, m
			cpi BULLET_STATUS_INVIS
			jz @delayUpdate

@attkUpdate:
			; hl - ptr to bullet_status
			; advance and decr bullet_status_timer
			inx h
			; check if it's time to die
			dcr m
			jz @destroy

@attkAnimUpdate:
			; advance to bullet_anim_timer
			inx h
			; update it
			mov a, m
			adi HERO_SWORD_ANIM_SPEED_ATTACK
			mov m, a
			jnc @skipAnimUpdate

			; advance to bullet_anim_ptr
			inx h
			; read the ptr to a current frame
			mov e, m
			inx h
			mov d, m
			xchg
			; hl - the ptr to a current frame
			; get the offset to the next frame
			mov c, m
			inx h
			mov b, m
			; advance the current frame ptr to the next frame
			dad b
			xchg
			; de - the next frame ptr
			; store de into the bullet_anim_ptr
			mov m, d
			dcx h
			mov m, e
@skipAnimUpdate:
			; update movement if needed
			ret
@destroy:
			LXI_D_TO_DIFF(bullet_update_ptr+1, bullet_status_timer)
			dad d
			jmp bullets_destroy

@delayUpdate:
			; hl - ptr to bullet_status
			; advance and decr bullet_status_timer
			inx h
			dcr m
			rnz

			; hl - ptr to bulletStatusDuration
			; set the attack
			mvi m, HERO_SWORD_STATUS_ATTACK_DURATION
			; advance and set bullet_status
			dcx h
			mvi m, HERO_SWORD_STATUS_ATTACK

			; advance and reset bullet_anim_timer
			inx_h(2)
			mvi m, 0
			; advance and set bullet_anim_ptr
			inx h
			lda hero_dir_x
			ora a
			jz @attkL
@attkR:
			mvi m, < hero_sword_attk_r
			inx h
			mvi m, > hero_sword_attk_r

			; check enemies-attk01 sprite collision
			; hl - ptr to bullet_anim_ptr+1
			; advance hl to bullet_pos_x+1
			LXI_B_TO_DIFF(bullet_pos_x+1, bullet_anim_ptr+1)
			dad b
			; add a collision offset
			mov d, m
			inx_h(2)
			mov e, m
			lxi h, HERO_SWORD_COLLISION_OFFSET_X_R<<8 | HERO_SWORD_COLLISION_OFFSET_Y_R
			dad d
			jmp @setCollisionSize
@attkL:
			mvi m, < hero_sword_attk_l
			inx h
			mvi m, > hero_sword_attk_l

			; check enemies-attk01 sprite collision
			; hl - ptr to bullet_anim_ptr+1
			; advance hl to bullet_pos_x+1
			LXI_B_TO_DIFF(bullet_pos_x+1, bullet_anim_ptr+1)
			dad b
			; add a collision offset
			mov d, m
			inx_h(2)
			mov e, m
			lxi h, HERO_SWORD_COLLISION_OFFSET_X_L<<8 | HERO_SWORD_COLLISION_OFFSET_Y_L
			dad d

@setCollisionSize:
			; store posXY
			push h
			; check if a bullet collides with a monster
			mvi a, HERO_SWORD_COLLISION_WIDTH-1
			mvi c, HERO_SWORD_COLLISION_HEIGHT-1
			call monsters_get_first_collided

			; hl - ptr to a collided monster_update_ptr+1
			mov a, m
			cpi MONSTER_RUNTIME_DATA_DESTR
			pop d
			; de - posXY
			; if not, check the tile it is on.
			jnc @checkTiledata

			; advance hl to monster_impacted_ptr
			LXI_B_TO_DIFF(monster_impacted_ptr, monster_update_ptr+1)
			dad b
			; call bulletImpactPtr
			mov e, m
			inx h
			mov d, m
			xchg
			pchl
@checkTiledata:
			; de - posXY 
			lxi b, (HERO_SWORD_COLLISION_WIDTH-1)<<8 | HERO_SWORD_COLLISION_HEIGHT-1
			CALL_RAM_DISK_FUNC(room_get_tiledata, __RAM_DISK_M_BACKBUFF2 | RAM_DISK_M_89, false, false)
			rz ; return if the is no tiledata to analize

			lxi h, room_get_tiledata_buff
			mvi c, 4
@loop:		TILEDATA_HANDLE_FUNC_CALL(hero_sword_tile_func_table-JMP_4_LEN, true)
			inx h
			dcr c
			jnz @loop
			ret

hero_sword_func_breakable:
			;call room_handle_tiledata_under_sprite
			ret

; draw a sprite into a backbuffer
; in:
; de - ptr to bullet_draw_ptr in the runtime data
hero_sword_draw:
			BULLET_DRAW(sprite_get_scr_addr_hero_sword, __RAM_DISK_S_HERO_SWORD)