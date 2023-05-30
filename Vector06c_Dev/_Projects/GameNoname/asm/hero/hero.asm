.include "asm\\hero\\hero_data.asm"
.include "asm\\hero\\hero_update.asm"
.include "asm\\hero\\hero_collision.asm"
.include "asm\\hero\\hero_tile_funcs.asm"
.include "asm\\hero\\hero_render.asm"


hero_init:
			call hero_idle_start
			
			; reset key data			
			lxi h, KEY_NO << 8 | KEY_NO
			shld key_code

			lxi h, hero_pos_x+1
			call sprite_get_scr_addr8
			xchg
			shld hero_erase_scr_addr_old
			; 16x15 size
			lxi h, SPRITE_W_PACKED_MIN<<8 | SPRITE_H_MIN
			shld hero_erase_wh_old
			xra a
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
