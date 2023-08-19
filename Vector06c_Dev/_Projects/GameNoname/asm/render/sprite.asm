; get a sprite data addr
; in:
; hl - anim_ptr
; c - preshifted sprite idx*2 offset based on posX then +2
; out:
; bc - ptr to a sprite
sprite_get_addr:
			mvi b, 0
			dad b
			mov c, m
			inx h
			mov b, m
			ret

; in:
; hl - ptr to posX+1 (high byte in 16-bit pos)
; out:
; de - sprite screen addr
; c - preshifted sprite idx*2 offset based on posX then +2
; hl - ptr to posY+1
; use: a
sprite_get_scr_addr8:
			; calc preshifted sprite idx*2 offset
			mov	a, m
			ani SPRITES_PRESHIFTED_8 - 1 ; %0000_0111
			rlc
			adi 2 ; because there are two bytes of next_frame_offset in front of sprite ptrs
			mov	c, a
			; calc screen addr X
			mov	a, m
			RRC_(3)
			ani %00011111
			adi SPRITE_X_SCR_ADDR
			INX_H(2)
			mov e, m
			mov	d, a
			; de - sprite screen addr			
			ret

; in:
; hl - ptr to posX+1 (high byte in 16-bit pos)
; out:
; de - sprite screen addr
; c - preshifted sprite idx*2 offset based on posX then +2
; hl - ptr to posY+1
; use: a	
; TODO: think of optimization. replace mov a, m; ani, with mvi, ana m
sprite_get_scr_addr4:
			; calc preshifted sprite idx*2 offset
			mov	a, m
			ani (SPRITES_PRESHIFTED_4 - 1) * 2 ; %0000_0110
			adi 2 ; because there are two bytes of next_frame_offset in front of sprite ptrs
			mov	c, a
			; calc screen addr X
			mov	a, m
			RRC_(3)
			ani %00011111
			adi SPRITE_X_SCR_ADDR
			INX_H(2)
			mov e, m
			mov	d, a
			; de - sprite screen addr			
			ret
			

; copy a sprite from the back buff to the screen
; in:
; de - scr addr
; b - width
;		00 - 8pxs,
;		01 - 16pxs,
;		10 - 24pxs,
;		11 - 32pxs
; c - height

sprite_copy_to_scr_v:
			; store sp
			lxi h, 0
			dad	sp
			shld restore_sp + 1

			; Y -= 1 because we start copying bytes with dec Y
			inr e
/*
			; w=max(h, SPRITE_COPY_TO_SCR_H_MAX)
			mvi a, SPRITE_COPY_TO_SCR_W_PACKED_MAX
			cmp b
			jnc @skipMaxW
@maxW:
			mvi b, SPRITE_COPY_TO_SCR_W_PACKED_MAX
@skipMaxW:
*/
			; h=max(h, SPRITE_COPY_TO_SCR_H_MAX)
			mov a, c
			cpi SPRITE_COPY_TO_SCR_H_MAX
			jc @skipMaxH
@maxH:
			mvi a, SPRITE_COPY_TO_SCR_H_MAX
@skipMaxH:

			; BC = an offset in the copy routine table
			ADD_A(2) ; to make a JMP_4 ptr

			mov c, a
			mov a, b ; temp a = width
			mvi b, 0

			; hl - an addr of a copy routine
			lxi h, @copy_routine_addrs - SPRITE_COPY_TO_SCR_H_MIN * JMP_4_LEN
			dad b
			; run the copy routine
			pchl

@h05:		COPY_SPRITE_TO_SCR(5)
@h06:		COPY_SPRITE_TO_SCR(6)
@h07:		COPY_SPRITE_TO_SCR(7)
@h08:		COPY_SPRITE_TO_SCR(8)
@h09:		COPY_SPRITE_TO_SCR(9)
@h10:		COPY_SPRITE_TO_SCR(10)
@h11:		COPY_SPRITE_TO_SCR(11)
@h12:		COPY_SPRITE_TO_SCR(12)
@h13:		COPY_SPRITE_TO_SCR(13)
@h14:		COPY_SPRITE_TO_SCR(14)
@h15:		COPY_SPRITE_TO_SCR(15)
@h16:		COPY_SPRITE_TO_SCR(16)
@h17:		COPY_SPRITE_TO_SCR(17)
@h18:		COPY_SPRITE_TO_SCR(18)
@h19:		COPY_SPRITE_TO_SCR(19)
@h20:		COPY_SPRITE_TO_SCR(20)

@copy_routine_addrs:
			JMP_4(@h05)
			JMP_4(@h06)
			JMP_4(@h07)
			JMP_4(@h08)
			JMP_4(@h09)
			JMP_4(@h10)
			JMP_4(@h11)
			JMP_4(@h12)
			JMP_4(@h13)
			JMP_4(@h14)
			JMP_4(@h15)
			JMP_4(@h16)
			JMP_4(@h17)
			JMP_4(@h18)
			JMP_4(@h19)
			JMP_4(@h20)		

.macro COPY_SPRITE_TO_SCR_PB(move_up = true)
			pop b
			mov m, c
			inr l
			mov m, b
		.if move_up == true
			inr l
		.endif
.endmacro
.macro COPY_SPRITE_TO_SCR_B()
			pop b
			mov m, c
.endmacro

.macro COPY_SPRITE_TO_SCR_LOOP(height, height_odd)
	.if height_odd
		.loop height / 2 - 1
			COPY_SPRITE_TO_SCR_PB()
		.endloop
			COPY_SPRITE_TO_SCR_B()
	.endif
	.if height_odd == false
		.loop height / 2 - 2
			COPY_SPRITE_TO_SCR_PB()
		.endloop
			COPY_SPRITE_TO_SCR_PB(false)
	.endif			
.endmacro

.macro COPY_SPRITE_TO_SCR(height)
			height_odd = (height / 2)*2 != height
			; hl - scr addr
			xchg
			; d - width
			mov d, a			
			; to restore X
			mov e, h

@next_column:
			RAM_DISK_ON(__RAM_DISK_S_BACKBUFF | __RAM_DISK_M_BACKBUFF | RAM_DISK_M_8F)
			; read without a stack operations because
			; we have to load BC before using POP B
			mov b, m
			dcr l
			mov c, m
			RAM_DISK_ON(__RAM_DISK_S_BACKBUFF)

			mov m, c
			inr l
			mov m, b
			inr l
			sphl

			COPY_SPRITE_TO_SCR_LOOP(height, height_odd)

			; advance Y to the bottom of the sprite, X to the next scr buff
	.if height_odd
			lxi h, $2000-height+2-1-1
	.endif
	.if height_odd == false
			lxi h, $2000-height+2-1
	.endif
			dad sp
			; set sp to a safe place, because an interuption break can happen
			; between sta and out $10 in RAM_DISK_ON(__RAM_DISK_S_BACKBUFF) in the code above
			lxi sp, STACK_INTERRUPTION_ADDR

			jnc @next_column
			; advance Y to the next column
			inr e
			mov h, e
			dcr d
			jp @next_column
			jmp restore_sp
.endmacro

; copy a sprite from backbuff1 to backbuff2
; in:
; de - scr addr
; h - width
;		00 - 8pxs,
;		01 - 16pxs,
;		10 - 24pxs,
;		11 - 32pxs
; l - height

sprite_copy_to_back_buff_v:
			; Y -= 1 because we start copying bytes with dec Y
			inr e

			; h=min(h, SPRITE_COPY_TO_SCR_H_MAX)
			mov a, l
			cpi SPRITE_COPY_TO_SCR_H_MAX
			jc @do_not_set_min
@set_min:
			mvi a, SPRITE_COPY_TO_SCR_H_MAX
@do_not_set_min:

			; BC = an offset in the copy routine table
			ADD_A(2)	; to make a JMP_4 ptr
			mov c, a
			mvi b, 0
			; temp a = width
			mov a, h

			; store sp
			lxi h, 0
			dad	sp
			shld restore_sp + 1

			; hl - an addr of a copy routine
			lxi h, @copy_routine_addrs - SPRITE_COPY_TO_SCR_H_MIN * JMP_4_LEN
			dad b
			; run the copy routine
			pchl

@h05:		COPY_SPRITE_TO_SCR2(5)
@h06:		COPY_SPRITE_TO_SCR2(6)
@h07:		COPY_SPRITE_TO_SCR2(7)
@h08:		COPY_SPRITE_TO_SCR2(8)
@h09:		COPY_SPRITE_TO_SCR2(9)
@h10:		COPY_SPRITE_TO_SCR2(10)
@h11:		COPY_SPRITE_TO_SCR2(11)
@h12:		COPY_SPRITE_TO_SCR2(12)
@h13:		COPY_SPRITE_TO_SCR2(13)
@h14:		COPY_SPRITE_TO_SCR2(14)
@h15:		COPY_SPRITE_TO_SCR2(15)
@h16:		COPY_SPRITE_TO_SCR2(16)
@h17:		COPY_SPRITE_TO_SCR2(17)
@h18:		COPY_SPRITE_TO_SCR2(18)
@h19:		COPY_SPRITE_TO_SCR2(19)
@h20:		COPY_SPRITE_TO_SCR2(20)

@copy_routine_addrs:
			JMP_4(@h05)
			JMP_4(@h06)
			JMP_4(@h07)
			JMP_4(@h08)
			JMP_4(@h09)
			JMP_4(@h10)
			JMP_4(@h11)
			JMP_4(@h12)
			JMP_4(@h13)
			JMP_4(@h14)
			JMP_4(@h15)
			JMP_4(@h16)
			JMP_4(@h17)
			JMP_4(@h18)
			JMP_4(@h19)
			JMP_4(@h20)					

.macro COPY_SPRITE_TO_SCR_PB2(move_up = true)
			pop b
			mov m, c
			inr l
			mov m, b
		.if move_up == true
			inr l
		.endif
.endmacro
.macro COPY_SPRITE_TO_SCR_B2()
			pop b
			mov m, c
.endmacro

.macro COPY_SPRITE_TO_SCR_LOOP2(height)
			height_odd = (height / 2)*2 != height

	.if height_odd
		.loop height / 2 - 1
			COPY_SPRITE_TO_SCR_PB()
		.endloop
			COPY_SPRITE_TO_SCR_B()
	.endif
	.if height_odd == false
		.loop height / 2 - 2
			COPY_SPRITE_TO_SCR_PB()
		.endloop
			COPY_SPRITE_TO_SCR_PB(false)
	.endif			
.endmacro

.macro COPY_SPRITE_TO_SCR2(height)
			; hl - scr addr
			xchg
			; d - width
			mov d, a
@next_column:
			RAM_DISK_ON(__RAM_DISK_S_BACKBUFF2 | __RAM_DISK_M_BACKBUFF2 | RAM_DISK_M_8F)
			; read without a stack operations because
			; we need fill up BC prior to use POP B
			mov b, m
			dcr l
			mov c, m
			RAM_DISK_ON(__RAM_DISK_S_BACKBUFF2 | __RAM_DISK_M_BACKBUFF | RAM_DISK_M_8F)

			mov m, c
			inr l
			mov m, b
			inr l
			sphl

			COPY_SPRITE_TO_SCR_LOOP2(height)

			; assign SP to prevent screen data corruption
			; when we use mov b, m and mov c, m commands.
			; a corruption might happen because we fill up B and C with
			; more than one command (mov b,m/mov c,m)
			lxi sp, STACK_INTERRUPTION_ADDR
			; advance Y down and to the next scr buff
			lxi b, $2000-height+2
			dad b

			jnc @next_column
			; advance Y to the next column
			mvi a, -$20*3+1
			add h
			mov h, a
			dcr d
			jp @next_column
			jmp restore_sp
.endmacro

