REGS = 14

StartTestMusic:
			xra a
			out $10
			mvi a, $c9
			sta $38
			lxi sp, $100
			
; synced with interruptions
@loop:
			ei
			
			hlt
			call SongDataUpdate
			call AYUpdate
			jmp @loop
			.closelabels

SchedulerInit:
			lxi h, 0
			shld regDataIdx
			ret
			.closelabels

SongDataUpdate:
			lhld regDataIdx
			inx h
			mov a, h
			cpi >regDataLen
			jnz @saveRegDataCounter
			mov a, l
			cpi <regDataLen
			jnz @saveRegDataCounter
			; reset regDataIdx
			lxi h, 0
@saveRegDataCounter:
			shld regDataIdx
			ret
			.closelabels
;
; AY-3-8910 ports
;
AY_REG	= $15
AY_DATA	= $14
				
; Send data to AY regs
; reg13 (envelope shape) data = $ff means do not send data to reg13
AYUpdate:
				mvi c, 13
				lhld regDataIdx
				shld @regDataIdx+1

				lxi h, regDataPtrs+13*2+1	
@loop:
				mov d, m
				dcx h
				mov e, m  
				dcx h
				xchg

				push b
@regDataIdx:
				lxi b, TEMP_ADDR
				dad b
				pop b

				mvi a, 13
				cmp c
				jnz @sendDataToAY
				mov a, m
				cpi $ff
				jz @dontSendDataToAY
@sendDataToAY:
				mov a, c
				out AY_REG
				mov a, m
				out AY_DATA
@dontSendDataToAY:
				xchg
				dcr c
				jp @loop
				ret
				.closelabels

regDataIdx:
			.word 0

regDataPtrs:
	.word regData00, regData01, regData02, regData03, regData04, 
	.word regData05, regData06, regData07, regData08, regData09, 
	.word regData10, regData10, regData11, regData12, regData13

regData00:
.incbin "song00.bin.lz77"
regData01:
.incbin "song01.bin.lz77"
regData02:
.incbin "song02.bin.lz77"
regData03:
.incbin "song03.bin.lz77"
regData04:
.incbin "song04.bin.lz77"
regData05:
.incbin "song05.bin.lz77"
regData06:
.incbin "song06.bin.lz77"
regData07:
.incbin "song07.bin.lz77"
regData08:
.incbin "song08.bin.lz77"
regData09:
.incbin "song09.bin.lz77"
regData10:
.incbin "song10.bin.lz77"
regData11:
.incbin "song11.bin.lz77"
regData12:
.incbin "song12.bin.lz77"
regData13:
.incbin "song13.bin.lz77"

regDataLen = regData01 - regData00