.include "asm\\hero\\hero_data.asm"
.include "asm\\hero\\hero_update.asm"
.include "asm\\hero\\hero_collision.asm"
.include "asm\\hero\\hero_tile_funcs.asm"
.include "asm\\hero\\hero_render.asm"


hero_game_init:
			A_TO_ZERO(HERO_NO_WEAPON)
			sta hero_weapon
			ret

hero_init:
			call hero_idle_start
			
			; reset key data			
			A_TO_ZERO(CONTROL_CODE_NO)
			sta action_code

			lxi h, hero_pos_x+1
			call sprite_get_scr_addr8
			xchg
			shld hero_erase_scr_addr_old
			; 16x15 size
			lxi h, SPRITE_W_PACKED_MIN<<8 | SPRITE_H_MIN
			shld hero_erase_wh_old
			A_TO_ZERO(HERO_RENDER_STATUS_TRUE)
			sta hero_global_status_no_render
			ret

; input:
; b - posX
; c - posY
; use:
; a
hero_set_pos:
			mov a, b
			sta hero_pos_x+1
			mov a, c
			sta hero_pos_y+1
			ret
