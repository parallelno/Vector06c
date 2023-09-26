.include "..\\render\\text.asm"
.include "dialogs.asm"

game_ui_draw:
			call game_ui_draw_panel
			call game_ui_draw_resources
			call game_ui_draw_health
			call game_ui_draw_score
			call game_ui_draw_bomb
			ret

game_ui_update:
			jmp dialog_update

game_ui_draw_panel:
			DRAW_TILED_IMG(__RAM_DISK_S_TILED_IMAGES_GFX, __RAM_DISK_S_TILED_IMAGES_DATA, __tiled_images_frame_ingame_top, __TILED_IMAGES_FRAME_INGAME_TOP_COPY_LEN, __tiled_images_tile1)
			ret

; draw resources on the game top panel
game_ui_draw_resources:
			; 
			; copy a tiled image

			; draw an image
			DRAW_TILED_IMG(__RAM_DISK_S_TILED_IMAGES_GFX, __RAM_DISK_S_TILED_IMAGES_DATA, __tiled_images_res_sword, __TILED_IMAGES_RES_SWORD_COPY_LEN, __tiled_images_tile1)			
			ret
@res_tiled_img_ptrs:
			.word __tiled_images_res_sword
			.word __tiled_images_res_mana
			.word __tiled_images_res_potion_health
			.word __tiled_images_res_potion_mana
			.word __tiled_images_res_clothes
			.word __tiled_images_res_cabbage
			.word __tiled_images_res_tnt


; use:
; all
HEALTH_SCR_ADDR = $a3fb
game_ui_draw_health:
			lxi h, hero_res_health
			mov l, m
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

HERO_SCORE_SCR_ADDR = $b3fb
game_ui_draw_score:
			lhld hero_res_score

			lxi d, game_ui_score
			push d
			call int16_to_ascii_dec

			pop h
			; hl = game_ui_score
			lxi b, HERO_SCORE_SCR_ADDR
			call draw_text
			ret
game_ui_score:
			.byte $30, $30, $30, $30, $30, $30, 0

UI_ITEM_BOMB_SCR_ADDR = $a8fb
game_ui_draw_bomb:
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
