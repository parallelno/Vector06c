SKELETON_HEALTH = 1
SKELETON_RUN_SPEED		= $0080
SKELETON_RUN_SPEED_D	= $ffff - $80 + 1
; in:
; hl - ptr to monsterUpdate+1
; out:
; a = 0
SkeletonInit:
			call MonstersGetEmptyDataPtr
			dcx h
			mvi m, <SkeletonUpdate
			inx h 
			mvi m, >SkeletonUpdate
			inx h 
			mvi m, <SkeletonDraw
			inx h 
			mvi m, >SkeletonDraw
			inx h 
			mvi m, SKELETON_HEALTH
			;lxi d, monsterAnimAddr - monsterHealth ; 4
			LXI_D_TO_DIFF(monsterAnimAddr, monsterHealth)
			dad d
			; monsterAnimAddr
			mvi m, < skeleton_run_r
			inx h
			mvi m, > skeleton_run_r
			; advance to monsterSpeedY+1
			;lxi d, monsterSpeedY+1 - monsterAnimAddr+1; 16
			LXI_D_TO_DIFF(monsterSpeedY+1, monsterAnimAddr+1)
			dad d
			; monsterSpeedY+1
			; set monsterSpeedY to zero
			mvi b, 0
			mov m, b
			dcx h
			mov m, b
			dcx h 
			; monsterSpeedX+1
			; set monsterSpeedX to right 
			mvi m, >SKELETON_RUN_SPEED
			dcx h 
			mvi m, <SKELETON_RUN_SPEED
			dcx h 
			; monsterPosY+1
			; convert tile idx into the posY and set it
			mov a, c
			; posY = tile idx % ROOM_WIDTH * TILE_WIDTH
			ani %11110000
			mov m, a
			mov e, a
			dcx h 
			mov m, b
			dcx h 
			; monsterPosX+1
			; convert tile idx into the posX and set it
			mov a, c
			; posX = tile idx % ROOM_WIDTH * TILE_WIDTH
			ani %00001111
			rlc_(4)
			mov m, a
			dcx h 
			mov m, b 
			dcx h 
			; monsterEraseWHOld+1
			mov m, b ; width = 8
			dcx h 
			mvi m, 5 ; supported mimimum height
			dcx_h(3)
			; monsterEraseScrAddrOld+1
			; scrX = x/8 + $a0
			rrc_(3)
			adi SPRITE_X_SCR_ADDR
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
; de - ptr to monsterUpdate in the runtime data
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
			; advance to monsterAnimAddr
			;lxi h, monsterAnimAddr - monsterUpdate
			LXI_H_TO_DIFF(monsterAnimAddr, monsterUpdate)
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
			; advance the current frame ptr to the next frame
			dad b
			xchg
			; de - the next frame ptr
			; store de into the monsterAnimAddr
			mov m, d
			dcx h
			mov m, e
			pop b
@skipAnimUpdate:			
			; update movement
			;lxi h, monsterPosX - monsterUpdate
			LXI_H_TO_DIFF(monsterPosX, monsterUpdate)
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

			mov b, a
			mov c, h
			; check the monster pos against the room collision tiles
			call RoomCheckTileCollision
			; check if any tiles collide

			cpi $ff
			jz @collides
			ora a ; if all the tiles data == 0, means no collision.
			jnz @collides
@updatePos:
            lhld charTempX
@monsterPosXPtr:
			shld TEMP_ADDR
			lhld charTempY
@monsterPosYPtr:
			shld TEMP_ADDR
			ret

@collides:
@monsterUpdatePptr:
            lxi b, TEMP_ADDR
			; get speedX addr
            call Random

			;lxi h, monsterSpeedX - monsterUpdate
			LXI_H_TO_DIFF(monsterSpeedX, monsterUpdate)
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
			mvi m, < SKELETON_RUN_SPEED_D
			inx h
			mvi m, > SKELETON_RUN_SPEED_D
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
			mvi m, < SKELETON_RUN_SPEED_D
			inx h
			mvi m, > SKELETON_RUN_SPEED_D
			inx h
			mov m, a
			inx h
			mov m, a
			mvi a, > SKELETON_RUN_SPEED_D
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
			;lxi h, monsterAnimAddr - monsterUpdate
			LXI_H_TO_DIFF(monsterAnimAddr, monsterUpdate)
			dad b
			mvi m, < skeleton_run_l
			inx h
			mvi m, > skeleton_run_l
			ret
@setAnimRunR:
			;lxi h, monsterAnimAddr - monsterUpdate
			LXI_H_TO_DIFF(monsterAnimAddr, monsterUpdate)
			dad b
			mvi m, < skeleton_run_r
			inx h
			mvi m, > skeleton_run_r
            ret
@handleTileData:
            ret			
			.closelabels

; draw a sprite into a backbuffer
; in:
; de - ptr to monsterDraw in the runtime data
SkeletonDraw:
			;lxi h, monsterPosX+1 - monsterDraw
			LXI_H_TO_DIFF(monsterPosX+1, monsterDraw)
			dad d
			call GetSpriteScrAddr4
			; hl - ptr to monsterPosY+1
			; tmpA <- c
			mov a, c

			; advance to monsterAnimAddr
			;lxi b, monsterAnimAddr - monsterPosY+1;$ffff - 12 ;move prt to monsterAnimAddr
			LXI_B_TO_DIFF(monsterAnimAddr, monsterPosY+1)
			dad b
			mov b, m
			inx h
			push h
			mov h, m
			mov l, b
			mov c, a
			; hl - animPtr
			; c - preshifted sprite idx*2 offset
			call GetSpriteAddr

; TODO: optimize. set RAM_DISK_S0 | RAM_DISK_M2 | RAM_DISK_M_8F just once for all monsters draw funcs
			CALL_RAM_DISK_FUNC(__DrawSpriteVM, RAM_DISK_S0 | RAM_DISK_M2 | RAM_DISK_M_8F)
			pop h
			inx h
			; hl - ptr to monsterEraseScrAddr
			; store a current scr addr, into monsterEraseScrAddr
			mov m, c
			inx h
			mov m, b
			; advance to monsterEraseWH
			;inx_h(3)
			;lxi b, monsterEraseWH - monsterEraseScrAddr+1;
			LXI_B_TO_DIFF(monsterEraseWH, monsterEraseScrAddr+1)
			dad b
			; store a width and a height into monsterEraseWH
			mov m, e
			inx h
			mov m, d
			ret
			.closelabels