.include "text.asm"
.include "text2.asm"

game_ui_init:
			call game_ui_draw_panel
			call game_ui_draw_health
			call game_ui_draw_score
			call game_ui_draw_bomb
			ret
/*
GameUIUpdate:
			ret
*/

game_ui_draw_panel:
			DRAW_TILED_IMG(__RAM_DISK_S_TILED_IMAGES_GFX, __RAM_DISK_S_TILED_IMAGES_DATA, __tiled_images_frame_ingame_top, __TILED_IMAGES_FRAME_INGAME_TOP_COPY_LEN, __tiled_images_tile1)
			ret

HEALTH_SCR_ADDR = $a3fb
game_ui_draw_health:
			lda hero_health
			mov l, a
			mvi h, 0
			lxi d, @text_hi
			call int8_to_ascii_dec

			lxi h, @text
			lxi b, HEALTH_SCR_ADDR
			call draw_text
			ret
@text_hi:
			.byte $30
@text:
			.byte $31,$30,0

HERO_SCORE_SCR_ADDR = $b5fb
game_ui_draw_score:
			lda hero_score
			mov l, a
			mvi h, 0
			lxi d, @hero_score_text
			call int16_to_ascii_dec

			lxi h, @hero_score_text
			lxi b, HERO_SCORE_SCR_ADDR
			call draw_text
			ret
@hero_score_text:
			.byte $30, $30, $30, $30, $30, 0

UI_ITEM_BOMB_SCR_ADDR = $a8fb
game_ui_draw_bomb:
			;lda hero_score
			;mov l, a
			; TODO: replace with loading a real item count
			mvi l, 0
			
			mvi h, 0
			lxi d, @bomb_text_hi
			call int8_to_ascii_dec

			lxi h, @bomb_text
			lxi b, UI_ITEM_BOMB_SCR_ADDR
			call draw_text
			ret
@bomb_text_hi:
			.byte $30
@bomb_text:
			.byte $30, $30, 0

.macro DRAW_DIALOG(ram_disk_s_tiled_img_gfx, ram_disk_s_tiled_img_data, idxs_data_addr, idxs_data_len, tile_gfx_addr)
			DRAW_TILED_IMG(ram_disk_s_tiled_img_gfx, ram_disk_s_tiled_img_data, idxs_data_addr, idxs_data_len, tile_gfx_addr)
			; draw text

			lxi b, $182d
			lxi h, test_text_data1
			CALL_RAM_DISK_FUNC(draw_text_ex, __RAM_DISK_S_FONT)

			lxi b, $1821
			lxi h, test_text_data2
			CALL_RAM_DISK_FUNC(draw_text_ex, __RAM_DISK_S_FONT)

			lxi b, $1815
			lxi h, test_text_data3
			CALL_RAM_DISK_FUNC(draw_text_ex, __RAM_DISK_S_FONT)						

			lxi b, $1809
			lxi h, test_text_data4
			CALL_RAM_DISK_FUNC(draw_text_ex, __RAM_DISK_S_FONT)						
			ret

test_text_data1:
.encoding "screencode", "mixed"
			.text "The cold and the darkness of corridors rev-"
			.byte 0
test_text_data2:
.encoding "screencode", "mixed"			
			.text "ealed a mysterious figure. Two strong hands"
			.byte 0
test_text_data3:
.encoding "screencode", "mixed"			
			.text "lifted up the unconscious body and carried"
			.byte 0			
test_text_data4:
.encoding "screencode", "mixed"			
			.text "him out of the dungeon into the fresh air."
			.byte 0
			; reset updates
			xra a
			sta requested_updates
			ret
.endmacro
