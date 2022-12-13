
; draw a monster sprite into a backbuffer
; ex. MONSTER_DRAW(SpriteGetScrAddr_skeleton, __RAM_DISK_S_SKELETON)
; in:
; de - ptr to monsterDrawPtr in the runtime data
.macro MONSTER_DRAW(SpriteGetScrAddr_monster, __RAM_DISK_S_MONSTER)
			LXI_H_TO_DIFF(monsterPosX+1, monsterDrawPtr)
			dad d
			call SpriteGetScrAddr_monster
			; hl - ptr to monsterPosY+1
			; tmp a = c
			mov a, c

			; advance hl to monsterAnimPtr
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
			call SpriteGetAddr

			CALL_RAM_DISK_FUNC(__DrawSpriteVM, __RAM_DISK_S_MONSTER | __RAM_DISK_M_DRAW_SPRITE_VM | RAM_DISK_M_8F)
			pop h
			inx h
			; hl - ptr to monsterEraseScrAddr
			; store a current scr addr, into monsterEraseScrAddr
			mov m, c
			inx h
			mov m, b
			; advance hl to monsterEraseWH
			LXI_B_TO_DIFF(monsterEraseWH, monsterEraseScrAddr+1)
			dad b
			; store a width and a height into monsterEraseWH
			mov m, e
			inx h
			mov m, d
			ret
.endmacro


; in:
; hl - monsterAnimTimer
; a - anim speed
.macro MONSTER_UPDATE_ANIM_CHECK_COLLISION_HERO(MONSTER_COLLISION_WIDTH, MONSTER_COLLISION_HEIGHT, MONSTER_DAMAGE)
			call ActorAnimUpdate
@heroCollisionCheck:
			; hl points to monsterAnimPtr
			; TODO: check hero-monster collision not every frame
			; advance hl to monsterPosX
			LXI_B_TO_DIFF(monsterPosX+1, monsterAnimPtr)
			dad b
			; horizontal check
			mov c, m ; posX
			lda heroPosX+1
			mov b, a ; tmp
			adi HERO_COLLISION_WIDTH-1
			cmp c
			rc
			mvi a, MONSTER_COLLISION_WIDTH-1
			add c
			cmp b
			rc
			; vertical check
			; advance hl to monsterPosY+1
			inx_h(2)
			mov c, m ; posY
			lda heroPosY+1
			mov b, a
			adi HERO_COLLISION_HEIGHT-1
			cmp c
			rc
			mvi a, MONSTER_COLLISION_HEIGHT-1
			add c
			cmp b
			rc
@collidesHero:
			; hero collides
			; send him a damage
			mvi c, MONSTER_DAMAGE
			jmp HeroImpact
.endmacro