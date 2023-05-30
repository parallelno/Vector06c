;.include "asm\\main_menu_consts.asm"

main_menu:

			; clear the screen	
			xra a
			lxi b, 0
			lxi d, SCR_BUFF_LEN * 4 / 32 - 1
			call clear_mem_sp

			mvi a, 1
			sta border_color_idx			

			call title_draw
			call main_menu_ui_draw

			xra a
			sta requested_updates

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
			;call hero_update
			;call monsters_update
			;call bullets_update
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
			;call bullets_draw

			;call hero_copy_to_scr
			;call monsters_copy_to_scr
			;call bullets_copy_to_scr

			;call hero_erase
			;call monsters_erase
			;call bullets_erase
			ret

main_menu_ui_draw:
			lxi d, __tiled_images_palette
			mvi h, <__RAM_DISK_S_TILED_IMAGES_GFX
			call copy_palette_request_update
			
			DRAW_TILED_IMG(__RAM_DISK_S_TILED_IMAGES_GFX, __RAM_DISK_S_TILED_IMAGES_DATA, __tiled_images_frame_main_menu, __TILED_IMAGES_FRAME_MAIN_MENU_COPY_LEN, __tiled_images_tile1)
			
			; draw mane menu settings
			@setting_pos = $6083
			@setting_vert_spacing = 18
			lxi b, @setting_pos - @setting_vert_spacing * 0
			lxi h, @text_start_game
			CALL_RAM_DISK_FUNC(draw_text_ex, __RAM_DISK_S_FONT)			
			lxi b, @setting_pos - @setting_vert_spacing * 1
			lxi h, @text_options
			CALL_RAM_DISK_FUNC(draw_text_ex, __RAM_DISK_S_FONT)	
			lxi b, @setting_pos - @setting_vert_spacing * 2
			lxi h, @text_help
			CALL_RAM_DISK_FUNC(draw_text_ex, __RAM_DISK_S_FONT)	
			lxi b, @setting_pos - @setting_vert_spacing * 3
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


