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
