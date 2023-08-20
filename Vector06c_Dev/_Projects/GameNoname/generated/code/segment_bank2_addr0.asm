.org 0
.include "asm\\globals\\global_consts.asm"
RAM_DISK_S = RAM_DISK_S2
RAM_DISK_M = RAM_DISK_M2

__chunk_start_bank2_addr0_0:

__hero_l_sprites_rd_data_start:
.include "generated\\sprites\\hero_l_sprites.asm"
__hero_l_sprites_rd_data_end:

.align 2
__chunk_end_bank2_addr0_0:

__chunk_start_bank2_addr0_1:

__vampire_sprites_rd_data_start:
.include "generated\\sprites\\vampire_sprites.asm"
__vampire_sprites_rd_data_end:
__vfx_sprites_rd_data_start:
.include "generated\\sprites\\vfx_sprites.asm"
__vfx_sprites_rd_data_end:

.align 2
__chunk_end_bank2_addr0_1:

