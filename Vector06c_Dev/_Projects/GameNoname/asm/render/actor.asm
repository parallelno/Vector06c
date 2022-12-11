; in:
; hl - ptr to animTimer (monsterAnimTimer or bulletAnimTimer)
; a - anim speed
; use:
; de, bc
; out:
; hl points to animPtr (bulletAnimPtr or monsterAnimPtr)
AnimationUpdate:
			; update monsterAnimTimer
			add m
			mov m, a
			rnc
			; advance hl to monsterAnimPtr
			inx h
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


