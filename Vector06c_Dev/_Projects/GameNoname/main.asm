;.setting "OmitUnusedFunctions", true

.include "macro.asm"
.include "globalConsts.asm"
.include "init.asm"
.include "globalVars.asm"

.include "utils.asm"
.include "interruptions.asm"

.include "ramDisk.asm"
;.include "gigachad16Player.asm"
.include "game.asm"

Start:
			call RamDiskInit
@mainLoop:
			;call MainMenu
			call GameInit

			jmp @mainLoop
			.closelabels

.include "gigachad16Player.asm"
			.end
