;================================================================
;	levels data initialization every game start
;
levels_init:
			mvi a, LEVEL_FIRST
			sta level_idx

			; erase global item statuses
			lxi h, global_items
			mvi a, <global_items_end
			jmp clear_mem_short

;================================================================
;	level data initialization every level start
;
level_init:
			; get the level init data ptr of the current level
			lda level_idx
			HL_TO_AX2_PLUS_INT16(levels_init_tbls_ptrs)

			mov e, m
			inx h
			mov d, m
			xchg
			; hl - source
			; copy a level init data
			lxi d, level_init_tbl
			lxi b, LEVEL_INIT_TBL_LEN
			call copy_mem 

			; copy a palette from the ram-disk, then request for using it
			call level_init_palette

			mvi a, 1
			sta border_color_idx

			; erase rooms spawn data
			lxi h, rooms_spawn_rates
			mvi a, <rooms_spawn_rates_end
			call clear_mem_short

			; erase resources buffs
			lxi h, hero_resources
			mvi a, <hero_resources_end
			call clear_mem_short

			; erase backs buffs
			lxi h, backs_runtime_data
			mvi a, <backs_runtime_data_end
			call clear_mem_short

; TODO: look up bullet_runtime_data_sorted
; it seems bullets_runtime_data and possible others like monster_runtime_data_sorted
; got creared twice. once here, and once in their init funcs
			; erase bullets buffs
			lxi h, bullet_runtime_data_sorted
			mvi a, <bullets_runtime_data_end
			call clear_mem_short

			; erase monsters buffs
			lxi h, monster_runtime_data_sorted
			lxi b, MONSTERS_RUNTIME_DATA_LEN
			call clear_mem

			; setup resources
			lhld level_resources_inst_data_pptr
			xchg
			lxi h, level_ram_disk_s_data
			mov h, m
			lxi b, resources_inst_data_ptrs
			COPY_FROM_RAM_DISK(RESOURCES_LEN)

			; setup containers
			lhld level_containers_inst_data_pptr
			xchg
			lxi h, level_ram_disk_s_data
			mov h, m
			lxi b, containers_inst_data_ptrs
			COPY_FROM_RAM_DISK(CONTAINERS_LEN)

			; reset room_id
			A_TO_ZERO(NULL_BYTE)
			sta room_id

			call room_init

			; setup a hero pos	
			lhld level_start_pos_ptr
			xchg
			lda level_ram_disk_s_data
			call get_word_from_ram_disk
			call hero_set_pos
			call hero_init

			call game_ui_draw

			; reset level command
			A_TO_ZERO(GLOBAL_REQ_NONE)
			sta global_request
			ret

; copy a palette from the ram-disk, then request for using it
level_init_palette:
			lhld level_palette_ptr
			xchg
			lxi h, level_ram_disk_s_gfx
			mov h, m
			call copy_palette_request_update
			ret

level_update:
			lda global_request
			ora a
			rz
			cpi GAME_REQ_ROOM_INIT
			jz @room_load_draw
			cpi GAME_REQ_LEVEL_INIT
			jz @level_load
			cpi GAME_REQ_ROOM_DRAW
			jz @room_draw
			ret
@room_load_draw:
			call hero_init
			; load a new room
			call room_init
			; reset level command
			A_TO_ZERO(GLOBAL_REQ_NONE)
			sta global_request
			call reset_game_updates_counter
			ret
@room_draw:
			call room_redraw
			A_TO_ZERO(GLOBAL_REQ_NONE)
			sta global_request
			call reset_game_updates_counter
			ret
@level_load:
			jmp level_init
