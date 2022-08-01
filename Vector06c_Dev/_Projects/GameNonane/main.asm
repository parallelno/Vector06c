;-------------------------------------------------
;|                                               |
;|     Sprite Rendering Speed Test		         |
;|     											 |
;|     Original ver. 2020						 |
;|     by KTSerg aka Sergey Cherkozianov		 |
;-------------------------------------------------

;.setting "OmitUnusedFunctions", true

.include "macro.asm"
.include "init.asm"
.include "globalVars.asm"
; subs
.include "utils.asm"
.include "interruptions.asm"

.include "game.asm"

Start:
			
@mainLoop:
			;call Menu
			call GameInit

			jmp @mainLoop
			.closelabels
			.end