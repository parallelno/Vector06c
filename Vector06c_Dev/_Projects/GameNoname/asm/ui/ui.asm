.include "..\\render\\text.asm"
.include "..\\render\\text_ex.asm"
.include "dialogs.asm"

game_ui_draw:
			call game_ui_draw_panel
			call game_ui_draw_health
			call game_ui_draw_score
			call game_ui_draw_bomb
			ret

game_ui_update:
			jmp dialog_update

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
