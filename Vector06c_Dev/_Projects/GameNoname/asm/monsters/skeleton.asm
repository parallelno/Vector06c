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
;			updateAnim
;			check mod-hero collision, impact if collides

; statuses.
SKELETON_STATUS_DETECT_HERO_INIT	= 0
SKELETON_STATUS_DETECT_HERO			= 1
SKELETON_STATUS_SHOOT_PREP			= 2
SKELETON_STATUS_SHOOT				= 3
SKELETON_STATUS_RELAX				= 4
SKELETON_STATUS_MOVE_INIT			= 5
SKELETON_STATUS_MOVE				= 6

; status duration in updates.
SKELETON_STATUS_DETECT_HERO_TIME	= 50
SKELETON_STATUS_SHOOT_PREP_TIME		= 10
SKELETON_STATUS_RELAX_TIME			= 25
SKELETON_STATUS_MOVE_TIME			= 50

; animation speed (the less the slower, 0-255, 255 means the next frame is almost every update)
SKELETON_ANIM_SPEED_DETECT_HERO	= 30
SKELETON_ANIM_SPEED_RELAX		= 20
SKELETON_ANIM_SPEED_MOVE		= 50
SKELETON_ANIM_SPEED_SHOOT_PREP	= 1

; gameplay
SKELETON_DAMAGE = 1
SKELETON_HEALTH = 1

SKELETON_COLLISION_WIDTH	= 15
SKELETON_COLLISION_HEIGHT	= 10

SKELETON_MOVE_SPEED		= $0100
SKELETON_MOVE_SPEED_NEG	= $ffff - $100 + 1

SKELETON_DETECT_HERO_DISTANCE = 60

;========================================================
; called to spawn this monster
; in:
; c - tile idx in the roomTilesData array.
; a - monster id * 4
; out:
; a = 0
SkeletonInit:
			MONSTER_INIT(SkeletonUpdate, SkeletonDraw, SkeletonImpact, SKELETON_HEALTH, SKELETON_STATUS_DETECT_HERO_INIT, skeleton_idle)
			ret

; anim and a gameplay logic update
; in:
; de - ptr to monsterUpdatePtr in the runtime data
SkeletonUpdate:
			; advance hl to monsterStatus
			LXI_H_TO_DIFF(monsterStatus, monsterUpdatePtr)
			dad d
			mov a, m
			; TODO: optimization. think of using a call table
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
			jc @heroDetected
			jmp @updateAnimHeroDetectY
@checkNegPosYDiff:
			cpi -SKELETON_DETECT_HERO_DISTANCE
			jnc @heroDetected
			jmp @updateAnimHeroDetectY
@heroDetected:
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
			mvi m, <skeleton_idle
			inx h
			mvi m, >skeleton_idle
			ret
@updateAnimHeroDetectX:
			; advance hl to monsterAnimTimer
			LXI_B_TO_DIFF(monsterAnimTimer, monsterPosX+1)
			dad b
			mvi a, SKELETON_ANIM_SPEED_DETECT_HERO
			jmp SkeletonUpdateAnimCheckCollisionHero
@updateAnimHeroDetectY:
			; advance hl to monsterAnimTimer
			LXI_B_TO_DIFF(monsterAnimTimer, monsterPosY+1)
			dad b
			mvi a, SKELETON_ANIM_SPEED_DETECT_HERO
			jmp SkeletonUpdateAnimCheckCollisionHero

@setMoveInit:
 			; hl - ptr to monsterStatusTimer
			mvi m, SKELETON_STATUS_MOVE_TIME
			; advance hl to monsterStatus
			dcx h
			mvi m, SKELETON_STATUS_MOVE_INIT
			ret

SkeletonUpdateMoveInit:
			; hl = monsterStatus
			mvi m, SKELETON_STATUS_MOVE
			;inx h
			;mvi m, SKELETON_STATUS_MOVE_TIME ; TODO: use a rnd number instead of a const

			xchg
			call Random
			; advance hl to monsterSpeedX
			LXI_H_TO_DIFF(monsterSpeedX, monsterStatus)
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
			mvi m, <SKELETON_MOVE_SPEED_NEG
			inx h
			mvi m, >SKELETON_MOVE_SPEED_NEG
			jmp @setAnim
@speedYp:
			mov m, c
			inx h
			mov m, c
			inx h
			mvi m, <SKELETON_MOVE_SPEED
			inx h
			mvi m, >SKELETON_MOVE_SPEED
			jmp @setAnim
@speedXn:
			mvi m, <SKELETON_MOVE_SPEED_NEG
			inx h
			mvi m, >SKELETON_MOVE_SPEED_NEG
			inx h
			mov m, c
			inx h
			mov m, c
			jmp @setAnim
@speedXp:
			mvi m, <SKELETON_MOVE_SPEED
			inx h
			mvi m, >SKELETON_MOVE_SPEED
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
			ACTOR_UPDATE_MOVEMENT_CHECK_TILE_COLLISION(monsterStatusTimer, monsterPosX, SKELETON_COLLISION_WIDTH, SKELETON_COLLISION_HEIGHT, @setMoveInit) 
			
			; hl points to monsterPosY+1
			; advance hl to monsterAnimTimer
			LXI_B_TO_DIFF(monsterAnimTimer, monsterPosY+1)
			dad b
			mvi a, SKELETON_ANIM_SPEED_MOVE
			jmp SkeletonUpdateAnimCheckCollisionHero

@setMoveInit:
			pop h
			; hl points to monsterPosX
			; advance hl to monsterStatus
			LXI_B_TO_DIFF(monsterStatus, monsterPosX)
			dad b
			mvi m, SKELETON_STATUS_MOVE_INIT
			inx h
			mvi m, SKELETON_STATUS_MOVE_TIME
			ret
@setDetectHeroInit:
 			; hl - ptr to monsterStatusTimer
			mvi m, SKELETON_STATUS_MOVE_TIME
			; advance hl to monsterStatus
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
			jmp SkeletonUpdateAnimCheckCollisionHero
 @setMoveInit:
 			; hl - ptr to monsterStatusTimer
			mvi m, SKELETON_STATUS_MOVE_TIME
			; advance hl to monsterStatus
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
			jmp SkeletonUpdateAnimCheckCollisionHero
 @setShoot:
  			; hl - ptr to monsterStatusTimer
			; advance hl to monsterStatus
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
			mvi a, BULLET_DIR_R
			jp @shootRight
@shootLeft:
			mvi a, BULLET_DIR_L
@shootRight:
			LXI_B_TO_DIFF(monsterPosX+1, monsterSpeedX+1)
			jmp @setBulletPos
@shootVert:
			; advance hl to monsterSpeedY+1
			inx_h(2)
			mov a, m
			ora a
			mvi a, BULLET_DIR_U
			jp @shootUp
@shootDown:
			mvi a, BULLET_DIR_D
@shootUp:
			LXI_B_TO_DIFF(monsterPosX+1, monsterSpeedY+1)
@setBulletPos:
			dad b
			mov b, m
			inx_h(2)
			mov c, m
			jmp ScytheInit

; in:
; hl - monsterAnimTimer
; a - anim speed
SkeletonUpdateAnimCheckCollisionHero:
			call ActorAnimUpdate
			MONSTER_CHECK_COLLISION_HERO(SKELETON_COLLISION_WIDTH, SKELETON_COLLISION_HEIGHT, SKELETON_DAMAGE)

SkeletonImpact:
			; de - ptr to monsterImpactPtr+1
			LXI_H_TO_DIFF(monsterUpdatePtr+1, monsterImpactPtr+1)
			dad d
			jmp MonstersDestroy

; draw a sprite into a backbuffer
; in:
; de - ptr to monsterDrawPtr in the runtime data
SkeletonDraw:
			MONSTER_DRAW(SpriteGetScrAddr_skeleton, __RAM_DISK_S_SKELETON)