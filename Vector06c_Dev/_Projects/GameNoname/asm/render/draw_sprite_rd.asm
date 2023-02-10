; sharetable chunk of code to restore SP and 
; return a couple of parameters within HL, C
DrawSpriteRet_ramDisk__:
drawSpriteRestoreSP_ramDisk__:
			lxi sp, TEMP_ADDR
drawSpriteScrAddr_ramDisk__:
			lxi b, TEMP_ADDR
drawSpriteWidthHeight_ramDisk__:
; d - width
;		00 - 8pxs,
;		01 - 16pxs,
;		10 - 24pxs,
;		11 - 32pxs,
; e - height
			lxi d, TEMP_WORD
			ret
			.closelabels
			
; =============================================
; Draw a sprite without a mask in three consiquence screen buffs with offsetX and offsetY
; width is 1-3 bytes
; height is 0-255
; offsetX in bytes
; offsetY in pixels
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
.macro DrawSpriteV_B0()
			pop b
			mov m, c
.endmacro
.macro DrawSpriteV_B1()
			mov m, b
.endmacro
__DrawSpriteV:
			; store SP
			lxi h, 0
			dad sp
			shld drawSpriteRestoreSP_ramDisk__ + 1
			; sp = BC
			mov	h, b
			mov	l, c
			sphl
			xchg
			; b - offsetX
			; c - offsetY
			pop b
			dad b
			; store a sprite screen addr to return it from this func
			shld drawSpriteScrAddr_ramDisk__+1

			; store sprite width and height
			; b - width, c - height
			pop b
			mov d, b
			mov e, c
			xchg
			shld drawSpriteWidthHeight_ramDisk__+1
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
			DrawSpriteV_B0()
			inr h
			DrawSpriteV_B1()
@w16evenScr2:
			mov h, d
			DrawSpriteV_B0()
			dcr h
			DrawSpriteV_B1()
@w16evenScr3:
			mvi h, TEMP_BYTE
			DrawSpriteV_B0()
			dcr h
			DrawSpriteV_B1()
			inr l
			dcr e
			jz DrawSpriteRet_ramDisk__

@w16oddScr3:
			DrawSpriteV_B0()
			inr h
			DrawSpriteV_B1()
@w16oddScr2:
			mov h, d
			DrawSpriteV_B0()
			dcr h
			DrawSpriteV_B1()
@w16oddScr1:
			mvi h, TEMP_BYTE
			DrawSpriteV_B0()
			dcr h
			DrawSpriteV_B1()
			inr l
			dcr e
			jnz @w16evenScr1
			jmp DrawSpriteRet_ramDisk__
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
			DrawSpriteV_B0()
			inr h
			DrawSpriteV_B1()
			inr h
			DrawSpriteV_B0()

@w24evenScr2:
			mov h, d
			DrawSpriteV_B1()
			dcr h
			DrawSpriteV_B0()
			dcr h
			DrawSpriteV_B1()

@w24evenScr3:
			mvi h, TEMP_BYTE
			DrawSpriteV_B0()
			dcr h
			DrawSpriteV_B1()
			dcr h
			DrawSpriteV_B0()
			inr l
			dcr e
			jz DrawSpriteRet_ramDisk__

@w24oddScr3:
			DrawSpriteV_B1()
			inr h
			DrawSpriteV_B0()
			inr h
			DrawSpriteV_B1()
@w24oddScr2:
			mov h, d
			DrawSpriteV_B0()
			dcr h
			DrawSpriteV_B1()
			dcr h
			DrawSpriteV_B0()
@w24oddScr1:
			mvi h, TEMP_BYTE
			DrawSpriteV_B1()
			dcr h
			DrawSpriteV_B0()
			dcr h
			DrawSpriteV_B1()
			inr l
			dcr e
			jnz @w24evenScr1
			jmp DrawSpriteRet_ramDisk__
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
			DrawSpriteV_B0()
@w8evenScr2:
			mov h, d
			DrawSpriteV_B1()
@w8evenScr3:
			mvi h, TEMP_BYTE
			DrawSpriteV_B0()
			inr l
			dcr e
			jz DrawSpriteRet_ramDisk__
@w8oddScr3:
			DrawSpriteV_B1()
@w8oddScr2:
			mov h, d
			DrawSpriteV_B0()
@w8oddScr1:
			mvi h, TEMP_BYTE
			DrawSpriteV_B1()
			inr l
			dcr e
			jnz @w8evenScr1
			jmp DrawSpriteRet_ramDisk__
			.closelabels


; =============================================
; Draw a sprite with a mask in three consiquence screen buffs with offsetX and offsetY
; width is 1-3 bytes
; height is 0-255
; offsetX in bytes
; offsetY in pixels
; it uses sp to read the sprite data
; ex. CALL_RAM_DISK_FUNC(__DrawSpriteVM, __RAM_DISK_S_HERO_ATTACK01 | __RAM_DISK_M_DRAW_SPRITE_VM | RAM_DISK_M_8F)
; input:
; bc	sprite data
; de	screen address
; use: a, hl, sp

; data format:
; .word - two safety bytes to prevent a data corruption by the interruption  func
; .byte - offsetY
; .byte - offsetX
; .byte - height
; .byte - width
; 		0 - one byte width, 
;		1 - two bytes width, 
;		2 - three bytes width

; pixel format:
; 1st screen buff : 1 -> 2
; 2nd screen buff : 4 <- 3
; 3rd screen buff : 6 <- 5
; y++
; 3rd screen buff : 7 -> 8
; 2nd screen buff : 10 <- 9
; 1st screen buff : 12 <- 11
; y++
; repeat for the next lines of the art data
.macro DRAW_SPRITE_V_M()
			pop b
			mov a, m
			ana c
			ora b
			mov m, a
.endmacro

__RAM_DISK_M_DRAW_SPRITE_VM = RAM_DISK_M

__DrawSpriteVM:
			; store SP
			lxi h, 0
			dad sp
			shld drawSpriteRestoreSP_ramDisk__ + 1
			; sp = BC
			mov	h, b
			mov	l, c
			sphl
			xchg
			; b - offsetX
			; c - offsetY
			pop b
			dad b
			; store a sprite screen addr to return it from this func
			shld drawSpriteScrAddr_ramDisk__+1

			; store sprite width and height
			; b - width, c - height
			pop b
			mov d, b
			mov e, c
			xchg
			shld drawSpriteWidthHeight_ramDisk__+1
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
			DRAW_SPRITE_V_M()
			inr h
			DRAW_SPRITE_V_M()
@w16evenScr2:
			mov h, d
			DRAW_SPRITE_V_M()
			dcr h
			DRAW_SPRITE_V_M()
@w16evenScr3:
			mvi h, TEMP_BYTE
			DRAW_SPRITE_V_M()
			dcr h
			DRAW_SPRITE_V_M()
			inr l
			dcr e
			jz DrawSpriteRet_ramDisk__

@w16oddScr3:
			DRAW_SPRITE_V_M()
			inr h
			DRAW_SPRITE_V_M()
@w16oddScr2:
			mov h, d
			DRAW_SPRITE_V_M()
			dcr h
			DRAW_SPRITE_V_M()
@w16oddScr1:
			mvi h, TEMP_BYTE
			DRAW_SPRITE_V_M()
			dcr h
			DRAW_SPRITE_V_M()
			inr l
			dcr e
			jnz @w16evenScr1
			jmp DrawSpriteRet_ramDisk__
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
			DRAW_SPRITE_V_M()
			inr h
			DRAW_SPRITE_V_M()
			inr h
			DRAW_SPRITE_V_M()

@w24evenScr2:
			mov h, d
			DRAW_SPRITE_V_M()
			dcr h
			DRAW_SPRITE_V_M()
			dcr h
			DRAW_SPRITE_V_M()

@w24evenScr3:
			mvi h, TEMP_BYTE
			DRAW_SPRITE_V_M()
			dcr h
			DRAW_SPRITE_V_M()
			dcr h
			DRAW_SPRITE_V_M()
			inr l
			dcr e
			jz DrawSpriteRet_ramDisk__

@w24oddScr3:
			DRAW_SPRITE_V_M()
			inr h
			DRAW_SPRITE_V_M()
			inr h
			DRAW_SPRITE_V_M()
@w24oddScr2:
			mov h, d
			DRAW_SPRITE_V_M()
			dcr h
			DRAW_SPRITE_V_M()
			dcr h
			DRAW_SPRITE_V_M()
@w24oddScr1:
			mvi h, TEMP_BYTE
			DRAW_SPRITE_V_M()
			dcr h
			DRAW_SPRITE_V_M()
			dcr h
			DRAW_SPRITE_V_M()
			inr l
			dcr e
			jnz @w24evenScr1
			jmp DrawSpriteRet_ramDisk__
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
			DRAW_SPRITE_V_M()
@w8evenScr2:
			mov h, d
			DRAW_SPRITE_V_M()
@w8evenScr3:
			mvi h, TEMP_BYTE
			DRAW_SPRITE_V_M()
			inr l
			dcr e
			jz DrawSpriteRet_ramDisk__
@w8oddScr3:
			DRAW_SPRITE_V_M()
@w8oddScr2:
			mov h, d
			DRAW_SPRITE_V_M()
@w8oddScr1:
			mvi h, TEMP_BYTE
			DRAW_SPRITE_V_M()
			inr l
			dcr e
			jnz @w8evenScr1
			jmp DrawSpriteRet_ramDisk__
			.closelabels
