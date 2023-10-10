.org $8000
.include "asm\\globals\\global_consts.asm"
RAM_DISK_S = RAM_DISK_S1
RAM_DISK_M = RAM_DISK_M1

__sword_sprites_rd_data_start:
.include "generated\\sprites\\sword_sprites.asm"
.align 2
__sword_sprites_rd_data_end:
