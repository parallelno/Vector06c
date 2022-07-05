;-------------------------------------------------
;|                                               |
;|     Sprite Rendering Speed Test		         |
;|     											 |
;|     Original ver. 2020						 |
;|     by KTSerg aka Sergey Cherkozianov		 |
;-------------------------------------------------
;.setting "OmitUnusedFunctions", true

.include "init.asm"
.include "macro.asm"
; subs
.include "utils.asm"
.include "interruptions.asm"
.include "sprite.asm"

			SPRITE_DY 				= 24
			SPRITE_INIT_COUNT 		= 10
spriteCoordTbl:
			.word	$8180, $8490, $88A0, $8BD0, 
			.word	$8E40, $9150, $9470, $9750, $9AF0, $9D90
spriteTbl:	.byte	0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10
spriteSpeedYTbl:	
			.byte	1, -1, 1, 2, -3, 2, 0, 10, -2, 0, 1		
Start:
;----------------------------------------------------------------
			HLT
			;------------------------------------------
			; speed test indication on the boorder
			MVI		A, PORT0_OUT_OUT
			OUT		0
			LDA  	0;borderColorIdx ; (16)			
			OUT		2
			;------------------------------------------
			MVI		A, SPRITE_INIT_COUNT
			STA		@counter
			LXI		H, spriteCoordTbl
			LXI		D, spriteSpeedYTbl
			MVI		C, SPRITE_DY + 20; lowest possible Y
@loop:
			LDAX	D
			MOV		B, A
			ADD		M
			MOV 	M, A
			CMP		C
			JNC		@next

			; inverse speed Y
			MOV 	A, B
			CMA
			INR		A
			STAX	D
			; restore prev Y
			; ADD		M
			; MOV		M, A
@next:
			
			INX		H
			INX		H
			INX		D

			
@counter = *+1
			MVI		A, TEMP_BYTE
			DCR		A
			STA		@counter

			JNZ		@loop
 			.closelabels


			;-------------------------------------------
			MVI		A, SPRITE_INIT_COUNT
			STA		@counter
			LXI		H, spriteCoordTbl
			LXI		D, spriteTbl
@loop:			
			LDAX	D
			INX		D
			PUSH	D
			XCHG	; save HL to DE because GetSpriteAddr doesn't use it
			CALL	GetSpriteAddr
			XCHG
			MOV		E, M
			INX		H
			MOV		D, M
			INX		H
			PUSH	H
			CALL	DrawSprite24x24
			POP		H
			POP		D

@counter = *+1
			MVI		A, TEMP_BYTE
			DCR		A
			STA		@counter
			JNZ		@loop
			
			;------------------------------------------
			; speed test indication on the boorder
			MVI		A, PORT0_OUT_OUT
			OUT		0
			LDA  	1;borderColorIdx ; (16)			
			OUT		2
			;------------------------------------------
			JMP		Start
			.closelabels

;================================================================
; SUBROUTINES
;================================================================

;----------------------------------------------------------------
; Get an address by a sprite index
; in: A		sprite index
; out: BC	sprite address
; corrupt: HL, A

GetSpriteAddr:
			; BC = A * 2 + spriteTable
			ADD		A				; (4)
			MOV		C, A			; (8)
			MVI		B, 0			; (8)
			LXI		H, spriteTable	; (12)
			DAD		B				; (12)
			MOV		C, M			; (8)
			INX		H				; (8)
			MOV		B, M			; (8)
			RET						; (12)
									; (88) total, 14 bytes


.include "sprites.asm"

;================================================================
			.END