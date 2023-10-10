.org $0
.include "asm\\globals\\global_consts.asm"
RAM_DISK_S = RAM_DISK_S0
RAM_DISK_M = RAM_DISK_M0

__hero_r_sprites_rd_data_start:
.include "generated\\sprites\\hero_r_sprites.asm"
.align 2
__hero_r_sprites_rd_data_end:
__skeleton_sprites_rd_data_start:
.include "generated\\sprites\\skeleton_sprites.asm"
.align 2
__skeleton_sprites_rd_data_end:
__scythe_sprites_rd_data_start:
.include "generated\\sprites\\scythe_sprites.asm"
.align 2
__scythe_sprites_rd_data_end:
__bomb_sprites_rd_data_start:
.include "generated\\sprites\\bomb_sprites.asm"
.align 2
__bomb_sprites_rd_data_end:
__snowflake_sprites_rd_data_start:
.include "generated\\sprites\\snowflake_sprites.asm"
.align 2
__snowflake_sprites_rd_data_end:
__font_gfx_rd_data_start:
.include "generated\\sprites\\font_gfx.asm"
.align 2
__font_gfx_rd_data_end:
