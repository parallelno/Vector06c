; gigachad16 player
; info/credits:
; music has to be compressed into 14 buffers each for every register
; this player decompresses and plays 14 parallel streams.
; Only one task is executed each frame that decompresses 16 bytes for one of the ay registers.
; cpu load: 5-20 of 312 scanlines per a frame
; original player code made by svofski 2022
; original zx0 decompression code made by ivagor 2022

; total number of scheduled tasks
GC_PLAYER_TASKS	  = 14
; task stack size 
GC_PLAYER_STACK_SIZE = 22

GCPlayerStartCheck: 
			lda GCPlayerUpdate
			ora a
			rz
			;call GCPlayerMute
			call GCPlayerTasksInit
			call GCPlayerSchedulerInit
			;call GCPlayerClearBuffers

			; set bufferIdx GC_PLAYER_TASKS bytes prior to the init unpacking addr (0),
			; to let zx0 unpack data for GC_PLAYER_TASKS number of regs
			; that means the music will be GC_PLAYER_TASKS number of frames delayed
			mvi a, -GC_PLAYER_TASKS
			sta GCPlayerBufferIdx
			mvi a, -1
			sta GCPlayerTaskId
			; turn on the updates
			xra a
			sta GCPlayerUpdate
			ret
			.closelabels

; should be synced with interruptions				
GCPlayerUpdate:
			; return it it's turned off
			ret
			;RAM_DISK_ON(RAM_DISK0_B1_STACK)
			lxi h, GCPlayerTaskId
			mov a, m
			inr a
			ani $f
			mov m, a
			cpi GC_PLAYER_TASKS
			jnc @skip
			call GCPlayerSchedulerUpdate
@skip:
			lxi h, GCPlayerBufferIdx
			inr m
			call GCPlayerAYUpdate
			;RAM_DISK_OFF()
			ret
			.closelabels

; bufferN[bufferIdx] data will be send to AY for each register accordingly
GCPlayerBufferIdx:    
			.byte TEMP_BYTE
GCPlayerTaskId:  
			.byte TEMP_BYTE
			.closelabels

;==========================================
; create a GCPlayerUnpack tasks
;
GCPlayerTasksInit:
			di
			lxi h, 0
			dad sp
			shld @restoreSp+1

			lxi sp, GCPlayerTaskStack13 + GC_PLAYER_STACK_SIZE
			lxi d, GCPlayerAyRegDataPtrs + GC_PLAYER_TASKS * WORD_LEN
			; b = 0, c = a task counter * 2
			lxi b, (GC_PLAYER_TASKS - 1) * WORD_LEN
@loop:
			; store zx0 entry point to a task stack
			lxi h, GCPlayerUnpack
			push h
			; store the buffer addr to a task stack
			mov a, c
			rrc
			adi >GCPlayerBuffer00
			mov h, a
			mov l, b
			push h
			; store the regData addr to a task stack
			xchg
			dcx h
			mov d, m
			dcx h
			mov e, m
			push d
			xchg
			; store taskSP to GCPlayerTaskSPs
			lxi h, GCPlayerTaskSPs
			dad b
			shld @storeTaskSP+1
			; move sp back 4 bytes to skip storing HL, PSW because zx0 doesnt use them to init
			lxi h, $ffff - WORD_LEN * 2 + 1
			dad sp
@storeTaskSP:
			shld TEMP_ADDR
			; move SP to the previous task stack end
			lxi h, $ffff - GC_PLAYER_STACK_SIZE + WORD_LEN * 3 + 1
			dad sp

			sphl
			dcr c
			dcr c
			jp @loop
@restoreSp: lxi sp, TEMP_ADDR
			ei 
			ret  
			.closelabels

; Set the current task stack pointer to the first task stack pointer
GCPlayerSchedulerInit:
			lxi h, GCPlayerTaskSPs
			shld GCPlayerCurrentTaskSPp
			ret
			.closelabels

; clear the last 14 bytes of every buffer
; to prevent player to play gugbage data 
; when it repeats the current song or
; play a new one
GCPlayerClearBuffers:
			mvi h, >GCPlayerBuffer00
			mvi a, (>GCPlayerBuffer13) + 1
@nextBuff:
			mvi l, -GC_PLAYER_TASKS
@loop:
			mvi m, 0
			inr l
			jnz @loop
			inr h	
			cmp h
			jnz @nextBuff
			ret
			.closelabels

; call GCPlayerUnpack for the current task
GCPlayerSchedulerUpdate:
; TODO: replace it with lxi h, -2
; and replace lxi sp, temp_addr, ret with jmp temp_addr
			lxi h, 0
			dad sp
			shld GCPlayerSchedulerRestoreSp+1
			lhld GCPlayerCurrentTaskSPp
			mov e, m 
			inx h 
			mov d, m ; de = &GCPlayerTaskSPs[n]
			xchg
			sphl
			; restore a task context and return into it
			pop psw
			pop h
			pop d
			pop b
			ret      ; return to GCPlayerUnpack

; GCPlayerUnpack task calls this after unpacking 16 bytes.
; it stores all the registers of the current task
GCPlayerSchedulerStoreTaskContext:     
			push b
			push d
			push h
			push psw

			lxi h, 0 
			dad sp
			xchg
			lhld GCPlayerCurrentTaskSPp
			mov m, e 
			inx h 
			mov m, d 
			inx h
			mvi a, <GCPlayerTaskSPsEnd
			cmp l
			jnz @storeNextTaskSp
			mvi a, >GCPlayerTaskSPsEnd
			cmp h
			jnz @storeNextTaskSp
			; (GCPlayerCurrentTaskSPp) = GCPlayerTaskSPs[0]
			lxi h, GCPlayerTaskSPs
@storeNextTaskSp:
			shld GCPlayerCurrentTaskSPp
GCPlayerSchedulerRestoreSp:
			lxi sp, TEMP_ADDR
			ret
			.closelabels

; Parameters (forward):
; DE: source address (compressed data)
; BC: destination address (decompressing)
; unpack every 16 bytes into a current task circular buffer, 
; then call GCPlayerSchedulerStoreTaskContext
GCPlayerUnpack:
		lxi h, $ffff
		push h
		inx h
		mvi a, $80
@dzx0literals:
		call @dzx0Elias
		push psw
@dzx0Ldir1:
		ldax d
		stax b
		inx d					
		inr c 		; to stay inside the circular buffer
		; check if it's time to
		mvi a, $0f
		ana c
		cz GCPlayerSchedulerStoreTaskContext 

		dcx h
		mov a, h
		ora l
		jnz @dzx0Ldir1
		pop psw
		add a

		jc @dzx0newOffset
		call @dzx0Elias
@dzx0copy:
		xchg
		xthl
		push h
		dad b
		mov h, b ; to stay inside the circular buffer
		xchg

@dzx0ldirFromBuff:
		push psw
@dzx0ldirFromBuff1:
		ldax d
		stax b
		inr e		; to stay inside the circular buffer				
		inr c 		; to stay inside the circular buffer
		; check if it's time to
		mvi a, $0f
		ana c
		cz GCPlayerSchedulerStoreTaskContext 

		dcx h
		mov a, h
		ora l
		jnz @dzx0ldirFromBuff1
		mvi h, 0	; ----------- ???
		pop psw
		add a

		xchg
		pop h
		xthl
		xchg
		jnc @dzx0literals
@dzx0newOffset:
		call @dzx0Elias
		mov h, a
		pop psw
		xra a
		sub l
		jz @dzx0exit
		push h
		rar
        mov h, a
		ldax d
		rar
        mov l, a
		inx d
		xthl
		mov a, h
		lxi h, 1
		cnc @dzx0eliasBacktrack
		inx h
		jmp @dzx0copy

@dzx0Elias:
		inr l
@dzx0eliasLoop:	
		add a
		jnz @dzx0eliasSkip
		ldax d
		inx d
		ral
@dzx0eliasSkip:
		rc
@dzx0eliasBacktrack:
		dad h
		add a
		jnc @dzx0eliasLoop
		jmp @dzx0Elias

@dzx0exit:
		; restore sp
		lhld GCPlayerSchedulerRestoreSp+1
		sphl
		; pop GCPlayerSchedulerUpdate return addr 
		; to return right to the func that called GCPlayerUpdate
		pop psw
		; turn off the current music
		mvi a, OPCODE_RET
		sta GCPlayerUpdate
		;RAM_DISK_OFF()
		; return to the func that called GCPlayerUpdate		
		ret
		.closelabels
		
; Send buffers data to AY regs
; input:
; hl = bufferIdx
; reg13 (envelope shape) data = $ff means don't send data to reg13
; AY-3-8910 ports
AY_PORT_REG  = $15
AY_PORT_DATA = $14

GCPlayerAYUpdate:       
			mvi e, GC_PLAYER_TASKS - 1
			mov c, m                
			mvi b, (>GCPlayerBuffer00) + GC_PLAYER_TASKS - 1
				
			ldax b
			cpi $ff
			jz @doNotSendData
@sendData:           
			mov a, e
			out AY_PORT_REG
			ldax b
			out AY_PORT_DATA
@doNotSendData:                
			dcr b
			dcr e
			jp @sendData
			ret
			.closelabels

GCPlayerMute:       
			mvi e, GC_PLAYER_TASKS - 1
@sendData:
			mov a, e
			out AY_PORT_REG
			mvi a, 0
			out AY_PORT_DATA
			dcr e
			jp @sendData
			ret
			.closelabels

GCPlayerTaskSPs: .storage WORD_LEN * GC_PLAYER_TASKS
GCPlayerTaskSPsEnd     = *
; task stacks
GCPlayerTaskStack00: .storage GC_PLAYER_STACK_SIZE
GCPlayerTaskStack01: .storage GC_PLAYER_STACK_SIZE
GCPlayerTaskStack02: .storage GC_PLAYER_STACK_SIZE
GCPlayerTaskStack03: .storage GC_PLAYER_STACK_SIZE
GCPlayerTaskStack04: .storage GC_PLAYER_STACK_SIZE
GCPlayerTaskStack05: .storage GC_PLAYER_STACK_SIZE
GCPlayerTaskStack06: .storage GC_PLAYER_STACK_SIZE
GCPlayerTaskStack07: .storage GC_PLAYER_STACK_SIZE
GCPlayerTaskStack08: .storage GC_PLAYER_STACK_SIZE
GCPlayerTaskStack09: .storage GC_PLAYER_STACK_SIZE
GCPlayerTaskStack10: .storage GC_PLAYER_STACK_SIZE
GCPlayerTaskStack11: .storage GC_PLAYER_STACK_SIZE
GCPlayerTaskStack12: .storage GC_PLAYER_STACK_SIZE
GCPlayerTaskStack13: .storage GC_PLAYER_STACK_SIZE
; a pointer to a current task sp. *GCPlayerCurrentTaskSPp = GCPlayerTaskSPs[currentTask]
GCPlayerCurrentTaskSPp: .word TEMP_ADDR;
; buffers for unpacking the streams, must be aligned to 256 byte boundary
.align $100
GCPlayerBuffer00 : .storage $100
GCPlayerBuffer01 : .storage $100
GCPlayerBuffer02 : .storage $100
GCPlayerBuffer03 : .storage $100
GCPlayerBuffer04 : .storage $100
GCPlayerBuffer05 : .storage $100
GCPlayerBuffer06 : .storage $100
GCPlayerBuffer07 : .storage $100
GCPlayerBuffer08 : .storage $100
GCPlayerBuffer09 : .storage $100
GCPlayerBuffer10 : .storage $100
GCPlayerBuffer11 : .storage $100
GCPlayerBuffer12 : .storage $100
GCPlayerBuffer13 : .storage $100
/*
; DoUbTfuL FutUre... hi f4nZzz..;)
; MmcM^Sa9e 050720120452 ABC YM
; Created by Sergey Bulba's AY-3-8910/12 Emulator v2.9
GCPlayerAyRegDataPtrs: .word ayRegData00, ayRegData01, ayRegData02, ayRegData03, ayRegData04, ayRegData05, ayRegData06, ayRegData07, ayRegData08, ayRegData09, ayRegData10, ayRegData11, ayRegData12, ayRegData13, 
ayRegData00: .byte $85,$00,$68,$f9,$5a,$ba,$1e,$dc,$68,$f1,$68,$74,$79,$f4,$38,$ff,$9e,$b0,$a6,$e8,$79,$b8,$e0,$dc,$62,$4c,$a6,$54,$f5,$40,$f4,$64,$f5,$40,$5c,$c0,$80,$42,$3f,$2e,$17,$fe,$34,$80,$79,$b8,$e0,$dc,$7e,$65,$dc,$01,$f1,$40,$f5,$64,$f4,$dc,$1c,$de,$14,$f4,$73,$80,$17,$de,$ac,$dc,$07,$25,$a4,$8e,$17,$07,$dc,$47,$d7,$40,$de,$64,$40,$11,$26,$ba,$9d,$7c,$7d,$f4,$3b,$ac,$83,$d0,$bd,$b8,$dc,$03,$c3,$40,$de,$64,$40,$14,$66,$d1,$a6,$8c,$7d,$f4,$3b,$ac,$83,$d0,$bd,$b8,$dc,$03,$c3,$40,$de,$64,$40,$11,$24,$9f,$2e,$17,$17,$eb,$ba,$9d,$f4,$4e,$40,$e0,$e8,$ef,$b8,$dc,$40,$f0,$40,$f7,$64,$81,$40,$0c,$b9,$80,$f4,$ee,$eb,$7c,$dc,$f4,$f4,$ee,$ac,$d0,$0e,$b8,$f4,$dc,$0f,$40,$0f,$64,$78,$40,$44,$cc,$80,$01,$26,$d1,$a6,$8c,$7d,$f4,$3b,$ac,$83,$d0,$bd,$b8,$dc,$03,$c3,$40,$de,$64,$40,$11,$24,$9f,$2e,$17,$17,$eb,$ba,$9d,$f4,$4e,$40,$e0,$e8,$ef,$b8,$dc,$40,$f0,$40,$f7,$64,$81,$40,$0c,$b9,$80,$f4,$ee,$eb,$7c,$dc,$f4,$f4,$ee,$ac,$d0,$0e,$b8,$f4,$dc,$0f,$40,$0f,$64,$78,$40,$44,$cc,$80,$01,$26,$d1,$a6,$8c,$7d,$f4,$3b,$ac,$83,$d0,$bd,$b8,$dc,$03,$c3,$40,$de,$64,$40,$11,$24,$9f,$2e,$17,$17,$eb,$ba,$9d,$f4,$4e,$40,$e0,$e8,$ef,$b8,$dc,$40,$f0,$40,$f7,$64,$81,$40,$0c,$b9,$80,$f4,$ee,$eb,$7c,$dc,$f4,$f4,$ee,$ac,$d0,$0e,$b8,$f4,$dc,$0f,$40,$0f,$64,$78,$40,$44,$cc,$80,$01,$26,$d1,$a6,$8c,$7d,$f4,$3b,$ac,$83,$d0,$bd,$b8,$dc,$03,$c3,$40,$de,$64,$40,$11,$24,$9f,$2e,$17,$17,$eb,$ba,$9d,$f4,$4e,$40,$e0,$e8,$ef,$b8,$dc,$40,$f0,$40,$f7,$64,$81,$40,$0c,$b9,$80,$f4,$ee,$eb,$7c,$dc,$f4,$f4,$ee,$ac,$d0,$0e,$b8,$f4,$dc,$0f,$40,$0f,$64,$79,$40,$44,$cd,$80,$89,$ba,$b0,$4f,$dc,$c8,$80,$40,$e1,$40,$46,$67,$d1,$a6,$8c,$d3,$f4,$b8,$40,$d0,$3b,$b8,$90,$dc,$f8,$65,$dc,$07,$c3,$40,$df,$64,$40,$04,$8e,$17,$07,$dc,$46,$49,$2e,$17,$17,$eb,$ba,$9d,$f4,$f4,$ee,$64,$d0,$0e,$b8,$e4,$dc,$3e,$65,$dc,$01,$f0,$40,$f7,$64,$81,$40,$0c,$b9,$38,$f4,$ee,$67,$7c,$dc,$f4,$f4,$ee,$ac,$d0,$0e,$b8,$f4,$dc,$0f,$40,$0f,$64,$78,$40,$44,$cc,$80,$01,$26,$d1,$a6,$8c,$7d,$f4,$3b,$ac,$83,$d0,$bd,$b8,$dc,$03,$c3,$40,$de,$64,$40,$11,$24,$9f,$2e,$17,$17,$eb,$ba,$9d,$f4,$4e,$40,$e0,$e8,$ef,$b8,$dc,$40,$f0,$40,$f7,$64,$81,$40,$0c,$b9,$80,$f4,$ee,$eb,$7c,$dc,$f4,$f4,$ee,$ac,$d0,$0e,$b8,$f4,$dc,$0f,$40,$5f,$88,$56,$03,$f1,$51,$b1,$11,$71,$d1,$31,$91,$c5,$f0,$93,$2e,$be,$4e,$de,$6e,$fe,$9c,$f4,$d1,$80,$0e,$40,$14,$66,$d1,$a6,$8c,$7d,$f4,$3b,$ac,$83,$d0,$bd,$b8,$dc,$03,$c3,$40,$de,$64,$40,$11,$24,$9f,$2e,$17,$17,$eb,$ba,$9d,$f4,$4e,$40,$e0,$e8,$ef,$b8,$dc,$40,$f0,$40,$f7,$64,$81,$40,$0c,$b9,$80,$f4,$ee,$eb,$7c,$dc,$f4,$f4,$ee,$ac,$d0,$0e,$b8,$f4,$dc,$0f,$40,$0f,$64,$78,$40,$44,$cc,$80,$01,$26,$d1,$a6,$8c,$7d,$f4,$3b,$ac,$83,$d0,$bd,$b8,$dc,$03,$c3,$40,$de,$64,$40,$11,$24,$9f,$2e,$17,$17,$eb,$ba,$9d,$f4,$4e,$40,$e0,$e8,$ef,$b8,$dc,$40,$f0,$40,$f7,$64,$81,$40,$0c,$b9,$80,$f4,$ee,$eb,$7c,$dc,$f4,$f4,$ee,$ac,$d0,$0e,$b8,$f4,$dc,$0f,$40,$0f,$64,$78,$40,$44,$cc,$80,$01,$26,$d1,$a6,$8c,$7d,$f4,$3b,$ac,$83,$d0,$bd,$b8,$dc,$03,$c3,$40,$de,$64,$40,$11,$24,$9f,$2e,$17,$17,$eb,$ba,$9d,$f4,$4e,$40,$e0,$e8,$ef,$b8,$dc,$40,$f0,$40,$f7,$64,$81,$40,$0c,$b9,$80,$f4,$ee,$eb,$7c,$dc,$f4,$f4,$ee,$ac,$d0,$0e,$b8,$f4,$dc,$0f,$40,$0f,$64,$78,$40,$44,$cc,$80,$01,$26,$d1,$a6,$8c,$7d,$f4,$3b,$ac,$83,$d0,$bd,$b8,$dc,$03,$c3,$40,$de,$64,$40,$11,$24,$9f,$2e,$17,$17,$eb,$ba,$9d,$f4,$4e,$40,$e0,$e8,$ef,$b8,$dc,$40,$f0,$40,$f7,$64,$81,$40,$0c,$b9,$80,$f4,$ee,$eb,$7c,$dc,$f4,$f4,$ee,$ac,$d0,$0e,$b8,$f4,$dc,$0f,$40,$0f,$64,$78,$40,$44,$b9,$74,$fe,$55,$30,$00,$08
ayRegData01: .byte $85,$00,$5b,$01,$94,$f4,$b9,$00,$dc,$5e,$f4,$41,$e1,$40,$04,$23,$02,$01,$fc,$fe,$40,$5f,$b8,$78,$dc,$1a,$01,$01,$79,$ac,$5b,$00,$d5,$dc,$3d,$f4,$5e,$ac,$07,$d4,$88,$b8,$01,$dc,$1f,$40,$04,$79,$f4,$55,$19,$e0,$02,$01,$01,$b8,$5f,$dc,$15,$f5,$88,$e0,$dc,$07,$84,$f4,$15,$27,$02,$01,$01,$81,$b8,$7c,$dc,$57,$d7,$88,$80,$dc,$1e,$f4,$10,$54,$9e,$02,$01,$01,$b8,$05,$f1,$dc,$5f,$88,$5e,$dc,$00,$78,$f4,$41,$52,$78,$02,$01,$01,$b8,$17,$c4,$dc,$7d,$88,$17,$21,$b0,$0f,$dc,$14,$1a,$00,$04,$e1,$40,$54,$6e,$01,$dc,$46,$fd,$02,$cf,$40,$5f,$b8,$e4,$dc,$28,$01,$00,$e5,$d0,$7d,$40,$17,$84,$f4,$15,$27,$02,$01,$01,$81,$b8,$7c,$dc,$57,$d7,$88,$80,$dc,$1e,$f4,$15,$59,$e8,$02,$02,$03,$ff,$04,$aa,$05,$06,$28,$07,$aa,$08,$09,$2b,$0a,$97,$d0,$fe,$bb,$bc,$f4,$78,$04,$17,$91,$b8,$45,$98,$02,$01,$01,$10,$f1,$dc,$5f,$88,$5e,$dc,$00,$78,$f4,$41,$52,$78,$02,$01,$01,$b8,$17,$c5,$dc,$7d,$88,$78,$dc,$01,$e1,$f4,$05,$49,$e0,$02,$01,$01,$b8,$5f,$dc,$15,$f5,$88,$e0,$dc,$07,$84,$f4,$15,$27,$02,$01,$01,$81,$b8,$7c,$dc,$57,$d7,$88,$80,$dc,$1f,$f4,$05,$48,$39,$02,$03,$04,$01,$fe,$51,$70,$00,$08
ayRegData02: .byte $85,$00,$64,$39,$32,$ca,$a2,$06,$6a,$ce,$32,$96,$fa,$5e,$c2,$26,$e8,$e6,$dc,$e2,$a2,$fe,$86,$74,$86,$ba,$87,$f9,$9e,$e8,$d0,$07,$97,$a0,$95,$b8,$f4,$a0,$7d,$e8,$1e,$40,$79,$10,$5e,$40,$7d,$a0,$7d,$fe,$a1,$d1,$e7,$b8,$9e,$e8,$d0,$07,$d1,$a0,$1f,$10,$7d,$28,$7d,$fe,$a1,$17,$a1,$8c,$e7,$a0,$9e,$e8,$d0,$07,$d1,$a0,$1f,$10,$78,$28,$1e,$d0,$5b,$7c,$8f,$fe,$a0,$7d,$d0,$55,$f7,$e8,$99,$ac,$24,$32,$ca,$a2,$06,$6a,$ce,$e7,$e8,$9e,$dc,$c4,$6e,$74,$fe,$28,$ba,$79,$58,$e7,$a0,$81,$d0,$f5,$a0,$47,$9c,$28,$d7,$80,$da,$fe,$d1,$1e,$b8,$5e,$d0,$07,$d5,$a0,$1e,$dc,$72,$80,$06,$e2,$17,$fe,$87,$8c,$97,$a0,$81,$d0,$e0,$a0,$05,$c8,$80,$1e,$b8,$6e,$7c,$fe,$39,$a0,$78,$d0,$1e,$a0,$00,$5c,$81,$80,$b8,$74,$fe,$a1,$ba,$e5,$b8,$e0,$d0,$78,$a0,$17,$25,$38,$e0,$40,$17,$35,$80,$7d,$fe,$a1,$d1,$e5,$b8,$e0,$d0,$7d,$a0,$51,$e7,$1c,$20,$80,$6e,$17,$fe,$28,$8c,$79,$a0,$78,$d0,$1f,$a0,$40,$79,$1c,$e7,$40,$dc,$28,$d7,$80,$9b,$d0,$7c,$8e,$fe,$b8,$5e,$d0,$07,$c4,$a0,$1f,$28,$72,$80,$05,$b8,$74,$fe,$a1,$ba,$e7,$e8,$9e,$b8,$d0,$07,$d5,$a0,$1b,$d2,$8c,$fe,$d7,$80,$da,$fe,$d1,$1c,$97,$20,$81,$d0,$e0,$a0,$05,$c8,$80,$1b,$17,$8a,$fe,$8c,$1e,$e8,$79,$b8,$e0,$d0,$78,$a0,$01,$72,$80,$06,$e2,$f9,$fe,$87,$7c,$9e,$e8,$c4,$78,$d0,$1f,$a0,$10,$7d,$e8,$c9,$b0,$6e,$e2,$fe,$32,$80,$06,$e2,$74,$fe,$87,$ba,$9e,$e8,$b8,$78,$d0,$1f,$a0,$54,$6e,$d2,$fe,$33,$80,$5f,$fe,$68,$d1,$73,$14,$1f,$d0,$5e,$a0,$00,$5c,$81,$80,$b8,$17,$fe,$a1,$8c,$e7,$e8,$9e,$b8,$d0,$07,$80,$a0,$17,$20,$80,$6e,$f9,$fe,$28,$7c,$79,$e8,$e7,$c4,$81,$d0,$f1,$a0,$07,$dc,$28,$96,$b0,$e3,$e2,$fe,$25,$80,$b8,$d1,$ff,$1e,$f9,$ba,$a6,$7c,$5d,$53,$3e,$2f,$29,$ee,$41,$6e,$ba,$ff,$8a,$a6,$9d,$32,$bc,$e0,$e8,$41,$62,$4a,$e2,$b9,$f9,$e5,$39,$7c,$5d,$53,$3e,$2f,$29,$ee,$10,$e2,$fe,$85,$ba,$e6,$dc,$49,$7c,$88,$94,$a0,$ac,$b8,$38,$b8,$51,$3e,$e8,$e8,$9d,$ff,$a6,$f5,$e8,$49,$4e,$f1,$51,$b1,$11,$71,$d1,$f1,$61,$d1,$41,$b1,$21,$e9,$69,$fc,$1b,$a2,$8a,$fe,$74,$1e,$04,$59,$38,$32,$ca,$a2,$06,$6a,$ce,$d0,$1f,$a0,$40,$79,$4c,$e5,$a0,$e5,$dc,$e6,$a0,$e4,$88,$fe,$a1,$44,$e7,$c4,$97,$dc,$9e,$b8,$a0,$00,$5c,$81,$80,$b9,$5c,$fe,$28,$2e,$79,$b8,$e5,$dc,$e7,$b8,$80,$a0,$17,$20,$80,$6e,$f9,$fe,$28,$7c,$79,$e8,$e7,$c4,$81,$d0,$f0,$a0,$03,$c4,$fe,$28,$74,$68,$ba,$79,$40,$78,$d0,$1f,$a0,$54,$79,$28,$79,$dc,$c9,$20,$6e,$d1,$fe,$39,$b8,$78,$d0,$1f,$a0,$54,$79,$dc,$c8,$80,$1b,$17,$8a,$fe,$8c,$1e,$a0,$5e,$d0,$07,$80,$a0,$17,$20,$80,$79,$b8,$b8,$7c,$fe,$e5,$a0,$e0,$d0,$78,$a0,$01,$72,$80,$06,$e2,$74,$fe,$87,$ba,$97,$b8,$81,$d0,$e0,$a0,$5c,$97,$f8,$80,$40,$5c,$d5,$80,$f6,$fe,$87,$d1,$97,$b8,$81,$d0,$f5,$a0,$47,$9c,$1c,$81,$80,$b8,$17,$fe,$a1,$8c,$e5,$a0,$e0,$d0,$7d,$a0,$01,$e7,$1c,$9f,$40,$28,$73,$80,$5e,$d0,$6e,$7c,$fe,$39,$b8,$78,$d0,$1f,$a0,$10,$7d,$28,$c8,$80,$16,$e2,$74,$fe,$87,$ba,$9e,$e8,$b8,$78,$d0,$1f,$a0,$54,$6e,$d2,$fe,$33,$80,$5f,$fe,$68,$d1,$72,$20,$5e,$d0,$07,$80,$a0,$17,$20,$80,$6e,$17,$fe,$28,$8c,$79,$e8,$e7,$b8,$81,$d0,$e0,$a0,$05,$c8,$80,$1b,$f9,$8a,$fe,$7c,$1e,$e8,$79,$c4,$e0,$d0,$7c,$a0,$41,$f7,$e8,$25,$b0,$b8,$e2,$fe,$c8,$80,$1b,$74,$8a,$fe,$ba,$1e,$e8,$79,$b8,$e0,$d0,$7d,$a0,$51,$b8,$d2,$fe,$cd,$80,$7d,$fe,$a1,$d1,$cc,$14,$7d,$d0,$78,$a0,$01,$72,$80,$06,$e2,$17,$fe,$87,$8c,$9e,$e8,$b8,$78,$d0,$1e,$a0,$00,$5c,$81,$80,$b8,$f9,$fe,$a1,$7c,$e7,$e8,$9e,$c4,$d0,$07,$c4,$a0,$1f,$28,$72,$b0,$5b,$e2,$8c,$fe,$96,$80,$43,$4a,$e2,$ba,$f9,$ba,$a6,$7c,$5d,$53,$3e,$2f,$29,$90,$ee,$5e,$fe,$55,$70,$00,$08
ayRegData03: .byte $85,$00,$6a,$02,$22,$03,$02,$8a,$03,$04,$b9,$05,$e8,$f3,$f4,$bd,$df,$01,$fe,$e0,$94,$78,$d0,$1e,$a0,$5e,$b8,$57,$d1,$a0,$f4,$e8,$79,$40,$e5,$10,$72,$c8,$07,$25,$80,$5e,$a0,$55,$73,$80,$50,$4e,$4c,$43,$d5,$d0,$1e,$e8,$5f,$f4,$3b,$f3,$02,$e7,$ff,$d0,$9e,$e8,$f4,$72,$20,$47,$de,$b8,$d0,$07,$d1,$a0,$5c,$c0,$80,$11,$e7,$ce,$35,$80,$f7,$ac,$25,$20,$7d,$40,$7d,$a0,$55,$cd,$80,$73,$20,$57,$d7,$40,$d5,$a0,$c9,$38,$7d,$40,$17,$34,$80,$57,$dc,$a0,$d5,$80,$57,$97,$dc,$34,$80,$7d,$7c,$f5,$40,$e0,$d0,$7c,$a0,$41,$f7,$28,$35,$80,$73,$20,$5f,$e6,$f7,$a0,$81,$d0,$f5,$a0,$46,$e3,$05,$fe,$25,$80,$15,$f7,$a0,$31,$80,$01,$fd,$ad,$fc,$79,$c4,$e0,$d0,$7c,$a0,$41,$f7,$28,$25,$b0,$b8,$03,$fe,$c9,$80,$73,$20,$57,$d7,$d0,$d5,$a0,$1b,$05,$8c,$fe,$94,$80,$57,$dc,$a0,$c4,$80,$07,$f5,$ad,$fc,$e7,$c4,$81,$d0,$f1,$a0,$07,$dc,$28,$96,$b0,$e3,$03,$fe,$25,$80,$ca,$1e,$e5,$00,$fe,$51,$6a,$01,$21,$02,$00,$41,$08,$a8,$01,$02,$03,$e2,$f4,$f8,$04,$f8,$f6,$04,$05,$f4,$3d,$04,$01,$fe,$e5,$a0,$eb,$a2,$02,$e0,$ff,$d0,$7c,$a0,$55,$f7,$4c,$97,$40,$97,$dc,$9b,$a0,$06,$92,$fe,$87,$03,$9e,$c4,$dc,$5e,$c4,$78,$a0,$01,$72,$80,$06,$e4,$04,$fe,$ff,$ca,$c4,$78,$dc,$7d,$e8,$e0,$a0,$11,$cd,$80,$6e,$00,$fe,$03,$9e,$c4,$d0,$07,$c0,$a0,$5e,$fe,$45,$e5,$a0,$e0,$40,$78,$d0,$1f,$a0,$54,$79,$28,$79,$f4,$c9,$80,$45,$1e,$ce,$73,$80,$5f,$ac,$72,$20,$57,$d7,$40,$d5,$a0,$5c,$d7,$80,$35,$20,$7d,$40,$7d,$a0,$5c,$97,$f8,$d1,$40,$73,$80,$45,$7d,$a0,$cd,$80,$55,$79,$1c,$73,$80,$47,$df,$7c,$40,$5e,$d0,$07,$c4,$a0,$1f,$28,$73,$80,$57,$35,$20,$ff,$e6,$a0,$78,$d0,$1f,$a0,$54,$6e,$05,$fe,$32,$80,$51,$5f,$a0,$73,$80,$10,$1f,$ad,$d7,$fc,$9e,$c4,$d0,$07,$c4,$a0,$1f,$28,$72,$b0,$5b,$03,$8c,$fe,$97,$80,$35,$20,$7d,$d0,$7d,$a0,$51,$b8,$05,$fe,$c9,$80,$45,$7d,$a0,$cc,$80,$40,$7f,$ad,$fc,$5e,$c4,$78,$d0,$1f,$a0,$10,$7d,$28,$c9,$b0,$6e,$03,$fe,$32,$80,$5f,$c1,$e5,$77,$fe,$45,$c0,$00,$20
ayRegData04: .byte $85,$00,$67,$ba,$9d,$7c,$c4,$fa,$42,$61,$d1,$a6,$8c,$54,$66,$eb,$ba,$9d,$15,$46,$61,$ba,$9d,$7c,$54,$64,$38,$4a,$e2,$ba,$f9,$ba,$a6,$7c,$5d,$53,$3e,$2f,$29,$ee,$43,$92,$fe,$87,$ba,$95,$e8,$e0,$dc,$6e,$a6,$fe,$4f,$ac,$09,$f7,$b5,$b0,$ab,$c8,$96,$ac,$e4,$9d,$fe,$e5,$dc,$e7,$64,$9c,$d0,$91,$e0,$f5,$dc,$73,$8c,$47,$f2,$04,$e0,$45,$e5,$40,$97,$f9,$ed,$e1,$d5,$c9,$bd,$b1,$24,$38,$f4,$88,$6e,$eb,$fe,$4e,$04,$7d,$dc,$4e,$fe,$4e,$dc,$57,$25,$80,$e7,$dc,$34,$f8,$39,$ff,$21,$9a,$97,$94,$91,$8e,$8c,$e7,$d0,$ce,$e8,$6e,$58,$3c,$a0,$9a,$94,$8e,$dc,$e5,$b8,$c9,$08,$72,$80,$78,$dc,$17,$97,$ac,$81,$e8,$e5,$10,$e7,$dc,$d3,$e8,$36,$e0,$7e,$88,$82,$7c,$fe,$86,$a6,$86,$7c,$85,$8c,$f0,$dc,$87,$92,$98,$9e,$a4,$a6,$20,$44,$73,$80,$55,$f5,$dc,$78,$4c,$17,$25,$20,$e5,$dc,$b9,$9d,$fe,$39,$dc,$79,$1c,$e7,$d0,$20,$80,$17,$d7,$e8,$25,$e0,$e7,$dc,$34,$e0,$79,$40,$65,$c9,$f9,$ed,$e1,$d5,$c9,$bd,$b1,$68,$02,$e4,$eb,$fe,$e7,$04,$d4,$dc,$e4,$fe,$f4,$dc,$5c,$95,$38,$c9,$08,$57,$81,$a0,$e5,$e8,$7d,$c4,$49,$21,$b7,$b4,$b1,$ae,$ab,$a8,$73,$bc,$46,$e4,$8c,$fe,$e5,$dc,$c9,$b0,$79,$dc,$7d,$88,$cd,$8c,$60,$e4,$4a,$e2,$ba,$f9,$4f,$e5,$7c,$5d,$53,$3e,$2f,$29,$ee,$b8,$27,$b8,$a1,$29,$b8,$2f,$04,$e6,$e8,$7b,$8c,$84,$7c,$fe,$97,$d0,$fe,$e1,$dc,$a0,$58,$20,$29,$ac,$b2,$b8,$2e,$75,$fe,$39,$a0,$79,$dc,$e5,$40,$67,$75,$6f,$69,$b9,$fe,$a0,$79,$dc,$87,$69,$75,$81,$8d,$99,$37,$74,$fe,$40,$ff,$94,$4e,$64,$79,$70,$79,$40,$59,$ee,$69,$63,$5d,$fe,$40,$5f,$e1,$f9,$dc,$a0,$5b,$53,$8e,$fe,$70,$5e,$dc,$72,$80,$55,$e5,$a0,$72,$80,$55,$93,$ba,$a4,$8e,$82,$76,$75,$c3,$40,$8e,$fe,$a0,$56,$e3,$7c,$fe,$97,$a0,$9f,$dc,$40,$02,$19,$aa,$9a,$94,$8e,$8c,$09,$f8,$9d,$94,$8c,$fe,$ca,$92,$98,$80,$86,$a6,$86,$ba,$91,$a6,$18,$fe,$17,$5d,$fe,$d0,$5e,$dc,$79,$a0,$58,$fe,$1a,$69,$fe,$d0,$5e,$dc,$72,$20,$56,$80,$1f,$69,$1f,$46,$0c,$4a,$e2,$ba,$f9,$86,$6b,$7c,$5d,$53,$3e,$2f,$e5,$ee,$e5,$40,$62,$8c,$84,$00,$a0,$7c,$18,$20,$29,$ac,$b2,$b8,$2e,$75,$fe,$39,$a0,$79,$dc,$c9,$20,$58,$80,$75,$6f,$3b,$dc,$e4,$fe,$93,$75,$81,$8d,$99,$9d,$a6,$fe,$40,$ff,$94,$4e,$64,$79,$70,$79,$40,$59,$ee,$69,$63,$5d,$fe,$40,$5f,$e1,$f9,$dc,$a0,$5b,$53,$8e,$fe,$d0,$5e,$dc,$72,$80,$55,$e5,$a0,$72,$80,$55,$93,$ba,$a4,$8e,$82,$76,$75,$c3,$40,$8e,$fe,$a0,$56,$e3,$7c,$fe,$97,$a0,$9f,$dc,$40,$02,$19,$aa,$9a,$94,$8e,$8c,$09,$f8,$9d,$94,$8c,$fe,$ca,$92,$98,$80,$86,$a6,$86,$ba,$91,$a6,$18,$fe,$17,$5d,$fe,$d0,$5e,$dc,$79,$a0,$58,$fe,$1a,$69,$fe,$70,$5e,$dc,$72,$20,$56,$80,$1f,$69,$1f,$46,$e3,$44,$fe,$a7,$9a,$74,$39,$f9,$9b,$f4,$3e,$8e,$fe,$dc,$53,$ff,$c4,$ac,$cf,$fe,$94,$99,$3b,$3b,$3b,$b8,$75,$fe,$a3,$1d,$cf,$dc,$b8,$78,$a0,$3d,$dc,$1e,$04,$14,$f7,$1c,$fb,$fc,$28,$96,$a0,$79,$a2,$4c,$17,$f4,$f4,$dc,$3f,$c4,$fc,$ac,$fe,$fe,$94,$6a,$eb,$94,$75,$df,$fe,$dc,$3d,$b8,$e0,$a0,$e1,$dc,$4c,$81,$e0,$72,$80,$7b,$28,$96,$a0,$ce,$d5,$67,$f4,$7d,$dc,$0f,$c4,$ff,$ac,$fe,$3f,$a0,$bb,$64,$88,$20,$80,$f3,$dc,$de,$b8,$a0,$0e,$dc,$14,$c8,$e0,$17,$20,$80,$e5,$a0,$ee,$7f,$f9,$f4,$7d,$dc,$0f,$c4,$ff,$ac,$fe,$3f,$94,$bb,$6a,$dc,$20,$80,$f3,$dc,$de,$b8,$a0,$0e,$dc,$14,$c8,$e0,$17,$26,$80,$42,$3b,$5b,$7b,$9b,$bb,$db,$4a,$e2,$ba,$f9,$ba,$a6,$87,$5d,$53,$3e,$2f,$29,$97,$ee,$35,$80,$4f,$3c,$9a,$4b,$5b,$6b,$c9,$8b,$80,$40,$f7,$40,$d9,$c4,$e7,$a2,$4c,$17,$f4,$d0,$dc,$ff,$c4,$ac,$f3,$fe,$fb,$94,$6c,$b2,$94,$80,$0e,$dc,$f4,$40,$f3,$4c,$df,$94,$dc,$47,$20,$e0,$5c,$90,$80,$b3,$d5,$4f,$9f,$f4,$dc,$43,$ff,$c4,$ac,$cf,$fe,$a0,$ee,$64,$dc,$c8,$80,$3b,$dc,$d3,$40,$cf,$4c,$94,$7d,$dc,$1c,$81,$e0,$72,$80,$43,$b9,$7f,$f9,$f4,$f4,$dc,$3f,$c4,$fc,$ac,$fe,$fe,$94,$6c,$ec,$dc,$83,$80,$bd,$dc,$40,$3c,$4c,$f7,$94,$90,$dc,$f5,$04,$79,$bd,$12,$44,$4a,$50,$56,$5c,$62,$68,$6e,$74,$7a,$80,$86,$8c,$92,$98,$9e,$a4,$aa,$b0,$b6,$bc,$c2,$c8,$4a,$e2,$ba,$86,$ba,$a6,$7c,$5d,$53,$8e,$2f,$29,$ee,$10,$e4,$fe,$a1,$ba,$e5,$e8,$78,$dc,$1b,$a6,$93,$fe,$c2,$ac,$7d,$b5,$b0,$ab,$ce,$e5,$ac,$b9,$9d,$fe,$39,$dc,$79,$b8,$e7,$d0,$24,$e0,$7d,$dc,$5c,$d1,$8c,$fc,$04,$91,$e0,$79,$40,$65,$c9,$f9,$ed,$e1,$d5,$c9,$bd,$b1,$38,$3d,$88,$1b,$eb,$93,$fe,$9f,$04,$dc,$53,$93,$fe,$95,$dc,$c9,$80,$79,$dc,$cd,$f8,$0e,$ff,$48,$9a,$97,$94,$91,$8e,$8c,$79,$d0,$f3,$e8,$96,$6e,$0f,$a0,$9a,$94,$8e,$dc,$39,$b8,$72,$08,$5c,$9e,$80,$dc,$05,$e5,$ac,$e0,$e8,$79,$10,$79,$dc,$f4,$e8,$cd,$e0,$9f,$88,$82,$7c,$fe,$a1,$a6,$a1,$7c,$a1,$8c,$7c,$dc,$21,$c8,$92,$98,$9e,$a4,$a6,$44,$1c,$d5,$80,$7d,$dc,$5e,$4c,$05,$c9,$20,$79,$dc,$6e,$9d,$fe,$4e,$dc,$5e,$1c,$79,$d0,$c8,$80,$05,$f5,$e8,$c9,$e0,$79,$dc,$cd,$e0,$1e,$40,$59,$72,$f9,$ed,$e1,$d5,$c9,$bd,$b1,$68,$40,$b9,$eb,$fe,$39,$04,$f5,$dc,$39,$fe,$3d,$dc,$17,$25,$38,$72,$08,$55,$e0,$a0,$79,$e8,$5f,$c4,$52,$48,$b7,$b4,$b1,$ae,$ab,$a8,$5c,$d1,$bc,$b9,$8c,$fe,$39,$dc,$72,$b0,$5e,$dc,$5f,$88,$73,$8c,$58,$39,$4a,$e2,$ba,$f9,$4f,$39,$7c,$5d,$53,$3e,$2f,$29,$ee,$6e,$27,$b8,$28,$29,$6e,$2f,$04,$39,$e8,$9e,$8c,$84,$7c,$fe,$e5,$d0,$ff,$e1,$dc,$96,$a0,$08,$29,$ac,$b2,$b8,$0b,$75,$8e,$fe,$a0,$5e,$dc,$79,$40,$59,$ee,$75,$6f,$69,$fe,$a0,$5e,$dc,$61,$cd,$69,$75,$81,$8d,$99,$74,$ff,$40,$ff,$93,$94,$9e,$64,$70,$5e,$40,$56,$7b,$69,$63,$5d,$fe,$97,$40,$fe,$e1,$dc,$a0,$56,$e3,$53,$fe,$97,$d0,$9c,$dc,$95,$80,$79,$a0,$5c,$95,$80,$64,$f0,$ba,$a4,$8e,$82,$76,$75,$40,$e3,$fe,$95,$a0,$b8,$7c,$fe,$e5,$a0,$e7,$dc,$c0,$40,$86,$aa,$9a,$94,$8e,$8c,$42,$7e,$9d,$94,$8c,$fe,$32,$92,$98,$80,$a1,$a6,$a1,$ba,$a4,$a6,$46,$3f,$17,$5d,$fe,$97,$d0,$9e,$dc,$a0,$56,$3f,$1a,$69,$fe,$97,$d0,$9c,$dc,$95,$20,$a0,$1f,$1a,$1f,$51,$83,$4a,$e2,$ba,$f9,$21,$6b,$b9,$7c,$5d,$53,$3e,$2f,$ee,$79,$40,$58,$80,$8c,$84,$28,$7c,$06,$08,$29,$ac,$b2,$b8,$0b,$75,$8e,$fe,$a0,$5e,$dc,$72,$20,$56,$20,$75,$6f,$0e,$dc,$f9,$fe,$24,$75,$81,$8d,$99,$9d,$a6,$ff,$40,$ff,$93,$94,$9e,$64,$70,$5e,$40,$56,$7b,$69,$63,$5d,$fe,$97,$40,$fe,$e1,$dc,$a0,$56,$e3,$53,$fe,$97,$d0,$9c,$dc,$95,$80,$79,$a0,$5c,$95,$80,$64,$f0,$ba,$a4,$8e,$82,$76,$75,$40,$e3,$fe,$95,$a0,$b8,$7c,$fe,$e5,$a0,$e7,$dc,$c0,$40,$86,$aa,$9a,$94,$8e,$8c,$42,$7e,$9d,$94,$8c,$fe,$32,$92,$98,$80,$a1,$a6,$a1,$ba,$a4,$a6,$46,$3f,$17,$5d,$fe,$97,$d0,$9e,$dc,$a0,$56,$3f,$1a,$69,$fe,$97,$70,$9c,$dc,$95,$20,$a0,$1f,$1a,$1f,$54,$8e,$9d,$7c,$fa,$45,$3c,$fe,$11,$c0,$00,$20
ayRegData05: .byte $90,$00,$45,$5a,$01,$88,$02,$00,$55,$54,$2a,$01,$21,$02,$00,$55,$42,$a2,$01,$02,$00,$15,$54,$20,$8e,$04,$05,$06,$03,$e8,$8b,$01,$01,$df,$f4,$ca,$e4,$dc,$44,$f6,$e8,$e7,$01,$f4,$91,$dc,$47,$30,$80,$44,$f3,$f4,$90,$dc,$57,$da,$d6,$02,$f0,$fe,$e0,$34,$47,$cc,$71,$80,$01,$f5,$34,$bd,$01,$f4,$f5,$dc,$5e,$4c,$51,$7f,$40,$31,$80,$14,$f7,$f4,$d5,$dc,$79,$4c,$15,$c9,$92,$4a,$02,$e5,$fe,$55,$16,$a2,$01,$02,$00,$15,$54,$2a,$01,$25,$02,$00,$15,$43,$00,$00,$80
ayRegData06: .byte $90,$00,$68,$03,$46,$85,$10,$a2,$00,$80,$0f,$a1,$0e,$68,$00,$a0,$0d,$28,$0c,$5a,$00,$28,$0b,$0a,$0a,$16,$8a,$00,$09,$02,$85,$0e,$a3,$06,$90,$70,$ee,$d0,$70,$43,$b8,$a0,$70,$2e,$08,$fe,$4a,$06,$28,$07,$0a,$06,$17,$97,$d0,$97,$a0,$97,$70,$97,$40,$97,$10,$25,$e0,$c9,$b0,$73,$80,$4b,$0f,$da,$fe,$10,$16,$8a,$06,$11,$02,$85,$12,$a2,$06,$80,$13,$a1,$14,$68,$06,$a0,$15,$28,$16,$5e,$d0,$5e,$a0,$5e,$70,$5e,$40,$5e,$10,$5c,$97,$e0,$25,$b0,$c9,$80,$72,$50,$5c,$d2,$20,$f6,$0b,$fe,$85,$0a,$a2,$06,$80,$09,$a1,$08,$68,$06,$a0,$07,$28,$06,$5e,$d0,$5e,$a0,$5e,$70,$5e,$40,$5e,$10,$5c,$97,$e0,$25,$b0,$c9,$80,$72,$50,$5c,$d2,$20,$f6,$11,$fe,$85,$12,$a1,$06,$68,$03,$7c,$e8,$e4,$fe,$a2,$13,$80,$10,$a3,$00,$83,$40,$97,$10,$b2,$d0,$e0,$0e,$40,$5e,$d0,$cb,$8c,$9e,$0a,$be,$78,$70,$32,$20,$0f,$70,$49,$93,$07,$07,$07,$9c,$c4,$9e,$20,$70,$bd,$05,$fe,$a1,$0a,$68,$00,$a2,$03,$86,$09,$86,$05,$86,$08,$8a,$03,$04,$02,$85,$06,$a2,$00,$8a,$01,$07,$1e,$a0,$5f,$70,$f7,$fe,$c7,$40,$ee,$10,$0b,$fe,$33,$e0,$4b,$07,$dc,$fe,$d3,$80,$ae,$b8,$0f,$fe,$33,$20,$4b,$0b,$da,$fe,$12,$16,$8a,$00,$0d,$28,$13,$68,$03,$68,$06,$68,$03,$5a,$16,$16,$8a,$00,$0f,$28,$15,$68,$11,$68,$14,$7f,$70,$df,$fe,$40,$1f,$10,$e7,$ac,$34,$e0,$bd,$09,$fe,$cc,$80,$73,$50,$e7,$ac,$34,$20,$bd,$05,$fe,$a1,$0a,$68,$00,$a2,$03,$86,$09,$86,$05,$86,$08,$8a,$03,$04,$02,$85,$06,$a2,$00,$8a,$01,$07,$1e,$a0,$5f,$70,$f7,$fe,$c7,$40,$ee,$10,$0b,$fe,$33,$e0,$4b,$07,$dc,$fe,$d3,$80,$ae,$b8,$0f,$fe,$33,$20,$4b,$0b,$da,$fe,$12,$16,$8a,$00,$0d,$28,$13,$68,$11,$a2,$03,$86,$06,$85,$03,$a1,$16,$68,$00,$a2,$0f,$86,$15,$86,$11,$87,$14,$fd,$70,$fe,$f1,$40,$fe,$10,$ac,$72,$e0,$5e,$34,$ec,$70,$9c,$5c,$c7,$80,$3e,$50,$ac,$73,$20,$4b,$05,$da,$fe,$0a,$16,$8a,$00,$03,$28,$09,$68,$05,$68,$08,$68,$03,$a0,$04,$28,$06,$5a,$00,$28,$01,$a1,$07,$e5,$a0,$ff,$70,$fe,$7c,$40,$7e,$10,$e3,$0b,$fe,$34,$e0,$bd,$07,$fe,$cd,$80,$3a,$b8,$e3,$0f,$fe,$25,$20,$eb,$a0,$0b,$da,$fe,$12,$16,$8a,$00,$0d,$28,$13,$68,$03,$68,$06,$68,$03,$5a,$16,$16,$8a,$00,$0f,$28,$15,$68,$11,$68,$14,$7f,$70,$df,$fe,$40,$1f,$10,$e7,$ac,$34,$e0,$bd,$09,$fe,$cc,$80,$73,$50,$e7,$ac,$34,$20,$bd,$05,$fe,$a1,$0a,$68,$00,$a2,$03,$86,$09,$86,$05,$86,$08,$8a,$03,$04,$02,$85,$06,$a2,$00,$8a,$01,$07,$1e,$a0,$5f,$70,$f7,$fe,$c7,$40,$ee,$10,$0b,$fe,$33,$e0,$4b,$07,$dc,$fe,$d3,$80,$ae,$b8,$0f,$fe,$33,$20,$4b,$0b,$da,$fe,$12,$16,$8a,$06,$13,$02,$86,$03,$86,$06,$85,$03,$ee,$ca,$76,$0b,$0f,$92,$fe,$86,$11,$86,$14,$8a,$00,$0d,$03,$97,$40,$9e,$10,$ac,$73,$e0,$4b,$09,$dc,$fe,$c7,$80,$3e,$50,$ac,$73,$20,$4b,$05,$da,$fe,$0a,$16,$8a,$00,$03,$28,$09,$68,$05,$68,$08,$68,$04,$5a,$06,$16,$8a,$00,$01,$03,$97,$a0,$fd,$70,$fe,$e5,$40,$e5,$10,$cd,$e0,$2f,$07,$fe,$72,$80,$5c,$97,$50,$34,$20,$bd,$0b,$fe,$a1,$12,$68,$00,$a0,$0d,$28,$03,$68,$06,$68,$03,$5a,$16,$16,$8a,$00,$0f,$28,$15,$68,$11,$68,$14,$79,$70,$7c,$40,$7f,$10,$9c,$ac,$97,$e0,$25,$b0,$cc,$80,$73,$50,$e7,$ac,$34,$20,$bd,$05,$fe,$a1,$0a,$68,$00,$a2,$03,$86,$09,$86,$05,$86,$08,$85,$04,$a1,$06,$68,$00,$a0,$01,$39,$a0,$7f,$70,$de,$fe,$40,$5e,$10,$5c,$d2,$e0,$f7,$07,$fe,$25,$80,$c9,$50,$73,$20,$4b,$0b,$da,$fe,$12,$17,$27,$d4,$9c,$10,$83,$bc,$f9,$76,$fe,$28,$13,$e0,$76,$b9,$0f,$fe,$28,$11,$68,$14,$68,$00,$a0,$0d,$39,$40,$79,$10,$e7,$ac,$25,$e0,$e5,$3a,$cc,$80,$73,$50,$e7,$ac,$34,$20,$bd,$05,$fe,$a1,$0a,$68,$00,$a2,$03,$86,$09,$86,$05,$86,$08,$85,$04,$a1,$06,$68,$00,$a0,$01,$39,$a0,$7f,$70,$de,$fe,$40,$5e,$10,$5c,$d2,$e0,$f7,$07,$fe,$25,$80,$c9,$50,$73,$20,$4b,$0b,$da,$fe,$12,$16,$8a,$00,$0d,$02,$86,$03,$86,$06,$85,$03,$a1,$16,$68,$00,$a2,$0f,$86,$15,$86,$11,$87,$14,$97,$70,$c7,$40,$f9,$10,$ac,$c9,$e0,$72,$b0,$5c,$c7,$80,$3e,$50,$ac,$73,$20,$4b,$05,$da,$fe,$0a,$16,$8a,$00,$03,$28,$09,$68,$05,$68,$08,$68,$04,$5a,$06,$16,$8a,$00,$01,$03,$97,$a0,$fd,$70,$fe,$e5,$40,$e5,$10,$cd,$e0,$2f,$07,$fe,$72,$80,$5c,$97,$50,$34,$20,$bd,$0b,$fe,$a1,$12,$72,$d4,$79,$10,$c8,$bc,$3f,$76,$92,$fe,$8e,$16,$dc,$e6,$76,$f8,$0f,$ff,$f4,$3f,$22,$db,$f4,$0d,$92,$fe,$85,$0c,$a1,$0b,$68,$0a,$5a,$09,$16,$85,$08,$a1,$07,$68,$06,$5a,$05,$16,$85,$04,$a1,$03,$68,$02,$5a,$01,$16,$85,$00,$e5,$d0,$e5,$a0,$e5,$70,$e5,$40,$e5,$10,$c9,$e0,$72,$b0,$5c,$97,$80,$25,$50,$c9,$20,$6e,$0b,$fe,$4a,$0c,$16,$85,$0d,$a1,$0e,$68,$0f,$5a,$10,$88,$13,$10,$0e,$d0,$5e,$a0,$5e,$70,$5e,$40,$5e,$10,$5c,$97,$e0,$25,$b0,$c9,$80,$72,$50,$5c,$96,$20,$e4,$05,$fe,$a1,$04,$68,$03,$5a,$02,$16,$85,$01,$a1,$00,$79,$d0,$79,$a0,$79,$70,$79,$40,$79,$10,$72,$e0,$5c,$97,$b0,$25,$80,$c9,$50,$72,$20,$5b,$0b,$92,$fe,$85,$0c,$a1,$0d,$68,$0e,$5a,$0f,$16,$8a,$13,$10,$02,$8a,$00,$0f,$02,$a9,$0e,$11,$e7,$94,$b8,$d0,$70,$39,$40,$7b,$d0,$83,$0a,$3f,$f5,$c4,$27,$e0,$b2,$d0,$aa,$0c,$97,$80,$b2,$d0,$4a,$0c,$fc,$35,$c4,$9e,$14,$70,$bd,$05,$fe,$a1,$04,$68,$00,$a0,$03,$a6,$06,$a9,$02,$05,$a1,$02,$ae,$01,$b8,$4f,$fe,$1a,$01,$03,$97,$a0,$fd,$70,$fe,$e5,$40,$e5,$10,$c9,$e0,$72,$b0,$5c,$97,$80,$25,$50,$cd,$20,$2f,$0b,$fe,$68,$0c,$5a,$00,$28,$0d,$0c,$9c,$fa,$df,$b2,$e9,$da,$fe,$10,$16,$8a,$00,$0f,$02,$a9,$0e,$11,$a1,$0e,$e5,$70,$e5,$40,$e5,$10,$c9,$e0,$72,$b0,$5c,$97,$80,$25,$50,$cd,$20,$2f,$05,$fe,$68,$04,$5c,$fd,$ae,$fe,$aa,$02,$05,$68,$02,$7b,$d2,$87,$b8,$c6,$fe,$80,$01,$e5,$a0,$e5,$70,$e5,$40,$e5,$10,$c9,$e0,$72,$b0,$5c,$97,$80,$25,$50,$cd,$20,$2f,$0b,$fe,$68,$0c,$5a,$0d,$16,$85,$0e,$a1,$0f,$68,$13,$a0,$10,$3b,$70,$83,$ca,$97,$a0,$b8,$10,$70,$2e,$12,$fe,$4e,$10,$6e,$11,$fe,$39,$34,$e7,$70,$25,$b0,$f1,$70,$cf,$50,$9e,$ac,$c4,$72,$a4,$7a,$70,$f6,$05,$fe,$85,$0a,$a2,$00,$8a,$03,$09,$1a,$05,$1a,$08,$1a,$03,$28,$04,$0a,$06,$16,$8a,$00,$01,$28,$07,$79,$a0,$7f,$70,$df,$fe,$40,$1f,$10,$b8,$0b,$fe,$cd,$e0,$2f,$07,$fe,$73,$80,$4e,$b8,$b8,$0f,$fe,$cd,$20,$2f,$0b,$fe,$68,$12,$5a,$00,$28,$0d,$a1,$13,$a1,$03,$a1,$06,$a1,$03,$68,$16,$5a,$00,$28,$0f,$a1,$15,$a1,$11,$a1,$14,$ff,$70,$fe,$7c,$40,$7f,$10,$9c,$ac,$d2,$e0,$f7,$09,$fe,$31,$80,$cf,$50,$9c,$ac,$d2,$20,$f6,$05,$fe,$85,$0a,$a2,$00,$8a,$03,$09,$1a,$05,$1a,$08,$1a,$03,$28,$04,$0a,$06,$16,$8a,$00,$01,$28,$07,$79,$a0,$7f,$70,$df,$fe,$40,$1f,$10,$b8,$0b,$fe,$cd,$e0,$2f,$07,$fe,$73,$80,$4e,$b8,$b8,$0f,$fe,$cd,$20,$2f,$0b,$fe,$68,$12,$5a,$00,$28,$0d,$a1,$13,$a2,$11,$8a,$03,$06,$1a,$03,$16,$85,$16,$a2,$00,$8a,$0f,$15,$1a,$11,$1a,$14,$1f,$70,$f7,$fe,$c7,$40,$f9,$10,$ac,$c9,$e0,$7b,$34,$b2,$70,$5c,$73,$80,$1c,$f9,$50,$ac,$cd,$20,$2f,$05,$fe,$68,$0a,$5a,$00,$28,$03,$a1,$09,$a1,$05,$a1,$08,$a2,$03,$80,$04,$a1,$06,$68,$00,$a2,$01,$87,$07,$97,$a0,$fd,$70,$fe,$f1,$40,$fb,$10,$0b,$8c,$fe,$d2,$e0,$f7,$07,$fe,$34,$80,$eb,$b8,$0f,$8c,$fe,$97,$20,$af,$a0,$0b,$fe,$68,$12,$5a,$00,$28,$0d,$a1,$13,$a1,$03,$a1,$06,$a1,$03,$68,$16,$5a,$00,$28,$0f,$a1,$15,$a1,$11,$a1,$14,$ff,$70,$fe,$7c,$40,$7f,$10,$9c,$ac,$d2,$e0,$f7,$09,$fe,$31,$80,$cf,$50,$9c,$ac,$d2,$20,$f6,$05,$fe,$85,$0a,$a2,$00,$8a,$03,$09,$1a,$05,$1a,$08,$1a,$03,$28,$04,$0a,$06,$16,$8a,$00,$01,$28,$07,$79,$a0,$7f,$70,$df,$fe,$40,$1f,$10,$b8,$0b,$fe,$cd,$e0,$2f,$07,$fe,$73,$80,$4e,$b8,$b8,$0f,$fe,$cd,$20,$2f,$0b,$fe,$68,$12,$5a,$06,$28,$13,$0a,$03,$1a,$06,$1a,$03,$17,$b8,$ca,$76,$2e,$0f,$fe,$4a,$11,$1a,$14,$1a,$00,$28,$0d,$0e,$40,$5e,$10,$79,$ac,$cd,$e0,$2f,$09,$fe,$73,$80,$1c,$f9,$50,$ac,$cd,$20,$2f,$05,$fe,$68,$0a,$5a,$00,$28,$03,$a1,$09,$a1,$05,$a1,$08,$a1,$04,$68,$06,$5a,$00,$28,$01,$0e,$a0,$5f,$70,$f7,$fe,$97,$40,$97,$10,$34,$e0,$bd,$07,$fe,$c9,$80,$72,$50,$5c,$d2,$20,$f6,$0b,$fe,$85,$12,$a2,$00,$80,$0d,$a1,$03,$a1,$06,$a1,$03,$68,$16,$5a,$00,$28,$0f,$a1,$15,$a1,$11,$a1,$14,$e5,$70,$f1,$40,$fe,$10,$ac,$72,$e0,$5c,$97,$b0,$31,$80,$cf,$50,$9c,$ac,$d2,$20,$f6,$05,$fe,$85,$0a,$a2,$00,$8a,$03,$09,$1a,$05,$1a,$08,$1a,$04,$16,$85,$06,$a2,$00,$80,$01,$e5,$a0,$ff,$70,$fe,$79,$40,$79,$10,$73,$e0,$4b,$07,$dc,$fe,$97,$80,$25,$50,$cd,$20,$2f,$0b,$fe,$68,$12,$5c,$9e,$d4,$10,$72,$bc,$0f,$76,$e4,$fe,$a3,$13,$82,$76,$e4,$0f,$fe,$a1,$11,$a1,$14,$a2,$00,$80,$0d,$e5,$40,$e7,$10,$9c,$ac,$97,$e0,$97,$3a,$31,$80,$cf,$50,$9c,$ac,$d2,$20,$f6,$05,$fe,$85,$0a,$a2,$00,$8a,$03,$09,$1a,$05,$1a,$08,$1a,$04,$16,$85,$06,$a2,$00,$80,$01,$e5,$a0,$ff,$70,$fe,$79,$40,$79,$10,$73,$e0,$4b,$07,$dc,$fe,$97,$80,$25,$50,$cd,$20,$2f,$0b,$fe,$68,$12,$5a,$00,$28,$0d,$0a,$03,$1a,$06,$1a,$03,$16,$85,$16,$a2,$00,$8a,$0f,$15,$1a,$11,$1a,$14,$1e,$70,$5f,$40,$1f,$10,$e7,$ac,$25,$e0,$c9,$b0,$73,$80,$1c,$f9,$50,$ac,$cd,$20,$2f,$05,$fe,$68,$0a,$5a,$00,$28,$03,$a1,$09,$a1,$05,$a1,$08,$a1,$04,$68,$06,$5a,$00,$28,$01,$0e,$a0,$5f,$70,$f7,$fe,$97,$40,$97,$10,$34,$e0,$bd,$07,$fe,$c9,$80,$72,$50,$5c,$d2,$20,$f6,$0b,$fe,$85,$12,$c9,$d4,$e7,$10,$20,$bc,$fe,$76,$fe,$4a,$13,$28,$10,$0a,$0f,$16,$85,$0e,$a0,$0d,$28,$00,$a1,$0c,$68,$0b,$5c,$fd,$62,$fe,$05,$c0,$00,$20
ayRegData07: .byte $85,$00,$66,$08,$38,$28,$12,$f7,$38,$f4,$8a,$ff,$08,$18,$8b,$1a,$08,$e1,$f9,$f4,$4e,$a0,$55,$e3,$29,$38,$3a,$be,$ff,$28,$f9,$f4,$15,$f8,$a1,$d0,$11,$f8,$41,$a0,$10,$cd,$80,$41,$3c,$d0,$10,$7e,$e9,$f4,$4b,$28,$fe,$fe,$d1,$e8,$0e,$f4,$6a,$00,$38,$18,$1a,$ff,$82,$00,$1a,$78,$02,$08,$1a,$e8,$27,$00,$18,$08,$bd,$fe,$d0,$e1,$f4,$b8,$20,$40,$a1,$20,$bf,$22,$63,$e8,$7e,$dd,$64,$3d,$d0,$e1,$c4,$e4,$a0,$07,$de,$28,$f4,$79,$40,$57,$21,$80,$40,$5e,$b8,$c9,$80,$51,$7f,$a0,$20,$80,$11,$62,$38,$38,$14,$57,$f3,$28,$80,$56,$a3,$00,$18,$1a,$88,$ff,$00,$1a,$27,$02,$08,$1a,$83,$e8,$35,$80,$43,$d7,$a0,$31,$80,$3d,$a0,$7f,$70,$d1,$40,$f5,$a0,$57,$35,$80,$7f,$b9,$40,$47,$d5,$a0,$5c,$d5,$80,$fc,$11,$40,$5f,$a0,$10,$7d,$e8,$c9,$b0,$7c,$89,$d6,$80,$a3,$00,$18,$1a,$88,$ff,$00,$1a,$27,$02,$08,$1a,$83,$e8,$21,$80,$5f,$28,$7c,$a0,$15,$cd,$80,$7d,$40,$7f,$10,$d1,$40,$f5,$a0,$57,$35,$80,$7f,$b9,$40,$47,$d5,$a0,$5c,$d5,$80,$fc,$11,$40,$5f,$a0,$10,$7d,$e8,$c9,$b0,$7c,$89,$d6,$80,$8b,$00,$2c,$88,$ff,$00,$28,$39,$f4,$10,$bf,$38,$33,$3b,$94,$f4,$1a,$10,$28,$38,$55,$0c,$ae,$75,$28,$fd,$b9,$00,$f4,$15,$e7,$04,$81,$f4,$05,$a1,$30,$a8,$00,$e2,$18,$1a,$ff,$00,$1a,$09,$e0,$02,$08,$1a,$e8,$ee,$d1,$28,$fe,$88,$00,$3a,$23,$02,$28,$86,$f4,$ff,$00,$9b,$f4,$de,$d0,$e8,$0e,$a0,$06,$94,$22,$78,$40,$57,$df,$4c,$a0,$78,$dc,$68,$20,$7d,$40,$5c,$d5,$80,$5f,$40,$72,$80,$50,$56,$86,$08,$8e,$1a,$f4,$4f,$fe,$17,$8e,$71,$18,$1a,$ff,$20,$00,$1a,$9e,$02,$08,$1a,$e8,$09,$ef,$00,$18,$08,$fe,$d0,$78,$f4,$6c,$20,$8a,$e0,$20,$1a,$22,$1a,$20,$1a,$20,$1f,$d0,$78,$c4,$79,$a0,$01,$f7,$28,$9e,$f4,$40,$55,$c8,$80,$50,$17,$b2,$b8,$80,$54,$5f,$a0,$c8,$80,$04,$58,$85,$38,$38,$15,$fc,$28,$d5,$80,$a8,$00,$e2,$18,$1a,$ff,$00,$1a,$09,$e0,$02,$08,$1a,$e8,$cd,$80,$50,$f5,$a0,$cc,$80,$4f,$a0,$5f,$70,$f4,$40,$7d,$a0,$55,$cd,$80,$5f,$b9,$d1,$40,$f5,$a0,$57,$35,$80,$7f,$11,$40,$17,$c4,$a0,$1f,$e8,$72,$b0,$5f,$89,$35,$80,$a8,$00,$e2,$18,$1a,$ff,$00,$1a,$09,$e0,$02,$08,$1a,$e8,$c8,$80,$57,$df,$28,$a0,$05,$73,$80,$5f,$40,$5f,$10,$f4,$40,$7d,$a0,$55,$cd,$80,$5f,$b9,$d1,$40,$f5,$a0,$57,$35,$80,$7f,$11,$40,$17,$c4,$a0,$4f,$e8,$73,$b0,$7d,$88,$7d,$f4,$b8,$29,$fe,$05,$a0,$20,$1a,$00,$41,$1c,$00,$02
ayRegData08: .byte $85,$00,$6a,$0e,$8a,$0d,$0c,$28,$0b,$b9,$0a,$e8,$9e,$0a,$0a,$09,$fe,$e5,$e8,$55,$5b,$0f,$a2,$ff,$08,$8e,$0c,$f4,$e5,$e8,$14,$cb,$72,$bb,$e8,$f4,$81,$e8,$45,$26,$08,$08,$08,$7b,$f4,$94,$e8,$17,$25,$08,$e0,$e8,$51,$49,$9e,$08,$08,$08,$f4,$e5,$e8,$05,$c9,$08,$78,$e8,$14,$52,$67,$08,$08,$08,$b9,$f4,$e8,$41,$72,$08,$5e,$e8,$05,$14,$99,$08,$08,$08,$ee,$f4,$e8,$50,$5c,$97,$08,$81,$e8,$45,$26,$08,$08,$08,$7b,$f4,$94,$e8,$47,$35,$08,$f5,$e8,$55,$6e,$0e,$ff,$8a,$0d,$0c,$28,$0b,$a2,$0a,$8a,$09,$08,$2e,$07,$d0,$5e,$b8,$7d,$f4,$bb,$0f,$c2,$bb,$88,$b6,$94,$e8,$17,$25,$08,$e0,$e8,$51,$49,$9e,$08,$08,$08,$f4,$e5,$e8,$05,$c9,$08,$78,$e8,$14,$52,$67,$08,$08,$08,$b9,$f4,$e8,$41,$72,$08,$5e,$e8,$05,$14,$99,$08,$08,$08,$ee,$f4,$e8,$50,$5c,$97,$08,$81,$e8,$44,$63,$0e,$10,$80,$fe,$5a,$00,$51,$5c,$00,$02
ayRegData09: .byte $85,$00,$6a,$0f,$6a,$0e,$0d,$0c,$0b,$aa,$0a,$09,$e7,$e8,$82,$f4,$ef,$10,$ff,$0c,$f9,$a9,$f4,$0f,$f5,$e8,$7c,$a0,$55,$f5,$d0,$73,$80,$05,$03,$80,$70,$17,$e5,$e9,$f4,$9f,$0d,$0c,$0c,$d0,$f7,$e8,$9f,$f4,$a0,$1f,$70,$7d,$a0,$7f,$d0,$9f,$86,$a0,$44,$32,$80,$45,$00,$a1,$0e,$55,$68,$10,$01,$13,$f2,$dc,$80,$54,$0a,$0e,$15,$53,$dc,$a0,$94,$80,$69,$0c,$57,$d5,$a0,$5c,$d5,$80,$a5,$10,$5f,$a0,$55,$73,$80,$56,$94,$0c,$3c,$a0,$51,$fc,$e8,$c2,$b0,$c8,$0c,$80,$12,$95,$10,$7d,$a0,$55,$cd,$80,$5a,$0c,$55,$f5,$a0,$57,$35,$80,$69,$10,$57,$d5,$a0,$5c,$d5,$80,$a5,$0c,$0f,$a0,$14,$7f,$e8,$30,$b0,$b2,$0c,$80,$13,$f9,$fb,$ed,$fe,$28,$0d,$5a,$0c,$16,$85,$0b,$a1,$0a,$68,$09,$5a,$08,$16,$87,$07,$b8,$78,$fa,$3b,$48,$83,$fa,$93,$d0,$fd,$48,$fa,$ff,$48,$fa,$7f,$48,$df,$fa,$48,$f7,$fa,$f8,$48,$fa,$39,$fe,$79,$d0,$79,$a0,$79,$70,$79,$40,$79,$10,$72,$b0,$56,$78,$0f,$0f,$0e,$fa,$32,$80,$41,$7f,$40,$da,$fe,$0e,$16,$85,$0d,$a1,$0c,$68,$0b,$5a,$0a,$16,$85,$09,$a1,$08,$72,$92,$79,$f4,$c9,$aa,$e7,$ee,$df,$e2,$72,$e7,$d0,$df,$e2,$54,$e7,$d0,$df,$e2,$42,$e7,$d0,$df,$e2,$36,$e7,$18,$dc,$0c,$f8,$56,$b8,$1e,$70,$07,$81,$28,$c8,$e0,$1c,$cf,$98,$f4,$7d,$fa,$ff,$d6,$fa,$7f,$9a,$df,$fa,$94,$f7,$fa,$fd,$58,$fa,$fe,$22,$fa,$0b,$0f,$c0,$fe,$88,$0e,$10,$88,$0c,$10,$3a,$e9,$10,$17,$f9,$27,$4f,$d0,$79,$e6,$f1,$a0,$57,$df,$4c,$a0,$7d,$dc,$72,$80,$15,$5f,$a0,$72,$80,$51,$47,$84,$fa,$7d,$40,$07,$d5,$a0,$5f,$e8,$e7,$f4,$24,$80,$11,$1a,$0e,$15,$56,$80,$10,$11,$3f,$dc,$25,$80,$40,$a1,$0e,$55,$3d,$a0,$c9,$80,$46,$95,$0c,$7d,$a0,$55,$cd,$80,$5a,$10,$55,$f5,$a0,$57,$35,$80,$69,$0c,$43,$c5,$a0,$1f,$e8,$cc,$b0,$2c,$0c,$81,$80,$29,$10,$57,$d5,$a0,$5c,$d5,$80,$a5,$0c,$5f,$a0,$55,$73,$80,$56,$95,$10,$7d,$a0,$55,$cd,$80,$5a,$0c,$50,$f1,$a0,$47,$f3,$e8,$b0,$0b,$0c,$21,$80,$3f,$fb,$ed,$8a,$fe,$0d,$1a,$0c,$1a,$0b,$1a,$0a,$1a,$09,$1a,$08,$1a,$07,$1a,$06,$1a,$05,$1a,$04,$1a,$03,$1a,$02,$1a,$01,$16,$85,$00,$57,$00,$00,$80
ayRegData10: .byte $85,$00,$6a,$0a,$9a,$09,$08,$a6,$07,$a9,$06,$05,$aa,$04,$03,$68,$0f,$5a,$0e,$16,$85,$0d,$a1,$0c,$68,$0b,$5a,$0a,$16,$85,$09,$a1,$08,$68,$07,$5e,$d0,$5e,$a0,$5e,$70,$5e,$40,$5e,$10,$5c,$97,$e0,$25,$b0,$c8,$80,$10,$57,$95,$10,$ca,$8d,$0e,$07,$25,$a4,$e5,$ac,$c9,$d4,$78,$a8,$e7,$b4,$bf,$40,$ba,$9e,$f4,$a8,$3c,$f4,$e5,$b8,$3d,$d0,$43,$9c,$10,$9f,$e8,$e8,$5f,$28,$5c,$87,$8e,$9c,$ee,$93,$70,$30,$80,$03,$c5,$88,$73,$80,$55,$f7,$a0,$35,$80,$ff,$94,$ff,$9c,$f4,$80,$50,$1e,$d0,$5c,$85,$80,$1e,$ac,$5f,$b8,$45,$f5,$d0,$5c,$d5,$80,$e5,$a0,$5e,$f4,$29,$09,$33,$98,$45,$e7,$e8,$9e,$70,$e8,$5c,$81,$80,$5e,$ac,$5c,$d1,$b0,$79,$88,$57,$35,$80,$5f,$a0,$57,$8a,$f4,$09,$4e,$88,$79,$10,$5e,$d0,$14,$72,$8c,$4f,$b8,$10,$cd,$50,$5c,$85,$80,$0b,$0e,$9f,$c8,$c2,$f3,$14,$ce,$a0,$88,$39,$e8,$50,$07,$e8,$fe,$0d,$6e,$0c,$d4,$6e,$0a,$10,$5e,$e8,$51,$55,$b8,$10,$ff,$23,$0f,$1f,$1e,$08,$82,$f4,$79,$1e,$1d,$1d,$dc,$10,$7e,$e8,$49,$0c,$1c,$1b,$09,$09,$09,$ee,$f4,$e8,$99,$1b,$1a,$1a,$39,$d0,$e1,$b8,$45,$c9,$80,$54,$1b,$1c,$98,$d0,$ea,$0f,$0e,$fe,$0d,$28,$0c,$a2,$0b,$8a,$0a,$09,$28,$08,$ee,$a0,$f4,$ef,$a0,$e8,$f7,$58,$93,$d0,$f9,$58,$b8,$5e,$40,$5f,$70,$53,$d0,$b8,$3d,$40,$c8,$20,$17,$c1,$b8,$3f,$40,$c0,$70,$f5,$28,$5c,$95,$80,$05,$e6,$64,$78,$17,$17,$16,$fe,$aa,$15,$14,$aa,$13,$12,$aa,$11,$0f,$88,$0e,$0f,$a1,$0e,$a1,$0d,$a1,$0c,$a1,$0b,$a1,$0a,$a1,$09,$a1,$08,$e3,$a8,$9a,$b4,$0b,$1b,$0a,$9e,$f4,$a8,$3c,$f4,$e5,$b8,$3d,$d0,$43,$9c,$e8,$9f,$e8,$e8,$5f,$28,$5c,$87,$8e,$9c,$ee,$93,$70,$30,$80,$03,$c5,$88,$73,$80,$55,$f7,$a0,$35,$80,$ff,$94,$ff,$9c,$f4,$80,$50,$1e,$d0,$5c,$85,$80,$1e,$ac,$5f,$b8,$45,$f5,$d0,$5c,$d5,$80,$e5,$a0,$5e,$f4,$29,$09,$33,$98,$45,$e7,$e8,$9e,$70,$e8,$5c,$81,$80,$5e,$ac,$5c,$d1,$b0,$79,$88,$57,$35,$80,$5f,$a0,$57,$8a,$f4,$09,$4e,$88,$79,$10,$5e,$d0,$14,$72,$8c,$4f,$b8,$10,$cd,$50,$5c,$85,$80,$0b,$0e,$9f,$c8,$c2,$f3,$14,$ce,$a0,$88,$39,$e8,$50,$07,$e8,$fe,$0d,$6e,$0c,$d4,$6e,$0a,$10,$5e,$e8,$51,$50,$ef,$ec,$e6,$e2,$fe,$86,$0c,$86,$0b,$86,$0a,$86,$09,$86,$08,$86,$07,$86,$06,$86,$05,$86,$04,$86,$03,$86,$02,$85,$01,$a4,$00,$11,$c0,$00,$20
ayRegData11: .byte $85,$00,$5a,$2f,$1a,$5d,$17,$d1,$dc,$e0,$a0,$55,$b8,$34,$fe,$a1,$68,$7d,$dc,$1e,$a0,$05,$5b,$23,$8a,$fe,$46,$17,$d1,$dc,$e0,$a0,$55,$b8,$1f,$fe,$a1,$3e,$7d,$dc,$1e,$a0,$05,$5b,$2f,$8a,$fe,$5d,$17,$d1,$dc,$e0,$a0,$55,$b8,$34,$fe,$a1,$68,$7d,$dc,$1e,$a0,$05,$5b,$23,$8a,$fe,$46,$17,$d1,$dc,$e0,$a0,$55,$b8,$1f,$fe,$a1,$3e,$7d,$dc,$1e,$a0,$05,$5b,$2f,$8a,$fe,$5d,$17,$d1,$dc,$e0,$a0,$55,$b8,$34,$fe,$a1,$68,$7d,$dc,$1e,$a0,$05,$5b,$23,$8a,$fe,$46,$17,$d1,$dc,$e0,$a0,$55,$b8,$1f,$fe,$a1,$3e,$7d,$dc,$1e,$a0,$05,$5b,$2f,$8a,$fe,$5d,$17,$d1,$dc,$e0,$a0,$55,$b8,$34,$fe,$a1,$68,$7d,$dc,$1e,$a0,$05,$5b,$23,$8a,$fe,$46,$17,$d1,$dc,$e0,$a0,$55,$b8,$1f,$fe,$a1,$3e,$7d,$dc,$1e,$a0,$05,$5b,$2f,$8a,$fe,$5d,$17,$d1,$dc,$e0,$a0,$55,$b8,$34,$fe,$a1,$68,$7d,$dc,$1e,$a0,$05,$5b,$23,$8a,$fe,$46,$17,$d1,$dc,$e0,$a0,$55,$b8,$1f,$fe,$a1,$3e,$7d,$dc,$1e,$a0,$05,$5b,$2f,$8a,$fe,$5d,$17,$d1,$dc,$e0,$a0,$55,$b8,$34,$fe,$a1,$68,$7d,$dc,$1e,$a0,$05,$5b,$23,$8a,$fe,$46,$17,$d1,$dc,$e0,$a0,$55,$b8,$1f,$fe,$a1,$3e,$7d,$dc,$1e,$a0,$01,$5f,$fe,$68,$2f,$68,$5d,$5f,$dc,$47,$81,$a0,$56,$e2,$34,$fe,$85,$68,$f4,$dc,$78,$a0,$15,$6e,$23,$fe,$28,$46,$5f,$dc,$47,$81,$a0,$56,$e2,$1f,$fe,$85,$3e,$f4,$dc,$7d,$a0,$14,$e4,$ff,$08,$22,$25,$28,$2b,$2e,$31,$34,$37,$3a,$3d,$40,$43,$46,$49,$4c,$4f,$52,$55,$58,$5b,$5e,$61,$64,$2f,$68,$5d,$5f,$dc,$47,$81,$a0,$56,$e2,$34,$fe,$85,$68,$f4,$dc,$78,$a0,$15,$6e,$23,$fe,$28,$46,$5f,$dc,$47,$81,$a0,$56,$e2,$1f,$fe,$85,$3e,$f4,$dc,$78,$a0,$15,$6e,$2f,$fe,$28,$5d,$5f,$dc,$47,$81,$a0,$56,$e2,$34,$fe,$85,$68,$f4,$dc,$78,$a0,$15,$6e,$23,$fe,$28,$46,$5f,$dc,$47,$81,$a0,$56,$e2,$1f,$fe,$85,$3e,$f4,$dc,$78,$a0,$15,$6e,$2f,$fe,$28,$5d,$5f,$dc,$47,$81,$a0,$56,$e2,$34,$fe,$85,$68,$f4,$dc,$78,$a0,$15,$6e,$23,$fe,$28,$46,$5f,$dc,$47,$81,$a0,$56,$e2,$1f,$fe,$85,$3e,$f4,$dc,$78,$a0,$15,$6e,$2f,$fe,$28,$5d,$5f,$dc,$47,$81,$a0,$56,$e2,$34,$fe,$85,$68,$f4,$dc,$78,$a0,$15,$6e,$23,$fe,$28,$46,$5f,$dc,$47,$81,$a0,$56,$e2,$1f,$fe,$85,$3e,$f4,$dc,$78,$a0,$15,$6e,$2f,$fe,$58,$50,$5c,$30,$31,$32,$33,$34,$35,$36,$37,$38,$39,$3a,$3b,$3c,$3d,$3e,$3f,$40,$41,$42,$43,$44,$45,$46,$47,$48,$49,$4a,$4b,$4c,$4d,$4e,$4f,$50,$51,$52,$53,$54,$55,$56,$57,$58,$59,$5a,$5b,$5c,$5d,$5e,$5f,$60,$61,$62,$63,$64,$65,$66,$67,$68,$69,$6a,$6b,$6c,$6d,$6e,$6f,$70,$71,$72,$73,$74,$75,$76,$77,$78,$79,$7a,$7b,$7c,$7d,$7e,$7f,$80,$81,$82,$83,$84,$85,$86,$87,$88,$89,$8a,$8b,$8c,$8d,$8e,$8f,$90,$91,$92,$93,$94,$95,$96,$97,$98,$99,$9a,$9b,$9c,$9d,$9e,$9f,$a0,$a1,$a2,$a3,$a4,$a5,$a6,$a7,$a8,$a9,$aa,$ab,$ac,$ad,$ae,$af,$b0,$b1,$b2,$b3,$b4,$b5,$b6,$b7,$b8,$b9,$ba,$bb,$bc,$bd,$be,$bf,$c0,$c1,$c2,$c3,$c4,$c5,$c6,$c7,$c8,$c9,$ca,$cb,$cc,$cd,$ce,$cf,$d0,$d1,$d2,$d3,$d4,$d5,$d6,$d7,$d8,$d9,$da,$db,$dc,$dd,$de,$df,$e0,$e1,$e2,$00,$02
ayRegData12: .byte $80,$00,$15,$45,$5c,$00,$02
ayRegData13: .byte $85,$ff,$5b,$0c,$81,$f4,$55,$40,$a1,$ff,$a1,$0c,$50,$56,$85,$ff,$68,$0c,$55,$55,$5a,$0e,$e5,$fe,$51,$c0,$00,$20
*/

GCPlayerAyRegDataPtrs:
			.word ayRegData00, ayRegData01, ayRegData02, ayRegData03, ayRegData04, ayRegData05, ayRegData06, ayRegData07, 
			.word ayRegData08, ayRegData09, ayRegData10, ayRegData11, ayRegData12, ayRegData13

ayRegData00: .byte $79,$8e,$1c,$ef,$fa,$54,$26,$b2,$65,$1c,$15,$19,$85,$9f,$3e,$fc,$47,$2e,$02,$fa,$55,$09,$85,$b2,$65,$1c,$46,$61,$9f,$3e,$fc,$51,$9b,$0e,$9c,$6f,$21,$50,$79,$d0,$04,$79,$fb,$a6,$32,$e5,$9c,$65,$1c,$b2,$01,$e0,$d0,$47,$9a,$fb,$1f,$be,$7c,$60,$3e,$fc,$9f,$1e,$d0,$05,$73,$20,$02,$a8,$1c,$8e,$43,$81,$a0,$47,$9a,$fb,$32,$e5,$9c,$60,$65,$1c,$b2,$1e,$d7,$b8,$9c,$d0,$5e,$a0,$51,$e6,$fb,$1f,$be,$7c,$98,$3e,$fc,$9f,$07,$ae,$d7,$7c,$d0,$17,$95,$a0,$72,$20,$68,$0e,$5a,$0e,$07,$85,$d0,$e0,$a0,$51,$e6,$fb,$32,$e5,$9c,$89,$65,$1c,$a5,$b2,$fc,$e9,$f4,$ae,$9c,$d0,$17,$94,$a0,$79,$fb,$a2,$1f,$be,$7c,$3e,$fc,$69,$9f,$7f,$e9,$f4,$2b,$7c,$85,$d0,$e5,$a0,$5c,$95,$20,$78,$a0,$14,$79,$fb,$a2,$32,$e5,$9c,$65,$1c,$69,$b2,$7f,$e9,$f4,$2b,$9c,$85,$d0,$e5,$a0,$1e,$fb,$68,$1f,$be,$7c,$9a,$3e,$fc,$9f,$5f,$e9,$ca,$f4,$7c,$e1,$d0,$79,$a0,$57,$25,$20,$5e,$a0,$05,$1e,$fb,$68,$32,$e5,$9c,$9a,$65,$1c,$b2,$5f,$e9,$ca,$f4,$9c,$e1,$d0,$79,$a0,$47,$9a,$fb,$1f,$be,$7c,$26,$3e,$fc,$97,$9f,$f2,$e9,$f4,$b8,$7c,$d0,$5e,$a0,$55,$c9,$20,$57,$81,$a0,$47,$9a,$fb,$32,$e5,$9c,$26,$65,$1c,$97,$b2,$f2,$e9,$f4,$b8,$9c,$d0,$5e,$a0,$51,$e6,$fb,$1f,$be,$7c,$89,$3e,$fc,$a5,$9f,$fc,$e9,$f4,$ae,$7c,$d0,$17,$95,$a0,$72,$20,$55,$e0,$a0,$51,$e6,$fb,$32,$e5,$9c,$89,$65,$1c,$a5,$b2,$fc,$e9,$f4,$ae,$9c,$d0,$17,$94,$a0,$79,$fb,$a2,$1f,$be,$7c,$3e,$fc,$69,$9f,$7f,$e9,$f4,$2b,$7c,$85,$d0,$e5,$a0,$5c,$95,$20,$78,$a0,$14,$79,$fb,$a2,$32,$e5,$9c,$65,$1c,$69,$b2,$7f,$e9,$f4,$2b,$9c,$85,$d0,$e5,$a0,$1e,$fb,$68,$1f,$be,$7c,$9a,$3e,$fc,$9f,$5f,$e9,$ca,$f4,$7c,$e1,$d0,$79,$a0,$57,$00,$00,$80
ayRegData01: .byte $79,$00,$01,$00,$fa,$55,$28,$01,$55,$68,$00,$05,$56,$85,$01,$47,$25,$80,$56,$0f,$02,$03,$04,$05,$d0,$00,$0f,$ed,$80,$fa,$e0,$d0,$57,$34,$50,$57,$f9,$0f,$ff,$a0,$10,$3e,$03,$fa,$03,$f8,$a0,$d0,$5e,$a0,$55,$c9,$20,$57,$d4,$a0,$43,$e0,$c3,$fa,$3f,$a0,$85,$d0,$e5,$a0,$5c,$95,$20,$7d,$a0,$44,$3e,$c3,$fa,$03,$f8,$a0,$d0,$5e,$a0,$55,$c9,$20,$57,$d4,$a0,$43,$e0,$c3,$fa,$3f,$a0,$85,$d0,$e5,$a0,$5c,$95,$20,$7d,$a0,$44,$3e,$c3,$fa,$03,$f8,$a0,$d0,$5e,$a0,$55,$c9,$20,$57,$d4,$a0,$43,$e0,$c3,$fa,$3f,$a0,$85,$d0,$e5,$a0,$5c,$95,$20,$7d,$a0,$44,$3e,$c3,$fa,$03,$f8,$a0,$d0,$5e,$a0,$55,$c9,$80,$55,$c0,$00,$20
ayRegData02: .byte $85,$00,$55,$6b,$ef,$a2,$fc,$ec,$e9,$9b,$ef,$f2,$f5,$9b,$f0,$1c,$e2,$ff,$fd,$19,$16,$9b,$1c,$1f,$22,$9e,$f0,$b8,$54,$f0,$7c,$e5,$40,$57,$81,$64,$be,$65,$ff,$fd,$29,$62,$5f,$b9,$65,$68,$6b,$f0,$e5,$b8,$4f,$7c,$0b,$fc,$e2,$ff,$fd,$f9,$f6,$9b,$fc,$ff,$02,$9b,$f0,$3e,$e2,$ff,$fd,$3b,$38,$9b,$3e,$41,$44,$9e,$f0,$b8,$54,$f0,$7c,$c8,$08,$17,$95,$b8,$3c,$7c,$39,$40,$55,$e0,$64,$6f,$65,$ff,$8a,$fd,$62,$5f,$6e,$65,$68,$6b,$f0,$79,$b8,$53,$c2,$7c,$f8,$fc,$ff,$fd,$a6,$f9,$f6,$fc,$ff,$02,$e6,$f0,$f8,$3e,$ff,$fd,$a6,$3b,$38,$3e,$41,$44,$e7,$f0,$95,$b8,$3c,$7c,$32,$08,$05,$e5,$b8,$4f,$7c,$0e,$40,$55,$78,$64,$1b,$65,$e2,$ff,$fd,$62,$5f,$9b,$65,$68,$6b,$9e,$f0,$b8,$54,$f0,$7c,$be,$fc,$ff,$fd,$29,$f9,$f6,$b9,$fc,$ff,$02,$f0,$be,$3e,$ff,$fd,$29,$3b,$38,$b9,$3e,$41,$44,$f0,$e5,$b8,$4f,$7c,$0c,$96,$50,$fb,$bd,$fe,$ba,$25,$ec,$e7,$dc,$95,$b8,$79,$7c,$79,$40,$55,$e0,$28,$6f,$65,$ff,$8a,$fd,$62,$5f,$6e,$65,$68,$6b,$dc,$79,$b8,$57,$96,$7c,$f8,$fc,$fe,$08,$f9,$f6,$f9,$fc,$ff,$02,$ff,$d6,$22,$d3,$3e,$e8,$fc,$a6,$3b,$38,$3e,$41,$44,$e7,$dc,$95,$b8,$79,$7c,$79,$f0,$6e,$1c,$fe,$25,$86,$1a,$18,$1a,$1c,$1e,$20,$bd,$86,$d6,$86,$ef,$15,$f2,$ed,$eb,$ed,$ef,$f1,$f3,$ef,$eb,$e7,$e3,$df,$db,$d5,$cf,$cd,$cb,$c9,$c7,$c1,$bd,$bb,$b9,$bb,$b8,$5f,$d4,$d2,$d4,$d6,$d8,$da,$d8,$f0,$f0,$a0,$e7,$70,$e7,$b0,$bf,$c1,$bf,$93,$f0,$97,$94,$9f,$40,$4c,$0f,$9c,$79,$f0,$43,$21,$80,$08,$07,$ea,$e5,$e0,$db,$d6,$cf,$c8,$c5,$c2,$bf,$bc,$b5,$b2,$b0,$ae,$b0,$b2,$20,$bc,$79,$a0,$73,$44,$5f,$f0,$72,$38,$07,$d3,$ac,$d6,$9c,$55,$fc,$da,$e4,$ee,$f8,$02,$08,$0e,$14,$1a,$24,$2e,$38,$42,$48,$4e,$54,$5a,$64,$6e,$78,$82,$88,$8e,$94,$9a,$a4,$ae,$b8,$c2,$c8,$ce,$c0,$84,$80,$24,$33,$eb,$e7,$e3,$df,$db,$d5,$cf,$cd,$cb,$c9,$c7,$c1,$94,$e0,$10,$7c,$a0,$33,$44,$5f,$f0,$79,$94,$79,$a0,$f0,$4c,$f7,$9c,$94,$f0,$32,$80,$10,$80,$72,$ea,$e5,$e0,$db,$d6,$cf,$c8,$c5,$c2,$bf,$bc,$b5,$b2,$b0,$ae,$b0,$b2,$bc,$07,$97,$a0,$35,$44,$f7,$f0,$20,$38,$7d,$ac,$3d,$9c,$64,$4c,$da,$e4,$ee,$f8,$02,$08,$0e,$14,$1a,$24,$2e,$38,$42,$48,$4e,$54,$5a,$64,$6e,$78,$82,$88,$8e,$1c,$8e,$5e,$e1,$9b,$f4,$27,$bd,$5e,$3f,$2a,$83,$5e,$22,$6b,$47,$a2,$6b,$77,$4f,$f9,$f9,$ac,$92,$fc,$7e,$54,$fc,$fc,$7e,$43,$81,$d0,$e4,$a0,$f0,$40,$02,$0f,$65,$b2,$77,$65,$f8,$18,$25,$df,$ef,$9f,$df,$39,$b8,$e7,$ac,$f9,$58,$f8,$17,$fc,$10,$f8,$78,$7c,$1c,$98,$74,$ff,$3e,$9f,$fb,$f9,$a0,$e4,$f8,$5e,$74,$78,$f4,$18,$3e,$bd,$5e,$3f,$bd,$f9,$4c,$72,$20,$5e,$40,$7c,$94,$7d,$d0,$79,$a0,$79,$40,$55,$83,$65,$b2,$77,$65,$c6,$f8,$09,$df,$ef,$9f,$df,$4e,$b8,$79,$ac,$fe,$58,$f8,$45,$ff,$10,$f8,$1e,$7c,$07,$26,$74,$3f,$3e,$9f,$fb,$f9,$f9,$a0,$f8,$17,$3a,$6f,$fc,$29,$ec,$e9,$af,$ef,$f2,$f5,$bd,$fe,$be,$ba,$5f,$fc,$8a,$19,$16,$6e,$1c,$1f,$22,$dc,$79,$b8,$57,$97,$7c,$95,$40,$5e,$28,$06,$f8,$65,$ff,$fd,$a6,$62,$5f,$65,$68,$6b,$e7,$04,$95,$b8,$79,$7c,$6f,$fc,$fe,$80,$82,$f9,$f6,$f9,$fc,$ff,$02,$ff,$d6,$2e,$d3,$3e,$fc,$8a,$3b,$38,$6e,$3e,$41,$44,$dc,$79,$b8,$57,$97,$c4,$00,$00,$80
ayRegData03: .byte $90,$00,$40,$68,$01,$07,$91,$b8,$7d,$7c,$79,$40,$10,$f0,$fe,$43,$d7,$10,$de,$ea,$b8,$00,$72,$08,$05,$f4,$b8,$4f,$40,$00,$7c,$fe,$10,$f5,$10,$f7,$ea,$80,$b8,$1c,$81,$08,$7d,$b8,$13,$c0,$40,$1f,$fe,$04,$3d,$10,$7d,$ea,$e0,$b8,$07,$35,$08,$7d,$c4,$79,$b8,$53,$c5,$40,$0e,$ac,$07,$80,$dc,$1c,$91,$80,$a4,$01,$1e,$b8,$55,$b8,$01,$fe,$12,$85,$00,$05,$c9,$80,$00,$2e,$01,$fe,$41,$a1,$00,$41,$72,$80,$40,$0c,$dc,$be,$c7,$ae,$bd,$f8,$f4,$32,$82,$17,$97,$d0,$81,$a0,$f0,$b8,$3c,$40,$11,$f7,$f8,$d7,$dc,$91,$04,$e4,$f8,$5c,$95,$b0,$f7,$14,$35,$08,$e5,$fe,$5c,$94,$bc,$e5,$ac,$79,$94,$5e,$b8,$57,$c1,$40,$4f,$f8,$7d,$dc,$79,$04,$1e,$f8,$45,$c9,$b0,$5f,$14,$73,$08,$5e,$fe,$00,$68,$01,$5f,$b8,$01,$f5,$c4,$e5,$40,$57,$81,$ac,$e0,$dc,$07,$24,$80,$69,$01,$07,$95,$b8,$3c,$c4,$30,$00,$08
ayRegData04: .byte $79,$1c,$ef,$bd,$fa,$54,$26,$65,$1c,$ef,$15,$19,$85,$3e,$fc,$d6,$47,$2e,$02,$fa,$55,$09,$85,$65,$1c,$ef,$46,$61,$3e,$fc,$d6,$51,$cb,$02,$95,$fa,$42,$61,$65,$1c,$ef,$51,$98,$3e,$fc,$d6,$54,$72,$02,$e5,$fa,$50,$98,$65,$1c,$ef,$54,$66,$3e,$fc,$d6,$15,$1c,$96,$68,$e4,$70,$fe,$e4,$d0,$15,$be,$65,$e1,$fa,$0b,$94,$93,$fe,$81,$d0,$59,$e0,$3e,$fc,$d6,$fa,$b9,$f8,$fe,$38,$d0,$15,$c9,$20,$5e,$d0,$41,$5b,$65,$e0,$e1,$fa,$b9,$94,$fe,$38,$d0,$15,$9e,$3e,$fc,$d6,$fa,$0b,$f8,$93,$fe,$81,$d0,$5c,$95,$20,$e4,$d0,$15,$be,$65,$e1,$fa,$0b,$94,$93,$fe,$81,$d0,$59,$e0,$3e,$fc,$d6,$fa,$b9,$f8,$fe,$38,$d0,$15,$c9,$20,$5e,$d0,$41,$5b,$65,$e0,$e1,$fa,$b9,$94,$fe,$38,$d0,$15,$9e,$3e,$fc,$d6,$fa,$0b,$f8,$93,$fe,$81,$d0,$5c,$95,$20,$e4,$d0,$15,$be,$65,$e1,$fa,$0b,$94,$93,$fe,$81,$d0,$59,$e0,$3e,$fc,$d6,$fa,$b9,$f8,$fe,$38,$d0,$15,$c9,$20,$5e,$d0,$41,$5b,$65,$e0,$e1,$fa,$b9,$94,$fe,$38,$d0,$15,$9e,$3e,$fc,$d6,$fa,$0b,$f8,$93,$fe,$81,$d0,$5c,$00,$02
ayRegData05: .byte $2e,$01,$00,$fa,$55,$1a,$01,$15,$5a,$00,$01,$55,$a1,$01,$51,$cc,$80,$00,$83,$02,$02,$03,$05,$95,$d0,$42,$8a,$03,$01,$3d,$fa,$78,$d0,$15,$e5,$10,$78,$d0,$04,$1a,$03,$28,$01,$f5,$fa,$e0,$d0,$57,$31,$50,$42,$e4,$04,$fe,$e4,$d0,$40,$a2,$03,$8e,$01,$fa,$2e,$05,$fe,$4e,$d0,$05,$79,$10,$5e,$d0,$01,$02,$8a,$03,$01,$38,$fa,$b9,$05,$fe,$38,$d0,$15,$e5,$10,$78,$d0,$04,$0a,$03,$28,$01,$e2,$fa,$e4,$05,$fe,$e0,$d0,$57,$95,$10,$e0,$d0,$10,$28,$03,$a3,$01,$8b,$fa,$05,$93,$fe,$81,$d0,$5e,$10,$57,$80,$d0,$40,$a2,$03,$8e,$01,$fa,$2e,$05,$fe,$4e,$d0,$05,$79,$10,$5e,$d0,$01,$02,$8a,$03,$01,$38,$fa,$b9,$05,$fe,$38,$d0,$15,$c9,$80,$55,$c0,$00,$20
ayRegData06: .byte $81,$00,$04,$56,$08,$10,$08,$06,$04,$0e,$a0,$50,$56,$f8,$01,$ff,$f4,$27,$12,$0a,$08,$ae,$aa,$02,$ff,$8a,$00,$03,$38,$f4,$3b,$82,$9e,$f4,$d0,$5e,$a0,$5e,$70,$5e,$40,$04,$40,$4c,$00,$02
ayRegData07: .byte $85,$28,$55,$68,$38,$55,$56,$f0,$30,$d0,$11,$22,$30,$30,$17,$b8,$fe,$d0,$79,$a0,$15,$5f,$df,$ea,$fe,$34,$9f,$3c,$f7,$ff,$f4,$a0,$85,$d0,$e0,$a0,$50,$55,$c0,$00,$20
ayRegData08: .byte $49,$0e,$0d,$0c,$0b,$0a,$09,$38,$e8,$1f,$c4,$41,$f7,$d0,$90,$40,$55,$6e,$0f,$e6,$bc,$0a,$fe,$fa,$e8,$0b,$17,$81,$dc,$b9,$0b,$d0,$7c,$a0,$39,$70,$5e,$40,$11,$16,$3b,$0d,$0d,$ec,$84,$40,$f9,$d1,$40,$3d,$d0,$79,$70,$5e,$40,$11,$42,$85,$0d,$b8,$0d,$d0,$15,$14,$30,$00,$08
ayRegData09: .byte $85,$00,$55,$61,$91,$0f,$0e,$0d,$0c,$0b,$f5,$dc,$1f,$e8,$5e,$40,$01,$14,$21,$f1,$0a,$0a,$09,$08,$08,$dc,$1e,$40,$14,$17,$d6,$f8,$fb,$0f,$cf,$cc,$97,$e8,$df,$f4,$d0,$5e,$94,$07,$d1,$70,$e4,$28,$1b,$0b,$85,$fe,$32,$80,$45,$5b,$0a,$81,$fe,$32,$80,$01,$0f,$fe,$44,$c8,$80,$51,$6e,$0a,$fe,$52,$fa,$0f,$98,$0a,$e6,$e9,$09,$08,$07,$01,$e7,$c4,$c3,$b8,$95,$e8,$7c,$40,$10,$f9,$46,$7e,$06,$05,$04,$03,$02,$01,$00,$ff,$dc,$07,$d1,$a0,$f5,$e0,$f9,$ff,$60,$79,$40,$55,$cd,$08,$1e,$f4,$7d,$b8,$7d,$e8,$57,$d5,$40,$73,$20,$47,$81,$dc,$f4,$a0,$7d,$e0,$7e,$7b,$60,$5f,$40,$04,$3d,$fe,$fb,$7c,$08,$80,$dc,$1e,$e8,$5e,$40,$05,$57,$00,$00,$80
ayRegData10: .byte $49,$0e,$0d,$0c,$0b,$0a,$09,$38,$e8,$1f,$c4,$41,$f7,$d0,$90,$40,$55,$6e,$0f,$e6,$bc,$0a,$fe,$fa,$e8,$0b,$17,$81,$dc,$b9,$0b,$d0,$7c,$a0,$39,$70,$5e,$40,$44,$45,$b9,$1f,$fe,$39,$70,$38,$d0,$43,$95,$70,$e0,$40,$41,$55,$c0,$00,$20
ayRegData11: .byte $90,$00,$01,$16,$85,$47,$55,$a1,$59,$55,$a1,$50,$55,$a1,$47,$05,$a1,$00,$68,$47,$55,$68,$59,$41,$68,$00,$5a,$50,$15,$5a,$47,$10,$5a,$00,$16,$85,$47,$56,$84,$59,$16,$85,$00,$a1,$50,$55,$a1,$47,$55,$68,$59,$55,$68,$50,$55,$68,$47,$55,$5a,$59,$15,$5a,$50,$15,$5a,$47,$15,$56,$85,$59,$56,$84,$50,$17,$00,$00,$80
ayRegData12: .byte $94,$00,$55,$55,$c0,$00,$20
ayRegData13: .byte $90,$ff,$01,$16,$f4,$08,$d0,$41,$2c,$01,$95,$80,$55,$38,$d0,$01,$55,$c0,$00,$20
