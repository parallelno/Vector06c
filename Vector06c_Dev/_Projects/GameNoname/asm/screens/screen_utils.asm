screen_space_checking:
			; check keys
			; check if the space key pressed
			lhld key_code
			mvi a, KEY_SPACE
			cmp h
			rnz

			mvi a, GLOBAL_REQ_MAIN_MENU
			sta global_request
			ret


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

screen_palette_and_frame:
			lxi d, __tiled_images_palette
			mvi h, <__RAM_DISK_S_TILED_IMAGES_GFX
			call copy_palette_request_update

			; back1
			DRAW_TILED_IMG(__RAM_DISK_S_TILED_IMAGES_GFX, __RAM_DISK_S_TILED_IMAGES_DATA, __tiled_images_main_menu_back1, __TILED_IMAGES_MAIN_MENU_BACK1_COPY_LEN, __tiled_images_tile1)
			; back2
			DRAW_TILED_IMG(__RAM_DISK_S_TILED_IMAGES_GFX, __RAM_DISK_S_TILED_IMAGES_DATA, __tiled_images_main_menu_back2, __TILED_IMAGES_MAIN_MENU_BACK2_COPY_LEN, __tiled_images_tile1)			
			ret			

; in:
; hl - a specific update func ptr
screen_simple_update:
			shld @spec_update_func + 1
			lxi h, game_update_counter
			inr m

			; check if an interuption happened
			lda requested_updates
			ora a
			rz
@loop:
@spec_update_func:
			call TEMP_ADDR
			call backs_update
			call bullets_update

			; to check repeated key-pressing
			lhld key_code
			shld key_code_old

			lxi h, requested_updates
			dcr m
			jnz @loop
			ret

screen_simple_draw:
			; update counter to calc fps
			lhld game_draws_counter
			inx h
			shld game_draws_counter

			; draw funcs
			call backs_draw
			call bullets_draw
			call bullets_copy_to_scr
			call bullets_erase			
			ret