; update anim, check collision against the hero
; in:
; hl - bullet_anim_timer
; a - anim speed
; out:
; if no collision:
;	it returns
; if it collides:
;	no returns
;	hl - bullet_pos_y+1
; rev 1 168cc
; rev 2 144cc
.macro BULLET_UPDATE_ANIM_CHECK_COLLISION_HERO(BULLET_COLLISION_WIDTH, BULLET_COLLISION_HEIGHT, BULLET_DAMAGE)
			call actor_anim_update
@check_collision:
			; hl points to bullet_anim_ptr
			; advance hl to bullet_pos_x
			L_ADVANCE(bullet_anim_ptr, bullet_pos_x+1, BY_A)

			; rough collision check. it assumes the biggest bullet collision dimention <= the biggest hero dimension
			HERO_COLLISION_SIZE .var HERO_COLLISION_WIDTH
			.if HERO_COLLISION_WIDTH < BULLET_COLLISION_HEIGHT
				HERO_COLLISION_SIZE = BULLET_COLLISION_HEIGHT
			.endif

			; precise collision check
			; horizontal check
			lda hero_pos_x+1
			adi HERO_COLLISION_WIDTH
			cmp m
			rc ; 48cc
			sui HERO_COLLISION_WIDTH + BULLET_COLLISION_WIDTH
			cmp m
			rnc ; 72cc
			; 64cc

			; advance hl to bullet_pos_y+1
			INX_H(2)

			; vertical check
			lda hero_pos_y+1
			adi HERO_COLLISION_HEIGHT
			cmp m
			rc
			sui HERO_COLLISION_HEIGHT + BULLET_COLLISION_HEIGHT
			cmp m
			rnc
			; cc = 144
			
@collides_hero:
			; hero collides
			; hl points to bullet_pos_y+1
			push h
			; send him a damage
			mvi c, BULLET_DAMAGE
			call hero_impacted
			pop h
.endmacro