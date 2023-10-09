END_GAME_TEXT_POS		= $12e0
END_GAME_LINE_SPACING	= 12
END_GAME_PARAG_SPACING	= 24

STATS_MONSTERS_SCR_ADDR = $b0aa

stats_screen:
			lda global_request
			sta @global_req+1
			call stats_screen_init

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

stats_screen_text_draw:
			CALL_RAM_DISK_FUNC(__text_ex_rd_reset_spacing, __RAM_DISK_S_FONT | __RAM_DISK_M_TEXT_EX)
			; draw a text
			lxi b, END_GAME_TEXT_POS
			lxi h, __text_game_stats
			CALL_RAM_DISK_FUNC(__text_ex_rd_scr1, __RAM_DISK_S_FONT | __RAM_DISK_M_TEXT_EX)

			
			; draw monsters stats 
			mvi c, TILEDATA_FUNC_ID_MONSTERS
			CALL_RAM_DISK_FUNC(__game_stats_get, __RAM_DISK_S_SCORE)
			xchg
			; hl - stats
			lxi b, STATS_MONSTERS_SCR_ADDR
			call draw_text_int16

			; draw items stats 
			mvi c, TILEDATA_FUNC_ID_ITEMS
			CALL_RAM_DISK_FUNC(__game_stats_get, __RAM_DISK_S_SCORE)
			xchg
			; hl - stats
			lxi b, STATS_MONSTERS_SCR_ADDR - END_GAME_LINE_SPACING * 1
			call draw_text_int16

			; draw coins stats 
			mvi c, TILEDATA_FUNC_ID_RESOURCES
			CALL_RAM_DISK_FUNC(__game_stats_get, __RAM_DISK_S_SCORE)
			xchg
			; hl - stats
			lxi b, STATS_MONSTERS_SCR_ADDR - END_GAME_LINE_SPACING * 2
			call draw_text_int16

			; draw containers stats 
			mvi c, TILEDATA_FUNC_ID_CONTAINERS
			CALL_RAM_DISK_FUNC(__game_stats_get, __RAM_DISK_S_SCORE)
			xchg
			; hl - stats
			lxi b, STATS_MONSTERS_SCR_ADDR - END_GAME_LINE_SPACING * 3
			call draw_text_int16

			; draw doors stats 
			mvi c, TILEDATA_FUNC_ID_DOORS
			CALL_RAM_DISK_FUNC(__game_stats_get, __RAM_DISK_S_SCORE)
			xchg
			; hl - stats
			lxi b, STATS_MONSTERS_SCR_ADDR - END_GAME_LINE_SPACING * 4
			call draw_text_int16

			; draw breakables stats 
			mvi c, TILEDATA_FUNC_ID_BREAKABLES
			CALL_RAM_DISK_FUNC(__game_stats_get, __RAM_DISK_S_SCORE)
			xchg
			; hl - stats
			lxi b, STATS_MONSTERS_SCR_ADDR - END_GAME_LINE_SPACING * 5
			call draw_text_int16

			; TODO: add stats of secret rooms entered

			; draw total stats
			lxi h, game_ui_score_txt
			lxi b, STATS_MONSTERS_SCR_ADDR - END_GAME_LINE_SPACING * 7
			jmp draw_text

stats_screen_init:
			call screen_simple_init
			call screen_palette_and_frame
			call screen_draw_return_text_button

			call stats_screen_text_draw

			call reset_game_updates_counter
			ret