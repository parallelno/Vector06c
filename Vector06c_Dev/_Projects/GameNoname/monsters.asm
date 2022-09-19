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

			lxi h, monsterEraseScrAddr
			dad b
			mov e, m
			inx h
			mov d, m
			inx_h(3)
			; hl - monsterEraseWH
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
			; convert monster id into the offset in the monstersRoomData array
			; and store it into bc
			lxi h, monsterRoomDataAddrOffsets
			dad b
			mov c, m
/*
			lxi h, monsterEraseScrAddrOld+1
			mov d, m
			dcx h
			mov e, m
			dcx h
			mov b, m
			dcx h
			mov c, m
			; de - heroEraseScrAddrOld
			; bc - heroEraseScrAddr
			; hl - ptr to heroEraseScrAddr
			; get the min(b, d), min(c, e)
			mov a, b
			cmp d
			jc @keepCurrentX
			mov b, d
@keepCurrentX:
			mov a, c
			cmp e
			jc @keepCurrentY 
			mov c, e
@keepCurrentY:
			; bc - a scr addr to copy
			push b
			mov e, b 
			*/
			; for tests
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
			inr_l(2)
			dcr e
			; hl - width, height
			jmp CopySpriteToScrV
