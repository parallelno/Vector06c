; -----------------------------------------------------------------------------
; image unpacker/renderer
; ex. CALL_RAM_DISK_FUNC(draw_image_zx0, __RAM_DISK_M_IMAGES | RAM_DISK_M_8F)
;
; based on ZX0 i8080 decoder v7 by Ivan Gorodetsky -  OLD FILE FORMAT v1
; which based on ZX0 z80 decoder by Einar Saukas

; unpacks from the ram-disk $8000-$FFFF to ram
; in:
; de - compressed data addr
; bc - uncompressed data addr
; a - ram-disk activation command

.macro DRAW_IMAGE_ZX0_COPY(_scr_dx)
			RAM_DISK_ON(__RAM_DISK_M_BACKBUFF | RAM_DISK_M_8F)
			ldax d
			mov c, a
			inx d
			RAM_DISK_OFF()
			mov m, c

			mvi a, _scr_dx
			add h
			mov h, a
.endmacro

draw_image_zx0:
			CALL_RAM_DISK_FUNC_BANK(@unpack)
			CALL_RAM_DISK_FUNC(@decoded_scr_buff_data, __RAM_DISK_M_BACKBUFF | RAM_DISK_M_8F)

			;copy the pallete from a ram-disk, then requet for using it
			lxi d, __image_intro_palette
			mvi h, <(__RAM_DISK_M_IMAGES | RAM_DISK_M_8F)
			call copy_palette_request_update
						

			lxi h, SCR_BUFF0_ADDR
			call @copy_scr_data
			;HLT_(100)
			ret

; copy data into the screen buff
; in:
; hl - scr addr
@copy_scr_data:
			; de - ptr to a temporally uncompressed data in the ram-disk backbuffer
			lxi d, SCR_BUFF1_ADDR
@copy_new_line:			
			; b - width
			mvi b, 30 ; width/8 240/8
			mvi h, >SCR_BUFF0_ADDR ; should be set
@copy_loop:
			; draw in SCR BUFF0
			DRAW_IMAGE_ZX0_COPY($20)
			; draw in SCR BUFF1
			DRAW_IMAGE_ZX0_COPY($20)
			; draw in SCR BUFF2
			DRAW_IMAGE_ZX0_COPY($20)
			; draw in SCR BUFF3
			DRAW_IMAGE_ZX0_COPY(-$60 + 1)
			dcr b
			jnz @copy_loop
			inr l
			mvi a, 200; height
			cmp l
			jnz @copy_new_line
			ret

@decoded_scr_buff_data:
			lxi h, SCR_BUFF1_ADDR ; hl - ptr to a temporally uncompressed data in the ram-disk backbuffer
@decode_loop:		
			; convert first two color_idxs into 4 pairs of bits, each for the corresponding scr buf
			mov a, m
			ani %1100_0000
			mov c, a

			mov a, m
			ani %0011_0000
			RLC_(2)
			mov b, a

			mov a, m
			ani %0000_1100
			RLC_(4)
			mov e, a

			mov a, m
			ani %0000_0011
			RRC_(2)
			mov d, a
			inx h

			; convert the second two color_idxs into 4 pairs of bits, each for the corresponding scr buf
			mov a, m
			ani %1100_0000
			RRC_(2)
			ora c
			mov c, a

			mov a, m
			ani %0011_0000
			;RRC_(2)
			ora b
			mov b, a

			mov a, m
			ani %0000_1100
			RLC_(2)
			ora e
			mov e, a

			mov a, m
			ani %0000_0011
			RLC_(4)
			ora d
			mov d, a
			inx h

			; convert the third two color_idxs into 4 pairs of bits, each for the corresponding scr buf
			mov a, m
			ani %1100_0000
			RRC_(4)
			ora c
			mov c, a

			mov a, m
			ani %0011_0000
			RRC_(2)
			ora b
			mov b, a

			mov a, m
			ani %0000_1100
			;RRC_(2)
			ora e
			mov e, a

			mov a, m
			ani %0000_0011
			RLC_(2)
			ora d
			mov d, a
			inx h

			; convert the forth two color_idxs into 4 pairs of bits, each for the corresponding scr buf
			mov a, m
			ani %1100_0000
			RLC_(2)
			ora c
			mov c, a

			mov a, m
			ani %0011_0000
			RRC_(4)
			ora b
			mov b, a

			mov a, m
			ani %0000_1100
			RRC_(2)
			ora e
			mov e, a

			mov a, m
			ani %0000_0011
			;RLC_(4)
			ora d
			;mov d, a
			;inx h

			; store decoded scr buff bytes
			mov m, a
			;mov m, d
			dcx h
			mov m, e
			dcx h
			mov m, b
			dcx h
			mov m, c
			; advance hl to the next 4 bytes
			lxi d, 4
			dad d
			jnc @decode_loop
			ret

; in:
; de - compressed data addr
; bc - uncompressed data addr
; a - ram-disk activation command
@unpack:
			lxi b, SCR_BUFF1_ADDR ; bc - ptr to a temporally uncompressed data in the ram-disk backbuffer
			sta @ramDiskCmd1+1
			sta @ramDiskCmd2+1

			lxi h, $ffff
			push h
			inx h
			mvi a,$80
@literals:
			call @elias
@ldir:
			sta @restoreA1+1
@ldir_loop:
			ldax d
			sta @storeA+1
			RAM_DISK_ON(__RAM_DISK_M_BACKBUFF | RAM_DISK_M_8F)
@storeA:
			mvi a, TEMP_BYTE
			stax b
@ramDiskCmd1:
			mvi a, TEMP_BYTE
			RAM_DISK_ON_BANK()

			inx d
			inx b
			dcx h
			mov a, h
			ora l
			jnz @ldir_loop

@restoreA1:
			mvi a, TEMP_BYTE		
			add a

			jc @new_offset
			call @elias
@copy:
			xchg
			xthl
			push h
			dad b
			xchg

@ldir_unpacked:
			sta @restoreA2+1
			RAM_DISK_ON(__RAM_DISK_M_BACKBUFF | RAM_DISK_M_8F)
@ldirUnpackedLoop:
			ldax d
			stax b
			inx d
			inx b
			dcx h
			mov a, h
			ora l
			jnz @ldirUnpackedLoop
@ramDiskCmd2:
			mvi a, TEMP_BYTE
			RAM_DISK_ON_BANK()

@restoreA2:
			mvi a, TEMP_BYTE		
			add a

			xchg
			pop h
			xthl
			xchg
			jnc @literals
@new_offset:
			call @elias
			mov h, a
			pop psw
			xra a
			sub l
			rz
			push h
			rar
			mov h, a
			ldax d
			rar
			mov l, a
			inx d
			xthl
			mov a, h
			lxi h, 1
			cnc @elias_backtrack
			inx h
			jmp @copy

@elias:
			inr l
@elias_loop:
			add a
			jnz @elias_skip
			ldax d
			inx d
			ral
@elias_skip:
			rc
@elias_backtrack:
			dad h
			add a
			jnc @elias_loop
			jmp @elias
			


