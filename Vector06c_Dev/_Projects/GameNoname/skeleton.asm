
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

			mvi m, < skeleton_run_r
			inx h
			mvi m, > skeleton_run_r

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
			mvi m, < skeleton_run_l
			inx h
			mvi m, > skeleton_run_l
			ret
@setAnimRunR:
			lxi h, monsterAnimAddr
			dad b
			mvi m, < skeleton_run_r
			inx h
			mvi m, > skeleton_run_r

            ret
@handleTileData:
            ret
			.closelabels

; draw sprite and save erase scr addr
; in:
; bc - monster idx*2
SkeletonDraw:
			; convert monster id into the offset in the monstersRoomData array
			; and store it into bc
			lxi h, monsterRoomDataAddrOffsets
			dad b
			mov c, m

			lxi h, monsterPosX+1
			dad b
			call GetSpriteScrAddr4
			mov a, c

			; get the anim addr
			lxi b, $ffff - 12 ;monsterAnimAddr
			dad b
			mov b, m
			inx h
			push h
			mov h, m
			mov l, b
			mov c, a
			call GetSpriteAddr

			CALL_RAM_DISK_FUNC(__DrawSpriteVM, RAM_DISK0_B0_STACK_B2_8AF_RAM)
			pop h
			inx h
			; store an old scr addr, width, and height
			; hl - ptr to monsterEraseScrAddr
			mov m, c
			inx h
			mov m, b
			; hl - ptr to monsterEraseWH
			inx_h(3)
			mov m, e
			inx h
			mov m, d
			ret
			.closelabels