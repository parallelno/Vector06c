.org 0
.include "asm\\globals\\global_consts.asm"
.include "asm\\globals\\macro.asm"
RAM_DISK_S = RAM_DISK_S0
RAM_DISK_M = RAM_DISK_M0

__chunk_start_bank0_addr0_0:

__hero_r_sprites_rd_data_start:
.include "generated\\sprites\\hero_r_sprites.asm"
__hero_r_sprites_rd_data_end:

.align 2
__chunk_end_bank0_addr0_0:

__chunk_start_bank0_addr0_1:

__skeleton_sprites_rd_data_start:
.include "generated\\sprites\\skeleton_sprites.asm"
__skeleton_sprites_rd_data_end:
__scythe_sprites_rd_data_start:
.include "generated\\sprites\\scythe_sprites.asm"
__scythe_sprites_rd_data_end:
__hero_sword_sprites_rd_data_start:
.include "generated\\sprites\\hero_sword_sprites.asm"
__hero_sword_sprites_rd_data_end:

.align 2
__chunk_end_bank0_addr0_1:

