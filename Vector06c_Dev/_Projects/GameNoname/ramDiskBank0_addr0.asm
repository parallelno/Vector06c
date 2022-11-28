.setting "ShowLabelsAfterCompiling", true
.org 0
__firstAddrBank0_addr0:

.include "globalConsts.asm"
RAM_DISK_BANK_ACTIVATION_CMD = RAM_DISK_S0

.include "generated\\sprites\\heroSprites.asm"

.align 2
__splitB0_addr0_0:
 
.include "generated\\sprites\\skeletonSprites.asm"
.include "generated\\sprites\\scytheSprites.asm"
.include "generated\\sprites\\hero_attack01Sprites.asm"
.align 2 
__splitB0_addr0_1: