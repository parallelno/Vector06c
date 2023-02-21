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
; source\levels\art\sprites_tiles_lv01.png
level01_palette_sprites_tiles:
			.byte %01001010, %00000001, %01011100, %00011010, 
			.byte %11100100, %11111101, %01110111, %01011111, 
			.byte %01000010, %01001011, %01001100, %11111111, 
			.byte %11111111, %11101011, %01010010, %01011011, 

level_init:
			lxi d, level01_palette_sprites_tiles
			; remove the next line because we do not use ram-disk
            ;mvi a, <__RAM_DISK_S_LEVEL01
			xra a
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
			mvi a, <__RAM_DISK_S_LEVEL01
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
			call room_draw
			call hero_init
			xra a
			lda	update_request_counter
			; reset the command
			xra a
			sta level_command
			ret
@nextCommandCheck:
            ret
