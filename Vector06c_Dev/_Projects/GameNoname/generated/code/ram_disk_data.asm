; ram-disk data labels
.include "generated\\code\\segment_bank0_addr0_labels.asm"
.include "generated\\code\\segment_bank0_addr8000_labels.asm"
.include "generated\\code\\segment_bank1_addr0_labels.asm"
.include "generated\\code\\segment_bank2_addr0_labels.asm"
.include "generated\\code\\segment_bank2_addr8000_labels.asm"
.include "generated\\code\\segment_bank3_addr0_labels.asm"
.include "generated\\code\\segment_bank3_addr8000_labels.asm"

; main-ram data (sprite anims, etc.)
.include "generated\\sprites\\hero_r_anim.asm"
.include "generated\\sprites\\skeleton_anim.asm"
.include "generated\\sprites\\scythe_anim.asm"
.include "generated\\sprites\\hero_sword_anim.asm"
.include "generated\\sprites\\bomb_anim.asm"
.include "generated\\sprites\\backs_anim.asm"
.include "generated\\sprites\\knight_anim.asm"
.include "generated\\sprites\\burner_anim.asm"
.include "generated\\sprites\\fx_anim.asm"
.include "generated\\sprites\\hero_l_anim.asm"
.include "generated\\sprites\\vampire_anim.asm"

ram_disk_data: ; the addr of this label has to be < BUFFERS_START_ADDR
chunk_bank0_addr0_0:
.incbin "generated\\bin\\chunk_bank0_addr0_0.bin.zx0"
chunk_bank0_addr0_1:
.incbin "generated\\bin\\chunk_bank0_addr0_1.bin.zx0"
chunk_bank0_addr8000_0:
.incbin "generated\\bin\\chunk_bank0_addr8000_0.bin.zx0"
chunk_bank1_addr0_0:
.incbin "generated\\bin\\chunk_bank1_addr0_0.bin.zx0"
chunk_bank1_addr0_1:
.incbin "generated\\bin\\chunk_bank1_addr0_1.bin.zx0"
chunk_bank2_addr0_0:
.incbin "generated\\bin\\chunk_bank2_addr0_0.bin.zx0"
chunk_bank2_addr0_1:
.incbin "generated\\bin\\chunk_bank2_addr0_1.bin.zx0"
chunk_bank3_addr0_0:
.incbin "generated\\bin\\chunk_bank3_addr0_0.bin.zx0"
chunk_bank2_addr8000_0:
.incbin "generated\\bin\\chunk_bank2_addr8000_0.bin.zx0"
chunk_bank3_addr8000_0:
.incbin "generated\\bin\\chunk_bank3_addr8000_0.bin.zx0"

; ram-disk data layout
; bank0 addr0    [   94 free] description: 
;                             hero_r_sprites [14466], skeleton_sprites [10140], scythe_sprites [1626], hero_sword_sprites [5226], bomb_sprites [960], 
; bank0 addr8000 [27837 free] description: 
;                             level01_data [795], backs_sprites [496], decals_sprites [3640], 
; bank1 addr0    [ 5818 free] description: 
;                             knight_sprites [16398], burner_sprites [9600], fx_sprites [696],
; bank1 addr8000 [    0 free] description: $8000-$9FFF tiledata buffer (collision, copyToScr, etc), $A000-$FFFF back buffer2 (to restore a background in the back buffer)
; bank2 addr0    [10162 free] description: 
;                             hero_l_sprites [14466], vampire_sprites [7884], 
; bank2 addr8000 [19521 free] description: Music player and songs
;                             song01 [12542], sound_rd [705], 
; bank3 addr0    [25880 free] description: 
;                             level01_gfx [6632], 
; bank3 addr8000 [ 5993 free] description: $8000-$9FFF code library. $A000-$FFFF back buffer
;                             sprite_rd [173], draw_sprite_rd [340], draw_sprite_hit_rd [318], draw_sprite_invis_rd [26], utils_rd [87], sprite_preshift_rd [1541], 
; [95305 total free]

.if BUFFERS_START_ADDR < ram_disk_data
			.error "the programm is too big. It overlaps with tables at the end of RAM"
.endif
