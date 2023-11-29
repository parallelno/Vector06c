ram_disk_data:
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
chunk_bank1_addr8000_0:
.incbin "generated\\bin\\chunk_bank1_addr8000_0.bin.zx0"
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
; bank0 addr0    [ 2796 free] description: 
;                             hero_r_sprites [13818], skeleton_sprites [10140], scythe_sprites [1626], bomb_sprites [960], snowflake_sprites [1332], font_gfx [1840], 
; bank0 addr8000 [ 9500 free] description: 
;                             level00_data [3818], backs_sprites [620], decals_sprites [4446], vfx4_sprites [4686], level01_data [520], tiled_images_gfx [8178], tiled_images_data [1000], 
; bank1 addr0    [ 6514 free] description: 
;                             knight_sprites [16398], burner_sprites [9600], 
; bank1 addr8000 [  308 free] description: $A000-$FFFF backbuffer2 (to restore a background in the backbuffer) 
;                             vampire_sprites [7884], 
; bank2 addr0    [ 6988 free] description: 
;                             hero_l_sprites [13818], sword_sprites [9522], vfx_sprites [2184], 
; bank2 addr8000 [19561 free] description: sound and music must be at >= $8000 addr. $F102-$FFFF music player runtime buffers 
;                             sound_rd [794], song01 [8576], 
; bank3 addr0    [20204 free] description: 
;                             level00_gfx [5722], level01_gfx [6586], 
; bank3 addr8000 [  306 free] description: $8000-$9FFF code library. $A000-$FFFF backbuffer (to avoid sprite flickering)  
;                             global_consts_rd [0], sprite_rd [168], draw_sprite_rd [340], draw_sprite_hit_rd [318], draw_sprite_invis_rd [26], utils_rd [0], sprite_preshift_rd [1542], text_rd_data [4882], text_ex_rd [384], game_score_data_rd [226], 
; [141954 total/37089 compressed][66177 total free]

