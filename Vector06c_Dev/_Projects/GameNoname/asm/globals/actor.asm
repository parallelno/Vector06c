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
			; hl points to a vacant monster_data

			; if (hl + monster_data_len) points to ACTOR_RUNTIME_DATA_END, just return hl
			; in other case store ACTOR_RUNTIME_DATA_LAST marker to (hl + monster_data_len)
			; to mark this monster data the last element in monste runtime data array

			xchg
			dad d
			; hl - ptr to a marker after the vacant monster runtme data
			mov a, m
			cpi ACTOR_RUNTIME_DATA_END
			xchg
			rz ; it is ACTOR_RUNTIME_DATA_END, no need to store ACTOR_RUNTIME_DATA_LAST marker
			; it is not, store ACTOR_RUNTIME_DATA_LAST marker
			xchg
			mvi m, ACTOR_RUNTIME_DATA_LAST
			cmp a ; to set z flag
			xchg
			ret

@next_data:
			dad d
			jmp @loop

; replaces the actor runtime data with a marker 
; indicating that there is no actor runtime data here and beyond
; used mostly for erasing all runtime data
.macro ACTOR_ERASE_RUNTIME_DATA(actor_update_ptr)
			lxi h, actor_update_ptr + 1
			mvi m, ACTOR_RUNTIME_DATA_LAST
.endmacro

; marks the actor's runtime data as it's going to be destroyed
; in:
; hl - update_ptr+1 ptr
; TODO: optimize. fill up lastRemovedBulletRuntimeDataPtr
.macro ACTOR_DESTROY()
			mvi m, ACTOR_RUNTIME_DATA_DESTR
.endmacro


; marks the actor runtime data as empty
; in:
; hl - update_ptr+1 ptr
; TODO: optimize. fiil up lastRemovedBulletRuntimeDataPtr
.macro ACTOR_EMPTY()
			mvi m, ACTOR_RUNTIME_DATA_EMPTY
.endmacro

; calls a provided func for each actor with a status ACTOR_RUNTIME_DATA_ALIVE
; a ptr of a provided func has to be stored in the runtime data
; an invoked func will get DE pointing to a func ptr in the runtime data (monster_update_ptr or bullet_draw_ptr, etc)
; ex. ACTORS_INVOKE_IF_ALIVE(bullet_update_ptr, bullet_update_ptr, BULLET_RUNTIME_DATA_LEN, true)
; in:
; a - an offset from actor_update_ptr to func_ptr
; de - actor_update_ptr + 1
; hl - runtime data len
; use:
; hl, de, a
.macro ACTORS_INVOKE_IF_ALIVE(actor_calling_func_ptr, update_func_ptr, runtime_data_len, _jmp = false)
			mvi a, <(actor_calling_func_ptr - update_func_ptr)
			lxi d, update_func_ptr + 1
			lxi h, runtime_data_len
		.if _jmp == false
			call actors_invoke_if_alive
		.endif
		.if _jmp
			jmp actors_invoke_if_alive
		.endif
.endmacro

actors_invoke_if_alive:
			sta @func_ptr_offset+1
			shld @data_len+1
			xchg
@loop:
			mov a, m
			cpi ACTOR_RUNTIME_DATA_DESTR
			jc @call_func ; call if it's ACTOR_RUNTIME_DATA_ALIVE
			cpi ACTOR_RUNTIME_DATA_LAST
			jc @next_data ; skip if it's ACTOR_RUNTIME_DATA_DESTR or ACTOR_RUNTIME_DATA_EMPTY
			ret ; no more actors to process
@call_func:
			push h
			lxi d, @return
			push d
@func_ptr_offset:
			lxi d, TEMP_ADDR
			; advance to a func ptr
			dad d
			; read the func addr
			mov d, m
			dcx h
			mov e, m
			xchg
			; call a func
			pchl
@return:
			pop h
@next_data:
@data_len:
			lxi d, TEMP_WORD
			dad d
			jmp @loop
			ret

; calls any provided func for each actor with a status ACTOR_RUNTIME_DATA_ALIVE or ACTOR_RUNTIME_DATA_DESTR
; a called func will get HL pointing to a monster_update_ptr+1 in the runtime data, and A holding an actor status
; ex. ACTORS_CALL_IF_ALIVE(monster_copy_to_scr, monster_update_ptr, MONSTER_RUNTIME_DATA_LEN, true)
; in:
; hl - a func addr
; de - actor_update_ptr+1
; a - runtime data len
; use:
; de, a
.macro ACTORS_CALL_IF_ALIVE(calling_func_ptr, update_func_ptr, runtime_data_len, _jmp = false)
			lxi h, calling_func_ptr
			lxi d, update_func_ptr + 1
			mvi a, runtime_data_len
		.if _jmp == false
			call actors_call_if_alive
		.endif
		.if _jmp
			jmp actors_call_if_alive
		.endif
.endmacro
actors_call_if_alive:
			sta @data_len+1
			shld @func_ptr+1
			xchg
@loop:
			mov a, m
			cpi ACTOR_RUNTIME_DATA_EMPTY
			jc @call_func
			jz @next_data
			; it is the last or the end, so return
			ret
@call_func:
			push h
@func_ptr:
			call TEMP_ADDR
			pop h
@next_data:
@data_len:
			lxi d, TEMP_WORD
			dad d
			jmp @loop
			ret

; erase a sprite or restore the background behind a sprite
; requires (bullet_status - bullet_erase_scr_addr) == (monster_status - monster_erase_scr_addr)
; requires (bullet_erase_scr_addr+1 - bullet_erase_wh) == (monster_erase_scr_addr+1 - monster_erase_wh)
; in:
; hl - ptr to actor_update_ptr+1 
; de - LXI_D_TO_DIFF(actor_update_ptr+1, actor_status)
; a - ACTOR_RUNTIME_DATA_* status
actor_erase:
			; validation
		.if (bullet_status - bullet_erase_scr_addr) != (monster_status - monster_erase_scr_addr)
			.error "actor_erase func fails because (bullet_status - bullet_erase_scr_addr) != (monster_status - monster_erase_scr_addr)"
		.endif
		.if (bullet_erase_scr_addr+1 - bullet_erase_wh) != (monster_erase_scr_addr+1 - monster_erase_wh)
			.error "actor_erase func fails because (bullet_erase_scr_addr+1 - bullet_erase_wh) != (monster_erase_scr_addr+1 - monster_erase_wh)"
		.endif

			; if an actor is destroyed mark its data as empty
			cpi ACTOR_RUNTIME_DATA_DESTR
			jz @set_empty

			; de - LXI_D_TO_DIFF(actor_update_ptr+1, actor_status)
			; advance to actor_status
			dad d

			; if it is invisible, return
			mov a, m
			ani ACTOR_STATUS_BIT_INVIS
			rnz

			; advance to actor_erase_scr_addr
			HL_ADVANCE_BY_DIFF_DE(bullet_status, bullet_erase_scr_addr)
			mov e, m
			inx h
			mov d, m

			HL_ADVANCE_BY_DIFF_BC(bullet_erase_scr_addr+1, bullet_erase_wh)
			mov a, m
			inx h
			mov h, m
			mov l, a
			; hl - bullet_erase_wh
			; de - bullet_erase_scr_addr

			; check if it needs to restore the background
			push h
			push d
			call room_check_tiledata_restorable
			pop d
			pop h

			jnz sprite_copy_to_back_buff_v ; restore a background
			CALL_RAM_DISK_FUNC(__erase_sprite, __RAM_DISK_S_BACKBUFF | __RAM_DISK_M_ERASE_SPRITE | RAM_DISK_M_8F)
			ret
@set_empty:
			; hl - ptr to bullet_update_ptr+1 
			ACTOR_EMPTY()
			ret