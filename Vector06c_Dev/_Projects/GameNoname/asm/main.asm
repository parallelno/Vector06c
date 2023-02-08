.setting "Debug", true

.include "asm\\globals\\macro.asm"
.include "asm\\globals\\global_consts.asm"
; init.asm must be the first code inclusion
.include "asm\\globals\\init.asm"
.include "asm\\globals\\global_vars.asm"

.include "asm\\globals\\utils.asm"
.include "asm\\globals\\interruptions.asm"
.include "generated\\code\\ram_disk_init.asm"
.include "asm\\game.asm"

main_start:
			CALL_RAM_DISK_FUNC(__GCPlayerInit, __RAM_DISK_M_GCPLAYER | RAM_DISK_M_8F)
@mainLoop:
			;call MainMenu
			call GameInit
			jmp @mainLoop

.include "generated\\code\\ram_disk_data.asm"
.end