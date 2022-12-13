
; draw a bullet sprite into a backbuffer
; ex. BULLET_DRAW(SpriteGetScrAddr_scythe, __RAM_DISK_S_SCYTHE)
; in:
; de - ptr to bulletDrawPtr in the runtime data
.macro BULLET_DRAW(SpriteGetScrAddr_bullet, __RAM_DISK_S_BULLET)
			; advance to bulletStatus
			LXI_H_TO_DIFF(bulletStatus, bulletDrawPtr)
			dad d
			mov a, m
			; if it is invisible, return
			cpi BULLET_STATUS_INVIS
			rz

			LXI_D_TO_DIFF(bulletPosX+1, bulletStatus)
			dad d
			call SpriteGetScrAddr_bullet
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
			CALL_RAM_DISK_FUNC(__DrawSpriteVM, __RAM_DISK_S_BULLET | __RAM_DISK_M_DRAW_SPRITE_VM | RAM_DISK_M_8F)
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
.endmacro

; update anim, check collision with a hero
; in:
; hl - bulletAnimTimer
; a - anim speed
; out: 
; hl - bulletPosY+1
.macro BULLET_UPDATE_ANIM_CHECK_COLLISION_HERO(BULLET_COLLISION_WIDTH, BULLET_COLLISION_HEIGHT, BULLET_DAMAGE)
			call ActorAnimUpdate
@checkCollisionHero:
			; hl points to bulletAnimPtr
			; TODO: check hero-bullet collision not every frame			
			; advance hl to bulletPosX
			LXI_B_TO_DIFF(bulletPosX+1, bulletAnimPtr)
			dad b
			; horizontal check
			mov c, m ; posX
			lda heroPosX+1
			mov b, a ; tmp
			adi HERO_COLLISION_WIDTH-1
			cmp c
			rc
			mvi a, BULLET_COLLISION_WIDTH-1
			add c
			cmp b
			rc
			; vertical check
			; advance hl to bulletPosY+1
			inx_h(2)
			mov c, m ; posY
			lda heroPosY+1
			mov b, a
			adi HERO_COLLISION_HEIGHT-1
			cmp c
			rc
			mvi a, BULLET_COLLISION_HEIGHT-1
			add c
			cmp b
			rc
@collidesHero:
			; hero collides
			; hl points to bulletPosY+1
			push h
			; send him a damage
			mvi c, BULLET_DAMAGE
			call HeroImpact
			pop h
.endmacro