.include "..\\render\\text.asm"
.include "dialogs.asm"

game_ui_init:
			A_TO_ZERO(0)
			sta game_ui_res_id_selected
			jmp game_ui_draw

game_ui_draw:
			call game_ui_draw_panel
			call game_ui_draw_health_text
			call game_ui_draw_score_text
			ret

game_ui_update:
			jmp dialog_update


HEALTH_SCR_ADDR = $a3fb
game_ui_draw_health_text:
			lxi h, hero_res_health
			lxi b, HEALTH_SCR_ADDR
			jmp draw_text_int8_ptr

HERO_SCORE_SCR_ADDR = $b9fb
game_ui_draw_score_text:
			lhld hero_res_score

			lxi d, game_ui_score_txt
			push d
			call int16_to_ascii_dec
			pop h
			; hl = game_ui_score_txt
			lxi b, HERO_SCORE_SCR_ADDR
			jmp draw_text
game_ui_score_txt:
			.byte $30, $30, $30, $30, $30, $30, 0

TEXT_MANA_SCR_ADDR = $a8fb
game_ui_draw_res_mana_text:
			lxi h, hero_res_mana
			lxi b, TEXT_MANA_SCR_ADDR
			jmp draw_text_int8_ptr

; draw an FPS counter every second on the screen at FPS_SCR_ADDR addr
; works only in the interruption func and in the
; main program when the ram-disk is dismount
; in:
; A - fps
; uses:
; BC, DE, HL
FPS_SCR_ADDR = $bdfb - 16
draw_fps:
			lhld draw_text_restore_sp+1
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
			shld draw_text_restore_sp+1
			ret
@fps_text_hi: ; do not use a shared text buffer because draw_fps is called in the int func
			.byte $30, $30, $30, 0
@tmp_restore_sp:
            .word TEMP_ADDR


game_ui_draw_panel:
			DRAW_TILED_IMG(__RAM_DISK_S_TILED_IMAGES_DATA, __tiled_images_frame_ingame_top, true)
game_ui_draw_icon_mana:
			DRAW_TILED_IMG(__RAM_DISK_S_TILED_IMAGES_DATA, __tiled_images_res_mana, true)
game_ui_draw_icon_sword:
			DRAW_TILED_IMG(__RAM_DISK_S_TILED_IMAGES_DATA, __tiled_images_res_sword, true)


; draw resources (except health, mana, score) on the game top panel
game_ui_draw_resources:
			; check if mana is ITEM_ID_MANA is acquired
			lxi d, global_items + ITEM_ID_MANA - 1	; because the first item_id = 1
			ldax d
			cpi ITEM_STATUS_ACQUIRED
			;jnz @draw_res
			;call @draw_icon
@draw_res:
			; copy a tiled image
			lxi d, __tiled_images_res_sword
			ret

@draw_icon:
			; de - ptr to an img
			mvi a, <__RAM_DISK_S_TILED_IMAGES_DATA
			jmp draw_tiled_img			

@res_tiled_img_ptrs:
			.word __tiled_images_res_sword
			.word __tiled_images_res_mana
			.word __tiled_images_res_potion_health
			.word __tiled_images_res_potion_mana
			.word __tiled_images_res_clothes
			.word __tiled_images_res_cabbage
			.word __tiled_images_res_tnt