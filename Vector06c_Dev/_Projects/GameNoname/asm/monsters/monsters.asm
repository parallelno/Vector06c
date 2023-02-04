.include "asm\\monsters\\monstersConsts.asm"
.include "asm\\monsters\\monsterMacro.asm"
.include "asm\\monsters\\skeleton.asm"
.include "asm\\monsters\\vampire.asm"
.include "asm\\monsters\\burner.asm"
.include "asm\\monsters\\knight.asm"
.include "asm\\monsters\\monstersData.asm"

MonstersEraseRuntimeData:
			mvi a, MONSTER_RUNTIME_DATA_LAST
			sta monsterUpdatePtr+1
			ret
			.closelabels

; in:
; hl - 	posX, posY
; a  - 	collider width
; c  - 	collider height
; de -	monster data ptr + 1
; out:
; collision 	- (hl) < MONSTER_RUNTIME_DATA_LAST
; no collision 	- (hl) >= MONSTER_RUNTIME_DATA_LAST

MonstersGetFirstCollided:
			sta @colliderWidth+1
			mov a, c
			sta @colliderHeight+1
			mov a, h
			sta @colliderPosX+1
			mov a, l
			sta @colliderPosY+1
			xchg

@loop:
			mov a, m
			cpi MONSTER_RUNTIME_DATA_DESTR
			jc @checkCollision
			cpi MONSTER_RUNTIME_DATA_LAST
			jc @nextData
			; no collision against all alive monsters
			ret
@checkCollision:
			push h
			; advance hl to monsterType
			LXI_B_TO_DIFF(monsterType, monsterUpdatePtr+1)
			dad b
			mov a, m
			cpi MONSTER_TYPE_ALLY
			jz @noCollision

			; advance hl to monsterPosX+1
			LXI_B_TO_DIFF(monsterPosX+1, monsterType)
			dad b
			; horizontal check
			mov c, m 	; monster posX
@colliderPosX:
			mvi a, TEMP_BYTE
			mov b, a	; tmp
@colliderWidth:
			adi TEMP_BYTE
			cmp c
			jc @noCollision
			mvi a, SKELETON_COLLISION_WIDTH-1
			add c
			cmp b
			jc @noCollision
			; vertical check
			inx_h(2)
			mov c, m ; monster posY
@colliderPosY:
			mvi a, TEMP_BYTE
			mov b, a
@colliderHeight:
			adi TEMP_BYTE
			cmp c
			jc @noCollision
			mvi a, SKELETON_COLLISION_HEIGHT-1
			add c
			cmp b
			jc @noCollision

			; collides
			pop h
			ret
@noCollision:
			pop h
@nextData:
			lxi b, MONSTER_RUNTIME_DATA_LEN
			dad b
			jmp @loop

; look up the empty spot in the monster runtime data
; in: 
; none
; return:
; hl - a ptr to monsterUpdatePtr+1 of an empty monster runtime data
; uses:
; de, a

; TODO: optimize. use a lastRemovedMonsterRuntimeDataPtr as a starter to find an empty data
MonstersGetEmptyDataPtr:
			lxi h, monsterUpdatePtr+1
@loop:
			mov a, m
			cpi MONSTER_RUNTIME_DATA_EMPTY
			; return if it is an empty data
			rz
			jc @nextData
			cpi MONSTER_RUNTIME_DATA_LAST
			jnz @monstersTooMany
			; it is the end of the last monster data
			xchg
			lxi h, MONSTER_RUNTIME_DATA_LEN
			dad d
			mvi a, MONSTER_RUNTIME_DATA_END
			cmp m
			xchg
			; if the next after the last data is end, then just return
			rz
			; if not the end, then set it as the last
			xchg
			mvi m, MONSTER_RUNTIME_DATA_LAST
			xchg
			; TODO: optimize. store hl into lastRemovedMonsterRuntimeDataPtr
			ret
@monstersTooMany:
			; return bypassing a func that called this func
			pop psw
			ret
@nextData:
			lxi d, MONSTER_RUNTIME_DATA_LEN
			dad d
			jmp @loop


; mark a monster data ptr as it's going to be destroyed
; in:
; hl - monsterUpdate+1 ptr
; TODO: optimize. fiil up lastRemovedMonsterRuntimeDataPtr
MonstersDestroy:
			mvi m, MONSTER_RUNTIME_DATA_DESTR
			ret
			.closelabels

; mark a monster data as empty
; in:
; hl - monsterUpdate+1 ptr
; TODO: optimize. fiil up lastRemovedMonsterRuntimeDataPtr
MonstersSetEmpty:
			mvi m, MONSTER_RUNTIME_DATA_EMPTY
			ret
			.closelabels

; call all active monsters' Update/Draw func
; a func will get DE pointing to a func ptr (ex.:monsterUpdatePtr or monsterDrawPtr) in the runtime data
; in:
; hl - an offset to a func ptr relative to monsterUpdatePtr in the runtime data
; 		ex.: the offset to monsterUpdatePtr is zero
; use:
; de, a
MonstersDataFuncCaller:
			shld @funcPtrOffset+1
			lxi h, monsterUpdatePtr+1
@loop:
			mov a, m
			cpi MONSTER_RUNTIME_DATA_DESTR
			jc @callFunc
			cpi MONSTER_RUNTIME_DATA_LAST
			jc @nextData
			; it is the last or the end, so return
			ret
@callFunc:
			push h
			lxi d, @return
			push d
@funcPtrOffset:
			lxi d, TEMP_ADDR
			; advance to a func ptr
			dad d
			; read the func addr
			mov d, m 
			dcx h
			mov e, m
			xchg
			; call a func
			pchl
@return:
			pop h
@nextData:
			lxi d, MONSTER_RUNTIME_DATA_LEN
			dad d
			jmp @loop
			ret			
			.closelabels

; call a provided func (MonsterCopyToScr, MonsterErase) if a monster is alive
; a func will get HL pointing to a monsterUpdatePtr+1 in the runtime data, and A holding a MONSTER_RUNTIME_DATA_* status
; in:
; hl - a func addr
; use:
; de, a
MonstersCommonFuncCaller:
			shld @funcPtr+1
			lxi h, monsterUpdatePtr+1
@loop:
			mov a, m
			cpi MONSTER_RUNTIME_DATA_EMPTY
			jc @callFunc
			jz @nextData
			; it is the last or the end, so return
			ret
@callFunc:			
			push h
@funcPtr:
			call TEMP_ADDR
			pop h
@nextData:
			lxi d, MONSTER_RUNTIME_DATA_LEN
			dad d
			jmp @loop
			ret
			.closelabels
			
MonstersUpdate:
			lxi h, 0
			jmp MonstersDataFuncCaller

MonstersDraw:
			lxi h, monsterDrawPtr - monsterUpdatePtr
			jmp MonstersDataFuncCaller

MonstersCopyToScr:
			lxi h, MonsterCopyToScr
			jmp MonstersCommonFuncCaller

MonstersErase:
			lxi h, MonsterErase
			jmp MonstersCommonFuncCaller

; copy sprites from a backbuffer to a scr
; in:
; hl - ptr to monsterUpdatePtr+1 in the runtime data
MonsterCopyToScr:
			; advance to monsterStatus
			LXI_D_TO_DIFF(monsterStatus, monsterUpdatePtr+1)
			dad d
			; if it is invisible, return
			mov a, m
			cpi MONSTER_STATUS_INVIS
			rz

			; advance to monsterEraseScrAddr
			LXI_B_TO_DIFF(monsterEraseScrAddr, monsterStatus)			
			dad b
			; read monsterEraseScrAddr
			mov c, m
			inx h
			mov b, m
			inx h
			; read monsterEraseScrAddrOld
			mov e, m
			inx h
			mov d, m
			; store monsterEraseScrAddr temp
			xchg
			shld @oldTopRightConner+1
			xchg
			; store monsterEraseScrAddr to monsterEraseScrAddrOld
			mov m, b
			dcx h
			mov m, c
			; bc - heroEraseScrAddr
			; de - heroEraseScrAddrOld
			; hl - ptr to monsterEraseScrAddrOld
			; get min(b, d), min(c, e)
			mov a, d
			cmp b
			jc @keepOldX
			mov d, b
@keepOldX:
			mov a, e
			cmp c
			jc @keepOldY 
			mov e, c
@keepOldY:
			; tmp store a scr addr to copy
			push d
			; bc - monsterEraseScrAddr
			; calc top-right corner addr (heroEraseScrAddr + monsterEraseWH)
			inx_h(2)
			mov d, b
			mov e, c
			; bc - monsterEraseWH
			mov c, m
			inx h
			mov b, m
			inx h
			xchg
			dad b
			xchg
			; bc - monsterEraseWHOld
			; store monsterEraseWH to monsterEraseWHOld
			mov a, m
			mov m, c
			mov c, a
			inx h
			mov a, m
			mov m, b
			mov b, a
			; calc old top-right corner addr (heroEraseScrAddrOld + monsterEraseWHOld)
@oldTopRightConner:
			lxi h, TEMP_WORD
			dad b
			; hl - heroEraseScrAddrOld + monsterEraseWHOld
			; de - heroEraseScrAddr + monsterEraseWH
			; get max(h, d), max(l, e)
			mov a, h
			cmp d
			jnc @keepOldTRX
			mov h, d
@keepOldTRX:
			mov a, l
			cmp e
			jnc @keepOldTRY 
			mov l, e
@keepOldTRY:
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


; erase a sprite or restore the background behind a sprite
; in:
; hl - ptr to monsterUpdatePtr+1 in the runtime data
; a - MONSTER_RUNTIME_DATA_* status
MonsterErase:
			; if a monster is destroyed mark its data as empty
			cpi MONSTER_RUNTIME_DATA_DESTR
			jz MonstersSetEmpty

			; advance to monsterStatus
			LXI_D_TO_DIFF(monsterStatus, monsterUpdatePtr+1)
			dad d
			; if it is invisible, return
			mov a, m
			cpi MONSTER_STATUS_INVIS
			rz

			; advance to monsterEraseScrAddr
			LXI_D_TO_DIFF(monsterEraseScrAddr, monsterStatus)
			dad d
			mov e, m
			inx h
			mov d, m

			LXI_B_TO_DIFF(monsterEraseWH, monsterEraseScrAddr+1)
			dad b
			mov a, m
			inx h
			mov h, m			
			mov l, a
			; hl - monsterEraseWH
			; de - monsterEraseScrAddr

			; check if it needs to restore the background
			push h
			push d
			mvi a, -$20 ; advance DE to BACK_BUFF2_ADDR to check the collision, to decide if we need to restore a beckground
			add d
			mov d, a
			CALL_RAM_DISK_FUNC(RoomCheckNonZeroTiles, __RAM_DISK_M_BACKBUFF2 | RAM_DISK_M_89, false, false)
			pop d
			pop h
			jnz SpriteCopyToBackBuffV ; restore a background
			CALL_RAM_DISK_FUNC(__EraseSprite, __RAM_DISK_S_BACKBUFF | __RAM_DISK_M_ERASE_SPRITE | RAM_DISK_M_8F)
			ret
