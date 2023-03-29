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
			lxi d, __level01_palette_sprites_tiles_lv01
            mvi a, <__RAM_DISK_S_LEVEL01_GFX
			call set_palette_from_ram_disk
			mvi a, 1
			sta border_color_idx

			; erase rooms runtime data
			lxi h, rooms_spawn_rates
			mvi a, <rooms_spawn_rates_end
			call clear_mem_short

			; erase room resources
			lxi h, rooms_resources
			mvi a, <rooms_resources_end
			mvi c, <ITEM_STATUS_NOT_ACQUIRED
			call fill_mem_short

			xra a
			sta room_idx

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
			jnz @nextCommandCheck			
			; load a new room
			call room_init
			call hero_init
			xra a
			lda	update_request_counter
			; reset the command
			xra a
			sta level_command
			ret
@nextCommandCheck:
            ret
