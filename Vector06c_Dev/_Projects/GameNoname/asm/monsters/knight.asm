; mob AI:
; init:
;	 status = detectHeroInit
; detectHeroInit:
;	status = detectHero
;	status_timer = detectHeroTime
;	anim = idle.
; detectHero:
;	decr status_timer
;	if status_timer == 0:
;		status = moveInit
;	else:
;		if distance(mob, hero) < a defence radius:
;			status = defencePrep
;		else:
;			update_anim
;			check mod-hero collision, impact if collides
; defencePrep:
;	status = defence
;	status_timer = defenceTime
;	anim = run to the hero dir
;	
; defence:
;	if distance(mob, hero) < a defence radius:
;		try to move a mob toward a hero, reset one coord to move along one axis
;		if mob do not collides with tiles:
;			accept new pos
;		update_anim
;		check mod-hero collision, impact if collides
;	else:
;		status = detectHeroInit
; moveInit:
;	status = move
;	status_timer = random
;	speed = random dir only along one axis
;	set anim along the dir
; move:
;	decr status_timer
;	if status_timer = 0
;		status = detectHeroInit
;	else:
;		try to move a mob
;		if mob collides with tiles:
;			status = moveInit
;		else:
;			accept new pos
;			update_anim
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
; c - tile_idx in the room_tiledata array.
; a - monster_id * 4
; out:
; a = 0
knight_init:
			MONSTER_INIT(knight_update, knight_draw, monster_impacted, KNIGHT_HEALTH, KNIGHT_STATUS_DETECT_HERO_INIT, knight_idle)
			ret

; anim and a gameplay logic update
; in:
; de - ptr to monster_update_ptr in the runtime data
knight_update:
			; advance hl to monster_status
			LXI_H_TO_DIFF(monster_status, monster_update_ptr)
			dad d
			mov a, m
			; TODO: optimization. think of using a call table
			cpi KNIGHT_STATUS_MOVE
			jz knight_update_move
			cpi KNIGHT_STATUS_DETECT_HERO
			jz knight_update_detect_hero
			cpi KNIGHT_STATUS_DEFENCE
			jz knight_update_defence			
			cpi KNIGHT_STATUS_MOVE_INIT
			jz knight_update_move_init
			cpi KNIGHT_STATUS_DEFENCE_INIT
			jz knight_update_defence_init
			cpi KNIGHT_STATUS_DETECT_HERO_INIT
			jz knight_update_detect_hero_init
			ret

knight_update_detect_hero_init:
			; hl = monster_status
			mvi m, KNIGHT_STATUS_DETECT_HERO
			inx h
			mvi m, KNIGHT_STATUS_DETECT_HERO_TIME
			LXI_B_TO_DIFF(monster_anim_ptr, monster_status_timer)
			dad b
			mvi m, <knight_idle
			inx h
			mvi m, >knight_idle
			ret

knight_update_detect_hero:
			; hl = monster_status
			; advance hl to monster_status_timer
			inx h
			dcr m
			jz @setMoveInit
@checkMobHeroDistance:
			; advance hl to monster_pos_x+1
			LXI_B_TO_DIFF(monster_pos_x+1, monster_status_timer)
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
			; advance hl to monster_pos_y+1
			INX_H(2)
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
			; hl = monster_pos_y+1
			; advance hl to monster_status
			LXI_B_TO_DIFF(monster_status, monster_pos_y+1)
			dad b
			mvi m, KNIGHT_STATUS_DEFENCE_INIT
			ret
			
@updateAnimHeroDetectX:
			; advance hl to monster_anim_timer
			LXI_B_TO_DIFF(monster_anim_timer, monster_pos_x+1)
			dad b
			mvi a, KNIGHT_ANIM_SPEED_DETECT_HERO
			jmp knight_update_anim_check_collision_hero
@updateAnimHeroDetectY:
			; advance hl to monster_anim_timer
			LXI_B_TO_DIFF(monster_anim_timer, monster_pos_y+1)
			dad b
			mvi a, KNIGHT_ANIM_SPEED_DETECT_HERO
			jmp knight_update_anim_check_collision_hero

@setMoveInit:
 			; hl - ptr to monster_status_timer
			mvi m, KNIGHT_STATUS_MOVE_TIME ; TODO: use a rnd number instead of a const
			; advance hl to monster_status
			dcx h
			mvi m, KNIGHT_STATUS_MOVE_INIT
			ret

knight_update_defence_init:
			; hl - ptr to monster_status
			mvi m, KNIGHT_STATUS_DEFENCE
			; advance hl to monster_status_timer
			inx h
			mvi m, KNIGHT_STATUS_DEFENCE_TIME
@checkAnimDirection:
			; aim the monster to the hero dir
			; advance hl to monster_pos_x+1
			LXI_B_TO_DIFF(monster_pos_x+1, monster_status_timer)
			dad b
			lda hero_pos_x+1
			cmp m
			lxi d, knight_defence_l
			jc @dirXNeg
@dirXPos:			
			lxi d, knight_defence_r
@dirXNeg:
			; advance hl to monster_anim_ptr
			LXI_B_TO_DIFF(monster_anim_ptr, monster_pos_x+1)
			dad b	
			mov m, e
			inx h
			mov m, d

			; set the speed according to a monster_id (KNIGHT_HORIZ_ID / KNIGHT_VERT_ID)
			; advance hl to monster_id
			LXI_B_TO_DIFF(monster_id, monster_anim_ptr+1)
			dad b
			mov a, m		
			cpi <KNIGHT_HORIZ_ID
			jnz @speedVert
@speedHoriz:
			; advance hl to monster_speed_x
			LXI_B_TO_DIFF(monster_speed_x, monster_id)
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
			; advance hl to monster_speed_y
			inx h
			A_TO_ZERO(NULL_BYTE)
			mov m, a
			inx h
			mov m, a
			ret
@speedVert:
			; advance hl to monster_pos_y+1
			LXI_B_TO_DIFF(monster_pos_y+1, monster_id)
			dad b
			lda hero_pos_y+1
			cmp m
			lxi d, KNIGHT_DEFENCE_SPEED_NEG
			jc @speedYNeg
@speedYPos:
			lxi d, KNIGHT_DEFENCE_SPEED
@speedYNeg:
			; advance hl to monster_speed_x
			inx h
			A_TO_ZERO(NULL_BYTE)
			mov m, a
			inx h
			mov m, a
			; advance hl to monster_speed_y
			inx h
			mov m, e
			inx h
			mov m, d
			ret

knight_update_defence:
			; hl = monster_status
			; advance hl to monster_status_timer
			inx h
			dcr m
			jz @setDetectHeroInit
@update_movement:
			ACTOR_UPDATE_MOVEMENT_CHECK_TILE_COLLISION(monster_status_timer, monster_pos_x, KNIGHT_COLLISION_WIDTH, KNIGHT_COLLISION_HEIGHT, @collidedWithTiles) 
			
			; hl points to monster_pos_y+1
			; advance hl to monster_anim_timer
			LXI_B_TO_DIFF(monster_anim_timer, monster_pos_y+1)
			dad b
			mvi a, KNIGHT_ANIM_SPEED_DEFENCE
			jmp knight_update_anim_check_collision_hero

@collidedWithTiles:
			pop h
			; hl points to monster_pos_x
			; advance hl to monster_status
			LXI_B_TO_DIFF(monster_status, monster_pos_x)
			dad b
			mvi m, KNIGHT_STATUS_DEFENCE_INIT
			ret
@setDetectHeroInit:
 			; hl - ptr to monster_status_timer
			mvi m, KNIGHT_STATUS_DETECT_HERO_TIME ; TODO: seems unnecessary code
			; advance hl to monster_status
			dcx h
			mvi m, KNIGHT_STATUS_DETECT_HERO_INIT
			ret	

knight_update_move_init:
			; hl = monster_status
			mvi m, KNIGHT_STATUS_MOVE
			; advance hl to monster_status_timer

			; advance hl to monster_speed_x
			LXI_D_TO_DIFF(monster_id, monster_status)
			dad d
			mov a, m
			cpi <KNIGHT_HORIZ_ID
			lxi b, (%10000000)<<8 ; tmp c = 0 
			jnz @verticalMovement
			mvi b, %00000000
@verticalMovement:			
			xchg
			call random
			ani %01111111 ; to clear the last bit
			ora b
			; advance hl to monster_speed_x
			LXI_H_TO_DIFF(monster_speed_x, monster_id)
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
			LXI_B_TO_DIFF(monster_anim_ptr, monster_speed_y+1)
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

knight_update_move:
			; hl = monster_status
			; advance hl to monster_status_timer
			inx h
			dcr m
			jz @setDetectHeroInit
@update_movement:
			ACTOR_UPDATE_MOVEMENT_CHECK_TILE_COLLISION(monster_status_timer, monster_pos_x, KNIGHT_COLLISION_WIDTH, KNIGHT_COLLISION_HEIGHT, @setMoveInit) 
			
			; hl points to monster_pos_y+1
			; advance hl to monster_anim_timer
			LXI_B_TO_DIFF(monster_anim_timer, monster_pos_y+1)
			dad b
			mvi a, KNIGHT_ANIM_SPEED_MOVE
			jmp knight_update_anim_check_collision_hero

@setMoveInit:
			pop h
			; hl points to monster_pos_x
			; advance hl to monster_status
			LXI_B_TO_DIFF(monster_status, monster_pos_x)
			dad b
			mvi m, KNIGHT_STATUS_MOVE_INIT
			ret
@setDetectHeroInit:
 			; hl - ptr to monster_status_timer
			mvi m, KNIGHT_STATUS_DETECT_HERO_TIME ; TODO: seems unnecessary code
			; advance hl to monster_status
			dcx h
			mvi m, KNIGHT_STATUS_DETECT_HERO_INIT
			ret


; in:
; hl - monster_anim_timer
; a - anim speed
knight_update_anim_check_collision_hero:
			call actor_anim_update
			MONSTER_CHECK_COLLISION_HERO(KNIGHT_COLLISION_WIDTH, KNIGHT_COLLISION_HEIGHT, KNIGHT_DAMAGE)


; draw a sprite into a backbuffer
; in:
; de - ptr to monster_draw_ptr in the runtime data
knight_draw:
			MONSTER_DRAW(sprite_get_scr_addr_knight, __RAM_DISK_S_KNIGHT)