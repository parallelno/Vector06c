
; the first screen buffer X
HERO_RUN_SPEED		= $0100 ; it's a dword, low byte is a subpixel speed
HERO_RUN_SPEED_D	= $00b5 ; for diagonal moves

HERO_ANIM_TIMER_DELTA	= 90
; this's a struct. do not change the layout
heroData:
heroAnimTimer:		.byte TEMP_BYTE ; used to trigger change a anim frame
heroAnimAddr:		.word TEMP_WORD
heroDirX:			.byte 1 		; 1-right, 0-left
heroEraseScrAddr:	.word TEMP_ADDR
heroEraseScrAddrOld	.word TEMP_ADDR
heroEraseWH:		.word TEMP_WORD
heroEraseWHOld:		.word TEMP_WORD
heroX:				.word TEMP_WORD
heroY:				.word TEMP_WORD
heroSpeedX:			.word TEMP_WORD
heroSpeedY:			.word TEMP_WORD

; hero uses these funcs to handle the tile data. more info is in levelGlobalData.dasm->roomTilesData
heroFuncTable:		.word 0, 0, 0, HeroMoveTeleport, 0, 0, 0, 0

HeroInit:
			call HeroStop
			lxi h, heroX+1
			call GetSpriteScrAddr8
			xchg
			shld heroEraseScrAddr
			shld heroEraseScrAddrOld
			; 16x15 size
			lxi h, 1<<8 | 15
			shld heroEraseWH
			shld heroEraseWHOld
			ret
			.closelabels
HeroStop:
			lxi h, 0
			shld heroSpeedX
			shld heroSpeedY
			shld keyCode0
			ret
			.closelabels

; input:
; b - posX
; c - posY
; use:
; a
HeroSetPos:
			mov a, b
			sta heroX+1
			mov a, c
			sta heroY+1
			ret
			.closelabels

.macro CHECK_HERO_PREV_KEY()
			lxi h, keyCode0+1
			cmp m
			jz HeroMove
.endmacro

HeroUpdate:
			; anim update
			lxi h, heroAnimTimer
			mvi a, HERO_ANIM_TIMER_DELTA
			add m
			mov m, a
			jnc @skipAnimUpdate
			lhld heroAnimAddr
			mov e, m
			inx h
			mov d, m
			dad d
			shld heroAnimAddr
@skipAnimUpdate:

			lda keyCode0
			; if no key pressed, play idle
			cpi $ff
			jnz @setAnimRunR

			; if it's the same key as the prev frame, return
			CHECK_HERO_PREV_KEY()

			lxi h, 0
			shld heroSpeedX
			shld heroSpeedY

			lda heroDirX
			ora a
			jz @setAnimIdleL

			lxi h, hero_idle_r
			shld heroAnimAddr
			jmp HeroMove
@setAnimIdleL
			lxi h, hero_idle_l
			shld heroAnimAddr
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
			lxi h, hero_run_r
			shld heroAnimAddr
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
			lxi h, hero_run_r
			shld heroAnimAddr
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
			lxi h, hero_run_r
			shld heroAnimAddr
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
			lxi h, hero_run_l
			shld heroAnimAddr
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
			lxi h, hero_run_l
			shld heroAnimAddr
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
			lxi h, hero_run_l
			shld heroAnimAddr
			jmp HeroMove

@setAnimRunU:
			cpi KEY_UP
			jnz @setAnimRunD

			CHECK_HERO_PREV_KEY()

			lxi h, 0
			shld heroSpeedX
			lxi h, HERO_RUN_SPEED
			shld heroSpeedY

			lda heroDirX
			ora a
			jz @setAnimRunUfaceL

			lxi h, hero_run_r
			shld heroAnimAddr
			jmp HeroMove
@setAnimRunUfaceL:
			lxi h, hero_run_l
			shld heroAnimAddr
			jmp HeroMove
@setAnimRunD:
			cpi KEY_DOWN
			rnz

			CHECK_HERO_PREV_KEY()

			lxi h, 0
			shld heroSpeedX
			lxi h, $ffff - HERO_RUN_SPEED + 1
			shld heroSpeedY

			lda heroDirX
			ora a
			jz @setAnimRunDfaceL
			lxi h, hero_run_r
			shld heroAnimAddr
			jmp HeroMove
@setAnimRunDfaceL:
			lxi h, hero_run_l
			shld heroAnimAddr
			;jmp HeroMove

HeroMove:
			; apply the hero speed
			lhld heroX
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
; TODO: handle the case where the hero touches the wall tiles.
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
; TODO: fix the issue that hero can't teleport if he touches a wall nearby (top exit)
HeroMoveTeleport:
			pop h
			; update a room id to teleport there
			sta roomIdx
			; is the teleport of the left or right side?
			lda heroX+1
			cpi (ROOM_WIDTH - 2 ) * TILE_WIDTH
			jnc @teleportLeftRight
			cpi TILE_WIDTH + 2
			jc @teleportLeftRight
			; is the teleport of the top or bottom side?
			lda heroY+1
			cpi (ROOM_HEIGHT - 3 ) * TILE_WIDTH
			jnc @teleportTopBottom
			cpi TILE_HEIGHT * 2 + 2
			jc @teleportTopBottom
			jmp @donotMoveHero

@teleportLeftRight:
			; if the hero is on the right, move him to the left and vice versa
			lda heroX+1
			cma
			sui 15
			sta heroX+1
			jmp @donotMoveHero

			; if the hero is on the top, move him down and vice versa
@teleportTopBottom:
			lda heroY+1
			cma
			sui 30
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

HeroErase:
			; TODO: update initializations of heroEraseScrAddr and heroEraseWH
			; when the level starts, and hero teleports
			; TODO: erease only that is outside of the updated hero pos
			lhld heroEraseScrAddr
			xchg
			lhld heroEraseWH
			CALL_RAM_DISK_FUNC(__EraseSpriteSP, RAM_DISK0_B2_STACK_B2_8AF_RAM)
			ret
			.closelabels

HeroDraw:
			lxi h, heroX+1
			call GetSpriteScrAddr8

			lhld heroAnimAddr
			call GetSpriteAddr

			; TODO: consider using unrolled loops in DrawSpriteVM for sprites 15 pxs tall
			CALL_RAM_DISK_FUNC(__DrawSpriteV, RAM_DISK0_B0_STACK_B2_8AF_RAM)

			; store an old scr addr, width, and height
			lxi h, heroEraseScrAddr
			mov m, c
			inx h
			mov m, b
			xchg
			shld heroEraseWH
			ret

HeroCopyToScr:
			; get min(h, d), min(e,l)
			lhld heroEraseScrAddrOld
			xchg
			lhld heroEraseScrAddr
			mov a, h
			cmp d
			jc @keepCurrentX
			mov h, d
@keepCurrentX:
			mov a, l
			cmp e
			jc @keepCurrentY
			mov l, e
@keepCurrentY:
			; hl - a scr addr to copy
			push h
			; de - an old sprite scr addr
			lhld heroEraseWHOld
			dad d
			push h
			lhld heroEraseScrAddr
			; store as old
			shld heroEraseScrAddrOld
			xchg
			lhld heroEraseWH
			; store as old
			shld heroEraseWHOld
			dad d
			; hl - current sprite top-right corner scr addr
			; de - old sprite top-right corner scr addr
			pop d
			; get the max(h, d), max(e,l)
			mov a, h
			cmp d
			jnc @keepCurrentTRX
			mov h, d
@keepCurrentTRX:
			mov a, l
			cmp e
			jnc @keepCurrentTRY
			mov l, e
@keepCurrentTRY:
			; hl - top-right corner scr addr to copy
			; de - a scr addr to copy
			pop d
			; calc width and height
			mov a, h
			sub d
			mov h, a
			mov a, l
			sub e
			mov l, a
			; hl - width, height
			jmp CopySpriteToScrV