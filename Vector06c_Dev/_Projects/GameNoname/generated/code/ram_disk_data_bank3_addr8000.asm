.org $8000
__chunk_start_bank3_addr8000_0:

.include "asm\\globals\\global_consts.asm"
.include "asm\\globals\\macro.asm"
RAM_DISK_S = RAM_DISK_S3
RAM_DISK_M = RAM_DISK_M3

.include "asm\\render\\sprite_rd.asm"
.include "asm\\render\\draw_sprite_rd.asm"
.include "asm\\globals\\utils_rd.asm"
.include "asm\\render\\sprite_preshift_rd.asm"
.align 2
__chunk_end_bank3_addr8000_0:

