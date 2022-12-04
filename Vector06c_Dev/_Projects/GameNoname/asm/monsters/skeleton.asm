SKELETON_RUN_SPEED		= $0100
SKELETON_RUN_SPEED_NEG	= $ffff - $100 + 1

; statuses.
SKELETON_STATUS_DETECT_HERO = 0
;SKELETON_STATUS_ATTACK = 1


SKELETON_POS_X_MIN = TILE_WIDTH
SKELETON_POS_X_MAX = (ROOM_WIDTH - 2 ) * TILE_WIDTH
SKELETON_POS_Y_MIN = TILE_WIDTH
SKELETON_POS_Y_MAX = (ROOM_HEIGHT - 2 ) * TILE_HEIGHT

; gameplay
SKELETON_DAMAGE = 1
SKELETON_HEALTH = 1

SKELETON_COLLISION_WIDTH = 15
SKELETON_COLLISION_HEIGHT = 10

;========================================================
; called to spawn this monster
; in:
; c - tile idx in the roomTilesData array.
; a - monster id * 2
; out:
; a = 0
SkeletonInit:
			call MonstersGetEmptyDataPtr
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
			mvi m, SKELETON_STATUS_DETECT_HERO
			; advance to monsterStatusTimer
			inx h
			mvi m, 0
			; advance to monsterAnimTimer
			inx h
			mvi m, 0
			; advance to monsterAnimPtr
			inx h
			mvi m, < skeleton_idle
			inx h
			mvi m, > skeleton_idle

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