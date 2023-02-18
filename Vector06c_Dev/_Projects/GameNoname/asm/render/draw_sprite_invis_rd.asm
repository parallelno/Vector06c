; =============================================
; Do not draw a sprite. Just save return scr addr, width, height
; it is used for invinceble status
; it uses sp to read the sprite data
; ex. CALL_RAM_DISK_FUNC(__draw_sprite_invis_vm, __RAM_DISK_S_HERO_ATTACK01 | __RAM_DISK_M_DRAW_SPRITE_INVIS_VM | RAM_DISK_M_8F)
; input:
; bc	sprite data
; de	screen address
; use: a, hl, sp

__RAM_DISK_M_DRAW_SPRITE_INVIS_VM = RAM_DISK_M

__draw_sprite_invis_vm:
			; store SP
			lxi h, 0
			dad sp
			shld drawSpriteRestoreSP_ramDisk__ + 1
			; sp = BC
			mov	h, b
			mov	l, c
			sphl
			xchg
			; b - offset_x
			; c - offset_y
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
			jmp DrawSpriteRet_ramDisk__