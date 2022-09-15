
; the first screen buffer X
HERO_RUN_SPEED		= $0100 ; it's a dword, low byte is a subpixel speed
HERO_RUN_SPEED_D	= $00b5 ; for diagonal moves

; this's a struct. do not change the layout
heroData:
heroDirX:			.byte 1 ; 1-right, 0-left
heroEraseScrAddr:	.word TEMP_ADDR
heroEraseScrAddrOld .word TEMP_ADDR
heroEraseWH:		.word TEMP_WORD ; (width<<8 | height)
heroX:				.word TEMP_WORD
heroY:				.word TEMP_WORD
heroSpeedX:			.word TEMP_WORD
heroSpeedY:			.word TEMP_WORD

; hero uses these funcs to handle the tile data. more info is in levelGlobalData.dasm->roomTilesData 
heroFuncTable:		.word 0, 0, 0, HeroMoveTeleport, 0, 0, 0, 0 

HeroInit:
            call HeroStop
			; heroData access
			lxi h, heroX+1
			call GetSpriteScrAddr
			xchg
			shld heroEraseScrAddr
			shld heroEraseScrAddrOld
			; 16x15 size
			lxi h, 1<<8 | 15
			shld heroEraseWH
			ret
			.closelabels
HeroStop:
			; heroData access
			lxi h, 0
			shld heroSpeedX	
			shld heroSpeedY
			shld keyCode
			ret
			.closelabels

; input:
; b - posX
; c - posY
; use:
; a
HeroSetPos:
			; heroData access
			mov a, b
			sta heroX+1
			mov a, c
			sta heroY+1
			ret
			.closelabels

.macro CHECK_HERO_PREV_KEY()
			lxi h, keyCode+1
			cmp m
			jz HeroMove
.endmacro		
			
HeroUpdate:
			lda keyCode

			; if no key pressed, play idle
			cpi $ff
			jnz @setAnimRunR
			
			; if it's the same key as the prev frame, return
			CHECK_HERO_PREV_KEY()

			; heroData access
			lxi h, 0
			shld heroSpeedX
			shld heroSpeedY

			lxi h, GetSpriteAddr
			shld HeroDrawSpriteAddrFunc+1

			lda heroDirX
			ora a
			jz @setAnimIdleL

			lxi h, hero_idle_r
			shld HeroDrawAnimAddr+1
			jmp HeroMove
@setAnimIdleL
			lxi h, hero_idle_l
			shld HeroDrawAnimAddr+1
			jmp HeroMove

@setAnimRunR:
			cpi KEY_RIGHT
			jnz @setAnimRunRU
			
			CHECK_HERO_PREV_KEY()

			lxi h, HERO_RUN_SPEED
			shld heroSpeedX
			lxi h, 0
			shld heroSpeedY

			mvi a, 1
			sta heroDirX
			lxi h, hero_run_r0
			shld HeroDrawAnimAddr+1
			lxi h, GetSpriteAddr
			shld HeroDrawSpriteAddrFunc+1
			jmp HeroMove

@setAnimRunRU:
			cpi KEY_RIGHT_UP
			jnz @setAnimRunRD
			
			CHECK_HERO_PREV_KEY()

			lxi h, HERO_RUN_SPEED_D
			shld heroSpeedX
			shld heroSpeedY

			mvi a, 1
			sta heroDirX
			lxi h, hero_run_r0
			shld HeroDrawAnimAddr+1
			lxi h, GetSpriteAddr
			shld HeroDrawSpriteAddrFunc+1
			jmp HeroMove

@setAnimRunRD:
			cpi KEY_RIGHT_DOWN
			jnz @setAnimRunL
			
			CHECK_HERO_PREV_KEY()

			lxi h, HERO_RUN_SPEED_D
			shld heroSpeedX
			lxi h, $ffff - HERO_RUN_SPEED_D + 1
			shld heroSpeedY

			mvi a, 1
			sta heroDirX
			lxi h, hero_run_r0
			shld HeroDrawAnimAddr+1
			lxi h, GetSpriteAddr
			shld HeroDrawSpriteAddrFunc+1
			jmp HeroMove			

@setAnimRunL:
			cpi KEY_LEFT
			jnz @setAnimRunLU

			CHECK_HERO_PREV_KEY()

			lxi h, $ffff - HERO_RUN_SPEED + 1
			shld heroSpeedX
			lxi h, 0
			shld heroSpeedY

			xra a
			sta heroDirX
			lxi h, hero_run_l0
			shld HeroDrawAnimAddr+1
			lxi h, GetSpriteAddr
			shld HeroDrawSpriteAddrFunc+1	
			jmp HeroMove

@setAnimRunLU:
			cpi KEY_LEFT_UP
			jnz @setAnimRunLD

			CHECK_HERO_PREV_KEY()

			lxi h, $ffff - HERO_RUN_SPEED_D + 1
			shld heroSpeedX
			lxi h, HERO_RUN_SPEED_D
			shld heroSpeedY

			xra a
			sta heroDirX
			lxi h, hero_run_l0
			shld HeroDrawAnimAddr+1
			lxi h, GetSpriteAddr
			shld HeroDrawSpriteAddrFunc+1	
			jmp HeroMove

@setAnimRunLD:
			cpi KEY_LEFT_DOWN
			jnz @setAnimRunU

			CHECK_HERO_PREV_KEY()

			lxi h, $ffff - HERO_RUN_SPEED_D + 1
			shld heroSpeedX
			shld heroSpeedY

			xra a
			sta heroDirX
			lxi h, hero_run_l0
			shld HeroDrawAnimAddr+1
			lxi h, GetSpriteAddr
			shld HeroDrawSpriteAddrFunc+1	
			jmp HeroMove

@setAnimRunU:
			cpi KEY_UP
			jnz @setAnimRunD

			CHECK_HERO_PREV_KEY()

			lxi h, 0
			shld heroSpeedX
			lxi h, HERO_RUN_SPEED
			shld heroSpeedY

			lxi h, GetSpriteAddrRunV
			shld HeroDrawSpriteAddrFunc+1

			lda heroDirX
			ora a
			jz @setAnimRunUfaceL

			lxi h, hero_run_r0
			shld HeroDrawAnimAddr+1
			jmp HeroMove
@setAnimRunUfaceL:
			lxi h, hero_run_l0
			shld HeroDrawAnimAddr+1
			jmp HeroMove
@setAnimRunD:
			cpi KEY_DOWN
			rnz

			CHECK_HERO_PREV_KEY()

			lxi h, 0
			shld heroSpeedX
			lxi h, $ffff - HERO_RUN_SPEED + 1
			shld heroSpeedY		

			lxi h, GetSpriteAddrRunV
			shld HeroDrawSpriteAddrFunc+1
			
			lda heroDirX
			ora a
			jz @setAnimRunDfaceL
			lxi h, hero_run_r0
			shld HeroDrawAnimAddr+1		
			jmp HeroMove
@setAnimRunDfaceL:
			lxi h, hero_run_l0
			shld HeroDrawAnimAddr+1
			;jmp HeroMove

HeroMove:
			; heroData access
			; apply the hero speed (call addr 4685)
			lhld heroX ; 2c09, data addr 29fe
			xchg
			lhld heroSpeedX
			dad d
			mov b, h
			shld charTempX ; 12a
			lhld heroY
			xchg
			lhld heroSpeedY
			dad d
			mov c, h
			shld charTempY
			; check hero pos against the room collision tiles
			call CheckRoomTilesCollision
			; check if any tiles collide
			
			cpi $ff
			jz @tempCheck;rz ; return if any of the tiles were collision
			ora a ; if all the tiles data == 0, means no collision.
			jnz @collides
@updatePos:			
			lhld charTempX
			shld heroX
			lhld charTempY
			shld heroY
			ret
; TODO: handle this case
; for example, slide a hero along the walls if he moves along the diagonal directions
@tempCheck: 
lhld charTempX
ret

@collides:
			; handle collided tiles data
			lxi h, collidedRoomTilesData
			mvi c, 4
@loop:
			TILE_DATA_HANDLE_FUNC_CALL(heroFuncTable)

			inx h
			dcr c
			jnz @loop
			ret
			.closelabels

; load a new room with roomId, move the hero to an
; appropriate position based on his current posXY
; input:
; a - roomId
; TODO: fix the issue that hero can't teleport if he touches a wall nearby
HeroMoveTeleport:
			; heroData access
			pop h
			; update a room id to teleport there
			sta roomIdx
			; is the teleport of the left or right side?
			lda heroX+1
			cpi (ROOM_WIDTH - 2 ) * TILE_WIDTH
			jnc @teleportLR
			cpi TILE_WIDTH + 2
			jc @teleportLR
			; is the teleport of the top or bottom side?
			mvi c, 2
			lda heroY+1
			cpi (ROOM_HEIGHT - 2 ) * TILE_WIDTH
			jnc @teleportB
			cpi TILE_HEIGHT * 2 + 2
			jc @teleportT
			jmp @donotMoveHero

@teleportLR:
			; if the hero is on the right, move him to the left and vice versa
			lda heroX+1
			cma
			sui 15
			sta heroX+1
			jmp @donotMoveHero

			; if the hero is on the top, move him down and vice versa
@teleportB:
			mvi c, 0
@teleportT:
			lda heroY+1
			cma
			sub c
			sta heroY+1
			jmp @donotMoveHero	

@donotMoveHero:
			mvi a, LEVEL_COMMAND_LOAD_DRAW_ROOM
			sta levelCommand
			; bypassing the HeroMove:@loop because the hero is teleporting
			; so we don't need to handle the rest of the colllided tiles.
			; we return to the func that called HeroUpdate
			pop b
			ret
			.closelabels
			
HeroErase2:
			; heroData access
			; TODO: update initializations of heroEraseScrAddr and heroEraseWH 
			; when the level starts, and hero teleports
			; TODO: erease only that is outside of the updated hero pos
			lhld heroEraseScrAddr
			xchg
			lhld heroEraseWH
			jmp EraseSpriteSP2
			.closelabels
/*			
HeroErase:
			; heroData access
			; TODO: update initializations of heroEraseScrAddr and heroEraseWH 
			; when the level starts, and hero teleports
			; TODO: erease only that is outside of the updated hero pos
			lhld heroEraseScrAddr
			xchg
			lxi h, heroEraseWH
			mov c, m
			jmp EraseSpriteSP
			.closelabels			
*/
HeroDraw:
			; heroData access
			lxi h, heroX+1
			call GetSpriteScrAddr

HeroDrawAnimAddr:
			lxi h, hero_idle_r
HeroDrawSpriteAddrFunc:
			call GetSpriteAddr
			; TODO: consiider using an unrolled loop in DrawSpriteVM for sprites 15 pxs tall
			; TODO: draw hero first, and do not have mask in its gfx data
			call DrawSpriteVM

			; store an old scr addr, width, and height
			shld heroEraseScrAddr
			xchg
			shld heroEraseWH
			ret

HeroCopyToScr:
			lhld heroEraseScrAddr
			xchg
			lhld heroEraseWH
			jmp CopySpriteToScrV2

			; restore an old scr addr, width, and height
			lxi h, heroEraseWH
			mov c, m
			lhld heroEraseScrAddr
			xchg

			; TODO: replace heroSpeedY with DY in the code below
			; DY = Y - prevY
			lxi h, heroSpeedY+1
			mov a, m
			ora a
			; if heroSpeedY > 0, make a copying region taller by heroSpeedY
			jp CopySpriteToScrV2
			; if heroSpeedY < 0, make a copying region taller by abs(heroSpeedY)
			cma
			inr a
			mov b, a
			; if heroSpeedY < 0, move a copying region up by abs(speedY)
			; to clear the screen behind a sprite
			add e
			mov e, a
			mov a, b

			jmp CopySpriteToScrV2