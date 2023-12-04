; draw a bullet sprite into a backbuffer
; ex. BULLET_DRAW(sprite_get_scr_addr_scythe, __RAM_DISK_S_SCYTHE)
; in:
; de - ptr to bullet_draw_ptr 
; TODO: try to convert it into a function
.macro BULLET_DRAW(sprite_get_scr_addr_bullet, __ram_disk_s, check_invis = true)
        .if check_invis
			; advance to bullet_status
			HL_ADVANCE(bullet_draw_ptr, bullet_status, BY_HL_FROM_DE)
			mov a, m
			ani ACTOR_STATUS_BIT_INVIS
			rnz

			HL_ADVANCE(bullet_status, bullet_pos_x+1, BY_DE)
		.endif 
		.if check_invis == false
			HL_ADVANCE(bullet_draw_ptr, bullet_pos_x+1, BY_HL_FROM_DE)
		.endif
			; hl - ptr to bullet_pos_x+1
			call sprite_get_scr_addr_bullet
			; de - sprite screen addr
			; c - preshifted sprite idx*2 offset based on pos_x then +2
			; hl - ptr to pos_y+1
			mov a, c ; temp
			; advance to bullet_anim_ptr
			HL_ADVANCE(bullet_pos_y+1, bullet_anim_ptr, BY_BC)
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
			; hl - ptr to bullet_erase_scr_addr
			; d - width
			;		00 - 8pxs,
			;		01 - 16pxs,
			;		10 - 24pxs,
			;		11 - 32pxs,
			; e - height
			; bc - sprite screen addr + offset

			; store the current scr addr, into bullet_erase_scr_addr
			mov m, c
			inx h
			mov m, b
			; advance to bullet_erase_wh
			HL_ADVANCE(bullet_erase_scr_addr+1, bullet_erase_wh)
			; store a width and a height into bullet_erase_wh
			mov m, e
			inx h
			mov m, d
			ret
.endmacro

; update anim, check collision with a hero
; in:
; hl - bullet_anim_timer
; a - anim speed
; out:
; if no collision:
;	it returns
; if it collides:
;	no returns
;	hl - bullet_pos_y+1
.macro BULLET_UPDATE_ANIM_CHECK_COLLISION_HERO(BULLET_COLLISION_WIDTH, BULLET_COLLISION_HEIGHT, BULLET_DAMAGE)
			call actor_anim_update
@checkCollisionHero:
			; hl points to bullet_anim_ptr
			; advance hl to bullet_pos_x
			HL_ADVANCE(bullet_anim_ptr, bullet_pos_x+1, BY_BC)
			; horizontal check
			mov c, m ; pos_x
			lda hero_pos_x+1
			mov b, a ; tmp
			adi HERO_COLLISION_WIDTH-1
			cmp c
			rc
			mvi a, BULLET_COLLISION_WIDTH-1
			add c
			cmp b
			rc
			; vertical check
			; advance hl to bullet_pos_y+1
			INX_H(2)
			mov c, m ; pos_y
			lda hero_pos_y+1
			mov b, a
			adi HERO_COLLISION_HEIGHT-1
			cmp c
			rc
			mvi a, BULLET_COLLISION_HEIGHT-1
			add c
			cmp b
			rc
@collides_hero:
			; hero collides
			; hl points to bullet_pos_y+1
			push h
			; send him a damage
			mvi c, BULLET_DAMAGE
			call hero_impacted
			pop h
.endmacro