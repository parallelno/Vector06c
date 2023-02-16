.setting "Debug", true

.include "asm\\globals\\macro.asm"
.include "asm\\globals\\global_consts.asm"
; init.asm must be the first code inclusion
.include "asm\\globals\\main_init.asm"
.include "asm\\globals\\global_vars.asm"

.include "asm\\globals\\utils.asm"
.include "asm\\globals\\interruptions.asm"
.include "generated\\code\\ram_disk_init.asm"
.include "asm\\game.asm"

main_start:
			CALL_RAM_DISK_FUNC(__gc_player_init, __RAM_DISK_M_GCPLAYER | RAM_DISK_M_8F)
@mainLoop:
			;call main_menu
			call game_init
			jmp @mainLoop

code_seg_end:
; the ram disk data below will be moved into the ram-disk before the game starts. 
; that means if it is stored at the end of the program, everything that is go
; to the ram-disk can overlap the screen addrs.
.include "generated\\code\\ram_disk_data.asm"
.end