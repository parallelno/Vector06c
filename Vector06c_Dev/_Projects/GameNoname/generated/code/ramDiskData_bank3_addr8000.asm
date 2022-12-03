.org $8000
__chunkStart_bank3_addr8000_0:

.include "asm\\globals\\globalConsts.asm"
.include "asm\\globals\\macro.asm"
RAM_DISK_S = RAM_DISK_S3
RAM_DISK_M = RAM_DISK_M3

.include "asm\\render\\spriteRD.asm"
.include "asm\\render\\drawSpriteRD.asm"
.include "asm\\globals\\utilsRD.asm"
.include "asm\\render\\spritePreshiftRD.asm"
.align 2
__chunkEnd_bank3_addr8000_0:

