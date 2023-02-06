; ram-disk data labels
.include "generated\\code\\ramDiskData_bank0_addr0_labels.asm"
.include "generated\\code\\ramDiskData_bank1_addr0_labels.asm"
.include "generated\\code\\ramDiskData_bank2_addr0_labels.asm"
.include "generated\\code\\ramDiskData_bank2_addr8000_labels.asm"
.include "generated\\code\\ramDiskData_bank3_addr0_labels.asm"
.include "generated\\code\\ramDiskData_bank3_addr8000_labels.asm"

; sprites anims
.include "generated\\sprites\\heroRAnim.asm"
.include "generated\\sprites\\skeletonAnim.asm"
.include "generated\\sprites\\scytheAnim.asm"
.include "generated\\sprites\\hero_attack01Anim.asm"
.include "generated\\sprites\\knightAnim.asm"
.include "generated\\sprites\\burnerAnim.asm"
.include "generated\\sprites\\bomb_slowAnim.asm"
.include "generated\\sprites\\heroLAnim.asm"
.include "generated\\sprites\\vampireAnim.asm"

; compressed ram-disk data. They will be unpacked in a reverse order.
ramDiskData_bank0_addr0_0: ; ['heroR']
.incbin "generated\\bin\\ramDiskData_bank0_addr0_0.bin.zx0"
ramDiskData_bank0_addr0_1: ; ['skeleton', 'scythe', 'hero_attack01']
.incbin "generated\\bin\\ramDiskData_bank0_addr0_1.bin.zx0"
ramDiskData_bank1_addr0_0: ; ['knight']
.incbin "generated\\bin\\ramDiskData_bank1_addr0_0.bin.zx0"
ramDiskData_bank1_addr0_1: ; ['burner', 'bomb_slow']
.incbin "generated\\bin\\ramDiskData_bank1_addr0_1.bin.zx0"
ramDiskData_bank2_addr0: ; ['heroL', 'vampire']
.incbin "generated\\bin\\ramDiskData_bank2_addr0.bin.zx0"
ramDiskData_bank2_addr8000: ; ['song01', 'gigachad16PlayerRD']
.incbin "generated\\bin\\ramDiskData_bank2_addr8000.bin.zx0"
ramDiskData_bank3_addr0: ; ['level01']
.incbin "generated\\bin\\ramDiskData_bank3_addr0.bin.zx0"
ramDiskData_bank3_addr8000: ; ['spriteRD', 'drawSpriteRD', 'utilsRD', 'spritePreshiftRD']
.incbin "generated\\bin\\ramDiskData_bank3_addr8000.bin.zx0"

; ram-disk data layout
; bank0 addr0000 [1054 free]	- sprites:	['heroR', 'skeleton', 'scythe', 'hero_attack01']
; bank0 addr8000 [32768 free]	- empty:
; bank1 addr0000 [5554 free]	- sprites:	['knight', 'burner', 'bomb_slow']
; bank1 addr8000 [0 free]		- $8000-$9FFF tiledata buffer (collision, copyToScr, etc), $A000-$FFFF back buffer2 (to restore a background in the back buffer)
; bank2 addr0000 [10162 free]	- sprites:	['heroL', 'vampire']
; bank2 addr8000 [19856 free]	- music:	['song01', 'gigachad16PlayerRD']
; bank3 addr0000 [26212 free]	- levels:	['level01']
; bank3 addr8000 [6136 free]	- $8000-$9FFF code library. $A000-$FFFF back buffer
