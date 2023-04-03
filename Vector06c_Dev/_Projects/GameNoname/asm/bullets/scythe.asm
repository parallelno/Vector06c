; bullet AI:
; init:
;	status = moveForward
;	statusTimer = moveForwardTimer
;	speed = caster dir
; moveForward:
;	decr statusTimer
;	if statusTimer = 0
;		status = moveBackward
;		statusTimer = moveBackwardTimer
;	else:
;		try to move a bullet
;		if bullet collides with tiles:
;			if status = moveBackward:
;				die
;			else:
;				status = moveBackward
;		else:
;			accept new pos
;			updateAnim
;			check bullet-hero collision
;			if bullet collides with hero:
;				impact hero
;				death
; moveBackward:
;	decr statusTimer
;	if statusTimer = 0
;		death
;	else:
;		try to move a bullet
;		if bullet collides with tiles:
;			death
;		else:
;			accept new pos
;			updateAnim
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
			call bullets_get_empty_data_ptr
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
			jz @moveRight
			cpi BULLET_DIR_L
			jz @moveLeft
			cpi BULLET_DIR_U
			jz @moveUp
@moveDown:
			mov m, e
			inx h
			mov m, e
			; advance hl to bullet_speed_y
			inx h
			mvi m, <SCYTHE_MOVE_SPEED_NEG
			inx h
			mvi m, >SCYTHE_MOVE_SPEED_NEG
			ret	
@moveUp:
			mov m, e
			inx h
			mov m, e
			; advance hl to bullet_speed_y
			inx h
			mvi m, <SCYTHE_MOVE_SPEED
			inx h
			mvi m, >SCYTHE_MOVE_SPEED
			ret
@moveLeft:
			mvi m, <SCYTHE_MOVE_SPEED_NEG
			inx h
			mvi m, >SCYTHE_MOVE_SPEED_NEG
			; advance hl to bullet_speed_y
			inx h			
			mov m, e
			inx h
			mov m, e
			ret			
@moveRight:
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
@updateMove:
			dcr m
			jz @die
@updateMovement:
			ACTOR_UPDATE_MOVEMENT_CHECK_TILE_COLLISION(bullet_status_timer, bullet_pos_x, SCYTHE_COLLISION_WIDTH, SCYTHE_COLLISION_HEIGHT, @setBounceAfterTileCollision) 
			
			; hl points to bullet_pos_y+1
			; advance hl to bullet_anim_timer
			LXI_B_TO_DIFF(bullet_anim_timer, bullet_pos_y+1)
			dad b
			mvi a, SCYTHE_ANIM_SPEED_MOVE
			BULLET_UPDATE_ANIM_CHECK_COLLISION_HERO(SCYTHE_COLLISION_WIDTH, SCYTHE_COLLISION_HEIGHT, SCYTHE_DAMAGE)	
@dieAfterDamage:
			; advance hl to bullet_update_ptr+1
			LXI_B_TO_DIFF(bullet_update_ptr+1, bullet_pos_y+1)
			dad b
			jmp bullets_destroy
@setBounceAfterTileCollision:
			pop h
			; hl points to posX
			; advance hl to bullet_status_timer
			LXI_B_TO_DIFF(bullet_status_timer, bullet_pos_x)
			dad b
@setBounce:
			; hl - ptr to bullet_status_timer
			; advance hl to bullet_status
			dcx h
			mvi m, SCYTHE_STATUS_MOVE_BOUNCE
			; advance hl to bullet_speed_x
			LXI_B_TO_DIFF(bullet_speed_x, bullet_status)
			dad b
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
			LXI_B_TO_DIFF(bullet_update_ptr+1, bullet_status_timer)
			dad b
			jmp bullets_destroy

; draw a sprite into a backbuffer
; in:
; de - ptr to bullet_draw_ptr in the runtime data
scythe_draw:
			BULLET_DRAW(sprite_get_scr_addr_scythe, __RAM_DISK_S_SCYTHE)