OPTIONS_CURSOR_POS_X = $3800 ; .word
OPTIONS_CURSOR_POS_Y_MAX = $9d00 ; .word

OPTIONS_TITLE_POS = $68d8

OPTIONS_POS = $40b8
OPTIONS_LINE_SPACING = 14
OPTIONS_PARAG_SPACING = 24

OPTIONS_SETTING_MAX = 2

option_cursor_setting_id:
			.byte 0

options_screen:
			sta @global_req+1
			call options_screen_init

@loop:
			; return when a user hits a space button
			lda global_request
@global_req:
			cpi TEMP_BYTE
			rnz

			; TODO: make it play a new song
			CALL_RAM_DISK_FUNC(__gcplayer_start_repeat, __RAM_DISK_S_GCPLAYER | __RAM_DISK_M_GCPLAYER | RAM_DISK_M_8F)

			lxi h, options_screen_cursor_update
			call screen_simple_update
			call screen_simple_draw
			jmp	@loop

options_screen_text_draw:
			lxi b, OPTIONS_TITLE_POS
			lxi h, @text_title
			CALL_RAM_DISK_FUNC(draw_text_ex, __RAM_DISK_S_FONT)

@text_pos_y		.var  OPTIONS_POS

			lxi b, @text_pos_y + $2800
			lxi h, @text_settings
			CALL_RAM_DISK_FUNC(draw_text_ex, __RAM_DISK_S_FONT)

			@text_pos_y = @text_pos_y - OPTIONS_PARAG_SPACING
			lxi b, @text_pos_y
			lxi h, @text_music
			CALL_RAM_DISK_FUNC(draw_text_ex, __RAM_DISK_S_FONT)

			lxi b, @text_pos_y + $2000
			lxi h, @text_dots + 4 ; skip several dot symdols
			CALL_RAM_DISK_FUNC(draw_text_ex, __RAM_DISK_S_FONT)

			@text_pos_y = @text_pos_y - OPTIONS_LINE_SPACING
			lxi b, @text_pos_y
			lxi h, @text_sfx
			CALL_RAM_DISK_FUNC(draw_text_ex, __RAM_DISK_S_FONT)

			lxi b, @text_pos_y + $1800
			lxi h, @text_dots
			CALL_RAM_DISK_FUNC(draw_text_ex, __RAM_DISK_S_FONT)

			@text_pos_y = @text_pos_y - OPTIONS_PARAG_SPACING
			lxi b, @text_pos_y + $2800
			lxi h, @text_controls
			CALL_RAM_DISK_FUNC(draw_text_ex, __RAM_DISK_S_FONT)

			@text_pos_y = @text_pos_y - OPTIONS_PARAG_SPACING
			lxi b, @text_pos_y
			mvi e, 5
@loop:
			push b
			push d
			lxi h, @text_keys
			CALL_RAM_DISK_FUNC(draw_text_ex, __RAM_DISK_S_FONT)
			pop d
			pop b

			LXI_H(-OPTIONS_LINE_SPACING)
			dad b
			mov b, h
			mov c, l

			dcr e
			jnz @loop
			ret

@text_title:
			TEXT("OPTIONS")			

@text_settings:
			TEXT("Settings:")
@text_music:
			TEXT("Music")
@text_sfx:
			TEXT("SFX")
@text_controls:
			TEXT("Controls:")
@text_keys:
			TEXT("UP")

@text_up:
			TEXT("UP")
@text_down:
			TEXT("DOWN")
@text_left:
			TEXT("LEFT")
@text_right:
			TEXT("RIGHT")
@text_fire:
			TEXT("FIRE")
	
@text_on:
			TEXT("ON")
@text_off:
			TEXT("OFF")
@text_dots:
			TEXT("........................................")

options_screen_init:
			call screen_simple_init
			call screen_palette_and_frame
			call options_screen_text_draw
			call option_screen_cursor_init
			; dialog_press_key (tiledata = 162)
			mvi b, 162
			@pos_tiles_x = 13
			@pos_tiles_y = 1
			mvi c, @pos_tiles_x + @pos_tiles_y * TILE_HEIGHT
			; b - tiledata
			; c - tile_idx in the room_tiledata array.
			call backs_spawn

			xra a
			sta requested_updates
			ret

option_screen_cursor_init:
@check_if_init:
			jmp @init
@init:
			lxi h, @no_init
			shld @check_if_init + 1

			; reset selected option
			xra a
			sta option_cursor_setting_id

@no_init:
			lxi h, option_cursor_setting_id
			call options_cursor_pos_update
			jmp cursor_init

; converts option_cursor_setting_id into a cursor pos
; hl - ptr to option_cursor_setting_id
; out:
; bc - cursor_pos_xy
; (hero_pos_x + 1) = cursor_pos_x
; (hero_pos_y + 1) = cursor_pos_y
options_cursor_pos_update:
			mov b, m
			mvi a, >OPTIONS_CURSOR_POS_Y_MAX
			; b - option_cursor_setting_id
			; a - pos_y_max
			; calc the cursor pos_y
			
@loop:		dcr b
			jm @stop
			sui OPTIONS_LINE_SPACING
			jmp @loop
@stop:
			mov c, a
			mvi b, >OPTIONS_CURSOR_POS_X

			; spawn a cursor
			; bc - a cursor pos
			lxi h, hero_pos_x + 1
			mov m, b			
			lxi h, hero_pos_y + 1
			mov m, c
			ret

options_screen_cursor_update:
			; spawn vfx
			call random
			sui main_scr_vfx_spawn_rate
			cc @spawn_vfx

			; check keys
			; check if the space key pressed
			lhld key_code
			mvi a, KEY_SPACE
			cmp h
			jz @go_to_option

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
			lxi h, option_cursor_setting_id
			mov a, m
			dcr a
			rm ; return if a selected option = -1
			mov m, a
			; a - option_cursor_setting_id			
			; hl - ptr to option_cursor_setting_id
			call options_cursor_pos_update
			ret
@cursor_move_down:
			; check if a selected option is outside ofthe range [0 - MAIN_MENU_OPTIONS_MAX]
			lxi h, option_cursor_setting_id
			mov a, m
			inr a
			cpi MAIN_MENU_OPTIONS_MAX
			rnc ; return if a selected option >= MAIN_MENU_OPTIONS_MAX
			mov m, a
			; a - option_cursor_setting_id
			; hl - ptr to option_cursor_setting_id
			call options_cursor_pos_update
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
@go_to_option:
			lda option_cursor_setting_id
			adi GLOBAL_REQ_GAME
			sta global_request
			ret