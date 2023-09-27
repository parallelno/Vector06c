;----------------------------------------------------------------
; draw a tiled image (8x8 tiles)
; input:
; a - idx_data ram-disk activation command
; de - idx_data addr
; ex.: 
; DRAW_TILED_IMG(__RAM_DISK_S_TILED_IMAGES_DATA, __tiled_images_frame_ingame_top)

.macro DRAW_TILED_IMG(ram_disk_s_tiled_img_data, idxs_data_addr)
			mvi a, <ram_disk_s_tiled_img_data
			lxi d, idxs_data_addr
			call draw_tiled_img
.endmacro

TILED_IMG_SCR_BUFFS = 4
TILED_IMG_TILE_H = 8
TILE_IMG_TILE_LEN = TILED_IMG_TILE_H * TILED_IMG_SCR_BUFFS + 2 ; 8*4 bytes + a couple of safety bytes

REPEATER_CODE = $ff

draw_tiled_img:
			; de - data addr in the ram-disk
			; a - ram-disk activation command
			push d
			sta @ram_disk_access_data + 1
			call get_word_from_ram_disk
			; hl = idxs_data_addr
			; c = idxs_data_len
			; b = ram_disk_s_tiled_img_gfx
			mov a, b
			sta @gfx_data_access + 1			
@ram_disk_access_data:
			mvi h, TEMP_BYTE
			mov l, c
			pop d
			; de - idxs_data_addr

			; h - ram-disk activation command
			; l - data length / 2
			; de - data addr in the ram-disk
			; bc - destination addr
			; copy an image indices into a temp buffer
			lxi b, tiled_img_idxs
			call copy_from_ram_disk

@gfx_data_access:
			mvi a, TEMP_BYTE
			RAM_DISK_ON_BANK()

@draw:
			lxi h, tiled_img_idxs + 2 ; because the two bytes are __TILED_IMAGES_MAIN_MENU_BACK2_COPY_LEN, __RAM_DISK_S_TILED_IMAGES_DATA
			; get gfx addr
			mov e, m
			inx h
			mov d, m
			inx h
			xchg
			shld @gfx_addr + 1
			xchg

			; get scr addr
			mov e, m
			inx h
			mov d, m
			inx h
			; store scr_x for restoration every new line
			mov a, d
			sta @restore_scr_x + 1

			; store scr_y_end for checking the end of drawing
			mov a, m
			inx h
			sta @check_end + 1

			; store scr_x_end for checking the end of the line
			mov a, m
			inx h
			sta @check_end_line + 1
			; de - scr addr

@loop:
			; get tile_idx
			mov c, m
			inx h
			; skip if tile_idx = 0
			A_TO_ZERO(NULL_BYTE)
			ora c
			jz @skip
			cpi REPEATER_CODE
			jnz @it_is_idx

			; it is REPEATER_CODE
			; meaning the next two bytes represent
			; idx and repeating counter
			mov c, m
			; c - tile_idx
			inx h
			mov b, m
			inx h

			; skip if tile_idx = 0
			A_TO_ZERO(NULL_BYTE)
			ora c
			jnz @get_gfx_ptr
			; tile_idx = 0,
			; advance dce to the proper pos, and skip drawing
			; b - repeating counter
			mov a, d
			add b
			mov d, a
			jmp @check_end_line
@it_is_idx:
			mvi b, 1

@get_gfx_ptr:
			; c - tile_idx
			; b - repeating counter
			mov a, b
			sta @repeating_counter
			; tile gfx ptr = tile_gfxs_ptr + tile_idx * 34
			push h
			mov l, c
			mvi h, 0
			; offset = tile_idx * 32
			dad h
			mov c, l
			mov b, h
			dad h
			dad h
			dad h
			dad h
			; offset += tile_idx * 2
			dad b
			; add tile_gfxs_ptr
@gfx_addr:			
			lxi b, __tiled_images_tile1 - TILE_IMG_TILE_LEN ; because there is no tile_gfx associated with idx = 0
			dad b
			mov c, l
			mov b, h
			; bc - points to tile_gfx
@repeat:
			push b
			call @draw_tile
			pop b
			xchg
			; de - screen addr + $60
			mov a, d
			adi -$60 + 1
			mov d, a
			; de - scr_addr
			; bc - tile_gfx_addr
			lxi h, @repeating_counter
			dcr m
			jnz @repeat
			; restore a pointer to the next tile_idx
			pop h
			; decr d register because to compensate the next inc d after @skip
			dcr d
@skip:
			; advance pos_x to the next tile
			inr d
@check_end_line:
			mvi a, TEMP_BYTE
			cmp d
			jnz @loop
@restore_scr_x:
			; advance pos to a new line
			mvi d, TEMP_BYTE
			mvi a, TILED_IMG_TILE_H
			add e
			mov e, a
@check_end:
			cpi TEMP_BYTE
			jnz @loop

			RAM_DISK_OFF()
			ret
@repeating_counter:
			.byte 1
; draw a tile (8x8 pixels)
; input:
; bc - a tile gfx ptr
; de - screen addr
; out:
; hl - screen addr + $60

; tile gfx format:
; SCR_BUFF0_ADDR : 8 bytes from bottom to top
; SCR_BUFF1_ADDR : 8 bytes from top to bottom
; SCR_BUFF2_ADDR : 8 bytes from bottom to top
; SCR_BUFF3_ADDR : 8 bytes from top to bottom

@draw_tile:
			; store sp
			lxi h, $0000
			dad sp
			shld @restore_sp + 1
			; sp = BC
			mov h, b
			mov l, c
			sphl
			xchg

			lxi d, $2000
			; hl - screen buff addr
			; sp - tile_gfx data
			; de - next scr addr offset
			TILED_IMG_DRAWTILE()
@restore_sp:
			lxi sp, TEMP_ADDR
			ret

.macro TILED_IMG_DRAWTILE()
		; scr0 draw up
		.loop 3
			pop b
			mov m, c
			inr l
			mov m, b
			inr l
		.endloop
			pop b
			mov m, c
			inr l
			mov m, b
			dad d

		; scr1 draw down
		.loop 3
			pop b
			mov m, c
			dcr l
			mov m, b
			dcr l
		.endloop
			pop b
			mov m, c
			dcr l
			mov m, b
			dad d

		; scr2 draw up
		.loop 3
			pop b
			mov m, c
			inr l
			mov m, b
			inr l
		.endloop
			pop b
			mov m, c
			inr l
			mov m, b
			dad d

		; scr3 draw down
		.loop 3
			pop b
			mov m, c
			dcr l
			mov m, b
			dcr l
		.endloop
			pop b
			mov m, c
			dcr l
			mov m, b
.endmacro