; out:
; hl points to monsterPosY+1
.macro ACTOR_UPDATE_MOVEMENT_CHECK_TILE_COLLISION(actorStatusTimer, actorPosX, ACTOR_COLLISION_WIDTH, ACTOR_COLLISION_HEIGHT, CollisionHandler) 
			LXI_B_TO_DIFF(actorPosX, actorStatusTimer)
			dad b
			push h ; (stack) <- posX ptr, to restore it in @applyNewPos
			; bc <- posX
			mov c, m
			inx h
			mov b, m
			inx h
			; stack <- posY
			mov e, m
			inx h
			mov d, m
			inx h
			push d
			; de <- speedX
			mov e, m
			inx h
			mov d, m
			inx h
			; (newPosX) <- posX + speedX
			xchg
			dad b
			shld @newPosX+1
			mov a, h ; posX + speedX for checking a collision
			xchg
			; hl points to speedY
			; de <- speedY
			mov e, m
			inx h
			mov d, m
			; (newPosY) <- posY + speedY
			xchg
			pop b
			dad b
			shld @newPosY+1
			; a - posX + speedX
			; hl - posY + speedY
			; de - points to speedY+1

			; check the collision tiles
			mov d, a
			mov e, h
			lxi b, (ACTOR_COLLISION_WIDTH-1)<<8 | ACTOR_COLLISION_HEIGHT-1
			CALL_RAM_DISK_FUNC(RoomCheckWalkableTiles, __RAM_DISK_M_BACKBUFF2 | RAM_DISK_M_89, false, false)
			jnz CollisionHandler

@applyNewPos:
			pop h
			; hl points to posX
@newPosX:	lxi d, TEMP_WORD
@newPosY:	lxi b, TEMP_WORD
			; store a new posX
			mov m, e
			inx h
			mov m, d
			inx h
			; store a new posY
			mov m, c
			inx h
			mov m, b
.endmacro
