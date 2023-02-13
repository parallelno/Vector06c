; in:
; hl - ptr to animTimer (monster_anim_timer or bullet_anim_timer)
; a - anim speed
; use:
; de, bc, hl
; out:
; hl points to animPtr (bullet_anim_ptr or monster_anim_ptr)
actor_anim_update:
			; update monster_anim_timer
			add m
			mov m, a
			; advance hl to monster_anim_ptr
			inx h ; to make hl point to monster_anim_ptr when it returns
			rnc
			; read the ptr to a current frame
			mov e, m
			inx h
			mov d, m
			xchg
			; hl - the ptr to a current frame
			; get the offset to the next frame
			mov c, m
			inx h
			mov b, m
			; advance the current frame ptr to the next frame
			dad b
			xchg
			; de - the next frame ptr
			; hl points to monster_anim_ptr+1
			; store de into the monster_anim_ptr
			mov m, d
			dcx h
			mov m, e
			ret


