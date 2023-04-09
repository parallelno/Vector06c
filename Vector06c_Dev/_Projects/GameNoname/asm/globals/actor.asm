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

; look up an empty spot in the actor (monster, bullet, back, fx) runtime data
; in:
; hl - ptr to runtime_data+1, ex monster_update_ptr+1
; a - RUNTIME_DATA_LEN
; return:
; hl - a ptr to an empty actor runtime_data+1
; uses:
; hl, de, a
actor_get_empty_data_ptr:
			sta @len1 + 1
			sta @next_data + 1
@loop:
			mov a, m
			cpi ACTOR_RUNTIME_DATA_EMPTY
			; return if it's empty data
			rz
			jc @next_data
			cpi ACTOR_RUNTIME_DATA_LAST
			jnz @too_many_objects
			; it is the end of the last monster data
			xchg
@len1:
			lxi h, TEMP_WORD
			dad d
			mvi a, ACTOR_RUNTIME_DATA_END
			cmp m
			xchg
			; if the next after the last data is end, then just return
			rz
			; if not the end, then set it as the last
			xchg
			mvi m, ACTOR_RUNTIME_DATA_LAST
			xchg
			; TODO: optimize. store hl into lastRemovedMonsterRuntimeDataPtr
			ret
@too_many_objects:
			; return bypassing a func that called this func
			pop psw
			ret
@next_data:
			lxi d, TEMP_WORD
			dad d
			jmp @loop

; TODO: convert small funcs below to macros
actor_erase_runtime_data:
			mvi m, ACTOR_RUNTIME_DATA_LAST
			ret

; mark the actor's runtime data as it's going to be destroyed
; in:
; hl - update_ptr+1 ptr
; TODO: optimize. fill up lastRemovedBulletRuntimeDataPtr
actor_destroy:
			mvi m, ACTOR_RUNTIME_DATA_DESTR
			ret

; mark the actor's runtime data as empty
; in:
; hl - update_ptr+1 ptr
; TODO: optimize. fiil up lastRemovedBulletRuntimeDataPtr
actor_set_empty:
			mvi m, ACTOR_RUNTIME_DATA_EMPTY
			ret