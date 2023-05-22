;----------------------------------------------------------------
; draw a tiled image (8x8 tiles)
; input:
TILED_IMG_SCR_BUFFS = 4
TILED_IMG_TILE_H = 8
TILE_IMG_TILE_LEN = TILED_IMG_TILE_H * TILED_IMG_SCR_BUFFS + 2 ; 8*4 bytes + a couple of safety bytes

draw_tiled_img:
			; copy an image indices into a temp buffer
			lxi h, __RAM_DISK_S_TILED_IMAGES_DATA << 8 | __TILED_IMAGES_FRAME_INGAME_DIALOG_LEN / 2
			lxi d, __tiled_images_frame_ingame_dialog
			lxi b, tiled_img_idxs
			call copy_from_ram_disk
			
			; draw gfx tiles
			lxi d, __TILED_IMAGES_FRAME_INGAME_DIALOG_SCR_ADDR
			mov a, d
			sta @restore_scr_x + 1

			mvi a, >__TILED_IMAGES_FRAME_INGAME_DIALOG_SCR_ADDR_END
			sta @check_end_line + 1

			mvi a, <__TILED_IMAGES_FRAME_INGAME_DIALOG_SCR_ADDR_END
			sta @check_end + 1

			lxi h, tiled_img_idxs
@loop:			
			; get tile_idx
			mov a, m
			inx h
			; skip if idx = 0
			ora a
			jz @skip
			; tile gfx ptr = tile_gfxs_ptr + tile_idx * 34
			push h
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
			lxi b, __tiled_images_tiles
			dad b
			mov c, l
			mov b, h
			call draw_tiled_img_tile
			; hl - screen addr + $60
			mov a, h
			adi -$60
			mov h, a
@skip:
			inr h
			mov a, h
@check_end_line:			
			cpi TEMP_BYTE
			jnz @loop
@restore_scr_x:
			mvi h, TEMP_BYTE
			mvi a, TILED_IMG_TILE_H
			add l
			mov l, a
@check_end:
			cpi TEMP_BYTE
			jnz @loop
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

draw_tiled_img_tile:
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
			
.macro TILED_IMG_DRAWTILE()
		; scr0 draw up
		.loop 7
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
		.loop 7
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
		.loop 7
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
		.loop 7
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