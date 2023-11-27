PRESHIFT_MIN = 4 ; means 4 preshifted sprites, one preshifted sprite for every two pixels.

SPRITE_FORWARD_ORDER = true
SPRITE_BACKWARD_ORDER = false

COLOR_BYTE_LEN = 1
MASK_BYTE_COLOR_BYTE_LEN = 2

; TODO: calculate mirrored sprites.

; Calculate preshifted sprites
; a preshifting is done with 3 steps
; 1: copy to __sprite_tmp_buff buffer. sprites W=8 ocuppy the middle column, W16 sprites take second and the last third column
; 2: shift the sprite in the __sprite_tmp_buff buffer from the right to left starting from the last in the preshifting line
; 3: copy preshifted sprites back
; in:
; de - ptr to preshifted_sprites addr
; hl - sprite data offset in the ram-disk
; used:
; de, bc, a
__sprite_dup_preshift:
			shld @data_offset0+1
			shld @data_offset1+1

			xchg
			mov a, m
			cpi PRESHIFT_MIN
			rc ; return if preshifted_sprites is below 4
			sta @preshifted_sprites+1
			sta @preshifted_sprites2+1
			inx h
@get_anim_addr:
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
@get_next_frame_offset:
			mov e, m
			inx h
			mov d, m
			mov a, d
			sta @check_last_frame+1
			push h
			dad d
			shld @next_frame_addr+1
			pop h
			inx h
			; get the source sprite addr. like skeleton_run_r0_0
			mov e, m
			inx h
			mov d, m
			inx h
			xchg
			; add an offset inside the bank to the source sprite addr
@data_offset0:
			lxi b, TEMP_ADDR
			dad b
			; check if a frame is already preshifted
			dcx h
			mov a, m
			CPI_WITH_ZERO(0)
			jz @next_frame_addr
			; mark a first sprite of this frame being preshifted
			dcr m

			push d
			call sprite_to_buff
			pop h

@preshifted_sprites:
			mvi c, TEMP_BYTE
			; decr preshifted_sprites because we do not need 
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


@preshifted_sprites_loop:
			; get a target sprite addr to preshift
			mov d, m
			dcx h
			mov e, m
			dcx h
			push b
			push h

			; add an offset inside the bank to the target sprite
@data_offset1:
			lxi h, TEMP_ADDR
			dad d
			push h
@preshifted_sprites2:
			mvi e, TEMP_BYTE
			call sprite_buff_preshift ; check target addr and preshift counter
			pop h
			call sprite_from_buff

			pop h
			pop b
			dcr c
			jnz @preshifted_sprites_loop

@next_frame_addr:
			lxi h, TEMP_ADDR
@check_last_frame:
			mvi a, TEMP_BYTE
			CPI_WITH_ZERO(0)
			jz @get_next_frame_offset

			pop h
			jmp @get_anim_addr
			
;================================================================
; copy a sprite to a temp buffer (16*24 pxls max. w/wo a mask)
; in:
; hl - an original sprite data addr - 1
sprite_to_buff:
			dcx h
			; get a mask_flag
			; 0 = no mask
			; 1 = a mask
			mov b, m
			INX_H(4)
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
.macro SPRITE_TO_BUFF(source_width)
			; check a mask_flag
			A_TO_ZERO(NULL_BYTE)
			ora b
			jz @without_mask
@with_mask:
			SPRITE_TO_BUFF_(source_width, True)
@without_mask:
			SPRITE_TO_BUFF_(source_width, False)
.endmacro

.macro SPRITE_TO_BUFF_(source_width, with_mask)
		.if with_mask
			SP_BYTE_LEN = MASK_BYTE_COLOR_BYTE_LEN
		.endif
		.if with_mask == false
			SP_BYTE_LEN = COLOR_BYTE_LEN
		.endif

			lxi d, __sprite_tmp_buff
@loop:
			; screen buff 0
			SPRITE_TO_BUFF_EMPTY_BYTE(with_mask)
			SPRITE_TO_BUFF_COPY_LINE(source_width / 8 * SP_BYTE_LEN)
		.if source_width == 8
			SPRITE_TO_BUFF_EMPTY_BYTE(with_mask)
		.endif			
			
			; screen buff 1
		.if source_width == 8
			SPRITE_TO_BUFF_EMPTY_BYTE(with_mask)
		.endif			
			SPRITE_TO_BUFF_COPY_LINE(source_width / 8 * SP_BYTE_LEN)
			SPRITE_TO_BUFF_EMPTY_BYTE(with_mask)
			
			; screen buff 2
		.if source_width == 8
			SPRITE_TO_BUFF_EMPTY_BYTE(with_mask)
		.endif			
			SPRITE_TO_BUFF_COPY_LINE(source_width / 8 * SP_BYTE_LEN)
			SPRITE_TO_BUFF_EMPTY_BYTE(with_mask)

			dcr c
			jnz @loop
			ret
.endmacro

.macro SPRITE_TO_BUFF_EMPTY_BYTE(with_mask)
	.if with_mask
			; empty the first mask byte
			mvi a, $ff
			stax d
			inx d
	.endif
			; empty the first color byte
			A_TO_ZERO(NULL_BYTE)
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
sprite_from_buff:
			DCX_H(2)
			mov e, m
			; e - copy_from_buff_offset
			inx h
			mov b, m
			; b - a mask_flag
			; 0 = no mask
			; 1 = a mask
			INX_H(3)
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
			A_TO_ZERO(NULL_BYTE)
			ora b
			jz @width24_no_mask
			mov a, c
			add a
			mov c, a

@width24_no_mask:			
			lxi d, __sprite_tmp_buff
@width24_loop:	
			SPRITE_FROM_BUFF_COPY_LINE(SPRITE_W24 * SPRITE_SCR_BUFFS * COLOR_BYTE_LEN)
			dcr c
			jnz @width24_loop
			ret

; hl - sprite data addr
; b - 0 = no mask, 1 = mask
; c - height
; e - copy_from_buff_offset
.macro SPRITE_FROM_BUFF(target_width)
			; check a mask_flag
			A_TO_ZERO(NULL_BYTE)
			ora b
			jz @without_mask
@with_mask:
			SPRITE_FROM_BUFF_(target_width, True)
@without_mask:
			SPRITE_FROM_BUFF_(target_width, False)
.endmacro

.macro SPRITE_FROM_BUFF_(target_width, with_mask)
		.if with_mask
			SP_BYTE_LEN = MASK_BYTE_COLOR_BYTE_LEN
		.endif
		.if with_mask == false
			SP_BYTE_LEN = COLOR_BYTE_LEN
		.endif

			; e - copy_from_buff_offset
			; check copy_from_buff_offset
			A_TO_ZERO(NULL_BYTE)
			ora e
			lxi d, __sprite_tmp_buff
			jz @no_offset

@offset:

		; skip the 1st colunm
		.if target_width == 8
			; copy the 2nd column only
			; screen buff 0
			; forward line
			SPRITE_FROM_BUFF_SKIP_BYTE(with_mask)
			SPRITE_FROM_BUFF_COPY_LINE(target_width / 8 * SP_BYTE_LEN)		
			SPRITE_FROM_BUFF_SKIP_BYTE(with_mask)

			; screen buff 1
			; backward line
			SPRITE_FROM_BUFF_SKIP_BYTE(with_mask)			
			SPRITE_FROM_BUFF_COPY_LINE(target_width / 8 * SP_BYTE_LEN)
			SPRITE_FROM_BUFF_SKIP_BYTE(with_mask)			

			; screen buff 2
			; backward line
			SPRITE_FROM_BUFF_SKIP_BYTE(with_mask)			
			SPRITE_FROM_BUFF_COPY_LINE(target_width / 8 * SP_BYTE_LEN)
			SPRITE_FROM_BUFF_SKIP_BYTE(with_mask)									
		.endif

		.if target_width == 16
			; copy 2nd, and 3rd column only
			; screen buff 0
			; forward line
			SPRITE_FROM_BUFF_SKIP_BYTE(with_mask)
			SPRITE_FROM_BUFF_COPY_LINE(target_width / 8 * SP_BYTE_LEN)

			; screen buff 1
			; backward line
			SPRITE_FROM_BUFF_COPY_LINE(target_width / 8 * SP_BYTE_LEN)
			SPRITE_FROM_BUFF_SKIP_BYTE(with_mask)

			; screen buff 2			
			; backward line
			SPRITE_FROM_BUFF_COPY_LINE(target_width / 8 * SP_BYTE_LEN)
			SPRITE_FROM_BUFF_SKIP_BYTE(with_mask)
		.endif
		
			dcr c
			jnz @offset
			ret

@no_offset:
		; skip the last 3rd column
		.if target_width == 8
			; copy the 2nd colunm only
			; screen buff 0
			; forward line
			SPRITE_FROM_BUFF_COPY_LINE(target_width / 8 * SP_BYTE_LEN)
			SPRITE_FROM_BUFF_SKIP_BYTE(with_mask)
			SPRITE_FROM_BUFF_SKIP_BYTE(with_mask)

			; screen buff 1
			; backward line
			SPRITE_FROM_BUFF_SKIP_BYTE(with_mask)			
			SPRITE_FROM_BUFF_SKIP_BYTE(with_mask)
			SPRITE_FROM_BUFF_COPY_LINE(target_width / 8 * SP_BYTE_LEN)

			; screen buff 2
			SPRITE_FROM_BUFF_SKIP_BYTE(with_mask)
			SPRITE_FROM_BUFF_SKIP_BYTE(with_mask)			
			SPRITE_FROM_BUFF_COPY_LINE(target_width / 8 * SP_BYTE_LEN)
		.endif

		.if target_width == 16
			; copy the 1st and 2nd columns
			; screen buff 0
			; forward line
			SPRITE_FROM_BUFF_COPY_LINE(target_width / 8 * SP_BYTE_LEN)
			SPRITE_FROM_BUFF_SKIP_BYTE(with_mask)

			; screen buff 1
			; backward line			
			SPRITE_FROM_BUFF_SKIP_BYTE(with_mask)
			SPRITE_FROM_BUFF_COPY_LINE(target_width / 8 * SP_BYTE_LEN)

			; screen buff 2
			; backward line
			SPRITE_FROM_BUFF_SKIP_BYTE(with_mask)			
			SPRITE_FROM_BUFF_COPY_LINE(target_width / 8 * SP_BYTE_LEN)
		.endif
		
			dcr c
			jnz @no_offset
			ret
.endmacro

.macro SPRITE_FROM_BUFF_SKIP_BYTE(with_mask)
			inx d
		.if with_mask
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
; e - preshifted_sprites
;	8 - shift by 1 pxl
;	4 - shift by 2 pxls
sprite_buff_preshift:
			; get a preshift
			DCX_H(2)
			mov b, m
			; get a mask_flag
			inx h
			mov a, m
			; get a height
			INX_H(3)
			mov c, m
			; advance to gfx data
			INX_H(2)
			; check a mask_flag
			CPI_WITH_ZERO(0)
			lxi h, __sprite_tmp_buff
			jz @color

@color_mask:
			; check preshift
			mvi a, 4
			cmp e
			jz @color_mask_2_pxls

@color_mask_1_pxl:
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
			jnz @color_mask_1_pxl
			ret

@color_mask_2_pxls:
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
			jnz @color_mask_2_pxls
			ret

@color:
			; check preshift
			mvi a, 4
			cmp e
			jz @color_2_pxls

@color_1_pxl:
			; scr buff 0
			SPRITE_BUFF_PRESHIFT_LINE(1, SPRITE_FORWARD_ORDER)
			; scr buff 1
			SPRITE_BUFF_PRESHIFT_LINE(1, SPRITE_BACKWARD_ORDER)
			; scr buff 2
			SPRITE_BUFF_PRESHIFT_LINE(1, SPRITE_BACKWARD_ORDER)
			dcr c
			jnz @color_1_pxl
			ret

@color_2_pxls:
			; scr buff 0
			SPRITE_BUFF_PRESHIFT_LINE(2, SPRITE_FORWARD_ORDER)
			; scr buff 1
			SPRITE_BUFF_PRESHIFT_LINE(2, SPRITE_BACKWARD_ORDER)
			; scr buff 2
			SPRITE_BUFF_PRESHIFT_LINE(2, SPRITE_BACKWARD_ORDER)
			dcr c
			jnz @color_2_pxls
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
			INX_H(2)
			mov d, m
			INX_H(2)
			mov e, m
		.endif
		.if order == SPRITE_BACKWARD_ORDER
			mov e, m
			INX_H(2)
			mov d, m
			INX_H(2)
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
			DCX_H(2)
			mov m, d
			DCX_H(2)
			mov m, a
		.endif
		.if order == SPRITE_BACKWARD_ORDER
			mov m, a
			DCX_H(2)
			mov m, d
			DCX_H(2)
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

; a temp buffer for preshifting.
; sprites width=8 occupy only the first and the last columns
; sprites width=16 can occupy all three columns while preshifting
; __sprite_tmp_buff buffer has the last third column empty for sprites with width = 8
; order of bytes the same as in the final sprite described in draw_sprite_rd.asm
__sprite_tmp_buff:
			.storage SPRITE_W16 * MASK_BYTE_COLOR_BYTE_LEN * SPRITE_SCR_BUFFS * SPRITE_PRESHIFT_H_MAX