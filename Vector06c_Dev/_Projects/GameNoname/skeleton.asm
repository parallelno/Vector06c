.include "chars/skeleton.dasm"

SKELETON_RUN_SPEED		= $80

SkeletonInit:
            ; convert monster id into the offset in the monstersRoomData array
			; and store it into bc
			lxi h, monsterRoomDataAddrOffsets
			dad b
			mov c, m
			lxi h, monsterAnimAddr
			dad b

			mvi m, < skeleton_run_r0
			inx h
			mvi m, > skeleton_run_r0

			lxi h, monsterSpeedX
			dad b
			mvi m, SKELETON_RUN_SPEED
			;inx h
			;inx h
			;mvi m, 20

			ret
			.closelabels

SkeletonUpdate:            
            ; convert monster id into the offset in the monstersRoomData array
			; and store it into bc
			lxi h, monsterRoomDataAddrOffsets
			dad b
			mov c, m
			mov h, b
			mov l, c
			shld @tileDataOffset+1
			lxi h, monsterPosX
			dad b
			shld @posXYaddr+1
			; bc <- (posX)
			mov c, m
			inx h
			mov b, m
			inx h
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
			; calc new posX and store it to tempX
			xchg
			dad b
			; a <- x for checking collision
			mov a, h
			shld charTempX
			xchg
			; de <- (speedY)
			mov e, m
			inx h
			mov d, m
			; calc new posY and store it to tempY
			xchg
			pop b
			dad b
			shld charTempY

			mov b, a
			mov c, h
			; check hero pos against the room collision tiles
			call CheckRoomTilesCollision
			; check if any tiles collide
			
			cpi $ff
			jz @collides
			ora a ; if all the tiles data == 0, means no collision.
			jnz @collides
@updatePos:			
            lhld charTempX
			xchg
@posXYaddr:
            lxi h, TEMP_ADDR
			mov m, e
			inx h
			mov m, d
			inx h
			xchg
			lhld charTempY
			xchg
			mov m, e
			inx h
			mov m, d
			ret
@collides:
@tileDataOffset:
            lxi b, TEMP_ADDR
			lxi h, monsterSpeedX
			dad b
			mov a, M
			cma
			inr A
			mov m, a
			inx h
			mov a, m
			cma
			mov m, a
			ora A
			jz @setAnimRunR

			lxi h, monsterAnimAddr
			dad b
			mvi m, < skeleton_run_l0
			inx h
			mvi m, > skeleton_run_l0
			ret
@setAnimRunR:
			lxi h, monsterAnimAddr
			dad b
			mvi m, < skeleton_run_r0
			inx h
			mvi m, > skeleton_run_r0

            ret
@handleTileData:
            ret
			.closelabels
			

SkeletonDraw:
			; convert monster id into the offset in the monstersRoomData array
			; and store it into bc
			lxi h, monsterRoomDataAddrOffsets
			dad b
			mov c, m
			lxi h, monsterRedrawTimer
			; hl - pointer to monsterRedrawTimer
			dad b
			; a <- (monsterRedrawTimer)
			mov a, m
			rrc
			mov m, a
			rnc

			; de <- (monsterCleanScrAddr)
			inx h
			mov e, m
			inx h
			mov d, m

			; a <- (monsterCleanFrameIdx2)
			inx h
			mov a, m
			push h
			push h
			xchg
			; TODO: do not clean sprite if it wasn't moving
			call CleanSprite
			pop h

			; hl - monsterPosX+1 addr
			inx h
			inx h		
			call GetSpriteScrAddr

			; move pointer back to monsterCleanFrameIdx2 addr
			pop h
			; save frame idx to monsterCleanFrameIdx2 addr
			mov m, c
 			; move pointer back to monsterCleanScrAddr+1 addr
			dcx h
			; save the addr returned by GetSpriteScrAddr into monsterCleanScrAddr backwards
			mov m, d
			dcx h
			mov m, e
			; get the anim addr
			;lxi h, skeleton_idle_r ; 316
			dcx h
			dcx h
			mov a, m
			dcx h
			mov l, m
			mov h, a
;MonsterDrawSpriteAddrFunc:
			call GetSpriteAddr

			ora a
			jz DrawSprite16x15
			jmp	DrawSprite24x15
			.closelabels