;================================================================
;	initialization levels data every game start
;
levels_init:
			xra a
			sta level_idx
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
			lxi b, rooms_runtime_data_end_addr
			lxi d, ROOM_RUNTIME_DATA_LEN * ROOMS_MAX / 32 - 1
			CLEAR_MEM_SP(true)

			xra a
			sta room_idx

			lxi d, __level01_startPos
			mvi a, <__RAM_DISK_S_LEVEL01_DATA
			call get_word_from_ram_disk
			call hero_set_pos
			call hero_init
			ret
			.closelabels

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
