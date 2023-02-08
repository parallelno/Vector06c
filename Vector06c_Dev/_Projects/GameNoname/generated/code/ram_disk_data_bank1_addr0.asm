.org 0
__chunk_start_bank1_addr0_0:

.include "asm\\globals\\global_consts.asm"
.include "asm\\globals\\macro.asm"
RAM_DISK_S = RAM_DISK_S1
RAM_DISK_M = RAM_DISK_M1

.include "generated\\sprites\\knight_sprites.asm"
.align 2
__chunk_end_bank1_addr0_0:

.include "generated\\sprites\\burner_sprites.asm"
.include "generated\\sprites\\bomb_slow_sprites.asm"
.align 2
__chunk_end_bank1_addr0_1:

