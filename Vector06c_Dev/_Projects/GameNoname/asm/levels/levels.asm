;================================================================
;	initialization levels data every game start
;
levels_init:
			xra a
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
			; TODO: make set_palette_from_ram_disk work via CALL_RAM_DISK_FUNC
			; TODO: set a proper palette depending on the level.
			lxi d, __level01_palette_sprites_tiles_lv01
            mvi a, <__RAM_DISK_S_LEVEL01_GFX
			call set_palette_from_ram_disk
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

			; setup room resources
			lxi h, __RAM_DISK_S_LEVEL01_DATA<<8 | (RESOURCES_LEN / 2)
			lxi d, __level01_resources_inst_data_ptrs
			lxi b, resources_inst_data_ptrs
			call copy_from_ram_disk

			; setup room containers
			lxi h, __RAM_DISK_S_LEVEL01_DATA<<8 | (CONTAINERS_LEN / 2)
			lxi d, __level01_containers_inst_data_ptrs
			lxi b, containers_inst_data_ptrs
			call copy_from_ram_disk			

			; reset room_id
			xra a
			sta room_id

			lxi d, __level01_startPos
			mvi a, <__RAM_DISK_S_LEVEL01_DATA
			call get_word_from_ram_disk
			call hero_set_pos
			call hero_init
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
			lda	update_request_counter
			; reset the command
			xra a
			sta level_command
			ret
;@next_command_check:
;            ret
