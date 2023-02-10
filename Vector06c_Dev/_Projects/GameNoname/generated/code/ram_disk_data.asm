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
.include "generated\\sprites\\hero_attack01_anim.asm"
.include "generated\\sprites\\torch_anim.asm"
.include "generated\\sprites\\knight_anim.asm"
.include "generated\\sprites\\burner_anim.asm"
.include "generated\\sprites\\bomb_slow_anim.asm"
.include "generated\\sprites\\hero_l_anim.asm"
.include "generated\\sprites\\vampire_anim.asm"

; compressed ram-disk data. They will be unpacked in a reverse order.
segment_bank0_addr0_0.bin:
.incbin "generated\\bin\\segment_bank0_addr0_0.bin.zx0"
segment_bank0_addr0_1.bin:
.incbin "generated\\bin\\segment_bank0_addr0_1.bin.zx0"
segment_bank0_addr8000.bin:
.incbin "generated\\bin\\segment_bank0_addr8000.bin.zx0"
segment_bank1_addr0_0.bin:
.incbin "generated\\bin\\segment_bank1_addr0_0.bin.zx0"
segment_bank1_addr0_1.bin:
.incbin "generated\\bin\\segment_bank1_addr0_1.bin.zx0"
segment_bank2_addr0.bin:
.incbin "generated\\bin\\segment_bank2_addr0.bin.zx0"
segment_bank2_addr8000.bin:
.incbin "generated\\bin\\segment_bank2_addr8000.bin.zx0"
segment_bank3_addr0.bin:
.incbin "generated\\bin\\segment_bank3_addr0.bin.zx0"
segment_bank3_addr8000.bin:
.incbin "generated\\bin\\segment_bank3_addr8000.bin.zx0"

; ram-disk data layout
; bank0 addr0    [ 1054 free] asset_name: size //
;                             hero_r_sprites.asm: 14466
;                             skeleton_sprites.asm: 10140
;                             scythe_sprites.asm: 1626
;                             hero_attack01_sprites.asm: 5226

; bank0 addr8000 [32552 free] asset_name: size //
;                             torch_sprites.asm: 216

; bank1 addr0    [ 5554 free] asset_name: size //
;                             knight_sprites.asm: 16398
;                             burner_sprites.asm: 9600
;                             bomb_slow_sprites.asm: 960

; bank1 addr8000 [    0 free] //$8000-$9FFF tiledata buffer (collision, copyToScr, etc), $A000-$FFFF back buffer2 (to restore a background in the back buffer)
; bank2 addr0    [10162 free] asset_name: size //
;                             hero_l_sprites.asm: 14466
;                             vampire_sprites.asm: 7884

; bank2 addr8000 [19856 free] asset_name: size //Music player and songs
;                             song01.asm: 12542
;                             gigachad_player_rd.asm: 370

; bank3 addr0    [26212 free] asset_name: size //
;                             level01.asm: 6300

; bank3 addr8000 [ 6136 free] asset_name: size //$8000-$9FFF code library. $A000-$FFFF back buffer
;                             sprite_rd.asm: 173
;                             draw_sprite_rd.asm: 544
;                             utils_rd.asm: 87
;                             sprite_preshift_rd.asm: 1538

