; hl points to actorStatusTimer
; out:
; hl points to actorPosX+1
.macro ACTOR_UPDATE_MOVEMENT(actorStatusTimer, actorSpeedY)
 			; hl - ptr to actorStatusTimer
			; advance hl to actorSpeedY+1
			LXI_B_TO_DIFF(actorSpeedY+1, actorStatusTimer)
			dad b
			; bc <- speedY
			mov b, m
			dcx h
			mov c, m
			dcx h
			; stack <- speedX
			mov d, m
			dcx h
			mov e, m
			dcx h
			push d
			; de <- posY
			mov d, m
			dcx h
			mov e, m
			; (posY) <- posY + speedY
			xchg
			dad b
			xchg
			mov m, e
			inx h 
			mov m, d
			dcx_h(2)
			; hl points to speedX+1
			; de <- posX
			mov d, m
			dcx h
			mov e, m
			; (posX) <- posX + speedX
			xchg
			pop b
			dad b
			xchg
			mov m, e
			inx h 
			mov m, d
.endmacro

; in:
; hl points to actorStatusTimer
; out:
; hl points to actorPosY+1
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
/*			
			push d

			lxi b, (ACTOR_COLLISION_WIDTH-1)<<8 | ACTOR_COLLISION_HEIGHT-1
			CALL_RAM_DISK_FUNC(room_check_tiledata_walkable, __RAM_DISK_M_BACKBUFF2 | RAM_DISK_M_89, false, false)

@test0:		mvi a, TEMP_BYTE			
			mvi a, 0
			jz @test2
			mvi a, 1
@test2:		sta @test0+1

			pop d
			*/
			lxi b, (ACTOR_COLLISION_WIDTH-1)<<8 | ACTOR_COLLISION_HEIGHT-1
			call room_check_tiledata_walkable_v2
/*
			push psw

			mvi b, 0
			jz @t2
			mvi b, 1
@t2:					
			lda @test0+1
			cmp b
@loop:		jnz @loop

			pop psw
			*/
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
