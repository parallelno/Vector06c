; in:
; bc - vfx scrXY
; de - vfx_anim_ptr (ex. vfx_puff)
vfx_init:
			; store anim ptr
			mov a, e
			sta @anim_ptr_l + 1
			mov a, d
			sta @anim_ptr_h + 1

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
			; store anim ptr
@anim_ptr_l:
			mvi m, <TEMP_ADDR
			inx h
@anim_ptr_h:			
			mvi m, >TEMP_ADDR

			; make posX
			mvi a, %00011111
			ana b
			ori SPRITE_X_SCR_ADDR
			mov b, a
			ani %00011111
			RLC_(3)

			mvi e, 0
			; b = scrX
			; a = posX
			; c = posY			
			; e = 0 and SPRITE_W_PACKED_MIN
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
			mov m, e
			inx h
			mov m, a
			; advance hl to bullet_pos_y
			inx h
			mov m, e
			inx h
			mov m, c
			ret

; in:
; hl - ptr to animTimer (monster_anim_timer or bullet_anim_timer)
; a - anim speed
; use:
; de, bc, hl
; out:
; hl points to animPtr (bullet_anim_ptr or monster_anim_ptr)
vfx_anim_update:
			; update monster_anim_timer
			add m
			mov m, a
			; advance hl to monster_anim_ptr
			inx h ; to make hl point to monster_anim_ptr when it returns
			rnc
			; read the ptr to a current frame
			mov e, m
			inx h
			mov d, m
			xchg
			; hl - the ptr to a current frame
			; get the offset to the next frame
			mov c, m
			; check if it starts looping on the last frame
			xra a
			ora c
			rm ; if it loops, return

			inx h
			mov b, m
			; advance the current frame ptr to the next frame
			dad b
			xchg
			; de - the next frame ptr
			; hl points to monster_anim_ptr+1
			; store de into the monster_anim_ptr
			mov m, d
			dcx h
			mov m, e
			; reset P flag to indicate this is not the end of anim
			xra a
			ret

; anim and a gameplay logic update
; in:
; de - ptr to bullet_update_ptr in the runtime data
vfx_update:
			LXI_H_TO_DIFF(bullet_anim_timer, bullet_update_ptr)
			dad d
			mvi a, VFX_ANIM_SPEED
			call vfx_anim_update
			rp
@die:
			; de points to bullet_anim_ptr + 1
			; advance hl to bullet_update_ptr+1
			LXI_H_TO_DIFF(bullet_update_ptr+1, bullet_anim_ptr + 1)
			dad d
			jmp actor_destroy


; work with only preshift = 0
; in:
; hl - ptr to posX+1 (high byte in 16-bit pos)
; out:
; de - sprite screen addr
; c - preshifted sprite idx*2 offset based on posX then +2
; hl - ptr to posY+1
; use: a		
sprite_get_scr_addr_vfx:
			; calc screen addr X
			;mov	a, m
			;ani (SPRITES_PRESHIFTED_4 - 1) * 2
			;adi 2 ; because there are two bytes of nextFrameOffset in front of sprite ptrs
			;mov	c, a
			mvi c, 2

			mov	a, m
			RRC_(3)
			ani		%00011111
			adi		SPRITE_X_SCR_ADDR
			inx h
			inx h
			; de - sprite screen addr
			mov e, m
			mov	d, a
			ret

; draw a sprite into a backbuffer
; in:
; de - ptr to bullet_draw_ptr in the runtime data
; TODO: make it use preshift 2
vfx_draw:
			BULLET_DRAW(sprite_get_scr_addr_vfx, __RAM_DISK_S_VFX)
