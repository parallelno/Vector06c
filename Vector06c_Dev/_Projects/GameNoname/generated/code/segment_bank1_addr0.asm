.org 0
.include "asm\\globals\\global_consts.asm"
.include "asm\\globals\\macro.asm"
RAM_DISK_S = RAM_DISK_S1
RAM_DISK_M = RAM_DISK_M1

__chunk_start_bank1_addr0_0:

__knight_sprites_rd_data_start:
.include "generated\\sprites\\knight_sprites.asm"
__knight_sprites_rd_data_end:

.align 2
__chunk_end_bank1_addr0_0:

__chunk_start_bank1_addr0_1:

__burner_sprites_rd_data_start:
.include "generated\\sprites\\burner_sprites.asm"
__burner_sprites_rd_data_end:

.align 2
__chunk_end_bank1_addr0_1:

