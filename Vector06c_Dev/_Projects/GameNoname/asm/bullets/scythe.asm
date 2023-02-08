; mob AI:
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
;		try to move a mob
;		if mob collides with tiles:
;			if status = moveBackward:
;				die
;			else:
;				status = moveBackward
;		else:
;			accept new pos
;			updateAnim
;			check mod-hero collision, impact if collides
; moveBackward:
;	decr statusTimer
;	if statusTimer = 0
;		death
;	else:
;		try to move a mob
;		if mob collides with tiles:
;			death
;		else:
;			accept new pos
;			updateAnim
;			check mod-hero collision, impact if collides


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
ScytheInit:
			sta @dir+1 ; direction (BULLET_DIR_*) ; TODO: move dir calc over this func. use A reg for a bullet_id
			call bullets_get_empty_data_ptr
			; hl - ptr to bullet_update_ptr+1
			; advance hl to bullet_update_ptr
			dcx h
			mvi m, <ScytheUpdate
			inx h 
			mvi m, >ScytheUpdate
			; advance hl to bullet_draw_ptr
			inx h 
			mvi m, <ScytheDraw
			inx h 
			mvi m, >ScytheDraw
			
			; advance hl to bullet_id
			inx h
;@bullet_id:	mvi a, TEMP_BYTE
			;mov m, a

			; advance hl to bullet_status
			inx h
			mvi m, SCYTHE_STATUS_MOVE_THROW
			; advance and set bullet_status_timer
			inx h
			mvi m, SCYTHE_STATUS_MOVE_TIME
			; advance hl to bulletAnimPtr
			inx_h(2)
			mvi m, <scythe_run
			inx h
			mvi m, >scythe_run

			mov a, b
			; a - posX
			; scrX = posX/8 + $a0
			rrc_(3)
			ani %00011111
			adi SPRITE_X_SCR_ADDR
			mvi e, 0
			; a = scrX
			; b = posX
			; c = posY			
			; e = 0 and SPRITE_W_PACKED_MIN
			; hl - ptr to bulletEraseScrAddrOld			
			
			; advance hl to bulletEraseScrAddr
			inx h
			mov m, c
			inx h
			mov m, a
			; advance hl to bulletEraseScrAddrOld
			inx h
			mov m, c
			inx h
			mov m, a
			; advance hl to bulletEraseWH
			inx h
			mvi m, SPRITE_H_MIN
			inx h
			mov m, e
			; advance hl to bulletEraseWHOld
			inx h
			mvi m, SPRITE_H_MIN
			inx h
			mov m, e
			; advance hl to bulletPosX
			inx h
			mov m, e
			inx h
			mov m, b
			; advance hl to bulletPosY
			inx h
			mov m, e
			inx h
			mov m, c
			; advance hl to bulletSpeedX
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
			; advance hl to bulletSpeedY
			inx h
			mvi m, <SCYTHE_MOVE_SPEED_NEG
			inx h
			mvi m, >SCYTHE_MOVE_SPEED_NEG
			ret	
@moveUp:
			mov m, e
			inx h
			mov m, e
			; advance hl to bulletSpeedY
			inx h
			mvi m, <SCYTHE_MOVE_SPEED
			inx h
			mvi m, >SCYTHE_MOVE_SPEED
			ret
@moveLeft:
			mvi m, <SCYTHE_MOVE_SPEED_NEG
			inx h
			mvi m, >SCYTHE_MOVE_SPEED_NEG
			; advance hl to bulletSpeedY
			inx h			
			mov m, e
			inx h
			mov m, e
			ret			
@moveRight:
			mvi m, <SCYTHE_MOVE_SPEED
			inx h
			mvi m, >SCYTHE_MOVE_SPEED
			; advance hl to bulletSpeedY
			inx h			
			mov m, e
			inx h
			mov m, e
			ret
			
; anim and a gameplay logic update
; in:
; de - ptr to bullet_update_ptr in the runtime data
ScytheUpdate:
			; advance to bullet_status_timer
			LXI_H_TO_DIFF(bullet_status_timer, bullet_update_ptr)
			dad d
@updateMove:
			dcr m
			jz @die
@updateMovement:
			ACTOR_UPDATE_MOVEMENT_CHECK_TILE_COLLISION(bullet_status_timer, bulletPosX, SCYTHE_COLLISION_WIDTH, SCYTHE_COLLISION_HEIGHT, @setBounceAfterTileCollision) 
			
			; hl points to bulletPosY+1
			; advance hl to bullet_anim_timer
			LXI_B_TO_DIFF(bullet_anim_timer, bulletPosY+1)
			dad b
			mvi a, SCYTHE_ANIM_SPEED_MOVE
			BULLET_UPDATE_ANIM_CHECK_COLLISION_HERO(SCYTHE_COLLISION_WIDTH, SCYTHE_COLLISION_HEIGHT, SCYTHE_DAMAGE)	
@dieAfterDamage:
			; advance hl to bullet_update_ptr+1
			LXI_B_TO_DIFF(bullet_update_ptr+1, bulletPosY+1)
			dad b
			jmp bullets_destroy
@setBounceAfterTileCollision:
			pop h
			; hl points to posX
			; advance hl to bullet_status_timer
			LXI_B_TO_DIFF(bullet_status_timer, bulletPosX)
			dad b
@setBounce:
			; hl - ptr to bullet_status_timer
			; advance hl to bullet_status
			dcx h
			mvi m, SCYTHE_STATUS_MOVE_BOUNCE
			; advance hl to bulletSpeedX
			LXI_B_TO_DIFF(bulletSpeedX, bullet_status)
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
			; advance hl to bulletSpeedY+1
			inx_h(2)
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
ScytheDraw:
			BULLET_DRAW(SpriteGetScrAddr_scythe, __RAM_DISK_S_SCYTHE)