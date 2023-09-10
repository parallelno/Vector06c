; bullet AI:
; init:
;	status = move_forward
;	status_timer = moveForwardTimer
;	speed = caster dir
; move_forward:
;	decr status_timer
;	if status_timer = 0
;		status = move_backward
;		status_timer = moveBackwardTimer
;	else:
;		try to move a bullet
;		if bullet collides with tiles:
;			if status = move_backward:
;				die
;			else:
;				status = move_backward
;		else:
;			accept new pos
;			update_anim
;			check bullet-hero collision
;			if bullet collides with hero:
;				impact hero
;				death
; move_backward:
;	decr status_timer
;	if status_timer = 0
;		death
;	else:
;		try to move a bullet
;		if bullet collides with tiles:
;			death
;		else:
;			accept new pos
;			update_anim
;			check bullet-hero collision
;			if bullet collides with hero:
;				impact hero
;				death


SCYTHE_MOVE_SPEED		= $0400				; low byte is a subpixel speed, high byte is a speed in pixels
SCYTHE_MOVE_SPEED_NEG	= $ffff - $0400 + 1	; low byte is a subpixel speed, high byte is a speed in pixels

; statuses.
SCYTHE_STATUS_MOVE_THROW = 0
SCYTHE_STATUS_MOVE_BOUNCE = 1

; status duration in updates.
SCYTHE_STATUS_MOVE_TIME	= 25

; animation speed (the less the slower, 0-255, 255 means the next frame is almost every update)
SCYTHE_ANIM_SPEED_MOVE	= 130

; gameplay
SCYTHE_DAMAGE = 1
SCYTHE_COLLISION_WIDTH	= 12
SCYTHE_COLLISION_HEIGHT	= 12

; in:
; bc - caster pos
; a - direction
scythe_init:
			sta @dir+1 ; direction (BULLET_DIR_*) ; TODO: move dir calc over this func. use A reg for a bullet_id
			
			lxi h, bullet_update_ptr+1
			mvi e, BULLET_RUNTIME_DATA_LEN
			call actor_get_empty_data_ptr
			rnz ; return because too many objects

			; hl - ptr to bullet_update_ptr+1
			; advance hl to bullet_update_ptr
			dcx h
			mvi m, <scythe_update
			inx h 
			mvi m, >scythe_update
			; advance hl to bullet_draw_ptr
			inx h 
			mvi m, <scythe_draw
			inx h 
			mvi m, >scythe_draw
			
			; advance hl to bullet_id
			inx h
			; do not set bullet_id because it is unnecessary for this weapon
;@bullet_id:
			;mvi a, TEMP_BYTE
			;mov m, a

			; advance hl to bullet_status
			inx h
			mvi m, SCYTHE_STATUS_MOVE_THROW
			; advance and set bullet_status_timer
			inx h
			mvi m, SCYTHE_STATUS_MOVE_TIME
			; advance hl to bullet_anim_ptr
			INX_H(2)
			mvi m, <scythe_run
			inx h
			mvi m, >scythe_run

			mov a, b
			; a - posX
			; scrX = posX/8 + $a0
			RRC_(3)
			ani %00011111
			adi SPRITE_X_SCR_ADDR
			mvi e, 0
			; a = scrX
			; b = posX
			; c = posY			
			; e = 0 and SPRITE_W_PACKED_MIN
			; hl - ptr to bullet_erase_scr_addr_old			
			
			; advance hl to bullet_erase_scr_addr
			inx h
			mov m, c
			inx h
			mov m, a
			; advance hl to bullet_erase_scr_addr_old
			inx h
			mov m, c
			inx h
			mov m, a
			; advance hl to bullet_erase_wh
			inx h
			mvi m, SPRITE_H_MIN
			inx h
			mov m, e
			; advance hl to bullet_erase_wh_old
			inx h
			mvi m, SPRITE_H_MIN
			inx h
			mov m, e
			; advance hl to bullet_pos_x
			inx h
			mov m, e
			inx h
			mov m, b
			; advance hl to bullet_pos_y
			inx h
			mov m, e
			inx h
			mov m, c
			; advance hl to bullet_speed_x
			inx h
@dir:
			mvi a, TEMP_BYTE ; direction (BULLET_DIR_*)
			cpi BULLET_DIR_R
			jz @move_right
			cpi BULLET_DIR_L
			jz @move_left
			cpi BULLET_DIR_U
			jz @move_up
@move_down:
			mov m, e
			inx h
			mov m, e
			; advance hl to bullet_speed_y
			inx h
			mvi m, <SCYTHE_MOVE_SPEED_NEG
			inx h
			mvi m, >SCYTHE_MOVE_SPEED_NEG
			ret	
@move_up:
			mov m, e
			inx h
			mov m, e
			; advance hl to bullet_speed_y
			inx h
			mvi m, <SCYTHE_MOVE_SPEED
			inx h
			mvi m, >SCYTHE_MOVE_SPEED
			ret
@move_left:
			mvi m, <SCYTHE_MOVE_SPEED_NEG
			inx h
			mvi m, >SCYTHE_MOVE_SPEED_NEG
			; advance hl to bullet_speed_y
			inx h			
			mov m, e
			inx h
			mov m, e
			ret			
@move_right:
			mvi m, <SCYTHE_MOVE_SPEED
			inx h
			mvi m, >SCYTHE_MOVE_SPEED
			; advance hl to bullet_speed_y
			inx h			
			mov m, e
			inx h
			mov m, e
			ret
			
; anim and a gameplay logic update
; in:
; de - ptr to bullet_update_ptr in the runtime data
scythe_update:
			; advance to bullet_status_timer
			LXI_H_TO_DIFF(bullet_status_timer, bullet_update_ptr)
			dad d
@update_move:
			dcr m
			jz @die
@update_movement:
			ACTOR_UPDATE_MOVEMENT_CHECK_TILE_COLLISION(bullet_status_timer, bullet_pos_x, SCYTHE_COLLISION_WIDTH, SCYTHE_COLLISION_HEIGHT, @setBounceAfterTileCollision) 
			
			; hl points to bullet_pos_y+1
			; advance hl to bullet_anim_timer
			HL_ADVANCE_BY_DIFF_B(bullet_anim_timer, bullet_pos_y+1)
			mvi a, SCYTHE_ANIM_SPEED_MOVE
			BULLET_UPDATE_ANIM_CHECK_COLLISION_HERO(SCYTHE_COLLISION_WIDTH, SCYTHE_COLLISION_HEIGHT, SCYTHE_DAMAGE)	
@dieAfterDamage:
			; advance hl to bullet_update_ptr+1
			HL_ADVANCE_BY_DIFF_B(bullet_update_ptr+1, bullet_pos_y+1)
			jmp actor_destroy
@setBounceAfterTileCollision:
			pop h
			; hl points to posX
			; advance hl to bullet_status_timer
			HL_ADVANCE_BY_DIFF_B(bullet_status_timer, bullet_pos_x)
@set_bounce:
			; hl - ptr to bullet_status_timer
			; advance hl to bullet_status
			dcx h
			mvi m, SCYTHE_STATUS_MOVE_BOUNCE
			; advance hl to bullet_speed_x
			HL_ADVANCE_BY_DIFF_B(bullet_speed_x, bullet_status)
			mov a, m
			inx h
			ora m
			jz @setMoveVert
			jp @setMoveLeft
@setMoveRight:
			mvi m, >SCYTHE_MOVE_SPEED
			dcx h
			mvi m, <SCYTHE_MOVE_SPEED
			ret
@setMoveLeft:
			mvi m, >SCYTHE_MOVE_SPEED_NEG
			dcx h
			mvi m, <SCYTHE_MOVE_SPEED_NEG
			ret
@setMoveVert:		
			; advance hl to bullet_speed_y+1
			INX_H(2)
			mov a, m
			ora a
			jp @setMoveDown
@setMoveUp:			
			mvi m, >SCYTHE_MOVE_SPEED
			dcx h
			mvi m, <SCYTHE_MOVE_SPEED
			ret
@setMoveDown:			
			mvi m, >SCYTHE_MOVE_SPEED_NEG
			dcx h
			mvi m, <SCYTHE_MOVE_SPEED_NEG
			ret
@die:
			; hl points to bullet_status_timer
			; advance hl to bullet_update_ptr+1
			HL_ADVANCE_BY_DIFF_B(bullet_update_ptr+1, bullet_status_timer)
			jmp actor_destroy

; draw a sprite into a backbuffer
; in:
; de - ptr to bullet_draw_ptr in the runtime data
scythe_draw:
			BULLET_DRAW(sprite_get_scr_addr_scythe, __RAM_DISK_S_SCYTHE)