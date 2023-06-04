; TODO: make it to include automatically
.include "generated\\sprites\\font_gfx_ptrs.asm"

__RAM_DISK_M_TEXT_EX = RAM_DISK_M | RAM_DISK_M_89
LINE_SPACING_DEFAULT = -12
PARAG_SPACING_DEFAULT = -24

; convert local labels into global
; call ex. CALL_RAM_DISK_FUNC(__draw_text_ex_rd_init, __RAM_DISK_S_FONT | __RAM_DISK_M_TEXT_EX)
; in:
; bc - __font_gfx addr
__draw_text_ex_rd_init:
			mvi a, GFX_PTRS_LEN
			lxi h, font_gfx_ptrs
@loop:		
			mov e, m
			inx h
			mov d, m
			xchg
			dad b
			xchg
			mov m, d
			dcx h
			mov m, e
			INX_H(2)
			dcr a
			jnz @loop
			ret

; set a default line and a paragraph spacing
__draw_text_ex_rd_reset_spacing:
			mvi a, LINE_SPACING_DEFAULT
			sta draw_text_ex_rd_line_spacing + 1

			mvi a, PARAG_SPACING_DEFAULT
			sta draw_text_ex_rd_parag_spacing + 1
			ret

; set a line and a paragraph spacing
; in:
; c - line spacing
; b - paragraph spacing
__draw_text_ex_rd_set_spacing:
			lxi h, draw_text_ex_rd_line_spacing + 1
			mov m, c
			lxi h, draw_text_ex_rd_parag_spacing + 1
			mov m, b
			ret

; draw a text with kerning. blend func - OR
; char_id = 0 is EOD
; char_id = LINE_BREAK is a new line
; in:
; hl - text addr
; bc - pos_xy
; call ex. CALL_RAM_DISK_FUNC(__draw_text_ex_rd_scr1, __RAM_DISK_S_FONT | __RAM_DISK_M_TEXT_EX)
__draw_text_ex_rd_scr3:
			mvi a, >SCR_BUFF3_ADDR
			jmp draw_text_ex_rd
__draw_text_ex_rd_scr2:
			mvi a, >SCR_BUFF2_ADDR
			jmp draw_text_ex_rd
__draw_text_ex_rd_scr1:
			mvi a, >SCR_BUFF1_ADDR
; draw a text with kerning. blend func - OR
; a - scr buff high addr, ex: >SCR_BUFF0_ADDR			
draw_text_ex_rd:
			sta @scr_buff_addr+1
			; store pox_x
			mov a, b
			sta draw_text_ex_rd_restore_pos_x + 1
@next_char:			
			; get a char code
			mov e, m
			; return if its code 0
			xra a
			ora e
			rz
			inx h			
			; a - char_code
			; check if it is the end of the line
			cpi <LINE_BREAK
			jz draw_text_ex_rd_line_spacing
			; check if it is the end of the line
			cpi <PARAG_BREAK
			jz draw_text_ex_rd_parag_spacing

			mvi d, 0
			push h ; preserve the text data ptr
			push b ; preserve pos_xy

			; get a char gfx pptr
			xchg
			dad h
			lxi d, font_gfx_ptrs - ADDR_LEN ; because there is no char_code = 0
			dad d
			; hl points to char gfx ptr
			; get a char gfx ptr
			mov e, m
			inx h
			mov d, m

			; preserve SP
			lxi h, 0
			dad sp
			shld @restoreSP + 1
			xchg
			; hl points to a char gfx
			sphl
			mov h, b
			mov l, c
			; hl - scr pos

			; add a pos_xy offset
			pop b
			dad b

			; calc a pxl shift
			mvi a, %111
			ana h
			; make a ptr to skip_dad dad h
			rlc
			adi <@skip_dad_ptrs
			mov e, a
			mvi a, >@skip_dad_ptrs
			aci 0
			mov d, a

			; read skip_ptr
			xchg
			mov a, m
			inx h
			mov h, m
			mov l, a
			shld @skip_dad + 1

			; de - scr pos
			; pos_xy to scr addr
			mvi a, %11111000
			ana d
			RRC_(3)
@scr_buff_addr:			
			adi TEMP_ADDR;>SCR_BUFF1_ADDR
			mov d, a

			; draw a char
@loop:
			; de - scr addr
			; shift a pair of gfx bytes
			pop b
			; check if it is the end of the char gfx
			xra a
			ora b
			jnz @advancePos
			mov l, c
			mov h, b
@skip_dad:	jmp TEMP_ADDR

@shift1:	dad h
@shift2:	dad h
@shift3:	dad h
@shift4:	dad h
@shift5:	dad h
@shift6:	dad h
@shift7:	dad h

			ldax d
			ora h
			stax d
			inr d
			ldax d
			ora l
			stax d
			dcr d
			inr e
			jmp @loop

@shift0:
			ldax d
			ora c
			stax d
			inr e
			jmp @loop			

@advancePos:
			; bc - a pos offset
@restoreSP:
			lxi sp, TEMP_ADDR
			pop h ; restore pos_xy
			; advance a pos_xy to the next char
			dad b
			mov b, h
			mov c, l
			pop h ; retore text addr
			jmp @next_char
@skip_dad_ptrs:
			.word @shift0, @shift1,	@shift2, @shift3, @shift4, @shift5, @shift6, @shift7

draw_text_ex_rd_next_char: = @next_char

; move a position to the next paragraph
draw_text_ex_rd_parag_spacing:
			mvi a, PARAG_SPACING_DEFAULT
			add c
			mov c, a
			jmp draw_text_ex_rd_restore_pos_x
; move a position to the next line
draw_text_ex_rd_line_spacing:
			mvi a, LINE_SPACING_DEFAULT
			add c
			mov c, a
draw_text_ex_rd_restore_pos_x:
			mvi b, TEMP_BYTE			
			jmp draw_text_ex_rd_next_char