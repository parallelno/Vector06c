;----------------------------------------------------------------
; Memory Reset
; in:
; BC	buffer last byte + 1
; DE	counter (buffer length / 32)
; use: HL

			.function MemResetM
MemReset:	LXI		H, 0			; (12)
			DAD		SP				; (12)
			SHLD	@restoreSP+1	; (20)

			MOV		H, B			; (8)
			MOV		L, C			; (8)
			SPHL					; (8)
			LXI		B, $0000		; (12)

@loop:		
			PUSH_B(16)

			DCR		E				; (8)
			JNZ		@loop			; (12)
			DCR		D				; (8)
			JNZ		@loop			; (12)
@restoreSP:	
			LXI		SP, TEMP_ADDR	; restore SP (12)
			RET
			.endfunction

;----------------------------------------------------------------
; Set Palette
; in: none
; use: A, HL, BC

			INIT_COLOR_IDX			= $0F

			.function SetPaletteM
SetPalette:	PUSH	PSW			; (16)
			PUSH	B
			PUSH	H
					
			LXI		H, colorTable + INIT_COLOR_IDX
			MVI		B, INIT_COLOR_IDX

@loop:		MOV		A, B		; (8)
			OUT		2			; (12)
			MOV		A,M			; (8)
			OUT		$0C			; (12)
			INR		B			; (8) delay
			OUT		$0C			; (12)
			DCX		H			; (8)
			OUT		$0C			; (12)
			DCR		B			; (8) delay
			DCR		B			; (8)
			OUT		$0C			; (12)
								; (108) total
			JP		@loop

			MVI		A, PORT0_OUT_OUT
			OUT		0
			LDA  	borderColorIdx ; (16)			
			OUT		2
			LDA		vScroll
			OUT		3

			POP		H			; (12)
			POP		B
			POP		PSW
			RET
			.endfunction

vScroll:	.byte $0FF
			.byte 0
borderColorIdx:
			.byte 0
colorTable:	.byte %01011011, $03, %01100010, $14, 
			.byte %10101101, $55, %11111110, $80,
			.byte %11111000, $F0, %00010010, $2D,
			.byte $2D, $2D, $2D, $07

spriteTable:.word	spriteData00, spriteData01, spriteData02, spriteData03
			.word	spriteData04, spriteData05, spriteData06, spriteData07
			.word	spriteData08, spriteData09, spriteData10, spriteData11
			.word	spriteData12, spriteData13, spriteData14, spriteData15            