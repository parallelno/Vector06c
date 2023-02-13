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
;			status = defencePrep
;		else:
;			updateAnim
;			check mod-hero collision, impact if collides
; defencePrep:
;	status = defence
;	statusTimer = defenceTime
;	anim = run to the hero dir
;	
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
KNIGHT_STATUS_DEFENCE_INIT		= 2
KNIGHT_STATUS_DEFENCE			= 3
KNIGHT_STATUS_MOVE_INIT			= 4
KNIGHT_STATUS_MOVE				= 5

; status duration in updates.
KNIGHT_STATUS_DETECT_HERO_TIME	= 100
KNIGHT_STATUS_DEFENCE_TIME		= 30
KNIGHT_STATUS_MOVE_TIME			= 50

; animation speed (the less the slower, 0-255, 255 means the next frame is almost every update)
KNIGHT_ANIM_SPEED_DETECT_HERO	= 10
KNIGHT_ANIM_SPEED_DEFENCE		= 100
KNIGHT_ANIM_SPEED_MOVE			= 50

; gameplay
KNIGHT_DAMAGE = 1
KNIGHT_HEALTH = 1

KNIGHT_COLLISION_WIDTH	= 15
KNIGHT_COLLISION_HEIGHT	= 10

KNIGHT_MOVE_SPEED		= $0060
KNIGHT_MOVE_SPEED_NEG	= $ffff - $60 + 1

KNIGHT_DEFENCE_SPEED		= $0100
KNIGHT_DEFENCE_SPEED_NEG	= $ffff - $100 + 1

KNIGHT_DETECT_HERO_DISTANCE = 60

;========================================================
; called to spawn this monster
; in:
; c - tile idx in the room_tiles_data array.
; a - monster id * 4
; out:
; a = 0
KnightInit:
			MONSTER_INIT(KnightUpdate, KnightDraw, KnightImpact, KNIGHT_HEALTH, KNIGHT_STATUS_DETECT_HERO_INIT, knight_idle)
			ret

; anim and a gameplay logic update
; in:
; de - ptr to monster_update_ptr in the runtime data
KnightUpdate:
			; advance hl to monsterStatus
			LXI_H_TO_DIFF(monsterStatus, monster_update_ptr)
			dad d
			mov a, m
			; TODO: optimization. think of using a call table
			cpi KNIGHT_STATUS_MOVE
			jz KnightUpdateMove
			cpi KNIGHT_STATUS_DETECT_HERO
			jz KnightUpdateDetectHero
			cpi KNIGHT_STATUS_DEFENCE
			jz KnightUpdateDefence			
			cpi KNIGHT_STATUS_MOVE_INIT
			jz KnightUpdateMoveInit
			cpi KNIGHT_STATUS_DEFENCE_INIT
			jz KnightUpdateDefenceInit
			cpi KNIGHT_STATUS_DETECT_HERO_INIT
			jz KnightUpdateDetectHeroInit
			ret

KnightUpdateDetectHeroInit:
			; hl = monsterStatus
			mvi m, KNIGHT_STATUS_DETECT_HERO
			inx h
			mvi m, KNIGHT_STATUS_DETECT_HERO_TIME
			LXI_B_TO_DIFF(monsterAnimPtr, monsterStatusTimer)
			dad b
			mvi m, <knight_idle
			inx h
			mvi m, >knight_idle
			ret

KnightUpdateDetectHero:
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
			cpi KNIGHT_DETECT_HERO_DISTANCE
			jc @checkPosYDiff
			jmp @updateAnimHeroDetectX
@checkNegPosXDiff:
			cpi -KNIGHT_DETECT_HERO_DISTANCE
			jnc @checkPosYDiff
			jmp @updateAnimHeroDetectX
@checkPosYDiff:
			; advance hl to monsterPosY+1
			inx_h(2)
			; check hero-monster posY diff
			lda hero_pos_y+1
			sub m
			jc @checkNegPosYDiff
			cpi KNIGHT_DETECT_HERO_DISTANCE
			jc @heroDetected
			jmp @updateAnimHeroDetectY
@checkNegPosYDiff:
			cpi -KNIGHT_DETECT_HERO_DISTANCE
			jnc @heroDetected
			jmp @updateAnimHeroDetectY
@heroDetected:
			; hl = monsterPosY+1
			; advance hl to monsterStatus
			LXI_B_TO_DIFF(monsterStatus, monsterPosY+1)
			dad b
			mvi m, KNIGHT_STATUS_DEFENCE_INIT
			ret
			
@updateAnimHeroDetectX:
			; advance hl to monsterAnimTimer
			LXI_B_TO_DIFF(monsterAnimTimer, monsterPosX+1)
			dad b
			mvi a, KNIGHT_ANIM_SPEED_DETECT_HERO
			jmp KnightUpdateAnimCheckCollisionHero
@updateAnimHeroDetectY:
			; advance hl to monsterAnimTimer
			LXI_B_TO_DIFF(monsterAnimTimer, monsterPosY+1)
			dad b
			mvi a, KNIGHT_ANIM_SPEED_DETECT_HERO
			jmp KnightUpdateAnimCheckCollisionHero

@setMoveInit:
 			; hl - ptr to monsterStatusTimer
			mvi m, KNIGHT_STATUS_MOVE_TIME ; TODO: use a rnd number instead of a const
			; advance hl to monsterStatus
			dcx h
			mvi m, KNIGHT_STATUS_MOVE_INIT
			ret

KnightUpdateDefenceInit:
			; hl - ptr to monsterStatus
			mvi m, KNIGHT_STATUS_DEFENCE
			; advance hl to monsterStatusTimer
			inx h
			mvi m, KNIGHT_STATUS_DEFENCE_TIME
@checkAnimDirection:
			; aim the monster to the hero dir
			; advance hl to monsterPosX+1
			LXI_B_TO_DIFF(monsterPosX+1, monsterStatusTimer)
			dad b
			lda hero_pos_x+1
			cmp m
			lxi d, knight_defence_l
			jc @dirXNeg
@dirXPos:			
			lxi d, knight_defence_r
@dirXNeg:
			; advance hl to monsterAnimPtr
			LXI_B_TO_DIFF(monsterAnimPtr, monsterPosX+1)
			dad b	
			mov m, e
			inx h
			mov m, d

			; set the speed according to a monster_id (KNIGHT_HORIZ_ID / KNIGHT_VERT_ID)
			; advance hl to monster_id
			LXI_B_TO_DIFF(monster_id, monsterAnimPtr+1)
			dad b
			mov a, m		
			cpi <KNIGHT_HORIZ_ID
			jnz @speedVert
@speedHoriz:
			; advance hl to monsterSpeedX
			LXI_B_TO_DIFF(monsterSpeedX, monster_id)
			dad b
			; dir positive if e == knight_defence_r and vise versa
			mvi a, <knight_defence_r
			cmp e
			lxi d, KNIGHT_DEFENCE_SPEED_NEG
			jnz @speedXNeg
@speedXPos:
			lxi d, KNIGHT_DEFENCE_SPEED
@speedXNeg:
			mov m, e
			inx h
			mov m, d
			; advance hl to monsterSpeedY
			inx h
			xra a
			mov m, a
			inx h
			mov m, a
			ret
@speedVert:
			; advance hl to monsterPosY+1
			LXI_B_TO_DIFF(monsterPosY+1, monster_id)
			dad b
			lda hero_pos_y+1
			cmp m
			lxi d, KNIGHT_DEFENCE_SPEED_NEG
			jc @speedYNeg
@speedYPos:
			lxi d, KNIGHT_DEFENCE_SPEED
@speedYNeg:
			; advance hl to monsterSpeedX
			inx h
			xra a
			mov m, a
			inx h
			mov m, a
			; advance hl to monsterSpeedY
			inx h
			mov m, e
			inx h
			mov m, d
			ret

KnightUpdateDefence:
			; hl = monsterStatus
			; advance hl to monsterStatusTimer
			inx h
			dcr m
			jz @setDetectHeroInit
@updateMovement:
			ACTOR_UPDATE_MOVEMENT_CHECK_TILE_COLLISION(monsterStatusTimer, monsterPosX, KNIGHT_COLLISION_WIDTH, KNIGHT_COLLISION_HEIGHT, @collidedWithTiles) 
			
			; hl points to monsterPosY+1
			; advance hl to monsterAnimTimer
			LXI_B_TO_DIFF(monsterAnimTimer, monsterPosY+1)
			dad b
			mvi a, KNIGHT_ANIM_SPEED_DEFENCE
			jmp KnightUpdateAnimCheckCollisionHero

@collidedWithTiles:
			pop h
			; hl points to monsterPosX
			; advance hl to monsterStatus
			LXI_B_TO_DIFF(monsterStatus, monsterPosX)
			dad b
			mvi m, KNIGHT_STATUS_DEFENCE_INIT
			ret
@setDetectHeroInit:
 			; hl - ptr to monsterStatusTimer
			mvi m, KNIGHT_STATUS_DETECT_HERO_TIME ; TODO: seems unnecessary code
			; advance hl to monsterStatus
			dcx h
			mvi m, KNIGHT_STATUS_DETECT_HERO_INIT
			ret	

KnightUpdateMoveInit:
			; hl = monsterStatus
			mvi m, KNIGHT_STATUS_MOVE
			; advance hl to monsterStatusTimer

			; advance hl to monsterSpeedX
			LXI_D_TO_DIFF(monster_id, monsterStatus)
			dad d
			mov a, m
			cpi <KNIGHT_HORIZ_ID
			lxi b, (%10000000)<<8 ; tmp c = 0 
			jnz @verticalMovement
			mvi b, %00000000
@verticalMovement:			
			xchg
			call Random
			ani %01111111 ; to clear the last bit
			ora b
			; advance hl to monsterSpeedX
			LXI_H_TO_DIFF(monsterSpeedX, monster_id)
			dad d

			cpi $40
			jc @speedXp
			cpi $80
			jc @speedXn
			cpi $c0
			jc @speedYp
@speedYn:
			mov m, c
			inx h
			mov m, c
			inx h
			mvi m, <KNIGHT_MOVE_SPEED_NEG
			inx h
			mvi m, >KNIGHT_MOVE_SPEED_NEG
			jmp @setAnim
@speedYp:
			mov m, c
			inx h
			mov m, c
			inx h
			mvi m, <KNIGHT_MOVE_SPEED
			inx h
			mvi m, >KNIGHT_MOVE_SPEED
			jmp @setAnim
@speedXn:
			mvi m, <KNIGHT_MOVE_SPEED_NEG
			inx h
			mvi m, >KNIGHT_MOVE_SPEED_NEG
			inx h
			mov m, c
			inx h
			mov m, c
			jmp @setAnim
@speedXp:
			mvi m, <KNIGHT_MOVE_SPEED
			inx h
			mvi m, >KNIGHT_MOVE_SPEED
			inx h
			mov m, c
			inx h
			mov m, c
@setAnim:
			LXI_B_TO_DIFF(monsterAnimPtr, monsterSpeedY+1)
			dad b
			; a = rnd
			;ora a
			adi $40
			; if rnd is positive (up or right movement), then play knight_run_r anim
			jp @setAnimRunR
@setAnimRunL:
			mvi m, <knight_run_l
			inx h
			mvi m, >knight_run_l
			ret
@setAnimRunR:
			mvi m, <knight_run_r
			inx h
			mvi m, >knight_run_r
            ret

KnightUpdateMove:
			; hl = monsterStatus
			; advance hl to monsterStatusTimer
			inx h
			dcr m
			jz @setDetectHeroInit
@updateMovement:
			ACTOR_UPDATE_MOVEMENT_CHECK_TILE_COLLISION(monsterStatusTimer, monsterPosX, KNIGHT_COLLISION_WIDTH, KNIGHT_COLLISION_HEIGHT, @setMoveInit) 
			
			; hl points to monsterPosY+1
			; advance hl to monsterAnimTimer
			LXI_B_TO_DIFF(monsterAnimTimer, monsterPosY+1)
			dad b
			mvi a, KNIGHT_ANIM_SPEED_MOVE
			jmp KnightUpdateAnimCheckCollisionHero

@setMoveInit:
			pop h
			; hl points to monsterPosX
			; advance hl to monsterStatus
			LXI_B_TO_DIFF(monsterStatus, monsterPosX)
			dad b
			mvi m, KNIGHT_STATUS_MOVE_INIT
			ret
@setDetectHeroInit:
 			; hl - ptr to monsterStatusTimer
			mvi m, KNIGHT_STATUS_DETECT_HERO_TIME ; TODO: seems unnecessary code
			; advance hl to monsterStatus
			dcx h
			mvi m, KNIGHT_STATUS_DETECT_HERO_INIT
			ret


; in:
; hl - monsterAnimTimer
; a - anim speed
KnightUpdateAnimCheckCollisionHero:
			call actor_anim_update
			MONSTER_CHECK_COLLISION_HERO(KNIGHT_COLLISION_WIDTH, KNIGHT_COLLISION_HEIGHT, KNIGHT_DAMAGE)

KnightImpact:
			; de - ptr to monster_impact_ptr+1
			LXI_H_TO_DIFF(monster_update_ptr+1, monster_impact_ptr+1)
			dad d
			jmp MonstersDestroy			

; draw a sprite into a backbuffer
; in:
; de - ptr to monsterDrawPtr in the runtime data
KnightDraw:
			MONSTER_DRAW(sprite_get_scr_addr_knight, __RAM_DISK_S_KNIGHT)