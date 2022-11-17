

SPRITE_FORWARD_ORDER = true
SPRITE_BACKWARD_ORDER = false

COLOR_BYTE_LEN = 1
MASK_BYTE_COLOR_BYTE_LEN = 2

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
			sta @preshiftedSprites2+1
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
			; get the source sprite addr. like skeleton_run_r0_0
			mov e, m
			inx h
			mov d, m
			inx h
			xchg
			; add an offset inside the bank to the source sprite addr
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

			push d
			call SpriteToBuff
			pop h

@preshiftedSprites:
			mvi c, TEMP_BYTE
			; decr preshiftedSprites because we do not need 
			; to update the first sprite in a frame
			dcr c
			
			; hl - a ptr to a target sprite addr. like skeleton_run_r0_1
			; advance it to the last preshifted sprite addr (high byte)
			; because we iterate them backwards,
			; because we can preshift only to the left
			mov e, c
			mvi d, 0
			xchg
			dad h
			dad d
			dcx h


@preshiftedSpritesloop:
			; get a target sprite addr to preshift
			mov d, m
			dcx h
			mov e, m
			dcx h
			push b
			push h

			; add an offset inside the bank to the target sprite
@dataOffset1:
			lxi h, TEMP_ADDR
			dad d
			push h
@preshiftedSprites2:
			mvi e, TEMP_BYTE
			call SpriteBuffPreshift ; check target addr and preshift counter
			pop h
			call SpriteFromBuff

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
			
;================================================================
; copy a sprite to a temp buffer (16*24 pxls max. w/wo a mask)
; in:
; hl - an original sprite data addr - 1
SpriteToBuff:
			dcx h
			; get a maskFlag
			; 0 = no mask
			; 1 = a mask
			mov b, m
			inx_h(4)
			; get a height
			mov c, m
			; advance to a width
			inx h
			; check a width
			mov a, m
			inx h
			cpi SPRITE_W16_PACKED
			jz @width16
			cpi SPRITE_W8_PACKED
			jz @width8
			ret

@width8: 	SPRITE_TO_BUFF(8)
@width16:	SPRITE_TO_BUFF(16)

; hl - sprite data addr
; b - 0 = no mask, 1 = mask
; c - height
.macro SPRITE_TO_BUFF(sourceWidth)
			; check a maskFlag
			xra a
			ora b
			jz @WithoutMask
@withMask:
			SPRITE_TO_BUFF_(sourceWidth, True)
@WithoutMask:
			SPRITE_TO_BUFF_(sourceWidth, False)
.endmacro

.macro SPRITE_TO_BUFF_(sourceWidth, withMask)
		.if withMask
			SP_BYTE_LEN = MASK_BYTE_COLOR_BYTE_LEN
		.endif
		.if withMask == false
			SP_BYTE_LEN = COLOR_BYTE_LEN
		.endif

			lxi d, spriteTmpBuff
@loop:
			; screen buff 0
			SPRITE_TO_BUFF_EMPTY_BYTE(withMask)
			SPRITE_TO_BUFF_COPY_LINE(sourceWidth / 8 * SP_BYTE_LEN)
		.if sourceWidth == 8
			SPRITE_TO_BUFF_EMPTY_BYTE(withMask)
		.endif			
			
			; screen buff 1
		.if sourceWidth == 8
			SPRITE_TO_BUFF_EMPTY_BYTE(withMask)
		.endif			
			SPRITE_TO_BUFF_COPY_LINE(sourceWidth / 8 * SP_BYTE_LEN)
			SPRITE_TO_BUFF_EMPTY_BYTE(withMask)
			
			; screen buff 2
		.if sourceWidth == 8
			SPRITE_TO_BUFF_EMPTY_BYTE(withMask)
		.endif			
			SPRITE_TO_BUFF_COPY_LINE(sourceWidth / 8 * SP_BYTE_LEN)
			SPRITE_TO_BUFF_EMPTY_BYTE(withMask)

			dcr c
			jnz @loop
			ret
.endmacro

.macro SPRITE_TO_BUFF_EMPTY_BYTE(withMask)
	.if withMask
			; empty the first mask byte
			mvi a, $ff
			stax d
			inx d
	.endif
			; empty the first color byte
			xra a
			stax d
			inx d
.endmacro

.macro SPRITE_TO_BUFF_COPY_LINE(count)
		.loop count
			mov a, m
			stax d
			inx h
			inx d
		.endloop
.endmacro

;================================================================
; copy a sprite from a temp buffer (24*24 pxls max. w/wo a mask)
; in:
; hl - a target sprite data addr
SpriteFromBuff:
			; get copyFromBuffOffset
			dcx_h(2)
			mov e, m
			inx h
			; get a maskFlag
			; 0 = no mask
			; 1 = a mask
			mov b, m
			inx_h(3)
			; get a height
			mov c, m
			; advance to a width
			inx h
			; check a width
			mov a, m
			inx h
			cpi SPRITE_W24_PACKED
			jz @width24
			cpi SPRITE_W16_PACKED
			jz @width16
			cpi SPRITE_W8_PACKED
			jz @width8
			ret

@width8: 	SPRITE_FROM_BUFF(8)
@width16:	SPRITE_FROM_BUFF(16)
@width24:	; copy buff as it is

			; if there is a mask, 
			; then double the amount of bytes to copy
			xra a
			ora b
			jz @width24NoMask
			mov a, c
			add a
			mov c, a

@width24NoMask:			
			lxi d, spriteTmpBuff
@width24Loop:	
			SPRITE_FROM_BUFF_COPY_LINE(SPRITE_W24 * SPRITE_SCR_BUFFS * COLOR_BYTE_LEN)
			dcr c
			jnz @width24Loop
			ret

; hl - sprite data addr
; b - 0 = no mask, 1 = mask
; c - height
.macro SPRITE_FROM_BUFF(targetWidth)
			; check a maskFlag
			xra a
			ora b
			jz @WithoutMask
@withMask:
			SPRITE_FROM_BUFF_(targetWidth, True)
@WithoutMask:
			SPRITE_FROM_BUFF_(targetWidth, False)
.endmacro

.macro SPRITE_FROM_BUFF_(targetWidth, withMask)
		.if withMask
			SP_BYTE_LEN = MASK_BYTE_COLOR_BYTE_LEN
		.endif
		.if withMask == false
			SP_BYTE_LEN = COLOR_BYTE_LEN
		.endif

			; check copyFromBuffOffset
			xra a
			ora e
			lxi d, spriteTmpBuff
			jz @noOffset

@noOffset8:
			; screen buff 0
			SPRITE_FROM_BUFF_SKIP_BYTE(withMask)			
		.if targetWidth == 8
			SPRITE_FROM_BUFF_SKIP_BYTE(withMask)
		.endif
			SPRITE_FROM_BUFF_COPY_LINE(targetWidth / 8 * SP_BYTE_LEN)

			; screen buff 1			
			SPRITE_FROM_BUFF_COPY_LINE(targetWidth / 8 * SP_BYTE_LEN)
		.if targetWidth == 8
			SPRITE_FROM_BUFF_SKIP_BYTE(withMask)
		.endif
			SPRITE_FROM_BUFF_SKIP_BYTE(withMask)		
			
			; screen buff 2			
			SPRITE_FROM_BUFF_COPY_LINE(targetWidth / 8 * SP_BYTE_LEN)
		.if targetWidth == 8
			SPRITE_FROM_BUFF_SKIP_BYTE(withMask)
		.endif
			SPRITE_FROM_BUFF_SKIP_BYTE(withMask)		

			dcr c
			jnz @noOffset8
			ret

@noOffset:
			; screen buff 0
		.if targetWidth == 8
			SPRITE_FROM_BUFF_SKIP_BYTE(withMask)
		.endif
			SPRITE_FROM_BUFF_COPY_LINE(targetWidth / 8 * SP_BYTE_LEN)
			SPRITE_FROM_BUFF_SKIP_BYTE(withMask)

			; screen buff 1
			SPRITE_FROM_BUFF_SKIP_BYTE(withMask)			
			SPRITE_FROM_BUFF_COPY_LINE(targetWidth / 8 * SP_BYTE_LEN)
		.if targetWidth == 8
			SPRITE_FROM_BUFF_SKIP_BYTE(withMask)
		.endif

			; screen buff 2
			SPRITE_FROM_BUFF_SKIP_BYTE(withMask)			
			SPRITE_FROM_BUFF_COPY_LINE(targetWidth / 8 * SP_BYTE_LEN)
		.if targetWidth == 8
			SPRITE_FROM_BUFF_SKIP_BYTE(withMask)
		.endif

			dcr c
			jnz @noOffset
			ret
.endmacro

.macro SPRITE_FROM_BUFF_SKIP_BYTE(withMask)
			inx d
		.if withMask
			inx d
		.endif
.endmacro

.macro SPRITE_FROM_BUFF_COPY_LINE(count)
		.loop count
			ldax d
			mov m, a
			inx h
			inx d
		.endloop
.endmacro

;================================================================
; preshift a temp buffer
; in:
; hl - a target sprite data addr
; e - preshiftedsprites. 
;	8 - shift by 1 pxl
;	4 - shift by 2 pxls
SpriteBuffPreshift:
			; get a preshift
			dcx_h(2)
			mov b, m
			; get a maskFlag
			inx h
			mov a, m
			; get a height
			inx_h(3)
			mov c, m
			; advance to gfx data
			inx_h(2)
			; check a maskFlag
			ora a
			lxi h, spriteTmpBuff
			jz @color

@colorMask:
			; check preshift
			mvi a, 4
			cmp e
			jz @colorMask2pxls

@colorMask1pxl:
			; scr buff 0
			SPRITE_BUFF_PRESHIFT_LINE_W_MASK(1, SPRITE_FORWARD_ORDER, true)
			SPRITE_BUFF_PRESHIFT_LINE_W_MASK(1, SPRITE_FORWARD_ORDER, false)
			; scr buff 1
			SPRITE_BUFF_PRESHIFT_LINE_W_MASK(1, SPRITE_BACKWARD_ORDER, true)
			SPRITE_BUFF_PRESHIFT_LINE_W_MASK(1, SPRITE_BACKWARD_ORDER, false)
			; scr buff 2
			SPRITE_BUFF_PRESHIFT_LINE_W_MASK(1, SPRITE_BACKWARD_ORDER, true)
			SPRITE_BUFF_PRESHIFT_LINE_W_MASK(1, SPRITE_BACKWARD_ORDER, false)
			dcr c
			jnz @colorMask1pxl
			ret

@colorMask2pxls:
			; scr buff 0
			SPRITE_BUFF_PRESHIFT_LINE_W_MASK(2, SPRITE_FORWARD_ORDER, true)
			SPRITE_BUFF_PRESHIFT_LINE_W_MASK(2, SPRITE_FORWARD_ORDER, false)
			; scr buff 1
			SPRITE_BUFF_PRESHIFT_LINE_W_MASK(2, SPRITE_BACKWARD_ORDER, true)
			SPRITE_BUFF_PRESHIFT_LINE_W_MASK(2, SPRITE_BACKWARD_ORDER, false)
			; scr buff 2
			SPRITE_BUFF_PRESHIFT_LINE_W_MASK(2, SPRITE_BACKWARD_ORDER, true)
			SPRITE_BUFF_PRESHIFT_LINE_W_MASK(2, SPRITE_BACKWARD_ORDER, false)
			dcr c
			jnz @colorMask2pxls
			ret

@color:
			; check preshift
			mvi a, 4
			cmp e
			jz @color2pxls

@color1pxl:
			; scr buff 0
			SPRITE_BUFF_PRESHIFT_LINE(1, SPRITE_FORWARD_ORDER)
			; scr buff 1
			SPRITE_BUFF_PRESHIFT_LINE(1, SPRITE_BACKWARD_ORDER)
			; scr buff 2
			SPRITE_BUFF_PRESHIFT_LINE(1, SPRITE_BACKWARD_ORDER)
			dcr c
			jnz @color1pxl
			ret

@color2pxls:
			; scr buff 0
			SPRITE_BUFF_PRESHIFT_LINE(2, SPRITE_FORWARD_ORDER)
			; scr buff 1
			SPRITE_BUFF_PRESHIFT_LINE(2, SPRITE_BACKWARD_ORDER)
			; scr buff 2
			SPRITE_BUFF_PRESHIFT_LINE(2, SPRITE_BACKWARD_ORDER)
			dcr c
			jnz @color2pxls
			ret			

.macro SPRITE_BUFF_PRESHIFT_LINE(count, order)
			; load a line
		.if order == SPRITE_FORWARD_ORDER
			mov a, m
			inx h
			mov d, m
			inx h
			mov e, m
		.endif
		.if order == SPRITE_BACKWARD_ORDER
			mov e, m
			inx h
			mov d, m
			inx h
			mov a, m
		.endif

		.loop count
			; shift
			xchg
			dad h
			ral
			xchg
		.endloop

			; save 
		.if order == SPRITE_FORWARD_ORDER
			mov m, e
			dcx h
			mov m, d
			dcx h
			mov m, a
		.endif
		.if order == SPRITE_BACKWARD_ORDER
			mov m, a
			dcx h
			mov m, d
			dcx h
			mov m, e
		.endif
		; advance to the next line
		lxi d, SPRITE_W24 * COLOR_BYTE_LEN
		dad d
.endmacro

.macro SPRITE_BUFF_PRESHIFT_LINE_W_MASK(count, order, mask)
			; load a line of mask bytes
		.if order == SPRITE_FORWARD_ORDER
			mov a, m
			inx_h(2)
			mov d, m
			inx_h(2)
			mov e, m
		.endif
		.if order == SPRITE_BACKWARD_ORDER
			mov e, m
			inx_h(2)
			mov d, m
			inx_h(2)
			mov a, m
		.endif

		.loop count
			; shift
			xchg
			dad h
		.if mask
			inr l ; fill up the rightest bit of mask to 1
		.endif
			ral
			xchg
		.endloop

			; save bytes
		.if order == SPRITE_FORWARD_ORDER
			mov m, e
			dcx_h(2)
			mov m, d
			dcx_h(2)
			mov m, a
		.endif
		.if order == SPRITE_BACKWARD_ORDER
			mov m, a
			dcx_h(2)
			mov m, d
			dcx_h(2)
			mov m, e
		.endif

	.if mask
		inx h
	.endif
	.if mask == false
		; advance to the next line
		lxi d, SPRITE_W24 * MASK_BYTE_COLOR_BYTE_LEN - 1
		dad d
	.endif
.endmacro

spriteTmpBuff:
			.storage SPRITE_W16 * MASK_BYTE_COLOR_BYTE_LEN * SPRITE_SCR_BUFFS * SPRITE_PRESHIFT_H_MAX

__spriteduppreshiftEnd: