; Init for preshifted VFX
; in:
; bc - vfx pos_xy
; de - vfx_anim_ptr (ex. vfx_puff)
vfx_init4:
			xchg
			shld @anim_ptr + 1

			lxi h, bullet_update_ptr+1
			mvi a, BULLET_RUNTIME_DATA_LEN
			call actor_get_empty_data_ptr

			; hl - ptr to bullet_update_ptr+1
			; advance hl to bullet_update_ptr
			dcx h
			mvi m, <vfx_update
			inx h 
			mvi m, >vfx_update
			; advance hl to bullet_draw_ptr
			inx h 
			mvi m, <vfx_draw4
			inx h 
			mvi m, >vfx_draw4

			; advance hl to bullet_anim_ptr
			MVI_A_TO_DIFF(bullet_anim_ptr, bullet_draw_ptr + 1)
			add l
			mov l, a
			
@anim_ptr:  ; store anim ptr
			lxi d, TEMP_ADDR
			mov m, e
			inx h			
			mov m, d

			mov a, b
			; a - pos_x
			; scr_x = pos_x/8 + $a0
			RRC_(3)
			ani %00011111
			adi SPRITE_X_SCR_ADDR
			mvi e, 0
			; a = scr_x
			; b = pos_x
			; c = pos_y			
			; e = 0 and SPRITE_W_PACKED_MIN
			; hl - ptr to bullet_erase_scr_addr_old			
			
			; advance hl to bullet_erase_scr_addr
			inx h
			mov m, c
			inx h
			mov m, a
			; advance hl to bullet_erase_scr_addr_old
			inx h
			mov m, c
			inx h
			mov m, a
			; advance hl to bullet_erase_wh
			inx h
			mvi m, SPRITE_H_MIN
			inx h
			mov m, e
			; advance hl to bullet_erase_wh_old
			inx h
			mvi m, SPRITE_H_MIN
			inx h
			mov m, e
			; advance hl to bullet_pos_x
			inx h
			mov m, e
			inx h
			mov m, b
			; advance hl to bullet_pos_y
			inx h
			mov m, e
			inx h
			mov m, c
			ret

; Init for non-preshifted VFX (x coord aligned to 8 pixels )
; in:
; bc - vfx screen addr
; de - vfx_anim_ptr (ex. vfx_puff)
vfx_init:
			xchg
			shld @anim_ptr + 1

			lxi h, bullet_update_ptr+1
			mvi a, BULLET_RUNTIME_DATA_LEN
			call actor_get_empty_data_ptr

			; hl - ptr to bullet_update_ptr+1
			; advance hl to bullet_update_ptr
			dcx h
			mvi m, <vfx_update
			inx h 
			mvi m, >vfx_update
			; advance hl to bullet_draw_ptr
			inx h 
			mvi m, <vfx_draw
			inx h 
			mvi m, >vfx_draw

			; advance hl to bullet_anim_ptr
			MVI_A_TO_DIFF(bullet_anim_ptr, bullet_draw_ptr + 1)
			add l
			mov l, a
			
@anim_ptr:  ; store anim ptr
			lxi d, TEMP_ADDR
			mov m, e
			inx h			
			mov m, d

			; make a proper scr addr
			mvi a, %00011111
			ana b
			ori SPRITE_X_SCR_ADDR
			mov b, a

			mvi d, 2 ; anim ptr offset. used in draw func
			mvi e, 0
			; bc - screen addr
			; e - 0 and SPRITE_W_PACKED_MIN
			; hl - ptr to bullet_erase_scr_addr_old			
			
			; advance hl to bullet_erase_scr_addr
			inx h
			mov m, c
			inx h
			mov m, b
			; advance hl to bullet_erase_scr_addr_old
			inx h
			mov m, c
			inx h
			mov m, b
			; advance hl to bullet_erase_wh
			inx h
			mvi m, SPRITE_H_MIN
			inx h
			mov m, e
			; advance hl to bullet_erase_wh_old
			inx h
			mvi m, SPRITE_H_MIN
			inx h
			mov m, e
			; advance hl to bullet_pos_x
			inx h
			inx h
			mov m, b
			; advance hl to bullet_pos_y
			inx h
@anim_ptr_offset:
			mov m, d
			inx h
			mov m, c
			ret

; anim and a gameplay logic update
; in:
; de - ptr to bullet_update_ptr in the runtime data
vfx_update:
			LXI_H_TO_DIFF(bullet_anim_timer, bullet_update_ptr)
			dad d
			mvi a, VFX_ANIM_SPEED
			call actor_anim_update
			rnc
@die:
			; hl points to bullet_anim_ptr
			; advance hl to bullet_update_ptr+1
			LXI_D_TO_DIFF(bullet_update_ptr+1, bullet_anim_ptr)
			dad d
			jmp actor_destroy


; in:
; hl - ptr to pos_x+1 (high byte in 16-bit pos)
; out:
; de - sprite screen addr
; c - preshifted sprite idx*2 offset based on pos_x then +2
; hl - ptr to pos_y+1
; use: a		
sprite_get_scr_addr_vfx:
			mov d, m 
			inx h 
			mov c, m ; (pos_y) contains an anim ptr offset to get a proper preshifted frame
			inx h 
			mov e, m
			ret

; draw a non-preshifted sprite into a backbuffer
; in:
; de - ptr to bullet_draw_ptr in the runtime data
vfx_draw:
			BULLET_DRAW(sprite_get_scr_addr_vfx, __RAM_DISK_S_VFX, false)

; draw a sprite into a backbuffer
; in:
; de - ptr to bullet_draw_ptr in the runtime data
vfx_draw4:
			BULLET_DRAW(sprite_get_scr_addr_vfx4, __RAM_DISK_S_VFX4, false)
