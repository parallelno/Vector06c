MAIN_MENU_CURSOR_POS_X = $5800 ; .word
MAIN_MENU_CURSOR_POS_Y = $8100 ; .word

SETTING_POS = $6083
SETTING_VERT_SPACING = 18

MAIN_MENU_OPTIONS_MAX = 4

cursor_option_id:
			.byte 0

main_menu:
			; clear the screen	
			xra a
			lxi b, 0
			lxi d, SCR_BUFF_LEN * 4 / 32 - 1
			call clear_mem_sp
			; clear the backbuffer2
			mvi a, __RAM_DISK_S_BACKBUFF
			lxi b, 0
			lxi d, SCR_BUFF_LEN * 3 / 32 - 1
			call clear_mem_sp

			mvi a, 1
			sta border_color_idx

			call title_draw
			call main_menu_ui_draw

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

			call main_menu_cursor_init

			xra a
			sta requested_updates

			; reset key data
			lxi h, KEY_NO << 8 | KEY_NO
			shld key_code
			shld key_code_old

@loop:
			; TODO: make it play a new song
			CALL_RAM_DISK_FUNC(__gcplayer_start_repeat, __RAM_DISK_S_GCPLAYER | __RAM_DISK_M_GCPLAYER | RAM_DISK_M_8F)
			call main_menu_update
			call main_menu_draw
			jmp	 @loop

main_menu_update:
			lxi h, game_update_counter
			inr m

			; check if an interuption happened
			lda requested_updates
			ora a
			rz
@loop:
			call main_menu_cursor_update
			;call monsters_update
			call bullets_update
			;call level_update
			;call backs_update
			;call game_ui_update

			; to check repeated key-pressing
			lhld key_code
			shld key_code_old

			lxi h, requested_updates
			dcr m
			jnz @loop
			ret

main_menu_draw:
			; update counter to calc fps
			lhld game_draws_counter
			inx h
			shld game_draws_counter
			
			; draw funcs
			;call backs_draw

			;call hero_draw
			;call monsters_draw
			call bullets_draw

			;call hero_copy_to_scr
			;call monsters_copy_to_scr
			call bullets_copy_to_scr

			;call hero_erase
			;call monsters_erase
			call bullets_erase
			ret

main_menu_ui_draw:
			lxi d, __tiled_images_palette
			mvi h, <__RAM_DISK_S_TILED_IMAGES_GFX
			call copy_palette_request_update
			
			DRAW_TILED_IMG(__RAM_DISK_S_TILED_IMAGES_GFX, __RAM_DISK_S_TILED_IMAGES_DATA, __tiled_images_frame_main_menu, __TILED_IMAGES_FRAME_MAIN_MENU_COPY_LEN, __tiled_images_tile1)
			
			; draw mane menu settings
			lxi b, SETTING_POS - SETTING_VERT_SPACING * 0
			lxi h, @text_start_game
			CALL_RAM_DISK_FUNC(draw_text_ex, __RAM_DISK_S_FONT)			
			lxi b, SETTING_POS - SETTING_VERT_SPACING * 1
			lxi h, @text_options
			CALL_RAM_DISK_FUNC(draw_text_ex, __RAM_DISK_S_FONT)	
			lxi b, SETTING_POS - SETTING_VERT_SPACING * 2
			lxi h, @text_help
			CALL_RAM_DISK_FUNC(draw_text_ex, __RAM_DISK_S_FONT)	
			lxi b, SETTING_POS - SETTING_VERT_SPACING * 3
			lxi h, @text_credits
			CALL_RAM_DISK_FUNC(draw_text_ex, __RAM_DISK_S_FONT)									
			
			@licensing_pos = $1420
			@licensing_vert_spacing = 12
			; draw licensing
			lxi b, @licensing_pos + @licensing_vert_spacing
			lxi h, @text_license1
			CALL_RAM_DISK_FUNC(draw_text_ex, __RAM_DISK_S_FONT)						
			lxi b, @licensing_pos
			lxi h, @text_license2
			CALL_RAM_DISK_FUNC(draw_text_ex, __RAM_DISK_S_FONT)			
			ret
@text_start_game:
			TEXT("START GAME")
@text_options:
			TEXT("OPTIONS")
@text_help:
			TEXT("HELP")
@text_credits:
			TEXT("CREDITS")	
@text_license1:
			TEXT("2023. Developed by")
@text_license2:			
			TEXT("Alex, Fenia, Ilia, and Petr Fedotovskikh")

title_draw:
			; title1
			DRAW_TILED_IMG(__RAM_DISK_S_TILED_IMAGES_GFX, __RAM_DISK_S_TILED_IMAGES_DATA, __tiled_images_title1, __TILED_IMAGES_TITLE1_COPY_LEN, __tiled_images_tile1)
			; title2
			DRAW_TILED_IMG(__RAM_DISK_S_TILED_IMAGES_GFX, __RAM_DISK_S_TILED_IMAGES_DATA, __tiled_images_title2, __TILED_IMAGES_TITLE2_COPY_LEN, __tiled_images_tile1)
			; back1
			DRAW_TILED_IMG(__RAM_DISK_S_TILED_IMAGES_GFX, __RAM_DISK_S_TILED_IMAGES_DATA, __tiled_images_main_menu_back1, __TILED_IMAGES_MAIN_MENU_BACK1_COPY_LEN, __tiled_images_tile1)
			; back2
			DRAW_TILED_IMG(__RAM_DISK_S_TILED_IMAGES_GFX, __RAM_DISK_S_TILED_IMAGES_DATA, __tiled_images_main_menu_back2, __TILED_IMAGES_MAIN_MENU_BACK2_COPY_LEN, __tiled_images_tile1)			
			ret

main_menu_cursor_update:
			; check keys
			; check if an attack key pressed
			lhld key_code
			mvi a, KEY_SPACE
			cmp h
			;jz hero_attack_start

			; check if no arrow key pressed
			mvi a, KEY_UP & KEY_DOWN
			ora l
			inr a
			rz
@cursor_pos_update:
			; check if the same arrow keys pressed the prev update
			lda key_code_old
			cmp l
			jnz @new_key_pressed
			ret
@new_key_pressed:
			mov a, l
			cpi KEY_DOWN
			jz @cursor_move_down
			cpi KEY_UP
			jz @cursor_move_up
			ret
@cursor_move_up:
			; check if a selected option is outside ofthe range [0 - MAIN_MENU_OPTIONS_MAX]
			lda cursor_option_id
			dcr a
			rm ; return if a selected option = -1
			sta cursor_option_id

			lxi h, hero_pos_y+1
			mov a, m
			adi SETTING_VERT_SPACING
			mov m, a
			ret
@cursor_move_down:		
			; check if a selected option is outside ofthe range [0 - MAIN_MENU_OPTIONS_MAX]
			lda cursor_option_id
			inr a
			cpi MAIN_MENU_OPTIONS_MAX
			rnc ; return if a selected option >= MAIN_MENU_OPTIONS_MAX
			sta cursor_option_id

			lxi h, hero_pos_y+1
			mov a, m
			sui SETTING_VERT_SPACING
			mov m, a
			ret

main_menu_cursor_init:
			; create a cursor actor
			lxi h, MAIN_MENU_CURSOR_POS_X
			shld hero_pos_x
			lxi h, MAIN_MENU_CURSOR_POS_Y
			shld hero_pos_y

			; reset selected option
			xra a
			sta cursor_option_id

			lxi b, (>MAIN_MENU_CURSOR_POS_X)<<8 | >MAIN_MENU_CURSOR_POS_Y
			jmp cursor_init