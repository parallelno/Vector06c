.include "levelsGlobalData.asm"

.include "ramDiskBank0_addr0Labels.asm"
.include "ramDiskBank0_addr8000Labels.asm"

.include "generated\\sprites\\heroAnim.dasm"
.include "generated\\sprites\\skeletonAnim.dasm"

.include "drawTile.asm"
.include "sprite.asm"
.include "hero.asm"
.include "monsters.asm"
.include "levels.asm"

GameInit:
			call LevelsInit
			call LevelInit
			call RoomInit
			call RoomDraw

			xra a
			sta interruptionCounter
			hlt
@gameLoop:
			call GCPlayerStartCheck
			// di
			// call GCPlayerUpdate
			// ei
			call GameUpdate
			call GameDraw

; TEST vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
			BORDER_LINE(1)
; TEST ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
			;hlt
; TEST vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
			BORDER_LINE(9)
; TEST ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

			jmp	 @gameLoop

GameUpdate:
			lda interruptionCounter
			ora a
			jnz	@updateLoop
			ret

@updateLoop:
			call HeroUpdate
			call MonstersUpdate
			call LevelUpdate

			lda keyCode
			sta keyCode+1

			lxi h, interruptionCounter
			dcr m
			jnz @updateLoop
			ret
			.closelabels
			

GameDraw:
			call HeroDraw			
			call MonstersDraw
			ret
			.closelabels
			


