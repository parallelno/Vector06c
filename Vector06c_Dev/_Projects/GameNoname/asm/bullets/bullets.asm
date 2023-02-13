.include "asm\\bullets\\bullets_macro.asm"
.include "asm\\bullets\\bullets_data.asm"
.include "asm\\bullets\\hero_sword_trail.asm"
.include "asm\\bullets\\scythe.asm"
.include "asm\\bullets\\bomb_slow.asm"

bullets_erase_runtime_data:
			mvi a, BULLET_RUNTIME_DATA_LAST
			sta bullet_update_ptr + 1
			ret
			.closelabels


; look up the empty spot in the bullet runtime data
; in: 
; none
; return:
; hl - a ptr to bullet_update_ptr + 1 of an empty bullet runtime data
; uses:
; de, a

; TODO: optimize. use a last_removed_bullet_runtime_data_ptr as a starter to find an empty data
bullets_get_empty_data_ptr:
			lxi h, bullet_update_ptr + 1
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
; hl - bullet_update_ptr+1 ptr
; TODO: optimize. fill up lastRemovedBulletRuntimeDataPtr
bullets_destroy:
			mvi m, BULLET_RUNTIME_DATA_DESTR
			ret
			.closelabels

; mark a bullet data as empty
; in:
; hl - bullet_update_ptr+1 ptr
; TODO: optimize. fiil up lastRemovedBulletRuntimeDataPtr
bullets_set_empty:
			mvi m, BULLET_RUNTIME_DATA_EMPTY
			ret
			.closelabels

; call all active bullets' Update/Draw func
; a func will get DE pointing to a func ptr (ex.:bullet_update_ptr or bullet_draw_ptr) in the runtime data
; in:
; hl - an offset to a func ptr relative to bullet_update_ptr in the runtime data
; 		ex.: the offset to bullet_update_ptr is zero
; use:
; de, a
BulletsDataFuncCaller:
			shld @funcPtrOffset+1
			lxi h, bullet_update_ptr+1
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
; a func will get HL pointing to a bullet_update_ptr+1 in the runtime data, and A holding a BULLET_RUNTIME_DATA_* status
; in:
; hl - a func addr
; use:
; de, a
BulletsCommonFuncCaller:
			shld @funcPtr+1
			lxi h, bullet_update_ptr+1
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
			
bullets_update:
			lxi h, 0
			jmp BulletsDataFuncCaller

bullets_draw:
			lxi h, bullet_draw_ptr - bullet_update_ptr
			jmp BulletsDataFuncCaller

bullets_copy_to_scr:
			lxi h, BulletCopyToScr
			jmp BulletsCommonFuncCaller

bullets_erase:
			lxi h, BulletErase
			jmp BulletsCommonFuncCaller

; copy sprites from a backbuffer to a scr
; in:
; hl - ptr to bullet_update_ptr+1 in the runtime data
BulletCopyToScr:
			; advance to bullet_status
			LXI_D_TO_DIFF(bullet_status, bullet_update_ptr+1)
			dad d
			; if it is invisible, return
			mov a, m
			cpi BULLET_STATUS_INVIS
			rz

			; advance to bulletEraseScrAddr
			LXI_B_TO_DIFF(bulletEraseScrAddr, bullet_status)			
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
			; bc - hero_erase_scr_addr
			; de - hero_erase_scr_addr_old
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
			; calc top-right corner addr (hero_erase_scr_addr + bulletEraseWH)
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
			; calc old top-right corner addr (hero_erase_scr_addr_old + bulletEraseWHOld)
@oldTopRightConner:
			lxi h, TEMP_WORD
			dad b
			; hl - hero_erase_scr_addr_old + bulletEraseWHOld
			; de - hero_erase_scr_addr + bulletEraseWH
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
			jmp sprite_copy_to_scr_v


; erase a sprite or restore the background behind a sprite
; in:
; hl - ptr to bullet_update_ptr+1 in the runtime data
; a - BULLET_RUNTIME_DATA_* status
BulletErase:
			; if a bullet is destroyed mark its data as empty
			cpi BULLET_RUNTIME_DATA_DESTR
			jz bullets_set_empty

			; advance to bullet_status
			LXI_D_TO_DIFF(bullet_status, bullet_update_ptr+1)
			dad d
			; if it is invisible, return
			mov a, m
			cpi BULLET_STATUS_INVIS
			rz

			; advance to bulletEraseScrAddr
			LXI_D_TO_DIFF(bulletEraseScrAddr, bullet_status)
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
			CALL_RAM_DISK_FUNC(room_check_non_zero_tiles, __RAM_DISK_M_BACKBUFF2 | RAM_DISK_M_89, false, false)
			pop d
			pop h
			jnz sprite_copy_to_back_buff_v ; restore a background
			CALL_RAM_DISK_FUNC(__erase_sprite, __RAM_DISK_S_BACKBUFF | __RAM_DISK_M_ERASE_SPRITE | RAM_DISK_M_8F)
			ret
