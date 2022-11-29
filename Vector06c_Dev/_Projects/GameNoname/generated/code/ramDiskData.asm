; ram-disk data labels
.include "generated\\code\\ramDiskData_bank0_addr0_labels.asm"
.include "generated\\code\\ramDiskData_bank0_addr8000_labels.asm"
.include "generated\\code\\ramDiskData_bank1_addr0_labels.asm"
.include "generated\\code\\ramDiskData_bank1_addr8000_labels.asm"
.include "generated\\code\\ramDiskData_bank2_addr8000_labels.asm"

; sprites anims
.include "generated\\sprites\\heroAnim.asm"
.include "generated\\sprites\\skeletonAnim.asm"
.include "generated\\sprites\\scytheAnim.asm"
.include "generated\\sprites\\hero_attack01Anim.asm"
.include "generated\\sprites\\knightAnim.asm"
.include "generated\\sprites\\burnerAnim.asm"
.include "generated\\sprites\\vampireAnim.asm"

; compressed ram-disk data
; ram-disk data has to keep the range from STACK_MIN_ADDR to STACK_MAIN_PROGRAM_ADDR-1 unused,
; because it can be corrupted by the subroutines which manipulate the stack
ramDiskData_bank0_addr0_0:
.incbin "generated\\bin\\ramDiskData_bank0_addr0_0.bin.zx0"
ramDiskData_bank0_addr0_1:
.incbin "generated\\bin\\ramDiskData_bank0_addr0_1.bin.zx0"
ramDiskData_bank0_addr8000:
.incbin "generated\\bin\\ramDiskData_bank0_addr8000.bin.zx0"
ramDiskData_bank1_addr0:
.incbin "generated\\bin\\ramDiskData_bank1_addr0.bin.zx0"
ramDiskData_bank1_addr8000:
.incbin "generated\\bin\\ramDiskData_bank1_addr8000.bin.zx0"
ramDiskData_bank2_addr8000:
.incbin "generated\\bin\\ramDiskData_bank2_addr8000.bin.zx0"

