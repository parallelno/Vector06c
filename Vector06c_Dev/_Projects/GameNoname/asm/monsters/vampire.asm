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
VAMPIRE_STATUS_DETECT_HERO_INIT	= 0
VAMPIRE_STATUS_DETECT_HERO			= 1
VAMPIRE_STATUS_SHOOT_PREP			= 2
VAMPIRE_STATUS_SHOOT				= 3
VAMPIRE_STATUS_RELAX				= 4
VAMPIRE_STATUS_MOVE_INIT			= 5
VAMPIRE_STATUS_MOVE				= 6

; status duration in updates.
VAMPIRE_STATUS_DETECT_HERO_TIME	= 50
VAMPIRE_STATUS_SHOOT_PREP_TIME		= 30
VAMPIRE_STATUS_RELAX_TIME			= 25
VAMPIRE_STATUS_MOVE_TIME			= 75

; animation speed (the less the slower, 0-255, 255 means the next frame is almost every update)
VAMPIRE_ANIM_SPEED_DETECT_HERO	= 30
VAMPIRE_ANIM_SPEED_RELAX		= 20
VAMPIRE_ANIM_SPEED_MOVE		= 50
VAMPIRE_ANIM_SPEED_SHOOT_PREP	= 1

; gameplay
VAMPIRE_DAMAGE = 1
VAMPIRE_HEALTH = 1

VAMPIRE_COLLISION_WIDTH	= 15
VAMPIRE_COLLISION_HEIGHT	= 10

VAMPIRE_MOVE_SPEED		= $0100
VAMPIRE_MOVE_SPEED_NEG	= $ffff - $100 + 1

VAMPIRE_DETECT_HERO_DISTANCE = 60

;========================================================
; called to spawn this monster
; in:
; c - tile idx in the roomTilesData array.
; a - monster id * 2
; out:
; a = 0
VampireInit:
			call MonstersGetEmptyDataPtr
			; hl - ptr to monsterUpdatePtr+1
			; advance hl to monsterUpdatePtr
			dcx h
			mvi m, <VampireUpdate
			inx h
			mvi m, >VampireUpdate
			; advance hl to monsterDrawPtr
			inx h
			mvi m, <VampireDraw
			inx h
			mvi m, >VampireDraw
			; advance hl to monsterImpactPtr
			inx h
			mvi m, <VampireImpact
			inx h
			mvi m, >VampireImpact

			; advance hl to monsterType
			inx h
			mvi m, MONSTER_TYPE_ENEMY
			; advance hl to monsterHealth
			inx h
			mvi m, VAMPIRE_HEALTH
			; advance hl to monsterStatus
			inx h
			mvi m, VAMPIRE_STATUS_DETECT_HERO_INIT
			; advance hl to monsterAnimPtr
			LXI_D_TO_DIFF(monsterAnimPtr, monsterStatus)
			dad d
			mvi m, <vampire_idle
			inx h
			mvi m, >vampire_idle

			; c - tileIdx
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
			mvi e, 0
			; d = scrX
			; b = posX
			; a = posY
			; e = 0 and SPRITE_W_PACKED_MIN
			; hl - ptr to monsterUpdatePtr+1

			; advance hl to monsterEraseScrAddr
			inx h
			mov m, a
			inx h
			mov m, d
			; advance hl to monsterEraseScrAddrOld
			inx h
			mov m, a
			inx h
			mov m, d
			; advance hl to monsterEraseWH
			inx h
			mvi m, SPRITE_H_MIN
			inx h
			mov m, e
			; advance hl to monsterEraseWHOld
			inx h
			mvi m, SPRITE_H_MIN
			inx h
			mov m, e
			; advance hl to monsterPosX
			inx h
			mov m, e
			inx h
			mov m, b
			; advance hl to monsterPosY
			inx h
			mov m, e
			inx h
			mov m, a

			; return zero to erase the tile data
			; there this monster was in the roomTilesData
			xra a
			ret
			.closelabels

; anim and a gameplay logic update
; in:
; de - ptr to monsterUpdatePtr in the runtime data
VampireUpdate:
			; advance hl to monsterStatus
			LXI_H_TO_DIFF(monsterStatus, monsterUpdatePtr)
			dad d
			mov a, m
			; TODO: optimization. think of using a call table
			cpi VAMPIRE_STATUS_MOVE
			jz VampireUpdateMove
			cpi VAMPIRE_STATUS_DETECT_HERO
			jz VampireUpdateDetectHero
			cpi VAMPIRE_STATUS_RELAX
			jz VampireUpdateRelax
			cpi VAMPIRE_STATUS_SHOOT_PREP
			jz VampireUpdateShootPrep
			cpi VAMPIRE_STATUS_MOVE_INIT
			jz VampireUpdateMoveInit
			cpi VAMPIRE_STATUS_DETECT_HERO_INIT
			jz VampireUpdateDetectHeroInit
			cpi VAMPIRE_STATUS_SHOOT
			jz VampireUpdateShoot
			ret

VampireUpdateDetectHeroInit:
			; hl = monsterStatus
			mvi m, VAMPIRE_STATUS_DETECT_HERO
			inx h
			mvi m, VAMPIRE_STATUS_DETECT_HERO_TIME
			LXI_B_TO_DIFF(monsterAnimPtr, monsterStatusTimer)
			dad b
			mvi m, <vampire_idle
			inx h
			mvi m, >vampire_idle
			ret

VampireUpdateDetectHero:
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
			cpi VAMPIRE_DETECT_HERO_DISTANCE
			jc @checkPosYDiff
			jmp @updateAnimHeroDetectX
@checkNegPosXDiff:
			cpi -VAMPIRE_DETECT_HERO_DISTANCE
			jnc @checkPosYDiff
			jmp @updateAnimHeroDetectX
@checkPosYDiff:
			; advance hl to monsterPosY+1
			inx_h(2)
			; check hero-monster posY diff
			lda heroPosY+1
			sub m
			jc @checkNegPosYDiff
			cpi VAMPIRE_DETECT_HERO_DISTANCE
			jc @detectsHero
			jmp @updateAnimHeroDetectY
@checkNegPosYDiff:
			cpi -VAMPIRE_DETECT_HERO_DISTANCE
			jnc @detectsHero
			jmp @updateAnimHeroDetectY
@detectsHero:
			; hl = monsterPosY+1
			; advance hl to monsterStatus
			LXI_B_TO_DIFF(monsterStatus, monsterPosY+1)
			dad b
			mvi m, VAMPIRE_STATUS_SHOOT_PREP
			inx h
			mvi m, VAMPIRE_STATUS_SHOOT_PREP_TIME
			; advance hl to monsterAnimPtr
			LXI_B_TO_DIFF(monsterAnimPtr, monsterStatusTimer)
			dad b
			mvi m, <vampire_cast
			inx h
			mvi m, >vampire_cast
			ret
@updateAnimHeroDetectX:
			; advance hl to monsterAnimTimer
			LXI_B_TO_DIFF(monsterAnimTimer, monsterPosX+1)
			dad b
			mvi a, VAMPIRE_ANIM_SPEED_DETECT_HERO
			jmp VampireUpdateAnimCheckCollisionHero
@updateAnimHeroDetectY:
			; advance hl to monsterAnimTimer
			LXI_B_TO_DIFF(monsterAnimTimer, monsterPosY+1)
			dad b
			mvi a, VAMPIRE_ANIM_SPEED_DETECT_HERO
			jmp VampireUpdateAnimCheckCollisionHero

@setMoveInit:
 			; hl - ptr to monsterStatusTimer
			mvi m, VAMPIRE_STATUS_MOVE_TIME
			; advance hl to monsterStatus
			dcx h
			mvi m, VAMPIRE_STATUS_MOVE_INIT
			ret

VampireUpdateMoveInit:
			; hl = monsterStatus
			mvi m, VAMPIRE_STATUS_MOVE
			;inx h
			;mvi m, VAMPIRE_STATUS_MOVE_TIME ; TODO: use a rnd number instead of a const

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
			mvi m, <VAMPIRE_MOVE_SPEED_NEG
			inx h
			mvi m, >VAMPIRE_MOVE_SPEED_NEG
			jmp @setAnim
@speedYp:
			mov m, c
			inx h
			mov m, c
			inx h
			mvi m, <VAMPIRE_MOVE_SPEED
			inx h
			mvi m, >VAMPIRE_MOVE_SPEED
			jmp @setAnim
@speedXn:
			mvi m, <VAMPIRE_MOVE_SPEED_NEG
			inx h
			mvi m, >VAMPIRE_MOVE_SPEED_NEG
			inx h
			mov m, c
			inx h
			mov m, c
			jmp @setAnim
@speedXp:
			mvi m, <VAMPIRE_MOVE_SPEED
			inx h
			mvi m, >VAMPIRE_MOVE_SPEED
			inx h
			mov m, c
			inx h
			mov m, c
@setAnim:
			LXI_B_TO_DIFF(monsterAnimPtr, monsterSpeedY+1)
			dad b
			; a = rnd
			ora a
			; if rnd is positive (up or right movement), then play vampire_run_r anim
			jp @setAnimRunR
@setAnimRunL:
			mvi m, <vampire_run_l
			inx h
			mvi m, >vampire_run_l
			ret
@setAnimRunR:
			mvi m, <vampire_run_r
			inx h
			mvi m, >vampire_run_r
            ret

VampireUpdateMove:
			; hl = monsterStatus
			; advance hl to monsterStatusTimer
			inx h
			dcr m
			jz @setDetectHeroInit
@updateMovement:
			ACTOR_UPDATE_MOVEMENT_CHECK_TILE_COLLISION(monsterStatusTimer, monsterPosX, VAMPIRE_COLLISION_WIDTH, VAMPIRE_COLLISION_HEIGHT, @setMoveInit) 
			
			; hl points to monsterPosY+1
			; advance hl to monsterAnimTimer
			LXI_B_TO_DIFF(monsterAnimTimer, monsterPosY+1)
			dad b
			mvi a, VAMPIRE_ANIM_SPEED_MOVE
			jmp VampireUpdateAnimCheckCollisionHero

@setMoveInit:
			pop h
			; hl points to monsterPosX
			; advance hl to monsterStatus
			LXI_B_TO_DIFF(monsterStatus, monsterPosX)
			dad b
			mvi m, VAMPIRE_STATUS_MOVE_INIT
			ret
@setDetectHeroInit:
 			; hl - ptr to monsterStatusTimer
			; advance hl to monsterStatus
			dcx h
			mvi m, VAMPIRE_STATUS_DETECT_HERO_INIT
			ret

VampireUpdateRelax:
			; hl = monsterStatus
			; advance hl to monsterStatusTimer
			inx h
			dcr m
			jz @setMoveInit
			; advance hl to monsterAnimTimer
			LXI_B_TO_DIFF(monsterAnimTimer, monsterStatusTimer)
			dad b
			mvi a, VAMPIRE_ANIM_SPEED_RELAX
			jmp VampireUpdateAnimCheckCollisionHero
 @setMoveInit:
 			; hl - ptr to monsterStatusTimer
			; advance hl to monsterStatus
			dcx h
			mvi m, VAMPIRE_STATUS_MOVE_INIT
			ret

VampireUpdateShootPrep:
			; hl = monsterStatus
			; advance hl to monsterStatusTimer
			inx h
			dcr m
			jz @setShoot
			; advance hl to monsterAnimTimer
			LXI_B_TO_DIFF(monsterAnimTimer, monsterStatusTimer)
			dad b
			mvi a, VAMPIRE_ANIM_SPEED_SHOOT_PREP
			jmp VampireUpdateAnimCheckCollisionHero
 @setShoot:
  			; hl - ptr to monsterStatusTimer
			; advance hl to monsterStatus
			dcx h
			mvi m, VAMPIRE_STATUS_SHOOT
			ret

VampireUpdateShoot:
			; hl = monsterStatus
			mvi m, VAMPIRE_STATUS_RELAX
			; advance hl to monsterStatusTimer
			inx h
			mvi m, VAMPIRE_STATUS_RELAX_TIME

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
			jmp BombSlowInit

; in:
; hl - monsterAnimTimer
; a - anim speed
VampireUpdateAnimCheckCollisionHero:
			MONSTER_UPDATE_ANIM_CHECK_COLLISION_HERO(VAMPIRE_COLLISION_WIDTH, VAMPIRE_COLLISION_HEIGHT, VAMPIRE_DAMAGE)

VampireImpact:
			; de - ptr to monsterImpactPtr+1
			LXI_H_TO_DIFF(monsterUpdatePtr+1, monsterImpactPtr+1)
			dad d
			jmp MonstersDestroy

; draw a sprite into a backbuffer
; in:
; de - ptr to monsterDrawPtr in the runtime data
VampireDraw:
			MONSTER_DRAW(SpriteGetScrAddr_vampire, __RAM_DISK_S_VAMPIRE)