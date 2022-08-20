;.setting "OmitUnusedFunctions", true

.include "macro.asm"
.include "globalConsts.asm"
;.include "init.asm"
;.include "globalVars.asm"
; subs
;.include "utils.asm"
;.include "interruptions.asm"

;.include "ramDisk.asm"
;.include "game.asm"
Start:
			.org $100
			call StartTestMusic
			.include "musicZX0Stream.asm"
			;lxi h, regData00
			;lxi d, unpacked
			;call DLz77
			;lxi h, unpacked
			;lxi d, original
			;lxi b, originalEnd
			;call Dlz77Check
			jmp *
			;.include "dlz77.asm"

			;.include "music_lz77.asm"
			;call StartTestMusic

			;call RamDiskInit

@mainLoop:
					;call Menu
			;call GameInit

			;jmp @mainLoop
			;.closelabels
;org $200
;.incbin "songLz77.bin"

/*
.org $200		
regData00:		
.incbin "song00.bin.lz77"
.org $900			
unpacked:
			.word 0
.org $1900			
original:
.incbin "song00.bin.unpack"
originalEnd:
			.byte 0
*/
			.end
