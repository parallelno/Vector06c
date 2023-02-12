.org 0
.include "asm\\globals\\global_consts.asm"
.include "asm\\globals\\macro.asm"
RAM_DISK_S = RAM_DISK_S3
RAM_DISK_M = RAM_DISK_M3

__chunk_start_bank3_addr0_0:

__level01_rd_data_start:
.include "generated\\levels\\level01.asm"
__level01_rd_data_end:

.align 2
__chunk_end_bank3_addr0_0:

