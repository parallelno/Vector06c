.include "asm\\bullets\\bullets_macro.asm"
.include "asm\\bullets\\vfx_consts.asm"
.include "asm\\bullets\\hero_sword.asm"
.include "asm\\bullets\\scythe.asm"
.include "asm\\bullets\\bomb.asm"
.include "asm\\bullets\\vfx.asm"

bullets_init:
			mvi a, <bullets_runtime_data
			sta bullet_runtime_data_sorted
			; set the last marker byte of runtime_data
			mvi a, ACTOR_RUNTIME_DATA_END
			sta bullets_runtime_data_end_marker + 1
			; erase runtime_data
			lxi h, bullet_update_ptr + 1
			jmp actor_erase_runtime_data


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
			shld @funcPtr+1
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
@funcPtr:
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
			LXI_D_TO_DIFF(bullet_status, bullet_update_ptr+1)
			dad d
			; if it is invisible, return
			mov a, m
			ani ACTOR_STATUS_BIT_INVIS
			rnz

			; advance to bullet_erase_scr_addr
			LXI_B_TO_DIFF(bullet_erase_scr_addr, bullet_status)			
			dad b
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
			LXI_D_TO_DIFF(bullet_status, bullet_update_ptr+1)
			dad d
			; if it is invisible, return
			mov a, m
			ani ACTOR_STATUS_BIT_INVIS
			rnz

			; advance to bullet_erase_scr_addr
			LXI_D_TO_DIFF(bullet_erase_scr_addr, bullet_status)
			dad d
			mov e, m
			inx h
			mov d, m

			LXI_B_TO_DIFF(bullet_erase_wh, bullet_erase_scr_addr+1)
			dad b
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
