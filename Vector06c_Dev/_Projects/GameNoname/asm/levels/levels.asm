;================================================================
;	initialization levels data every game start
;
levels_init:
			xra a
			sta level_idx

			; erase global item statuses
			lxi h, global_items
			lxi b, global_items_end - global_items
			call clear_mem	
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
			lxi h, rooms_runtime_data
			lxi b, ROOMS_RUNTIME_DATA_LEN
			call clear_mem

			; erase room resources
			lxi h, rooms_resources
			lxi b, ROOMS_RESOURCES_LEN
			call clear_mem

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
