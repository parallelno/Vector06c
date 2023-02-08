; ram-disk data labels
.include "generated\\code\\ram_disk_data_bank0_addr0_labels.asm"
.include "generated\\code\\ram_disk_data_bank1_addr0_labels.asm"
.include "generated\\code\\ram_disk_data_bank2_addr0_labels.asm"
.include "generated\\code\\ram_disk_data_bank2_addr8000_labels.asm"
.include "generated\\code\\ram_disk_data_bank3_addr0_labels.asm"
.include "generated\\code\\ram_disk_data_bank3_addr8000_labels.asm"

; sprites anims
.include "generated\\sprites\\hero_r_anim.asm"
.include "generated\\sprites\\skeleton_anim.asm"
.include "generated\\sprites\\scythe_anim.asm"
.include "generated\\sprites\\hero_attack01_anim.asm"
.include "generated\\sprites\\knight_anim.asm"
.include "generated\\sprites\\burner_anim.asm"
.include "generated\\sprites\\bomb_slow_anim.asm"
.include "generated\\sprites\\hero_l_anim.asm"
.include "generated\\sprites\\vampire_anim.asm"

; compressed ram-disk data. They will be unpacked in a reverse order.
ram_disk_data_bank0_addr0_0: ; ['hero_r']
.incbin "generated\\bin\\ram_disk_data_bank0_addr0_0.bin.zx0"
ram_disk_data_bank0_addr0_1: ; ['skeleton', 'scythe', 'hero_attack01']
.incbin "generated\\bin\\ram_disk_data_bank0_addr0_1.bin.zx0"
ram_disk_data_bank1_addr0_0: ; ['knight']
.incbin "generated\\bin\\ram_disk_data_bank1_addr0_0.bin.zx0"
ram_disk_data_bank1_addr0_1: ; ['burner', 'bomb_slow']
.incbin "generated\\bin\\ram_disk_data_bank1_addr0_1.bin.zx0"
ram_disk_data_bank2_addr0: ; ['hero_l', 'vampire']
.incbin "generated\\bin\\ram_disk_data_bank2_addr0.bin.zx0"
ram_disk_data_bank2_addr8000: ; ['song01', 'gigachad_player_rd']
.incbin "generated\\bin\\ram_disk_data_bank2_addr8000.bin.zx0"
ram_disk_data_bank3_addr0: ; ['level01']
.incbin "generated\\bin\\ram_disk_data_bank3_addr0.bin.zx0"
ram_disk_data_bank3_addr8000: ; ['sprite_rd', 'draw_sprite_rd', 'utils_rd', 'sprite_preshift_rd']
.incbin "generated\\bin\\ram_disk_data_bank3_addr8000.bin.zx0"

; ram-disk data layout
; bank0 addr0000 [1054 free]	- sprites:	['hero_r', 'skeleton', 'scythe', 'hero_attack01']
; bank0 addr8000 [32768 free]	- empty:
; bank1 addr0000 [5554 free]	- sprites:	['knight', 'burner', 'bomb_slow']
; bank1 addr8000 [0 free]		- $8000-$9FFF tiledata buffer (collision, copyToScr, etc), $A000-$FFFF back buffer2 (to restore a background in the back buffer)
; bank2 addr0000 [10162 free]	- sprites:	['hero_l', 'vampire']
; bank2 addr8000 [19856 free]	- music:	['song01', 'gigachad_player_rd']
; bank3 addr0000 [26212 free]	- levels:	['level01']
; bank3 addr8000 [6136 free]	- $8000-$9FFF code library. $A000-$FFFF back buffer
