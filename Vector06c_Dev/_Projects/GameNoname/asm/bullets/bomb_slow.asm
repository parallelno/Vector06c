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


BOMB_SLOW_MOVE_SPEED		= $0400				; low byte is a subpixel speed, high byte is a speed in pixels
BOMB_SLOW_MOVE_SPEED_NEG	= $ffff - $0400 + 1	; low byte is a subpixel speed, high byte is a speed in pixels

; statuses.
BOMB_SLOW_STATUS_MOVE_THROW = 0
BOMB_SLOW_STATUS_MOVE_BOUNCE = 1

; status duration in updates.
BOMB_SLOW_STATUS_MOVE_TIME	= 25

; animation speed (the less the slower, 0-255, 255 means the next frame is almost every update)
BOMB_SLOW_ANIM_SPEED_MOVE	= 130

; gameplay
BOMB_SLOW_DAMAGE = 1
BOMB_SLOW_COLLISION_WIDTH	= 10
BOMB_SLOW_COLLISION_HEIGHT	= 10

; in:
; bc - caster posX
; a - direction
BombSlowInit:
			sta @dir+1 ; direction (BULLET_DIR_*)
			call BulletsGetEmptyDataPtr
			; hl - ptr to bulletUpdatePtr+1
			; advance hl to bulletUpdatePtr
			dcx h
			mvi m, <BombSlowUpdate
			inx h 
			mvi m, >BombSlowUpdate
			; advance hl to bulletDrawPtr
			inx h 
			mvi m, <BombSlowDraw
			inx h 
			mvi m, >BombSlowDraw

			; advance hl to bulletStatus
			inx h
			mvi m, BOMB_SLOW_STATUS_MOVE_THROW
			; advance and set bulletStatusTimer
			inx h
			mvi m, BOMB_SLOW_STATUS_MOVE_TIME
			; advance hl to bulletAnimPtr
			inx_h(2)
			mvi m, <bomb_slow_run
			inx h
			mvi m, >bomb_slow_run

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
			mvi m, <BOMB_SLOW_MOVE_SPEED_NEG
			inx h
			mvi m, >BOMB_SLOW_MOVE_SPEED_NEG
			ret	
@moveUp:
			mov m, e
			inx h
			mov m, e
			; advance hl to bulletSpeedY
			inx h
			mvi m, <BOMB_SLOW_MOVE_SPEED
			inx h
			mvi m, >BOMB_SLOW_MOVE_SPEED
			ret
@moveLeft:
			mvi m, <BOMB_SLOW_MOVE_SPEED_NEG
			inx h
			mvi m, >BOMB_SLOW_MOVE_SPEED_NEG
			; advance hl to bulletSpeedY
			inx h			
			mov m, e
			inx h
			mov m, e
			ret			
@moveRight:
			mvi m, <BOMB_SLOW_MOVE_SPEED
			inx h
			mvi m, >BOMB_SLOW_MOVE_SPEED
			; advance hl to bulletSpeedY
			inx h			
			mov m, e
			inx h
			mov m, e
			ret
			
; anim and a gameplay logic update
; in:
; de - ptr to bulletUpdatePtr in the runtime data
BombSlowUpdate:
			; advance to bulletStatusTimer
			LXI_H_TO_DIFF(bulletStatusTimer, bulletUpdatePtr)
			dad d
@updateMove:
			dcr m
			jz @die
@updateMovement:
			ACTOR_UPDATE_MOVEMENT_CHECK_TILE_COLLISION(bulletStatusTimer, bulletPosX, BOMB_SLOW_COLLISION_WIDTH, BOMB_SLOW_COLLISION_HEIGHT, @setBounceAfterTileCollision) 
			
			; hl points to bulletPosY+1
			; advance hl to bulletAnimTimer
			LXI_B_TO_DIFF(bulletAnimTimer, bulletPosY+1)
			dad b
			mvi a, BOMB_SLOW_ANIM_SPEED_MOVE
			BULLET_UPDATE_ANIM_CHECK_COLLISION_HERO(BOMB_SLOW_COLLISION_WIDTH, BOMB_SLOW_COLLISION_HEIGHT, BOMB_SLOW_DAMAGE)	
@dieAfterDamage:
			; advance hl to bulletUpdatePtr+1
			LXI_B_TO_DIFF(bulletUpdatePtr+1, bulletPosY+1)
			dad b
			jmp BulletsDestroy
@setBounceAfterTileCollision:
			pop h
			; hl points to posX
			; advance hl to bulletStatusTimer
			LXI_B_TO_DIFF(bulletStatusTimer, bulletPosX)
			dad b
@setBounce:
			; hl - ptr to bulletStatusTimer
			; advance hl to bulletStatus
			dcx h
			mvi m, BOMB_SLOW_STATUS_MOVE_BOUNCE
			; advance hl to bulletSpeedX
			LXI_B_TO_DIFF(bulletSpeedX, bulletStatus)
			dad b
			mov a, m
			inx h
			ora m
			jz @setMoveVert
			jp @setMoveLeft
@setMoveRight:
			mvi m, >BOMB_SLOW_MOVE_SPEED
			dcx h
			mvi m, <BOMB_SLOW_MOVE_SPEED
			ret
@setMoveLeft:
			mvi m, >BOMB_SLOW_MOVE_SPEED_NEG
			dcx h
			mvi m, <BOMB_SLOW_MOVE_SPEED_NEG
			ret
@setMoveVert:		
			; advance hl to bulletSpeedY+1
			inx_h(2)
			mov a, m
			ora a
			jp @setMoveDown
@setMoveUp:			
			mvi m, >BOMB_SLOW_MOVE_SPEED
			dcx h
			mvi m, <BOMB_SLOW_MOVE_SPEED
			ret
@setMoveDown:			
			mvi m, >BOMB_SLOW_MOVE_SPEED_NEG
			dcx h
			mvi m, <BOMB_SLOW_MOVE_SPEED_NEG
			ret
@die:
			; hl points to bulletStatusTimer
			; advance hl to bulletUpdatePtr+1
			LXI_B_TO_DIFF(bulletUpdatePtr+1, bulletStatusTimer)
			dad b
			jmp BulletsDestroy

; draw a sprite into a backbuffer
; in:
; de - ptr to bulletDrawPtr in the runtime data
BombSlowDraw:
			BULLET_DRAW(SpriteGetScrAddr_bomb_slow, __RAM_DISK_S_BOMB_SLOW)