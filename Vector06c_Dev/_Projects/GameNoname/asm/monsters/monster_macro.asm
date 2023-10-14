
; draw a monster sprite into a backbuffer
; ex. MONSTER_DRAW(sprite_get_scr_addr_skeleton, __RAM_DISK_S_SKELETON)
; in:
; de - ptr to monster_draw_ptr in the runtime data
; TODO: think of converting it into a function it will save 50*4 = 200 bytes
.macro MONSTER_DRAW(sprite_get_scr_addr_monster, __RAM_DISK_S_MONSTER)
			LXI_H_TO_DIFF(monster_draw_ptr, monster_pos_x+1)
			dad d
			call sprite_get_scr_addr_monster
			; hl - ptr to monster_pos_y+1
			; tmp a = c
			mov a, c

			; advance hl to monster_anim_ptr
			HL_ADVANCE_BY_DIFF_BC(monster_pos_y+1, monster_anim_ptr)
			mov b, m
			inx h
			push h
			mov h, m
			mov l, b
			mov c, a
			; hl - anim_ptr
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
			HL_ADVANCE_BY_DIFF_BC(monster_erase_scr_addr+1, monster_erase_wh)
			; store a width and a height into monster_erase_wh
			mov m, e
			inx h
			mov m, d
			ret
.endmacro


; check the monster collision with a hero
; ex MONSTER_CHECK_COLLISION_HERO(VAMPIRE_COLLISION_WIDTH, VAMPIRE_COLLISION_HEIGHT, VAMPIRE_DAMAGE)
; in:
; hl points to monster_anim_ptr
; uses:
; bc, de, hl, a
; think of converting this macro into a func. it'll save 168 bytes.
.macro MONSTER_CHECK_COLLISION_HERO(MONSTER_COLLISION_WIDTH, MONSTER_COLLISION_HEIGHT, MONSTER_DAMAGE)
			; hl points to monster_anim_ptr
			; advance hl to monster_pos_x
			HL_ADVANCE_BY_DIFF_BC(monster_anim_ptr, monster_pos_x+1)
			; horizontal check
			mov c, m ; pos_x
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
			INX_H(2)
			mov c, m ; pos_y
			lda hero_pos_y+1
			mov b, a
			adi HERO_COLLISION_HEIGHT-1
			cmp c
			rc
			mvi a, MONSTER_COLLISION_HEIGHT-1
			add c
			cmp b
			rc
@collides_hero:
			; hero collides
			; send him a damage
			mvi c, MONSTER_DAMAGE
			jmp hero_impacted
.endmacro