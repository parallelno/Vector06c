hero_draw:
			lxi h, hero_pos_x+1
			call sprite_get_scr_addr_hero_r

			lhld hero_anim_addr
			call sprite_get_addr

			lda hero_dir
			rrc
			mvi l, <(__RAM_DISK_S_HERO_R | __RAM_DISK_M_DRAW_SPRITE_VM | RAM_DISK_M_8F)
			jc @spriteR
@spriteL:
			mvi l, <(__RAM_DISK_S_HERO_L | __RAM_DISK_M_DRAW_SPRITE_VM | RAM_DISK_M_8F)
@spriteR:

			lda hero_status
			ani ACTOR_STATUS_BIT_INVIS
			jnz @invis
			lda hero_status
			ani ACTOR_STATUS_BIT_BLINK
			jnz @state_blink

@draw:
			mov a, l
			; TODO: optimize. consider using unrolled loops in DrawSpriteVM for sprites 15 pxs tall
			CALL_RAM_DISK_FUNC_BANK(__draw_sprite_vm)

@save_params:
			; store an old scr addr, width, and height
			lxi h, hero_erase_scr_addr
			mov m, c
			inx h
			mov m, b
			xchg
			shld hero_erase_wh
			ret

@state_blink:
			mvi a, %00110011
			rrc
			sta @state_blink + 1
			jc @draw
@invis:
			mov a, l
			CALL_RAM_DISK_FUNC_BANK(__draw_sprite_invis_vm)
			jmp @save_params

hero_copy_to_scr:
			; get min(h, d), min(e,l)
			lhld hero_erase_scr_addr_old
			xchg
			lhld hero_erase_scr_addr
			mov a, h
			cmp d
			jc @keepCurrentX
			mov h, d
@keepCurrentX:
			mov a, l
			cmp e
			jc @keepCurrentY
			mov l, e
@keepCurrentY:
			; hl - a scr addr to copy
			push h
			; de - an old sprite scr addr
			lhld hero_erase_wh_old
			dad d
			push h
			lhld hero_erase_scr_addr
			; store as old
			shld hero_erase_scr_addr_old
			xchg
			lhld hero_erase_wh
			; store as old
			shld hero_erase_wh_old
			dad d
			; hl - current sprite top-right corner scr addr
			; de - old sprite top-right corner scr addr
			pop d
			; get the max(h, d), max(e,l)
			mov a, h
			cmp d
			jnc @keepCurrentTRX
			mov h, d
@keepCurrentTRX:
			mov a, l
			cmp e
			jnc @keepCurrentTRY
			mov l, e
@keepCurrentTRY:
			; hl - top-right corner scr addr to copy
			; de - a scr addr to copy
			pop d
			; calc bc (width, height)
			mov a, h
			sub d
			mov b, a
			mov a, l
			sub e
			mov c, a
			jmp sprite_copy_to_scr_v

hero_erase:
			lhld hero_erase_scr_addr
			xchg
			lhld hero_erase_wh

			; check if it needs to restore the background
			call room_check_tiledata_restorable
			lhld hero_erase_scr_addr
			xchg
			lhld hero_erase_wh


			jnz sprite_copy_to_back_buff_v ; restore a background
			CALL_RAM_DISK_FUNC(__erase_sprite, __RAM_DISK_S_BACKBUFF | __RAM_DISK_M_ERASE_SPRITE | RAM_DISK_M_8F)
			ret