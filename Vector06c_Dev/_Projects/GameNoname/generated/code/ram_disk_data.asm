; ram-disk data labels
.include "generated\\code\\segment_bank0_addr0_labels.asm"
.include "generated\\code\\segment_bank0_addr8000_labels.asm"
.include "generated\\code\\segment_bank1_addr0_labels.asm"
.include "generated\\code\\segment_bank1_addr8000_labels.asm"
.include "generated\\code\\segment_bank2_addr0_labels.asm"
.include "generated\\code\\segment_bank2_addr8000_labels.asm"
.include "generated\\code\\segment_bank3_addr0_labels.asm"
.include "generated\\code\\segment_bank3_addr8000_labels.asm"

; main-ram data (sprite anims, etc.)
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

ram_disk_data: ; the addr of this label has to be < BUFFERS_START_ADDR
chunk_bank0_addr0_0:
.incbin "generated\\bin\\chunk_bank0_addr0_0.bin.zx0"
chunk_bank0_addr0_1:
.incbin "generated\\bin\\chunk_bank0_addr0_1.bin.zx0"
chunk_bank0_addr8000_0:
.incbin "generated\\bin\\chunk_bank0_addr8000_0.bin.zx0"
chunk_bank0_addr8000_1:
.incbin "generated\\bin\\chunk_bank0_addr8000_1.bin.zx0"
chunk_bank1_addr0_0:
.incbin "generated\\bin\\chunk_bank1_addr0_0.bin.zx0"
chunk_bank1_addr0_1:
.incbin "generated\\bin\\chunk_bank1_addr0_1.bin.zx0"
chunk_bank1_addr8000_0:
.incbin "generated\\bin\\chunk_bank1_addr8000_0.bin.zx0"
chunk_bank2_addr0_0:
.incbin "generated\\bin\\chunk_bank2_addr0_0.bin.zx0"
chunk_bank2_addr0_1:
.incbin "generated\\bin\\chunk_bank2_addr0_1.bin.zx0"
chunk_bank3_addr0_0:
.incbin "generated\\bin\\chunk_bank3_addr0_0.bin.zx0"
chunk_bank3_addr0_1:
.incbin "generated\\bin\\chunk_bank3_addr0_1.bin.zx0"
chunk_bank2_addr8000_0:
.incbin "generated\\bin\\chunk_bank2_addr8000_0.bin.zx0"
chunk_bank3_addr8000_0:
.incbin "generated\\bin\\chunk_bank3_addr8000_0.bin.zx0"

; ram-disk data layout
; bank0 addr0    [ 3712 free] description: 
;                             hero_r_sprites [14466], skeleton_sprites [10140], scythe_sprites [1626], bomb_sprites [960], font_gfx [1608], 
; bank0 addr8000 [14151 free] description: 
;                             level00_data [196], backs_sprites [620], decals_sprites [3640], vfx4_sprites [4686], level01_data [795], tiled_images_gfx [7702], tiled_images_data [978], 
; bank1 addr0    [ 6514 free] description: 
;                             knight_sprites [16398], burner_sprites [9600], 
; bank1 addr8000 [ 2966 free] description: $A000-$FFFF backbuffer2 (to restore a background in the backbuffer) 
;                             hero_sword_sprites [5226], 
; bank2 addr0    [ 8806 free] description: 
;                             hero_l_sprites [14466], vampire_sprites [7884], vfx_sprites [1356], 
; bank2 addr8000 [19563 free] description: sound and music must be at >= $8000 addr. $F102-$FFFF music player runtime buffers 
;                             sound_rd [793], song01 [8575], 
; bank3 addr0    [21044 free] description: 
;                             level00_gfx [4834], level01_gfx [6634], 
; bank3 addr8000 [ 4388 free] description: $8000-$9FFF code library. $A000-$FFFF backbuffer (to avoid sprite flickering) 
;                             sprite_rd [172], draw_sprite_rd [340], draw_sprite_hit_rd [318], draw_sprite_invis_rd [26], utils_rd [87], sprite_preshift_rd [1541], draw_text_ex_rd [390], text_rd [930], 
; [126987 total/27918 compressed][81144 total free]

.if BUFFERS_START_ADDR < ram_disk_data
			.error "the programm is too big. It overlaps with tables at the end of RAM"
.endif
