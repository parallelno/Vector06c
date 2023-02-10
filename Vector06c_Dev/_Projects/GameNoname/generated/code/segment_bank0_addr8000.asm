.org $8000
__chunk_start_bank0_addr8000_0:

.include "asm\\globals\\global_consts.asm"
.include "asm\\globals\\macro.asm"
RAM_DISK_S = RAM_DISK_S0
RAM_DISK_M = RAM_DISK_M0

__torch_sprites_rd_data_start:
.include "generated\\sprites\\torch_sprites.asm"
__torch_sprites_rd_data_end:

.align 2
__chunk_end_bank0_addr8000_0:

