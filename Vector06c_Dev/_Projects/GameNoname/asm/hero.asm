HERO_RUN_SPEED		= $0200 ; low byte is a subpixel speed, high byte is a speed in pixels
HERO_RUN_SPEED_D	= $016a ; for diagonal moves

; hero statuses.
; a status describes what set of animations and behavior is active
; for ex. HERO_STATUS_ATTACK plays hero_r_attk or hero_l_attk depending on the direction and it spawns a weapon trail
HERO_STATUS_IDLE		= 0
HERO_STATUS_ATTACK		= 1
HERO_STATUS_INVINCIBLE	= 2

; duration of statuses (in updateDurations)
HERO_STATUS_ATTACK_DURATION	= 12
HERO_STATUS_INVINCIBLE_DURATION = 50

; animation speed (the less the slower, 0-255, 255 means next frame every update)
HERO_ANIM_SPEED_MOVE	= 65
HERO_ANIM_SPEED_IDLE	= 4
HERO_ANIM_SPEED_ATTACK	= 80

; gameplay
HERO_HEALTH_MAX = 100

HERO_COLLISION_WIDTH = 15
HERO_COLLISION_HEIGHT = 11

; hero runtime data
; this's a struct. do not change the layout
hero_update_ptr:		.word hero_update
hero_draw_ptr:			.word hero_draw
hero_impacted_ptr:		.word hero_impacted ; called by a monster's bullet, a monster, etc. to affect a hero
hero_type:				.byte MONSTER_TYPE_ALLY
hero_health:			.byte HERO_HEALTH_MAX
hero_status:			.byte HERO_STATUS_IDLE ; a status describes what set of animations and behavior is active
hero_status_timer:		.byte 0	; a duration of the status. ticks every update
hero_anim_timer:		.byte TEMP_BYTE ; it triggers an anim frame switching when it overflows
hero_anim_addr:			.word TEMP_ADDR ; holds the current frame ptr
hero_dir_x:				.byte 1 		; 1-right, 0-left
hero_erase_scr_addr:	.word TEMP_ADDR
hero_erase_scr_addr_old .word TEMP_ADDR
hero_erase_wh:			.word TEMP_WORD
hero_erase_wh_old:		.word TEMP_WORD
hero_pos_x:				.word TEMP_WORD
hero_pos_y:				.word TEMP_WORD
hero_speed_x:			.word TEMP_WORD
hero_speed_y:			.word TEMP_WORD
hero_data_prev_pptr:	.word DRAW_LIST_FIRST_DATA_MARKER
hero_data_next_pptr:	.word monster_data_next_pptr
;
hero_collision_func_table:
			; bit layout:
			; 0, 0, (bottom-left), (bottom-right), (top_right), (top-left), 0, 0
			jmp_4( hero_no_collision)
			jmp_4( hero_check_collision_top_left)
			jmp_4( hero_check_collision_top_right)
			jmp_4( hero_move_horizontally)
			jmp_4( hero_check_collision_bottom_right)
			jmp_4( hero_check_tiledata)
			jmp_4( hero_move_vertically)
			jmp_4( hero_check_tiledata)
			jmp_4( hero_check_collision_bottom_left)
			jmp_4( hero_move_vertically)
			jmp_4( hero_check_tiledata)
			jmp_4( hero_check_tiledata)
			jmp_4( hero_move_horizontally)
			jmp_4( hero_check_tiledata)
			jmp_4( hero_check_tiledata)
			jmp_4( hero_check_tiledata)

; funcs to handle the tiledata. more info is in level_data.asm->room_tiledata
hero_tile_func_table:
			jmp_4( 0)						; func_id == 1
			jmp_4( hero_tile_func_teleport)	; func_id == 2
			jmp_4( 0)						; func_id == 3
			jmp_4( 0)						; func_id == 4
			jmp_4( 0)						; func_id == 5
			jmp_4( 0)						; func_id == 6
			jmp_4( 0)						; func_id == 7
			jmp_4( 0)						; func_id == 8
			jmp_4( 0)						; func_id == 9
			jmp_4( 0)						; func_id == 10
			jmp_4( 0)						; func_id == 11
			jmp_4( 0)						; func_id == 12
			jmp_4( 0)						; func_id == 13
			jmp_4( 0)						; func_id == 14
			ret_4()							; func_id == 15 (collision) called only when a hero is stuck into collision tiles

hero_init:
			call hero_idle_start
			lxi h, KEY_NO << 8 | KEY_NO
			shld key_code

			lxi h, hero_pos_x+1
			call sprite_get_scr_addr8
			xchg
			shld hero_erase_scr_addr_old
			; 16x15 size
			lxi h, SPRITE_W_PACKED_MIN<<8 | SPRITE_H_MIN
			shld hero_erase_wh_old
			ret

; input:
; b - posX
; c - posY
; use:
; a
hero_set_pos:
			mov a, b
			sta hero_pos_x+1
			mov a, c
			sta hero_pos_y+1
			ret

.macro HERO_UPDATE_ANIM(anim_speed)
			; anim idle update
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
			cpi HERO_STATUS_INVINCIBLE
			cz hero_invincible_update

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

			mvi a, 1
			sta hero_dir_x
			lxi h, hero_r_run
			shld hero_anim_addr
			jmp hero_update_temp_pos

@setAnimRunRU:
			cpi KEY_RIGHT & KEY_UP
			jnz @setAnimRunRD

			lxi h, HERO_RUN_SPEED_D
			shld hero_speed_x
			shld hero_speed_y

			mvi a, 1
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

			mvi a, 1
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

			xra a
			sta hero_dir_x
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

			xra a
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

			xra a
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

			lda hero_dir_x
			ora a
			jz @setAnimRunUfaceL

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

			lda hero_dir_x
			ora a
			jz @setAnimRunDfaceL
			lxi h, hero_r_run
			shld hero_anim_addr
			jmp hero_update_temp_pos
@setAnimRunDfaceL:
			lxi h, hero_l_run
			shld hero_anim_addr
			;jmp hero_update_temp_pos

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
			CALL_RAM_DISK_FUNC(room_get_tiledata, __RAM_DISK_M_BACKBUFF2 | RAM_DISK_M_89, false, false)
			jz hero_no_collision_no_tiledata;  ; if there is no tiledata to analize, move a hero and return
@collides:
			; check if there is any collidable tiledata
			; de - (bottom-left), (top-left), 
			; hl - (top-right), (bottom-right)			
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
			mov a, h
			add b
			mov a, c
			ral
			mov c, a

			; check the top-right corner
			mov a, l
			add b
			mov a, c
			ral
			mov c, a

			; check the top-left corner
			mov a, d
			add b
			mov a, c
			ral
			add_a(2)
			mov c, a

			; handle a collision data around a hero
			; if a hero is inside the collision, move him out
			lxi h, hero_collision_func_table
			mvi b, 0
			dad b
			pchl

; handle tiledata around a hero.
hero_check_tiledata:
			lxi h, hero_pos_x+1
			mov d, m
			inx_h(2)
			mov e, m
			lxi b, (HERO_COLLISION_WIDTH-1)<<8 | HERO_COLLISION_HEIGHT-1
			CALL_RAM_DISK_FUNC(room_get_tiledata, __RAM_DISK_M_BACKBUFF2 | RAM_DISK_M_89, false, false)
			rz ; return if there is no tiledata to analize
hero_do_not_get_tiledata_around:	
			lxi h, room_get_tiledata_buff
			mvi c, 4
@loop:		TILEDATA_HANDLE_FUNC_CALL(hero_tile_func_table-JMP_4_LEN, true)
			inx h
			dcr c
			jnz @loop
			ret

; we are here when a hero does not collide with colladable tiles, and there is no tiledata round
hero_no_collision_no_tiledata:
			lhld char_temp_x
			shld hero_pos_x
			lhld char_temp_y
			shld hero_pos_y
			ret

; we are here when a hero does not collides with collidable tiles, but there is some tiledata around, ex. teleport
hero_no_collision:
			lhld char_temp_x
			shld hero_pos_x
			lhld char_temp_y
			shld hero_pos_y
			jmp hero_do_not_get_tiledata_around

hero_check_collision_top_left:
			lda char_temp_x+1
			; get the inverted offset_x inside the tile
			cma
			ani %00001111
			mov c, a
			lda char_temp_y+1
			adi HERO_COLLISION_HEIGHT-1
			; get the offset_y inside the tile
			ani %00001111
			cmp c
			jz hero_move_tile_br
			jnc hero_move_tile_r
			jmp hero_move_tile_b

hero_check_collision_top_right:
			lda char_temp_x+1
			adi HERO_COLLISION_WIDTH-1
			; get the offset inside the tile
			ani %00001111
			mov c, a
			lda char_temp_y+1
			adi HERO_COLLISION_HEIGHT-1
			; get the offset inside the tile
			ani %00001111
			cmp c
			jz hero_move_tile_bl
			jc hero_move_tile_b
			jmp hero_move_tile_l

hero_check_collision_bottom_left:
			lda char_temp_x+1
			; get the offset inside the tile
			cma
			ani %00001111
			mov c, a
			lda char_temp_y+1
			; get the offset inside the tile
			cma
			ani %00001111
			cmp c
			jz hero_move_tile_tr
			jc hero_move_tile_t
			jmp hero_move_tile_r

hero_check_collision_bottom_right:
			lda char_temp_x+1
			adi HERO_COLLISION_WIDTH-1
			; get the offset inside the tile
			ani %00001111
			mov c, a
			lda char_temp_y+1
			; get the offset inside the tile
			cma
			ani %00001111
			cmp c
			jz hero_move_tile_tl
			jc hero_move_tile_t
			jmp hero_move_tile_l

; move the hero to the right out of of the collided tile
hero_move_tile_r:
			lda char_temp_x+1
			stc		; to move outside the current tile
			adc c
			sta hero_pos_x+1
			lhld char_temp_y
			shld hero_pos_y
			jmp hero_check_tiledata

; move the hero under the collided tile
hero_move_tile_b:
			lhld char_temp_x
			shld hero_pos_x
			mov c, a
			lda char_temp_y+1
			stc		; to move outside the current tile
			sbb c
			sta hero_pos_y+1
			jmp hero_check_tiledata

; move the hero to the bottom-right corner of the collided tile
hero_move_tile_br:
			lxi h, char_temp_x+1
			stc		; to move outside the current tile
			adc m
			sta hero_pos_x+1
			inx_h(2)
			mov a, m
			stc		; to move outside the current tile
			sbb c
			sta hero_pos_y+1
			jmp hero_check_tiledata

; move the hero to the left out of of the collided tile
hero_move_tile_l:
			lda char_temp_x+1
			stc		; to move outside the current tile
			sbb c
			sta hero_pos_x+1
			lhld char_temp_y
			shld hero_pos_y
			jmp hero_check_tiledata

; move the hero to the bottom-left corner of the collided tile
hero_move_tile_bl:
			lxi h, char_temp_x+1
			sub m
			cma
			sta hero_pos_x+1
			inx_h(2)
			mov a, m
			stc		; to move outside the current tile
			sbb c
			sta hero_pos_y+1
			jmp hero_check_tiledata

; move the hero on top of the collided tile
hero_move_tile_t:
			lhld char_temp_x
			shld hero_pos_x
			mov c, a
			lda char_temp_y+1
			stc		; to move outside the current tile
			adc c
			sta hero_pos_y+1
			jmp hero_check_tiledata

; move the hero to the top-right corner of the collided tile
hero_move_tile_tr:
			lxi h, char_temp_x+1
			stc		; to move outside the current tile
			adc m
			sta hero_pos_x+1
			inx_h(2)
			mov a, m
			stc		; to move outside the current tile
			adc c
			sta hero_pos_y+1
			jmp hero_check_tiledata

; move the hero to the top-left corner of the collided tile
hero_move_tile_tl:
			lxi h, char_temp_x+1
			sub m
			cma
			sta hero_pos_x+1
			inx_h(2)
			mov a, m
			stc		; to move outside the current tile
			adc c
			sta hero_pos_y+1
			jmp hero_check_tiledata

; when the hero runs into a tile from top or bottom, move him only horizontally
hero_move_horizontally:
			; do not move vertically
			lhld char_temp_x
			shld hero_pos_x
			jmp hero_check_tiledata

; when the hero runs into a tile from left or right, move him only vertically
hero_move_vertically:
			; do not move horizontally
			lhld char_temp_y
			shld hero_pos_y
			jmp hero_check_tiledata

; load a new room with room_id, move the hero to an
; appropriate position based on his current posXY
; input:
; a - room_id
hero_tile_func_teleport:
			pop h

			; update a room id to teleport there
			sta room_idx
			; requesting room loading
			mvi a, LEVEL_COMMAND_LOAD_DRAW_ROOM
			sta level_command
			; bypassing the hero_check_tiledata:@loop because the hero is teleporting
			; so we don't need to handle the rest of the colllided tiles.
			; return to the func that called hero_update
			pop b

			; check if the teleport on the left or right side
			lda hero_pos_x+1
			cpi (ROOM_WIDTH - 1 ) * TILE_WIDTH - HERO_COLLISION_WIDTH
			jnc @teleportRightToLeft
			cpi TILE_WIDTH
			jc @teleportLeftToRight
			; check if the teleport on the top or bottom side
			lda hero_pos_y+1
			cpi (ROOM_HEIGHT - 1 ) * TILE_HEIGHT - HERO_COLLISION_HEIGHT
			jnc @teleportTopToBottom
			cpi TILE_HEIGHT
			jc @teleportBottomToTop
			; teleport keeping the same pos
			ret

@teleportRightToLeft:
			mvi a, TILE_WIDTH
			sta hero_pos_x+1
			ret

@teleportLeftToRight:
			mvi a, (ROOM_WIDTH - 1 ) * TILE_WIDTH - HERO_COLLISION_WIDTH
			sta hero_pos_x+1
			ret

@teleportTopToBottom:
			mvi a, TILE_HEIGHT
			sta hero_pos_y+1
			ret
@teleportBottomToTop:
			mvi a, (ROOM_HEIGHT - 1 ) * TILE_HEIGHT - HERO_COLLISION_HEIGHT
			sta hero_pos_y+1
			ret

hero_attack_start:
			; set status
			mvi a, HERO_STATUS_ATTACK
			sta hero_status
			mvi a, HERO_STATUS_ATTACK_DURATION
			sta hero_status_timer
			; reset anim timer
			xra a
			sta hero_anim_timer

			; speed = 0
			lxi h, 0
			shld hero_speed_x
			shld hero_speed_y
			; set direction
			lda hero_dir_x
			ora a
			jz @setAnimAttkL

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
			ora a
			jz @setAnimIdleL

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
			; set status
			mvi a, HERO_STATUS_INVINCIBLE
			sta hero_status
			mvi a, HERO_STATUS_INVINCIBLE_DURATION
			sta hero_status_timer
			ret

hero_invincible_update:
			lxi h, hero_status_timer
			dcr m
			rnz
			jmp hero_idle_start


; handle the damage
; in:
; c - damage (positive number)
hero_impacted:
			lda hero_status
			cpi HERO_STATUS_INVINCIBLE
			rz

			call hero_invincible_start

			lxi h, hero_health
			mov a, m
			sub c
			mov m, a
			; check if he dies
			push psw
			call game_ui_health_draw
			pop psw
			rnc
			; hero's dead
			; TODO: teleport the hero to the main scene if he died in the level
			; TODO: teleport the hero to the catacombs entrance if a boss killed him
			ret

hero_draw:
			lxi h, hero_pos_x+1
			call sprite_get_scr_addr_hero_r

			lhld hero_anim_addr
			call sprite_get_addr

			lda hero_dir_x
			ora a
			mvi l, <(__RAM_DISK_S_HERO_R | __RAM_DISK_M_DRAW_SPRITE_VM | RAM_DISK_M_8F)
			jnz @spriteR
@spriteL:
			mvi l, <(__RAM_DISK_S_HERO_L | __RAM_DISK_M_DRAW_SPRITE_VM | RAM_DISK_M_8F)
@spriteR:

			lda hero_status
			cpi HERO_STATUS_INVINCIBLE
			jnz @draw
@invisState:
			mvi a, %00001111
			rrc
			sta @invisState+1
			jc @draw
@invis:
			mov a, l
			CALL_RAM_DISK_FUNC_BANK(__draw_sprite_invis_vm)
			jmp @saveParams
@draw:
			mov a, l
			; TODO: optimize. consider using unrolled loops in DrawSpriteVM for sprites 15 pxs tall
			CALL_RAM_DISK_FUNC_BANK(__draw_sprite_vm)

@saveParams:
			; store an old scr addr, width, and height
			lxi h, hero_erase_scr_addr
			mov m, c
			inx h
			mov m, b
			xchg
			shld hero_erase_wh
			ret

hero_copy_to_scr:
			; get min(h, d), min(e,l)
			lhld hero_erase_scr_addr_old
			xchg
			lhld hero_erase_scr_addr
			mov a, h
			cmp d
			jc @keepCurrentX
			mov h, d
@keepCurrentX:
			mov a, l
			cmp e
			jc @keepCurrentY
			mov l, e
@keepCurrentY:
			; hl - a scr addr to copy
			push h
			; de - an old sprite scr addr
			lhld hero_erase_wh_old
			dad d
			push h
			lhld hero_erase_scr_addr
			; store as old
			shld hero_erase_scr_addr_old
			xchg
			lhld hero_erase_wh
			; store as old
			shld hero_erase_wh_old
			dad d
			; hl - current sprite top-right corner scr addr
			; de - old sprite top-right corner scr addr
			pop d
			; get the max(h, d), max(e,l)
			mov a, h
			cmp d
			jnc @keepCurrentTRX
			mov h, d
@keepCurrentTRX:
			mov a, l
			cmp e
			jnc @keepCurrentTRY
			mov l, e
@keepCurrentTRY:
			; hl - top-right corner scr addr to copy
			; de - a scr addr to copy
			pop d
			; calc bc (width, height)
			mov a, h
			sub d
			mov b, a
			mov a, l
			sub e
			mov c, a
			jmp sprite_copy_to_scr_v

hero_erase:
			; TODO: optimize. erase only that is outside of the updated hero region
			lhld hero_erase_scr_addr
			xchg
			lhld hero_erase_wh

			; check if it needs to restore the background
			;push h
			;push d
			;mvi a, -$20 ; advance DE to SCR_ADDR_0 to check the collision, to decide if we need to restore a beckground
			;add d
			;mov d, a
			;CALL_RAM_DISK_FUNC(room_check_tiledata_restorable, __RAM_DISK_M_BACKBUFF2 | RAM_DISK_M_89, false, false)
			call room_check_tiledata_restorable_v2
			;pop d
			;pop h
			lhld hero_erase_scr_addr
			xchg
			lhld hero_erase_wh


			jnz sprite_copy_to_back_buff_v ; restore a background
			CALL_RAM_DISK_FUNC(__erase_sprite, __RAM_DISK_S_BACKBUFF | __RAM_DISK_M_ERASE_SPRITE | RAM_DISK_M_8F)
			ret
			.closelabels