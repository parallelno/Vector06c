CREDITS_POS = $12e0
CREDITS_LINE_SPACING = 12
CREDITS_PARAG_SPACING = 24

credits_screen:
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
@text_pos_y		.var  CREDITS_POS
			lxi b, @text_pos_y
			lxi h, __text_credits1
			CALL_RAM_DISK_FUNC(__draw_text_ex_rd_scr1, __RAM_DISK_S_FONT | __RAM_DISK_M_TEXT_EX)			

			@text_pos_y = @text_pos_y - CREDITS_LINE_SPACING 
			lxi b, @text_pos_y
			lxi h, __text_credits2
			CALL_RAM_DISK_FUNC(__draw_text_ex_rd_scr1, __RAM_DISK_S_FONT | __RAM_DISK_M_TEXT_EX)	

			@text_pos_y = @text_pos_y - CREDITS_LINE_SPACING 
			lxi b, @text_pos_y
			lxi h, __text_credits3
			CALL_RAM_DISK_FUNC(__draw_text_ex_rd_scr1, __RAM_DISK_S_FONT | __RAM_DISK_M_TEXT_EX)	

			@text_pos_y = @text_pos_y - CREDITS_PARAG_SPACING 
			lxi b, @text_pos_y
			lxi h, __text_credits4
			CALL_RAM_DISK_FUNC(__draw_text_ex_rd_scr1, __RAM_DISK_S_FONT | __RAM_DISK_M_TEXT_EX)									

			@text_pos_y = @text_pos_y - CREDITS_LINE_SPACING 
			lxi b, @text_pos_y
			lxi h, __text_credits5
			CALL_RAM_DISK_FUNC(__draw_text_ex_rd_scr1, __RAM_DISK_S_FONT | __RAM_DISK_M_TEXT_EX)	

			@text_pos_y = @text_pos_y - CREDITS_LINE_SPACING 
			lxi b, @text_pos_y
			lxi h, __text_credits6
			CALL_RAM_DISK_FUNC(__draw_text_ex_rd_scr1, __RAM_DISK_S_FONT | __RAM_DISK_M_TEXT_EX)							

			@text_pos_y = @text_pos_y - CREDITS_LINE_SPACING 
			lxi b, @text_pos_y
			lxi h, __text_credits7
			CALL_RAM_DISK_FUNC(__draw_text_ex_rd_scr1, __RAM_DISK_S_FONT | __RAM_DISK_M_TEXT_EX)		

			@text_pos_y = @text_pos_y - CREDITS_LINE_SPACING 
			lxi b, @text_pos_y
			lxi h, __text_credits8
			CALL_RAM_DISK_FUNC(__draw_text_ex_rd_scr1, __RAM_DISK_S_FONT | __RAM_DISK_M_TEXT_EX)		

			@text_pos_y = @text_pos_y - CREDITS_LINE_SPACING 
			lxi b, @text_pos_y
			lxi h, __text_credits9
			CALL_RAM_DISK_FUNC(__draw_text_ex_rd_scr1, __RAM_DISK_S_FONT | __RAM_DISK_M_TEXT_EX)		

			@text_pos_y = @text_pos_y - CREDITS_LINE_SPACING 
			lxi b, @text_pos_y
			lxi h, __text_credits10
			CALL_RAM_DISK_FUNC(__draw_text_ex_rd_scr1, __RAM_DISK_S_FONT | __RAM_DISK_M_TEXT_EX)

			@text_pos_y = @text_pos_y - CREDITS_PARAG_SPACING 
			lxi b, @text_pos_y
			lxi h, __text_credits11
			CALL_RAM_DISK_FUNC(__draw_text_ex_rd_scr1, __RAM_DISK_S_FONT | __RAM_DISK_M_TEXT_EX)	

			@text_pos_y = @text_pos_y - CREDITS_LINE_SPACING 
			lxi b, @text_pos_y
			lxi h, __text_credits12
			CALL_RAM_DISK_FUNC(__draw_text_ex_rd_scr1, __RAM_DISK_S_FONT | __RAM_DISK_M_TEXT_EX)

			@text_pos_y = @text_pos_y - CREDITS_PARAG_SPACING 
			lxi b, @text_pos_y
			lxi h, __text_credits13
			CALL_RAM_DISK_FUNC(__draw_text_ex_rd_scr1, __RAM_DISK_S_FONT | __RAM_DISK_M_TEXT_EX)				

			@text_pos_y = @text_pos_y - CREDITS_LINE_SPACING 
			lxi b, @text_pos_y
			lxi h, __text_credits14
			CALL_RAM_DISK_FUNC(__draw_text_ex_rd_scr1, __RAM_DISK_S_FONT | __RAM_DISK_M_TEXT_EX)																						
			ret

credits_screen_init:
			call screen_simple_init	
			call screen_palette_and_frame
			call credits_screen_text_draw

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