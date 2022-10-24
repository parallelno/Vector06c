; TODO: calculate mirrored sprites.

; Calculate preshifted sprites
; in:
; de - preshifted_sprites addr
; hl - sprite data offset in the ram-disk
; used:
; de, bc, a
__SpriteDupPreshift:
			shld @dataOffset0+1
			shld @dataOffset1+1
			
			xchg
			mov a, m
			sta @preshiftedSprites+1
			inx h
@getAnimAddr:
			; get anim addr
			mov e, m
			inx h
			mov d, m
			inx h

			; return if an anim addr = 0
			mov a, d
			ora e
			rz

			; store an anim addr
			push h

			xchg
			; get the next anim frame addr offset
@getNextFrameOffset:
			mov e, m
			inx h
			mov d, m
			mov a, d
			sta @checkLastFrame+1
			push h
			dad d
			shld @nextFrameAddr+1
			pop h
			inx h
			; get the source sprite. like skeleton_run_r0_0
			mov e, m
			inx h
			mov d, m
			inx h
			xchg
			; add an offset inside the bank to the source sprite
@dataOffset0:
			lxi b, TEMP_ADDR
			dad b
			; check if a frame is already preshifted
			dcx h
			mov a, m
			ora a
			jz @nextFrameAddr
			; mark a first sprite of this frame being preshifted
			dcr m
			inx h

			shld @sourceSpriteAddr+1
			xchg

@preshiftedSprites:
			mvi c, TEMP_BYTE
@preshiftedSpritesloop:
			; get a target sprite addr that needs to be preshifted
			mov e, m
			inx h
			mov d, m
			inx h
			push b			
			push h
			; add an offset inside the bank to the target sprite
@dataOffset1:
			lxi h, TEMP_ADDR
			dad d
			shld @preshiftSprite+1
			xchg
@sourceSpriteAddr:			
			lxi h, TEMP_ADDR
			call SpriteDup

@preshiftSprite:
			lxi h, TEMP_ADDR
			call SpritePreshift

			pop h
			pop b
			dcr c
			jnz @preshiftedSpritesloop

@nextFrameAddr: 
			lxi h, TEMP_ADDR
@checkLastFrame:
			mvi a, TEMP_BYTE
			ora a
			jz @getNextFrameOffset

			pop h
			jmp @getAnimAddr

			ret

;================================================================
; duplicate a sprite
; in:
; h - original sprite data addr
; d - dupped sprite data addr
COLOR_BYTE_LEN = 1
MASK_BYTE_COLOR_BYTE_LEN = 2

SpriteDup:
			; get source width
			inx_h(3)
			mov a, m
			inx h
			cpi 1
			jz @width16
			cpi 0
			jz @width8
			ret

@width8: 	DUP_SPRITE(8)
@width16:	DUP_SPRITE(16)

.macro DUP_SPRITE(width)
			xchg
			dcx h
			; get a maskFlag
			; 0 = no mask
			; 1 = a mask
			mov a, m
			inx_h(3)
			xchg
			; check a maskFlag		
			ora a
			jz @WithoutMask
@withMask:
			DUP_SPRITE_(width, True)
@WithoutMask:
			DUP_SPRITE_(width, False)
.endmacro

.macro DUP_SPRITE_(width, withMask)
		.if withMask
			SP_BYTE_LEN = MASK_BYTE_COLOR_BYTE_LEN
		.endif
		.if withMask == false
			SP_BYTE_LEN = COLOR_BYTE_LEN
		.endif

			; get a target height
			ldax d
			mov b, a
			inx d
			; get a target width
			ldax d
			inx d
			cpi width/8
			jz @widthOriginalToExtended ; Extended means 8 pxls wider
			cpi width/8 - 1
			jz @widthOriginalToOriginal
			ret
			
@widthOriginalToExtended:
			; screen buff 0
			SpritesCopyLine(width / 8 * SP_BYTE_LEN)
			inx d
		.if withMask
			inx d
		.endif
			; screen buff 1
			inx d
		.if withMask
			inx d
		.endif
			SpritesCopyLine(width / 8 * SP_BYTE_LEN)
			; screen buff 2
			inx d
		.if withMask
			inx d
		.endif
			SpritesCopyLine(width / 8 * SP_BYTE_LEN)
			dcr b
			jnz @widthOriginalToExtended
			ret

@widthOriginalToOriginal:
			; screen buff 0
			SpritesCopyLine(width / 8 * SP_BYTE_LEN)
			; screen buff 1
			SpritesCopyLine(width / 8 * SP_BYTE_LEN)
			; screen buff 2
			SpritesCopyLine(width / 8 * SP_BYTE_LEN)
			dcr b
			jnz @widthOriginalToOriginal
			ret
.endmacro

.macro SpritesCopyLine(count)
		.loop count
			mov a, m
			stax d
			inx h			
			inx d			
		.endloop
.endmacro

;================================================================
; preshift a sprite with mask
; in:
; h - a sprite data addr
SPRITE_W16 = 2
SPRITE_W24 = 3
SPRITE_PRESHIFT_RIGHT = true
SPRITE_PRESHIFT_LEFT = false
SPRITE_FORWARD_ORDER = true
SPRITE_BACKWARD_ORDER = false
SPRITE_COLOR = false
SPRITE_MASK = true

SpritePreshift:
			dcx_h(2)
			; get preshift
			mov c, m
			inx h

			; get a maskFlag
			; 0 = no mask
			; 1 = a mask
			mov a, m
			lxi d, 3
			dad d
			; check a maskFlag
			ora a
			jz @withoutMask
@withMask:	
			SPRITE_PRESHIFT(true)
@WithoutMask:
			SPRITE_PRESHIFT(false)
			.closelabels

.macro SPRITE_PRESHIFT(withMask)
			; get target height
			mov b, m
			inx h

			; check if preshift is to right
			xra a
			ora c
			jm @left

@right:
			; get target width
			mov a, m
			inx h
			cpi SPRITE_W24 - 1
			jz @right24
			cpi SPRITE_W16 - 1
			jz @right16
			ret

@left:
			; get target width
			mov a, m
			inx h
			cpi SPRITE_W24 - 1
			jz @left24
			cpi SPRITE_W16 - 1
			jz @left16
			ret

@right24:	SPRITE_PRESHIFT_(24, SPRITE_PRESHIFT_RIGHT, withMask)
@right16:	SPRITE_PRESHIFT_(16, SPRITE_PRESHIFT_RIGHT, withMask)
@left24:	SPRITE_PRESHIFT_(24, SPRITE_PRESHIFT_LEFT, withMask)
@left16:	SPRITE_PRESHIFT_(16, SPRITE_PRESHIFT_LEFT, withMask)

.endmacro

.macro SPRITE_PRESHIFT_(width, dir, withMask)
			; an example of a byte order for a 24 width sprite
			; with a mask
			; 0 line
			; (1,2)		(3,4)	(5,6)
			; (11,12)	(9,10)	(7,8)
			; (17,18)	(15,16)	(13,14)
			; 1 line
			; (15,16) ...

			; without a mask
			; 0 line
			; (1) (2) (3)
			; (6) (5) (4)
			; (9) (8) (7)
			; 1 line
			; (10) ...		

		.if withMask
			SP_BYTE_LEN = MASK_BYTE_COLOR_BYTE_LEN
		.endif
		.if withMask == false
			SP_BYTE_LEN = COLOR_BYTE_LEN
		.endif
		
		.if dir == SPRITE_PRESHIFT_LEFT
			; move hl to the last byte in the line
			lxi d, SP_BYTE_LEN * (width/8 - 1)
			dad d
		.endif		

		.if dir == SPRITE_PRESHIFT_RIGHT
			NEXT_LINE_OFFSET_SCR1 = SP_BYTE_LEN * width/8
			NEXT_LINE_OFFSET_SCR2 = SP_BYTE_LEN * (width/8*2 - 1)
			NEXT_LINE_OFFSET_SCR3 = SP_BYTE_LEN * width/8
			SPRITE_FORWARD_LINE = SPRITE_FORWARD_ORDER
			SPRITE_BACKWARD_LINE = SPRITE_BACKWARD_ORDER
		.endif
		.if dir == SPRITE_PRESHIFT_LEFT
			NEXT_LINE_OFFSET_SCR1 = SP_BYTE_LEN * width/8
			NEXT_LINE_OFFSET_SCR2 = SP_BYTE_LEN * 1
			NEXT_LINE_OFFSET_SCR3 = SP_BYTE_LEN * width/8
			SPRITE_FORWARD_LINE = SPRITE_BACKWARD_ORDER
			SPRITE_BACKWARD_LINE = SPRITE_FORWARD_ORDER			
		.endif
@loop:
		.if withMask
			; preshift mask
			push h
			push b
@maskLoop:
			; 1st scr buffer
			SPRITE_PRESHIFT_LINE(width, dir, withMask, SPRITE_MASK, SPRITE_FORWARD_LINE, NEXT_LINE_OFFSET_SCR1)
			; 2nd scr buffer
			SPRITE_PRESHIFT_LINE(width, dir, withMask, SPRITE_MASK, SPRITE_BACKWARD_LINE, NEXT_LINE_OFFSET_SCR2)
			; 3rd scr buffer
			SPRITE_PRESHIFT_LINE(width, dir, withMask, SPRITE_MASK, SPRITE_BACKWARD_LINE, NEXT_LINE_OFFSET_SCR3)
			dcr b
			jnz @maskLoop
			pop b
			pop h
		.endif

			; preshift color
			push h
			push b			
		.if withMask
			inx h
		.endif
@colorLoop:
			; 1st scr buffer
			SPRITE_PRESHIFT_LINE(width, dir, withMask, SPRITE_COLOR, SPRITE_FORWARD_LINE, NEXT_LINE_OFFSET_SCR1)
			; 2nd scr buffer
			SPRITE_PRESHIFT_LINE(width, dir, withMask, SPRITE_COLOR, SPRITE_BACKWARD_LINE, NEXT_LINE_OFFSET_SCR2)
			; 3rd scr buffer
			SPRITE_PRESHIFT_LINE(width, dir, withMask, SPRITE_COLOR, SPRITE_BACKWARD_LINE, NEXT_LINE_OFFSET_SCR3)
			dcr b
			jnz @colorLoop
			pop b
			pop h
		.if dir == SPRITE_PRESHIFT_RIGHT
			dcr c
		.endif
		.if dir == SPRITE_PRESHIFT_LEFT
			inr c
		.endif		
			jnz @loop
			ret
.endmacro

.macro SPRITE_PRESHIFT_ADVANCE(byteOrder, withMask)
	.if byteOrder == SPRITE_FORWARD_ORDER
			inx h
		.if withMask
			inx h
		.endif
	.endif
	.if byteOrder == SPRITE_BACKWARD_ORDER
			dcx h
		.if withMask
			dcx h
		.endif
	.endif
.endmacro

.macro SPRITE_PRESHIFT_ROTATE_BYTE(dir)
		.if dir == SPRITE_PRESHIFT_RIGHT
			rar
		.endif
		.if dir == SPRITE_PRESHIFT_LEFT
			ral
		.endif
.endmacro

.macro SPRITE_PRESHIFT_LINE(width, dir, withMask, mask, byteOrder, nextLineOffset)
			LOOP_COUNTER .var 0
		.if mask
			stc
		.endif
		.if mask == false
			xra a
		.endif
	.loop width/8
			mov a, m
			SPRITE_PRESHIFT_ROTATE_BYTE(dir)
			mov m, a
			
			LOOP_COUNTER = LOOP_COUNTER + 1
		.if LOOP_COUNTER < width/8
			SPRITE_PRESHIFT_ADVANCE(byteOrder, withMask)
		.endif
	.endloop

			lxi d, nextLineOffset
			dad d
.endmacro