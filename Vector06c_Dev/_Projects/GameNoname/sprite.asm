; get a sprite data addr
; input:
; hl - animation addr ptr
; c - preshifted sprite idx*2 offset based on posX then +2
; return:
; bc - sprite addr
GetSpriteAddr:
			mvi b, 0
			dad b
			mov c, m
			inx h
			mov b, m
			ret
			.closelabels

; input:
; hl - addr to posX+1 (high byte in 16-bit pos)
; return:
; de - sprite screen addr
; c - preshifted sprite idx*2 offset based on posX then +2
; hl+2
; use: a
GetSpriteScrAddr8:
			; extract the hero X screen addr
			mov	a, m
			ani PRESHIFTED_SPRITES_8 - 1
			rlc
			adi 2 ; because there are two bytes of nextFrameOffset in front of sprite ptrs
			mov	c, a
			mov	a, m
			rrc_(3)
			ani		%00011111
			adi		SPRITE_X_SCR_ADDR
			inx h
			inx h
			; copying posY
			mov e, m
			mov	d, a
			ret
			.closelabels
GetSpriteScrAddr4:
			; extract the hero X screen addr
			mov	a, m
			ani (PRESHIFTED_SPRITES_4 - 1) * 2
			adi 2 ; because there are two bytes of nextFrameOffset in front of sprite ptrs
			mov	c, a
			mov	a, m
			rrc_(3)
			ani		%00011111
			adi		SPRITE_X_SCR_ADDR
			inx h
			inx h
			; copying posY
			mov e, m
			mov	d, a
			ret
			.closelabels

; copy a sprite from the back buff to the screen
; in:
; de - scr addr
; h - width
;		00 - 8pxs,
;		01 - 16pxs,
;		10 - 24pxs,
;		11 - 32pxs
; l - height
CopySpriteToScrV:
			; adjust initial Y
			inr e

			; set up a copy routine
			mov a, l
			rlc
			mov c, a
			mov a, h
			mvi b, 0

			; store sp
			lxi h, 0
			dad	sp
			shld RestoreSP + 1

			; continue setting up a copy routine
			lxi h, @copyRoutineAddrs-8
			dad b
			mov b, m
			inx h
			mov h, m
			mov l, b
			pchl

@h04:
@h05:		COPY_SPRITE_TO_SCR(5)
@h06:		COPY_SPRITE_TO_SCR(6)
@h07:		COPY_SPRITE_TO_SCR(7)
@h08:		COPY_SPRITE_TO_SCR(8)
@h09:
@h10:
@h11:
@h12:
@h13:		COPY_SPRITE_TO_SCR(13)
@h14:		COPY_SPRITE_TO_SCR(14)
@h15:		COPY_SPRITE_TO_SCR(15)
@h16:		COPY_SPRITE_TO_SCR(16)
@h17:		COPY_SPRITE_TO_SCR(17)
@h18:		COPY_SPRITE_TO_SCR(18)
@h19:		COPY_SPRITE_TO_SCR(19)
@h20:		COPY_SPRITE_TO_SCR(20)

@copyRoutineAddrs:
			.word @h04
			.word @h05
			.word @h06
			.word @h07
			.word @h08
			.word @h09
			.word @h10
			.word @h11
			.word @h12
			.word @h13
			.word @h14
			.word @h15
			.word @h16
			.word @h17
			.word @h18
			.word @h19
			.word @h20
			.word @h20
			.word @h20
			.word @h20

.macro COPY_SPRITE_TO_SCR_PB(moveUp = true)
			pop b
			mov m, c
			inr l
			mov m, b
		.if moveUp == true
			inr l
		.endif
.endmacro
.macro COPY_SPRITE_TO_SCR_B()
			pop b
			mov m, c
.endmacro
.macro COPY_SPRITE_TO_SCR(height)
			xchg
			mov d, a
nextColumn:
			RAM_DISK_ON(RAM_DISK_S2 | RAM_DISK_M2 | RAM_DISK_M_8F)
			; read without a stack operations because
			; we need fill up BC prior to use POP B
			mov b, m
			dcr l
			mov c, m
			RAM_DISK_ON(RAM_DISK_S2)
			mov m, c
			inr l
			mov m, b
			inr l
			sphl

			heightOdd = (height / 2)*2 != height
	.if heightOdd
		.loop height / 2 - 1
			COPY_SPRITE_TO_SCR_PB()
		.endloop
			COPY_SPRITE_TO_SCR_B()
	.endif
	.if heightOdd == false
		.loop height / 2 - 2
			COPY_SPRITE_TO_SCR_PB()
		.endloop
			COPY_SPRITE_TO_SCR_PB(false)
	.endif

			; assign SP to prevent screen data corruption
			; when we use mov b, m and mov c, m commands.
			; a corruption might happen because we fill up B and C with
			; more than one command
			lxi sp, STACK_INTERRUPTION_ADDR
			; advance Y down and to the next scr buff
			lxi b, $2000-height+2
			dad b
			jnc nextColumn
			; advance Y to the next column
			mvi a, -$20*3+1
			add h
			mov h, a
			dcr d
			jp nextColumn
			jmp RestoreSP
.endmacro
			.closelabels

; TODO: calculate mirrored sprites.

; Calculate preshifted sprites
; in:
; hl - preshifted_sprites addr
; used:
; de, bc, a
SpriteDupPreshift:
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
			lxi b, $8000
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
			lxi h, $8000
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
			; screen buff 0
			SpritesCopyLine(SPRITE_W16_M_LINE_LEN)
			; screen buff 1
			SpritesCopyLine(SPRITE_W16_M_LINE_LEN)
			; screen buff 3
			SpritesCopyLine(SPRITE_W16_M_LINE_LEN)
			dcr b
			jnz @width16To16WithMask


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
			; screen buff 0
			SpritesCopyLine(SPRITE_W16_LINE_LEN)
			;mvi a, $0
			;stax d

			inx d
			; screen buff 1
			;mvi a, $0
			;stax d

			inx d
			SpritesCopyLine(SPRITE_W16_LINE_LEN)
			; screen buff 3
			;mvi a, $0
			;stax d

			inx d
			SpritesCopyLine(SPRITE_W16_LINE_LEN)

			dcr b
			jnz @width16To24
			ret

@width16To16:
			; screen buff 0
			SpritesCopyLine(SPRITE_W16_LINE_LEN)
			; screen buff 1
			SpritesCopyLine(SPRITE_W16_LINE_LEN)
			; screen buff 3
			SpritesCopyLine(SPRITE_W16_LINE_LEN)
			dcr b
			jnz @width16To16
			.closelabels

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