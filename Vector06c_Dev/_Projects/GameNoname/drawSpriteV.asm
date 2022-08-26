
; =============================================
; Draw a dx*dy sprite in three consiquence screen buffs with offsetX and offsetY
; dx is 1-3 bytes
; dy is 0-255
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

DrawSpriteV2:
			; store sp
			lxi h, 0			; (12)
			dad	sp				; (12)
			shld DrawSpriteV_restoreSP + 1	; (20)
			; sp = BC
			mov	h, b			; (8)
			mov	l, c			; (8)
			RAM_DISK_ON()
			sphl				; (8)
			xchg
			; b - %YYYYYWWX
			; X - offsetX. 0 - no offset, 1 - one byte offset to the right
			; WW - width. 0 - one byte width, 1 - two bytes width, 2 - three bytes width
			; YYYYY - offsetY down
			; c - height
			pop b
			mov a, b			
			rrc	
			jnc @noOffsetX
			inr h	
@noOffsetX:
			rrc			
			jc DrawSpriteV2_width16
			rrc			
			jnc DrawSpriteV2_width8

@width24:
			; get offsetY and apply it to X
			ani %11111
			sub l
			cma
			inr a
			mov l, a

			; save high screen byte to restore X
			mvi a, 2
			add h
			sta @oddScr1+1
			adi $20
			mov d, a
			adi $20
			; dy counter
			mov e, c

@evenScr1:	pop b
			mov m, c
			inr h
			mov m, b
			inr h
			pop b
			mov m, c
@evenScr2:  mov h, d
			mov m, b
			dcr h
			pop b
			mov m, c
			dcr h
			mov m, b
@evenScr3:	mov h, a
			pop b
			mov m, c
			dcr h
			mov m, b
			dcr h
			pop b
			mov m, c
			dcr l			
			dcr e
			jz DrawSpriteV_restoreSP

@oddScr3:	mov m, b
			inr h
			pop b
			mov m, c
			inr h
			mov m, b
@oddScr2:	mov h, d
			pop b
			mov m, c
			dcr h
			mov m, b
			dcr h
			pop b
			mov m, c
@oddScr1:	mvi h, TEMP_BYTE
			mov m, b
			dcr h
			pop b
			mov m, c
			dcr h
			mov m, b
			dcr l
			dcr e
			jnz @evenScr1
			jmp DrawSpriteV_restoreSP
;------------------------------------------------
DrawSpriteV2_width16:
			; get offsetY and apply it to X
			rrc
			ani %11111
			sub l
			cma
			inr a			
			mov l, a

			; save high screen byte to restore X
			mvi a, 1
			add h
			sta @oddScr1+1
			adi $20
			mov d, a
			adi $20
			; counter
			mov e, c

@evenScr1:	pop b
			mov m, c
			inr h
			mov m, b
@evenScr2:  mov h, d
			pop b
			mov m, c
			dcr h
			mov m, b
@evenScr3:	mov h, a
			pop b
			mov m, c
			dcr h
			mov m, b
			dcr l			
			dcr e
			jz DrawSpriteV_restoreSP

@oddScr3:	pop b
			mov m, c
			inr h
			mov m, b
@oddScr2:	mov h, d 
			pop b
			mov m, c
			dcr h
			mov m, b
@oddScr1:	mvi h, TEMP_BYTE
			pop b
			mov m, c
			dcr h
			mov m, b
			dcr	l
			dcr e
			jnz @evenScr1
			jmp DrawSpriteV_restoreSP
;-------------------------------------------------
DrawSpriteV2_width8:
			; get offsetY and apply it to X
			ani %11111
			sub l
			cma
			inr a			
			mov l, a
			; save high screen byte to restore X
			mov a, h
			sta @oddScr1+1
			adi $20
			mov d, a
			adi $20
			; counter
			mov e, c

@evenScr1:	pop b
			mov m, c
@evenScr2:	mov h, d
			mov m, b
@evenScr3:	mov h, a
			pop b
			mov m, c
			dcr l
			dcr e
			jz DrawSpriteV_restoreSP
@oddScr3:	
			mov m, b
@oddScr2:	mov h, d
			pop b
			mov m, c
@oddScr1:	mvi h, TEMP_BYTE
			mov m, b
			dcr	l
			dcr e
			jnz @evenScr1
			jmp DrawSpriteV_restoreSP

; =============================================
; Draw a dx*15 sprite in three consiquence screen buffs with offsetX
; dx is 1-3 bytes
; offsetX is 0-1 bytes
; it uses sp to read the sprite data

; input:
; bc	sprite data
; de	screen address (in the $8000 screen buffer)
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

DrawSpriteV:
			; store sp
			lxi h, 0			; (12)
			dad	sp				; (12)
			shld DrawSpriteV_restoreSP + 1	; (20)
			; sp = BC
			mov	h, b			; (8)
			mov	l, c			; (8)
			RAM_DISK_ON()
			sphl				; (8)
			xchg				; (4)
			; b - %xxxxxWWX
			; X - offsetX. 0 - no offset, 1 - one byte to right offset.
			; WW - width. 0 - one byte width, 1 - two bytes width, 2 - three bytes width
			; xxxxx - not used
			; c - height * 2
			pop b
			mov a, b		; 8
			rrc				; 4
			jnc @noOffsetX
			inr h
@noOffsetX:
			rrc				; 4
			jc DrawSpriteV_width16
			rrc			; 4
			jnc DrawSpriteV_width8

DrawSpriteV_width24:
			; save high screen byte to restore X
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

DrawSpriteV_restoreSP:
			lxi		sp, TEMP_ADDR	; restore sp (12)
			RAM_DISK_OFF()

			ret
;-------------------------------------------------------------
DrawSpriteV_width16:
			; save high screen byte to restore X
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
			
			jmp DrawSpriteV_restoreSP
;-------------------------------------------------------------
DrawSpriteV_width8:
			; save high screen byte to restore X
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

			jmp DrawSpriteV_restoreSP
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