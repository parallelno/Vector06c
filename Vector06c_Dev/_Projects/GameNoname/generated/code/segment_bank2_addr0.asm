.org $0
.include "asm\\globals\\global_consts.asm"
RAM_DISK_S = RAM_DISK_S2
RAM_DISK_M = RAM_DISK_M2

__hero_l_sprites_rd_data_start:
.include "generated\\sprites\\hero_l_sprites.asm"
.align 2
__hero_l_sprites_rd_data_end:
__sword_sprites_rd_data_start:
.include "generated\\sprites\\sword_sprites.asm"
.align 2
__sword_sprites_rd_data_end:
__vfx_sprites_rd_data_start:
.include "generated\\sprites\\vfx_sprites.asm"
.align 2
__vfx_sprites_rd_data_end:
