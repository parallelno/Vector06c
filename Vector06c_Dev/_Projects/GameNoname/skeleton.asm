
SKELETON_RUN_SPEED		= $0080
SKELETON_RUN_SPEED_D	= $ffff - $80 + 1
; in:
; bc - monster idx*2
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

			ret
			.closelabels

; in:
; bc - monster idx*2
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
			; check the monster pos against the room collision tiles
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
			; get speedX addr
            lxi b, TEMP_ADDR

            call Random
			
			lxi h, monsterSpeedX
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
			ora a
			jz @setAnimRunR
@setAnimRunL:
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

; draw & clear sprite
; in:
; bc - monster idx*2
; a - flag
;	flag=OPCODE_RC to draw a sprite with Y>MONSTER_DRAW_Y_THRESHOLD, 
;	flag=OPCODE_RNC to draw a sprite with Y<=MONSTER_DRAW_Y_THRESHOLD, 
SkeletonDraw:
/*
			; check the flag
			ora a
			jnz @draw
@clear:
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
			rnc

			; de <- (monsterEraseScrAddr)
			inx h
			mov e, m
			inx h
			mov d, m

			; a <- (monsterEraseFrameIdx2)
			inx h
			mov a, m
			;xchg
			; TODO: do not clean sprite if it wasn't moving
			jmp EraseSpriteSP
*/
@draw:
			; TODO: after removing call EraseSprite that func needs an optimization pass
			; store a flag
			sta @checkY
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
			rnc

			inx h
			inx h
			inx h
			push h

			; hl - monsterPosX+1 addr
			inx h
			inx h		
			call GetSpriteScrAddr
			; move pointer back to monsterEraseFrameIdx2 addr
			pop h
			
			; to support two-interations rendering
			mvi a, MONSTER_DRAW_Y_THRESHOLD
			cmp e
@checkY
			; replaced with RNC to draw sprites above MONSTER_DRAW_Y_THRESHOLD
			; replaced with RC to draw sprites below MONSTER_DRAW_Y_THRESHOLD
			nop

			; save frame idx to monsterEraseFrameIdx2 addr
			mov m, c
 			; move pointer back to monsterEraseScrAddr+1 addr
			dcx h
			; save the addr returned by GetSpriteScrAddr into monsterEraseScrAddr backwards
			mov m, d
			dcx h
			mov m, e

			; get the anim addr
			dcx h
			dcx h
			mov a, m
			dcx h
			mov l, m
			mov h, a
			call GetSpriteAddrRunV
			;jmp DrawSpriteVM
			.closelabels