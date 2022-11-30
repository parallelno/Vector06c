VAMPIRE_HEALTH = 1
VAMPIRE_RUN_SPEED		= $0100
VAMPIRE_RUN_SPEED_D	= $ffff - $100 + 1

VAMPIRE_COLLISION_WIDTH = 15
VAMPIRE_COLLISION_HEIGHT = 10

VAMPIRE_POS_X_MIN = TILE_WIDTH
VAMPIRE_POS_X_MAX = (ROOM_WIDTH - 2 ) * TILE_WIDTH
VAMPIRE_POS_Y_MIN = TILE_WIDTH
VAMPIRE_POS_Y_MAX = (ROOM_HEIGHT - 2 ) * TILE_HEIGHT

; gameplay
VAMPIRE_DAMAGE = 1

;========================================================
; called to spawn this mod
; in:
; c - monster idx
; out:
; a = 0
VampireInit:
			call MonstersGetEmptyDataPtr
			; hl - ptr to monsterUpdatePtr+1			
			mvi m, >VampireUpdate
			dcx h 
			mvi m, <VampireUpdate

			; TODO: add monsterDataPrevPPtr init
			; TODO: add monsterDataNextPPtr init

			
			; advance to VampireDraw
			LXI_d_TO_DIFF(monsterDrawPtr, monsterUpdatePtr)
			dad d
			
			mvi m, <VampireDraw
			inx h 
			mvi m, >VampireDraw
			inx h
			mvi m, <VampireImpact
			inx h
			mvi m, >VampireImpact
			; advance to monsterType
			inx h
			mvi m, 0; MONSTER_TYPE_ENEMY			
			; advance to monsterHealth
			inx h
			mvi m, VAMPIRE_HEALTH

			LXI_D_TO_DIFF(monsterAnimPtr, monsterHealth)
			dad d
			; monsterAnimPtr
			mvi m, < vampire_run_r
			inx h
			mvi m, > vampire_run_r
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
			mvi m, >VAMPIRE_RUN_SPEED
			dcx h 
			mvi m, <VAMPIRE_RUN_SPEED
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
VampireUpdate:
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
			lxi b, (VAMPIRE_COLLISION_WIDTH-1)<<8 | VAMPIRE_COLLISION_HEIGHT-1
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
			mvi a, VAMPIRE_COLLISION_WIDTH-1
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
			mvi a, VAMPIRE_COLLISION_HEIGHT-1
			add c
			cmp b
			rc
			; hero collides
			; send him a damage
			mvi c, VAMPIRE_DAMAGE
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
			mvi m, < VAMPIRE_RUN_SPEED_D
			inx h
			mvi m, > VAMPIRE_RUN_SPEED_D
			jmp @setAnim
@speedYp:
			xra a
			mov m, a
			inx h
			mov m, a
			inx h
			mvi m, < VAMPIRE_RUN_SPEED
			inx h
			mvi m, > VAMPIRE_RUN_SPEED
			jmp @setAnim
@speedXn:
			xra a
			mvi m, < VAMPIRE_RUN_SPEED_D
			inx h
			mvi m, > VAMPIRE_RUN_SPEED_D
			inx h
			mov m, a
			inx h
			mov m, a
			mvi a, > VAMPIRE_RUN_SPEED_D
			jmp @setAnim
@speedXp:
			xra a
			mvi m, < VAMPIRE_RUN_SPEED
			inx h
			mvi m, > VAMPIRE_RUN_SPEED
			inx h
			mov m, a
			inx h
			mov m, a
			mvi a, > VAMPIRE_RUN_SPEED
@setAnim:
			; a = speedX
			ora a
			; if speedX is positive, then play vampire_run_r
			; that means a vertical movement plays vampire_run_r anim as well
			jz @setAnimRunR
@setAnimRunL:
			LXI_H_TO_DIFF(monsterAnimPtr, monsterUpdatePtr)
			dad b
			mvi m, < vampire_run_l
			inx h
			mvi m, > vampire_run_l
			ret
@setAnimRunR:
			LXI_H_TO_DIFF(monsterAnimPtr, monsterUpdatePtr)
			dad b
			mvi m, < vampire_run_r
			inx h
			mvi m, > vampire_run_r
            ret

VampireImpact:
			; de - ptr to monsterImpactPtr+1
			LXI_H_TO_DIFF(monsterUpdatePtr+1, monsterImpactPtr+1)
			dad d
			jmp MonstersSetDestroy

; draw a sprite into a backbuffer
; in:
; de - ptr to monsterDrawPtr in the runtime data
VampireDraw:
			LXI_H_TO_DIFF(monsterPosX+1, monsterDrawPtr)
			dad d
			call SpriteGetScrAddr_vampire
			; hl - ptr to monsterPosY+1
			; tmpA <- c
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

			CALL_RAM_DISK_FUNC(__DrawSpriteVM, __RAM_DISK_S_VAMPIRE | __RAM_DISK_M_DRAW_SPRITE_VM | RAM_DISK_M_8F)
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