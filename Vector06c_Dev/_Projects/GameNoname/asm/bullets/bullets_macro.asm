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