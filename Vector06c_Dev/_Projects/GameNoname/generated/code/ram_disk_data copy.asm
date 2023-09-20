; ram-disk data labels
.include "generated\\code\\segment_bank0_addr0_labels.asm"
.include "generated\\code\\segment_bank0_addr8000_labels.asm"
.include "generated\\code\\segment_bank1_addr0_labels.asm"
.include "generated\\code\\segment_bank1_addr8000_labels.asm"
.include "generated\\code\\segment_bank2_addr0_labels.asm"
.include "generated\\code\\segment_bank2_addr8000_labels.asm"
.include "generated\\code\\segment_bank3_addr0_labels.asm"
.include "generated\\code\\segment_bank3_addr8000_labels.asm"

sprite_anims:
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
; bank0 addr0    [ 4336 free] description: 
;                             hero_r_sprites [13818], skeleton_sprites [10140], scythe_sprites [1626], bomb_sprites [960], font_gfx [1632], 
; bank0 addr8000 [ 9930 free] description: 
;                             level00_data [3779], backs_sprites [620], decals_sprites [4274], vfx4_sprites [4686], level01_data [798], tiled_images_gfx [7702], tiled_images_data [978], 
; bank1 addr0    [ 6514 free] description: 
;                             knight_sprites [16398], burner_sprites [9600], 
; bank1 addr8000 [  962 free] description: $A000-$FFFF backbuffer2 (to restore a background in the backbuffer) 
;                             hero_sword_sprites [7230], 
; bank2 addr0    [ 9418 free] description: 
;                             hero_l_sprites [13818], vampire_sprites [7884], vfx_sprites [1392], 
; bank2 addr8000 [19563 free] description: sound and music must be at >= $8000 addr. $F102-$FFFF music player runtime buffers 
;                             sound_rd [793], song01 [8575], 
; bank3 addr0    [19996 free] description: 
;                             level00_gfx [5722], level01_gfx [6794], 
; bank3 addr8000 [ 1203 free] description: $8000-$9FFF code library. $A000-$FFFF backbuffer (to avoid sprite flickering) 
;                             global_consts_rd [0], sprite_rd [171], draw_sprite_rd [340], draw_sprite_hit_rd [318], draw_sprite_invis_rd [26], utils_rd [87], sprite_preshift_rd [1541], text_ex_rd [389], text_rd [3911], game_score_data_rd [206], 
; [136208 total/35361 compressed][71922 total free]

.if BUFFERS_START_ADDR < ram_disk_data
			.error "the programm is too big. It overlaps with tables at the end of RAM"
.endif