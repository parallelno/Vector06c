;.include "drawSprite2.asm"
.include "chars/skeleton.dasm"

; the first screen buffer X
;HERO_X_SCR_ADDR	= $a0
;HERO_START_POS_X = 100
;HERO_START_POS_Y = 170
;HERO_RUN_SPEED = $0060 ; it's a dword, low byte is a subpixel speed

/*
MonsterStop:
			lxi h, 0
			shld heroSpeedX
			shld heroSpeedY
			shld keyCode
			ret
			.closelabels

; hl - posXY
MonsterSetPos:
			mov a, h
			sta heroX+1
			mov a, l
			sta heroY+1
			ret
			.closelabels

			.macro CHECK_HERO_REDRAW(timer)
			lxi h, keyCode+1
			cmp m
			jz MonsterMove
			mvi a, timer
			sta heroRedrawTimer
			.endmacro		
*/			
SkeletonUpdate:
			ret
/*
			lda keyCode

			; if no key pressed, play idle
			cpi $ff
			jnz @setAnimRunR
			
			; if it's the same key as the prev frame, return
			CHECK_HERO_REDRAW(ROT_TIMER_0p125)

			lxi h, 0
			shld heroSpeedX
			shld heroSpeedY

			lxi h, GetMonsterSpriteAddr
			shld MonsterDrawSpriteAddrFunc+1

			lda heroDirX
			ora a
			jz @setAnimIdleL

			lxi h, skeleton_idle_r
			shld MonsterDrawAnimAddr+1
			jmp MonsterMove
@setAnimIdleL
			lxi h, skeleton_idle_l
			shld MonsterDrawAnimAddr+1
			jmp MonsterMove

@setAnimRunR:
			cpi KEY_RIGHT
			jnz @setAnimRunL
			
			CHECK_HERO_REDRAW(ROT_TIMER_0p5)

			lxi h, HERO_RUN_SPEED
			shld heroSpeedX
			lxi h, 0
			shld heroSpeedY

			mvi a, 1
			sta heroDirX
			lxi h, GetMonsterSpriteAddr
			lxi h, skeleton_run_r0
			shld MonsterDrawAnimAddr+1
			lxi h, GetMonsterSpriteAddr
			shld MonsterDrawSpriteAddrFunc+1
			jmp MonsterMove
@setAnimRunL:
			cpi KEY_LEFT
			jnz @setAnimRunU

			CHECK_HERO_REDRAW(ROT_TIMER_0p5)

			lxi h, $ffff - HERO_RUN_SPEED + 1
			shld heroSpeedX
			lxi h, 0
			shld heroSpeedY

			xra a
			sta heroDirX
			lxi h, skeleton_run_l0
			shld MonsterDrawAnimAddr+1
			lxi h, GetMonsterSpriteAddr
			shld MonsterDrawSpriteAddrFunc+1	
			jmp MonsterMove
@setAnimRunU:
			cpi KEY_UP
			jnz @setAnimRunD

			CHECK_HERO_REDRAW(ROT_TIMER_0p5)

			lxi h, 0
			shld heroSpeedX
			lxi h, HERO_RUN_SPEED
			shld heroSpeedY

			lxi h, GetMonsterRunVSpriteAddr
			shld MonsterDrawSpriteAddrFunc+1

			lda heroDirX
			ora a
			jz @setAnimRunUL

			lxi h, skeleton_run_r0
			shld MonsterDrawAnimAddr+1
			jmp MonsterMove
@setAnimRunUL:
			lxi h, skeleton_run_l0
			shld MonsterDrawAnimAddr+1
			jmp MonsterMove
@setAnimRunD:
			cpi KEY_DOWN
			rnz

			CHECK_HERO_REDRAW(ROT_TIMER_0p5)

			lxi h, 0
			shld heroSpeedX
			lxi h, $ffff - HERO_RUN_SPEED + 1
			shld heroSpeedY		

			lxi h, GetMonsterRunVSpriteAddr
			shld MonsterDrawSpriteAddrFunc+1
			
			lda heroDirX
			ora a
			jz @setAnimRunDL
			lxi h, skeleton_run_r0
			shld MonsterDrawAnimAddr+1		
			jmp MonsterMove
@setAnimRunDL:
			lxi h, skeleton_run_l0
			shld MonsterDrawAnimAddr+1
			jmp MonsterMove

MonsterMove:
			; apply the hero speed
			lhld heroX
			xchg
			lhld heroSpeedX
			dad d
			mov b, h
			shld heroTempX
			lhld heroY
			xchg
			lhld heroSpeedY
			dad d
			mov c, h
			shld heroTempY
			; check collided tiles data
			call CheckTilesCollision
			; check if any tiles collide
			
			cpi $ff
			rz ; return if any of the tiles were collision
			ora a ; if all the tiles data == 0, means no collision.
			jnz @collides
@updatePos:			
			lhld heroTempX
			shld heroX
			lhld heroTempY
			shld heroY
			ret
@collides:
			; handle collided tiles data
			lxi h, collidedTilesData
			mvi c, 4
SkeletonMoveLoop:
			mov a, m
			push h	
			; extract a function
			ani %00000111
			jz MonsterMoveFuncRet
			dcr a ; we do not need to handle funcId == 0
			rlc
			mov e, a
			mvi d, 0
			; extract a func argument
			mov a, m
			rrc_(3)
			ani %00011111

			lxi h, heroFuncTable
			dad d
			mov e, m
			inx h
			mov d, m
			xchg
			pchl
SkeletonMoveFuncRet:
			pop h
			inx h
			dcr c
			jnz MonsterMoveLoop
			ret
			.closelabels
*/
;	hl - monster data addr
;
SkeletonDraw:
			; convert monster id into @posX, monsterCleanScrAddr, monsterCleanFrameIdx2
			lxi h, monsterRoomDataAddrOffsets
			dad b
			mov c, m
			lxi h, monsterCleanScrAddr
			dad b
			shld @cleanScrAddrLoad+1
			shld @cleanScrAddrSave+1
			lxi h, monsterCleanFrameIdx2
			dad b
			shld @cleanFrameLoad+1
			shld @cleanFrameSave+1
			lxi h, monsterPosX+1
			dad b
			shld @posX+1

			lxi h, monsterRedrawTimer
			dad b
			mov a, m
			rrc
			mov m, a
			rnc
@cleanScrAddrLoad:
			lhld monsterCleanScrAddr
@cleanFrameLoad:
			lda monsterCleanFrameIdx2
			call CleanSprite

@posX:
			lxi h, monsterPosX+1
			
			call GetSpriteScrAddr
			mov a, c
@cleanScrAddrSave:
			shld monsterCleanScrAddr
@cleanFrameSave:
			sta monsterCleanFrameIdx2
			xchg
MonsterDrawAnimAddr:
			lxi h, skeleton_idle_r
MonsterDrawSpriteAddrFunc:			
			call GetSpriteAddr

			ora a
			jz DrawSprite16x15
			jmp	DrawSprite24x15