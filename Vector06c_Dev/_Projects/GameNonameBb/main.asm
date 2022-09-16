;.setting "OmitUnusedFunctions", true

.include "macro.asm"
.include "globalConsts.asm"
; init.asm must be the first code inclusion
.include "init.asm"
.include "globalVars.asm"

.include "utils.asm"
.include "interruptions.asm"
.include "ramDisk.asm"

.include "ramDiskBank0_addr0Labels.asm"
.include "ramDiskBank0_addr8000Labels.asm"
.include "ramDiskBank1_addrA000Labels.asm"
.include "ramDiskBank2_addr8000Labels.asm"

.include "generated\\sprites\\heroAnim.dasm"
.include "generated\\sprites\\skeletonAnim.dasm"

.include "gigachad16Player.asm"
.include "game.asm"

Start:
			call RamDiskInit
			call GCPlayerInit
@mainLoop:
			;call MainMenu
			call GameInit

			jmp @mainLoop
			.closelabels
			.end
