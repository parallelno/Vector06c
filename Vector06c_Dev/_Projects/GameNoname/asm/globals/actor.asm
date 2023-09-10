; mark all actors killed to let 
; them wipe out from the screen
; in:
; hl - monster_update_ptr+1 or bullet_update_ptr+1
; bc - runtime_data_len
; ex.
; KILL_ALL_MONSTERS()
; KILL_ALL_BULLETS()
actor_kill_all:
@loop:
			mov a, m
			cpi ACTOR_RUNTIME_DATA_LAST
			rnc
			cpi ACTOR_RUNTIME_DATA_DESTR
			jnc @next
			; kill it
			mvi m, ACTOR_RUNTIME_DATA_DESTR
@next:
			dad b
			jmp @loop

.macro KILL_ALL_MONSTERS()
			lxi h, monster_update_ptr+1
			lxi b, MONSTER_RUNTIME_DATA_LEN
			call actor_kill_all
.endmacro
.macro KILL_ALL_BULLETS()
			lxi h, bullet_update_ptr+1
			lxi b, BULLET_RUNTIME_DATA_LEN
			call actor_kill_all
.endmacro			

; in:
; hl - ptr to anim_timer (monster_anim_timer or bullet_anim_timer)
; a - anim speed
; use:
; de, bc, hl
; out:
; hl points to *_anim_ptr
; C flag = 1 means the animation reached the last frame
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
; e - RUNTIME_DATA_LEN
; return:
; hl - a ptr to an empty actor runtime_data+1
; z flag != 1 if no memory for a new entity
; uses:
; hl, de, a
; TODO: optimize. store hl into lastRemovedMonsterRuntimeDataPtr
actor_get_empty_data_ptr:
			mvi d, 0
@loop:
			mov a, m
			cpi ACTOR_RUNTIME_DATA_EMPTY
			; return if it's empty data
			rz
			jc @next_data
			cpi ACTOR_RUNTIME_DATA_LAST
			rnz ; too many objects
			; we reached the end of the last existing actor's runtime data
			; there is at least a room for one more monster

			; there are only to cases left
			; if it is the last possible monster, then ACTOR_RUNTIME_DATA_END is stored after that data
			; in other case ACTOR_RUNTIME_DATA_LAST is stored after that data
			xchg
			dad d
			mvi a, ACTOR_RUNTIME_DATA_LAST
			ora m
			mov m, a
			xchg
			; if the next byte after the last actor's runtime data is ACTOR_RUNTIME_DATA_END, then just return
			cmp a ; to set z flag
			ret
@next_data:
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