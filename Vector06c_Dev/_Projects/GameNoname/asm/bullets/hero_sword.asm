; statuses.
; a status describes what set of animations and behavior is active
; for ex. HERO_STATUS_ATTACK plays hero_attk_r or hero_attk_l depending on the direction and it spawns a weapon trail
HERO_SWORD_STATUS_ATTACK = 0

; duration of statuses (in update_durations)
HERO_SWORD_STATUS_INVIS_DURATION	= 6
HERO_SWORD_STATUS_ATTACK_DURATION	= 6

; animation speed (the less the slower, 0-255, 255 means next frame every update)
HERO_SWORD_ANIM_SPEED_ATTACK	= 150

; gameplay
HERO_SWORD_DAMAGE = 1
HERO_SWORD_COLLISION_WIDTH	= 15
HERO_SWORD_COLLISION_HEIGHT	= 25
HERO_SWORD_COLLISION_OFFSET_X_R = 8
HERO_SWORD_COLLISION_OFFSET_Y_R = <(-4)

HERO_SWORD_COLLISION_OFFSET_X_L = <(-7)
HERO_SWORD_COLLISION_OFFSET_Y_L = <(-4)

; funcs to handle the tiledata. tiledata format is in level_data.asm->room_tiledata
hero_sword_tile_func_tbl:
			RET_4()								; func_id == 1 ; spawn a monster
			RET_4()								; func_id == 2 ; teleport
			RET_4()								; func_id == 3 ; teleport
			RET_4()								; func_id == 4 ; teleport
			RET_4()								; func_id == 5 ; teleport
			RET_4()								; func_id == 6
			RET_4()								; func_id == 7
			RET_4()								; func_id == 8
			RET_4()								; func_id == 9
			JMP_4( hero_sword_func_triggers)	; func_id == 10
			JMP_4( hero_sword_func_container)	; func_id == 11
			JMP_4( hero_sword_func_door)		; func_id == 12
			JMP_4( hero_sword_func_breakable)	; func_id == 13 ; breakable
			RET_4()								; func_id == 14
			RET_4()								; func_id == 15 ; collision

hero_sword_init:
			; prevent a sword from spawning if it's not available
			lda hero_res_sword
			CPI_WITH_ZERO(0)
			jnc @no_sword

			lxi h, bullet_update_ptr+1
			mvi e, BULLET_RUNTIME_DATA_LEN
			call actor_get_empty_data_ptr
			rnz ; return because too many objects

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
			mvi m, ACTOR_STATUS_BIT_INVIS
			; advance and set bullet_status_timer
			inx h
			mvi m, HERO_SWORD_STATUS_INVIS_DURATION

			; tmp b = 0
			mvi b, 0
			; advance hl to bullet_pos_y+1
			LXI_D_TO_DIFF(bullet_pos_y+1, bullet_status_timer)
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
			LXI_D_TO_DIFF(bullet_erase_scr_addr_old+1, bullet_erase_wh_old)
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
			lxi h, HERO_SWORD_COLLISION_OFFSET_X_L<<8 | HERO_SWORD_COLLISION_OFFSET_Y_L
			jnc @left
@right:
			lxi h, HERO_SWORD_COLLISION_OFFSET_X_R<<8 | HERO_SWORD_COLLISION_OFFSET_Y_R
@left:
			dad d
			xchg
			; de - pos_xy
			TILEDATA_HANDLING(HERO_SWORD_COLLISION_WIDTH, HERO_SWORD_COLLISION_HEIGHT, hero_sword_tile_func_tbl)
			ret


; anim and a gameplay logic update
; in:
; de - ptr to bullet_update_ptr in the runtime data
hero_sword_update:
			; advance to bullet_status
			LXI_H_TO_DIFF(bullet_status, bullet_update_ptr)
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
			jz @destroy

@attkAnimUpdate:
			; advance to bullet_anim_timer
			inx h
			mvi a, HERO_SWORD_ANIM_SPEED_ATTACK
			jmp actor_anim_update

@destroy:
			LXI_D_TO_DIFF(bullet_update_ptr+1, bullet_status_timer)
			dad d
			jmp actor_destroy

@delay_update:
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
			INX_H(2)
			mvi m, 0
			; advance and set bullet_anim_ptr
			inx h
			lda hero_dir_x
			rrc
			jnc @attkL
@attkR:
			mvi m, < hero_sword_attk_r
			inx h
			mvi m, > hero_sword_attk_r

			; check enemies-attk01 sprite collision
			; hl - ptr to bullet_anim_ptr+1
			; advance hl to bullet_pos_x+1
			HL_ADVANCE_BY_DIFF_BC(bullet_pos_x+1, bullet_anim_ptr+1)
			; add a collision offset
			mov d, m
			INX_H(2)
			mov e, m
			lxi h, HERO_SWORD_COLLISION_OFFSET_X_R<<8 | HERO_SWORD_COLLISION_OFFSET_Y_R
			dad d
			jmp @check_monster_collision
@attkL:
			mvi m, < hero_sword_attk_l
			inx h
			mvi m, > hero_sword_attk_l

			; check enemies-attk01 sprite collision
			; hl - ptr to bullet_anim_ptr+1
			; advance hl to bullet_pos_x+1
			HL_ADVANCE_BY_DIFF_BC(bullet_pos_x+1, bullet_anim_ptr+1)
			; add a collision offset
			mov d, m
			INX_H(2)
			mov e, m
			lxi h, HERO_SWORD_COLLISION_OFFSET_X_L<<8 | HERO_SWORD_COLLISION_OFFSET_Y_L
			dad d

@check_monster_collision:
			; store pos_xy
			push h
			; check if a bullet collides with a monster
			mvi a, HERO_SWORD_COLLISION_WIDTH-1
			mvi c, HERO_SWORD_COLLISION_HEIGHT-1
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
			TILEDATA_HANDLING(HERO_SWORD_COLLISION_WIDTH, HERO_SWORD_COLLISION_HEIGHT, hero_sword_tile_func_tbl)
			ret

; in:
; a - container_id
; c - tile_idx
hero_sword_func_container:
			; store tile_idx
			lxi h, @tile_idx + 1
			mov m, c

			sta @restore_container_id+1
			; find a container
			lxi h, room_id
			mov d, m
			mov l, a
			FIND_INSTANCE(@no_container_found, containers_inst_data_ptrs)
			; c = tile_idx
			; hl ptr to tile_idx
			; remove this container from containers_inst_data
			inx h
			mvi m, <CONTAINERS_STATUS_ACQUIRED

@no_container_found:
			; erase container_id from tiledata
			mvi b, >room_tiledata
			mvi a, TILEDATA_RESTORE_TILE
			stax b
			; calc tile gfx ptr
			mov l, c
			mvi h, 0
			lxi d, room_tiles_gfx_ptrs
			dad h
			dad d
			mov d, c
			; d - tile_idx
			; read a tile gfx ptr
			mov c, m
			inx h
			mov b, m

			; calc tile scr addr
			; d - tile_idx
			mvi a, %11110000
			ana d
			mov e, a
			; e - scr Y
			mvi a, %00001111
			ana d
			rlc
			adi >SCR_BUFF0_ADDR
			mov d, a

			; bc - a tile gfx ptr
			; de - screen addr
			push d ; for vfx

			push b
			push d
			; draw a tile on the screen
			lda level_ram_disk_s_gfx
			CALL_RAM_DISK_FUNC_BANK(draw_tile_16x16)
			pop d
			pop b
			push b
			push d
			; draw a tile in the back buffer
			lda level_ram_disk_s_gfx
			ori __RAM_DISK_M_BACKBUFF | RAM_DISK_M_AF
			CALL_RAM_DISK_FUNC_BANK(draw_tile_16x16)
			pop d
			pop b
			; draw a tile in the back buffer2
			lda level_ram_disk_s_gfx
			ori __RAM_DISK_M_BACKBUFF2 | RAM_DISK_M_AF
			CALL_RAM_DISK_FUNC_BANK(draw_tile_16x16)
@tile_idx:
			mvi c, TEMP_BYTE
			; c - tile_idx in the room_tiledata array
			lda @restore_container_id+1
			ADD_A(2) ; container_id to JMP_4 ptr
			sta room_decal_draw_ptr_offset+1
			ROOM_DECAL_DRAW(__containers_opened_gfx_ptrs, true)

			; draw vfx
			pop b
			lxi d, vfx_reward
			call vfx_init

			; update a hero container
			lxi h, hero_cont_func_tbl
@restore_container_id:
			mvi a, TEMP_BYTE
			mov e, a ; temp
			HL_TO_AX4_PLUS_INT16(hero_cont_func_tbl)
			push h

			; add score points
			; e - container_id
			mvi c, TILEDATA_FUNC_ID_CONTAINERS
			CALL_RAM_DISK_FUNC(__game_score_add, __RAM_DISK_S_SCORE | __RAM_DISK_M_TEXT_EX)
			call game_ui_draw_score
			pop h
			; hl - a container handler func ptr
			pchl ; run a container handler

; in:
; a - door_id
; c - tile_idx
hero_sword_func_door:
			; store tile_idx
			lxi h, @tile_idx + 1
			mov m, c

			mov b, a ; temp b = door_id
			; check global item status
			ani %00001110
			rrc

			adi <global_items
			mov l, a
			mvi h, >global_items
			mov a, m
			cpi <ITEM_STATUS_NOT_ACQUIRED
			rz	; if status == ITEM_STATUS_NOT_ACQUIRED, means a hero does't have a proper key to open the door

			mov a, b
			ADD_A(2) ; to make a JMP_4 ptr
			sta room_decal_draw_ptr_offset+1 ; store door_id in case we need to draw an opened version of it

			; update the key status
			mvi m, <ITEM_STATUS_USED

			; add score points
			push b
			mov e, b
			mvi c, TILEDATA_FUNC_ID_DOORS
			CALL_RAM_DISK_FUNC(__game_score_add, __RAM_DISK_S_SCORE)
			call game_ui_draw_score
			pop b

			; erase breakable_id from tiledata
			mvi b, >room_tiledata
			mvi a, TILEDATA_RESTORE_TILE
			stax b
			; calc tile gfx ptr
			mov l, c
			mvi h, 0
			lxi d, room_tiles_gfx_ptrs
			dad h
			dad d
			mov d, c
			; d - tile_idx
			; read a tile gfx ptr
			mov c, m
			inx h
			mov b, m

			; calc tile scr addr
			; d - tile_idx
			mvi a, %11110000
			ana d
			mov e, a
			; e - scr Y
			mvi a, %00001111
			ana d
			rlc
			adi >SCR_BUFF0_ADDR
			mov d, a

			; bc - a tile gfx ptr
			; de - screen addr
			push d ; for vfx

			push b
			push d
			; draw a tile on the screen
			lda level_ram_disk_s_gfx
			CALL_RAM_DISK_FUNC_BANK(draw_tile_16x16)
			pop d
			pop b

			push b
			push d
			; draw a tile in the back buffer
			lda level_ram_disk_s_gfx
			ori __RAM_DISK_M_BACKBUFF | RAM_DISK_M_AF
			CALL_RAM_DISK_FUNC_BANK(draw_tile_16x16)
			pop d
			pop b

			; draw a tile in the back buffer2
			lda level_ram_disk_s_gfx
			ori __RAM_DISK_M_BACKBUFF2 | RAM_DISK_M_AF
			CALL_RAM_DISK_FUNC_BANK(draw_tile_16x16, )

@tile_idx:
			mvi c, TEMP_BYTE
			; c - tile_idx in the room_tiledata array
			ROOM_DECAL_DRAW(__doors_opened_gfx_ptrs, true)

			; draw vfx
			pop b
			lxi d, vfx_puff
			jmp vfx_init

; in:
; a - breakable_id
; c - tile_idx
hero_sword_func_breakable:
			mov e, a
			; check if a sword is available
			lda hero_res_sword
			CPI_WITH_ZERO(0)
			rz ; return if no sword

			; if breakable_id == BREAKABLE_ID_CABBAGE, spawn a fart bullet
			; e - breakable_id
			mvi a, BREAKABLE_ID_CABBAGE
			cmp e
			jnz @no_fart
@cabbage:
			mvi a, CABBAGE_HEALH_VAL
			push b
			call hero_health_increase
			pop b
			; add the cabbage resource
			lxi h, hero_res_cabbage
			inr m
			mvi a, CABBAGE_MAX
			cmp m
			jnz @no_fart
			mvi m, 0
			; a hero got fart
			lxi h, global_items + ITEM_ID_FART - 1	; because the first item_id = 1
			mov a, m
			CPI_WITH_ZERO(ITEM_STATUS_NOT_ACQUIRED)
			jnz @no_new_fart
			mvi m, ITEM_STATUS_ACQUIRED
@no_new_fart:

			push b ; store tile_idx
			; spawn the fart actor
			lxi h, hero_erase_scr_addr
			mov c, m
			inx h
			mov b, m
			lxi d, vfx_puff_loop
			call fart_init
			pop b ; restore tile_idx

@no_fart:
			; add score points
			push b
			mvi c, TILEDATA_FUNC_ID_BREAKABLES
			CALL_RAM_DISK_FUNC(__game_score_add, __RAM_DISK_S_SCORE)
			call game_ui_draw_score
			pop b

			; erase breakable_id from tiledata
			mvi b, >room_tiledata
			mvi a, TILEDATA_RESTORE_TILE
			stax b
			; calc tile gfx ptr
			mov l, c
			mvi h, 0
			lxi d, room_tiles_gfx_ptrs
			dad h
			dad d
			mov d, c
			; d - tile_idx
			; read a tile gfx ptr
			mov c, m
			inx h
			mov b, m

			; calc tile scr addr
			; d - tile_idx
			mvi a, %11110000
			ana d
			mov e, a
			; e - scr Y
			mvi a, %00001111
			ana d
			rlc
			adi >SCR_BUFF0_ADDR
			mov d, a

			; bc - a tile gfx ptr
			; de - screen addr
			push b
			push d
			; draw a tile on the screen
			lda level_ram_disk_s_gfx
			CALL_RAM_DISK_FUNC_BANK(draw_tile_16x16)
			pop d
			pop b
			push b
			push d
			; draw a tile in the back buffer
			lda level_ram_disk_s_gfx
			ori __RAM_DISK_M_BACKBUFF | RAM_DISK_M_AF
			CALL_RAM_DISK_FUNC_BANK(draw_tile_16x16)
			pop d
			pop b
			push d
			; draw a tile in the back buffer2
			lda level_ram_disk_s_gfx
			ori __RAM_DISK_M_BACKBUFF2 | RAM_DISK_M_AF
			CALL_RAM_DISK_FUNC_BANK(draw_tile_16x16)

			; draw vfx
			pop b
			lxi d, vfx_puff
			call vfx_init

			ret
			ROOM_SPAWN_RATE_UPDATE(rooms_spawn_rate_breakables, BREAKABLE_SPAWN_RATE_DELTA, BREAKABLE_SPAWN_RATE_MAX)

; in:
; a - trigger_id
; c - tile_idx
hero_sword_func_triggers:
			push psw
			mvi c, TILEDATA_FUNC_ID_TRIGGERS
			mov e, a
			CALL_RAM_DISK_FUNC(__game_score_add, __RAM_DISK_S_SCORE)
			pop psw
			cpi TIMEDATA_TRIGGER_HOME_DOOR
			jz @game_over
			cpi TIMEDATA_TRIGGER_FRIEND_DOOR
			jz @friends_home_door
			ret
@game_over:
			; init a dialog
			jmp trigger_hero_knocks_his_home_door

@friends_home_door:
			jmp trigger_hero_knocks_his_friend_door

; draw a sprite into a backbuffer
; in:
; de - ptr to bullet_draw_ptr in the runtime data
hero_sword_draw:
			BULLET_DRAW(sprite_get_scr_addr_hero_sword, __RAM_DISK_S_HERO_SWORD)