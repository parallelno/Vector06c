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
;			death
;		else:
;			accept new pos
;			check mod-hero collision, impact if collides
;			updateAnim
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
;			check mod-hero collision, impact if collides
;			updateAnim


SCYTHE_MOVE_SPEED		= $0400				; low byte is a subpixel speed, high byte is a speed in pixels
SCYTHE_MOVE_SPEED_NEG	= $ffff - $0400 + 1	; low byte is a subpixel speed, high byte is a speed in pixels

; statuses.
SCYTHE_STATUS_MOVE_FORWARD = 0
SCYTHE_STATUS_MOVE_BACKWARD = 1

; status duration in updates.
SCYTHE_STATUS_MOVE_FORWARD_TIME	= 25
SCYTHE_STATUS_MOVE_BACKWARD_TIME	= 25

; animation speed (the less the slower, 0-255, 255 means the next frame is almost every update)
SCYTHE_ANIM_SPEED_MOVE	= 130

; gameplay
SCYTHE_DAMAGE = 1
SCYTHE_COLLISION_WIDTH	= 12
SCYTHE_COLLISION_HEIGHT	= 12
SCYTHE_COLLISION_OFFSET_X_R = 0
SCYTHE_COLLISION_OFFSET_Y_R = 0

SCYTHE_COLLISION_OFFSET_X_L = 0
SCYTHE_COLLISION_OFFSET_Y_L = 0

; in:
; bc - caster posX
; a - direction
ScytheInit:
			sta @dir+1 ; direction (BULLET_DIR_*)
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

			; advance hl to bulletStatus
			inx h
			mvi m, SCYTHE_STATUS_MOVE_FORWARD
			; advance and set bulletStatusTimer
			inx h
			mvi m, SCYTHE_STATUS_MOVE_FORWARD_TIME
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
			; advance to bulletStatus
			LXI_H_TO_DIFF(bulletStatus, bulletUpdatePtr)
			dad d
			mov a, m
			cpi SCYTHE_STATUS_MOVE_FORWARD
			jz ScytheUpdateMoveForward
			jmp ScytheUpdateMoveBackward

ScytheUpdateMoveForward:
			; hl = bulletStatus
			; advance hl to bulletStatusTimer
			inx h
			dcr m
			jz ScytheUpdateMoveBackwardInit
ScytheUpdateMovement:
			LXI_B_TO_DIFF(bulletPosX, bulletStatusTimer)
			dad b
			push h ; (stack) <- posX ptr, to restore it in @applyNewPos
			; bc <- posX
			mov c, m
			inx h
			mov b, m
			inx h
			; stack <- posY
			mov e, m
			inx h
			mov d, m
			inx h
			push d
			; de <- speedX
			mov e, m
			inx h
			mov d, m
			inx h
			; (newPosX) <- posX + speedX
			xchg
			dad b
			shld @newPosX+1			
			mov a, h ; posX + speedX for checking a collision
			xchg
			; hl points to speedY
			; de <- speedY
			mov e, m
			inx h
			mov d, m
			; (newPosY) <- posY + speedY
			xchg
			pop b
			dad b
			shld @newPosY+1
			; a - posX + speedX			
			; hl - posY + speedY
			; de - points to speedY+1

			; check the collision tiles
			mov d, a
			mov e, h
			lxi b, (SCYTHE_COLLISION_WIDTH-1)<<8 | SCYTHE_COLLISION_HEIGHT-1
			CALL_RAM_DISK_FUNC(RoomCheckWalkableTiles, __RAM_DISK_M_BACKBUFF2 | RAM_DISK_M_89, false, false)
			jnz @setMoveBackward

@applyNewPos:
			pop h
			; hl points to posX
@newPosX:	lxi d, TEMP_WORD
@newPosY:	lxi b, TEMP_WORD
			; store a new posX
			mov m, e
			inx h
			mov m, d
			inx h
			; store a new posY
			mov m, c
			inx h
			mov m, b		
			; hl points to bulletPosY+1
			; advance hl to bulletAnimTimer
			LXI_B_TO_DIFF(bulletAnimTimer, bulletPosY+1)
			dad b
			mvi a, SCYTHE_ANIM_SPEED_MOVE
			call AnimationUpdate
@checkCollisionHero:
			; hl points to bulletAnimPtr
			; TODO: check hero-bullet collision not every frame			
			; advance hl to bulletPosX
			LXI_B_TO_DIFF(bulletPosX+1, bulletAnimPtr)
			dad b
			; horizontal check
			mov c, m ; posX
			lda heroPosX+1
			mov b, a ; tmp
			adi HERO_COLLISION_WIDTH-1
			cmp c
			rc
			mvi a, SCYTHE_COLLISION_WIDTH-1
			add c
			cmp b
			rc
			; vertical check
			; advance hl to bulletPosY+1
			inx_h(2)
			mov c, m ; posY
			lda heroPosY+1
			mov b, a
			adi HERO_COLLISION_HEIGHT-1
			cmp c
			rc
			mvi a, SCYTHE_COLLISION_HEIGHT-1
			add c
			cmp b
			rc
@collidesHero:
			; hero collides
			; hl points to bulletPosY+1
			push h
			; send him a damage
			mvi c, SCYTHE_DAMAGE
			call HeroImpact
			pop h
@dieAfterDamage:
			; advance hl to bulletUpdatePtr+1
			LXI_B_TO_DIFF(bulletUpdatePtr+1, bulletPosY+1)
			dad b
			jmp BulletsDestroy
			
@setMoveBackward:
			pop h
			; hl points to posX
			; advance hl to bulletStatus
			LXI_B_TO_DIFF(bulletStatus, bulletPosX)
			dad b
			mov a, m
			cpi SCYTHE_STATUS_MOVE_BACKWARD
			jz @dieBackward
			; advance hl to bulletStatusTImer
			inx h
			jmp ScytheUpdateMoveBackwardInit
@dieBackward:
			; advance hl to bulletUpdatePtr+1
			LXI_B_TO_DIFF(bulletUpdatePtr+1, bulletStatus)
			dad b
			jmp BulletsDestroy

ScytheUpdateMoveBackwardInit:
			; hl - ptr to bulletStatusTimer
			mvi m, SCYTHE_STATUS_MOVE_BACKWARD_TIME
			; advance hl to bulletStatus
			dcx h
			mvi m, SCYTHE_STATUS_MOVE_BACKWARD
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

ScytheUpdateMoveBackward:
			; hl = bulletStatus
			; advance hl to bulletStatusTimer
			inx h
			dcr m
			jnz ScytheUpdateMovement
@die:
			; advance hl to bulletUpdatePtr+1
			LXI_B_TO_DIFF(bulletUpdatePtr+1, bulletStatusTimer)
			dad b
			jmp BulletsDestroy

; draw a sprite into a backbuffer
; in:
; de - ptr to bulletDrawPtr in the runtime data
ScytheDraw:
			; advance to bulletStatus
			LXI_H_TO_DIFF(bulletStatus, bulletDrawPtr)
			dad d
			mov a, m
			; if it is invisible, return
			cpi BULLET_STATUS_INVIS
			rz

			LXI_D_TO_DIFF(bulletPosX+1, bulletStatus)
			dad d
			call SpriteGetScrAddr_scythe
			; hl - ptr to bulletPosY+1
			; tmpA <- c
			mov a, c
			; advance to bulletAnimPtr
			LXI_B_TO_DIFF(bulletAnimPtr, bulletPosY+1)
			dad b
			mov b, m
			inx h
			push h
			mov h, m
			mov l, b
			mov c, a
			; hl - animPtr
			; c - preshifted sprite idx*2 offset
			call SpriteGetAddr
			CALL_RAM_DISK_FUNC(__DrawSpriteVM, __RAM_DISK_S_SCYTHE | __RAM_DISK_M_DRAW_SPRITE_VM | RAM_DISK_M_8F)
			pop h
			inx h
			; hl - ptr to bulletEraseScrAddr
			; store the current scr addr, into bulletEraseScrAddr
			mov m, c
			inx h
			mov m, b
			; advance to bulletEraseWH
			LXI_B_TO_DIFF(bulletEraseWH, bulletEraseScrAddr+1)
			dad b
			; store a width and a height into bulletEraseWH
			mov m, e
			inx h
			mov m, d
			ret