.org $8000
.include "asm\\globals\\global_consts.asm"
.include "asm\\globals\\macro.asm"
RAM_DISK_S = RAM_DISK_S1
RAM_DISK_M = RAM_DISK_M1

__chunk_start_bank1_addr8000_0:

__vfx_sprites_rd_data_start:
.include "generated\\sprites\\vfx_sprites.asm"
__vfx_sprites_rd_data_end:
__hero_sword_sprites_rd_data_start:
.include "generated\\sprites\\hero_sword_sprites.asm"
__hero_sword_sprites_rd_data_end:

.align 2
__chunk_end_bank1_addr8000_0:

; __chunk_start_bank1_addr8000_1:
; reserved. $A000-$FFFF backbuffer2 (to restore a background in the backbuffer)

