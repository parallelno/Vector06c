
; sharetable chunk of code to restore SP and 
; return a couple of parameters within HL, C
DrawSpriteRet:
drawSpriteScrAddr:
			lxi h, TEMP_ADDR
drawSpriteWidthHeight:
; d - width
;		00 - 8pxs,
;		01 - 16pxs,
;		10 - 24pxs,
;		11 - 32pxs,
; e - height
			lxi d, TEMP_WORD
RestoreSP:
			lxi sp, TEMP_ADDR
			RAM_DISK_OFF()
			ret
			.closelabels

; =============================================
; Draw a sprite with a mask in three consiquence screen buffs with offsetX and offsetY
; width is 1-3 bytes
; height is 0-255
; offsetX is 0-1 bytes
; offsetY is 0-31 pixels down
; it uses sp to read the sprite data

; input:
; bc	sprite data
; de	screen address
; use: a, hl, sp

; the sprite format:
; 0, 0 - safety bytes
; offsetY, offsetX
; height, width
	; width: 0 - one byte width, 1 - two bytes width, 2 - three bytes width

; art data:
; 1st screen buff : 1 -> 2
; 2nd screen buff : 4 <- 3
; 3rd screen buff : 6 <- 5
; y++
; 3rd screen buff : 7 -> 8
; 2nd screen buff : 10 <- 9
; 1st screen buff : 12 <- 11
; y++
; repeat for the next lines of the art data
.macro DrawSpriteVM_B()
			pop b
			mov a, m
			ana c
			ora b
			mov m, a
.endmacro

DrawSpriteVM:
			; store sp
			lxi h, 0
			dad	sp
			shld RestoreSP + 1
			; sp = BC
			mov	h, b
			mov	l, c
			RAM_DISK_ON(RAM_DISK0_B0_STACK_B2_AF_RAM)
			sphl
			xchg
			; b - offsetX
			; c - offsetY
			pop b
			dad b
			; store a sprite screen addr to return it from this func
			shld drawSpriteScrAddr+1

			; store sprite width and height
			; b - width, c - height
			pop b
			mov d, b
			mov e, c
			xchg
			shld drawSpriteWidthHeight+1
			xchg
			mov a, b
			rrc
			jc @width16
			rrc
			jc @width24
			jmp @width8


;------------------------------------------------
@width16:
			; save the high screen byte to restore X
			rlc
			add h
			sta @w16oddScr1+1
			adi $20
			mov d, a
			adi $20
			sta @w16evenScr3+1

@w16evenScr1:
			DrawSpriteVM_B()
			inr h
			DrawSpriteVM_B()
@w16evenScr2:
			mov h, d
			DrawSpriteVM_B()
			dcr h
			DrawSpriteVM_B()
@w16evenScr3:
			mvi h, TEMP_BYTE
			DrawSpriteVM_B()
			dcr h
			DrawSpriteVM_B()
			inr l
			dcr e
			jz DrawSpriteRet

@w16oddScr3:
			DrawSpriteVM_B()
			inr h
			DrawSpriteVM_B()
@w16oddScr2:
			mov h, d
			DrawSpriteVM_B()
			dcr h
			DrawSpriteVM_B()
@w16oddScr1:
			mvi h, TEMP_BYTE
			DrawSpriteVM_B()
			dcr h
			DrawSpriteVM_B()
			inr l
			dcr e
			jnz @w16evenScr1
			jmp DrawSpriteRet
;-------------------------------------------------
@width24:
			; save the high screen byte to restore X
			mvi a, 2
			add h
			sta @w24oddScr1+1
			adi $20
			mov d, a
			adi $20
			sta @w24evenScr3+1

@w24evenScr1:
			DrawSpriteVM_B()
			inr h
			DrawSpriteVM_B()
			inr h
			DrawSpriteVM_B()

@w24evenScr2:
			mov h, d
			DrawSpriteVM_B()
			dcr h
			DrawSpriteVM_B()
			dcr h
			DrawSpriteVM_B()

@w24evenScr3:
			mvi h, TEMP_BYTE
			DrawSpriteVM_B()
			dcr h
			DrawSpriteVM_B()
			dcr h
			DrawSpriteVM_B()
			inr l
			dcr e
			jz DrawSpriteRet

@w24oddScr3:
			DrawSpriteVM_B()
			inr h
			DrawSpriteVM_B()
			inr h
			DrawSpriteVM_B()
@w24oddScr2:
			mov h, d
			DrawSpriteVM_B()
			dcr h
			DrawSpriteVM_B()
			dcr h
			DrawSpriteVM_B()
@w24oddScr1:
			mvi h, TEMP_BYTE
			DrawSpriteVM_B()
			dcr h
			DrawSpriteVM_B()
			dcr h
			DrawSpriteVM_B()
			inr l
			dcr e
			jnz @w24evenScr1
			jmp DrawSpriteRet
;------------------------------------------------------
@width8:
			; save the high screen byte to restore X
			mov a, h
			sta @w8oddScr1+1
			adi $20
			mov d, a
			adi $20
			sta @w8evenScr3+1

@w8evenScr1:
			DrawSpriteVM_B()
@w8evenScr2:
			mov h, d
			DrawSpriteVM_B()
@w8evenScr3:
			mvi h, TEMP_BYTE
			DrawSpriteVM_B()
			inr l
			dcr e
			jz DrawSpriteRet
@w8oddScr3:
			DrawSpriteVM_B()
@w8oddScr2:
			mov h, d
			DrawSpriteVM_B()
@w8oddScr1:
			mvi h, TEMP_BYTE
			DrawSpriteVM_B()
			inr l
			dcr e
			jnz @w8evenScr1
			jmp DrawSpriteRet
			.closelabels
