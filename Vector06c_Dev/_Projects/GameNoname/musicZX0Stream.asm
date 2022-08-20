; info/credits:
; music has to be compressed into 14 buffers each for every register
; this player decompresses and plays 14 parallel streams.
; Only one task is executed each frame that decompresses 16 bytes for one of the ay registers.
; cpu load: 5-20 of 312 scanlines per a frame
; Compressed data size 2310 bytes (uncompressed 61586)
; original player code made by svofski 2022
; original zx0 decompression code made by ivagor 2022

; to cook data for this plyer: 
;   1. extract each register data from a music track
;   2. zx0 -c -w 256 regData
;   3. combine all all of the compressed regData
;   4. add a header that is an word array with addresses of all of regData
;   5. compress it as zx0 -c regData

; Special thanks to Vortex Tracker 2.5
; EA at feb 2018 (YM+ABC)
; Created by Sergey Bulba's AY-3-8910/12 Emulator v2.9


; total number of scheduled tasks
ZX0_PLAYER_TASKS		= 14
; task stack size 
ZX0_PLAYER_STACK_SIZE = 16

StartTestMusic:
			xra a
			out $10	
			mvi a, $c9
			sta $38
			lxi sp, $100

			call Zx0PlayerInit
@loop:
			ei
			hlt

			call Zx0PlayerUpdate
			jmp @loop

Zx0PlayerInit: 
			call Zx0PlayerTasksInit
			call Zx0PlayerSchedulerInit

			; set bufferIdx ZX0_PLAYER_TASKS bytes prior to the init unpacking addr (0),
			; to let zx0 unpack data for ZX0_PLAYER_TASKS number of regs
			; that means the music will be ZX0_PLAYER_TASKS number of frames delayed
			mvi a, -ZX0_PLAYER_TASKS
			sta Zx0PlayerBufferIdx
			mvi a, -1
			sta Zx0PlayerTaskId
			ret
			.closelabels

; should be synced with interruptions				
Zx0PlayerUpdate:
			lxi h, Zx0PlayerTaskId
			mov a, m
			inr a
			ani $f
			mov m, a
			cpi ZX0_PLAYER_TASKS
			jnc @skip
			call Zx0PlayerSchedulerUpdate
@skip:
			lxi h, Zx0PlayerBufferIdx
			inr m
			call Zx0PlayerAYUpdate
			ret
			.closelabels

; bufferN[bufferIdx] data will be send to AY for each register accordingly
Zx0PlayerBufferIdx:    
			.byte TEMP_BYTE
Zx0PlayerTaskId:  
			.byte TEMP_BYTE
			.closelabels

;==========================================
; create a Zx0PlayerUnpack tasks
;
Zx0PlayerTasksInit:
			di
			lxi h, 0
			dad sp
			shld @restoreSp+1

			lxi sp, Zx0PlayerTaskStack13 + ZX0_PLAYER_STACK_SIZE
			lxi d, Zx0PlayerAyRegDataPtrs + ZX0_PLAYER_TASKS * WORD_LEN
			; b = 0, c = a task counter * 2
			lxi b, (ZX0_PLAYER_TASKS - 1) * WORD_LEN
@loop:
			; store zx0 entry point to a task stack
			lxi h, Zx0PlayerUnpack
			push h
			; store the buffer addr to a task stack
			mov a, c
			rrc
			adi >Zx0PlayerBuffer00
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
			; store taskSP to Zx0PlayerTaskSPs
			lxi h, Zx0PlayerTaskSPs
			dad b
			shld @storeTaskSP+1
			; move sp back 4 bytes to skip storing HL, PSW because zx0 doesnt use them to init
			lxi h, $ffff - WORD_LEN * 2 + 1
			dad sp
@storeTaskSP:
			shld TEMP_ADDR
			; move SP to the previous task stack end
			lxi h, $ffff - ZX0_PLAYER_STACK_SIZE + WORD_LEN * 3 + 1
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
Zx0PlayerSchedulerInit:
			lxi h, Zx0PlayerTaskSPs
			shld Zx0PlayerCurrentTaskSPp
			ret
			.closelabels

; call Zx0PlayerUnpack for the current task
Zx0PlayerSchedulerUpdate: 
			lxi h, 0
			dad sp
			shld Zx0PlayerSchedulerRestoreSp+1
			lhld Zx0PlayerCurrentTaskSPp
			mov e, m 
			inx h 
			mov d, m ; de = &Zx0PlayerTaskSPs[n]
			xchg
			sphl
			; restore a task context and return into it
			pop psw
			pop h
			pop d
			pop b
			ret      ; return to Zx0PlayerUnpack

; Zx0PlayerUnpack task calls this after unpacking 16 bytes.
; it stores all the registers of the current task
Zx0PlayerSchedulerStoreTaskContext:     
			push b
			push d
			push h
			push psw

			lxi h, 0 
			dad sp
			xchg
			lhld Zx0PlayerCurrentTaskSPp
			mov m, e 
			inx h 
			mov m, d 
			inx h
			mvi a, <Zx0PlayerTaskSPsEnd
			cmp l
			jnz @storeNextTaskSp
			mvi a, >Zx0PlayerTaskSPsEnd
			cmp h
			jnz @storeNextTaskSp
			; (Zx0PlayerCurrentTaskSPp) = Zx0PlayerTaskSPs[0]
			lxi h, Zx0PlayerTaskSPs
@storeNextTaskSp:
			shld Zx0PlayerCurrentTaskSPp
Zx0PlayerSchedulerRestoreSp:
			lxi sp, TEMP_ADDR
			ret
			.closelabels

; Parameters (forward):
; DE: source address (compressed data)
; BC: destination address (decompressing)
; unpack every 16 bytes into a current task circular buffer, 
; then call Zx0PlayerSchedulerStoreTaskContext
Zx0PlayerUnpack:
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
		cz Zx0PlayerSchedulerStoreTaskContext 

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
		cz Zx0PlayerSchedulerStoreTaskContext 

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
		lhld Zx0PlayerSchedulerRestoreSp+1
		sphl
		; pop Zx0PlayerSchedulerUpdate return addr
		pop psw
		; reset the current music
		call Zx0PlayerInit
		; return to func that called Zx0PlayerUpdate
		ret
		.closelabels
		
; Send buffers data to AY regs
; input:
; hl = bufferIdx
; reg13 (envelope shape) data = $ff means don't send data to reg13
; AY-3-8910 ports
AY_PORT_REG  = $15
AY_PORT_DATA = $14

Zx0PlayerAYUpdate:       
			mvi e, ZX0_PLAYER_TASKS - 1
			mov c, m                
			mvi b, (>Zx0PlayerBuffer00) + ZX0_PLAYER_TASKS - 1
				
			ldax b
			cpi $ff
			jz @doNotSendData
@sendData                
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

; array of task stack pointers. Zx0PlayerTaskSPs[i] = taskSP
Zx0PlayerTaskSPs: .storage WORD_LEN * ZX0_PLAYER_TASKS;  
Zx0PlayerTaskSPsEnd     = *

; task stacks          
Zx0PlayerTaskStack00: .storage ZX0_PLAYER_STACK_SIZE
Zx0PlayerTaskStack01: .storage ZX0_PLAYER_STACK_SIZE
Zx0PlayerTaskStack02: .storage ZX0_PLAYER_STACK_SIZE
Zx0PlayerTaskStack03: .storage ZX0_PLAYER_STACK_SIZE
Zx0PlayerTaskStack04: .storage ZX0_PLAYER_STACK_SIZE
Zx0PlayerTaskStack05: .storage ZX0_PLAYER_STACK_SIZE
Zx0PlayerTaskStack06: .storage ZX0_PLAYER_STACK_SIZE
Zx0PlayerTaskStack07: .storage ZX0_PLAYER_STACK_SIZE
Zx0PlayerTaskStack08: .storage ZX0_PLAYER_STACK_SIZE
Zx0PlayerTaskStack09: .storage ZX0_PLAYER_STACK_SIZE
Zx0PlayerTaskStack10: .storage ZX0_PLAYER_STACK_SIZE
Zx0PlayerTaskStack11: .storage ZX0_PLAYER_STACK_SIZE
Zx0PlayerTaskStack12: .storage ZX0_PLAYER_STACK_SIZE
Zx0PlayerTaskStack13: .storage ZX0_PLAYER_STACK_SIZE

; a pointer to a current task sp. *Zx0PlayerCurrentTaskSPp = Zx0PlayerTaskSPs[currentTask]
Zx0PlayerCurrentTaskSPp: .word TEMP_ADDR;

; buffers for unpacking the streams, must be aligned to 256 byte boundary
.align $100
Zx0PlayerBuffer00 : .storage $100
Zx0PlayerBuffer01 : .storage $100      
Zx0PlayerBuffer02 : .storage $100
Zx0PlayerBuffer03 : .storage $100    
Zx0PlayerBuffer04 : .storage $100
Zx0PlayerBuffer05 : .storage $100
Zx0PlayerBuffer06 : .storage $100
Zx0PlayerBuffer07 : .storage $100
Zx0PlayerBuffer08 : .storage $100
Zx0PlayerBuffer09 : .storage $100
Zx0PlayerBuffer10 : .storage $100
Zx0PlayerBuffer11 : .storage $100     
Zx0PlayerBuffer12 : .storage $100
Zx0PlayerBuffer13 : .storage $100

Zx0PlayerAyRegDataPtrs:
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
