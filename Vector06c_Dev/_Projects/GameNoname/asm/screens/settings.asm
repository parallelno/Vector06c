; text
SETTINGS_TEXT_SETTINGS_W	= 112 ; a width of a setting text column
SETTINGS_SETTING_VAL_W = 12
SETTINGS_SUB_SETTING_VAL_W = 24
SETTINGS_TEXT_TITLE_W = 30
SETTINGS_SETTING_PREDEF_VAL_W = 12

SETTINGS_POS_Y_MAX	= 216


SETTINGS_LINE_SPACING = -14
SETTINGS_PARAG_SPACING = -24

SETTINGS_ID_MUSIC	= 0
SETTINGS_ID_SFX		= 1
SETTINGS_ID_CONTROLS	= 2
SETTINGS_ID_RETURN	= 3

SETTINGS_MAX = 4

SETTINGS_SECTION1_LAST_ID = SETTINGS_ID_SFX
SETTINGS_SECTION2_LAST_ID = SETTINGS_ID_CONTROLS

SETTINGS_CURSOR_POS_Y_OFFSET1	= - SETTINGS_PARAG_SPACING + SETTINGS_LINE_SPACING	; when it is in the controls section
SETTINGS_CURSOR_POS_Y_OFFSET2	= SETTINGS_CURSOR_POS_Y_OFFSET1 - SETTINGS_PARAG_SPACING - SETTINGS_LINE_SPACING * 6	; when it is in the return section
;========================================
; no need to adjust
SETTINGS_HALF_SCR		= 128

SETTINGS_POS_X						= SETTINGS_HALF_SCR - (SETTINGS_TEXT_SETTINGS_W/2)
SETTINGS_POS							= SETTINGS_POS_X<<8 | SETTINGS_POS_Y_MAX
SETTINGS_SETTING_VAL_POS_X			= SETTINGS_HALF_SCR + SETTINGS_TEXT_SETTINGS_W/2 - SETTINGS_SETTING_VAL_W
SETTINGS_SUB_SETTING_VAL_POS_X		= SETTINGS_HALF_SCR + SETTINGS_TEXT_SETTINGS_W/2 - SETTINGS_SUB_SETTING_VAL_W
SETTINGS_SETTING_PREDEF_VAL_POS_X 	= SETTINGS_HALF_SCR + SETTINGS_TEXT_SETTINGS_W/2 - SETTINGS_SETTING_PREDEF_VAL_W
SETTINGS_SETTING_TITLE_POS_X			= SETTINGS_HALF_SCR - SETTINGS_TEXT_TITLE_W/2

; cursor
SETTINGS_CURSOR_POS_X		= SETTINGS_POS_X - 8
SETTINGS_CURSOR_POS_Y_MAX	= SETTINGS_POS_Y_MAX - 16

; no need to adjust - end
;========================================


settings_cursor_setting_id:
			.byte 0

settings_screen:
			sta @global_req+1
			call settings_screen_init
@loop:
			; return when a user hits a space button
			lda global_request
@global_req:
			cpi TEMP_BYTE
			rnz

			lxi h, settings_screen_cursor_update
			call screen_simple_update
			call screen_simple_draw
			jmp	@loop

settings_screen_init:
			call screen_simple_init
			call screen_palette_and_frame

			lxi h, __text_change_settings
			@text_change_settings_pos = $8a19
			lxi b, @text_change_settings_pos
			call screen_draw_return_button_custom_text

			call settings_screen_text_draw
			call settings_screen_cursor_init

			call reset_game_updates_counter
			ret

settings_screen_text_draw:
			lxi b, (<SETTINGS_PARAG_SPACING)<<8 | <SETTINGS_LINE_SPACING
			CALL_RAM_DISK_FUNC(__text_ex_rd_set_spacing, __RAM_DISK_S_FONT | __RAM_DISK_M_TEXT_EX)

@text_pos		.var  SETTINGS_POS
			; SETTINGS TITLE
			lxi b, SETTINGS_SETTING_TITLE_POS_X<<8 | <@text_pos
			lxi h, __text_settings
			CALL_RAM_DISK_FUNC(__text_ex_rd_scr1, __RAM_DISK_S_FONT | __RAM_DISK_M_TEXT_EX)

			; MUSIC & SFX & Controls
			@text_pos = @text_pos + SETTINGS_LINE_SPACING
			lxi b, @text_pos
			lxi h, __text_settings_names
			CALL_RAM_DISK_FUNC(__text_ex_rd_scr1, __RAM_DISK_S_FONT | __RAM_DISK_M_TEXT_EX)

			call settings_val_draw
			ret

settings_screen_cursor_init:
@check_if_init:
			jmp @init
@init:
			lxi h, @no_init
			shld @check_if_init + 1

			; reset selected settings
			A_TO_ZERO_CONST(SETTINGS_ID_MUSIC)
			sta settings_cursor_setting_id

@no_init:
			lxi h, settings_cursor_setting_id
			call settings_cursor_pos_update
			jmp cursor_init


; erase and draw a music/sfx settings values
settings_val_draw:
			call setting_music_val_draw
			call setting_sfx_val_draw
			call setting_controls_val_draw
			ret

setting_music_val_draw:
@text_pos	.var  SETTINGS_POS
			@text_pos = @text_pos + SETTINGS_LINE_SPACING

			; erase a setting value
			@scr_addr_x_offset = (SETTINGS_SETTING_VAL_POS_X/8)<<8
			lxi b, 2<<8 | 9
			lxi d, SCR_BUFF1_ADDR + <@text_pos | @scr_addr_x_offset
			call sprite_copy_to_scr_v
			; get a setting value
			lxi h, __text_setting_on
			CALL_RAM_DISK_FUNC(__gcplayer_get_setting, __RAM_DISK_S_GCPLAYER | __RAM_DISK_M_GCPLAYER | RAM_DISK_M_8F)
			mvi a, SETTING_OFF
			cmp c
			jnz @music_on
			lxi h, __text_setting_off
@music_on:
			; draw a setting value
			lxi b, <@text_pos | SETTINGS_SETTING_VAL_POS_X<<8
			CALL_RAM_DISK_FUNC(__text_ex_rd_scr1, __RAM_DISK_S_FONT | __RAM_DISK_M_TEXT_EX)
			ret

setting_sfx_val_draw:
@text_pos	.var  SETTINGS_POS
			@text_pos = @text_pos + SETTINGS_LINE_SPACING * 2

			; erase a setting value
			@scr_addr_x_offset = (SETTINGS_SETTING_VAL_POS_X/8)<<8
			lxi b, 2<<8 | 9
			lxi d, SCR_BUFF1_ADDR + <@text_pos | @scr_addr_x_offset
			call sprite_copy_to_scr_v
			; get a setting value
			lxi h, __text_setting_on
			CALL_RAM_DISK_FUNC(__sfx_get_setting, __RAM_DISK_M_SOUND | RAM_DISK_M_8F)
			mvi a, SETTING_OFF
			cmp c
			jnz @sfx_on
			lxi h, __text_setting_off
@sfx_on:
			; draw a setting value
			lxi b, SETTINGS_SETTING_VAL_POS_X<<8 | <@text_pos
			CALL_RAM_DISK_FUNC(__text_ex_rd_scr1, __RAM_DISK_S_FONT | __RAM_DISK_M_TEXT_EX)
			ret

setting_controls_val_draw:
@text_pos	.var  SETTINGS_POS
			@text_pos = @text_pos + SETTINGS_LINE_SPACING * 2 + SETTINGS_PARAG_SPACING
			
			; erase a CONTROL PRESET settings value
			lxi b, 4<<8 | 9
			lxi h, SCR_BUFF1_ADDR + <@text_pos | (SETTINGS_SETTING_VAL_POS_X/8)<<8
			call erase_screen_block

			; erase a Controls settings value
			lxi b, 6<<8 | 95
			lxi h, SCR_BUFF1_ADDR + <@text_pos + SETTINGS_LINE_SPACING * 7 | (SETTINGS_SUB_SETTING_VAL_POS_X/8)<<8
			call erase_screen_block

			; get a setting value
			call controls_get_preset			

			cpi CONTROL_PRESET_KEYBOARD
			jz @control_preset_keyboard
			; draw a preset name
			lxi h, __text_control_preset_joy
			lxi b, SETTINGS_SETTING_VAL_POS_X<<8 | <@text_pos
			CALL_RAM_DISK_FUNC(__text_ex_rd_scr1, __RAM_DISK_S_FONT | __RAM_DISK_M_TEXT_EX)

			; draw controls
			lxi h, __text_controls_joystic
			lxi b, SETTINGS_SUB_SETTING_VAL_POS_X<<8 | <@text_pos + SETTINGS_LINE_SPACING
			CALL_RAM_DISK_FUNC(__text_ex_rd_scr1, __RAM_DISK_S_FONT | __RAM_DISK_M_TEXT_EX)
			ret
@control_preset_keyboard:
			; draw a preset name
			lxi h, __text_control_preset_key
			lxi b, SETTINGS_SETTING_VAL_POS_X<<8 | <@text_pos
			CALL_RAM_DISK_FUNC(__text_ex_rd_scr1, __RAM_DISK_S_FONT | __RAM_DISK_M_TEXT_EX)			
			
			; draw controls
			lxi h, __text_controls_keyboard
			lxi b, SETTINGS_SUB_SETTING_VAL_POS_X<<8 | <@text_pos + SETTINGS_LINE_SPACING
			CALL_RAM_DISK_FUNC(__text_ex_rd_scr1, __RAM_DISK_S_FONT | __RAM_DISK_M_TEXT_EX)
			ret


; converts settings_cursor_setting_id into a cursor pos
; hl - ptr to settings_cursor_setting_id
; out:
; bc - cursor_pos_xy
; (hero_pos_x + 1) = cursor_pos_x
; (hero_pos_y + 1) = cursor_pos_y
settings_cursor_pos_update:
			mov b, m
			; check if the cursor is in the return section
			mvi a, SETTINGS_SECTION2_LAST_ID
			cmp b
			mvi a, SETTINGS_CURSOR_POS_Y_MAX
			jnc @no_offset2
			sui SETTINGS_CURSOR_POS_Y_OFFSET2
			jmp @no_offset1
@no_offset2:
			; check if the cursor is in the controls section
			mvi a, SETTINGS_SECTION1_LAST_ID
			cmp b
			mvi a, SETTINGS_CURSOR_POS_Y_MAX
			jnc @no_offset1
			sui SETTINGS_CURSOR_POS_Y_OFFSET1
@no_offset1:
			; b - settings_cursor_setting_id
			; a - pos_y_max
			; calc the cursor pos_y

@loop:		dcr b
			jm @stop
			adi SETTINGS_LINE_SPACING
			jmp @loop
@stop:
			mov c, a
			mvi b, SETTINGS_CURSOR_POS_X

			; spawn a cursor
			; bc - a cursor pos
			lxi h, hero_pos_x + 1
			mov m, b
			lxi h, hero_pos_y + 1
			mov m, c
			ret

settings_screen_cursor_update:
			; check keys
			; check if the space key pressed
			lhld action_code
			; h - action_code_old
			; l - action_code

			; return if the same key was pressed last time 
			; to avoid multiple times pressing
			mov a, l
			cmp h
			rz

			mvi a, CONTROL_CODE_KEY_SPACE | CONTROL_CODE_FIRE1
			ana l
			jnz @space_handling

@check_arrows:
			mov a, l
			; a - action_code
			cpi CONTROL_CODE_DOWN
			jz @cursor_move_down
			cpi CONTROL_CODE_UP
			rnz
@cursor_move_up:
			; check if a selected setting is outside of the range [0 - SETTINGS_MAX]
			lxi h, settings_cursor_setting_id
			mov a, m
			dcr a
			rm ; return if a selected setting = -1
			mov m, a
			; a - settings_cursor_setting_id
			; hl - ptr to settings_cursor_setting_id
			call settings_cursor_pos_update
			ret
@cursor_move_down:
			; check if a selected setting is outside ofthe range [0 - SETTINGS_MAX]
			lxi h, settings_cursor_setting_id
			mov a, m
			inr a
			cpi SETTINGS_MAX
			rnc ; return if a selected setting >= SETTINGS_MAX
			mov m, a
			; a - settings_cursor_setting_id
			; hl - ptr to settings_cursor_setting_id
			call settings_cursor_pos_update
			ret

@space_handling:
			lda settings_cursor_setting_id
			cpi SETTINGS_ID_RETURN
			jnz @check_music
			; set the global req to return to the main nemu
			mvi a, GLOBAL_REQ_MAIN_MENU
			sta global_request
			ret
@check_music:
			cpi SETTINGS_ID_MUSIC
			jnz @check_sfx
			CALL_RAM_DISK_FUNC(__gcplayer_flip_mute, __RAM_DISK_S_GCPLAYER | __RAM_DISK_M_GCPLAYER | RAM_DISK_M_8F)
			jmp setting_music_val_draw
@check_sfx:
			cpi SETTINGS_ID_SFX
			jnz @check_controls
			; flip the setting on/off
			CALL_RAM_DISK_FUNC(__sfx_flip_mute, __RAM_DISK_M_SOUND | RAM_DISK_M_8F)

			jmp setting_sfx_val_draw
@check_controls:
			cpi SETTINGS_ID_CONTROLS
			rnz
			; flip the control preset keys/joy
			call controls_flip_preset
			jmp setting_controls_val_draw
			ret
