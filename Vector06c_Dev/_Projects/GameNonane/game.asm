.include "drawTile.asm"
;.include "hero.asm"
.include "skeleton.asm"

; data
.include "levelsGlobals.dasm"
.include "levels.asm"

GameInit:
			call LevelsInit
			call LevelInit
			call RoomInit
			call RoomDraw

			xra a
			sta interruptionCounter
@gameLoop:
			
			call GameUpdate
			call GameDraw
			jmp	 @gameLoop

GameUpdate:
			lda interruptionCounter
			ora a
			jnz	@updateLoop
			hlt
			ret
@updateLoop:
			call HeroUpdate

			lda keyCode
			sta keyCode+1

			lxi h, interruptionCounter
			dcr M
			jnz @updateLoop
			ret
			.closelabels
			

GameDraw:
			call	HeroDraw
			ret
			.closelabels
			


