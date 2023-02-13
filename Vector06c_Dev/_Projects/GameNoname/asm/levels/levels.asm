;================================================================
;	initialization levels data every game start
;
levels_init:
			xra a
			sta level_idx
			ret

;================================================================
;	initialization level data every game start
;
level_init:
			lxi d, __level01_palette_sprites_tiles_lv01
            mvi a, <__RAM_DISK_S_LEVEL01
			call SetPaletteFromRamDisk
			mvi a, 1
			sta borderColorIdx
			xra a
			sta room_idx

			lxi d, __level01_startPos
			mvi a, <__RAM_DISK_S_LEVEL01
			call get_word_from_ram_disk
			call hero_set_pos
			call HeroInit
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

			call HeroInit
			xra a
			lda	update_request_counter
			; reset the command
			xra a
			sta level_command
			ret
@nextCommandCheck:
            ret
