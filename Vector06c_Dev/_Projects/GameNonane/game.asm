.include "drawTile.asm"
.include "hero.asm"

; data
.include "levelsGlobals.dasm"
.include "levels.asm"

InitGame:
			call 	InitLevels
			call	InitLevel
			call	initRoom
			call	DrawRoom

			mvi		a, 0
			lda		interruptionCounter
@gameLoop:
			
			call	GameUpdate
			call	GameDraw
			jmp		@gameLoop

GameUpdate:
			lda interruptionCounter
			ora a
			jnz	@updateLoop
			hlt
			ret
@updateLoop:
			call	UpdateHero

			lda keyCode
			sta keyCode+1

			lxi h, interruptionCounter
			dcr M
			jnz @updateLoop
			ret
			.closelabels
			

GameDraw:
			call	DrawHero
			ret
			.closelabels
			


