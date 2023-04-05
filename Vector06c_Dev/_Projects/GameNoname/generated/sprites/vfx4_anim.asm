; source\sprites\vfx4.json
sprite_get_scr_addr_vfx4 = sprite_get_scr_addr4

vfx4_preshifted_sprites:
			.byte 4
vfx4_anims:
			.word vfx4_hit, 0, 
vfx4_hit:
			.byte 9, 0 ; offset to the next frame
			.word __vfx4_hit0_0, __vfx4_hit0_1, __vfx4_hit0_2, __vfx4_hit0_3, 
			.byte 9, 0 ; offset to the next frame
			.word __vfx4_hit0_0, __vfx4_hit0_1, __vfx4_hit0_2, __vfx4_hit0_3, 
			.byte 9, 0 ; offset to the next frame
			.word __vfx4_hit1_0, __vfx4_hit1_1, __vfx4_hit1_2, __vfx4_hit1_3, 
			.byte 9, 0 ; offset to the next frame
			.word __vfx4_hit2_0, __vfx4_hit2_1, __vfx4_hit2_2, __vfx4_hit2_3, 
			.byte -1, $ff ; offset to the same last frame
			.word __vfx4_hit3_0, __vfx4_hit3_1, __vfx4_hit3_2, __vfx4_hit3_3, 
