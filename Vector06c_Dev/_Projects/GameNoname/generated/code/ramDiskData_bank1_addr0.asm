.org 0
__chunkStart_bank1_addr0_0:

.include "asm\\globals\\globalConsts.asm"
.include "asm\\globals\\macro.asm"
RAM_DISK_S = RAM_DISK_S1
RAM_DISK_M = RAM_DISK_M1

.include "generated\\sprites\\knightSprites.asm"
.align 2
__chunkEnd_bank1_addr0_0:

.include "generated\\sprites\\burnerSprites.asm"
.include "generated\\sprites\\bomb_slowSprites.asm"
.align 2
__chunkEnd_bank1_addr0_1:

