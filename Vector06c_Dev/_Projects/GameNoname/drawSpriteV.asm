
; =============================================
; Draw a dx*dy sprite with offsetX and offsetY
; dx is 1-3 bytes
; dy is 0-255
; offsetX is 0-1 bytes
; offsetY is 0-31 pixels down
; it uses SP to read the sprite data

; in:
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
; $80 screen buff : 1 -> 2
; $a0 screen buff : 4 <- 3
; $c0 screen buff : 6 <- 5
; y--
; $c0 screen buff : 7 -> 8
; $a0 screen buff : 10 <- 9
; $80 screen buff : 12 <- 11
; y--
; repeat art data

DrawSpriteV2:
			; store SP
			lxi h, 0			; (12)
			dad	sp				; (12)
			shld DrawSpriteV_restoreSP + 1	; (20)
			; SP = BC
			mov	h, b			; (8)
			mov	l, c			; (8)
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
			sta @oddScr80+1
			adi $20
			mov d, a
			adi $20
			; dy counter
			mov e, c

@evenScr80:	pop b
			mov m, c
			inr h
			mov m, b
			inr h
			pop b
			mov m, c
@evenScrA0: mov h, d
			mov m, b
			dcr h
			pop b
			mov m, c
			dcr h
			mov m, b
@evenScrC0:	mov h, a
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

@oddScrC0:	mov m, b
			inr h
			pop b
			mov m, c
			inr h
			mov m, b
@oddScrA0:	mov h, d
			pop b
			mov m, c
			dcr h
			mov m, b
			dcr h
			pop b
			mov m, c
@oddScr80:	mvi h, TEMP_BYTE
			mov m, b
			dcr h
			pop b
			mov m, c
			dcr h
			mov m, b
			dcr l
			dcr e
			jnz @evenScr80
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
			sta @oddScr80+1
			adi $20
			mov d, a
			adi $20
			; counter
			mov e, c

@evenScr80:	pop b
			mov m, c
			inr h
			mov m, b
@evenScrA0: mov h, d
			pop b
			mov m, c
			dcr h
			mov m, b
@evenScrC0:	mov h, a
			pop b
			mov m, c
			dcr h
			mov m, b
			dcr l			
			dcr e
			jz DrawSpriteV_restoreSP

@oddScrC0:	pop b
			mov m, c
			inr h
			mov m, b
@oddScrA0:	mov h, d 
			pop b
			mov m, c
			dcr h
			mov m, b
@oddScr80:	mvi h, TEMP_BYTE
			pop b
			mov m, c
			dcr h
			mov m, b
			dcr	l
			dcr e
			jnz @evenScr80
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
			sta @oddScr80+1
			adi $20
			mov d, a
			adi $20
			; counter
			mov e, c

@evenScr80:	pop b
			mov m, c
@evenScrA0:	mov h, d
			mov m, b
@evenScrC0:	mov h, a
			pop b
			mov m, c
			dcr l
			dcr e
			jz DrawSpriteV_restoreSP
@oddScrC0:	
			mov m, b
@oddScrA0:	mov h, d
			pop b
			mov m, c
@oddScr80:	mvi h, TEMP_BYTE
			mov m, b
			dcr	l
			dcr e
			jnz @evenScr80
			jmp DrawSpriteV_restoreSP

; =============================================
; Draw a dx*15 sprite with offsetX
; dx is 1-3 bytes
; offsetX is 0-1 bytes
; it uses SP to read the sprite data

; in:
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
; $80 screen buff : 1 -> 2
; $a0 screen buff : 4 <- 3
; $c0 screen buff : 6 <- 5
; y--
; $c0 screen buff : 7 -> 8
; $a0 screen buff : 10 <- 9
; $80 screen buff : 12 <- 11
; y--
; repeat art data

DrawSpriteV:
			; store SP
			lxi h, 0			; (12)
			dad	sp				; (12)
			shld DrawSpriteV_restoreSP + 1	; (20)
			; SP = BC
			mov	h, b			; (8)
			mov	l, c			; (8)
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
			jnc DrawSpriteV_noOffsetX
			inr h
DrawSpriteV_noOffsetX:
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
			lxi		sp, TEMP_ADDR	; restore SP (12)
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
@scr80:		pop b
			mov m, c
@scrA0:		mov h, e
			mov m, b
@scrC0:		mov h, a
			pop b
			mov m, c
		.if _moveDown == True
			dcr l
		.endif
.endmacro

.macro DRAW_ODD_LINE_8(_moveDown = true)
@scrC0:	
			mov m, b
@scrA0:		mov h, d
			pop b
			mov m, c
@scr80:		mvi h, TEMP_BYTE
			mov m, b
		.if _moveDown == True
			dcr l
		.endif
.endmacro

.macro DRAW_EVEN_LINE_16(_moveDown = true)
@scr80:		POP B
			MOV M,C
			INR H
			MOV M,B
@scrA0:		MOV H,E
			POP B
			MOV M,C
			DCR H
			MOV M,B
@scrC0:		MOV H,A
			POP B
			MOV M,C
			DCR H
			MOV M,B
		.if _moveDown == true
			DCR	L
		.endif
.endmacro

.macro DRAW_ODD_LINE_16(_moveDown = true)
@scrC0:		POP B
			MOV M,C
			INR H
			MOV M,B
@scrA0:		MOV H,E
			POP B
			MOV M,C
			DCR H
			MOV M,B
@scr80:		MOV H,D
			POP B
			MOV M,C
			DCR H
			MOV M,B
		.if _moveDown == true
			dcr	l
		.endif			
.endmacro

.macro DRAW_EVEN_LINE_24(_moveDown = true)
@scr80:		POP B
			MOV M,C
			INR H
			MOV M,B
			INR H
			POP B
			MOV M,C
@scrA0:		MOV H,E
			MOV M,B
			DCR H
			POP B
			MOV M,C
			DCR H
			MOV M,B
@scrC0:		MOV H,A 
			POP B
			MOV M,C
			DCR H
			MOV M,B
			DCR H
			POP B
			MOV M,C
		.if _moveDown == true
			DCR	L
		.endif
.endmacro

.macro DRAW_ODD_LINE_24(_moveDown = true)
@scrC0:		MOV M,B
			INR H
			POP B
			MOV M,C
			INR H
			MOV M,B
@scrA0:		MOV H,E
			POP B
			MOV M,C
			DCR H
			MOV M,B
			DCR H
			POP B
			MOV M,C
@scr80:		MOV H,D
			MOV M,B
			DCR H
			POP B
			MOV M,C
			DCR H
			MOV M,B
		.if _moveDown == true
			DCR	L
		.endif			
.endmacro