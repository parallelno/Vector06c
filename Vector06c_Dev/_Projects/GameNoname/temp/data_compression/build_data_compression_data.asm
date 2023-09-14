; ram-disk data labels
.org 0
/*.include "rom\\debug.txt"

.include "generated\\code\\segment_bank0_addr0_labels.asm"
.include "generated\\code\\segment_bank0_addr8000_labels.asm"
.include "generated\\code\\segment_bank1_addr0_labels.asm"
.include "generated\\code\\segment_bank1_addr8000_labels.asm"
.include "generated\\code\\segment_bank2_addr0_labels.asm"
.include "generated\\code\\segment_bank2_addr8000_labels.asm"
.include "generated\\code\\segment_bank3_addr0_labels.asm"
.include "generated\\code\\segment_bank3_addr8000_labels.asm"

;sprite_anims:
.include "generated\\sprites\\hero_r_anim.asm"
.include "generated\\sprites\\skeleton_anim.asm"
.include "generated\\sprites\\scythe_anim.asm"
.include "generated\\sprites\\bomb_anim.asm"
.include "generated\\sprites\\backs_anim.asm"
.include "generated\\sprites\\vfx4_anim.asm"
.include "generated\\sprites\\knight_anim.asm"
.include "generated\\sprites\\burner_anim.asm"
.include "generated\\sprites\\hero_sword_anim.asm"
.include "generated\\sprites\\hero_l_anim.asm"
.include "generated\\sprites\\vampire_anim.asm"
.include "generated\\sprites\\vfx_anim.asm"
*/
;ram_disk_data: ; the addr of this label has to be < BUFFERS_START_ADDR
;chunk_bank0_addr0_0:
.incbin "generated\\bin\\chunk_bank0_addr0_0.bin"
;chunk_bank0_addr0_1:
.incbin "generated\\bin\\chunk_bank0_addr0_1.bin"
;chunk_bank0_addr8000_0:
.incbin "generated\\bin\\chunk_bank0_addr8000_0.bin"
;chunk_bank0_addr8000_1:
.incbin "generated\\bin\\chunk_bank0_addr8000_1.bin"
;chunk_bank1_addr0_0:
.incbin "generated\\bin\\chunk_bank1_addr0_0.bin"
;chunk_bank1_addr0_1:
.incbin "generated\\bin\\chunk_bank1_addr0_1.bin"
;chunk_bank1_addr8000_0:
.incbin "generated\\bin\\chunk_bank1_addr8000_0.bin"
;chunk_bank2_addr0_0:
.incbin "generated\\bin\\chunk_bank2_addr0_0.bin"
;chunk_bank2_addr0_1:
.incbin "generated\\bin\\chunk_bank2_addr0_1.bin"
;chunk_bank3_addr0_0:
.incbin "generated\\bin\\chunk_bank3_addr0_0.bin"
;chunk_bank3_addr0_1:
.incbin "generated\\bin\\chunk_bank3_addr0_1.bin"
;chunk_bank2_addr8000_0:
.incbin "generated\\bin\\chunk_bank2_addr8000_0.bin"
;chunk_bank3_addr8000_0:
.incbin "generated\\bin\\chunk_bank3_addr8000_0.bin"