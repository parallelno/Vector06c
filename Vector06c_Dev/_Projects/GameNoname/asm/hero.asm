HERO_RUN_SPEED		= $0200 ; low byte is a subpixel speed, high byte is a speed in pixels
HERO_RUN_SPEED_D	= $016a ; for diagonal moves

; hero statuses.
; a status describes what set of animations and behavior is active
; for ex. HERO_STATUS_ATTACK plays hero_r_attk or hero_l_attk depending on the direction and it spawns a weapon trail
HERO_STATUS_IDLE	= 0
HERO_STATUS_ATTACK	= 1

; duration of statuses (in updateDurations)
HERO_STATUS_ATTACK_DURATION	= 12

; animation speed (the less the slower, 0-255, 255 means next frame every update)
HERO_ANIM_SPEED_MOVE	= 65
HERO_ANIM_SPEED_IDLE	= 4
HERO_ANIM_SPEED_ATTACK	= 80

; gameplay
HERO_HEALTH_MAX = 100

HERO_COLLISION_WIDTH = 15
HERO_COLLISION_HEIGHT = 11

; hero runtime data
; this's a struct. do not change the layout
heroUpdatePtr:			.word hero_update
heroDrawPtr:			.word hero_draw
heroImpactPtr:			.word HeroImpact
heroType:				.byte MONSTER_TYPE_ALLY
heroHealth:				.byte HERO_HEALTH_MAX
heroStatus:				.byte HERO_STATUS_IDLE ; a status describes what set of animations and behavior is active
heroStatusTimer:		.byte 0	; a duration of the status. ticks every update
heroAnimTimer:			.byte TEMP_BYTE ; it triggers an anim frame switching when it overflows
heroAnimAddr:			.word TEMP_ADDR ; holds the current frame ptr
heroDirX:				.byte 1 		; 1-right, 0-left
heroEraseScrAddr:		.word TEMP_ADDR
heroEraseScrAddrOld		.word TEMP_ADDR
heroEraseWH:			.word TEMP_WORD
heroEraseWHOld:			.word TEMP_WORD
heroPosX:				.word TEMP_WORD
heroPosY:				.word TEMP_WORD
heroSpeedX:				.word TEMP_WORD
heroSpeedY:				.word TEMP_WORD
heroDataPrevPPtr:		.word DRAW_LIST_FIRST_DATA_MARKER
heroDataNextPPtr:		.word monsterDataNextPPtr
;
heroCollisionFuncTable:
			; bit layout:
			; (bottom-left), (bottom-right), (top_right), (top-left), 0         
			JMP_4(HeroCheckCollisionTL)
			JMP_4(HeroCheckCollisionTR)
			JMP_4(HeroMoveHorizontally)
			JMP_4(HeroCheckCollisionBR)
			JMP_4(HeroDontMove)
			JMP_4(HeroMoveVertically)
			JMP_4(HeroDontMove)
			JMP_4(HeroCheckCollisionBL)
			JMP_4(HeroMoveVertically)
			JMP_4(HeroDontMove)
			JMP_4(HeroDontMove)
			JMP_4(HeroMoveHorizontally)
			JMP_4(HeroDontMove)
			JMP_4(HeroDontMove)
			JMP_4(HeroDontMove)

; funcs to handle the tile data. more info is in levelGlobalData.asm->roomTilesData
HeroTileFuncTable:
			JMP_4(0)					; funcId == 1
			JMP_4(0)					; funcId == 2
			JMP_4(0)					; funcId == 3
			JMP_4(HeroTileFuncTeleport)	; funcId == 4
			JMP_4(0)					; funcId == 5
			JMP_4(0)					; funcId == 6
			JMP_4(HeroTileFuncNothing)	; funcId == 7 (collision) called only when a hero has got stuck into a collision tiles

HeroInit:
			call HeroIdleStart
			lxi h, KEY_NO << 8 | KEY_NO
			shld key_code

			lxi h, heroPosX+1
			call SpriteGetScrAddr8
			xchg
			shld heroEraseScrAddrOld
			; 16x15 size
			lxi h, SPRITE_W_PACKED_MIN<<8 | SPRITE_H_MIN
			shld heroEraseWHOld
			ret

; input:
; b - posX
; c - posY
; use:
; a
HeroSetPos:
			mov a, b
			sta heroPosX+1
			mov a, c
			sta heroPosY+1
			ret
			.closelabels

.macro HERO_UPDATE_ANIM(animSpeed)
			; anim idle update
			lxi h, heroAnimTimer
			mov a, m
			adi animSpeed
			mov m, a
			jnc @skipAnimUpdate
			lhld heroAnimAddr
			mov e, m
			inx h
			mov d, m
			dad d
			shld heroAnimAddr
@skipAnimUpdate:
.endmacro

hero_update:
			; check if a current animation is an attack
			lda heroStatus
			cpi HERO_STATUS_ATTACK
			jz HeroAttackUpdate

			; check if an attack key pressed
			lhld key_code
			mvi a, KEY_SPACE
			cmp h
			jz HeroAttackStart

			; check if no arrow key pressed
			mvi a, KEY_LEFT & KEY_RIGHT & KEY_UP & KEY_DOWN
			ora l
			inr a
			jz HeroIdleUpdate

@checkMoveKeys:
			; check if the same arrow keys pressed the prev update
			lda key_code_old
			cmp l
			jnz @moveKeysPressed

			; update a move anim
			HERO_UPDATE_ANIM(HERO_ANIM_SPEED_MOVE)
			jmp hero_update_pos

@moveKeysPressed:
			mov a, l
@setAnimRunR:
			cpi KEY_RIGHT
			jnz @setAnimRunRU

			lxi h, HERO_RUN_SPEED
			shld heroSpeedX
			lxi h, 0
			shld heroSpeedY

			mvi a, 1
			sta heroDirX
			lxi h, hero_r_run
			shld heroAnimAddr
			jmp hero_update_pos

@setAnimRunRU:
			cpi KEY_RIGHT & KEY_UP
			jnz @setAnimRunRD

			lxi h, HERO_RUN_SPEED_D
			shld heroSpeedX
			shld heroSpeedY

			mvi a, 1
			sta heroDirX
			lxi h, hero_r_run
			shld heroAnimAddr
			jmp hero_update_pos

@setAnimRunRD:
			cpi KEY_RIGHT & KEY_DOWN
			jnz @setAnimRunL

			lxi h, HERO_RUN_SPEED_D
			shld heroSpeedX
			LXI_H_NEG(HERO_RUN_SPEED_D)
			shld heroSpeedY

			mvi a, 1
			sta heroDirX
			lxi h, hero_r_run
			shld heroAnimAddr
			jmp hero_update_pos

@setAnimRunL:
			cpi KEY_LEFT
			jnz @setAnimRunLU

			LXI_H_NEG(HERO_RUN_SPEED)
			shld heroSpeedX
			lxi h, 0
			shld heroSpeedY

			xra a
			sta heroDirX
			lxi h, hero_l_run
			shld heroAnimAddr
			jmp hero_update_pos

@setAnimRunLU:
			cpi KEY_LEFT & KEY_UP
			jnz @setAnimRunLD

			LXI_H_NEG(HERO_RUN_SPEED_D)
			shld heroSpeedX
			lxi h, HERO_RUN_SPEED_D
			shld heroSpeedY

			xra a
			sta heroDirX
			lxi h, hero_l_run
			shld heroAnimAddr
			jmp hero_update_pos

@setAnimRunLD:
			cpi KEY_LEFT & KEY_DOWN
			jnz @setAnimRunU

			LXI_H_NEG(HERO_RUN_SPEED_D)
			shld heroSpeedX
			shld heroSpeedY

			xra a
			sta heroDirX
			lxi h, hero_l_run
			shld heroAnimAddr
			jmp hero_update_pos

@setAnimRunU:
			cpi KEY_UP
			jnz @setAnimRunD

			lxi h, 0
			shld heroSpeedX
			lxi h, HERO_RUN_SPEED
			shld heroSpeedY

			lda heroDirX
			ora a
			jz @setAnimRunUfaceL

			lxi h, hero_r_run
			shld heroAnimAddr
			jmp hero_update_pos
@setAnimRunUfaceL:
			lxi h, hero_l_run
			shld heroAnimAddr
			jmp hero_update_pos
@setAnimRunD:
			cpi KEY_DOWN
			rnz

			lxi h, 0
			shld heroSpeedX
			LXI_H_NEG(HERO_RUN_SPEED)
			shld heroSpeedY

			lda heroDirX
			ora a
			jz @setAnimRunDfaceL
			lxi h, hero_r_run
			shld heroAnimAddr
			jmp hero_update_pos
@setAnimRunDfaceL:
			lxi h, hero_l_run
			shld heroAnimAddr
			;jmp hero_update_pos

hero_update_pos:
			; apply the hero speed
			lhld heroPosX
			xchg
			lhld heroSpeedX
			dad d
			shld charTempX
			mov b, h			
			lhld heroPosY
			xchg
			lhld heroSpeedY
			dad d
			shld charTempY
			
			; check the collision tiles
			mov d, b ; posX
			mov e, h ; posY
			lxi b, (HERO_COLLISION_WIDTH-1)<<8 | HERO_COLLISION_HEIGHT-1
			CALL_RAM_DISK_FUNC(RoomCheckTileDataCollision, __RAM_DISK_M_BACKBUFF2 | RAM_DISK_M_89, false, false)
			jz HeroMove
@collides:
			; handle a collision data around a hero
			; if a hero is inside the collision, move him out
			lxi h, heroCollisionFuncTable-4 ; C==0 is no case, skip it			
			mvi b, 0
			dad b
			pchl

HeroMove:
			lhld charTempX
			shld heroPosX
			lhld charTempY
			shld heroPosY
; handle tileData around a hero.
HeroCheckTileData:
HeroDontMove:
			lxi h, heroPosX+1
			mov d, m
			inx_h(2)
			mov e, m
			lxi b, (HERO_COLLISION_WIDTH-1)<<8 | HERO_COLLISION_HEIGHT-1
			CALL_RAM_DISK_FUNC(RoomGetTileDataAroundSprite, __RAM_DISK_M_BACKBUFF2 | RAM_DISK_M_89, false, false)
			rz

			lxi h, roomTileCollisionData
			mvi c, 4
@loop:		TILE_DATA_HANDLE_FUNC_CALL(HeroTileFuncTable-4, true)
			inx h
			dcr c
			jnz @loop
			ret

HeroCheckCollisionTL:
			lda charTempX+1
			; get the inverted offsetX inside the tile
			cma
			ani %00001111
			mov c, a
			lda charTempY+1
			adi HERO_COLLISION_HEIGHT-1
			; get the offsetY inside the tile
			ani %00001111
			cmp c
			jz HeroMoveTileBR
			jnc HeroMoveTileR
			jmp HeroMoveTileB
			
HeroCheckCollisionTR:
			lda charTempX+1
			adi HERO_COLLISION_WIDTH-1
			; get the offset inside the tile
			ani %00001111
			mov c, a
			lda charTempY+1
			adi HERO_COLLISION_HEIGHT-1
			; get the offset inside the tile
			ani %00001111
			cmp c
			jz HeroMoveTileBL
			jc HeroMoveTileB
			jmp HeroMoveTileL

HeroCheckCollisionBL:
			lda charTempX+1
			; get the offset inside the tile
			cma
			ani %00001111
			mov c, a
			lda charTempY+1
			; get the offset inside the tile
			cma
			ani %00001111
			cmp c
			jz HeroMoveTileTR
			jc HeroMoveTileT
			jmp HeroMoveTileR

HeroCheckCollisionBR:
			lda charTempX+1
			adi HERO_COLLISION_WIDTH-1
			; get the offset inside the tile
			ani %00001111
			mov c, a
			lda charTempY+1
			; get the offset inside the tile
			cma
			ani %00001111
			cmp c
			jz HeroMoveTileTL
			jc HeroMoveTileT
			jmp HeroMoveTileL

; move the hero to the right out of of the collided tile
HeroMoveTileR:
			lda charTempX+1
			stc		; to move outside the current tile
			adc c
			sta heroPosX+1
			lhld charTempY
			shld heroPosY
			jmp HeroCheckTileData

; move the hero under the collided tile
HeroMoveTileB:
			lhld charTempX
			shld heroPosX
			mov c, a
			lda charTempY+1
			stc		; to move outside the current tile
			sbb c
			sta heroPosY+1
			jmp HeroCheckTileData

; move the hero to the bottom-right corner of the collided tile
HeroMoveTileBR:
			lxi h, charTempX+1
			stc		; to move outside the current tile
			adc m
			sta heroPosX+1
			inx_h(2)
			mov a, m
			stc		; to move outside the current tile
			sbb c
			sta heroPosY+1
			jmp HeroCheckTileData

; move the hero to the left out of of the collided tile
HeroMoveTileL:
			lda charTempX+1
			stc		; to move outside the current tile
			sbb c
			sta heroPosX+1
			lhld charTempY
			shld heroPosY
			jmp HeroCheckTileData

; move the hero to the bottom-left corner of the collided tile
HeroMoveTileBL:
			lxi h, charTempX+1
			sub m
			cma
			sta heroPosX+1
			inx_h(2)
			mov a, m
			stc		; to move outside the current tile
			sbb c
			sta heroPosY+1
			jmp HeroCheckTileData

; move the hero on top of the collided tile
HeroMoveTileT:
			lhld charTempX
			shld heroPosX
			mov c, a
			lda charTempY+1
			stc		; to move outside the current tile
			adc c
			sta heroPosY+1
			jmp HeroCheckTileData

; move the hero to the top-right corner of the collided tile
HeroMoveTileTR:
			lxi h, charTempX+1
			stc		; to move outside the current tile
			adc m
			sta heroPosX+1
			inx_h(2)
			mov a, m
			stc		; to move outside the current tile
			adc c
			sta heroPosY+1
			jmp HeroCheckTileData

; move the hero to the top-left corner of the collided tile
HeroMoveTileTL:			
			lxi h, charTempX+1
			sub m
			cma
			sta heroPosX+1
			inx_h(2)
			mov a, m
			stc		; to move outside the current tile
			adc c
			sta heroPosY+1
			jmp HeroCheckTileData

; when the hero runs into a tile from top or bottom, move him only horizontally
HeroMoveHorizontally:
			; do not move vertically
			lhld charTempX
			shld heroPosX	
			jmp HeroCheckTileData

; when the hero runs into a tile from left or right, move him only vertically
HeroMoveVertically:
			; do not move horizontally
			lhld charTempY
			shld heroPosY			
			jmp HeroCheckTileData

HeroTileFuncNothing:
			; bypass "ret"s to return from the hero_update func
			pop psw
			pop psw
			ret

; load a new room with roomId, move the hero to an
; appropriate position based on his current posXY
; input:
; a - roomId
HeroTileFuncTeleport:
			pop h

			; update a room id to teleport there
			sta roomIdx
			; requesting room loading
			mvi a, LEVEL_COMMAND_LOAD_DRAW_ROOM
			sta levelCommand
			; bypassing the HeroCheckTileData:@loop because the hero is teleporting
			; so we don't need to handle the rest of the colllided tiles.
			; return to the func that called hero_update
			pop b

			; check if the teleport on the left or right side
			lda heroPosX+1
			cpi (ROOM_WIDTH - 1 ) * TILE_WIDTH - HERO_COLLISION_WIDTH
			jnc @teleportRightToLeft
			cpi TILE_WIDTH
			jc @teleportLeftToRight
			; check if the teleport on the top or bottom side
			lda heroPosY+1
			cpi (ROOM_HEIGHT - 1 ) * TILE_HEIGHT - HERO_COLLISION_HEIGHT
			jnc @teleportTopToBottom
			cpi TILE_HEIGHT
			jc @teleportBottomToTop
			; teleport keeping the same pos
			ret

@teleportRightToLeft:
			mvi a, TILE_WIDTH
			sta heroPosX+1
			ret

@teleportLeftToRight:
			mvi a, (ROOM_WIDTH - 1 ) * TILE_WIDTH - HERO_COLLISION_WIDTH
			sta heroPosX+1
			ret

@teleportTopToBottom:
			mvi a, TILE_HEIGHT
			sta heroPosY+1
			ret
@teleportBottomToTop:
			mvi a, (ROOM_HEIGHT - 1 ) * TILE_HEIGHT - HERO_COLLISION_HEIGHT
			sta heroPosY+1
			ret

HeroAttackStart:
			; set status
			mvi a, HERO_STATUS_ATTACK
			sta heroStatus
			mvi a, HERO_STATUS_ATTACK_DURATION
			sta heroStatusTimer
			; reset anim timer
			xra a
			sta heroAnimTimer			

			; speed = 0
			lxi h, 0
			shld heroSpeedX
			shld heroSpeedY
			; set direction
			lda heroDirX
			ora a
			jz @setAnimAttkL

			lxi h, hero_r_attk
			shld heroAnimAddr
			jmp  HeroSwordTrailInit
@setAnimAttkL:
			lxi h, hero_l_attk
			shld heroAnimAddr
			jmp HeroSwordTrailInit
			.closelabels

HeroAttackUpdate:
			HERO_UPDATE_ANIM(HERO_ANIM_SPEED_ATTACK)
			lxi h, heroStatusTimer
			dcr m
			rnz

			; if the timer == 0, set the status to Idle
			jmp HeroIdleStart
			.closelabels

HeroIdleStart:
			; set status
			mvi a, HERO_STATUS_IDLE
			sta heroStatus
			; reset anim timer
			xra a
			sta heroAnimTimer

			; speed = 0
			lxi h, 0
			shld heroSpeedX
			shld heroSpeedY
			; set direction
			lda heroDirX
			ora a
			jz @setAnimIdleL

			lxi h, hero_r_idle
			shld heroAnimAddr
			ret
@setAnimIdleL:
			lxi h, hero_l_idle
			shld heroAnimAddr
			ret

HeroIdleUpdate:
			; check if the same keys pressed the prev update
			lda key_code_old
			cmp l
			jnz HeroIdleStart
			HERO_UPDATE_ANIM(HERO_ANIM_SPEED_IDLE)
			ret

; handle the damage
; in:
; c - damage (positive number)
HeroImpact:
			lxi h, heroHealth
			mov a, m
			sub c
			mov m, a
			; check if he dies
			push psw
			call GameUIHealthDraw
			pop psw
			rnc
			; hero's dead
			; TODO: teleport the hero to the main scene if he died in the level
			; TODO: teleport the hero to the catacombs entrance if a boss killed him
			ret

hero_draw:
			lxi h, heroPosX+1
			call SpriteGetScrAddr_hero_r

			lhld heroAnimAddr
			call SpriteGetAddr

			lda heroDirX
			ora a
			mvi a, <(__RAM_DISK_S_HERO_R | __RAM_DISK_M_DRAW_SPRITE_VM | RAM_DISK_M_8F)
			jnz @spriteR
@spriteL:
			mvi a, <(__RAM_DISK_S_HERO_L | __RAM_DISK_M_DRAW_SPRITE_VM | RAM_DISK_M_8F)
@spriteR:			

			; TODO: optimize. consider using unrolled loops in DrawSpriteVM for sprites 15 pxs tall
			CALL_RAM_DISK_FUNC_BANK(__DrawSpriteVM)

			; store an old scr addr, width, and height
			lxi h, heroEraseScrAddr
			mov m, c
			inx h
			mov m, b
			xchg
			shld heroEraseWH
			ret

hero_copy_to_scr:
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
			; calc bc (width, height)
			mov a, h
			sub d
			mov b, a
			mov a, l
			sub e
			mov c, a
			jmp SpriteCopyToScrV

hero_erase:
			; TODO: optimize. erase only that is outside of the updated hero region
			lhld heroEraseScrAddr
			xchg
			lhld heroEraseWH

			; check if it needs to restore the background
			push h
			push d
			mvi a, -$20 ; advance DE to SCR_ADDR_0 to check the collision, to decide if we need to restore a beckground
			add d
			mov d, a
			CALL_RAM_DISK_FUNC(RoomCheckNonZeroTiles, __RAM_DISK_M_BACKBUFF2 | RAM_DISK_M_89, false, false)
			pop d
			pop h
			jnz SpriteCopyToBackBuffV ; restore a background
			CALL_RAM_DISK_FUNC(__EraseSprite, __RAM_DISK_S_BACKBUFF | __RAM_DISK_M_ERASE_SPRITE | RAM_DISK_M_8F)
			ret
			.closelabels	