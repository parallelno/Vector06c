; mob AI:
; detectHeroInit:
;	status = detectHero
;	statusTimer = detectHeroTime
;	anim = idle.
; detectHero:
;	decr statusTimer
;	if statusTimer == 0:
;		status = moveInit
;	else:
;		if distance(mob, hero) < a shooting radius:
;			status = shootPrep
;			statusTimer = shootPrepTime
;			anim to the hero dir
;		else:
;			updateAnim
;			check mod-hero collision, impact if collides
; shootPrep:
;	decr statusTimer
;	if statusTimer == 0:
;		status = shoot
;	else:
;		updateAnim
;		check mod-hero collision, impact if collides
; shoot:
;	status = relax
;	statusTimer = relaxTime
;	spawn a projectile along the mob dir
; relax:
;	decr statusTimer
;	if statusTimer == 0:
;		status = moveInit
;	else:
;		updateAnim
;		check mod-hero collision, impact if collides
; moveInit:
;	status = move
;	statusTimer = random
;	speed = random dir
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


; statuses.
SKELETON_STATUS_DETECT_HERO_INIT	= 0
SKELETON_STATUS_DETECT_HERO			= 1
SKELETON_STATUS_SHOOT_PREP			= 2
SKELETON_STATUS_SHOOT				= 3
SKELETON_STATUS_RELAX				= 4
SKELETON_STATUS_MOVE_INIT			= 5
SKELETON_STATUS_MOVE				= 6

; statusTimer. in updates.
SKELETON_STATUS_DETECT_HERO_TIME = 50 ; 1 sec
SKELETON_STATUS_SHOOT_PREP_TIME = 10
SKELETON_STATUS_RELAX_TIME = 25
SKELETON_STATUS_MOVE_TIME = 75

; animation speed (the less the slower, 0-255, 255 means next frame every update)
SKELETON_ANIM_SPEED_DETECT_HERO = 40
SKELETON_ANIM_SPEED_RELAX = 20
SKELETON_ANIM_SPEED_MOVE = 50
SKELETON_ANIM_SPEED_SHOOT_PREP = 1

; gameplay
SKELETON_DAMAGE = 1
SKELETON_HEALTH = 1

SKELETON_COLLISION_WIDTH = 15
SKELETON_COLLISION_HEIGHT = 10

SKELETON_POS_X_MIN = TILE_WIDTH
SKELETON_POS_X_MAX = (ROOM_WIDTH - 2 ) * TILE_WIDTH
SKELETON_POS_Y_MIN = TILE_WIDTH
SKELETON_POS_Y_MAX = (ROOM_HEIGHT - 2 ) * TILE_HEIGHT

SKELETON_RUN_SPEED		= $0100
SKELETON_RUN_SPEED_NEG	= $ffff - $100 + 1

SKELETON_DETECT_HERO_DISTANCE = 45

;========================================================
; called to spawn this monster
; in:
; c - tile idx in the roomTilesData array.
; a - monster id * 2
; out:
; a = 0
SkeletonInit:
			call MonstersGetEmptyDataPtr

			; posX = tile idx % ROOM_WIDTH * TILE_WIDTH
			mvi a, %00001111
			ana c
			rlc_(4)
			mov b, a
			; scrX = posX/8 + $a0
			rrc_(3)
			adi SPRITE_X_SCR_ADDR
			mov d, a
			; posY = (tile idx % ROOM_WIDTH) * TILE_WIDTH
			mvi a, %11110000
			ana c
			mvi c, 0
			; b = posX
			; d = scrX
			; a = posY
			; c = 0 and SPRITE_W_PACKED_MIN
			; hl - ptr to monsterUpdatePtr+1

			mvi m, >SkeletonUpdate
			dcx h
			mvi m, <SkeletonUpdate
			; advance to SkeletonDraw
			inx_h(2)
			mvi m, <SkeletonDraw
			inx h
			mvi m, >SkeletonDraw
			inx h
			mvi m, <SkeletonImpact
			inx h
			mvi m, >SkeletonImpact
			; advance to monsterType
			inx h
			mvi m, MONSTER_TYPE_ENEMY
			; advance to monsterHealth
			inx h
			mvi m, SKELETON_HEALTH
			; advance to monsterStatus
			inx h
			mvi m, SKELETON_STATUS_DETECT_HERO_INIT
			; advance to monsterStatusTimer
			inx h
			mov m, c
			; advance to monsterAnimTimer
			inx h
			mov m, c
			; advance to monsterAnimPtr
			inx h
			mvi m, < skeleton_idle
			inx h
			mvi m, > skeleton_idle

			; advance to monsterEraseScrAddr
			inx h
			mov m, a
			inx h
			mov m, d
			; advance to monsterEraseScrAddrOld
			inx h
			mov m, a
			inx h
			mov m, d
			; advance to monsterEraseWH
			inx h
			mvi m, SPRITE_H_MIN
			inx h
			mov m, c
			; advance to monsterEraseWHOld
			inx h
			mvi m, SPRITE_H_MIN
			inx h
			mov m, c
			; advance to monsterPosX
			inx h
			mov m, c
			inx h
			mov m, b
			; advance to monsterPosY
			inx h
			mov m, c
			inx h
			mov m, a
			; advance to monsterSpeedX
			inx h
			mvi m, <SKELETON_RUN_SPEED
			inx h
			mvi m, >SKELETON_RUN_SPEED
			; advance to monsterSpeedY
			inx h
			mov m, c
			inx h
			mov m, c

			; return zero to erase the tile data
			; there this monster was in the roomTilesData
			xra a
			ret
			.closelabels

; anim and a gameplay logic update
; in:
; de - ptr to monsterUpdatePtr in the runtime data
SkeletonUpdate:
			; advance hl to monsterStatus
			LXI_H_TO_DIFF(monsterStatus, monsterUpdatePtr)
			dad d
			mov a, m
			cpi SKELETON_STATUS_MOVE
			jz SkeletonUpdateMove
			cpi SKELETON_STATUS_DETECT_HERO
			jz SkeletonUpdateDetectHero
			cpi SKELETON_STATUS_RELAX
			jz SkeletonUpdateRelax
			cpi SKELETON_STATUS_SHOOT_PREP
			jz SkeletonUpdateShootPrep	
			cpi SKELETON_STATUS_MOVE_INIT
			jz SkeletonUpdateMoveInit
			cpi SKELETON_STATUS_DETECT_HERO_INIT
			jz SkeletonUpdateDetectHeroInit
			cpi SKELETON_STATUS_SHOOT
			jz SkeletonUpdateShoot
			ret

SkeletonUpdateDetectHeroInit:
			; hl = monsterStatus
			mvi m, SKELETON_STATUS_DETECT_HERO
			inx h 
			mvi m, SKELETON_STATUS_DETECT_HERO_TIME
			LXI_B_TO_DIFF(monsterAnimPtr, monsterStatusTimer)
			dad b
			mvi m, <skeleton_idle
			inx h 
			mvi m, >skeleton_idle
			ret

SkeletonUpdateDetectHero:
			; hl = monsterStatus
			; advance hl to monsterStatusTimer
			inx h
			dcr m
			jz @setMoveInit
@checkMobHeroDistance:
			; advance hl to monsterPosX+1
			LXI_B_TO_DIFF(monsterPosX+1, monsterStatusTimer)
			dad b
			; check hero-monster posX diff
			lda heroPosX+1
			sub m
			jc @checkNegPosXDiff
			cpi SKELETON_DETECT_HERO_DISTANCE
			jc @checkPosYDiff
			jmp @updateAnimHeroDetectX
@checkNegPosXDiff:
			cpi -SKELETON_DETECT_HERO_DISTANCE
			jnc @checkPosYDiff
			jmp @updateAnimHeroDetectX
@checkPosYDiff:
			; advance hl to monsterPosY+1
			inx_h(2)
			; check hero-monster posY diff
			lda heroPosY+1
			sub m
			jc @checkNegPosYDiff
			cpi SKELETON_DETECT_HERO_DISTANCE
			jc @detectsHero
			jmp @updateAnimHeroDetectY
@checkNegPosYDiff:
			cpi -SKELETON_DETECT_HERO_DISTANCE
			jnc @detectsHero
			jmp @updateAnimHeroDetectY
@detectsHero:
			; hl = monsterPosY+1
			; advance hl to monsterStatus
			LXI_B_TO_DIFF(monsterStatus, monsterPosY+1)
			dad b
			mvi m, SKELETON_STATUS_SHOOT_PREP
			inx h
			mvi m, SKELETON_STATUS_SHOOT_PREP_TIME
			; advance hl to monsterAnimPtr
			LXI_B_TO_DIFF(monsterAnimPtr, monsterStatusTimer)
			dad b
			mvi m, <skeleton_run_r
			inx h
			mvi m, >skeleton_run_r
			ret
@updateAnimHeroDetectX:
			; advance hl to monsterAnimTimer
			LXI_B_TO_DIFF(monsterAnimTimer, monsterPosX+1)
			dad b
			mvi a, SKELETON_ANIM_SPEED_DETECT_HERO
			jmp SkeletonUpdateAnim
@updateAnimHeroDetectY:
			; advance hl to monsterAnimTimer
			LXI_B_TO_DIFF(monsterAnimTimer, monsterPosY+1)
			dad b
			mvi a, SKELETON_ANIM_SPEED_DETECT_HERO
			jmp SkeletonUpdateAnim

@setMoveInit:
			dcx h
			mvi m, SKELETON_STATUS_MOVE_INIT
			ret

SkeletonUpdateMoveInit:
			; hl = monsterStatus
			mvi m, SKELETON_STATUS_MOVE
			inx h
			mvi m, SKELETON_STATUS_MOVE_TIME

			xchg
			call Random
			; advance hl to monsterSpeedX
			LXI_H_TO_DIFF(monsterSpeedX, monsterStatusTimer)
			dad d

			mvi c, 0 ; tmp c=0
			cpi $40
			jc @speedXp
			cpi $80
			jc @speedYp
			cpi $c0
			jc @speedXn
@speedYn:
			mov m, c
			inx h
			mov m, c
			inx h
			mvi m, <SKELETON_RUN_SPEED_NEG
			inx h
			mvi m, >SKELETON_RUN_SPEED_NEG
			jmp @setAnim
@speedYp:
			mov m, c
			inx h
			mov m, c
			inx h
			mvi m, <SKELETON_RUN_SPEED
			inx h
			mvi m, >SKELETON_RUN_SPEED
			jmp @setAnim
@speedXn:
			mvi m, <SKELETON_RUN_SPEED_NEG
			inx h
			mvi m, >SKELETON_RUN_SPEED_NEG
			inx h
			mov m, c
			inx h
			mov m, c
			jmp @setAnim
@speedXp:
			mvi m, <SKELETON_RUN_SPEED
			inx h
			mvi m, >SKELETON_RUN_SPEED
			inx h
			mov m, c
			inx h
			mov m, c
@setAnim:
			LXI_B_TO_DIFF(monsterAnimPtr, monsterSpeedY+1)
			dad b
			; a = rnd
			ora a
			; if rnd is positive (up or right movement), then play skeleton_run_r anim
			jp @setAnimRunR
@setAnimRunL:
			mvi m, <skeleton_run_l
			inx h
			mvi m, >skeleton_run_l
			ret
@setAnimRunR:
			mvi m, <skeleton_run_r
			inx h
			mvi m, >skeleton_run_r
            ret

SkeletonUpdateMove:
			; hl = monsterStatus
			; advance hl to monsterStatusTimer
			inx h
			dcr m
			jz @setDetectHeroInit
@updateMovement:
			LXI_B_TO_DIFF(monsterPosX, monsterStatusTimer)
			dad b
			shld @posXPtr+1
			; bc <- posX
			mov c, m
			inx h
			mov b, m
			inx h
			shld @posYPtr+1
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
			; hl points to speedX+1
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

			; check the collision tiles
			mov d, a
			mov e, h
			lxi b, (SKELETON_COLLISION_WIDTH-1)<<8 | SKELETON_COLLISION_HEIGHT-1
			CALL_RAM_DISK_FUNC(RoomCheckWalkableTiles, __RAM_DISK_M_BACKBUFF2 | RAM_DISK_M_89, false, false)
			jnz @tilesCollide

@applyNewPos:
@newPosX:
            lxi h, TEMP_WORD
@posXPtr:
			shld TEMP_ADDR
@newPosY:			
			lxi h, TEMP_WORD
@posYPtr:
			shld TEMP_ADDR
			
			lhld @posXPtr+1
			; hl points to monsterPosX
			; advance hl to monsterAnimTimer
			LXI_B_TO_DIFF(monsterAnimTimer, monsterPosX)
			dad b
			mvi a, SKELETON_ANIM_SPEED_MOVE
			jmp SkeletonUpdateAnim
@tilesCollide:
			lhld @posXPtr+1
			; hl points to monsterPosX
			; advance hl to monsterStatus
			LXI_B_TO_DIFF(monsterStatus, monsterPosX)
			dad b
			mvi m, SKELETON_STATUS_MOVE_INIT
			ret
@setDetectHeroInit:
			dcx h
			mvi m, SKELETON_STATUS_DETECT_HERO_INIT
			ret			

SkeletonUpdateRelax:
			; hl = monsterStatus
			; advance hl to monsterStatusTimer
			inx h
			dcr m
			jz @setMoveInit
			; advance hl to monsterAnimTimer
			LXI_B_TO_DIFF(monsterAnimTimer, monsterStatusTimer)			
			dad b
			mvi a, SKELETON_ANIM_SPEED_RELAX
			jmp SkeletonUpdateAnim
 @setMoveInit:
			dcx h
			mvi m, SKELETON_STATUS_MOVE_INIT
			ret

SkeletonUpdateShootPrep:
			; hl = monsterStatus
			; advance hl to monsterStatusTimer
			inx h
			dcr m
			jz @setShoot
			; advance hl to monsterAnimTimer
			LXI_B_TO_DIFF(monsterAnimTimer, monsterStatusTimer)
			dad b
			mvi a, SKELETON_ANIM_SPEED_SHOOT_PREP
			jmp SkeletonUpdateAnim
 @setShoot:
			dcx h
			mvi m, SKELETON_STATUS_SHOOT
			ret

SkeletonUpdateShoot:
			; hl = monsterStatus
			mvi m, SKELETON_STATUS_RELAX
			; advance hl to monsterStatusTimer	
			inx h
			mvi m, SKELETON_STATUS_RELAX_TIME

			LXI_B_TO_DIFF(monsterSpeedX, monsterStatusTimer)
			dad b
			mov a, m
			inx h
			ora m
			jz @shootVert
			mov a, m
			ora a
			mvi a, BULLET_MOVE_R
			jp @shootRight
@shootLeft:
			mvi a, BULLET_MOVE_L
@shootRight:
			LXI_B_TO_DIFF(monsterPosX+1, monsterSpeedX+1)
			jmp @setBulletPos
@shootVert:
			; advance hl to monsterSpeedY+1
			inx_h(2)
			mov a, m
			ora a
			mvi a, BULLET_MOVE_U
			jp @shootUp
@shootDown:
			mvi a, BULLET_MOVE_D
@shootUp:
			LXI_B_TO_DIFF(monsterPosX+1, monsterSpeedY+1)
@setBulletPos:
			dad b
			mov b, m
			inx_h(2)
			mov c, m
			jmp ScytheInit

/*
; anim and a gameplay logic update
; in:
; de - ptr to monsterUpdatePtr in the runtime data
SkeletonUpdate:
			; advance hl to monsterStatus
			LXI_H_TO_DIFF(monsterStatus, monsterUpdatePtr)
			dad d
			mov a, m
			cpi SKELETON_STATUS_DETECT_HERO
			jz SkeletonUpdateHeroDetect
			cpi SKELETON_STATUS_RUN
			jz SkeletonUpdateRun
			cpi SKELETON_STATUS_FIND_PATROL_END_POS
			jz SkeletonUpdatePatrolRoute
			cpi SKELETON_STATUS_ATTACK
			jz SkeletonUpdateAttack
			cpi SKELETON_STATUS_CHASE_HERO_INIT
			jz SkeletonUpdateInitChase
			ret

SkeletonUpdateHeroDetect:
			; advance hl to monsterPosX+1
			LXI_B_TO_DIFF(monsterPosX+1, monsterStatus)
			dad b
			; check hero-monster posX diff
			lda heroPosX+1
			sub m
			jc @checkNegPosXDiff
			cpi SKELETON_DETECT_HERO_DISTANCE
			jc @checkPosYDiff
			mvi c, SKELETON_ANIM_SPEED_IDLE
			jmp @updateAnimHeroDetectX
@checkNegPosXDiff:
			cpi -SKELETON_DETECT_HERO_DISTANCE
			jnc @checkPosYDiff
			mvi c, SKELETON_ANIM_SPEED_IDLE
			jmp @updateAnimHeroDetectX
@checkPosYDiff:
			; advance hl to monsterPosY+1
			inx_h(2)
			; check hero-monster posY diff
			lda heroPosY+1
			sub m
			jc @checkNegPosYDiff
			cpi SKELETON_DETECT_HERO_DISTANCE
			jc @detectsHero
			mvi c, SKELETON_ANIM_SPEED_IDLE
			jmp @updateAnimHeroDetectY
@checkNegPosYDiff:
			cpi -SKELETON_DETECT_HERO_DISTANCE
			jnc @detectsHero
			mvi c, SKELETON_ANIM_SPEED_IDLE
			jmp @updateAnimHeroDetectY
@detectsHero:
			; hl = monsterPosY+1
			; advance hl to monsterStatus
			LXI_B_TO_DIFF(monsterStatus, monsterPosY+1)
			dad b
			mvi m, SKELETON_STATUS_CHASE_HERO_INIT
			ret
@updateAnimHeroDetectX:
			; advance hl to monsterAnimTimer
			LXI_B_TO_DIFF(monsterAnimTimer, monsterPosX+1)
			dad b
			mvi a, SKELETON_ANIM_SPEED_DETECT
			jmp SkeletonUpdateAnim
@updateAnimHeroDetectY:
			; advance hl to monsterAnimTimer
			LXI_B_TO_DIFF(monsterAnimTimer, monsterPosY+1)
			dad b
			mvi a, SKELETON_ANIM_SPEED_DETECT
			jmp SkeletonUpdateAnim

SkeletonUpdateInitChase:
			; hl = monsterStatus
			; a skeleton goes only straight along the shortest path during SKELETON_STATUS_CHASE_TIME
			mvi m, SKELETON_STATUS_RUN
			; advance hl to monsterStatusTimer
			inx h
			mvi m, SKELETON_STATUS_RUN_TIME
			; advance hl to monsterPosX+1
			LXI_B_TO_DIFF(monsterPosX+1, monsterStatusTimer)
			dad b
			; calc abs(heroPosX-monsterPosX)
			lda heroPosX+1
			sub m
			push psw ; store to check which direction a monster has to go to chase a hero
			jnc @skipInversDiffX
@invertDiffX:
			cma
			inr a ; do not inr A. it is a bit less accurate, but faster
@skipInversDiffX:
			mov c, a ; c = abs(heroPosX-monsterPosX)
			; advance hl to monsterPosY+1
			inx_h(2)
			; calc abs(heroPosY-monsterPosY)
			lda heroPosY+1
			sub m
			push psw ; store to check which direction a monster has to go to chase a hero
			jnc @skipInvertDiffY
@invertDiffY:
			cma
			inr a ; do not inr A. it is a bit less accurate, but faster
@skipInvertDiffY:
@compareDiffXdiffY:
			; c - diffX
			; a - diffY
			cmp c
			; if diffY > diffX, monster goes vertical
			jnc @setMoveVert

@setMoveHoriz:
			; hl = monsterPosY+1
			; advance hl to monsterSpeedX
			inx h
			pop psw
			pop psw
			jnc @setMoveRigh
@setMoveLeft:
			; set speedX
			mvi m, <SKELETON_RUN_SPEED_NEG
			inx h
			mvi m, >SKELETON_RUN_SPEED_NEG
			; advance hl to speedY
			inx h
			; reset speedY
			mvi m, 0
			inx h
			mvi m, 0

			; advance hl to monsterAnimPtr
			LXI_B_TO_DIFF(monsterAnimPtr, monsterSpeedY+1)
			dad b
			; set anim
			mvi m, <skeleton_run_l
			inx h
			mvi m, >skeleton_run_l
			ret

@setMoveRigh:			
			; set speedX
			mvi m, <SKELETON_RUN_SPEED
			inx h
			mvi m, >SKELETON_RUN_SPEED
			; advance hl to speedY
			inx h
			; reset speedY
			mvi m, 0
			inx h
			mvi m, 0

			; advance hl to monsterAnimPtr
			LXI_B_TO_DIFF(monsterAnimPtr, monsterSpeedY+1)
			dad b
			; set anim
			mvi m, <skeleton_run_r
			inx h
			mvi m, >skeleton_run_r
			ret

@setMoveVert:
			; hl = monsterPosY+1
			; advance hl to monsterSpeedX
			inx h
			; reset monsterSpeedX
			mvi m, 0
			inx h
			mvi m, 0
			; advance hl to monsterSpeedY
			inx h

			pop psw
			jnc @setMoveUp
@setMoveDown:
			; set monsterSpeedY
			mvi m, <SKELETON_RUN_SPEED_NEG
			inx h
			mvi m, >SKELETON_RUN_SPEED_NEG
			; advance hl to monsterAnimPtr
			LXI_B_TO_DIFF(monsterAnimPtr, monsterSpeedY+1)
			dad b
			; set anim
			mvi m, <skeleton_run_l
			inx h
			mvi m, >skeleton_run_l
			jmp @setMoveHorizPopPSW

@setMoveUp:			
			mvi m, <SKELETON_RUN_SPEED
			inx h
			mvi m, >SKELETON_RUN_SPEED
			; advance hl to monsterAnimPtr
			LXI_B_TO_DIFF(monsterAnimPtr, monsterSpeedY+1)
			dad b
			; set anim
			mvi m, <skeleton_run_r
			inx h
			mvi m, >skeleton_run_r
@setMoveHorizPopPSW:
			pop psw
			ret

SkeletonUpdateRun:
			; hl = monsterStatus
			shld @restoreStatusPtr+1
			; advance hl to monsterStatusTimer
			inx h
			dcr m
			jz @setDetectHero

			; update movement
			LXI_B_TO_DIFF(monsterPosX, monsterStatusTimer)
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
			lxi b, (SKELETON_COLLISION_WIDTH-1)<<8 | SKELETON_COLLISION_HEIGHT-1
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
			mvi a, SKELETON_COLLISION_WIDTH-1
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
			mvi a, SKELETON_COLLISION_HEIGHT-1
			add c
			cmp b
			rc
			; hero collides
			; send him a damage
			mvi c, SKELETON_DAMAGE
			call HeroImpact
			ret

@setDetectHero:
@restoreStatusPtr:
			lxi h, TEMP_ADDR ; hl = monsterStatus
			mvi m, SKELETON_STATUS_DETECT_HERO
			inx h 
			mvi m, SKELETON_STATUS_DETECT_TIME
			LXI_B_TO_DIFF(monsterAnimPtr, monsterStatusTimer)
			dad b 
			mvi m, <skeleton_idle
			inx h 
			mvi m, >skeleton_idle
			ret

@tilesCollide:
            ret

			; set random speed
			lhld @restoreStatusPtr+1
			mvi m, SKELETON_STATUS_RUN
			; advance to monsterStatusTimer
			inx h
			mvi m, SKELETON_STATUS_RUN_TIME

			xchg
			call Random
			LXI_H_TO_DIFF(monsterSpeedX, monsterStatusTimer)
			dad d

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
			mvi m, < SKELETON_RUN_SPEED_NEG
			inx h
			mvi m, > SKELETON_RUN_SPEED_NEG
			jmp @setAnim
@speedYp:
			xra a
			mov m, a
			inx h
			mov m, a
			inx h
			mvi m, < SKELETON_RUN_SPEED
			inx h
			mvi m, > SKELETON_RUN_SPEED
			jmp @setAnim
@speedXn:
			xra a
			mvi m, < SKELETON_RUN_SPEED_NEG
			inx h
			mvi m, > SKELETON_RUN_SPEED_NEG
			inx h
			mov m, a
			inx h
			mov m, a
			mvi a, > SKELETON_RUN_SPEED_NEG
			jmp @setAnim
@speedXp:
			xra a
			mvi m, < SKELETON_RUN_SPEED
			inx h
			mvi m, > SKELETON_RUN_SPEED
			inx h
			mov m, a
			inx h
			mov m, a
			mvi a, > SKELETON_RUN_SPEED
@setAnim:
			; a = speedX
			ora a
			; if speedX is positive, then play skeleton_run_r
			; that means a vertical movement plays skeleton_run_r anim as well
			jz @setAnimRunR
@setAnimRunL:
			LXI_H_TO_DIFF(monsterAnimPtr, monsterUpdatePtr)
			dad b
			mvi m, < skeleton_run_l
			inx h
			mvi m, > skeleton_run_l
			ret
@setAnimRunR:
			LXI_H_TO_DIFF(monsterAnimPtr, monsterUpdatePtr)
			dad b
			mvi m, < skeleton_run_r
			inx h
			mvi m, > skeleton_run_r
            ret			


SkeletonCheckTileCollision:
			ret
SkeletonUpdatePatrolRoute:
			ret
SkeletonUpdateAttack:
			ret
*/
; in:
; hl - ptr to monsterAnimTimer
; a - anim speed
SkeletonUpdateAnim:
			; update monsterAnimTimer
			add m
			mov m, a
			rnc
			; advance to monsterAnimPtr
			inx h
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
			; advance the current frame ptr to the next frame
			dad b
			xchg
			; de - the next frame ptr
			; store de into the monsterAnimPtr
			mov m, d
			dcx h
			mov m, e
			ret

SkeletonImpact:
			; de - ptr to monsterImpactPtr+1
			LXI_H_TO_DIFF(monsterUpdatePtr+1, monsterImpactPtr+1)
			dad d
			jmp MonstersSetDestroy

; draw a sprite into a backbuffer
; in:
; de - ptr to monsterDrawPtr in the runtime data
SkeletonDraw:
			LXI_H_TO_DIFF(monsterPosX+1, monsterDrawPtr)
			dad d
			call SpriteGetScrAddr_skeleton
			; hl - ptr to monsterPosY+1
			; tmp a = c
			mov a, c

			; advance to monsterAnimPtr
			LXI_B_TO_DIFF(monsterAnimPtr, monsterPosY+1)
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

			CALL_RAM_DISK_FUNC(__DrawSpriteVM, __RAM_DISK_S_SKELETON | __RAM_DISK_M_DRAW_SPRITE_VM | RAM_DISK_M_8F)
			pop h
			inx h
			; hl - ptr to monsterEraseScrAddr
			; store a current scr addr, into monsterEraseScrAddr
			mov m, c
			inx h
			mov m, b
			; advance to monsterEraseWH
			LXI_B_TO_DIFF(monsterEraseWH, monsterEraseScrAddr+1)
			dad b
			; store a width and a height into monsterEraseWH
			mov m, e
			inx h
			mov m, d
			ret
			.closelabels