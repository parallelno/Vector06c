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
			sta @dir+1 ; direction (BULLET_DIR_*) ; TODO: move dir calc over this func. use A reg for a bulletId
			call BulletsGetEmptyDataPtr
			; hl - ptr to bulletUpdatePtr+1
			; advance hl to bulletUpdatePtr
			dcx h
			mvi m, <ScytheUpdate
			inx h 
			mvi m, >ScytheUpdate
			; advance hl to bulletDrawPtr
			inx h 
			mvi m, <ScytheDraw
			inx h 
			mvi m, >ScytheDraw
			
			; advance hl to bulletId
			inx h
;@bulletId:	mvi a, TEMP_BYTE
			;mov m, a

			; advance hl to bulletStatus
			inx h
			mvi m, SCYTHE_STATUS_MOVE_THROW
			; advance and set bulletStatusTimer
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
; de - ptr to bulletUpdatePtr in the runtime data
ScytheUpdate:
			; advance to bulletStatusTimer
			LXI_H_TO_DIFF(bulletStatusTimer, bulletUpdatePtr)
			dad d
@updateMove:
			dcr m
			jz @die
@updateMovement:
			ACTOR_UPDATE_MOVEMENT_CHECK_TILE_COLLISION(bulletStatusTimer, bulletPosX, SCYTHE_COLLISION_WIDTH, SCYTHE_COLLISION_HEIGHT, @setBounceAfterTileCollision) 
			
			; hl points to bulletPosY+1
			; advance hl to bulletAnimTimer
			LXI_B_TO_DIFF(bulletAnimTimer, bulletPosY+1)
			dad b
			mvi a, SCYTHE_ANIM_SPEED_MOVE
			BULLET_UPDATE_ANIM_CHECK_COLLISION_HERO(SCYTHE_COLLISION_WIDTH, SCYTHE_COLLISION_HEIGHT, SCYTHE_DAMAGE)	
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
			mvi m, SCYTHE_STATUS_MOVE_BOUNCE
			; advance hl to bulletSpeedX
			LXI_B_TO_DIFF(bulletSpeedX, bulletStatus)
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
			; hl points to bulletStatusTimer
			; advance hl to bulletUpdatePtr+1
			LXI_B_TO_DIFF(bulletUpdatePtr+1, bulletStatusTimer)
			dad b
			jmp BulletsDestroy

; draw a sprite into a backbuffer
; in:
; de - ptr to bulletDrawPtr in the runtime data
ScytheDraw:
			BULLET_DRAW(SpriteGetScrAddr_scythe, __RAM_DISK_S_SCYTHE)