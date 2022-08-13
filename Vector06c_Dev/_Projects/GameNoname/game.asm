.include "levelsGlobalData.dasm"

.include "drawTile.asm"
.include "sprite.asm"
.include "hero.asm"
.include "monsters.asm"
.include "levels.asm"

;.include "testDrawSpriteVSpeed.asm"

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

; TEST vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
			BORDER_LINE(1)
; TEST ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

			hlt
; TEST vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
			BORDER_LINE(9)
; TEST ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
			ret
@updateLoop:
			call HeroUpdate
			call MonstersUpdate
			call LevelUpdate

			lda keyCode
			sta keyCode+1

			lxi h, interruptionCounter
			dcr M
			jnz @updateLoop
			ret
			.closelabels
			

GameDraw:
			call HeroDraw			
			call MonstersDraw
			;call TestDrawSpriteVSpeed
			ret
			.closelabels
			


