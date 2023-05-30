; functions that common accross this specific game
; 


; it fills the main ram, backbuffer, backbuffer2
; set SCR_BUFF0 (only in the main mem), SCR_BUFF1, SCR_BUFF2 to zero
; set SCR_BUFF3 to $ff
fill_all_black:
			; set SCR_BUFF0, SCR_BUFF1, SCR_BUFF2 to zero
			; set SCR_BUFF3 to $ff
			; that represents the darkest possible color in the current palette
			xra a
			lxi d, SCR_BUFF_LEN * 3 / 32 - 1
			call fill_buff_black

			; do the same for backbuffer and backbuffer2
			; set SCR_BUFF1, SCR_BUFF2 to zero
			; set SCR_BUFF3 to $ff
			; that represents the darkest possible color in the current palette
			mvi a, __RAM_DISK_S_BACKBUFF
			lxi d, SCR_BUFF_LEN * 2 / 32 - 1
			call fill_buff_black

			mvi a, __RAM_DISK_S_BACKBUFF2
			lxi d, SCR_BUFF_LEN * 2 / 32 - 1
			call fill_buff_black
			ret

; it fills SCR_BUFF3 with $ff
; it erases SCR_BUFF2, optionally <SCR_BUFF1, SCR_BUFF0>
; that represents the darkest possible color in the current palette
; in:
; a - ram-disk activation command
;		a = 0 if you erase the main memory
; de - buff_len/32-1 that have to be erased
fill_buff_black:
			; set SCR_BUFF0, SCR_BUFF1, SCR_BUFF2 to zero
			lxi b, SCR_BUFF3_ADDR
			push psw
			call clear_mem_sp
			pop psw
			; set SCR_BUFF3 to $ff
			lxi h, $ffff
			lxi b, 0
			lxi d, SCR_BUFF_LEN / 32 - 1
			jmp fill_mem_sp

screen_simple_init:
			; clear the screen	
			xra a
			lxi b, 0
			lxi d, SCR_BUFF_LEN * 4 / 32 - 1
			call clear_mem_sp
			; clear the backbuffer2
			mvi a, __RAM_DISK_S_BACKBUFF
			lxi b, 0
			lxi d, SCR_BUFF_LEN * 3 / 32 - 1
			call clear_mem_sp

			mvi a, 1
			sta border_color_idx

			; erase backs buffs
			lxi h, backs_runtime_data
			mvi a, <backs_runtime_data_end
			call clear_mem_short
			; setup backs runtime data
			call backs_init

			; erase bullets buffs
			lxi h, bullet_runtime_data_sorted
			mvi a, <bullets_runtime_data_end
			call clear_mem_short
			; setup bullets runtime data
			call bullets_init			

			; fill up the tile_data_buff with tiledata = 0
			; (walkable tile, no back restore , no decal)
			mvi c, 0
			call room_fill_tiledata

			; reset key data
			lxi h, KEY_NO << 8 | KEY_NO
			shld key_code
			shld key_code_old
			ret