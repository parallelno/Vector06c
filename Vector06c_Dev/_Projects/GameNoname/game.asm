.include "levelsData.asm"
.include "drawTile.asm"
.include "sprite.asm"
.include "hero.asm"
.include "monsters.asm"
.include "bullets.asm"
.include "levels.asm"
.include "room.asm"
.include "text.asm"
.include "ui.asm"

GameInit:
			call LevelsInit
			call LevelInit			
			call RoomInit
			call RoomDraw
			call GameUIInit			

			xra a
			sta updateRequestCounter
			hlt
@gameLoop:
			CALL_RAM_DISK_FUNC(__GCPlayerStartRepeat, __RAM_DISK_S_GCPLAYER | __RAM_DISK_M_GCPLAYER | RAM_DISK_M_8F)
			call GameUpdate
			call GameDraw
			jmp	 @gameLoop

GameUpdate:
			lxi h, gameUpdateCounter
			inr m

			; check if an interuption happened
			lda updateRequestCounter
			ora a
			rz
@updateLoop:
			call HeroUpdate
			call MonstersUpdate
			call BulletsUpdate
			call LevelUpdate

			; to check repeated key-pressing
			lhld keyCode
			shld keyCodeOld

			lxi h, updateRequestCounter
			dcr m
			jnz @updateLoop
			ret

GameDraw:
			lxi h, gameDrawsCounter
			inr m

			call HeroDraw
			call MonstersDraw
			call BulletsDraw

			call HeroCopyToScr
			call MonstersCopyToScr
			call BulletsCopyToScr

			call HeroErase
			call MonstersErase
			call BulletsErase
			ret



