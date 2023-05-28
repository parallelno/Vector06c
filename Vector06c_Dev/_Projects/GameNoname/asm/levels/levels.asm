;================================================================
;	initialization levels data every game start
;
levels_init:
			mvi a, 1
			sta level_idx

			; erase global item statuses
			lxi h, global_items
			mvi a, <global_items_end
			call clear_mem_short
			ret

;================================================================
;	initialization level data every level start
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

			; erase resources
			lxi h, hero_resources
			mvi a, <hero_resources_end
			call clear_mem_short

			; erase backs
			lxi h, backs_runtime_data
			mvi a, <backs_runtime_data_end
			call clear_mem_short

			; erase bullets
			lxi h, bullet_runtime_data_sorted
			mvi a, <bullets_runtime_data_end
			call clear_mem_short

			; erase monsters
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

			; setup a hero pos
@start_pos_ptr:			
			lhld level_start_pos_ptr
			xchg
			lda level_ram_disk_s_data
			call get_word_from_ram_disk
			call hero_set_pos
			call hero_init

			; reset level command
			mvi a, LEVEL_COMMAND_NONE
			sta level_command
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
			lda level_command
			ora a
			rz
			cpi LEVEL_COMMAND_LOAD_DRAW_ROOM
			;jnz @next_command_check
			rnz

			; load a new room
			call room_init
			call hero_init
			xra a
			sta	requested_updates
			; reset the command
			sta level_command
			ret
;@next_command_check:
;            ret
