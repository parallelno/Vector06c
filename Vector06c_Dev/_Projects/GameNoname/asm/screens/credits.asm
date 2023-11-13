CREDITS_POS = $12e0
CREDITS_LINE_SPACING = 12
CREDITS_PARAG_SPACING = 24

credits_screen:
			lda global_request
			sta @global_req+1
			call credits_screen_init

@loop:
			; return when a user hits a space button
			lda global_request
@global_req:
			cpi TEMP_BYTE
			rnz

			lxi h, screen_space_checking
			call screen_simple_update
			call screen_simple_draw
			jmp	@loop

credits_screen_text_draw:
			CALL_RAM_DISK_FUNC(__text_ex_rd_reset_spacing, __RAM_DISK_S_FONT_RUS | __RAM_DISK_M_TEXT_EX)
			; credits
			lxi b, CREDITS_POS
			lxi h, __text_credits
			CALL_RAM_DISK_FUNC(__text_ex_rd_scr1, __RAM_DISK_S_FONT_RUS | __RAM_DISK_M_TEXT_EX)
			ret

credits_screen_init:
			call screen_simple_init
			call screen_palette_and_frame
			call screen_draw_return_text_button

			call credits_screen_text_draw

			call reset_game_updates_counter
			ret