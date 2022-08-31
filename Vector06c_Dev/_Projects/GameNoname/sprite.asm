.include "drawSprite.asm"

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

; this's a special version of GetSpriteAddr for a vertical & horizontal movement.
; input:
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

; in:
; hl - addr to posX+1 (high byte in 16-bit pos)
; return:
; de - sprite screen addr
; c - idx in the animaion
; use: a
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
; it clears 3 screen buffers from hl addr and further
; where: 
; 16 pxs width if a = 0
; 24 pxs width if a != 0
; input:
; hl - scr addr
; a - width marker
; use:
; bc, de

CleanSprite:
			mvi c, 2
			mvi b, 0
			
			ora a
			jz @width16
			inr c
@width16:		
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


; clear a N*16 pxs square on the screen, 
; it uses PUSH!
; it clears 3 screen buffers from hl addr and further

; input:
; de - scr addr
; a - flag
;		flag=0, 16 pxs width
;		flag!=0, 24 pxs width

; use:
; bc, hl, sp

CleanSpriteSP:
			di
			lxi h, 0
			dad sp
			shld @restoreSP+1

			xchg
			; to prevent clearing below the sprite
			inr l
			inr l

			lxi b, 0
			lxi d, $2000

			; replaced with OPCODE_NOP if with == 24
			; replaced with OPCODE_NOP if with == 24
			ora a
			jz @width16
@width8:
			sphl
			PUSH_B(8)
			dad d
			sphl
			PUSH_B(8)
			dad d
			sphl
			PUSH_B(8)

			mov a, h
			sui $20*2-1
			mov h, a
@width16:
			sphl
			PUSH_B(8)
			dad d
			sphl
			PUSH_B(8)
			dad d
			sphl
			PUSH_B(8)

			mov a, h
			sui $20*2-1
			mov h, a			
@width24:
			sphl
			PUSH_B(8)
			dad d
			sphl
			PUSH_B(8)
			dad d
			sphl
			PUSH_B(8)
@restoreSP:
			lxi sp, TEMP_ADDR
			ei
			ret
			.closelabels
