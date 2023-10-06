.include "..\\render\\text.asm"
.include "dialogs.asm"

game_ui_init:
			A_TO_ZERO( RES_SELECTABLE_AVAILABLE_NONE)
			sta game_ui_res_selected_id
			mvi a, <global_items
			sta game_ui_item_visible_addr
			jmp game_ui_draw

game_ui_draw:
			call game_ui_draw_panel
			call game_ui_draw_health_text
			call game_ui_draw_score_text
			ret

game_ui_update:
			call game_ui_draw_items
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
game_ui_draw_mana_text:
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

; when a player hits action_1
; it decrement the selected resource amount (except a sword because it's unlimited)
; it selects the first non-empty resource
game_ui_res_use:
			lda game_ui_res_selected_id
			CPI_WITH_ZERO(RES_SELECTABLE_AVAILABLE_NONE)
			rz

			; if a sword is selected, return because it's unlimited
			rrc
			rnc

			; use selected (non-sword) resource
			; a - res_selectable_id
			adi <hero_res_sword
			mov l, a
			mvi h, >hero_res_sword
			dcr m ; use a resource
game_ui_select_first_available_if_empty:
			jp @select_first_available
			; if a value == -1, clamp to zero
			mov c, m
			inr c
			jnz @select_first_available ; if it's not -1
			mov m, c ; clamp the resouce to 0
@select_first_available:
			call game_ui_res_get_first_available
			; c - res_selected_id
			; c = 0 if all resources are empty (except a sword)

			; check if a sword is available
			lda hero_res_sword
			rrc ; to make the sword_selected bit
			mov a, c
			ral ; set the sword_selected bit
			sta game_ui_res_selected_id
			ret


; find the first selectable non-empty resource except a sword
; out:
; hl - ptr to non-empty resource if any available
; c - res_selected_id
; c = 0 if all resources are empty (except a sword)
; use:
; hl, a, c
game_ui_res_get_first_available:
			lxi h, hero_res_sword + 1
			mvi c, RES_SELECTABLE_MAX - 1
			A_TO_ZERO(0)
@next_res:
			cmp m
			jnz @reverse_counter
			inx h
			dcr c
			jnz @next_res
			; no non-empty resources
			; c = RES_SELECTABLE_AVAILABLE_NONE
			ret
@reverse_counter:
			mvi a, RES_SELECTABLE_MAX
			sub c
			mov c, a
			ret


; when a player hits action_2
; it selects the next non-empty resource
; it returns a selected res_id
game_ui_res_select_next:
			ret

; in:
; c - res_selectable_id
game_ui_res_select_and_draw:
			; check if a resource is not empty
			push b
			mvi a, <hero_res_sword
			add c
			mov l, a
			mvi h, >hero_res_sword
			mov a, m
			CPI_WITH_ZERO(0)
			pop b
			jnz @select_res
			call game_ui_select_first_available_if_empty
			jmp @draw_icon
@select_res:
			lxi h, game_ui_res_selected_id
			mov a, m
			ani ~RES_SELECTABLE_MASK
			rrc
			ora c
			rlc
			mov m, a
@draw_icon:
			lda hero_res_sword
			CPI_WITH_ZERO(HERO_WEAPON_NONE)
			jnz game_ui_res_select_sword_and_draw
			jmp game_ui_draw_res

game_ui_res_select_sword_and_draw:
			lxi h, game_ui_res_selected_id
			mov a, m
			ori RES_SELECTABLE_AVAILABLE_SWORD
			mov m, a
			jmp game_ui_draw_res

; if a sword is available, then it draws a sword icon
; if not all resources empty, then it draws a first non-empty resource icon, else it draws an empty res slot
; it draws a selection frame on a sword or on a resource icon depending on what is selected
; health, mana, and the score have their own dedicated draw functions
TEXT_RES_SCR_ADDR = $b0fb
game_ui_draw_res:
			; if a sword is available, draw it
			lda hero_res_sword
			CPI_WITH_ZERO(0)
			cnz @draw_sword

			; check if a resource's available
			lda game_ui_res_selected_id
			ani RES_SELECTABLE_MASK
			rrc
			; a - res_selected_id
			; a = 0 if all resource are empty
			jnz @draw_res
			; draw an empty res icon
			lxi d, __tiled_images_res_empty
			call @draw_icon
			jmp @draw_selection

@draw_res:
			; a - res_selected_id
			; a reg's min value is 1
			HL_TO_AX2_PLUS_INT16(@tiled_img_ptrs - WORD_LEN) ; - WORD_LEN because a reg's min value is 1
			mov e, m
			inx h
			mov d, m
			; de - tiled image data ptr
			call @draw_icon

@draw_res_text:
			lda game_ui_res_selected_id
			ani RES_SELECTABLE_MASK
			rrc
			; a - res_selectable_id
			adi <hero_res_sword
			mov l, a
			mvi h, >hero_res_sword
			lxi b, TEXT_RES_SCR_ADDR
			call draw_text_int8_ptr

@draw_selection:
			lda game_ui_res_selected_id
			CPI_WITH_ZERO(0)
			rz ; return if no
			rrc
			jc @draw_sword_selection
			; draw selection frame on a resouce

			lxi b, __vfx_selection_0
			lxi d, $a000 + (14<<8) | 30*8
			CALL_RAM_DISK_FUNC(__draw_sprite_vm, __RAM_DISK_S_VFX | __RAM_DISK_M_DRAW_SPRITE_VM | RAM_DISK_M_89)
			ret
@draw_sword_selection:
			; draw selection frame on a sword
			lxi b, __vfx_selection_0
			lxi d, $a000 + (11<<8) | 30*8
			CALL_RAM_DISK_FUNC(__draw_sprite_vm, __RAM_DISK_S_VFX | __RAM_DISK_M_DRAW_SPRITE_VM | RAM_DISK_M_89)
			ret

@draw_sword:
			lxi d, __tiled_images_res_sword
@draw_icon:
			; de - ptr to an img
			mvi a, <__RAM_DISK_S_TILED_IMAGES_DATA
			jmp draw_tiled_img

@tiled_img_ptrs:
			.word __tiled_images_res_potion_health
			.word __tiled_images_res_potion_mana
			.word __tiled_images_res_tnt
			.word __tiled_images_res_clothes
			.word __tiled_images_res_cabbage


; draws an available item.
; it shows the next available item every game_update_time * GAME_UI_ITEM_UPDATE_DELAY time
GAME_UI_ITEM_UPDATE_DELAY = 80
game_ui_draw_items:
			lxi h, @delay
			dcr m
			rnz
			mvi m, GAME_UI_ITEM_UPDATE_DELAY

			lxi h, game_ui_item_visible_addr
			mov e, m
			mvi d, >global_items
			mvi c, <global_items + ITEM_ID_UI_MAX
			mvi b, ITEM_ID_UI_MAX
			; de - addr to the currently shown item on the ui panel
@loop:
			inx d
			; check if addr in the range
			mov a, e
			cmp c
			jc @check_amount
			; clamp the ptr to the ITEM_ID_UI_MAX range
			mvi e, <global_items
@check_amount:
			; check if available
			ldax d
			cpi ITEM_STATUS_ACQUIRED
			jz @draw
			dcr b
			jnz @loop
			; no available items
			lxi d, __tiled_images_item_key_empty
			jmp @draw_icon
@draw:
			mov m, e
			; de - ptr to the item amount
			; make item_id
			mov a, e
			sui <global_items

			; a - item_id
			HL_TO_AX2_PLUS_INT16(@tiled_img_ptrs)
			mov e, m
			inx h
			mov d, m
@draw_icon:
			; de - ptr to an img
			mvi a, <__RAM_DISK_S_TILED_IMAGES_DATA
			jmp draw_tiled_img

@delay:		.byte TEMP_WORD

@tiled_img_ptrs:
			.word __tiled_images_item_key_0
			.word __tiled_images_item_key_1
			.word __tiled_images_item_key_1
			.word __tiled_images_item_key_2
			.word __tiled_images_item_key_3