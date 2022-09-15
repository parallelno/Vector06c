.include "levelsGlobalData.asm"


.include "drawTile.asm"
.include "sprite.asm"
.include "hero.asm"
.include "monsters.asm"
.include "levels.asm"
.include "text.asm"

GameInit:
			call LevelsInit
			call LevelInit
			call RoomInit
			call RoomDraw

			xra a
			sta interruptionCounter
			hlt
@gameLoop:
			call GCPlayerStartRepeat
			call GameUpdate
			call GameDraw

			DEBUG_BORDER_LINE(1)
			DEBUG_HLT()
			jmp	 @gameLoop

GameUpdate:
			; check if an interuption happened
			lda interruptionCounter
			ora a
			rz
@updateLoop:
			; TODO: consider having update in the interruption
			; every second frame (25fps)
			DEBUG_BORDER_LINE(4)
			call HeroUpdate
			DEBUG_BORDER_LINE(2)
			call MonstersUpdate
			DEBUG_BORDER_LINE(3)
			call LevelUpdate

			lda keyCode
			sta keyCode+1

			lxi h, interruptionCounter
			dcr m
			jnz @updateLoop
			ret
			.closelabels

GameDraw:
			lxi h, gameDrawsPerInt
			inr m

			DEBUG_BORDER_LINE(5)
			call HeroErase2

			DEBUG_BORDER_LINE(6)
			call HeroDraw

			DEBUG_BORDER_LINE(0)
			;call MonstersDraw

			DEBUG_BORDER_LINE(7)
			call HeroCopyToScr

			ret
			.closelabels


