screen_space_checking:
			; return if non-space key was pressed
			lda action_code
			ani CONTROL_CODE_KEY_SPACE | CONTROL_CODE_FIRE1
			rz
			; set the global req to return to the main nemu
			mvi a, GLOBAL_REQ_MAIN_MENU
			sta global_request
			ret


screen_simple_init:
			; clear the screen	
			A_TO_ZERO(RAM_DISK_OFF_CMD)
			lxi b, 0
			lxi d, SCR_BUFF_LEN * 4 / 32 - 1
			call clear_mem_sp
			; clear the backbuffer2
			mvi a, __RAM_DISK_S_BACKBUFF
			lxi b, 0
			lxi d, SCR_BUFF_LEN * 3 / 32 - 1
			call clear_mem_sp

			mvi a, BORDER_COLOT_IDX
			sta border_color_idx

			; erase backs buffs
			lxi h, backs_runtime_data
			mvi a, <backs_runtime_data_end
			call clear_mem_short
			; setup backs runtime data
			call backs_init

			; erase bullets buffs
			lxi h, bullet_runtime_data_sorted
			mvi a, <bullets_runtime_data_end
			call clear_mem_short
			; setup bullets runtime data
			call bullets_init			

			; fill up the tile_data_buff with tiledata = 0
			; (walkable tile, no back restore , no decal)
			mvi c, 0
			call room_fill_tiledata

			; reset key data
			mvi a, CONTROL_CODE_NO
			sta action_code

			ret

screen_palette_and_frame:
			lxi d, __tiled_images_palette
			mvi h, <__RAM_DISK_S_TILED_IMAGES_GFX
			call copy_palette_request_update

			; back1
			DRAW_TILED_IMG(__RAM_DISK_S_TILED_IMAGES_DATA, __tiled_images_main_menu_back1)
			; back2
			DRAW_TILED_IMG(__RAM_DISK_S_TILED_IMAGES_DATA, __tiled_images_main_menu_back2)			
			ret			

; in:
; hl - a specific update func ptr
screen_simple_update:
			shld @spec_update_func + 1
			lxi h, game_update_counter
			inr m

@loop:
			CHECK_GAME_UPDATE_COUNTER(game_updates_counter)

@spec_update_func:
			call TEMP_ADDR
			call backs_update
			call bullets_update

			; to check repeated key-pressing
			lda action_code
			sta action_code_old

			jmp @loop

screen_simple_draw:
			; update counter to calc fps
			lhld game_draws_counter
			inx h
			shld game_draws_counter

			; draw funcs
			call backs_draw
			call bullets_draw
			call bullets_copy_to_scr
			call bullets_erase
			ret

; draw a space button as a back object
; draw a text referenced by __text_return label
screen_draw_return_text_button:
			; draw a text
			@text_return_pos = $5819
			lxi b, @text_return_pos
			lxi h, __text_return

; draw a space button as a back object
; and a custom text at the custom pos
; in:
; hl - screen_pos
; bc - text_addr

screen_draw_return_button_custom_text:
			CALL_RAM_DISK_FUNC(__text_ex_rd_scr1, __RAM_DISK_S_FONT | __RAM_DISK_M_TEXT_EX)

			; braw a button
			@pos_tiles_y = 1
			@pos_tiles_x = 13			
			mvi c, @pos_tiles_x + @pos_tiles_y * TILE_HEIGHT
			; dialog_press_key (tiledata = 162)
			mvi b, 162			
			; b - tiledata
			; c - tile_idx in the room_tiledata array.
			jmp backs_spawn