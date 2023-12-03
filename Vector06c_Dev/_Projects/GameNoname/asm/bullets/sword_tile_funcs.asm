; in:
; a - container_id
; c - tile_idx
sword_func_container:
			sta @restore_container_id+1
			push b ; store tile_idx
			mov m, c

			; find a container
			lxi h, room_id
			mov d, m
			mov l, a
			FIND_INSTANCE(@no_container_found, containers_inst_data_ptrs)
			; c = tile_idx
			; hl ptr to tile_idx
			; remove this container from containers_inst_data
			inx h
			mvi m, <CONTAINERS_STATUS_ACQUIRED

@no_container_found:
			; erase container_id from tiledata
			mvi b, >room_tiledata
			mvi a, TILEDATA_RESTORE_TILE
			stax b

			call draw_tile_16x16_buffs
			; draw vfx
			; bc - tile screen addr
			lxi d, vfx_reward
			call vfx_init

			pop b
			; c - tile_idx in the room_tiledata array
@restore_container_id:
			mvi a, TEMP_BYTE			
			ADD_A(2) ; container_id to JMP_4 ptr
			sta room_decal_draw_ptr_offset+1
			ROOM_DECAL_DRAW(__containers_opened_gfx_ptrs, true)

			; update a hero container
			lxi h, hero_cont_func_tbl
			lda @restore_container_id+1
			mov e, a
			HL_TO_AX4_PLUS_INT16(hero_cont_func_tbl)
			push h

			; add score points
			; e - container_id
			mvi a, TILEDATA_FUNC_ID_CONTAINERS
			CALL_RAM_DISK_FUNC(__game_score_add, __RAM_DISK_S_SCORE | __RAM_DISK_M_TEXT_EX)
			call game_ui_draw_score_text
			pop h
			; hl - a container handler func ptr
			pchl ; run a container handler

; in:
; a - door_id
; c - tile_idx
sword_func_door:
			; store tile_idx
			lxi h, @tile_idx + 1
			mov m, c

			mov b, a ; temp b = door_id
			; check global item status
			ani %00001110
			rrc

			adi <global_items
			mov l, a
			mvi h, >global_items
			mov a, m
			cpi <ITEM_STATUS_NOT_ACQUIRED
			rz	; if status == ITEM_STATUS_NOT_ACQUIRED, means a hero does't have a proper key to open the door

			mov a, b
			ADD_A(2) ; to make a JMP_4 ptr
			sta room_decal_draw_ptr_offset+1 ; store door_id in case we need to draw an opened version of it

			; update the key status
			mvi m, <ITEM_STATUS_USED

			; add score points
			push b
			mov e, b
			mvi a, TILEDATA_FUNC_ID_DOORS
			CALL_RAM_DISK_FUNC(__game_score_add, __RAM_DISK_S_SCORE)
			call game_ui_draw_score_text
			pop b

			; erase breakable_id from tiledata
			mvi b, >room_tiledata
			mvi a, TILEDATA_RESTORE_TILE
			stax b

			; c - tile_idx
			call draw_tile_16x16_buffs
			; draw vfx
			; bc - tile screen addr
			lxi d, vfx_puff
			call vfx_init

@tile_idx:
			mvi c, TEMP_BYTE
			; c - tile_idx in the room_tiledata array
			ROOM_DECAL_DRAW(__doors_opened_gfx_ptrs, true, true)


; in:
; a - breakable_id
; c - tile_idx
sword_func_breakable:
			mov e, a
			; check if a sword is available
			lda hero_res_sword
			CPI_WITH_ZERO(RES_EMPTY)
			rz ; return if no sword

			; if breakable_id == BREAKABLE_ID_CABBAGE, spawn a fart bullet
			; e - breakable_id
			mvi a, BREAKABLE_ID_CABBAGE
			cmp e
			jnz @not_cabbage
@cabbage:
			; add the cabbage resource
			lxi h, hero_res_cabbage
			INR_CLAMP_M(RES_CABBAGE_MAX)
@not_cabbage:
			; add score points
			push b
			; e - breakable_id			
			mvi a, TILEDATA_FUNC_ID_BREAKABLES
			CALL_RAM_DISK_FUNC(__game_score_add, __RAM_DISK_S_SCORE)
			call game_ui_draw_score_text
			pop b

			; erase breakable_id from tiledata
			mvi b, >room_tiledata
			mvi a, TILEDATA_RESTORE_TILE
			stax b
			
			; c - tile_idx
			call draw_tile_16x16_buffs
			; draw vfx
			; bc - tile screen addr
			lxi d, vfx_puff
			call vfx_init
			jmp game_ui_draw_res

; in:
; a - trigger_id
; c - tile_idx
sword_func_triggers:
			push psw
			mov e, a
			mvi a, TILEDATA_FUNC_ID_TRIGGERS
			CALL_RAM_DISK_FUNC(__game_score_add, __RAM_DISK_S_SCORE)
			pop psw
			cpi TIMEDATA_TRIGGER_HOME_DOOR
			jz trigger_hero_knocks_his_home_door
			cpi TIMEDATA_TRIGGER_FRIEND_DOOR
			jz trigger_hero_knocks_his_friend_door
			cpi TIMEDATA_TRIGGER_DUNGEON_ENTRANCE
			jz trigger_hero_knocks_dungeon_entrance
			ret