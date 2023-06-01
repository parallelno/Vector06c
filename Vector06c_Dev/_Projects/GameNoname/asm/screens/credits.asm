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

			; TODO: make it play a new song
			CALL_RAM_DISK_FUNC(__gcplayer_start_repeat, __RAM_DISK_S_GCPLAYER | __RAM_DISK_M_GCPLAYER | RAM_DISK_M_8F)

			lxi h, screen_space_checking	
			call screen_simple_update
			call screen_simple_draw
			jmp	@loop

credits_screen_text_draw:
@text_pos_y		.var  CREDITS_POS
			lxi b, @text_pos_y
			lxi h, @text1
			CALL_RAM_DISK_FUNC(draw_text_ex, __RAM_DISK_S_FONT)			

			@text_pos_y = @text_pos_y - CREDITS_LINE_SPACING 
			lxi b, @text_pos_y
			lxi h, @text2
			CALL_RAM_DISK_FUNC(draw_text_ex, __RAM_DISK_S_FONT)	

			@text_pos_y = @text_pos_y - CREDITS_LINE_SPACING 
			lxi b, @text_pos_y
			lxi h, @text3
			CALL_RAM_DISK_FUNC(draw_text_ex, __RAM_DISK_S_FONT)	

			@text_pos_y = @text_pos_y - CREDITS_PARAG_SPACING 
			lxi b, @text_pos_y
			lxi h, @text4
			CALL_RAM_DISK_FUNC(draw_text_ex, __RAM_DISK_S_FONT)									

			@text_pos_y = @text_pos_y - CREDITS_LINE_SPACING 
			lxi b, @text_pos_y
			lxi h, @text5
			CALL_RAM_DISK_FUNC(draw_text_ex, __RAM_DISK_S_FONT)	

			@text_pos_y = @text_pos_y - CREDITS_LINE_SPACING 
			lxi b, @text_pos_y
			lxi h, @text6
			CALL_RAM_DISK_FUNC(draw_text_ex, __RAM_DISK_S_FONT)							

			@text_pos_y = @text_pos_y - CREDITS_LINE_SPACING 
			lxi b, @text_pos_y
			lxi h, @text7
			CALL_RAM_DISK_FUNC(draw_text_ex, __RAM_DISK_S_FONT)		

			@text_pos_y = @text_pos_y - CREDITS_LINE_SPACING 
			lxi b, @text_pos_y
			lxi h, @text8
			CALL_RAM_DISK_FUNC(draw_text_ex, __RAM_DISK_S_FONT)		

			@text_pos_y = @text_pos_y - CREDITS_LINE_SPACING 
			lxi b, @text_pos_y
			lxi h, @text9
			CALL_RAM_DISK_FUNC(draw_text_ex, __RAM_DISK_S_FONT)		

			@text_pos_y = @text_pos_y - CREDITS_LINE_SPACING 
			lxi b, @text_pos_y
			lxi h, @text10
			CALL_RAM_DISK_FUNC(draw_text_ex, __RAM_DISK_S_FONT)

			@text_pos_y = @text_pos_y - CREDITS_PARAG_SPACING 
			lxi b, @text_pos_y
			lxi h, @text11
			CALL_RAM_DISK_FUNC(draw_text_ex, __RAM_DISK_S_FONT)	

			@text_pos_y = @text_pos_y - CREDITS_LINE_SPACING 
			lxi b, @text_pos_y
			lxi h, @text12
			CALL_RAM_DISK_FUNC(draw_text_ex, __RAM_DISK_S_FONT)	

			@text_pos_y = @text_pos_y - CREDITS_PARAG_SPACING 
			lxi b, @text_pos_y
			lxi h, @text13
			CALL_RAM_DISK_FUNC(draw_text_ex, __RAM_DISK_S_FONT)				

			@text_pos_y = @text_pos_y - CREDITS_LINE_SPACING 
			lxi b, @text_pos_y
			lxi h, @text14
			CALL_RAM_DISK_FUNC(draw_text_ex, __RAM_DISK_S_FONT)																						
			ret
@text1:
			TEXT("    This game was created because I truly")
@text2:
			TEXT("believe in the awesomeness of the Soviet")
@text3:
			TEXT("PC Vector 06c that shaped my life.")
@text4:			
			TEXT("Code: Alex Fedotovskikh")
@text5:			
			TEXT("Story and inspiration: Petr Fedotovskikh")
@text6:	
			TEXT("Game mechanics: Ilia Fedotovskikh")
@text7:			
			TEXT("Support and ideas: Fenia Fedotovskikh")
@text8:
			TEXT("Level design: the whole family!")
@text9:			
			TEXT("Feedback, sound API, v06x emulator: svofski")
@text10:
			TEXT("ZX0 unpacking code: ivagor")
@text11:
			TEXT("Big thanks to my amazing family for")
@text12:			
			TEXT("working hard to make it a reality!")
@text13:
			TEXT("Special thanks to zx-pk.ru community")
@text14:
			TEXT("and especially to svofski and ivagor!")			

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