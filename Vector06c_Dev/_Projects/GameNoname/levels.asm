;================================================================
;	initialization levels data every game start
;
LevelsInit:
			xra a
			sta levelIdx
			ret

;================================================================
;	initialization level data every game start
;
LevelInit:
			lxi d, __level01_palette_sprites_tiles_lv01
            mvi a, <__RAM_DISK_BANK_ACTIVATION_CMD_LEVEL01
			call SetPaletteFromRamDisk
			mvi a, 1
			sta borderColorIdx
			xra a
			sta roomIdx

			lxi d, __level01_startPos
			mvi a, <__RAM_DISK_BANK_ACTIVATION_CMD_LEVEL01
			call GetWordFromRamDisk
			call HeroSetPos
			call HeroInit
			ret
			.closelabels

LevelUpdate:
			lda levelCommand
			ora a
			rz
			cpi LEVEL_COMMAND_LOAD_DRAW_ROOM
			jnz @nextCommandCheck
			; load a new room
			call RoomInit
			call RoomDraw

			call HeroInit
			xra a
			lda	updateRequestCounter
			; reset the command
			xra a
			sta levelCommand
			ret
@nextCommandCheck:
            ret
