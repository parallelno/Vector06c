HERO_ATTACK01_LIFETIME = 100
; in:
; c - monster idx
; out:
; a = 0
HeroSwordTrailInit:
			call MonstersGetEmptyDataPtr
			; hl - ptr to monsterUpdatePtr+1

			dcx h
			mvi m, <HeroSwordTrailUpdate
			inx h 
			mvi m, >HeroSwordTrailUpdate
			inx h 
			mvi m, <HeroSwordTrailDraw
			inx h 
			mvi m, >HeroSwordTrailDraw
			; advance to monsterAnimTimer
			LXI_D_TO_DIFF(monsterAnimTimer, monsterDrawPtr+1)
			dad d
			mvi m, HERO_ATTACK01_LIFETIME
			; advance to monsterAnimPtr
			inx h
			; set the anim
			mvi m, < hero_attack01_attk_r
			inx h
			mvi m, > hero_attack01_attk_r

			; tmp b = 0
			mvi b, 0
			; advance hl to monsterPosY+1
			LXI_D_TO_DIFF(monsterPosY+1, monsterAnimPtr+1)
			dad d
			; set posY
			lda heroY+1
			; tmp c = posY
			mov c, a
			; set posY
			mov m, a
			dcx h 
			mov m, b
			; advance hl to monsterPosX+1	
			dcx h			
			; set posX
			lda heroX+1

			; TODO: temp
			mvi a, 5

			mov m, a
			dcx h
			mov m, b

			; advance hl to monsterEraseWHOld+1
			dcx h
			; set the mimimum supported width
			;mvi m, 1 ; width = 8
			mov m, b ; width = 8
			; advance hl to monsterEraseWHOld
			dcx h
			; set the mimimum supported height
			mvi m, 5
			; advance hl to monsterEraseScrAddrOld+1
			LXI_D_TO_DIFF(monsterEraseScrAddrOld+1, monsterEraseWHOld)
			dad d
			; a - posX
			; scrX = posX/8 + $a0
			rrc_(3)
			ani %00011111
			adi SPRITE_X_SCR_ADDR
			mov m, a
			dcx h
			; c = posY
			mov m, c

			; return zero to erase the tile data
			; there this monster was in the roomTilesData
			xra a 
			ret
			.closelabels

; anim and a gameplay logic update
; in:
; de - ptr to monsterUpdatePtr in the runtime data
HeroSwordTrailUpdate:
			; advance to monsterAnimTimer
			LXI_H_TO_DIFF(monsterAnimTimer, monsterUpdatePtr)
			dad d
			dcr m
			jz @destroy

			; anim update
			lda gameUpdateCounter	; update anim every 4th update
			ani %11
			jnz @skipAnimUpdate
			; advance to monsterAnimPtr
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
			; advance hl to the current frame ptr to the next frame
			dad b
			xchg
			; de - the next frame ptr
			; store de into the monsterAnimPtr
			mov m, d
			dcx h
			mov m, e
@skipAnimUpdate:
			; update movement
			ret
@destroy:
			LXI_D_TO_DIFF(monsterUpdatePtr+1, monsterAnimTimer)
			dad d
			jmp MonstersDestroy

; draw a sprite into a backbuffer
; in:
; de - ptr to monsterDrawPtr in the runtime data
HeroSwordTrailDraw:
			LXI_H_TO_DIFF(monsterPosX+1, monsterDrawPtr)
			dad d
			call GetSpriteScrAddr8
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
			call GetSpriteAddr
; TODO: optimize. set RAM_DISK_S0 | RAM_DISK_M2 | RAM_DISK_M_8F just once for all monsters draw funcs
			CALL_RAM_DISK_FUNC(__DrawSpriteVM, RAM_DISK_S0 | RAM_DISK_M2 | RAM_DISK_M_8F)
			pop h
			inx h
			; hl - ptr to monsterEraseScrAddr
			; store the current scr addr, into monsterEraseScrAddr
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