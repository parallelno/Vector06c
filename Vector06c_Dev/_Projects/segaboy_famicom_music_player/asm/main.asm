.setting "Debug", true

.include "asm\\globals\\macro.asm"
.include "asm\\globals\\global_consts.asm"
; main_init must be the first code inclusion
.include "asm\\globals\\main_init.asm"
.include "asm\\globals\\global_vars.asm"

.include "asm\\globals\\utils.asm"
.include "asm\\globals\\interruptions.asm"

.include "asm\\music_player_segaboy_famicom.asm"

main_start:
			call music_player_segaboy_init

stop_prg:
			jmp stop_prg

palette:
			.storage 16
palette_update_request:
			.byte 0

.end