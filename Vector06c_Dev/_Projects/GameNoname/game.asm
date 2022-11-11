.include "levelsGlobalData.asm"
.include "drawTile.asm"
.include "sprite.asm"
.include "hero.asm"
.include "monsters.asm"
.include "levels.asm"
.include "room.asm"
.include "text.asm"

.include "temp/test/ramDisk_sprite_test.asm"

GameInit:
			call LevelsInit
			call LevelInit
			call RoomInit

			; TODO: test
			call RamDiskInit_sprite_test

			call RoomDraw

			xra a
			sta interruptionCounter
			hlt
@gameLoop:
			CALL_RAM_DISK_FUNC(__GCPlayerStartRepeat, RAM_DISK_S1 | RAM_DISK_M1 | RAM_DISK_M_8F)
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

			call HeroDraw
			call MonstersDraw

			call HeroCopyToScr
			call MonstersCopyToScr

			call HeroErase
			call MonstersErase

			ret
			.closelabels



