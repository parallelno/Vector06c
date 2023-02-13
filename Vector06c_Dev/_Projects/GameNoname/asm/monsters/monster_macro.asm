
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
			call sprite_get_addr

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


; update the anim, then check the monster collision with a hero
; ex MONSTER_CHECK_COLLISION_HERO(VAMPIRE_COLLISION_WIDTH, VAMPIRE_COLLISION_HEIGHT, VAMPIRE_DAMAGE)
; in:
; hl points to monsterAnimPtr
.macro MONSTER_CHECK_COLLISION_HERO(MONSTER_COLLISION_WIDTH, MONSTER_COLLISION_HEIGHT, MONSTER_DAMAGE)
			; hl points to monsterAnimPtr
			; TODO: check hero-monster collision not every frame
			; advance hl to monsterPosX
			LXI_B_TO_DIFF(monsterPosX+1, monsterAnimPtr)
			dad b
			; horizontal check
			mov c, m ; posX
			lda hero_pos_x+1
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
			lda hero_pos_y+1
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

; monster initialization
; in:
; c - tile idx in the roomTilesData array.
; a - monster id * 4
;ex. MONSTER_INIT(KnightUpdate, KnightDraw, KnightImpact, KNIGHT_HEALTH, KNIGHT_STATUS_DETECT_HERO_INIT, knight_idle)
.macro MONSTER_INIT(MONSTER_UPDATE, MONSTER_DRAW, MONSTER_IMPACT, MONSTER_HEALTH, MONSTER_STATUS_DETECT_HERO_INIT, MONSTER_ANIM)
			rrc_(2) ; to get monsterID
			sta @monsterId+1
			call MonstersGetEmptyDataPtr
			; hl - ptr to monsterUpdatePtr+1
			; advance hl to monsterUpdatePtr
			dcx h
			mvi m, <MONSTER_UPDATE
			inx h
			mvi m, >MONSTER_UPDATE
			; advance hl to monsterDrawPtr
			inx h
			mvi m, <MONSTER_DRAW
			inx h
			mvi m, >MONSTER_DRAW
			; advance hl to monsterImpactPtr
			inx h
			mvi m, <MONSTER_IMPACT
			inx h
			mvi m, >MONSTER_IMPACT

			; advance hl to monsterId
			inx h
@monsterId:	mvi m, TEMP_BYTE

			; advance hl to monsterType
			inx h
			mvi m, MONSTER_TYPE_ENEMY
			; advance hl to monsterHealth
			inx h
			mvi m, MONSTER_HEALTH
			; advance hl to monsterStatus
			inx h
			mvi m, MONSTER_STATUS_DETECT_HERO_INIT
			; advance hl to monsterAnimPtr
			LXI_D_TO_DIFF(monsterAnimPtr, monsterStatus)
			dad d
			mvi m, <MONSTER_ANIM
			inx h
			mvi m, >MONSTER_ANIM

			; c - tileIdx
			; posX = tile idx % ROOM_WIDTH * TILE_WIDTH
			mvi a, %00001111
			ana c
			rlc_(4)
			mov b, a
			; scrX = posX/8 + $a0
			rrc_(3)
			adi SPRITE_X_SCR_ADDR
			mov d, a
			; posY = (tile idx % ROOM_WIDTH) * TILE_WIDTH
			mvi a, %11110000
			ana c
			mvi e, 0
			; d = scrX
			; b = posX
			; a = posY
			; e = 0 and SPRITE_W_PACKED_MIN
			; hl - ptr to monsterUpdatePtr+1

			; advance hl to monsterEraseScrAddr
			inx h
			mov m, a
			inx h
			mov m, d
			; advance hl to monsterEraseScrAddrOld
			inx h
			mov m, a
			inx h
			mov m, d
			; advance hl to monsterEraseWH
			inx h
			mvi m, SPRITE_H_MIN
			inx h
			mov m, e
			; advance hl to monsterEraseWHOld
			inx h
			mvi m, SPRITE_H_MIN
			inx h
			mov m, e
			; advance hl to monsterPosX
			inx h
			mov m, e
			inx h
			mov m, b
			; advance hl to monsterPosY
			inx h
			mov m, e
			inx h
			mov m, a

			; return zero to erase the tile data
			; there this monster was in the roomTilesData
			xra a
.endmacro