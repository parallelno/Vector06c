;================================================================
;	levels data initialization every game start
;
levels_init:
			; TODO: set the level_idx to 0
			mvi a, 1
			sta level_idx

			lxi h, 0
			shld game_score

			; erase global item statuses
			lxi h, global_items
			mvi a, <global_items_end
			call clear_mem_short
			ret

;================================================================
;	level data initialization every level start
;
level_init:
			; get the level init data ptr of the current level
			lda level_idx
			rlc
			mov e, a
			mvi d, 0
			lxi h, levels_init_tbls_ptrs
			dad d
			mov e, m
			inx h
			mov d, m
			xchg

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

			; erase bullets buffs
			lxi h, bullet_runtime_data_sorted
			mvi a, <bullets_runtime_data_end
			call clear_mem_short

			; erase monsters buffs
			lxi h, monster_runtime_data_sorted
			lxi b, monsters_runtime_data_end - monster_runtime_data_sorted
			call clear_mem

			; setup room resources
			lhld level_resources_inst_data_pptr
			xchg
			lxi h, level_ram_disk_s_data
			mov h, m
			mvi l, RESOURCES_LEN / 2
			lxi b, resources_inst_data_ptrs
			call copy_from_ram_disk

			; setup room containers
			lhld level_containers_inst_data_pptr
			xchg
			lxi h, level_ram_disk_s_data
			mov h, m
			mvi l, CONTAINERS_LEN / 2
			lxi b, containers_inst_data_ptrs
			call copy_from_ram_disk

			; reset room_id
			xra a
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
			xra a
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
			jz @load_draw_room
			cpi GAME_REQ_LEVEL_INIT
			jz @load_level
			ret
@load_draw_room:
			; load a new room
			call room_init
			call hero_init
			; reset level command
			xra a
			sta global_request
			xra a
			sta	requested_updates
			ret
@load_level:
			jmp level_init
