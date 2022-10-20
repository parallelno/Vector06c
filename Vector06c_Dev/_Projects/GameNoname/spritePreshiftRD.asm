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

; duplicate a sprite with mask
; in:
; h - original sprite data addr
; d - dupped sprite data addr
COLOR_BYTE_LEN = 1
MASK_BYTE_COLOR_BYTE_LEN = 2
SPRITE_W16 = 2
SPRITE_W24 = 3
SPRITE_SCR_BUFFS = 3
SPRITE_W16_M_LINE_LEN = MASK_BYTE_COLOR_BYTE_LEN * SPRITE_W16
SPRITE_W24_M_LINE_LEN = MASK_BYTE_COLOR_BYTE_LEN * SPRITE_W24

SPRITE_W16_LINE_LEN = COLOR_BYTE_LEN * SPRITE_W16
SPRITE_W24_LINE_LEN = COLOR_BYTE_LEN * SPRITE_W24

SpriteDup:
			; get source width
			inx_h(3)
			mov a, m
			inx h
			cpi 1
			jz @width16
			; TODO: add dupping for a source = @width24
			; TODO: add dupping for a source = @width8
			ret
@width16:
			xchg
			dcx h
			; get a maskFlag
			; 0 = no mask
			; 1 = a mask
			mov a, m
			lxi b, 3
			dad b
			xchg
			; check a maskFlag		
			ora a
			jz @width16dup

@width16dupWithMask:
			; get target height
			ldax d
			mov b, a
			inx d
			; get target width
			ldax d
			inx d
			cpi 2
			jz @width16To24WithMask
			cpi 1
			jz @width16To16WithMask
			ret
			
			
@width16To24WithMask:
/*
			mvi c, SPRITE_W16_M_LINE_LEN
			mvi a, OPCODE_INX_D
			sta @advanceTargetPtr1+1
			sta @advanceTargetPtr2+1
			sta @advanceTargetPtr3+1		
			jmp @dupLoopM
*/

			; screen buff 0
			SpritesCopyLine(SPRITE_W16_M_LINE_LEN)
			inx_d(2)
			; screen buff 1
			inx_d(2)
			SpritesCopyLine(SPRITE_W16_M_LINE_LEN)
			; screen buff 3
			inx_d(2)
			SpritesCopyLine(SPRITE_W16_M_LINE_LEN)
			dcr b
			jnz @width16To24WithMask
			ret

@width16To16WithMask:
/*
			mvi c, SPRITE_W16_M_LINE_LEN * SPRITE_SCR_BUFFS
			jmp @dupLoop
*/
			; screen buff 0
			SpritesCopyLine(SPRITE_W16_M_LINE_LEN)
			; screen buff 1
			SpritesCopyLine(SPRITE_W16_M_LINE_LEN)
			; screen buff 3
			SpritesCopyLine(SPRITE_W16_M_LINE_LEN)
			dcr b
			jnz @width16To16WithMask
			ret

@width16dup:
			; get target height
			ldax d
			mov b, a
			inx d
			; get target width
			ldax d
			inx d
			cpi 2
			jz @width16To24
			cpi 1
			jz @width16To16
			ret
			
@width16To24:
/*
			mvi c, SPRITE_W16_LINE_LEN
			xra a ; OPCODE_NOP
			sta @advanceTargetPtr1+1
			sta @advanceTargetPtr2+1
			sta @advanceTargetPtr3+1
			jmp @dupLoopM
*/

			; screen buff 0
			SpritesCopyLine(SPRITE_W16_LINE_LEN)
			inx d
			; screen buff 1
			inx d
			SpritesCopyLine(SPRITE_W16_LINE_LEN)
			; screen buff 3
			inx d
			SpritesCopyLine(SPRITE_W16_LINE_LEN)
			dcr b
			jnz @width16To24
			ret

@width16To16:
/*
			mvi c, SPRITE_W16_LINE_LEN * SPRITE_SCR_BUFFS
			jmp @dupLoop			
*/

			; screen buff 0
			SpritesCopyLine(SPRITE_W16_LINE_LEN)
			; screen buff 1
			SpritesCopyLine(SPRITE_W16_LINE_LEN)
			; screen buff 3
			SpritesCopyLine(SPRITE_W16_LINE_LEN)
			dcr b
			jnz @width16To16

/*
@dupLoopM:
			SPRITE_DUP_LINE()
@advanceTargetPtr1:
			inx d
			inx d

@advanceTargetPtr2:
			inx d
			inx d
			SPRITE_DUP_LINE()

@advanceTargetPtr3:
			inx d
			inx d
			SPRITE_DUP_LINE()
			dcr b
			jnz @dupLoopM
			ret			

@dupLoop:
			mov a, m
			stax d
			inx h
			inx d
			dcr c
			jnz @dupLoop

			dcr b
			jnz @dupLoop
			ret						
			.closelabels

.macro SPRITE_DUP_LINE()
			push b
@loop:
			mov a, m
			stax d
			inx h
			inx d
			dcr c
			jnz @loop
			pop b
.endmacro
*/
.macro SpritesCopyLine(count)
		.loop count
			mov a, m
			stax d
			inx h			
			inx d			
		.endloop
.endmacro


; preshift a sprite with mask
; in:
; h - a sprite data addr
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
			jz @WithoutMask

@WithMask:
			; get target height
			mov b, m
			inx h

			; check if it's forward preshift
			xra a
			ora c
			jm @BackwardWithMask

@ForwardWithMask:
			; get target width
			mov a, m
			inx h
			cpi 2
			jz @ForwardWidth24WithMask
			cpi 1
			jz @ForwardWidth16WithMask
			ret
			
@ForwardWidth24WithMask:
			push h
			push b

			; 0 line
			; (1,2)		(3,4)	(5,6)
			; (11,12)	(9,10)	(7,8)
			; (17,18)	(15,16)	(13,14)
			; 1 line
			; (15,16) ...
			
			; preshift mask
@ForwardWidth24WithMaskMaskLoop:
			; 1st scr buffer
			SpritesPreshiftLineM24(true, true, true, MASK_BYTE_COLOR_BYTE_LEN * SPRITE_W24)
			; 2nd scr buffer
			SpritesPreshiftLineM24(true, true, false, MASK_BYTE_COLOR_BYTE_LEN * (SPRITE_W24 + SPRITE_W16) )
			; 3rd scr buffer
			SpritesPreshiftLineM24(true, true, false, MASK_BYTE_COLOR_BYTE_LEN * SPRITE_W24)
			dcr b
			jnz @ForwardWidth24WithMaskMaskLoop

			pop b
			pop h
			push h
			push b			

			; preshift color
			inx h
@ForwardWidth24WithMaskColorLoop:
			; 1st scr buffer
			SpritesPreshiftLineM24(true, false, true, MASK_BYTE_COLOR_BYTE_LEN * SPRITE_W24)
			; 2nd scr buffer
			SpritesPreshiftLineM24(true, false, false, MASK_BYTE_COLOR_BYTE_LEN * (SPRITE_W24 + SPRITE_W16))
			; 3rd scr buffer
			SpritesPreshiftLineM24(true, false, false, MASK_BYTE_COLOR_BYTE_LEN * SPRITE_W24)
			dcr b
			jnz @ForwardWidth24WithMaskColorLoop

			pop b
			pop h

			dcr c
			jnz @ForwardWidth24WithMask
			ret

@ForwardWidth16WithMask:
			; TODO: add a code
			ret	

@BackwardWithMask:  
			; get target width
			mov a, m
			inx h
			cpi 2
			jz @BackwardWidth24WithMask
			cpi 1
			jz @BackwardWidth16WithMask
			ret
			
@BackwardWidth24WithMask:
			push h
			push b

			; 0 line
			; (1,2)		(3,4)	(5,6)
			; (11,12)	(9,10)	(7,8)
			; (17,18)	(15,16)	(13,14)
			; 1 line
			; (15,16) ...
			
			; preshift mask
			; move hl to the last mask byte in the line of the first scr buff
			lxi d, MASK_BYTE_COLOR_BYTE_LEN * SPRITE_W16
			dad d			
@BackwardWidth24WithMaskMaskLoop:
			; 1st scr buffer
			SpritesPreshiftLineM24(false, true, false, MASK_BYTE_COLOR_BYTE_LEN * SPRITE_W24)
			; 2nd scr buffer
			SpritesPreshiftLineM24(false, true, true, MASK_BYTE_COLOR_BYTE_LEN)
			; 3rd scr buffer
			SpritesPreshiftLineM24(false, true, true, MASK_BYTE_COLOR_BYTE_LEN * (SPRITE_W24 + SPRITE_W16))
			dcr b
			jnz @BackwardWidth24WithMaskMaskLoop

			pop b
			pop h
			push h
			push b			

			; preshift color
			; move hl to the last mask byte in the line of the first scr buff
			lxi d, MASK_BYTE_COLOR_BYTE_LEN * SPRITE_W16 + 1
			dad d	
@BackwardWidth24WithMaskColorLoop:
			; 1st scr buffer
			SpritesPreshiftLineM24(false, false, false, MASK_BYTE_COLOR_BYTE_LEN * SPRITE_W24)
			; 2nd scr buffer
			SpritesPreshiftLineM24(false, false, true, MASK_BYTE_COLOR_BYTE_LEN)
			; 3rd scr buffer
			SpritesPreshiftLineM24(false, false, true, MASK_BYTE_COLOR_BYTE_LEN * (SPRITE_W24 + SPRITE_W16))
			dcr b
			jnz @BackwardWidth24WithMaskColorLoop

			pop b
			pop h

			dcr c
			jnz @BackwardWidth24WithMask
			ret

@BackwardWidth16WithMask:
			; TODO: add a code
			ret


@WithoutMask:
			; get target height
			mov b, m
			inx h

			; check if it's forward preshift
			xra a
			ora c
			;jm @BackwardWithoutMask

@ForwardWithoutMask:
			; get target width
			mov a, m
			inx h
			cpi 2
			jz @ForwardWidth24WithoutMask
			cpi 1
			jz @ForwardWidth16WithoutMask
			ret
			
@ForwardWidth24WithoutMask:
			push h
			push b

			; 0 line
			; (1) (2) (3)
			; (6) (5) (4)
			; (9) (8) (7)
			; 1 line
			; (10) ...
			
			; preshift color
@ForwardWidth24WithoutMaskColorLoop:
			; 1st scr buffer
			SpritesPreshiftLine24(true, true, COLOR_BYTE_LEN * SPRITE_W24)
			; 2nd scr buffer
			SpritesPreshiftLine24(true, false, COLOR_BYTE_LEN * (SPRITE_W24 + SPRITE_W16))
			; 3rd scr buffer
			SpritesPreshiftLine24(true, false, COLOR_BYTE_LEN * SPRITE_W24)
			dcr b
			jnz @ForwardWidth24WithoutMaskColorLoop
/*
@temploop0
 		TEMP_PRESHIFT()
 		dcr b
 		jnz @temploop0
*/
			
			pop b
			pop h

			dcr c
			jnz @ForwardWidth24WithoutMask
			ret

@ForwardWidth16WithoutMask:
			; TODO: add a code
			ret	

@BackwardWithoutMask:
			; get target width
			mov a, m
			inx h
			cpi 2
			jz @BackwardWidth24WithoutMask
			cpi 1
			jz @BackwardWidth16WithoutMask
			ret
			
@BackwardWidth24WithoutMask:
			push h
			push b

			; 0 line
			; (1) (2) (3)
			; (6) (5) (4)
			; (9) (8) (7)
			; 1 line
			; (10) ...		

			; preshift color
			inx_h(2)
@BackwardWidth24WithoutMaskColorLoop:
			; 1st scr buffer
			SpritesPreshiftLine24(false, false, COLOR_BYTE_LEN * SPRITE_W24)
			; 2nd scr buffer
			SpritesPreshiftLine24(false, true, COLOR_BYTE_LEN)
			; 3rd scr buffer
			SpritesPreshiftLine24(false, true, COLOR_BYTE_LEN * SPRITE_W24)
			dcr b
			jnz @BackwardWidth24WithoutMaskColorLoop

			pop b
			pop h

			dcr c
			jnz @BackwardWidth24WithoutMask
			ret

@BackwardWidth16WithoutMask:
			; TODO: add a code
			ret			
			.closelabels


.macro SpritesPreshiftLineM24(toRight, mask, forwardByteOrder, nextLineOffset)
		.if mask
			stc
		.endif
		.if mask == false
			xra a
		.endif

			mov a, m
		.if toRight
			rar
		.endif
		.if toRight == false
			ral
		.endif		
			mov m, a
		.if forwardByteOrder
			inx_h(2)
		.endif
		.if forwardByteOrder == false
			dcx_h(2)
		.endif		
			mov a, m
		.if toRight
			rar
		.endif
		.if toRight == false
			ral
		.endif		
			mov m, a
		.if forwardByteOrder
			inx_h(2)
		.endif
		.if forwardByteOrder == false
			dcx_h(2)
		.endif
			mov a, m
		.if toRight
			rar
		.endif
		.if toRight == false
			ral
		.endif		
			mov m, a
			lxi d, nextLineOffset
			dad d
.endmacro

.macro SpritesPreshiftLine24(toRight, forwardByteOrder, nextLineOffset)
			xra a
			mov a, m
		.if toRight
			rar
		.endif
		.if toRight == false
			ral
		.endif		
			mov m, a
		.if forwardByteOrder
			inx h
		.endif
		.if forwardByteOrder == false
			dcx h
		.endif		
			mov a, m
		.if toRight
			rar
		.endif
		.if toRight == false
			ral
		.endif		
			mov m, a
		.if forwardByteOrder
			inx h
		.endif
		.if forwardByteOrder == false
			dcx h
		.endif
			mov a, m
		.if toRight
			rar
		.endif
		.if toRight == false
			ral
		.endif		
			mov m, a
			lxi d, nextLineOffset
			dad d
.endmacro