;.include "drawSprite.asm"
.include "drawSpriteV.asm"

; hl - animation addr, for example hero_idle_r
; c - idx in the animation
; return: 
; bc - sprite addr
; a - width marker. 0 - means a sprite width is 2 bytes , != 0 means 3 bytes
GetSpriteAddr:
            mov a, c
			mvi b, 0
			dad b
			mov c, m
			inx h
			mov b, m
			ret

; this's a special version of GetSpriteAddr for a vertical movement
; hl - animation addr, for example hero_idle_r
; c - idx in the animation
; e - pos Y
; return: 
; bc - sprire addr
; a - width marker. 0 - means a sprite width is 2 bytes , != 0 means 3 bytes
GetSpriteAddrRunV:
			mov a, e
			ani	%0000011
			rlc_(3)
			add c
			mov c, a
			mvi b, 0
			dad b
			mov c, m
			inx h
			mov b, m
			ani %110
			ret

; hl - addr to posX+1 (high byte in 16-bit pos)
; return:
; de - sprite screen addr
; c - idx in the animaion
; uses: a
GetSpriteScrAddr:
			; convert XY to screen addr + frame idx
			mov		a, m
			; extract the anim frame idx
			ani		%0000110
			mov 	c, a
			; extract the hero X screen addr
			mov		a, m
			rrc_(3)
			ani		%00011111
			adi		SPRITE_X_SCR_ADDR
			inx h
			inx h
			; copying posY
			mov e, m
			mov	d, a
			ret

; clear a N*15 pxs square on the screen, 
; where: 
; N = 16 pxs if a = 0
; N = 24 pxs if a != 0
; input:
; hl - scr addr
; a - width marker
; uses:
; bc, de
		
CleanSprite:
			ora a
			mvi c, 2
			mvi b, 0
			
			jz @init
			inr c
@init:		
			mov a, l
			sta @restoreY+1
			mov d, h
			mvi e, $20
		
@loop:
			CleanSpriteVLine(15)
@restoreY
			mvi l, TEMP_BYTE
			mov a, e
			add h
			mov h, a
			jnc @loop
			inr d
			mov h, d
			dcr c
			jnz @loop
			ret
			.closelabels

.macro CleanSpriteVLine(_dy)
		.loop _dy-1
			mov m, b
			dcr l
		.endloop
			mov m, b
.endmacro			