.include "skeleton.asm"
.include "monstersRuntimeData.asm"

MonstersClearRoomData:
			lxi h, monstersRoomData
			lxi b, MONSTERS_ROOM_DATA_LEN
			call ClearMem
			ret
			.closelabels

MONSTERS_NO_SPECIAL_FUNC = $ffff

.macro MONSTERS_FUNCS_HANDLER(funcs, specialFunc = MONSTERS_NO_SPECIAL_FUNC, noRet = false)
			lxi h, funcs + (MONSTERS_MAX-1) * 2 + 1
			; bc - monster idx, used in a func
			lxi b, MONSTERS_MAX-1
@loop:
			mov d, m
			dcx h
			mov e, m
			dcx h
			xra a
			ora d
			jz @skip
			push h
			push b
			xchg
			lxi d, @funcReturnAddr
			push d
		.if specialFunc != MONSTERS_NO_SPECIAL_FUNC
			lxi h, specialFunc
		.endif
			pchl ; call a monster update func
@funcReturnAddr:
			pop b
			pop h
@skip:
			dcr c
			jp @loop
		.if noRet == false
			ret
		.endif
			.closelabels
.endfunction

MonstersInit:
            MONSTERS_FUNCS_HANDLER(monstersInitFunc)

MonstersUpdate:
            MONSTERS_FUNCS_HANDLER(monstersUpdateFunc)

MonstersErase:
			MONSTERS_FUNCS_HANDLER(monstersDrawFunc, MonsterErase)

; erase sprite
; in:
; bc - monster idx*2
MonsterErase:
			; convert monster id into the offset in the monstersRoomData array
			; and store it into bc
			lxi h, monsterRoomDataAddrOffsets
			dad b
			mov c, m

			; de <- monsterEraseScrAddr
			; hl <- monsterEraseWH
			lxi h, monsterEraseScrAddr
			dad b
			mov e, m
			inx h
			mov d, m
			inx_h(3)
			mov a, m
			inx h
			mov h, m			
			mov l, a
			CALL_RAM_DISK_FUNC(__EraseSpriteSP, RAM_DISK0_B2_STACK_B2_8AF_RAM)
			ret

MonstersDraw:
			MONSTERS_FUNCS_HANDLER(monstersDrawFunc)

MonstersCopyToScr:
			MONSTERS_FUNCS_HANDLER(monstersDrawFunc, MonsterCopyToScr)

MonsterCopyToScr:
			; TODO: think of making layer of monstersRoomSpriteData struct like
			; monsterEraseScrX
			; monsterEraseScrXOld
			; monsterEraseW
			; monsterEraseWOld
			; ... similar for Y and height
			; convert monster id into the offset in the monstersRoomData array
			; and store it into bc
			lxi h, monsterRoomDataAddrOffsets
			dad b
			mov c, m

			; read monsterEraseScrAddr
			lxi h, monsterEraseScrAddr
			dad b
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
			; calc width and height
			mov a, h
			sub d 
			mov h, a
			mov a, l 
			sub e
			mov l, a
			; hl - width, height
			jmp CopySpriteToScrV
