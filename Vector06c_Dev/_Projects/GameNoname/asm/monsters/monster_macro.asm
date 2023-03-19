
; draw a monster sprite into a backbuffer
; ex. MONSTER_DRAW(sprite_get_scr_addr_skeleton, __RAM_DISK_S_SKELETON)
; in:
; de - ptr to monster_draw_ptr in the runtime data
.macro MONSTER_DRAW(SpriteGetScrAddr_monster, __RAM_DISK_S_MONSTER)
			LXI_H_TO_DIFF(monster_pos_x+1, monster_draw_ptr)
			dad d
			call SpriteGetScrAddr_monster
			; hl - ptr to monster_pos_y+1
			; tmp a = c
			mov a, c

			; advance hl to monster_anim_ptr
			LXI_B_TO_DIFF(monster_anim_ptr, monster_pos_y+1)
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

			CALL_RAM_DISK_FUNC(__draw_sprite_vm, __RAM_DISK_S_MONSTER | __RAM_DISK_M_DRAW_SPRITE_VM | RAM_DISK_M_8F)
			pop h
			inx h
			; hl - ptr to monster_erase_scr_addr
			; store a current scr addr, into monster_erase_scr_addr
			mov m, c
			inx h
			mov m, b
			; advance hl to monster_erase_wh
			LXI_B_TO_DIFF(monster_erase_wh, monster_erase_scr_addr+1)
			dad b
			; store a width and a height into monster_erase_wh
			mov m, e
			inx h
			mov m, d
			ret
.endmacro


; update the anim, then check the monster collision with a hero
; ex MONSTER_CHECK_COLLISION_HERO(VAMPIRE_COLLISION_WIDTH, VAMPIRE_COLLISION_HEIGHT, VAMPIRE_DAMAGE)
; in:
; hl points to monster_anim_ptr
.macro MONSTER_CHECK_COLLISION_HERO(MONSTER_COLLISION_WIDTH, MONSTER_COLLISION_HEIGHT, MONSTER_DAMAGE)
			; hl points to monster_anim_ptr
			; TODO: check hero-monster collision not every frame
			; advance hl to monster_pos_x
			LXI_B_TO_DIFF(monster_pos_x+1, monster_anim_ptr)
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
			; advance hl to monster_pos_y+1
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
			jmp hero_impacted
.endmacro

; monster initialization
; in:
; c - tile idx in the room_tiledata array.
; a - monster id * 4
;ex. MONSTER_INIT(knight_update, knight_draw, monster_impacted, KNIGHT_HEALTH, KNIGHT_STATUS_DETECT_HERO_INIT, knight_idle)
.macro MONSTER_INIT(MONSTER_UPDATE, MONSTER_DRAW, MONSTER_IMPACT, MONSTER_HEALTH, MONSTER_STATUS_DETECT_HERO_INIT, MONSTER_ANIM)
			rrc_(2) ; to get monsterID
			sta @monster_id+1

			; TODO: move the code into a spawner init routine
			ROOM_SPAWN_RATE_CHECK(rooms_spawn_rate_monsters, @ret)

			call monsters_get_empty_data_ptr
			; hl - ptr to monster_update_ptr+1
			; advance hl to monster_update_ptr
			dcx h
			mvi m, <MONSTER_UPDATE
			inx h
			mvi m, >MONSTER_UPDATE
			; advance hl to monster_draw_ptr
			inx h
			mvi m, <MONSTER_DRAW
			inx h
			mvi m, >MONSTER_DRAW
			; advance hl to monster_impacted_ptr
			inx h
			mvi m, <MONSTER_IMPACT
			inx h
			mvi m, >MONSTER_IMPACT

			; advance hl to monster_id
			inx h
@monster_id:	mvi m, TEMP_BYTE

			; advance hl to monster_type
			inx h
			mvi m, MONSTER_TYPE_ENEMY
			; advance hl to monster_health
			inx h
			mvi m, MONSTER_HEALTH
			; advance hl to monster_status
			inx h
			mvi m, MONSTER_STATUS_DETECT_HERO_INIT
			; advance hl to monster_anim_ptr
			LXI_D_TO_DIFF(monster_anim_ptr, monster_status)
			dad d
			mvi m, <MONSTER_ANIM
			inx h
			mvi m, >MONSTER_ANIM

			; c - tile_idx
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
			; hl - ptr to monster_update_ptr+1

			; advance hl to monster_erase_scr_addr
			inx h
			mov m, a
			inx h
			mov m, d
			; advance hl to monster_erase_scr_addr_old
			inx h
			mov m, a
			inx h
			mov m, d
			; advance hl to monster_erase_wh
			inx h
			mvi m, SPRITE_H_MIN
			inx h
			mov m, e
			; advance hl to monster_erase_wh_old
			inx h
			mvi m, SPRITE_H_MIN
			inx h
			mov m, e
			; advance hl to monster_pos_x
			inx h
			mov m, e
			inx h
			mov m, b
			; advance hl to monster_pos_y
			inx h
			mov m, e
			inx h
			mov m, a
@ret:
			; return zero to erase the tiledata
			; there this monster was in the room_tiledata
			xra a
.endmacro