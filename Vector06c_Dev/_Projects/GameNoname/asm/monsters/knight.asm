; mob AI:
; init:
;	 status = detectHeroInit
; detectHeroInit:
;	status = detectHero
;	statusTimer = detectHeroTime
;	anim = idle.
; detectHero:
;	decr statusTimer
;	if statusTimer == 0:
;		status = moveInit
;	else:
;		if distance(mob, hero) < a defence radius:
;			status = defence
;			anim to the hero dir
;			anim = run
;		else:
;			updateAnim
;			check mod-hero collision, impact if collides
; defence:
;	if distance(mob, hero) < a defence radius:
;		try to move a mob toward a hero, reset one coord to move along one axis
;		if mob do not collides with tiles:
;			accept new pos
;		updateAnim
;		check mod-hero collision, impact if collides
;	else:
;		status = detectHeroInit
; moveInit:
;	status = move
;	statusTimer = random
;	speed = random dir only along one axis
;	set anim along the dir
; move:
;	decr statusTimer
;	if statusTimer = 0
;		status = detectHeroInit
;	else:
;		try to move a mob
;		if mob collides with tiles:
;			status = moveInit
;		else:
;			accept new pos
;			updateAnim
;			check mod-hero collision, impact if collides

; statuses.
KNIGHT_STATUS_DETECT_HERO_INIT	= 0
KNIGHT_STATUS_DETECT_HERO		= 1
KNIGHT_STATUS_DEFENCE			= 2
KNIGHT_STATUS_MOVE_INIT			= 3
KNIGHT_STATUS_MOVE				= 4

; status duration in updates.
KNIGHT_STATUS_DETECT_HERO_TIME	= 100
KNIGHT_STATUS_MOVE				= 25

; animation speed (the less the slower, 0-255, 255 means the next frame is almost every update)
KNIGHT_ANIM_SPEED_DETECT_HERO	= 30
KNIGHT_ANIM_SPEED_DEFENCE		= 100
KNIGHT_ANIM_SPEED_MOVE			= 50

; gameplay
KNIGHT_DAMAGE = 1
KNIGHT_HEALTH = 1

KNIGHT_COLLISION_WIDTH	= 15
KNIGHT_COLLISION_HEIGHT	= 10

KNIGHT_MOVE_SPEED		= $0090
KNIGHT_MOVE_SPEED_NEG	= $ffff - $90 + 1

;========================================================
; called to spawn this monster
; in:
; c - tile idx in the roomTilesData array.
; a - monster id * 2
; out:
; a = 0
KnightInit:
			call MonstersGetEmptyDataPtr
			; hl - ptr to monsterUpdatePtr+1			
			mvi m, >KnightUpdate
			dcx h 
			mvi m, <KnightUpdate

			; TODO: add monsterDataPrevPPtr init
			; TODO: add monsterDataNextPPtr init

			
			; advance to KnightDraw
			LXI_d_TO_DIFF(monsterDrawPtr, monsterUpdatePtr)
			dad d
			
			mvi m, <KnightDraw
			inx h 
			mvi m, >KnightDraw
			inx h
			mvi m, <KnightImpact
			inx h
			mvi m, >KnightImpact
			; advance to monsterType
			inx h
			mvi m, MONSTER_TYPE_ENEMY			
			; advance to monsterHealth
			inx h
			mvi m, KNIGHT_HEALTH

			LXI_D_TO_DIFF(monsterAnimPtr, monsterHealth)
			dad d
			; monsterAnimPtr
			mvi m, < knight_run_r
			inx h
			mvi m, > knight_run_r
			; advance hl to monsterSpeedY+1
			LXI_D_TO_DIFF(monsterSpeedY+1, monsterAnimPtr+1)
			dad d
			; tmp d = 0
			mvi d, 0
			; set monsterSpeedY to zero
			mov m, d
			dcx h
			mov m, d
			dcx h 
			; advance hl to monsterSpeedX+1
			; set monsterSpeedX to right 
			mvi m, >KNIGHT_RUN_SPEED
			dcx h 
			mvi m, <KNIGHT_RUN_SPEED
			dcx h 
			; advance hl to monsterPosY+1
			; convert tile idx into the posY and set it
			mov a, c
			; posY = tile idx % ROOM_WIDTH * TILE_WIDTH
			ani %11110000
			mov m, a
			mov e, a
			dcx h 
			mov m, d
			; advance hl to monsterPosX+1
			dcx h 			
			; convert tile idx into the posX and set it
			mov a, c
			; posX = tile idx % ROOM_WIDTH * TILE_WIDTH
			ani %00001111
			rlc_(4)
			mov m, a
			dcx h 
			mov m, d 
			; advance hl to monsterEraseWHOld+1
			dcx h 			
			mov m, d ; width = 8
			dcx h 
			mvi m, 5 ; supported mimimum height
			; advance hl to monsterEraseWH+1
			dcx h 			
			mov m, d ; width = 8
			dcx h 
			mvi m, 5 ; supported mimimum height
			; advance hl to monsterEraseScrAddrOld+1
			dcx h
			; a - posX
			; scrX = posX/8 + $a0
			rrc_(3)
			ani %00011111			
			adi SPRITE_X_SCR_ADDR
			mov m, a
			dcx h 
			mov m, e
			; advance hl to monsterEraseScrAddr+1
			dcx h
			mov m, a
			dcx h 
			mov m, e

			; return zero to erase the tile data
			; there this monster was in the roomTilesData
			xra a 
			ret
			.closelabels

; anim and a gameplay logic update
; in:
; de - ptr to monsterUpdatePtr in the runtime data
KnightUpdate:
			mov b, d
			mov c, e
			xchg
			shld @monsterUpdatePptr+1

			; anim update
			lda gameUpdateCounter	; update anim every 4th update
			ani %11
			jnz @skipAnimUpdate
			; advance the anim to the next frame
			push b
			; advance hl to monsterAnimPtr
			LXI_H_TO_DIFF(monsterAnimPtr, monsterUpdatePtr)
			dad b
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
			; advance hl to the current frame ptr to the next frame
			dad b
			xchg
			; de - the next frame ptr
			; store de into the monsterAnimPtr
			mov m, d
			dcx h
			mov m, e
			pop b
@skipAnimUpdate:			
			; update movement
			LXI_H_TO_DIFF(monsterPosX, monsterUpdatePtr)
			dad b
			shld @monsterPosXPtr+1
			; bc <- (posX)
			mov c, m
			inx h
			mov b, m
			inx h
			shld @monsterPosYPtr+1
			; stack <- (posY)
			mov e, m
			inx h
			mov d, m
			inx h
			push d
			; de <- (speedX)
			mov e, m
			inx h
			mov d, m
			inx h
			; (charTempX) <- a new posX
			xchg
			dad b
			; a <- x for checking a collision
			mov a, h
			shld charTempX
			xchg
			; de <- (speedY)
			mov e, m
			inx h
			mov d, m
			; (charTempY) <- a new posY
			xchg
			pop b
			dad b
			shld charTempY

			; check the collision tiles
			mov d, a
			mov e, h
			lxi b, (KNIGHT_COLLISION_WIDTH-1)<<8 | KNIGHT_COLLISION_HEIGHT-1
			CALL_RAM_DISK_FUNC(RoomCheckWalkableTiles, __RAM_DISK_M_BACKBUFF2 | RAM_DISK_M_89, false, false)
			jnz @tilesCollide

@updatePos:
            lhld charTempX
@monsterPosXPtr:
			shld TEMP_ADDR
			lhld charTempY
@monsterPosYPtr:
			shld TEMP_ADDR
@heroCollisionCheck:
			; TODO: check hero-monster collision every second frame
			lhld @monsterPosXPtr+1
			inx h
			; horizontal check
			mov c, m ; monster posX
			lda heroPosX+1
			mov b, a ; tmp
			adi HERO_COLLISION_WIDTH-1
			cmp c
			rc
			mvi a, KNIGHT_COLLISION_WIDTH-1
			add c
			cmp b
			rc
			; vertical check
			inx_h(2)
			mov c, m ; monster posY
			lda heroPosY+1
			mov b, a
			adi HERO_COLLISION_HEIGHT-1
			cmp c
			rc
			mvi a, KNIGHT_COLLISION_HEIGHT-1
			add c
			cmp b
			rc
			; hero collides
			; send him a damage
			mvi c, KNIGHT_DAMAGE
			call HeroImpact
			ret

@tilesCollide:
@monsterUpdatePptr:
            lxi b, TEMP_ADDR
			; get speedX addr
            call Random

			LXI_H_TO_DIFF(monsterSpeedX, monsterUpdatePtr)
			dad b

			cpi $40
			jc @speedXp
			cpi $80
			jc @speedXn
			cpi $c0
			jc @speedYp
@speedYn:
			xra a
			mov m, a
			inx h
			mov m, a
			inx h
			mvi m, < KNIGHT_RUN_SPEED_NEG
			inx h
			mvi m, > KNIGHT_RUN_SPEED_NEG
			jmp @setAnim
@speedYp:
			xra a
			mov m, a
			inx h
			mov m, a
			inx h
			mvi m, < KNIGHT_RUN_SPEED
			inx h
			mvi m, > KNIGHT_RUN_SPEED
			jmp @setAnim
@speedXn:
			xra a
			mvi m, < KNIGHT_RUN_SPEED_NEG
			inx h
			mvi m, > KNIGHT_RUN_SPEED_NEG
			inx h
			mov m, a
			inx h
			mov m, a
			mvi a, > KNIGHT_RUN_SPEED_NEG
			jmp @setAnim
@speedXp:
			xra a
			mvi m, < KNIGHT_RUN_SPEED
			inx h
			mvi m, > KNIGHT_RUN_SPEED
			inx h
			mov m, a
			inx h
			mov m, a
			mvi a, > KNIGHT_RUN_SPEED
@setAnim:
			; a = speedX
			ora a
			; if speedX is positive, then play knight_run_r
			; that means a vertical movement plays knight_run_r anim as well
			jz @setAnimRunR
@setAnimRunL:
			LXI_H_TO_DIFF(monsterAnimPtr, monsterUpdatePtr)
			dad b
			mvi m, < knight_run_l
			inx h
			mvi m, > knight_run_l
			ret
@setAnimRunR:
			LXI_H_TO_DIFF(monsterAnimPtr, monsterUpdatePtr)
			dad b
			mvi m, < knight_run_r
			inx h
			mvi m, > knight_run_r
            ret

KnightImpact:
			; de - ptr to monsterImpactPtr+1
			LXI_H_TO_DIFF(monsterUpdatePtr+1, monsterImpactPtr+1)
			dad d
			jmp MonstersDestroy

; in:
; hl - monsterAnimTimer
; a - anim speed
KnightUpdateAnimCheckCollisionHero:
			MONSTER_UPDATE_ANIM_CHECK_COLLISION_HERO(KNIGHT_COLLISION_WIDTH, KNIGHT_COLLISION_HEIGHT, KNIGHT_DAMAGE)

; draw a sprite into a backbuffer
; in:
; de - ptr to monsterDrawPtr in the runtime data
KnightDraw:
			MONSTER_DRAW(SpriteGetScrAddr_knight, __RAM_DISK_S_KNIGHT)