.org $0
.include "asm\\globals\\global_consts.asm"
RAM_DISK_S = RAM_DISK_S3
RAM_DISK_M = RAM_DISK_M3

__level00_gfx_rd_data_start:
.include "generated\\levels\\level00_gfx.asm"
.align 2
__level00_gfx_rd_data_end:
__level01_gfx_rd_data_start:
.include "generated\\levels\\level01_gfx.asm"
.align 2
__level01_gfx_rd_data_end:
