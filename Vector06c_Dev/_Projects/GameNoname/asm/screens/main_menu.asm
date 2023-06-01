MAIN_MENU_CURSOR_POS_X		= $5800 ; .word
MAIN_MENU_CURSOR_POS_Y_MAX	= $8100 ; .word

SETTING_POS = $6083
SETTING_VERT_SPACING = 18

MAIN_MENU_OPTIONS_MAX = 4

main_menu_cursor_option_id:
			.byte 0


; the area in between min-max is used to spawn bacground vfx
main_scr_vfx_pos_max1 = $8690
main_scr_vfx_pos_min1 = $8230

main_scr_vfx_pos_max2 = $9c90
main_scr_vfx_pos_min2 = $9730

main_scr_vfx_pos_max3 = $84e0
main_scr_vfx_pos_min3 = $82b0

main_scr_vfx_pos_max4 = $9ce0
main_scr_vfx_pos_min4 = $9ba0

main_scr_vfx_spawn_rate = 10 ;(0 - no spawn, 255 - spawn every update)

main_menu:
			sta @global_req+1
			call main_menu_init

@loop:
			; return when a user hits any option in the main menu
			lda global_request
@global_req:
			cpi TEMP_BYTE
			rnz

			; TODO: make it play a new song
			CALL_RAM_DISK_FUNC(__gcplayer_start_repeat, __RAM_DISK_S_GCPLAYER | __RAM_DISK_M_GCPLAYER | RAM_DISK_M_8F)

			lxi h, main_menu_cursor_update
			call screen_simple_update
			call screen_simple_draw
			jmp	 @loop
			
main_menu_back_draw:
			call screen_palette_and_frame
			; title1
			DRAW_TILED_IMG(__RAM_DISK_S_TILED_IMAGES_GFX, __RAM_DISK_S_TILED_IMAGES_DATA, __tiled_images_title1, __TILED_IMAGES_TITLE1_COPY_LEN, __tiled_images_tile1)
			; title2
			DRAW_TILED_IMG(__RAM_DISK_S_TILED_IMAGES_GFX, __RAM_DISK_S_TILED_IMAGES_DATA, __tiled_images_title2, __TILED_IMAGES_TITLE2_COPY_LEN, __tiled_images_tile1)
			; settings frame
			DRAW_TILED_IMG(__RAM_DISK_S_TILED_IMAGES_GFX, __RAM_DISK_S_TILED_IMAGES_DATA, __tiled_images_frame_main_menu, __TILED_IMAGES_FRAME_MAIN_MENU_COPY_LEN, __tiled_images_tile1)

			; draw main menu settings
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

			@licensing_pos = $1a20
			@licensing_vert_spacing = 12
			; draw licensing
			lxi b, @licensing_pos
			lxi h, @text_license
			CALL_RAM_DISK_FUNC(draw_text_ex, __RAM_DISK_S_FONT)
			ret
@text_start_game:
			TEXT("START GAME")
@text_options:
			TEXT("OPTIONS")
@text_help:
			TEXT("SCORES")
@text_credits:
			TEXT("CREDITS")
@text_license:
			TEXT("2023. Developed by Fedotovskikh family")

main_menu_cursor_update:
			; spawn vfx
			call random
			sui main_scr_vfx_spawn_rate
			cc @spawn_vfx

			; check keys
			; check if the space key pressed
			lhld key_code
			mvi a, KEY_SPACE
			cmp h
			jz @space_handling

			; return if no arrow key pressed
			mvi a, KEY_UP & KEY_DOWN
			ora l
			inr a
			rz

			; return if the same arrow keys was pressed last update
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
			lda main_menu_cursor_option_id
			dcr a
			rm ; return if a selected option = -1
			sta main_menu_cursor_option_id

			lxi h, hero_pos_y+1
			mov a, m
			adi SETTING_VERT_SPACING
			mov m, a
			ret
@cursor_move_down:
			; check if a selected option is outside ofthe range [0 - MAIN_MENU_OPTIONS_MAX]
			lda main_menu_cursor_option_id
			inr a
			cpi MAIN_MENU_OPTIONS_MAX
			rnc ; return if a selected option >= MAIN_MENU_OPTIONS_MAX
			sta main_menu_cursor_option_id

			lxi h, hero_pos_y+1
			mov a, m
			sui SETTING_VERT_SPACING
			mov m, a
			ret
@spawn_vfx:
			; randomly chose an area to play vfx
			call random

			ani %11
			jz @bottom_l
			cpi 1
			jz @bottom_r
			cpi 2
			jz @top_l
@top_r:
			; bc - vfx scr addr
			lxi b, main_scr_vfx_pos_min4
			; add random to the scr_x
			mvi a, %0000_0011
			ana l
			add b
			CLAMP_A(>main_scr_vfx_pos_max4)
			mov b, a
			; add random to the scr_y
			mvi a, %0011_1111
			ana h
			add c
			CLAMP_A(<main_scr_vfx_pos_max4)
			mov c, a
			jmp @vfx_init
@top_l:
			; bc - vfx scr addr
			lxi b, main_scr_vfx_pos_min3
			; add random to the scr_x
			mvi a, %0000_0011
			ana l
			add b
			CLAMP_A(>main_scr_vfx_pos_max3)
			mov b, a
			; add random to the scr_y
			mvi a, %0011_1111
			ana h
			add c
			CLAMP_A(<main_scr_vfx_pos_max3)
			mov c, a
			jmp @vfx_init
@bottom_r:
			; bc - vfx scr addr
			lxi b, main_scr_vfx_pos_min2
			; add random to the scr_x
			mvi a, %0000_0111
			ana l
			add b
			CLAMP_A(>main_scr_vfx_pos_max2)
			mov b, a
			; add random to the scr_y
			mvi a, %0111_1111
			ana h
			add c
			CLAMP_A(<main_scr_vfx_pos_max2)
			mov c, a
			jmp @vfx_init
@bottom_l:
			; bc - vfx scr addr
			lxi b, main_scr_vfx_pos_min1
			; add random to the scr_x
			mvi a, %0000_0111
			ana l
			add b
			CLAMP_A(>main_scr_vfx_pos_max1)
			mov b, a
			; add random to the scr_y
			mvi a, %0111_1111
			ana h
			add c
			CLAMP_A(<main_scr_vfx_pos_max1)
			mov c, a
			jmp @vfx_init

@vfx_init:
			lxi d, vfx_reward
			jmp vfx_init
@space_handling:
			lda main_menu_cursor_option_id
			adi GLOBAL_REQ_GAME
			sta global_request
			ret

main_menu_cursor_init:
			xra a
@check_if_init:
			jmp @init
@init:
			lxi h, @no_init
			shld @check_if_init + 1

			; create a cursor actor
			lxi h, MAIN_MENU_CURSOR_POS_X
			shld hero_pos_x
			lxi h, MAIN_MENU_CURSOR_POS_Y_MAX
			shld hero_pos_y

			; reset selected option
			; a = 0
			sta main_menu_cursor_option_id

@no_init:
			; a = 0
			lxi h, main_menu_cursor_option_id
			mov b, m
			mvi a, >MAIN_MENU_CURSOR_POS_Y_MAX
			; b - main_menu_cursor_option_id
			; a - pos_y_max
			; calc the cursor pos_y
			
@loop:		dcr b
			jm @stop
			sui SETTING_VERT_SPACING
			jmp @loop
@stop:
			mov c, a
			mvi b, >MAIN_MENU_CURSOR_POS_X

			; spawn a cursor
			; bc - a cursor pos
			lxi h, hero_pos_y + 1
			mov m, c
			jmp cursor_init

main_menu_init:
			call screen_simple_init
			call main_menu_back_draw
			call main_menu_cursor_init

			; dialog_press_key (tiledata = 162)
			mvi b, 162
			@pos_tiles_x = 9
			@pos_tiles_y = 4
			mvi c, @pos_tiles_x + @pos_tiles_y * TILE_HEIGHT
			; b - tiledata
			; c - tile_idx in the room_tiledata array.
			call backs_spawn

			call reset_game_updates_counter
			ret