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

; status duration in updates.
BOMB_SLOW_STATUS_MOVE_TIME	= 32

; animation speed (the less the slower, 0-255, 255 means the next frame is almost every update)
BOMB_SLOW_ANIM_SPEED_MOVE	= 130

; gameplay
BOMB_SLOW_DAMAGE = 1
BOMB_SLOW_COLLISION_WIDTH	= 10
BOMB_SLOW_COLLISION_HEIGHT	= 10

; in:
; bc - caster pos
; a - projectileId
BombSlowInit:
			sta @bulletId+1
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

			; advance hl to bulletId
			inx h
@bulletId:	mvi a, TEMP_BYTE
			mov m, a

			; advance hl to bulletStatus
			inx h
			mvi m, BOMB_SLOW_STATUS_MOVE_THROW
			; advance and set bulletStatusTimer
			inx h
			mvi m, BOMB_SLOW_STATUS_MOVE_TIME
			; advance hl to bulletAnimPtr
			inx_h(2)
			
			; a - bulletId
			cpi BOMB_SLOW_ID
			jz @bombSlow
@bombDmg:
			mvi m, <bomb_slow_dmg
			inx h
			mvi m, >bomb_slow_dmg
			jmp @eraseScrAddr
@bombSlow:
			mvi m, <bomb_slow_run
			inx h
			mvi m, >bomb_slow_run			
@eraseScrAddr:
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
			
			; b = posX
			; c = posY	
			; set a projectile speed towards the hero
			; posDiff =  heroPos - burnerPosX
			; speed = posDiff / VAMPIRE_STATUS_DASH_TIME			
			lda heroPosX+1
			sub b
			mov e, a
			mvi a, 0
			; if posDiffX < 0, then d = $ff, else d = 0
			sbb a
			mov d, a
			xchg
			; posDiffX / BOMB_SLOW_STATUS_MOVE_TIME
			dad h 
			dad h 
			dad h
			; to fill up L with %1111 if posDiff < 0
			ani %111 ; <(%0000000011111111 / BOMB_SLOW_STATUS_DASH_TIME)
			ora l 
			mov l, a
			push h
			xchg
			; do the same for Y
			lda heroPosY+1
			sub c
			mov e, a 
			mvi a, 0
			; if posDiffY < 0, then d = $ff, else d = 0
			sbb a
			mov d, a 
			xchg
			; posDiffY / BOMB_SLOW_STATUS_MOVE_TIME 
			dad h 
			dad h 
			dad h 
			; to fill up L with %1111 if posDiff < 0
			ani %111 ; <(%0000000011111111 / BOMB_SLOW_STATUS_DASH_TIME)
			ora l 
			mov l, a
			xchg
			; advance hl to speedX
			inx h 
			pop b ; speedX
			mov m, c 
			inx h 
			mov m, b
			; advance hl to speedY
			inx h
			mov m, e
			inx h 
			mov m, d	
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
			; hl - ptr to bulletStatusTimer
			; advance hl to bulletSpeedY+1
			LXI_B_TO_DIFF(bulletSpeedY+1, bulletStatusTimer)
			dad b
			; bc <- speedY
			mov b, m
			dcx h
			mov c, m
			dcx h
			; stack <- speedX
			mov d, m
			dcx h
			mov e, m
			dcx h
			push d
			; de <- posY
			mov d, m
			dcx h
			mov e, m
			; (posY) <- posY + speedY
			xchg
			dad b
			xchg
			; pos = heroPos-pos/8
			mov m, e
			inx h 
			mov m, d
			dcx_h(2)
			; hl points to speedX+1
			; de <- posX
			mov d, m
			dcx h
			mov e, m
			; (posX) <- posX + speedX
			xchg
			pop b
			dad b
			xchg
			mov m, e
			inx h 
			mov m, d
			
			; hl points to bulletPosX+1
			; advance hl to bulletAnimTimer
			LXI_B_TO_DIFF(bulletAnimTimer, bulletPosX+1)
			dad b
			mvi a, BOMB_SLOW_ANIM_SPEED_MOVE
			BULLET_UPDATE_ANIM_CHECK_COLLISION_HERO(BOMB_SLOW_COLLISION_WIDTH, BOMB_SLOW_COLLISION_HEIGHT, BOMB_SLOW_DAMAGE)	
@dieAfterDamage:
			; advance hl to bulletUpdatePtr+1
			LXI_B_TO_DIFF(bulletUpdatePtr+1, bulletPosY+1)
			dad b
			jmp BulletsDestroy
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