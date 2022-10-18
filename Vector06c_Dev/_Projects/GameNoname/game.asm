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
			lxi h, gameUpdateCounter
			inr m

			; check if an interuption happened
			lda interruptionCounter
			ora a
			rz
@updateLoop:
			; TODO: optimize. consider having an update func called every second frame (25fps)
			DEBUG_BORDER_LINE(4)
			call HeroUpdate
			DEBUG_BORDER_LINE(2)
			call MonstersUpdate
			DEBUG_BORDER_LINE(3)
			call LevelUpdate

			; to check repeated key-pressing
			lhld keyCode
			shld keyCodeOld

			lxi h, interruptionCounter
			dcr m
			jnz @updateLoop
			ret
			.closelabels

GameDraw:
			lxi h, gameDrawsCounter
			inr m

			call HeroErase
			call MonstersErase

			call HeroDraw

			call MonstersDraw

			call HeroCopyToScr
			call MonstersCopyToScr

			ret
			.closelabels



