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
;		if distance(mob, hero) < a dashing radius:
;			status = dashPrep
;			statusTimer = dashPrepTime
;			anim to the hero dir
;		else:
;			updateAnim
;			check mod-hero collision, impact if collides
; dashPrep:
;	decr statusTimer
;	if statusTimer == 0:
;		status = dash
;		anim = run
;		speed directly to the hero pos
;	else:
;		updateAnim
;		check mod-hero collision, impact if collides
; dash:
;	decr statusTimer
;	if statusTimer == 0:
;		status = relax
;		statusTimer = relaxTime
;	else:
;		move a mob
;		updateAnim
;		check mod-hero collision, impact if collides
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
BURNER_STATUS_DETECT_HERO_INIT	= 0
BURNER_STATUS_DETECT_HERO		= 1
BURNER_STATUS_DASH_PREP			= 2
BURNER_STATUS_DASH				= 3
BURNER_STATUS_RELAX				= 4
BURNER_STATUS_MOVE_INIT			= 5
BURNER_STATUS_MOVE				= 6

; status duration in updates.
BURNER_STATUS_DETECT_HERO_TIME	= 50
BURNER_STATUS_DASH_PREP_TIME	= 10
BURNER_STATUS_DASH_TIME			= 16
BURNER_STATUS_RELAX_TIME		= 25
BURNER_STATUS_MOVE_TIME			= 60

; animation speed (the less the slower, 0-255, 255 means the next frame is almost every update)
BURNER_ANIM_SPEED_DETECT_HERO	= 50
BURNER_ANIM_SPEED_RELAX			= 20
BURNER_ANIM_SPEED_MOVE			= 60
BURNER_ANIM_SPEED_DASH_PREP		= 100
BURNER_ANIM_SPEED_DASH			= 150

; gameplay
BURNER_DAMAGE = 1
BURNER_HEALTH = 1

BURNER_COLLISION_WIDTH	= 15
BURNER_COLLISION_HEIGHT	= 10

BURNER_MOVE_SPEED		= $0100
BURNER_MOVE_SPEED_NEG	= $ffff - $100 + 1

BURNER_DETECT_HERO_DISTANCE = 60

;========================================================
; called to spawn this monster
; in:
; c - tile idx in the room_tiles_data array.
; a - monster id * 4
; out:
; a = 0
BurnerInit:
			MONSTER_INIT(BurnerUpdate, BurnerDraw, BurnerImpact, BURNER_HEALTH, BURNER_STATUS_DETECT_HERO_INIT, burner_idle)
			ret
			.closelabels

; anim and a gameplay logic update
; in:
; de - ptr to monster_update_ptr in the runtime data
BurnerUpdate:
			; advance hl to monsterStatus
			LXI_H_TO_DIFF(monsterStatus, monster_update_ptr)
			dad d
			mov a, m
			; TODO: optimization. think of using a call table
			cpi BURNER_STATUS_MOVE
			jz BurnerUpdateMove
			cpi BURNER_STATUS_DETECT_HERO
			jz BurnerUpdateDetectHero
			cpi BURNER_STATUS_DASH
			jz BurnerUpdateDash		
			cpi BURNER_STATUS_RELAX
			jz BurnerUpdateRelax
			cpi BURNER_STATUS_DASH_PREP
			jz BurnerUpdateDashPrep
			cpi BURNER_STATUS_MOVE_INIT
			jz BurnerUpdateMoveInit
			cpi BURNER_STATUS_DETECT_HERO_INIT
			jz BurnerUpdateDetectHeroInit
			ret

BurnerUpdateDetectHeroInit:
			; hl = monsterStatus
			mvi m, BURNER_STATUS_DETECT_HERO
			inx h
			mvi m, BURNER_STATUS_DETECT_HERO_TIME
			LXI_B_TO_DIFF(monsterAnimPtr, monsterStatusTimer)
			dad b
			mvi m, <burner_idle
			inx h
			mvi m, >burner_idle
			ret

BurnerUpdateDetectHero:
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
			lda hero_pos_x+1
			sub m
			jc @checkNegPosXDiff
			cpi BURNER_DETECT_HERO_DISTANCE
			jc @checkPosYDiff
			jmp @updateAnimHeroDetectX
@checkNegPosXDiff:
			cpi -BURNER_DETECT_HERO_DISTANCE
			jnc @checkPosYDiff
			jmp @updateAnimHeroDetectX
@checkPosYDiff:
			; advance hl to monsterPosY+1
			inx_h(2)
			; check hero-monster posY diff
			lda hero_pos_y+1
			sub m
			jc @checkNegPosYDiff
			cpi BURNER_DETECT_HERO_DISTANCE
			jc @heroDetected
			jmp @updateAnimHeroDetectY
@checkNegPosYDiff:
			cpi -BURNER_DETECT_HERO_DISTANCE
			jnc @heroDetected
			jmp @updateAnimHeroDetectY
@heroDetected:
			; hl = monsterPosY+1
			; advance hl to monsterStatus
			LXI_B_TO_DIFF(monsterStatus, monsterPosY+1)
			dad b
			mvi m, BURNER_STATUS_DASH_PREP
			inx h
			mvi m, BURNER_STATUS_DASH_PREP_TIME
			; advance hl to monsterAnimPtr
			LXI_B_TO_DIFF(monsterAnimPtr, monsterStatusTimer)
			dad b
			mvi m, <burner_dash
			inx h
			mvi m, >burner_dash
			ret
			
@updateAnimHeroDetectX:
			; advance hl to monsterAnimTimer
			LXI_B_TO_DIFF(monsterAnimTimer, monsterPosX+1)
			dad b
			mvi a, BURNER_ANIM_SPEED_DETECT_HERO
			jmp BurnerUpdateAnimCheckCollisionHero
@updateAnimHeroDetectY:
			; advance hl to monsterAnimTimer
			LXI_B_TO_DIFF(monsterAnimTimer, monsterPosY+1)
			dad b
			mvi a, BURNER_ANIM_SPEED_DETECT_HERO
			jmp BurnerUpdateAnimCheckCollisionHero

@setMoveInit:
 			; hl - ptr to monsterStatusTimer
			mvi m, BURNER_STATUS_MOVE_TIME ; TODO: use a rnd number instead of a const
			; advance hl to monsterStatus
			dcx h
			mvi m, BURNER_STATUS_MOVE_INIT
			ret

BurnerUpdateMoveInit:
			; hl = monsterStatus
			mvi m, BURNER_STATUS_MOVE

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
			mvi m, <BURNER_MOVE_SPEED_NEG
			inx h
			mvi m, >BURNER_MOVE_SPEED_NEG
			jmp @setAnim
@speedYp:
			mov m, c
			inx h
			mov m, c
			inx h
			mvi m, <BURNER_MOVE_SPEED
			inx h
			mvi m, >BURNER_MOVE_SPEED
			jmp @setAnim
@speedXn:
			mvi m, <BURNER_MOVE_SPEED_NEG
			inx h
			mvi m, >BURNER_MOVE_SPEED_NEG
			inx h
			mov m, c
			inx h
			mov m, c
			jmp @setAnim
@speedXp:
			mvi m, <BURNER_MOVE_SPEED
			inx h
			mvi m, >BURNER_MOVE_SPEED
			inx h
			mov m, c
			inx h
			mov m, c
@setAnim:
			LXI_B_TO_DIFF(monsterAnimPtr, monsterSpeedY+1)
			dad b
			; a = rnd
			ora a
			; if rnd is positive (up or right movement), then play burner_run_r anim
			jp @setAnimRunR
@setAnimRunL:
			mvi m, <burner_run_l
			inx h
			mvi m, >burner_run_l
			ret
@setAnimRunR:
			mvi m, <burner_run_r
			inx h
			mvi m, >burner_run_r
            ret

BurnerUpdateMove:
			; hl = monsterStatus
			; advance hl to monsterStatusTimer
			inx h
			dcr m
			jz @setDetectHeroInit
@updateMovement:
			ACTOR_UPDATE_MOVEMENT_CHECK_TILE_COLLISION(monsterStatusTimer, monsterPosX, BURNER_COLLISION_WIDTH, BURNER_COLLISION_HEIGHT, @setMoveInit) 
			
			; hl points to monsterPosY+1
			; advance hl to monsterAnimTimer
			LXI_B_TO_DIFF(monsterAnimTimer, monsterPosY+1)
			dad b
			mvi a, BURNER_ANIM_SPEED_MOVE
			jmp BurnerUpdateAnimCheckCollisionHero

@setMoveInit:
			pop h
			; hl points to monsterPosX
			; advance hl to monsterStatus
			LXI_B_TO_DIFF(monsterStatus, monsterPosX)
			dad b
			mvi m, BURNER_STATUS_MOVE_INIT
			inx h
			mvi m, BURNER_STATUS_MOVE_TIME
			ret
@setDetectHeroInit:
 			; hl - ptr to monsterStatusTimer
			; advance hl to monsterStatus
			dcx h
			mvi m, BURNER_STATUS_DETECT_HERO_INIT
			ret

BurnerUpdateRelax:
			; hl = monsterStatus
			; advance hl to monsterStatusTimer
			inx h
			dcr m
			jz @setMoveInit
			; advance hl to monsterAnimTimer
			LXI_B_TO_DIFF(monsterAnimTimer, monsterStatusTimer)
			dad b
			mvi a, BURNER_ANIM_SPEED_RELAX
			jmp BurnerUpdateAnimCheckCollisionHero
 @setMoveInit:
 			; hl - ptr to monsterStatusTimer
			mvi m, BURNER_STATUS_MOVE_TIME
			; advance hl to monsterStatus
			dcx h
			mvi m, BURNER_STATUS_MOVE_INIT
			ret

BurnerUpdateDashPrep:
			; hl = monsterStatus
			; advance hl to monsterStatusTimer
			inx h
			dcr m
			jz @setDash
			; advance hl to monsterAnimTimer
			LXI_B_TO_DIFF(monsterAnimTimer, monsterStatusTimer)
			dad b
			mvi a, BURNER_ANIM_SPEED_DASH_PREP
			jmp BurnerUpdateAnimCheckCollisionHero
 @setDash:
  			; hl - ptr to monsterStatusTimer
			mvi m, BURNER_STATUS_DASH_TIME
			; advance hl to monsterStatus
			dcx h
			mvi m, BURNER_STATUS_DASH
			; advance hl to monsterPosX
			LXI_B_TO_DIFF(monsterPosX, monsterStatus)
			dad b
			; reset sub pixel posX
			mvi m, 0
			; advance hl to posX+1
			inx h
			; posDiff =  heroPos - burnerPosX
			; speed = posDiff / BURNER_STATUS_DASH_TIME
			lda hero_pos_x+1
			sub m
			mov e, a 
			mvi a, 0
			; if posDiffX < 0, then d = $ff, else d = 0
			sbb a
			mov d, a
			xchg
			; posDiffX / BURNER_STATUS_DASH_TIME 
			dad h 
			dad h 
			dad h 
			dad h
			; to fill up L with %1111 if posDiff < 0
			ani %1111 ; <(%0000000011111111 / BURNER_STATUS_DASH_TIME)
			ora l
			mov l, a
			push h
			xchg
			; advance hl to posY
			inx h
			; reset sub pixel posY
			mvi m, 0
			; advance hl to posY+1
			inx h
			; do the same for Y
			lda hero_pos_y+1
			sub m
			mov e, a 
			mvi a, 0
			; if posDiffY < 0, then d = $ff, else d = 0
			sbb a
			mov d, a 
			xchg
			; posDiffY / BURNER_STATUS_DASH_TIME 
			dad h 
			dad h 
			dad h 
			dad h 
			; to fill up L with %1111 if posDiff < 0
			ani %1111 ; <(%0000000011111111 / BURNER_STATUS_DASH_TIME)
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

BurnerUpdateDash:
			; hl = monsterStatus
			; advance hl to monsterStatusTimer
			inx h
			dcr m
			jm @setMoveInit
@applyMovement:
			ACTOR_UPDATE_MOVEMENT(monsterStatusTimer, monsterSpeedY)
			; advance hl to monsterAnimTimer
			LXI_B_TO_DIFF(monsterAnimTimer, monsterPosX+1)
			dad b
			mvi a, BURNER_ANIM_SPEED_DASH
			jmp actor_anim_update
@setMoveInit:
			; hl points to monsterStatusTimer
			mvi m, BURNER_STATUS_MOVE_TIME			
			; advance hl to monsterStatus
			dcx h
			mvi m, BURNER_STATUS_MOVE_INIT
			ret	


; in:
; hl - monsterAnimTimer
; a - anim speed
BurnerUpdateAnimCheckCollisionHero:
			call actor_anim_update
			MONSTER_CHECK_COLLISION_HERO(BURNER_COLLISION_WIDTH, BURNER_COLLISION_HEIGHT, BURNER_DAMAGE)

BurnerImpact:
			; de - ptr to monster_impact_ptr+1
			LXI_H_TO_DIFF(monster_update_ptr+1, monster_impact_ptr+1)
			dad d
			jmp MonstersDestroy

; draw a sprite into a backbuffer
; in:
; de - ptr to monsterDrawPtr in the runtime data
BurnerDraw:
			MONSTER_DRAW(sprite_get_scr_addr_burner, __RAM_DISK_S_BURNER)