.include "drawSprite2.asm"

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

; hl - addr to posX+1
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