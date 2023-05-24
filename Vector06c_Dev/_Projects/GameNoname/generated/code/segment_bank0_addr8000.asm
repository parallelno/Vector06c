.org $8000
.include "asm\\globals\\global_consts.asm"
.include "asm\\globals\\macro.asm"
RAM_DISK_S = RAM_DISK_S0
RAM_DISK_M = RAM_DISK_M0

__chunk_start_bank0_addr8000_0:

__level00_data_rd_data_start:
.include "generated\\levels\\level00_data.asm"
__level00_data_rd_data_end:
__backs_sprites_rd_data_start:
.include "generated\\sprites\\backs_sprites.asm"
__backs_sprites_rd_data_end:
__decals_sprites_rd_data_start:
.include "generated\\sprites\\decals_sprites.asm"
__decals_sprites_rd_data_end:
__vfx4_sprites_rd_data_start:
.include "generated\\sprites\\vfx4_sprites.asm"
__vfx4_sprites_rd_data_end:

.align 2
__chunk_end_bank0_addr8000_0:

__chunk_start_bank0_addr8000_1:

__level01_data_rd_data_start:
.include "generated\\levels\\level01_data.asm"
__level01_data_rd_data_end:
__tiled_images_gfx_rd_data_start:
.include "generated\\sprites\\tiled_images_gfx.asm"
__tiled_images_gfx_rd_data_end:
__tiled_images_data_rd_data_start:
.include "generated\\sprites\\tiled_images_data.asm"
__tiled_images_data_rd_data_end:

.align 2
__chunk_end_bank0_addr8000_1:

