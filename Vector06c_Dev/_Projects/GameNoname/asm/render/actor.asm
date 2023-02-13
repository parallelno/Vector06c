; in:
; hl - ptr to animTimer (monsterAnimTimer or bullet_anim_timer)
; a - anim speed
; use:
; de, bc, hl
; out:
; hl points to animPtr (bullet_anim_ptr or monsterAnimPtr)
actor_anim_update:
			; update monsterAnimTimer
			add m
			mov m, a
			; advance hl to monsterAnimPtr
			inx h ; to make hl point to monsterAnimPtr when it returns
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
			; hl points to monsterAnimPtr+1
			; store de into the monsterAnimPtr
			mov m, d
			dcx h
			mov m, e
			ret


