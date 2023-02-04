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
KNIGHT_STATUS_MOVE_TIME				= 25

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
; a - monster id * 4
; out:
; a = 0
KnightInit:
			MONSTER_INIT(KnightUpdate, KnightDraw, KnightImpact, KNIGHT_HEALTH, KNIGHT_STATUS_DETECT_HERO_INIT, knight_idle)
			ret

; anim and a gameplay logic update
; in:
; de - ptr to monsterUpdatePtr in the runtime data
KnightUpdate:
			; advance hl to monsterStatus
			LXI_H_TO_DIFF(monsterStatus, monsterUpdatePtr)
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




; in:
; hl - monsterAnimTimer
; a - anim speed
KnightUpdateAnimCheckCollisionHero:
			call ActorAnimUpdate
			MONSTER_CHECK_COLLISION_HERO(KNIGHT_COLLISION_WIDTH, KNIGHT_COLLISION_HEIGHT, KNIGHT_DAMAGE)

KnightImpact:
			; de - ptr to monsterImpactPtr+1
			LXI_H_TO_DIFF(monsterUpdatePtr+1, monsterImpactPtr+1)
			dad d
			jmp MonstersDestroy			

; draw a sprite into a backbuffer
; in:
; de - ptr to monsterDrawPtr in the runtime data
KnightDraw:
			MONSTER_DRAW(SpriteGetScrAddr_knight, __RAM_DISK_S_KNIGHT)