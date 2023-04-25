.org $8000
.include "asm\\globals\\global_consts.asm"
.include "asm\\globals\\macro.asm"
RAM_DISK_S = RAM_DISK_S2
RAM_DISK_M = RAM_DISK_M2

__chunk_start_bank2_addr8000_0:

__sound_rd_rd_data_start:
.include "asm\\globals\\sound_rd.asm"
__sound_rd_rd_data_end:
__song01_rd_data_start:
.include "generated\\music\\song01.asm"
__song01_rd_data_end:

.align 2
__chunk_end_bank2_addr8000_0:

; __chunk_start_bank2_addr8000_1:
; reserved. $F102-$FFFF music player runtime buffers

