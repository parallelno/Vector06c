.setting "Debug", true

.include "asm\\globals\\macro.asm"
.include "asm\\globals\\global_consts.asm"
; main_init must be the first code inclusion
.include "asm\\globals\\main_init.asm"
.include "asm\\globals\\global_vars.asm"

.include "asm\\globals\\utils.asm"
.include "asm\\globals\\controls.asm"
.include "asm\\globals\\interruptions.asm"
.include "generated\\code\\ram_disk_init.asm"
.include "asm\\game_utils.asm"
.include "asm\\screens\\screen_utils.asm"
.include "asm\\screens\\main_menu.asm"
.include "asm\\screens\\credits.asm"
.include "asm\\screens\\scores.asm"
.include "asm\\screens\\settings.asm"
.include "asm\\game.asm"

main_start:
			CALL_RAM_DISK_FUNC(__sound_init, __RAM_DISK_M_GCPLAYER | RAM_DISK_M_8F)
			lxi b, __font_gfx
			CALL_RAM_DISK_FUNC(__draw_text_ex_rd_init, __RAM_DISK_S_FONT | __RAM_DISK_M_TEXT_EX)
@loop:
			lda global_request
			cpi GLOBAL_REQ_MAIN_MENU
			cz main_menu
			cpi GLOBAL_REQ_GAME
			cz main_game
			cpi GLOBAL_REQ_CREDITS
			cz credits_screen
			cpi GLOBAL_REQ_SCORES
			cz scores_screen
			cpi GLOBAL_REQ_OPTIONS
			cz settings_screen		
			jmp @loop

code_seg_end:
; the ram disk data below will be moved into the ram-disk before the game starts. 
; that means if it is stored at the end of the program, everything that goes
; to the ram-disk can overlap the screen addrs.
.include "generated\\code\\ram_disk_data.asm"
.end