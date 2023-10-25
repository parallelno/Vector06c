.include "asm\\bullets\\bullets_macro.asm"
.include "asm\\bullets\\vfx_consts.asm"
.include "asm\\bullets\\sword.asm"
.include "asm\\bullets\\snowflake.asm"
.include "asm\\bullets\\scythe.asm"
.include "asm\\bullets\\bomb.asm"
.include "asm\\bullets\\sparker.asm"
.include "asm\\bullets\\fart.asm"
.include "asm\\bullets\\vfx.asm"
.include "asm\\bullets\\cursor.asm"

; mark erased the runtime bullet data
bullets_init:
			mvi a, <bullets_runtime_data
			sta bullet_runtime_data_sorted
			; set the last marker byte of runtime_data
			mvi a, ACTOR_RUNTIME_DATA_END
			sta bullets_runtime_data_end_marker + 1
			; erase runtime_data
			lxi h, bullet_update_ptr + 1
			jmp actor_erase_runtime_data


; bullet initialization
; in:
; bc - caster pos
; ex. TODO: add an example
.macro BULLET_INIT(BULLET_UPDATE_PTR, BULLET_DRAW_PTR, BULLET_STATUS, BULLET_STATUS_TIMER, BULLET_ANIM_PTR, BULLET_SPEED_INIT)
			lxi d, @init_data
			jmp bullet_init

			.word TEMP_WORD  ; safety word because "call actor_get_empty_data_ptr"
			.word TEMP_WORD  ; safety word because an interruption can call
@init_data:
			.word BULLET_UPDATE_PTR, BULLET_DRAW_PTR, BULLET_STATUS | BULLET_STATUS_TIMER<<8, BULLET_ANIM_PTR, BULLET_SPEED_INIT
.endmacro

; bullet initialization
; this func calls bullet_speed_init code to define a unique bullet behavior. in for this code
; in:
; de - ptr to bullet_data: .word BULLET_UPDATE_PTR, BULLET_DRAW_PTR, BULLET_STATUS | BULLET_STATUS_TIMER<<8, BULLET_ANIM_PTR, BULLET_SPEED_INIT
; bc - caster pos
; when it calls BULLET_SPEED_INIT code
; in:
; de - ptr to bullet_speed_x
bullet_init:
			lxi h, 0
			dad	sp
			shld @restore_sp + 1
			xchg
			sphl

			mov l, c
			mov h, b
			shld @caster_pos + 1

			lxi h, bullet_update_ptr+1
			mvi e, BULLET_RUNTIME_DATA_LEN
			call actor_get_empty_data_ptr
			rnz ; return when it's too many objects

			; hl - ptr to bullet_update_ptr+1
			; advance hl to bullet_update_ptr
			dcx h
			pop b ; using bc to read from the stack is requirenment
			mov m, c
			inx h
			mov m, b
			; advance hl to bullet_draw_ptr
			inx h
			pop b
			mov m, c
			inx h
			mov m, b
			; advance hl to bullet_id
			inx h ; TODO: think of excluding bullet_id from the bullet_data
			; advance hl to bullet_status
			inx h
			pop b
			mov m, c
			; advance hl to bullet_status_timer
			inx h
			mov m, b
			; advance hl to bullet_anim_timer
			inx h
			mvi m, 0
			; advance hl to bullet_anim_ptr
			inx h
			pop b
			mov m, c
			inx h
			mov m, b
@caster_pos:
			lxi b, TEMP_WORD
			; bc - scr pos
			mov a, b
			; a - pos_x
			; scr_x = pos_x/8 + SPRITE_X_SCR_ADDR
			RRC_(3)
			ani %00011111
			adi SPRITE_X_SCR_ADDR
			mvi e, 0
			; a = scr_x
			; b = pos_x
			; c = pos_y
			; e = 0 and SPRITE_W_PACKED_MIN

			; advance hl to bullet_erase_scr_addr
			inx h
			mov m, c
			inx h
			mov m, a
			; advance hl to bullet_erase_scr_addr_old
			inx h
			mov m, c
			inx h
			mov m, a
			; advance hl to bullet_erase_wh
			inx h
			mvi m, SPRITE_H_MIN
			inx h
			mov m, e
			; advance hl to bullet_erase_wh_old
			inx h
			mvi m, SPRITE_H_MIN
			inx h
			mov m, e
			; advance hl to bullet_pos_x
			inx h
			mov m, e
			inx h
			mov m, b
			; advance hl to bullet_pos_y
			inx h
			mov m, e
			inx h
			mov m, c
			; advance hl to bullet_speed_x
			inx h

			pop b
			; bc - ptr to init_speed func
@restore_sp:
			lxi sp, TEMP_ADDR
			RAM_DISK_OFF()

			xchg
			; de - ptr to bullet_speed_x
			lxi h, @ret
			push h
			mov l, c
			mov h, b
			pchl
@ret:
			; return TILEDATA_RESTORE_TILE to make the tile where a monster spawned walkable and restorable
			mvi a, TILEDATA_RESTORE_TILE
			ret

; call all active bullets' Update/Draw func
; a func will get DE pointing to a func ptr (ex.:bullet_update_ptr or bullet_draw_ptr) in the runtime data
; in:
; hl - an offset to a func ptr relative to bullet_update_ptr in the runtime data
; 		ex.: the offset to bullet_update_ptr is zero
; use:
; de, a
bullets_data_func_caller:
			shld @func_ptr_offset+1
			lxi h, bullet_update_ptr+1
@loop:
			mov a, m
			cpi ACTOR_RUNTIME_DATA_DESTR
			jc @call_func
			cpi ACTOR_RUNTIME_DATA_LAST
			jc @next_data
			; it is the last or the end, so return
			ret
@call_func:
			push h
			lxi d, @return
			push d
@func_ptr_offset:
			lxi d, TEMP_ADDR
			; advance to a func ptr
			; TODO: replace dad PR with add R, because the data is $100 byte aligned in buffers.asm
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
			lxi d, BULLET_RUNTIME_DATA_LEN
			dad d
			jmp @loop
			ret


; call a provided func (bullet_copy_to_scr, bullet_erase) if a bullet is alive
; a func will get HL pointing to a bullet_update_ptr+1 in the runtime data, and A holding a BULLET_RUNTIME_DATA_* status
; in:
; hl - a func addr
; use:
; de, a
bullets_common_func_caller:
			shld @func_ptr+1
			lxi h, bullet_update_ptr+1
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
			lxi d, BULLET_RUNTIME_DATA_LEN
			dad d
			jmp @loop
			ret


bullets_update:
			lxi h, 0
			jmp bullets_data_func_caller

bullets_draw:
			lxi h, bullet_draw_ptr - bullet_update_ptr
			jmp bullets_data_func_caller

bullets_copy_to_scr:
			lxi h, bullet_copy_to_scr
			jmp bullets_common_func_caller

bullets_erase:
			lxi h, bullet_erase
			jmp bullets_common_func_caller

; copy sprites from a backbuffer to a scr
; in:
; hl - ptr to bullet_update_ptr+1 in the runtime data
bullet_copy_to_scr:
			; advance to bullet_status
			HL_ADVANCE_BY_DIFF_DE(bullet_update_ptr+1, bullet_status)
			; if it is invisible, return
			mov a, m
			ani ACTOR_STATUS_BIT_INVIS
			rnz

			; advance to bullet_erase_scr_addr
			HL_ADVANCE_BY_DIFF_BC(bullet_status, bullet_erase_scr_addr)
			; read bullet_erase_scr_addr
			mov c, m
			inx h
			mov b, m
			inx h
			; read bullet_erase_scr_addr_old
			mov e, m
			inx h
			mov d, m
			; store bullet_erase_scr_addr temp
			xchg
			shld @old_top_right_corner+1
			xchg
			; store bullet_erase_scr_addr to bullet_erase_scr_addr_old
			mov m, b
			dcx h
			mov m, c
			; bc - hero_erase_scr_addr
			; de - hero_erase_scr_addr_old
			; hl - ptr to bullet_erase_scr_addr_old
			; get min(b, d), min(c, e)
			mov a, d
			cmp b
			jc @keep_old_x
			mov d, b
@keep_old_x:
			mov a, e
			cmp c
			jc @keep_old_y
			mov e, c
@keep_old_y:
			; tmp store a scr addr to copy
			push d
			; bc - bullet_erase_scr_addr
			; calc top-right corner addr (hero_erase_scr_addr + bullet_erase_wh)
			INX_H(2)
			mov d, b
			mov e, c
			; bc - bullet_erase_wh
			mov c, m
			inx h
			mov b, m
			inx h
			xchg
			dad b
			xchg
			; bc - bullet_erase_wh_old
			; store bullet_erase_wh to bullet_erase_wh_old
			mov a, m
			mov m, c
			mov c, a
			inx h
			mov a, m
			mov m, b
			mov b, a
			; calc old top-right corner addr (hero_erase_scr_addr_old + bullet_erase_wh_old)
@old_top_right_corner:
			lxi h, TEMP_WORD
			dad b
			; hl - hero_erase_scr_addr_old + bullet_erase_wh_old
			; de - hero_erase_scr_addr + bullet_erase_wh
			; get max(h, d), max(l, e)
			mov a, h
			cmp d
			jnc @keep_old_tr_x
			mov h, d
@keep_old_tr_x:
			mov a, l
			cmp e
			jnc @keep_old_tr_y
			mov l, e
@keep_old_tr_y:
			; hl - top-right corner scr addr to copy
			; de - a scr addr to copy
			pop d
			; calc bc (width, height)
			mov a, h
			sub d
			mov b, a
			mov a, l
			sub e
			mov c, a
			jmp sprite_copy_to_scr_v


; erase a sprite or restore the background behind a sprite
; in:
; hl - ptr to bullet_update_ptr+1 in the runtime data
; a - BULLET_RUNTIME_DATA_* status
bullet_erase:
			; if a bullet is destroyed mark its data as empty
			cpi ACTOR_RUNTIME_DATA_DESTR
			jz actor_set_empty

			; advance to bullet_status
			HL_ADVANCE_BY_DIFF_DE(bullet_update_ptr+1, bullet_status)
			; if it is invisible, return
			mov a, m
			ani ACTOR_STATUS_BIT_INVIS
			rnz

			; advance to bullet_erase_scr_addr
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
