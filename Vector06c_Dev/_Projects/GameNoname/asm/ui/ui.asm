.include "..\\render\\text.asm"
.include "dialogs.asm"

HEALTH_SCR_ADDR = $a3fb
HERO_SCORE_SCR_ADDR = $b9fb
FPS_SCR_ADDR = $bdfb - 16

RES_TEXT_SCR_ADDR_0 = $a8fb
RES_SELECTION_FRAME_SCR_ADDR = $a000 + (6<<8) | 30*8
RES_DISPLAYED_MAX = 3

GAME_UI_ITEM_UPDATE_DELAY = 80

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
			jmp game_ui_draw_res

game_ui_update:
			call game_ui_draw_items
			jmp dialog_update


game_ui_draw_health_text:
			lxi h, hero_res_health
			lxi b, HEALTH_SCR_ADDR
			jmp draw_text_int8_ptr


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

; draw an FPS counter every second on the screen at FPS_SCR_ADDR addr
; works only in the interruption func and in the
; main program when the ram-disk is dismount
; in:
; A - fps
; uses:
; BC, DE, HL
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

;==================================================================================================
;
;	resource related routines
;
;==================================================================================================

; when a player hits action_2
; it selects the next non-empty resource
game_ui_res_select_next:			
			lxi h, game_ui_res_selected_id
			mov l, m
			mvi c, RES_SELECTABLE_MAX
			A_TO_ZERO(0)
			cmp l
			rz ; return if no available

			mvi h, >hero_resources
			; find the next available
@next_res:
			; check if the res_id is not out of range
			inr l
			mvi a, <RES_SELECTABLE_LAST + 1
			cmp l
			jnz @in_range
			mvi l, <RES_SELECTABLE_FIRST
@in_range:
			A_TO_ZERO(0)
			cmp m
			jnz game_ui_res_select
			dcr c
			jnz @next_res
			; selected the same resource, no need to redraw
			ret

; select the resource and draw resources
; if a resource is empty, select the first available
; in:
; hl - ptr to a resource ( ex. lxi h, hero_res_snowflake )
game_ui_res_select_and_draw:
			; check if a resource is not empty
			mov a, m
			CPI_WITH_ZERO(0)
			jnz @select_res
			call @get_first_available
@select_res:
			; hl - ptr to a resource
			; res_ptr to res_id
			mov a, l
			sta game_ui_res_selected_id
			jmp game_ui_draw_res
; out:
; l - res_id of the first non-empty resource
; l = 0 if all resources are empty
@get_first_available:
			lxi h, RES_SELECTABLE_FIRST
			mvi c, RES_SELECTABLE_MAX
			A_TO_ZERO(0)
@next_res:
			cmp m
			rnz
			inx h
			dcr c
			jnz @next_res
			; all res are empty
			mvi l, 0
			ret
game_ui_res_select: = @select_res

; draws available resource icons and a selection frame
; health and the score resources have their own dedicated draw functions
game_ui_draw_res:
			; check if no available res
			lxi h, game_ui_res_selected_id
			mov l, m
			A_TO_ZERO(0)
			cmp l
			jz @erase_all

			; find the first displayed res
			mvi c, RES_DISPLAYED_MAX
			mvi h, >hero_resources
			; l - selected res_id
@loop:
			mov a, m
			CPI_WITH_ZERO(0)
			jz @next
			
			; store an available res_id
			mov b, l
			dcr c
			jz @found_first_displayed

@next:
			dcr l
			mov a, l
			cpi <RES_SELECTABLE_FIRST
			jnc @loop

@found_first_displayed:
			; b - the first displayed res_id
			; store the displayed res counter
			mov a, c
			sta @draw_selection + 1
			mvi c, RES_DISPLAYED_MAX

@draw_loop:
			; b - res_id
			; c - displayed res counter
			; res_id to res_ptr
			mov l, b
			mvi h, >hero_resources
			; check if a res is available
			mov a, m
			CPI_WITH_ZERO(0)
			jz @draw_loop_next

			push b
			call @draw_res_icon
			pop b
			dcr c
			jz @draw_selection

@draw_loop_next:
			inr b
			; check if the res_id is not out of range
			mov a, b
			cpi <RES_SELECTABLE_LAST + 1
			jnz @draw_loop
			call @draw_empty_res_loop
			jmp @draw_selection

@draw_res_icon:
			; b - res_id
			; c - displayed res counter
			mov a, b
			; res_id to tiled graphics data ptr
			HL_TO_AX2_PLUS_INT16(@tiled_img_ptrs - RES_ID_SWORD * WORD_LEN) ; "- RES_ID_SWORD * WORD_LEN" because min value is RES_ID_SWORD

			mov e, m
			inx h
			mov d, m
			; de - tiled image data ptr
			; make the scr addr offset
			mvi a, RES_DISPLAYED_MAX
			sub c
			ADD_A(2) ; a * 4 because resources displayed every 4*8 pixels
			mov h, a
			mvi l, 0
			push b
			call @draw_icon
			pop b
@draw_res_text:
			; b - res_id
			; c - displayed res counter
			mov l, b
			mvi h, >hero_resources

			; make the scr addr offset	
			mvi a, RES_DISPLAYED_MAX
			sub c
			ADD_A(2)
			adi >RES_TEXT_SCR_ADDR_0
			mov b, a
			mvi c, <RES_TEXT_SCR_ADDR_0
			jmp draw_text_int8_ptr

@erase_all:
			mvi c, RES_DISPLAYED_MAX
@draw_empty_res_loop:
			push b
			call @draw_empty_res_icon
			pop b
			dcr c
			jnz @draw_empty_res_loop
			ret

@draw_empty_res_icon:
			; c - displayed res counter
			lxi d, __tiled_images_res_empty
			; de - tiled image data ptr
			; make the scr addr offset
			mvi a, RES_DISPLAYED_MAX
			sub c
			ADD_A(2) ; a * 4 because resources displayed every 4*8 pixels
			mov h, a
			mvi l, 0
			; hl - scr adr offset
@draw_icon:
			; de - ptr to an img
			mvi a, <__RAM_DISK_S_TILED_IMAGES_DATA
			jmp draw_tiled_img_pos_offset

@draw_selection:
			mvi c, TEMP_BYTE 
			; c - selected res counter
			; selected res counter to the scr addr
			mvi a, RES_DISPLAYED_MAX - 1 ; because selected res counter was decreased at least once
			sub c
			ADD_A(2) ; a * 4 because resources displayed every 4*8 pixels
			adi >RES_SELECTION_FRAME_SCR_ADDR
			mov d, a
			mvi e, <RES_SELECTION_FRAME_SCR_ADDR
			; de - scr addr
			; draw selection frame on a resouce
			lxi b, __vfx_selection_0
			CALL_RAM_DISK_FUNC(__draw_sprite_vm, __RAM_DISK_S_VFX | __RAM_DISK_M_DRAW_SPRITE_VM | RAM_DISK_M_89)
			ret

@tiled_img_ptrs:
			.word __tiled_images_res_sword
			.word __tiled_images_res_mana
			.word __tiled_images_res_tnt
			.word __tiled_images_res_potion_health
			.word __tiled_images_res_potion_mana
			.word __tiled_images_res_clothes
			.word __tiled_images_res_cabbage
			.word __tiled_images_res_spoon

;==================================================================================================
;
; draws an available item.
; it shows the next available item every game_update_time * GAME_UI_ITEM_UPDATE_DELAY time
;
;==================================================================================================
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
			lxi d, __tiled_images_item_empty
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
			.word __tiled_images_item_key_0	; item_id = 1
			.word __tiled_images_item_key_1	; item_id = 2
			.word __tiled_images_item_key_1	; item_id = 3
			.word __tiled_images_item_key_2	; item_id = 4
			.word __tiled_images_item_key_3	; item_id = 5
			.word __tiled_images_item_key_0 ; tmp ; id = 6