;.setting "OmitUnusedFunctions", true

;.include "macro.asm"
;.include "init.asm"
;.include "globalVars.asm"
; subs
;.include "utils.asm"
;.include "interruptions.asm"

;.include "ramDisk.asm"
;.include "game.asm"

Start:
			.include "music.asm"
			call StartTestMusic
			;call RamDiskInit

@mainLoop:
					;call Menu
			;call GameInit

			;jmp @mainLoop
			;.closelabels
			.end