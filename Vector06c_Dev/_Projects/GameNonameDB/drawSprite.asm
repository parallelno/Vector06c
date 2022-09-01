
/*
; =============================================
; Draw a width*height sprite in three consiquence screen buffs with offsetX and offsetY
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

DrawSpriteV:
			; store sp
			lxi h, 0			; (12)
			dad	sp				; (12)
			shld DrawSprite_restoreSP + 1	; (20)
			; sp = BC
			mov	h, b			; (8)
			mov	l, c			; (8)
			; skip the mask data offset and 2 safety bytes
			RAM_DISK_ON()
			sphl				; (8)
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

			; save the high screen byte to restore X
			mvi a, 2
			add h
			sta @w24oddScr1+1
			adi $20
			mov d, a
			adi $20
			; height counter
			mov e, c

@w24evenScr1:	
			pop b
			mov m, c
			inr h
			mov m, b
			inr h
			pop b
			mov m, c
@w24evenScr2:  
			mov h, d
			mov m, b
			dcr h
			pop b
			mov m, c
			dcr h
			mov m, b
@w24evenScr3:	
			mov h, a
			pop b
			mov m, c
			dcr h
			mov m, b
			dcr h
			pop b
			mov m, c
			dcr l			
			dcr e
			jz DrawSprite_restoreSP

@w24oddScr3:	
			mov m, b
			inr h
			pop b
			mov m, c
			inr h
			mov m, b
@w24oddScr2:	
			mov h, d
			pop b
			mov m, c
			dcr h
			mov m, b
			dcr h
			pop b
			mov m, c
@w24oddScr1:	
			mvi h, TEMP_BYTE
			mov m, b
			dcr h
			pop b
			mov m, c
			dcr h
			mov m, b
			dcr l
			dcr e
			jnz @w24evenScr1
			jmp DrawSprite_restoreSP
;------------------------------------------------
@width16:
			; get offsetY and apply it to X
			rrc
			ani %11111
			sub l
			cma
			inr a			
			mov l, a

			; save the high screen byte to restore X
			mvi a, 1
			add h
			sta @w16oddScr1+1
			adi $20
			mov d, a
			adi $20
			; counter
			mov e, c

@w16evenScr1:	
			pop b
			mov m, c
			inr h
			mov m, b
@w16evenScr2:  
			mov h, d
			pop b
			mov m, c
			dcr h
			mov m, b
@w16evenScr3:	
			mov h, a
			pop b
			mov m, c
			dcr h
			mov m, b
			dcr l			
			dcr e
			jz DrawSprite_restoreSP

@w16oddScr3:	
			pop b
			mov m, c
			inr h
			mov m, b
@w16oddScr2:	
			mov h, d 
			pop b
			mov m, c
			dcr h
			mov m, b
@w16oddScr1:	
			mvi h, TEMP_BYTE
			pop b
			mov m, c
			dcr h
			mov m, b
			dcr	l
			dcr e
			jnz @w16evenScr1
			jmp DrawSprite_restoreSP
;-------------------------------------------------
@width8:
			; get offsetY and apply it to X
			ani %11111
			sub l
			cma
			inr a			
			mov l, a
			; save the high screen byte to restore X
			mov a, h
			sta @w8oddScr1+1
			adi $20
			mov d, a
			adi $20
			; counter
			mov e, c

@w8evenScr1:	
			pop b
			mov m, c
@w8evenScr2:	
			mov h, d
			mov m, b
@w8evenScr3:	
			mov h, a
			pop b
			mov m, c
			dcr l
			dcr e
			jz DrawSprite_restoreSP
@w8oddScr3:	
			mov m, b
@w8oddScr2:	
			mov h, d
			pop b
			mov m, c
@w8oddScr1:	
			mvi h, TEMP_BYTE
			mov m, b
			dcr	l
			dcr e
			jnz @w8evenScr1
			jmp DrawSprite_restoreSP

; =============================================
; Draw a dx*15 sprite in three consiquence screen buffs with offsetX
; width is 1-3 bytes
; offsetX is 0-1 bytes
; it uses sp to read the sprite data

; input:
; bc	sprite data addr
; de	screen addr (in the $8000 screen buffer)
; use: a, hl, sp

; the sprite format:
; 0, 0 - safety bytes
; 0 - not used
; %YYYYYWWX
			; X - offsetX. 0 - no offset, 1 - one byte offset to the right
			; WW - width. 0 - one byte width, 1 - two bytes width, 2 - three bytes width
			; YYYYY - not used
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

DrawSprite:
			; store sp
			lxi h, 0
			dad	sp
			shld DrawSprite_restoreSP + 1
			; sp = BC
			mov	h, b
			mov	l, c
			inx_h(3)
			RAM_DISK_ON()
			sphl
			xchg
			; b - %YYYYYWWX
			; 		X - offsetX. 0 - no offset, 1 - one byte to right offset.
			; 		WW - width. 0 - one byte width, 1 - two bytes width, 2 - three bytes width
			; 		YYYYY - not used
			; c - not used in this func (used only in the interruption to restore the stack data)
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
			; save the high screen byte to restore X
			mvi a, 2
			add h
			mov d, a
			adi $20
			mov e, a
			adi $20

			DRAW_EVEN_LINE_24()
			DRAW_ODD_LINE_24()						
			DRAW_EVEN_LINE_24()			
			DRAW_ODD_LINE_24()			
			DRAW_EVEN_LINE_24()
			DRAW_ODD_LINE_24()			
			DRAW_EVEN_LINE_24()
			DRAW_ODD_LINE_24()			

			DRAW_EVEN_LINE_24()
			DRAW_ODD_LINE_24()			
			DRAW_EVEN_LINE_24()
			DRAW_ODD_LINE_24()			
			DRAW_EVEN_LINE_24()
			DRAW_ODD_LINE_24()			
			DRAW_EVEN_LINE_24(False)

			jmp DrawSprite_restoreSP

;-------------------------------------------------------------
@width16:
			; save the high screen byte to restore X
			mvi		a, 1
			add 	h
			mov 	d, a
			adi     $20
			mov     e, a
			adi 	$20

			DRAW_EVEN_LINE_16()	
			DRAW_ODD_LINE_16()
			DRAW_EVEN_LINE_16()	
			DRAW_ODD_LINE_16()
			DRAW_EVEN_LINE_16()	
			DRAW_ODD_LINE_16()
			DRAW_EVEN_LINE_16()	
			DRAW_ODD_LINE_16()

			DRAW_EVEN_LINE_16()	
			DRAW_ODD_LINE_16()
			DRAW_EVEN_LINE_16()	
			DRAW_ODD_LINE_16()
			DRAW_EVEN_LINE_16()	
			DRAW_ODD_LINE_16()
			DRAW_EVEN_LINE_16(false)
			
			jmp DrawSprite_restoreSP
;-------------------------------------------------------------
@width8:
			; save the high screen byte to restore X
			mov a, h
			mov d, h
			adi $20
			mov e, a
			adi $20

			DRAW_EVEN_LINE_8()
			DRAW_ODD_LINE_8()
			DRAW_EVEN_LINE_8()
			DRAW_ODD_LINE_8()
			DRAW_EVEN_LINE_8()
			DRAW_ODD_LINE_8()
			DRAW_EVEN_LINE_8()
			DRAW_ODD_LINE_8()

			DRAW_EVEN_LINE_8()
			DRAW_ODD_LINE_8()
			DRAW_EVEN_LINE_8()
			DRAW_ODD_LINE_8()
			DRAW_EVEN_LINE_8()
			DRAW_ODD_LINE_8()
			DRAW_EVEN_LINE_8(false)

DrawSprite_restoreSP:
			lxi sp, TEMP_ADDR	; restore sp (12)
			RAM_DISK_OFF()
			ret
			.closelabels

.macro DRAW_EVEN_LINE_8(_moveDown = true)
@scr1:		pop b
			mov m, c
@scr2:		mov h, e
			mov m, b
@scr3:		mov h, a
			pop b
			mov m, c
		.if _moveDown == True
			dcr l
		.endif
.endmacro

.macro DRAW_ODD_LINE_8(_moveDown = true)
@scr3:	
			mov m, b
@scr2:		mov h, d
			pop b
			mov m, c
@scr1:		mvi h, TEMP_BYTE
			mov m, b
		.if _moveDown == True
			dcr l
		.endif
.endmacro

.macro DRAW_EVEN_LINE_16(_moveDown = true)
@scr1:		pop b
			mov m, c
			inr h
			mov m, b
@scr2:		mov h, e
			pop b
			mov m, c
			dcr h
			mov m, b
@scr3:		mov h, a
			pop b
			mov m, c
			dcr h
			mov m, b
		.if _moveDown == true
			dcr	l
		.endif
.endmacro

.macro DRAW_ODD_LINE_16(_moveDown = true)
@scr3:		pop b
			mov m, c
			inr h
			mov m, b
@scr2:		mov h, e
			pop b
			mov m, c
			dcr h
			mov m, b
@scr1:		mov h, d
			pop b
			mov m, c
			dcr h
			mov m, b
		.if _moveDown == true
			dcr	l
		.endif			
.endmacro

.macro DRAW_EVEN_LINE_24(_moveDown = true)
@scr1:		pop b
			mov m, c
			inr h
			mov m, b
			inr h
			pop b
			mov m, c
@scr2:		mov h, e
			mov m, b
			dcr h
			pop b
			mov m, c
			dcr h
			mov m, b
@scr3:		mov h, a 
			pop b
			mov m, c
			dcr h
			mov m, b
			dcr h
			pop b
			mov m, c
		.if _moveDown == true
			dcr	l
		.endif
.endmacro

.macro DRAW_ODD_LINE_24(_moveDown = true)
@scr3:		mov m, b
			inr h
			pop b
			mov m, c
			inr h
			mov m, b
@scr2:		mov h, e
			pop b
			mov m, c
			dcr h
			mov m, b
			dcr h
			pop b
			mov m, c
@scr1:		mov h, d
			mov m, b
			dcr h
			pop b
			mov m, c
			dcr h
			mov m, b
		.if _moveDown == true
			dcr	l
		.endif			
.endmacro
*/

DrawSprite_restoreSP:
			lxi sp, TEMP_ADDR	; restore sp (12)
			RAM_DISK_OFF()
			ret
			.closelabels

; =============================================
; Draw with mask a width*height sprite in three consiquence screen buffs with offsetX and offsetY
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
			lxi h, 0			; (12)
			dad	sp				; (12)
			shld DrawSprite_restoreSP + 1	; (20)
			; sp = BC
			mov	h, b			; (8)
			mov	l, c			; (8)
			RAM_DISK_ON()
			sphl				; (8)
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
			jz DrawSprite_restoreSP

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
			jmp DrawSprite_restoreSP
;------------------------------------------------
@width16:
			; get offsetY and apply it to X
			rrc
			ani %11111
			sub l
			cma
			inr a			
			mov l, a

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
			jz DrawSprite_restoreSP

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
			jmp DrawSprite_restoreSP
;-------------------------------------------------
@width8:
			; get offsetY and apply it to X
			ani %11111
			sub l
			cma
			inr a			
			mov l, a
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
			jz DrawSprite_restoreSP
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
			jmp DrawSprite_restoreSP

; =============================================
; Erase a width*height sprite in three consiquence screen buffs with offsetX and offsetY
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
.macro EraseSpriteV_B() ; 72+64=136, 52+52=104
			pop b
			mov a, m
			ana c
			mov m, a
.endmacro

EraseSpriteV:
			; store sp
			lxi h, 0			; (12)
			dad	sp				; (12)
			shld DrawSprite_restoreSP + 1	; (20)
			; sp = BC
			mov	h, b			; (8)
			mov	l, c			; (8)
			RAM_DISK_ON()
			sphl				; (8)
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
			EraseSpriteV_B()
			inr h			
			EraseSpriteV_B()
			inr h
			EraseSpriteV_B()

@w24evenScr2:  
			mov h, d
			EraseSpriteV_B()
			dcr h
			EraseSpriteV_B()
			dcr h
			EraseSpriteV_B()

@w24evenScr3:	
			mvi h, TEMP_BYTE
			EraseSpriteV_B()
			dcr h
			EraseSpriteV_B()
			dcr h
			EraseSpriteV_B()
			dcr l		
			dcr e
			jz DrawSprite_restoreSP

@w24oddScr3:	
			EraseSpriteV_B()
			inr h
			EraseSpriteV_B()
			inr h
			EraseSpriteV_B()
@w24oddScr2:	
			mov h, d
			EraseSpriteV_B()
			dcr h
			EraseSpriteV_B()
			dcr h
			EraseSpriteV_B()
@w24oddScr1:	
			mvi h, TEMP_BYTE
			EraseSpriteV_B()
			dcr h
			EraseSpriteV_B()
			dcr h
			EraseSpriteV_B()
			dcr l
			dcr e
			jnz @w24evenScr1
			jmp DrawSprite_restoreSP
;------------------------------------------------
@width16:
			; get offsetY and apply it to X
			rrc
			ani %11111
			sub l
			cma
			inr a			
			mov l, a

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
			EraseSpriteV_B()
			inr h
			EraseSpriteV_B()
@w16evenScr2:  
			mov h, d
			EraseSpriteV_B()
			dcr h
			EraseSpriteV_B()
@w16evenScr3:	
			mvi h, TEMP_BYTE
			EraseSpriteV_B()
			dcr h
			EraseSpriteV_B()
			dcr l			
			dcr e
			jz DrawSprite_restoreSP

@w16oddScr3:	
			EraseSpriteV_B()
			inr h
			EraseSpriteV_B()
@w16oddScr2:	
			mov h, d 
			EraseSpriteV_B()
			dcr h
			EraseSpriteV_B()
@w16oddScr1:	
			mvi h, TEMP_BYTE
			EraseSpriteV_B()
			dcr h
			EraseSpriteV_B()
			dcr	l
			dcr e
			jnz @w16evenScr1
			jmp DrawSprite_restoreSP
;-------------------------------------------------
@width8:
			; get offsetY and apply it to X
			ani %11111
			sub l
			cma
			inr a			
			mov l, a
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
			EraseSpriteV_B()
@w8evenScr2:	
			mov h, d
			EraseSpriteV_B()
@w8evenScr3:	
			mvi h, TEMP_BYTE
			EraseSpriteV_B()
			dcr l
			dcr e
			jz DrawSprite_restoreSP
@w8oddScr3:	
			EraseSpriteV_B()
@w8oddScr2:	
			mov h, d
			EraseSpriteV_B()
@w8oddScr1:	
			mvi h, TEMP_BYTE
			EraseSpriteV_B()
			dcr	l
			dcr e
			jnz @w8evenScr1
			jmp DrawSprite_restoreSP
