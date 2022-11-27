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
			lxi d, level01_palette_sprites_tiles_lv01
            mvi a, RAM_DISK_S0
			call SetPaletteFromRamDisk
			mvi a, 1
			sta borderColorIdx
			xra a
			sta roomIdx

			lxi d, level01_startPos
			mvi a, RAM_DISK_S0
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
