OPTIONS_CURSOR_POS_X		= $38
OPTIONS_CURSOR_POS_Y_MAX	= $c8	;$9a

OPTIONS_CURSOR_POS_Y_OFFSET1	= 24	; when it is in the controls section
OPTIONS_CURSOR_POS_Y_OFFSET2	= 35	; when it is in the return section

;OPTIONS_TITLE_POS = $68d8

OPTIONS_POS = $40d8; $40b8
OPTIONS_LINE_SPACING = -14
OPTIONS_PARAG_SPACING = -24

OPTIONS_ID_MUSIC	= 0
OPTIONS_ID_SFX		= 1
OPTIONS_ID_UP		= 2
OPTIONS_ID_DOWN		= 3
OPTIONS_ID_LEFT		= 4
OPTIONS_ID_RIGHT	= 5
OPTIONS_ID_FIRE		= 6
OPTIONS_ID_SELECT	= 7
OPTIONS_ID_RETURN	= 8

OPTIONS_MAX = 9
OPTIONS_SECTION1_LAST_ID = OPTIONS_ID_SFX
OPTIONS_SECTION2_LAST_ID = OPTIONS_ID_SELECT

OPTIONS_SETTING_VAL_POS_X = 170

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

			lxi h, options_screen_cursor_update
			call screen_simple_update
			call screen_simple_draw
			jmp	@loop

; erase and draw a music/sfx settings values
options_settings_val_draw:
			call options_setting_music_val_draw
			call options_setting_sfx_val_draw
			ret

options_setting_music_val_draw:
@text_pos_y		.var  OPTIONS_POS
			@text_pos_y = @text_pos_y + OPTIONS_LINE_SPACING

			; erase music setting value
			@scr_addr_x_offset = (OPTIONS_SETTING_VAL_POS_X/8)<<8
			lxi b, 2<<8 | 9
			lxi d, SCR_BUFF1_ADDR + <@text_pos_y | @scr_addr_x_offset
			call sprite_copy_to_scr_v
			; draw music setting value
			lxi h, __text_setting_on
			CALL_RAM_DISK_FUNC(__gcplayer_get_setting, __RAM_DISK_S_GCPLAYER | __RAM_DISK_M_GCPLAYER | RAM_DISK_M_8F)
			mvi a, SETTING_OFF
			cmp c
			jnz @music_on
			lxi h, __text_setting_off
@music_on:
			lxi b, <@text_pos_y | OPTIONS_SETTING_VAL_POS_X<<8
			CALL_RAM_DISK_FUNC(__draw_text_ex_rd_scr1, __RAM_DISK_S_FONT | __RAM_DISK_M_TEXT_EX)
			ret

options_setting_sfx_val_draw:
@text_pos_y		.var  OPTIONS_POS
			@text_pos_y = @text_pos_y + OPTIONS_LINE_SPACING

			@text_pos_y = @text_pos_y + OPTIONS_LINE_SPACING
			; erase sfx setting value
			@scr_addr_x_offset = (OPTIONS_SETTING_VAL_POS_X/8)<<8
			lxi b, 2<<8 | 9
			lxi d, SCR_BUFF1_ADDR + <@text_pos_y | @scr_addr_x_offset
			call sprite_copy_to_scr_v
			; draw sfx setting value
			lxi h, __text_setting_on
			CALL_RAM_DISK_FUNC(__sfx_get_setting, __RAM_DISK_M_SOUND | RAM_DISK_M_8F)
			mvi a, SETTING_OFF
			cmp c
			jnz @sfx_on
			lxi h, __text_setting_off
@sfx_on:
			lxi b, <@text_pos_y | OPTIONS_SETTING_VAL_POS_X<<8
			CALL_RAM_DISK_FUNC(__draw_text_ex_rd_scr1, __RAM_DISK_S_FONT | __RAM_DISK_M_TEXT_EX)
			ret

options_screen_text_draw:
			lxi b, (<OPTIONS_PARAG_SPACING)<<8 | <OPTIONS_LINE_SPACING
			CALL_RAM_DISK_FUNC(__draw_text_ex_rd_set_spacing, __RAM_DISK_S_FONT | __RAM_DISK_M_TEXT_EX)

@text_pos_y		.var  OPTIONS_POS
			; SETTINGS TITLE
			lxi b, @text_pos_y + $2800
			lxi h, __text_settings
			CALL_RAM_DISK_FUNC(__draw_text_ex_rd_scr1, __RAM_DISK_S_FONT | __RAM_DISK_M_TEXT_EX)
			; MUSIC
			; SFX
			@text_pos_y = @text_pos_y + OPTIONS_LINE_SPACING
			lxi b, @text_pos_y
			lxi h, __text_music_sfx
			CALL_RAM_DISK_FUNC(__draw_text_ex_rd_scr1, __RAM_DISK_S_FONT | __RAM_DISK_M_TEXT_EX)
			lxi b, @text_pos_y + $2000
			lxi h, __text_dots + 4 ; skip several dot symdols
			CALL_RAM_DISK_FUNC(__draw_text_ex_rd_scr1, __RAM_DISK_S_FONT | __RAM_DISK_M_TEXT_EX)
			@text_pos_y = @text_pos_y + OPTIONS_LINE_SPACING
			lxi b, @text_pos_y + $1800
			lxi h, __text_dots
			CALL_RAM_DISK_FUNC(__draw_text_ex_rd_scr1, __RAM_DISK_S_FONT | __RAM_DISK_M_TEXT_EX)

			call options_settings_val_draw

			; CONTROLS TITLE
			@text_pos_y = @text_pos_y + OPTIONS_PARAG_SPACING
			lxi b, @text_pos_y + $2800
			lxi h, __text_controls
			CALL_RAM_DISK_FUNC(__draw_text_ex_rd_scr1, __RAM_DISK_S_FONT | __RAM_DISK_M_TEXT_EX)

			; CONTROLS NAMES
			@text_pos_y = @text_pos_y + OPTIONS_LINE_SPACING
			lxi b, @text_pos_y
			lxi h, __text_keys
			CALL_RAM_DISK_FUNC(__draw_text_ex_rd_scr1, __RAM_DISK_S_FONT | __RAM_DISK_M_TEXT_EX)
			
			; DOTS
			; UP
			lxi b, @text_pos_y + $1800
			lxi h, __text_dots
			CALL_RAM_DISK_FUNC(__draw_text_ex_rd_scr1, __RAM_DISK_S_FONT | __RAM_DISK_M_TEXT_EX)
			; DOWN
			@text_pos_y = @text_pos_y + OPTIONS_LINE_SPACING
			lxi b, @text_pos_y + $2000
			lxi h, __text_dots + 4
			CALL_RAM_DISK_FUNC(__draw_text_ex_rd_scr1, __RAM_DISK_S_FONT | __RAM_DISK_M_TEXT_EX)			
			; LEFT
			@text_pos_y = @text_pos_y + OPTIONS_LINE_SPACING
			lxi b, @text_pos_y + $2000
			lxi h, __text_dots + 4
			CALL_RAM_DISK_FUNC(__draw_text_ex_rd_scr1, __RAM_DISK_S_FONT | __RAM_DISK_M_TEXT_EX)			
			; RIGHT
			@text_pos_y = @text_pos_y + OPTIONS_LINE_SPACING
			lxi b, @text_pos_y + $2000
			lxi h, __text_dots + 4
			CALL_RAM_DISK_FUNC(__draw_text_ex_rd_scr1, __RAM_DISK_S_FONT | __RAM_DISK_M_TEXT_EX)			
			; FIRE
			@text_pos_y = @text_pos_y + OPTIONS_LINE_SPACING
			lxi b, @text_pos_y + $1800
			lxi h, __text_dots
			CALL_RAM_DISK_FUNC(__draw_text_ex_rd_scr1, __RAM_DISK_S_FONT | __RAM_DISK_M_TEXT_EX)			
			; SELECT
			@text_pos_y = @text_pos_y + OPTIONS_LINE_SPACING
			lxi b, @text_pos_y + $2800
			lxi h, __text_dots + 8
			CALL_RAM_DISK_FUNC(__draw_text_ex_rd_scr1, __RAM_DISK_S_FONT | __RAM_DISK_M_TEXT_EX)												
			ret

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

			call reset_game_updates_counter
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
			; check if the cursor is in the controls section
			mvi a, OPTIONS_SECTION2_LAST_ID
			cmp b
			mvi a, OPTIONS_CURSOR_POS_Y_MAX
			jnc @no_offset2
			sui OPTIONS_CURSOR_POS_Y_OFFSET2
			jmp @no_offset1
@no_offset2:
			; check if the cursor is in the controls section
			mvi a, OPTIONS_SECTION1_LAST_ID
			cmp b
			mvi a, OPTIONS_CURSOR_POS_Y_MAX
			jnc @no_offset1
			sui OPTIONS_CURSOR_POS_Y_OFFSET1
@no_offset1:
			; b - option_cursor_setting_id
			; a - pos_y_max
			; calc the cursor pos_y
			
@loop:		dcr b
			jm @stop
			adi OPTIONS_LINE_SPACING
			jmp @loop
@stop:
			mov c, a
			mvi b, OPTIONS_CURSOR_POS_X

			; spawn a cursor
			; bc - a cursor pos
			lxi h, hero_pos_x + 1
			mov m, b			
			lxi h, hero_pos_y + 1
			mov m, c
			ret

options_screen_cursor_update:
			; check keys
			; check if the space key pressed
			lhld key_code_old
			xchg
			lhld key_code
			
			mvi a, KEY_SPACE
			cmp h
			jnz @check_arrows
			; check if a space was not pressed last time 
			; to avoid multiple tyme pressing
			cmp d
			jnz @space_handling

@check_arrows:
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
			; check if a selected option is outside ofthe range [0 - OPTIONS_MAX]
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
			; check if a selected option is outside ofthe range [0 - OPTIONS_MAX]
			lxi h, option_cursor_setting_id
			mov a, m
			inr a
			cpi OPTIONS_MAX
			rnc ; return if a selected option >= OPTIONS_MAX
			mov m, a
			; a - option_cursor_setting_id
			; hl - ptr to option_cursor_setting_id
			call options_cursor_pos_update
			ret

@space_handling:
			lda option_cursor_setting_id
			cpi OPTIONS_ID_RETURN
			jnz @check_music
			; set the global req to return to the main nemu
			mvi a, GLOBAL_REQ_MAIN_MENU
			sta global_request
			ret
@check_music:						
			cpi OPTIONS_ID_MUSIC
			jnz @check_sfx
			CALL_RAM_DISK_FUNC(__gcplayer_flip_mute, __RAM_DISK_S_GCPLAYER | __RAM_DISK_M_GCPLAYER | RAM_DISK_M_8F)
			jmp options_setting_music_val_draw
@check_sfx:
			cpi OPTIONS_ID_SFX
			jnz @check_up
			; flip the setting on/off
			CALL_RAM_DISK_FUNC(__sfx_flip_mute, __RAM_DISK_M_SOUND | RAM_DISK_M_8F)

			jmp options_setting_sfx_val_draw
@check_up:
			cpi OPTIONS_ID_UP
			jnz @check_down
			; input and process a user provided key

			jmp options_settings_val_draw
@check_down:
			;adi GLOBAL_REQ_GAME
			;sta global_request
			ret