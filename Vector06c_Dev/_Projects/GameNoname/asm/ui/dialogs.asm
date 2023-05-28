.macro DIALOG_INIT_CALL(callbacks_tbl)
			lxi h, callbacks_tbl
			call dialog_init
.endmacro
.macro DIALOG_INIT_JMP(callbacks_tbl)
			lxi h, callbacks_tbl
			jmp dialog_init
.endmacro
; init every dialog
; in:
; hl - callback_tbl addr (callback pptr)
dialog_init:
			shld dialog_update + 1
			; disable hero updates
			mvi a, ACTOR_STATUS_NO_UPDATE
			sta hero_status
			ret

; invoke a dialog callback func
; if the callback pptr == NULL_PTR, return
dialog_update:
@callback_pptr:
			lhld dialog_update_no_updates
			; hl - a callback ptr
			; if hl == NULL_PTR, return
			mov a, l
			ora h
			rz
			xchg
			; de - a callback ptr
			; increment callback pptr
			lhld @callback_pptr + 1
			INX_H(2)
			shld @callback_pptr + 1
			; jmp to a callback
			xchg
			pchl

@dialog_update_stay_in_current_step:
			; decr callback pptr
			lhld @callback_pptr + 1
			DCX_H(2)
			shld @callback_pptr + 1
			ret
dialog_update_stay_in_current_step = @dialog_update_stay_in_current_step

dialog_update_no_updates:
			.word NULL_PTR

;===========================================================================
; dialog when the hero looses all the health
dialog_init_hero_no_health:
			.word @draw_frame, @draw_text1, @draw_text2, @draw_text3, @draw_text4, @check_key, 0

@draw_frame:
			DRAW_TILED_IMG(__RAM_DISK_S_TILED_IMAGES_GFX, __RAM_DISK_S_TILED_IMAGES_DATA, __tiled_images_frame_ingame_dialog, __TILED_IMAGES_FRAME_INGAME_DIALOG_COPY_LEN, __tiled_images_tile1)
			; dialog_press_key (tiledata = 162)
			mvi b, 162
			@pos_tiles_x = 14
			@pos_tiles_y = 0
			mvi c, @pos_tiles_x + @pos_tiles_y * TILE_HEIGHT
			; b - tiledata
			; c - tile_idx in the room_tiledata array.			
			call backs_spawn
			ret
@draw_text1:		
			; draw text
			lxi b, $102d
			lxi h, @text1
			CALL_RAM_DISK_FUNC(draw_text_ex, __RAM_DISK_S_FONT)
			ret
@draw_text2:
			lxi b, $1021
			lxi h, @text2
			CALL_RAM_DISK_FUNC(draw_text_ex, __RAM_DISK_S_FONT)
			ret

@draw_text3:
			lxi b, $1015
			lxi h, @text3
			CALL_RAM_DISK_FUNC(draw_text_ex, __RAM_DISK_S_FONT)
			ret

@draw_text4:			
			lxi b, $1009
			lxi h, @text4
			CALL_RAM_DISK_FUNC(draw_text_ex, __RAM_DISK_S_FONT)
			ret
@check_key:
			; check if a space key pressed
			lhld key_code
			mvi a, KEY_SPACE
			cmp h
			jnz dialog_update_stay_in_current_step
			; it's pressed
			; load the level0
			; update a room_id to teleport there
			xra a
			sta room_id
			; requesting room loading
			mvi a, LEVEL_COMMAND_LOAD_DRAW_ROOM
			sta level_command
			ret

@text1:
.encoding "screencode", "mixed"
			.text "The cold and the darkness of corridors rev-"
			.byte 0
@text2:
.encoding "screencode", "mixed"
			.text "ealed a mysterious figure. Two strong hands"
			.byte 0
@text3:
.encoding "screencode", "mixed"
			.text "lifted up the unconscious body and carried"
			.byte 0
@text4:
.encoding "screencode", "mixed"
			.text "him out of the dungeon into the fresh air."
			.byte 0
