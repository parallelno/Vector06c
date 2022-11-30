.setting "Debug", true

.include "macro.asm"
.include "globalConsts.asm"
; init.asm must be the first code inclusion
.include "init.asm"
.include "globalVars.asm"

.include "utils.asm"
.include "interruptions.asm"
.include "generated\\code\\ramDiskInit.asm"
.include "game.asm"

MainStart:
			CALL_RAM_DISK_FUNC(__GCPlayerInit, __RAM_DISK_M_GCPLAYER | RAM_DISK_M_8F)
@mainLoop:
			;call MainMenu
			call GameInit
			jmp @mainLoop

.include "generated\\code\\ramDiskData.asm"
.end