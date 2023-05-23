;----------------------------------------------------------------
; draw a tiled image (8x8 tiles)
; input:
; a - gfx_data ram-disk activation command
; h - idx_data ram-disk activation command
; l - idx_data len (comes from a exported file)
; de - idx_data addr
; ex.: 
; DRAW_TILED_IMG(__RAM_DISK_S_TILED_IMAGES_GFX, __RAM_DISK_S_TILED_IMAGES_DATA, __tiled_images_frame_ingame_top, __TILED_IMAGES_FRAME_INGAME_TOP_COPY_LEN, __tiled_images_tile1)

.macro DRAW_TILED_IMG(ram_disk_s_tiled_img_gfx, ram_disk_s_tiled_img_data, idxs_data_addr, idxs_data_len, tile_gfx_addr)
			lxi h, tile_gfx_addr - TILE_IMG_TILE_LEN ; because there is no tile_gfx associated with idx = 0
			shld draw_tiled_img_gfx_addr
			mvi a, <ram_disk_s_tiled_img_gfx			
			lxi h, ram_disk_s_tiled_img_data << 8 | idxs_data_len
			lxi d, idxs_data_addr
			call draw_tiled_img
.endmacro

TILED_IMG_SCR_BUFFS = 4
TILED_IMG_TILE_H = 8
TILE_IMG_TILE_LEN = TILED_IMG_TILE_H * TILED_IMG_SCR_BUFFS + 2 ; 8*4 bytes + a couple of safety bytes

draw_tiled_img:
			sta @gfx_data_access + 1
			
			; copy an image indices into a temp buffer
			lxi b, tiled_img_idxs
			call copy_from_ram_disk

@gfx_data_access:
			mvi a, TEMP_BYTE
			RAM_DISK_ON_BANK()
			;CALL_RAM_DISK_FUNC_BANK(@draw)
			;ret

@draw:
			lxi h, tiled_img_idxs
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

@loop:
			; get tile_idx
			mov a, m
			inx h
			push h
			; skip if idx = 0
			ora a
			jz @skip
			; tile gfx ptr = tile_gfxs_ptr + tile_idx * 34
			mov l, a
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
			call @draw_tile
			; hl - screen addr + $60
			mov a, h
			adi -$60
			mov h, a
			xchg
@skip:
			pop h
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
			shld @restoreSP + 1
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
@restoreSP:
			lxi sp, TEMP_ADDR
			ret

draw_tiled_img_gfx_addr = @gfx_addr + 1

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