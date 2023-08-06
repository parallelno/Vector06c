DIALOG_EMPTY_CALLBACK_PTR:
			.word DIALOG_EMPTY_CALLBACK

DIALOG_EMPTY_CALLBACK:
			ret

; init dialog
; in:
; hl - callback_tbl addr (callback pptr)
.macro DIALOG_INIT(dialog_callbacks_ptr)
			lxi h, dialog_callbacks_ptr
			shld dialog_update + 1
.endmacro

; invoke a dialog callback func
; if the callback pptr == NULL_PTR, return
dialog_update:
			lhld DIALOG_EMPTY_CALLBACK_PTR
			pchl

; should be called when a dialog step should be go the the next step
dialog_update_next_step:
			lhld dialog_update + 1
			INX_H(2)
			shld dialog_update + 1
			ret

dialog_draw_frame:
			DRAW_TILED_IMG(__RAM_DISK_S_TILED_IMAGES_GFX, __RAM_DISK_S_TILED_IMAGES_DATA, __tiled_images_frame_ingame_dialog, __TILED_IMAGES_FRAME_INGAME_DIALOG_COPY_LEN, __tiled_images_tile1)
			; draw an animated spacebar
			; dialog_press_key (tiledata = 162)
			mvi b, 162
			@pos_tiles_x = 14
			@pos_tiles_y = 0
			mvi c, @pos_tiles_x + @pos_tiles_y * TILE_HEIGHT
			; b - tiledata
			; c - tile_idx in the room_tiledata array.			
			jmp backs_spawn

; draw a text on the SCR_BUFF3
; use macro DIALOG_DRAW_TEXT to call this func
dialog_draw_text:
			CALL_RAM_DISK_FUNC(__text_ex_rd_reset_spacing, __RAM_DISK_S_FONT | __RAM_DISK_M_TEXT_EX)
			; draw text
			lxi b, $102d
dialog_draw_text_ptr:
			lxi h, TEMP_ADDR
			CALL_RAM_DISK_FUNC(__text_ex_rd_scr3, __RAM_DISK_S_FONT | __RAM_DISK_M_TEXT_EX)
			ret
.macro DIALOG_DRAW_TEXT(text_ptr)
			lxi h, text_ptr
			shld dialog_draw_text_ptr + 1
			call dialog_draw_text
.endmacro

;===========================================================================
; dialog when the hero looses all the health
dialog_init_hero_no_health:
			.word @init, @draw_text, @check_key, DIALOG_EMPTY_CALLBACK

@init:		
			; disable hero updates
			mvi a, ACTOR_STATUS_NO_UPDATE
			sta hero_status
			call dialog_draw_frame
			jmp dialog_update_next_step

@draw_text:	
			DIALOG_DRAW_TEXT(__text_no_health)
			jmp dialog_update_next_step
			 
@check_key:
			; check if a fire action is pressed
			lda action_code
			ani CONTROL_CODE_FIRE1 | CONTROL_CODE_KEY_SPACE
			rz
			; it's pressed
			; requesting a level loading
			A_TO_ZERO(LEVEL_FIRST)
			sta level_idx
			mvi a, GAME_REQ_LEVEL_INIT
			sta global_request
			; restore a hero health
			mvi a, HERO_HEALTH_MAX
			sta hero_health
			jmp dialog_update_next_step

;===========================================================================
; dialog when a hero picks up the global item called TILEDATA_ITEM_STORYTELLING
; it pauses everything except backs and ui, it erases backs
; when this dialog closes, the game continues
dialog_init_storytelling:
			mvi a, GAME_REQ_PAUSE
			sta global_request
			
			; mark erased the runtime back data
			call backs_init

			; draw a dialog
			call dialog_draw_frame

			; get the text
			; draw text
			DIALOG_DRAW_TEXT(__text_game_story_intro)

			DIALOG_INIT(dialog_storytelling)
			ret

dialog_storytelling:
			.word @check_key, DIALOG_EMPTY_CALLBACK
			
@check_key:
			; check if a fire action is pressed
			lda action_code
			ani CONTROL_CODE_FIRE1 | CONTROL_CODE_KEY_SPACE
			rz
			; it's pressed
			; requesting a level loading
			mvi a, GAME_REQ_ROOM_INIT
			sta global_request
			;call room_init
			jmp dialog_update_next_step


