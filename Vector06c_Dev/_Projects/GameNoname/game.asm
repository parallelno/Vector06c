.include "levelsGlobalData.asm"


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
			;call GameDraw
; TEST vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv			
			BORDER_LINE(6)
; TEST ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
			mvi c, HERO_DRAW_BOTTOM
			call HeroDraw
; TEST vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv			
			BORDER_LINE(0)
; TEST ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^						
			call MonstersDrawBottom


			call GCPlayerStartRepeat
			call GameUpdate

; TEST vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv			
			BORDER_LINE(0)
; TEST ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^						
			call MonstersDrawTop
; TEST vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv			
			BORDER_LINE(6)
; TEST ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
			mvi c, HERO_DRAW_TOP
			call HeroDraw
			call HeroRedrawTimerUpdate	

; TEST vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
			BORDER_LINE(1)
			hlt

			jmp	 @gameLoop

GameUpdate:
			lda interruptionCounter
			ora a
			jnz	@updateLoop
			ret

@updateLoop:
; TEST vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv			
			BORDER_LINE(4)
; TEST ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^	
			call HeroUpdate
; TEST vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv			
			BORDER_LINE(2)
; TEST ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^				
			call MonstersUpdate
; TEST vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv			
			BORDER_LINE(3)
; TEST ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^				
			call LevelUpdate

			lda keyCode
			sta keyCode+1

			lxi h, interruptionCounter
			dcr m
			jnz @updateLoop
			ret
			.closelabels
			

GameDraw:



			ret
			.closelabels
			


