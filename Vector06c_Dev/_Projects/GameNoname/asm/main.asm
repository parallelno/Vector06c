.setting "Debug", true

.include "asm\\globals\\macro.asm"
.include "asm\\globals\\globalConsts.asm"
; init.asm must be the first code inclusion
.include "asm\\globals\\init.asm"
.include "asm\\globals\\globalVars.asm"

.include "asm\\globals\\utils.asm"
.include "asm\\globals\\interruptions.asm"
.include "generated\\code\\ramDiskInit.asm"
.include "asm\\game.asm"

MainStart:
			CALL_RAM_DISK_FUNC(__GCPlayerInit, __RAM_DISK_M_GCPLAYER | RAM_DISK_M_8F)
@mainLoop:
			;call MainMenu
			call GameInit
			jmp @mainLoop

.include "generated\\code\\ramDiskData.asm"
.end