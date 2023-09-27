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
; TODO: replace 8 with a meaningful label
GAME_UI_RES_ICON_IMG_LEN = 8 ; __TILED_IMAGES_RES_SWORD_COPY_LEN
game_ui_draw_resources:
			; check if mana is ITEM_ID_MANA is acquired
			lxi d, global_items + ITEM_ID_MANA - 1	; because the first item_id = 1
			ldax d
			cpi ITEM_STATUS_ACQUIRED
			;jnz @draw_res
			lxi d, __tiled_images_res_mana
			call @draw_icon
@draw_res:
			; copy a tiled image
			lxi d, __tiled_images_res_sword


			/*
			.macro DRAW_TILED_IMG(ram_disk_s_tiled_img_gfx, ram_disk_s_tiled_img_data, idxs_data_addr, idxs_data_len, tile_gfx_addr)
			; draw an image
			DRAW_TILED_IMG(__RAM_DISK_S_TILED_IMAGES_GFX, __RAM_DISK_S_TILED_IMAGES_DATA, __tiled_images_res_sword, __TILED_IMAGES_RES_SWORD_COPY_LEN, __tiled_images_tile1)			
			*/
			ret
@res_tiled_img_ptrs:
			.word __tiled_images_res_sword
			.word __tiled_images_res_mana
			.word __tiled_images_res_potion_health
			.word __tiled_images_res_potion_mana
			.word __tiled_images_res_clothes
			.word __tiled_images_res_cabbage
			.word __tiled_images_res_tnt
@draw_icon:
			; de - ptr to an img
			lxi h, __tiled_images_tile1 - TILE_IMG_TILE_LEN ; because there is no tile_gfx associated with idx = 0
			shld draw_tiled_img_gfx_addr
			mvi a, <__RAM_DISK_S_TILED_IMAGES_GFX
			lxi h, __RAM_DISK_S_TILED_IMAGES_DATA << 8 | GAME_UI_RES_ICON_IMG_LEN ; it is assuming that copy_len is equal for every the res icon
			jmp draw_tiled_img


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

HERO_SCORE_SCR_ADDR = $b9fb
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


; draw an FPS counter every second on the screen at FPS_SCR_ADDR addr
; works only in the interruption func and in the
; main program when the ram-disk is dismount
; in:
; A - fps
; uses:
; BC, DE, HL
FPS_SCR_ADDR = $bdfb - 16
draw_fps:
			lhld DrawText_restoreSP+1
			shld @tmp_restore_sp
			;lxi h, @fps_text
			;call int_to_ascii_hex
			mov l, a
			mvi h, 0
			lxi d, @fps_text_hi
			call int8_to_ascii_dec	

			lxi h, @fps_text_hi
			lxi b, FPS_SCR_ADDR
			call draw_text
			lhld @tmp_restore_sp
			shld DrawText_restoreSP+1
			ret

@fps_text_hi:
			.byte $30
@fps_text:
			.byte $30, $30, 0
@tmp_restore_sp:
            .word TEMP_ADDR