.org $8000
.include "asm\\globals\\global_consts.asm"
.include "asm\\globals\\macro.asm"
RAM_DISK_S = RAM_DISK_S3
RAM_DISK_M = RAM_DISK_M3

__chunk_start_bank3_addr8000_0:

__sprite_rd_rd_data_start:
.include "asm\\render\\sprite_rd.asm"
__sprite_rd_rd_data_end:
__draw_sprite_rd_rd_data_start:
.include "asm\\render\\draw_sprite_rd.asm"
__draw_sprite_rd_rd_data_end:
__draw_sprite_hit_rd_rd_data_start:
.include "asm\\render\\draw_sprite_hit_rd.asm"
__draw_sprite_hit_rd_rd_data_end:
__draw_sprite_invis_rd_rd_data_start:
.include "asm\\render\\draw_sprite_invis_rd.asm"
__draw_sprite_invis_rd_rd_data_end:
__utils_rd_rd_data_start:
.include "asm\\globals\\utils_rd.asm"
__utils_rd_rd_data_end:
__sprite_preshift_rd_rd_data_start:
.include "asm\\render\\sprite_preshift_rd.asm"
__sprite_preshift_rd_rd_data_end:

.align 2
__chunk_end_bank3_addr8000_0:

; __chunk_start_bank3_addr8000_1:
; reserved. $A000-$FFFF backbuffer (to avoid sprite flickering)

