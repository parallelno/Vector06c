
; draw a monster sprite into a backbuffer
; ex. MONSTER_DRAW(sprite_get_scr_addr_skeleton, __RAM_DISK_S_SKELETON)
; in:
; de - ptr to monster_draw_ptr 
; TODO: think of converting it into a function it will save 50*4 = 200 bytes
.macro MONSTER_DRAW(sprite_get_scr_addr_monster, __ram_disk_s)
			HL_ADVANCE(monster_draw_ptr, monster_pos_x+1, BY_HL_FROM_D)

			call sprite_get_scr_addr_monster
			; hl - ptr to monster_pos_y+1
			; tmp a = c
			mov a, c

			; advance hl to monster_anim_ptr
			HL_ADVANCE(monster_pos_y+1, monster_anim_ptr, BY_BC)
			mov b, m
			inx h
			push h
			mov h, m
			mov l, b
			mov c, a
			; hl - anim_ptr
			; c - preshifted sprite idx*2 offset
			call sprite_get_addr

			CALL_RAM_DISK_FUNC(__draw_sprite_vm, __ram_disk_s | __RAM_DISK_M_DRAW_SPRITE_VM | RAM_DISK_M_8F)
			pop h
			inx h
			; hl - ptr to monster_erase_scr_addr
			; store a current scr addr, into monster_erase_scr_addr
			mov m, c
			inx h
			mov m, b
			; advance hl to monster_erase_wh
			HL_ADVANCE(monster_erase_scr_addr+1, monster_erase_wh, BY_BC)
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
			HL_ADVANCE(monster_anim_ptr, monster_pos_x+1, BY_BC)
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

; in:
; hl - ptr to monster_status
.macro MONSTER_UPDATE_DETECT_HERO(distance, hero_detected_status, hero_detected_status_time, hero_detected_anim, detect_anim_speed, anim_check_collision_hero, next_status, next_status_time)
			; hl - ptr to monster_status
			; advance hl to monster_status_timer
			inx h
			dcr m
			jz @set_move_init
			
			; check a hero-to-monster distance
			; advance hl to monster_pos_x+1
			HL_ADVANCE(monster_status_timer, monster_pos_x+1, BY_DE)
			mvi c, distance
			call actor_to_hero_distance
			jnc @anim_check_collision_hero

			; hero detected
			; hl - ptr to monster_pos_x+1
			; advance hl to monster_status
			HL_ADVANCE(monster_pos_x+1, monster_status, BY_BC)
			mvi m, hero_detected_status

		.if hero_detected_status_time != NULL
			inx h
			mvi m, hero_detected_status_time
			; advance hl to monster_anim_ptr
			HL_ADVANCE(monster_status_timer, monster_anim_ptr)
			mvi m, <hero_detected_anim
			inx h
			mvi m, >hero_detected_anim
		.endif
			ret

@anim_check_collision_hero:
			HL_ADVANCE(monster_pos_x+1, monster_anim_timer, BY_DE)
			mvi a, detect_anim_speed
			jmp anim_check_collision_hero


@set_move_init:
 			; hl - ptr to monster_status_timer
			mvi m, next_status_time ; TODO: use a rnd number instead of a const
			; advance hl to monster_status
			dcx h
			mvi m, next_status
			ret
.endmacro