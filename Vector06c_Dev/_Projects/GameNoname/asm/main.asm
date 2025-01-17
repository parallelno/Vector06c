;.setting "Debug", true
.setting "ShowLocalLabelsAfterCompiling", true

.include "asm\\common\\macro.asm"
.include "asm\\globals\\global_consts.asm"
; main_init must be the first code inclusion

.include "asm\\globals\\main_init.asm"
.include "generated\\code\\ram_disk_consts.asm"

.include "asm\\levels\\room_consts.asm" ; moved from a game.asm over here because of sone compilers issues. it was not able to find some consts

.include "asm\\common\\utils.asm"
.include "asm\\globals\\controls.asm"
.include "asm\\globals\\interruptions.asm"
.include "asm\\game_utils.asm"

.include "asm\\screens\\screen_utils.asm"
.include "asm\\screens\\main_menu.asm"
.include "asm\\screens\\credits.asm"
.include "asm\\screens\\scores.asm"
.include "asm\\screens\\settings.asm"
.include "asm\\screens\\stats.asm"
.include "asm\\game.asm"
.include "asm\\main_data.asm"


main_start:
			CALL_RAM_DISK_FUNC(__sound_init, __RAM_DISK_M_GCPLAYER | RAM_DISK_M_8F)
			lxi b, __font_gfx
			CALL_RAM_DISK_FUNC(__text_ex_rd_init, __RAM_DISK_S_FONT | __RAM_DISK_M_TEXT_EX)
@loop:
			lda global_request
			HL_TO_AX2_PLUS_INT16(main_screens_call_ptrs) ; because GLOBAL_REQ_NONE is excluded from main_screens_call_ptrs
			mov e, m
			inx h
			mov d, m
			lxi h, @loop
			push h
			xchg
			pchl

code_seg_end:

.include "generated\\code\\ram_disk_data_labels.asm"
.include "generated\\code\\ram_data.asm"
text_seg:
.include "generated\\text\\text_rd_data.asm"
rom_seg_end:

;=============================================================================
;
; validation
.if rom_seg_end >= BUFFERS_START_ADDR
	.error "main.asm rom segment ends at (" rom_seg_end ") addr. It overlaps with runtime_data.asm segment starting at (" BUFFERS_START_ADDR ")"
.endif

.end