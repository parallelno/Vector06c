; sharetable chunk of code to restore SP and 
; return a couple of parameters within HL, C
DrawSpriteRet:
drawSpriteScrAddr:
			lxi h, TEMP_ADDR
drawSpriteWidthHeight:
;   height/width packed HHHHHHWW
;	HHHHHH - height
;	WW - width
;		00 - 8pxs,
;		01 - 16pxs,
;		10 - 24pxs,
;		11 - 32pxs,
			mvi c, TEMP_BYTE
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
; de	screen address (in the $8000 screen buffer)
; use: a, hl, sp

; the sprite format:
; 0, 0 - safety bytes
; height
; %YYYYYWWX
			; X - offsetX. 0 - no offset, 1 - one byte offset to the right
			; WW - width. 0 - one byte width, 1 - two bytes width, 2 - three bytes width
			; YYYYY - offsetY down
; art data:
; 1st screen buff : 1 -> 2
; 2nd screen buff : 4 <- 3
; 3rd screen buff : 6 <- 5
; y--
; 3rd screen buff : 7 -> 8
; 2nd screen buff : 10 <- 9
; 1st screen buff : 12 <- 11
; y--
; repeat the next lines of the art data
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
			; b - %YYYYYWWX
			; 		X - offsetX. 0 - no offset, 1 - one byte offset to the right
			; 		WW - width. 0 - one byte width, 1 - two bytes width, 2 - three bytes width
			; 		YYYYY - offsetY down
			; c - height
			pop b
			mov a, b
			rrc
			jnc @noOffsetX
			inr h
@noOffsetX:
			rrc
			jc @width16
			rrc
			jnc @width8

@width24:
			; get offsetY and apply it to X
			ani %11111
			sub l
			cma
			inr a
			mov l, a
			; store sprite screen addr to return it from this func
			shld drawSpriteScrAddr+1
			; store sprite width and height packed as WWHHHHHH
			mvi a, %10000000
			ora c
			sta drawSpriteWidthHeight+1

			; save the high screen byte to restore X
			mvi a, 2
			add h
			sta @w24oddScr1+1
			adi $20
			mov d, a
			adi $20
			sta @w24evenScr3+1
			; height counter
			mov e, c

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
			dcr l
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
			dcr l
			dcr e
			jnz @w24evenScr1
			jmp DrawSpriteRet
;------------------------------------------------
@width16:
			; get offsetY and apply it to X
			rrc
			ani %11111
			sub l
			cma
			inr a
			mov l, a
			; store hl to return it from this func
			shld drawSpriteScrAddr+1
			; store sprite width and height packed as WWHHHHHH
			mvi a, %01000000
			ora c
			sta drawSpriteWidthHeight+1

			; save the high screen byte to restore X
			mvi a, 1
			add h
			sta @w16oddScr1+1
			adi $20
			mov d, a
			adi $20
			sta @w16evenScr3+1
			; counter
			mov e, c

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
			dcr l
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
			dcr	l
			dcr e
			jnz @w16evenScr1
			jmp DrawSpriteRet
;-------------------------------------------------
@width8:
			; get offsetY and apply it to X
			ani %11111
			sub l
			cma
			inr a
			mov l, a
			; store hl to return it from this func
			shld drawSpriteScrAddr+1
			; store sprite width and height packed as WWHHHHHH
			mov a, c
			sta drawSpriteWidthHeight+1

			; save the high screen byte to restore X
			mov a, h
			sta @w8oddScr1+1
			adi $20
			mov d, a
			adi $20
			sta @w8evenScr3+1
			; counter
			mov e, c

@w8evenScr1:
			DrawSpriteVM_B()
@w8evenScr2:
			mov h, d
			DrawSpriteVM_B()
@w8evenScr3:
			mvi h, TEMP_BYTE
			DrawSpriteVM_B()
			dcr l
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
			dcr	l
			dcr e
			jnz @w8evenScr1
			jmp DrawSpriteRet
			.closelabels

/*
; =============================================
; Draw a sprite in three consiquence screen buffs with offsetX and offsetY
; width is 1-3 bytes
; height is 0-255
; offsetX is 0-1 bytes
; offsetY is 0-31 pixels down
; it uses sp to read the sprite data

; input:
; bc	sprite data
; de	screen address (in the $8000 screen buffer)
; use: a, hl, sp

; the sprite format:
; 0, 0 - safety bytes
; height
; %YYYYYWWX
			; X - offsetX. 0 - no offset, 1 - one byte offset to the right
			; WW - width. 0 - one byte width, 1 - two bytes width, 2 - three bytes width
			; YYYYY - offsetY down
; art data:
; 1st screen buff : 1 -> 2
; 2nd screen buff : 4 <- 3
; 3rd screen buff : 6 <- 5
; y--
; 3rd screen buff : 7 -> 8
; 2nd screen buff : 10 <- 9
; 1st screen buff : 12 <- 11
; y--
; repeat the next lines of the art data
.macro DrawSpriteV_B()
			pop b
			mov m, b
.endmacro

DrawSpriteV:
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
			; b - %YYYYYWWX
			; 		X - offsetX. 0 - no offset, 1 - one byte offset to the right
			; 		WW - width. 0 - one byte width, 1 - two bytes width, 2 - three bytes width
			; 		YYYYY - offsetY down
			; c - height
			pop b
			mov a, b
			rrc
			jnc @noOffsetX
			inr h
@noOffsetX:
			rrc
			jc @width16
			rrc
			jnc @width8

@width24:
			; get offsetY and apply it to X
			ani %11111
			sub l
			cma
			inr a
			mov l, a
			; store sprite screen addr to return it from this func
			shld drawSpriteScrAddr+1
			; store sprite width and height packed as WWHHHHHH
			mvi a, %01000000
			ora c
			sta drawSpriteWidthHeight+1

			; save the high screen byte to restore X
			mvi a, 2
			add h
			sta @w24oddScr1+1
			adi $20
			mov d, a
			adi $20
			sta @w24evenScr3+1
			; height counter
			mov e, c

@w24evenScr1:
			DrawSpriteV_B()
			inr h
			DrawSpriteV_B()
			inr h
			DrawSpriteV_B()

@w24evenScr2:
			mov h, d
			DrawSpriteV_B()
			dcr h
			DrawSpriteV_B()
			dcr h
			DrawSpriteV_B()

@w24evenScr3:
			mvi h, TEMP_BYTE
			DrawSpriteV_B()
			dcr h
			DrawSpriteV_B()
			dcr h
			DrawSpriteV_B()
			dcr l
			dcr e
			jz DrawSpriteRet

@w24oddScr3:
			DrawSpriteV_B()
			inr h
			DrawSpriteV_B()
			inr h
			DrawSpriteV_B()
@w24oddScr2:
			mov h, d
			DrawSpriteV_B()
			dcr h
			DrawSpriteV_B()
			dcr h
			DrawSpriteV_B()
@w24oddScr1:
			mvi h, TEMP_BYTE
			DrawSpriteV_B()
			dcr h
			DrawSpriteV_B()
			dcr h
			DrawSpriteV_B()
			dcr l
			dcr e
			jnz @w24evenScr1
			jmp DrawSpriteRet
;------------------------------------------------
@width16:
			; get offsetY and apply it to X
			rrc
			ani %11111
			sub l
			cma
			inr a
			mov l, a
			; store hl to return it from this func
			shld drawSpriteScrAddr+1
			; store sprite width and height packed as WWHHHHHH
			mvi a, %10000000
			ora c
			sta drawSpriteWidthHeight+1

			; save the high screen byte to restore X
			mvi a, 1
			add h
			sta @w16oddScr1+1
			adi $20
			mov d, a
			adi $20
			sta @w16evenScr3+1
			; counter
			mov e, c

@w16evenScr1:
			DrawSpriteV_B()
			inr h
			DrawSpriteV_B()
@w16evenScr2:
			mov h, d
			DrawSpriteV_B()
			dcr h
			DrawSpriteV_B()
@w16evenScr3:
			mvi h, TEMP_BYTE
			DrawSpriteV_B()
			dcr h
			DrawSpriteV_B()
			dcr l
			dcr e
			jz DrawSpriteRet

@w16oddScr3:
			DrawSpriteV_B()
			inr h
			DrawSpriteV_B()
@w16oddScr2:
			mov h, d
			DrawSpriteV_B()
			dcr h
			DrawSpriteV_B()
@w16oddScr1:
			mvi h, TEMP_BYTE
			DrawSpriteV_B()
			dcr h
			DrawSpriteV_B()
			dcr	l
			dcr e
			jnz @w16evenScr1
			jmp DrawSpriteRet
;-------------------------------------------------
@width8:
			; get offsetY and apply it to X
			ani %11111
			sub l
			cma
			inr a
			mov l, a
			; store hl to return it from this func
			shld drawSpriteScrAddr+1
			; store sprite width and height packed as WWHHHHHH
			mov a, c
			sta drawSpriteWidthHeight+1

			; save the high screen byte to restore X
			mov a, h
			sta @w8oddScr1+1
			adi $20
			mov d, a
			adi $20
			sta @w8evenScr3+1
			; counter
			mov e, c

@w8evenScr1:
			DrawSpriteV_B()
@w8evenScr2:
			mov h, d
			DrawSpriteV_B()
@w8evenScr3:
			mvi h, TEMP_BYTE
			DrawSpriteV_B()
			dcr l
			dcr e
			jz DrawSpriteRet
@w8oddScr3:
			DrawSpriteV_B()
@w8oddScr2:
			mov h, d
			DrawSpriteV_B()
@w8oddScr1:
			mvi h, TEMP_BYTE
			DrawSpriteV_B()
			dcr	l
			dcr e
			jnz @w8evenScr1
			jmp DrawSpriteRet
			.closelabels
*/
