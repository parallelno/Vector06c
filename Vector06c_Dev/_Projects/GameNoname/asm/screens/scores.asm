SCORES_TITLE_POS = $58d8

SCORES_POS = $38b8
SCORES_LINE_SPACING = 14
SCORES_PARAG_SPACING = 24

scores_screen:
			sta @global_req+1
			call scores_screen_init

@loop:
			; return when a user hits a space button
			lda global_request
@global_req:
			cpi TEMP_BYTE  
			rnz

			; TODO: make it play a new song
			CALL_RAM_DISK_FUNC(__gcplayer_start_repeat, __RAM_DISK_S_GCPLAYER | __RAM_DISK_M_GCPLAYER | RAM_DISK_M_8F)
			
			lxi h, screen_space_checking	
			call screen_simple_update
			call screen_simple_draw
			jmp	@loop

scores_screen_text_draw:
			lxi b, SCORES_TITLE_POS
			lxi h, @score_title
			CALL_RAM_DISK_FUNC(draw_text_ex, __RAM_DISK_S_FONT)

			mvi e, SCORES_MAX
			lxi b, SCORES_POS
@loop:
			push b
			push d
			lxi h, @text_buff
			CALL_RAM_DISK_FUNC(draw_text_ex, __RAM_DISK_S_FONT)
			pop d
			pop b

			LXI_H(-SCORES_LINE_SPACING)
			dad b
			mov b, h
			mov c, l

			dcr e
			jnz @loop

			ret
@score_title:
			TEXT("SCORE BOARD")
@text_buff:
			TEXT("TEMPNAME .................. 65535")

scores_screen_init:
			call screen_simple_init
			call screen_palette_and_frame
			call scores_screen_text_draw

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