.org $0
.include "asm\\globals\\global_consts.asm"
RAM_DISK_S = RAM_DISK_S1
RAM_DISK_M = RAM_DISK_M1

__knight_sprites_rd_data_start:
.include "generated\\sprites\\knight_sprites.asm"
.align 2
__knight_sprites_rd_data_end:
__burner_sprites_rd_data_start:
.include "generated\\sprites\\burner_sprites.asm"
.align 2
__burner_sprites_rd_data_end:
