.include "asm\\monsters\\monsters_data.asm"
.include "asm\\monsters\\monster_macro.asm"
.include "asm\\monsters\\skeleton.asm"
.include "asm\\monsters\\vampire.asm"
.include "asm\\monsters\\burner.asm"
.include "asm\\monsters\\knight.asm"


; in:
; hl - 	posX, posY
; a  - 	collider width
; c  - 	collider height
; out:
; no collision 	- (hl) >= ACTOR_RUNTIME_DATA_DESTR
; collision 	- hl points to a collided monster_update_ptr+1, (hl) < ACTOR_RUNTIME_DATA_DESTR
; use:
; b
monsters_get_first_collided:
			sta @colliderWidth+1
			mov a, c
			sta @colliderHeight+1
			mov a, h
			sta @colliderPosX+1
			mov a, l
			sta @colliderPosY+1
			lxi h, monster_update_ptr+1

@loop:
			mov a, m
			cpi ACTOR_RUNTIME_DATA_DESTR
			jc @checkCollision
			cpi ACTOR_RUNTIME_DATA_LAST
			jc @next_data
			; no collision against all alive monsters
			ret
@checkCollision:
			push h
			; advance hl to monster_type
			LXI_B_TO_DIFF(monster_type, monster_update_ptr+1)
			dad b
			mov a, m
			cpi MONSTER_TYPE_ALLY
			jz @noCollision

			; advance hl to monster_pos_x+1
			LXI_B_TO_DIFF(monster_pos_x+1, monster_type)
			dad b
			; horizontal check
			mov c, m 	; monster posX
@colliderPosX:
			mvi a, TEMP_BYTE
			mov b, a	; tmp
@colliderWidth:
			adi TEMP_BYTE
			cmp c
			jc @noCollision
			mvi a, SKELETON_COLLISION_WIDTH-1
			add c
			cmp b
			jc @noCollision
			; vertical check
			INX_H(2)
			mov c, m ; monster posY
@colliderPosY:
			mvi a, TEMP_BYTE
			mov b, a
@colliderHeight:
			adi TEMP_BYTE
			cmp c
			jc @noCollision
			mvi a, SKELETON_COLLISION_HEIGHT-1
			add c
			cmp b
			jc @noCollision

			; collides
			pop h
			ret
@noCollision:
			pop h
@next_data:
			lxi b, MONSTER_RUNTIME_DATA_LEN
			dad b
			jmp @loop
			

; call all active monsters' Update/Draw func
; a func will get DE pointing to a func ptr (ex.:monster_update_ptr or monster_draw_ptr) in the runtime data
; in:
; hl - an offset to a func ptr relative to monster_update_ptr in the runtime data
; 		ex.: the offset to monster_update_ptr is zero
; use:
; de, a
monsters_data_func_caller:
			shld @funcPtrOffset+1
			lxi h, monster_update_ptr+1
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
@funcPtrOffset:
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
			lxi d, MONSTER_RUNTIME_DATA_LEN
			dad d
			jmp @loop
			ret			
			

; call a provided func (monster_copy_to_scr, monster_erase) if a monster is alive
; a func will get HL pointing to a monster_update_ptr+1 in the runtime data, and A holding a MONSTER_RUNTIME_DATA_* status
; in:
; hl - a func addr
; use:
; de, a
monsters_common_func_caller:
			shld @funcPtr+1
			lxi h, monster_update_ptr+1
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
			lxi d, MONSTER_RUNTIME_DATA_LEN
			dad d
			jmp @loop
			ret
			
monsters_update:
			lxi h, 0
			jmp monsters_data_func_caller

monsters_draw:
			lxi h, monster_draw_ptr - monster_update_ptr
			jmp monsters_data_func_caller

monsters_copy_to_scr:
			lxi h, monster_copy_to_scr
			jmp monsters_common_func_caller

monsters_erase:
			lxi h, monster_erase
			jmp monsters_common_func_caller

; copy sprites from a backbuffer to a scr
; in:
; hl - ptr to monster_update_ptr+1 in the runtime data
monster_copy_to_scr:
			; advance to monster_status
			LXI_D_TO_DIFF(monster_status, monster_update_ptr+1)
			dad d
			; if it is invisible, return
			mov a, m
			cpi ACTOR_STATUS_INVIS
			rz

			; advance to monster_erase_scr_addr
			LXI_B_TO_DIFF(monster_erase_scr_addr, monster_status)			
			dad b
			; read monster_erase_scr_addr
			mov c, m
			inx h
			mov b, m
			inx h
			; read monster_erase_scr_addr_old
			mov e, m
			inx h
			mov d, m
			; store monster_erase_scr_addr temp
			xchg
			shld @oldTopRightConner+1
			xchg
			; store monster_erase_scr_addr to monster_erase_scr_addr_old
			mov m, b
			dcx h
			mov m, c
			; bc - hero_erase_scr_addr
			; de - hero_erase_scr_addr_old
			; hl - ptr to monster_erase_scr_addr_old
			; get min(b, d), min(c, e)
			mov a, d
			cmp b
			jc @keepOldX
			mov d, b
@keepOldX:
			mov a, e
			cmp c
			jc @keepOldY 
			mov e, c
@keepOldY:
			; tmp store a scr addr to copy
			push d
			; bc - monster_erase_scr_addr
			; calc top-right corner addr (hero_erase_scr_addr + monster_erase_wh)
			INX_H(2)
			mov d, b
			mov e, c
			; bc - monster_erase_wh
			mov c, m
			inx h
			mov b, m
			inx h
			xchg
			dad b
			xchg
			; bc - monster_erase_wh_old
			; store monster_erase_wh to monster_erase_wh_old
			mov a, m
			mov m, c
			mov c, a
			inx h
			mov a, m
			mov m, b
			mov b, a
			; calc old top-right corner addr (hero_erase_scr_addr_old + monster_erase_wh_old)
@oldTopRightConner:
			lxi h, TEMP_WORD
			dad b
			; hl - hero_erase_scr_addr_old + monster_erase_wh_old
			; de - hero_erase_scr_addr + monster_erase_wh
			; get max(h, d), max(l, e)
			mov a, h
			cmp d
			jnc @keepOldTRX
			mov h, d
@keepOldTRX:
			mov a, l
			cmp e
			jnc @keepOldTRY 
			mov l, e
@keepOldTRY:
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
; hl - ptr to monster_update_ptr+1 in the runtime data
; a - MONSTER_RUNTIME_DATA_* status
monster_erase:
			; if a monster is destroyed mark its data as empty
			cpi ACTOR_RUNTIME_DATA_DESTR
			jz actor_set_empty

			; advance to monster_status
			LXI_D_TO_DIFF(monster_status, monster_update_ptr+1)
			dad d
			; if it is invisible, return
			mov a, m
			cpi ACTOR_STATUS_INVIS
			rz

			; advance to monster_erase_scr_addr
			LXI_D_TO_DIFF(monster_erase_scr_addr, monster_status)
			dad d
			mov e, m
			inx h
			mov d, m

			LXI_B_TO_DIFF(monster_erase_wh, monster_erase_scr_addr+1)
			dad b
			mov a, m
			inx h
			mov h, m			
			mov l, a
			; hl - monster_erase_wh
			; de - monster_erase_scr_addr

			; check if it needs to restore the background
			push h
			push d
			call room_check_tiledata_restorable
			pop d
			pop h
						
			jnz sprite_copy_to_back_buff_v ; restore a background
			CALL_RAM_DISK_FUNC(__erase_sprite, __RAM_DISK_S_BACKBUFF | __RAM_DISK_M_ERASE_SPRITE | RAM_DISK_M_8F)
			ret


monster_impacted:
			ROOM_SPAWN_RATE_UPDATE(rooms_spawn_rate_monsters, MONSTER_SPAWN_RATE_DELTA, MONSTER_SPAWN_RATE_MAX)
			; de - ptr to monster_impacted_ptr+1
			LXI_H_TO_DIFF(monster_update_ptr+1, monster_impacted_ptr+1)
			dad d
			jmp actor_destroy