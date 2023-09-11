; draw a bullet sprite into a backbuffer
; ex. BULLET_DRAW(sprite_get_scr_addr_scythe, __RAM_DISK_S_SCYTHE)
; in:
; de - ptr to bullet_draw_ptr in the runtime data
; TODO: try to convert it into a function
.macro BULLET_DRAW(sprite_get_scr_addr_bullet, __RAM_DISK_S_BULLET, check_invis = true)
        .if check_invis
			; advance to bullet_status
			LXI_H_TO_DIFF(bullet_status, bullet_draw_ptr)
			dad d
			mov a, m
			ani ACTOR_STATUS_BIT_INVIS
			rnz

			LXI_D_TO_DIFF(bullet_pos_x+1, bullet_status)
		.endif 
		.if check_invis == false
			LXI_H_TO_DIFF(bullet_pos_x+1, bullet_draw_ptr)
		.endif
			dad d
			call sprite_get_scr_addr_bullet
			; de - sprite screen addr
			; c - preshifted sprite idx*2 offset based on pos_x then +2
			; hl - ptr to pos_y+1
			mov a, c ; temp
			; advance to bullet_anim_ptr
			HL_ADVANCE_BY_DIFF_BC(bullet_anim_ptr, bullet_pos_y+1)
			mov b, m
			inx h
			push h
			mov h, m
			mov l, b
			mov c, a
			; hl - anim_ptr
			; c - preshifted sprite idx*2 offset
			call sprite_get_addr
			
			CALL_RAM_DISK_FUNC(__draw_sprite_vm, __RAM_DISK_S_BULLET | __RAM_DISK_M_DRAW_SPRITE_VM | RAM_DISK_M_8F)
			pop h
			inx h
			; hl - ptr to bullet_erase_scr_addr
			; store the current scr addr, into bullet_erase_scr_addr
			mov m, c
			inx h
			mov m, b
			; advance to bullet_erase_wh
			HL_ADVANCE_BY_DIFF_BC(bullet_erase_wh, bullet_erase_scr_addr+1)
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
			; TODO: check hero-bullet collision not every frame			
			; advance hl to bullet_pos_x
			HL_ADVANCE_BY_DIFF_BC(bullet_pos_x+1, bullet_anim_ptr)
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