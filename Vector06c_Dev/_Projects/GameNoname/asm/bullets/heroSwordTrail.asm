; statuses.
; a status describes what set of animations and behavior is active
; for ex. HERO_STATUS_ATTACK plays hero_attk_r or hero_attk_l depending on the direction and it spawns a weapon trail
ATTK01_STATUS_ATTACK = 0

; duration of statuses (in updateDurations)
ATTK01_STATUS_INVIS_DURATION	= 6
ATTK01_STATUS_ATTACK_DURATION	= 8

; animation speed (the less the slower, 0-255, 255 means next frame every update)
ATTK01_ANIM_SPEED_ATTACK	= 50

; gameplay
ATTK01_DAMAGE = 1
ATTK01_COLLISION_WIDTH	= 11
ATTK01_COLLISION_HEIGHT	= 16
ATTK01_COLLISION_OFFSET_X_R = 8
ATTK01_COLLISION_OFFSET_Y_R = 0

ATTK01_COLLISION_OFFSET_X_L = <(-3)
ATTK01_COLLISION_OFFSET_Y_L = 0

; in:
; out:
HeroSwordTrailInit:
			call BulletsGetEmptyDataPtr
			; hl - ptr to bulletUpdatePtr+1

			dcx h
			mvi m, <HeroSwordTrailUpdate
			inx h 
			mvi m, >HeroSwordTrailUpdate
			inx h 
			mvi m, <HeroSwordTrailDraw
			inx h 
			mvi m, >HeroSwordTrailDraw

			; advance hl to bulletStatus
			inx h
			mvi m, BULLET_STATUS_INVIS
			; advance and set bulletStatusTimer
			inx h
			mvi m, ATTK01_STATUS_INVIS_DURATION

			; tmp b = 0
			mvi b, 0
			; advance hl to bulletPosY+1
			LXI_D_TO_DIFF(bulletPosY+1, bulletStatusTimer)
			dad d
			; set posY
			lda heroPosY+1
			; tmp c = posY
			mov c, a
			; set posY
			mov m, a
			dcx h 
			mov m, b
			; advance hl to bulletPosX+1	
			dcx h			
			; set posX
			lda heroPosX+1

			mov m, a
			dcx h
			mov m, b

			; advance hl to bulletEraseWHOld+1
			dcx h
			; set the mimimum supported width
			;mvi m, 1 ; width = 8
			mov m, b ; width = 8
			; advance hl to bulletEraseWHOld
			dcx h
			; set the mimimum supported height
			mvi m, 5
			; advance hl to bulletEraseScrAddrOld+1
			LXI_D_TO_DIFF(bulletEraseScrAddrOld+1, bulletEraseWHOld)
			dad d
			; a - posX
			; scrX = posX/8 + $a0
			rrc_(3)
			ani %00011111
			adi SPRITE_X_SCR_ADDR
			mov m, a
			; advance hl to bulletEraseScrAddrOld
			dcx h
			; c = posY
			mov m, c
			ret
			.closelabels

; anim and a gameplay logic update
; in:
; de - ptr to bulletUpdatePtr in the runtime data
HeroSwordTrailUpdate:
			; advance to bulletStatus
			LXI_H_TO_DIFF(bulletStatus, bulletUpdatePtr)
			dad d
			mov a, m
			cpi BULLET_STATUS_INVIS
			jz @delayUpdate

@attkUpdate:
			; hl - ptr to bulletStatus
			; advance and decr bulletStatusTimer
			inx h
			; check if it's time to die
			dcr m
			jz @destroy			

@attkAnimUpdate:
			; advance to bulletAnimTimer
			inx h
			; update it
			mov a, m
			adi ATTK01_ANIM_SPEED_ATTACK
			mov m, a
			jnc @skipAnimUpdate

			; advance to bulletAnimPtr
			inx h			
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
			; store de into the bulletAnimPtr
			mov m, d
			dcx h
			mov m, e
@skipAnimUpdate:
			; update movement if needed
			ret
@destroy:
			LXI_D_TO_DIFF(bulletUpdatePtr+1, bulletStatusTimer)
			dad d
			jmp BulletsDestroy

@delayUpdate:
			; hl - ptr to bulletStatus
			; advance and decr bulletStatusTimer
			inx h
			dcr m
			rnz
			
			; hl = bulletStatusDuration
			; set the attack
			mvi m, ATTK01_STATUS_ATTACK_DURATION
			; advance and set bulletStatus
			dcx h
			mvi m, ATTK01_STATUS_ATTACK
			
			; advance and reset bulletAnimTimer
			inx_h(2)
			mvi m, 0
			; advance and set bulletAnimPtr
			inx h
			lda heroDirX
			ora a
			jz @attkL
@attkR:
			mvi m, < hero_attack01_attk_r
			inx h
			mvi m, > hero_attack01_attk_r

			; check enemies-attk01 sprite collision
			; hl - bulletAnimPtr+1
			; advance hl to bulletPosX+1			
			LXI_B_TO_DIFF(bulletPosX+1, bulletAnimPtr+1)
			dad b
			; add a collision offset
			mov d, m
			inx_h(2)
			mov e, m
			lxi h, ATTK01_COLLISION_OFFSET_X_R<<8 | ATTK01_COLLISION_OFFSET_Y_R
			dad d			

			jmp @setCollisionSize
@attkL:			
			mvi m, < hero_attack01_attk_l
			inx h
			mvi m, > hero_attack01_attk_l

			; check enemies-attk01 sprite collision
			; hl - bulletAnimPtr+1
			; advance hl to bulletPosX+1			
			LXI_B_TO_DIFF(bulletPosX+1, bulletAnimPtr+1)
			dad b
			; add a collision offset
			mov d, m
			inx_h(2)
			mov e, m
			lxi h, ATTK01_COLLISION_OFFSET_X_L<<8 | ATTK01_COLLISION_OFFSET_Y_L
			dad d

@setCollisionSize:
			mvi a, ATTK01_COLLISION_WIDTH-1
			mvi c, ATTK01_COLLISION_HEIGHT-1
			lxi d, monsterUpdatePtr+1
			call MonstersGetFirstCollided
			
			; check if bullet collides with monster
			mvi a, BULLET_RUNTIME_DATA_EMPTY
			cmp m
			rc ; return if no collision

			; advance hl to monsterImpactPtr
			LXI_B_TO_DIFF(monsterImpactPtr, monsterUpdatePtr+1)
			dad b
			; call bulletImpactPtr
			mov e, m
			inx h
			mov d, m
			xchg
			pchl


; draw a sprite into a backbuffer
; in:
; de - ptr to bulletDrawPtr in the runtime data
HeroSwordTrailDraw:
			; advance to bulletStatus
			LXI_H_TO_DIFF(bulletStatus, bulletDrawPtr)
			dad d
			mov a, m
			; if it is invisible, return
			cpi BULLET_STATUS_INVIS
			rz

			LXI_D_TO_DIFF(bulletPosX+1, bulletStatus)
			dad d
			call SpriteGetScrAddr_hero_attack01
			; hl - ptr to bulletPosY+1
			; tmpA <- c
			mov a, c
			; advance to bulletAnimPtr
			LXI_B_TO_DIFF(bulletAnimPtr, bulletPosY+1)
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
			CALL_RAM_DISK_FUNC(__DrawSpriteVM, __RAM_DISK_S_HERO_ATTACK01 | __RAM_DISK_M_DRAW_SPRITE_VM | RAM_DISK_M_8F)
			pop h
			inx h
			; hl - ptr to bulletEraseScrAddr
			; store the current scr addr, into bulletEraseScrAddr
			mov m, c
			inx h
			mov m, b
			; advance to bulletEraseWH
			LXI_B_TO_DIFF(bulletEraseWH, bulletEraseScrAddr+1)
			dad b
			; store a width and a height into bulletEraseWH
			mov m, e
			inx h
			mov m, d
			ret
			.closelabels