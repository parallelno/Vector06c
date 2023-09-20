.org $8000
.include "asm\\globals\\global_consts.asm"
RAM_DISK_S = RAM_DISK_S2
RAM_DISK_M = RAM_DISK_M2

__sound_rd_rd_data_start:
.include "asm\\globals\\sound_rd.asm"
.align 2
__sound_rd_rd_data_end:
__song01_rd_data_start:
.include "generated\\music\\song01.asm"
.align 2
__song01_rd_data_end:
