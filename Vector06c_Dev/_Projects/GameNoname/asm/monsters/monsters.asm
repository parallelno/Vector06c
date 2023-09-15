.include "asm\\monsters\\monsters_data.asm"
.include "asm\\monsters\\monster_macro.asm"
.include "asm\\monsters\\skeleton.asm"
.include "asm\\monsters\\vampire.asm"
.include "asm\\monsters\\burner.asm"
.include "asm\\monsters\\knight.asm"

monsters_init:
			lxi h, monsters_runtime_data
			shld monster_runtime_data_sorted

			; set the last marker byte of runtime_data
			mvi a, ACTOR_RUNTIME_DATA_END
			sta monsters_runtime_data_end_marker + 1
			; erase runtime_data
			lxi h, monster_update_ptr + 1
			call actor_erase_runtime_data
			ret


; monster initialization
; in:
; c - tile_idx in the room_tiledata array.
; a - monster_id * 4
;ex. MONSTER_INIT(knight_update, knight_draw, monster_impacted, KNIGHT_HEALTH, KNIGHT_STATUS_DETECT_HERO_INIT, knight_idle)
.macro MONSTER_INIT(MONSTER_UPDATE, MONSTER_DRAW, MONSTER_IMPACT, MONSTER_HEALTH, MONSTER_STATUS, MONSTER_ANIM)
			lxi d, @init_data
			jmp monster_init

			.word TEMP_WORD  ; safety word because "call actor_get_empty_data_ptr"
			.word TEMP_WORD  ; safety word because an interruption can call
@init_data:
			.word MONSTER_UPDATE, MONSTER_DRAW, MONSTER_IMPACT, MONSTER_STATUS<<8 | MONSTER_HEALTH, MONSTER_ANIM
.endmacro

; monster initialization
; in:
; de - ptr to monster_data: .word MONSTER_ANIM, MONSTER_STATUS | MONSTER_HEALTH<<8, MONSTER_IMPACT, MONSTER_DRAW, MONSTER_UPDATE
; c - tile_idx in the room_tiledata array.
; a - monster_id * 4
monster_init:
			lxi h, 0
			dad	sp
			shld @restore_sp + 1
			xchg
			sphl

			RRC_(2) ; to get monster_id
			sta @monster_id+1

			ROOM_SPAWN_RATE_CHECK(rooms_spawn_rate_monsters, @ret)

			lxi h, monster_update_ptr+1
			mvi e, MONSTER_RUNTIME_DATA_LEN
			call actor_get_empty_data_ptr
			jnz restore_sp ; return because too many objects

			mov a, c
			; a - tile_idx in the room_tiledata array
			; hl - ptr to monster_update_ptr+1			
			
			; advance hl to monster_update_ptr
			dcx h
			pop b ; use bc to read from the stack is requirenment
			; bc - ptr to monster_update_ptr
			mov m, c
			inx h
			mov m, b
			; advance hl to monster_draw_ptr
			inx h
			pop b
			; bc - ptr to monster_draw_ptr
			mov m, c
			inx h
			mov m, b
			; advance hl to monster_impacted_ptr
			inx h
			pop b
			; bc - ptr to monster_impacted_ptr
			mov m, c
			inx h
			mov m, b

			; advance hl to monster_id
			inx h
@monster_id:
			mvi m, TEMP_BYTE

			; advance hl to monster_type
			inx h
			mvi m, MONSTER_TYPE_ENEMY
			; advance hl to monster_health
			inx h
			pop b
			; b - MONSTER_STATUS
			; c - MONSTER_HEALTH
			mov m, c
			; advance hl to monster_status
			inx h
			mov m, b
			
			; advance hl to monster_anim_ptr
			LXI_D_TO_DIFF(monster_anim_ptr, monster_status)
			dad d

			mov e, a
			; e - tile_idx
			
			pop b
			; bc - monster_anim_ptr
			mov m, c
			inx h
			mov m, b

			; e - tile_idx
			; pos_x = tile_idx % ROOM_WIDTH * TILE_WIDTH
			mvi a, %00001111
			ana e
			RLC_(4)
			sta @pos_x + 1
			; scr_x = pos_x/8 + $a0
			RRC_(3)
			adi SPRITE_X_SCR_ADDR
			mov d, a
			; pos_y = (tile_idx % ROOM_WIDTH) * TILE_WIDTH
			mvi a, %11110000
			ana e
			mvi e, 0
			; d = scr_x
			; a = pos_y
			; e = 0 and SPRITE_W_PACKED_MIN
			; hl - ptr to monster_update_ptr+1

			; advance hl to monster_erase_scr_addr
			inx h
			mov m, a
			inx h
			mov m, d
			; advance hl to monster_erase_scr_addr_old
			inx h
			mov m, a
			inx h
			mov m, d
			; advance hl to monster_erase_wh
			inx h
			mvi m, SPRITE_H_MIN
			inx h
			mov m, e
			; advance hl to monster_erase_wh_old
			inx h
			mvi m, SPRITE_H_MIN
			inx h
			mov m, e
			; advance hl to monster_pos_x
			inx h
			mov m, e
			inx h
@pos_x:			
			mvi m, TEMP_BYTE ; pos_x
			; advance hl to monster_pos_y
			inx h
			mov m, e
			inx h
			mov m, a
@ret:
@restore_sp:
			lxi sp, TEMP_ADDR
			RAM_DISK_OFF()
			; return TILEDATA_RESTORE_TILE to make the tile where a monster spawned walkable and restorable
			mvi a, TILEDATA_RESTORE_TILE		
			ret


; in:
; hl - 	pos_x, pos_y
; a  - 	collider width
; c  - 	collider height
; out:
; no collision 	- (hl) >= ACTOR_RUNTIME_DATA_DESTR
; collision 	- hl points to a collided monster_update_ptr+1, (hl) < ACTOR_RUNTIME_DATA_DESTR
; use:
; b
monsters_get_first_collided:
			sta @collider_width+1
			mov a, c
			sta @collider_height+1
			mov a, h
			sta @collider_pos_x+1
			mov a, l
			sta @collider_pos_y+1
			lxi h, monster_update_ptr+1

@loop:
			mov a, m
			cpi ACTOR_RUNTIME_DATA_DESTR
			jc @check_collision
			cpi ACTOR_RUNTIME_DATA_LAST
			jc @next_data
			; no collision against all alive monsters
			ret
@check_collision:
			push h
			; advance hl to monster_type
			HL_ADVANCE_BY_DIFF_BC(monster_type, monster_update_ptr+1)
			mov a, m
			cpi MONSTER_TYPE_ALLY
			jz @no_collision

			; advance hl to monster_pos_x+1
			HL_ADVANCE_BY_DIFF_BC(monster_pos_x+1, monster_type)
			; horizontal check
			mov c, m 	; monster pos_x
@collider_pos_x:
			mvi a, TEMP_BYTE
			mov b, a	; tmp
@collider_width:
			adi TEMP_BYTE
			cmp c
			jc @no_collision
			mvi a, SKELETON_COLLISION_WIDTH-1
			add c
			cmp b
			jc @no_collision
			; vertical check
			INX_H(2)
			mov c, m ; monster pos_y
@collider_pos_y:
			mvi a, TEMP_BYTE
			mov b, a
@collider_height:
			adi TEMP_BYTE
			cmp c
			jc @no_collision
			mvi a, SKELETON_COLLISION_HEIGHT-1
			add c
			cmp b
			jc @no_collision

			; collides
			pop h
			ret
@no_collision:
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
			shld @func_ptr_offset+1
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
			shld @func_ptr+1
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
@func_ptr:
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
			ani ACTOR_STATUS_BIT_INVIS
			rnz

			; advance to monster_erase_scr_addr
			HL_ADVANCE_BY_DIFF_BC(monster_erase_scr_addr, monster_status)
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
			shld @old_top_right_corner+1
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
@old_top_right_corner:
			lxi h, TEMP_WORD
			dad b
			; hl - hero_erase_scr_addr_old + monster_erase_wh_old
			; de - hero_erase_scr_addr + monster_erase_wh
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
			ani ACTOR_STATUS_BIT_INVIS
			rnz

			; advance to monster_erase_scr_addr
			LXI_D_TO_DIFF(monster_erase_scr_addr, monster_status)
			dad d
			mov e, m
			inx h
			mov d, m

			HL_ADVANCE_BY_DIFF_BC(monster_erase_wh, monster_erase_scr_addr+1)
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

; in:
; de - ptr to monster_impacted_ptr + 1
monster_impacted:
			ROOM_SPAWN_RATE_UPDATE(rooms_spawn_rate_monsters, MONSTER_SPAWN_RATE_DELTA, MONSTER_SPAWN_RATE_MAX)
			; de - ptr to monster_impacted_ptr+1

			push d
			; advance hl to monster_id
			LXI_H_TO_DIFF(monster_id, monster_impacted_ptr+1)
			dad d
			; add score points
			mov e, m
			mvi c, TILEDATA_FUNC_ID_MONSTERS
			CALL_RAM_DISK_FUNC(__game_score_add, __RAM_DISK_S_SCORE)
			call game_ui_draw_score
			pop d

			; play a hit vfx
			; advance hl to monster_pos_x+1
			LXI_H_TO_DIFF(monster_pos_x+1, monster_impacted_ptr+1)
			dad d
			mov b, m
			; advance hl to monster_pos_y+1
			INX_H(2)
			mov c, m
			lxi d, vfx4_hit
			push h
			call vfx_init4
			pop h

			; recrease monster's health
			LXI_D_TO_DIFF(monster_health, monster_pos_y+1)
			dad d
			dcr m
			rnz

			; mark this monster dead
			; advance hl to monster_update_ptr+1
			LXI_D_TO_DIFF(monster_update_ptr+1, monster_health)
			dad d
			jmp actor_destroy