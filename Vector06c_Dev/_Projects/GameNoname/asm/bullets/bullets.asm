.include "asm\\bullets\\bulletsMacro.asm"
.include "asm\\bullets\\bulletsData.asm"
.include "asm\\bullets\\heroSwordTrail.asm"
.include "asm\\bullets\\scythe.asm"

BulletsEraseRuntimeData:
			mvi a, BULLET_RUNTIME_DATA_LAST
			sta bulletUpdatePtr+1
			ret
			.closelabels


; look up the empty spot in the bullet runtime data
; in: 
; none
; return:
; hl - a ptr to bulletUpdatePtr+1 of an empty bullet runtime data
; uses:
; de, a

; TODO: optimize. use a lastRemovedBulletRuntimeDataPtr as a starter to find an empty data
BulletsGetEmptyDataPtr:
			lxi h, bulletUpdatePtr+1
@loop:
			mov a, m
			cpi BULLET_RUNTIME_DATA_EMPTY
			; return if it is an empty data
			rz
			jc @nextData
			cpi BULLET_RUNTIME_DATA_LAST
			jnz @bulletsTooMany
			; it is the end of the last bullet data
			xchg
			lxi h, BULLET_RUNTIME_DATA_LEN
			dad d
			mvi a, BULLET_RUNTIME_DATA_END
			cmp m
			xchg
			; if the next after the last data is end, then just return
			rz
			; if not the end, then set it as the last
			xchg
			mvi m, BULLET_RUNTIME_DATA_LAST
			xchg
			; TODO: optimize. store hl into lastRemovedBulletRuntimeDataPtr
			ret
@bulletsTooMany:
			; return bypassing a func that called this func
			pop psw
			ret
@nextData:
			lxi d, BULLET_RUNTIME_DATA_LEN
			dad d
			jmp @loop


; mark a bullet data ptr as it's going to be destroyed
; in:
; hl - bulletUpdatePtr+1 ptr
; TODO: optimize. fill up lastRemovedBulletRuntimeDataPtr
BulletsDestroy:
			mvi m, BULLET_RUNTIME_DATA_DESTR
			ret
			.closelabels

; mark a bullet data as empty
; in:
; hl - bulletUpdatePtr+1 ptr
; TODO: optimize. fiil up lastRemovedBulletRuntimeDataPtr
BulletsSetEmpty:
			mvi m, BULLET_RUNTIME_DATA_EMPTY
			ret
			.closelabels

; call all active bullets' Update/Draw func
; a func will get DE pointing to a func ptr (ex.:bulletUpdatePtr or bulletDrawPtr) in the runtime data
; in:
; hl - an offset to a func ptr relative to bulletUpdatePtr in the runtime data
; 		ex.: the offset to bulletUpdatePtr is zero
; use:
; de, a
BulletsDataFuncCaller:
			shld @funcPtrOffset+1
			lxi h, bulletUpdatePtr+1
@loop:
			mov a, m
			cpi BULLET_RUNTIME_DATA_DESTR
			jc @callFunc
			cpi BULLET_RUNTIME_DATA_LAST
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
			lxi d, BULLET_RUNTIME_DATA_LEN
			dad d
			jmp @loop
			ret			
			.closelabels

; call a provided func (BulletCopyToScr, BulletErase) if a bullet is alive
; a func will get HL pointing to a bulletUpdatePtr+1 in the runtime data, and A holding a BULLET_RUNTIME_DATA_* status
; in:
; hl - a func addr
; use:
; de, a
BulletsCommonFuncCaller:
			shld @funcPtr+1
			lxi h, bulletUpdatePtr+1
@loop:
			mov a, m
			cpi BULLET_RUNTIME_DATA_EMPTY
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
			lxi d, BULLET_RUNTIME_DATA_LEN
			dad d
			jmp @loop
			ret
			.closelabels
			
BulletsUpdate:
			lxi h, 0
			jmp BulletsDataFuncCaller

BulletsDraw:
			lxi h, bulletDrawPtr - bulletUpdatePtr
			jmp BulletsDataFuncCaller

BulletsCopyToScr:
			lxi h, BulletCopyToScr
			jmp BulletsCommonFuncCaller

BulletsErase:
			lxi h, BulletErase
			jmp BulletsCommonFuncCaller

; copy sprites from a backbuffer to a scr
; in:
; hl - ptr to bulletUpdatePtr+1 in the runtime data
BulletCopyToScr:
			; advance to bulletStatus
			LXI_D_TO_DIFF(bulletStatus, bulletUpdatePtr+1)
			dad d
			; if it is invisible, return
			mov a, m
			cpi BULLET_STATUS_INVIS
			rz

			; advance to bulletEraseScrAddr
			LXI_B_TO_DIFF(bulletEraseScrAddr, bulletStatus)			
			dad b
			; read bulletEraseScrAddr
			mov c, m
			inx h
			mov b, m
			inx h
			; read bulletEraseScrAddrOld
			mov e, m
			inx h
			mov d, m
			; store bulletEraseScrAddr temp
			xchg
			shld @oldTopRightConner+1
			xchg
			; store bulletEraseScrAddr to bulletEraseScrAddrOld
			mov m, b
			dcx h
			mov m, c
			; bc - heroEraseScrAddr
			; de - heroEraseScrAddrOld
			; hl - ptr to bulletEraseScrAddrOld
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
			; bc - bulletEraseScrAddr
			; calc top-right corner addr (heroEraseScrAddr + bulletEraseWH)
			inx_h(2)
			mov d, b
			mov e, c
			; bc - bulletEraseWH
			mov c, m
			inx h
			mov b, m
			inx h
			xchg
			dad b
			xchg
			; bc - bulletEraseWHOld
			; store bulletEraseWH to bulletEraseWHOld
			mov a, m
			mov m, c
			mov c, a
			inx h
			mov a, m
			mov m, b
			mov b, a
			; calc old top-right corner addr (heroEraseScrAddrOld + bulletEraseWHOld)
@oldTopRightConner:
			lxi h, TEMP_WORD
			dad b
			; hl - heroEraseScrAddrOld + bulletEraseWHOld
			; de - heroEraseScrAddr + bulletEraseWH
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
; hl - ptr to bulletUpdatePtr+1 in the runtime data
; a - BULLET_RUNTIME_DATA_* status
BulletErase:
			; if a bullet is destroyed mark its data as empty
			cpi BULLET_RUNTIME_DATA_DESTR
			jz BulletsSetEmpty

			; advance to bulletStatus
			LXI_D_TO_DIFF(bulletStatus, bulletUpdatePtr+1)
			dad d
			; if it is invisible, return
			mov a, m
			cpi BULLET_STATUS_INVIS
			rz

			; advance to bulletEraseScrAddr
			LXI_D_TO_DIFF(bulletEraseScrAddr, bulletStatus)
			dad d
			mov e, m
			inx h
			mov d, m

			LXI_B_TO_DIFF(bulletEraseWH, bulletEraseScrAddr+1)
			dad b
			mov a, m
			inx h
			mov h, m			
			mov l, a
			; hl - bulletEraseWH
			; de - bulletEraseScrAddr

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
