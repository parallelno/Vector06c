; Song title: EA at feb 2018 (YM+ABC)
; compressed into 14 parallel streams from YM6 file saved by register
; This example is decompressing and playing 14 parallel streams.
; Only one task is executed each frame. 16 bytes are decoded at a time.
; frame time: 5-20 lines
; Compressed data size 2310 bytes (uncompressed 61586)
; code by svofski 2022

			.org $100
				

.include "globalConsts.asm"

REGS = 14

StartTestMusic:
			xra a
			out $10
				
			mvi a, $c9
			sta $38

brutal_restart:                
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
ayctrl          = $15
aydata          = $14
				
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
				out ayctrl
				mov a, m
				out aydata
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
.incbin "song00.bin.unpack"
regData01:
.incbin "song01.bin.unpack"
regData02:
.incbin "song02.bin.unpack"
regData03:
.incbin "song03.bin.unpack"
regData04:
.incbin "song04.bin.unpack"
regData05:
.incbin "song05.bin.unpack"
regData06:
.incbin "song06.bin.unpack"
regData07:
.incbin "song07.bin.unpack"
regData08:
.incbin "song08.bin.unpack"
regData09:
.incbin "song09.bin.unpack"
regData10:
.incbin "song10.bin.unpack"
regData11:
.incbin "song11.bin.unpack"
regData12:
.incbin "song12.bin.unpack"
regData13:
.incbin "song13.bin.unpack"

regDataLen = regData01 - regData00