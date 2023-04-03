; source\sprites\vfx.json
sprite_get_scr_addr_vfx = sprite_get_scr_addr4

vfx_preshifted_sprites:
			.byte 4
vfx_anims:
			.word vfx_puff, 0, 
vfx_puff:
			.byte 9, 0 ; offset to the next frame
			.word __vfx_puff0_0, __vfx_puff0_1, __vfx_puff0_2, __vfx_puff0_3, 
			.byte 9, 0 ; offset to the next frame
			.word __vfx_puff1_0, __vfx_puff1_1, __vfx_puff1_2, __vfx_puff1_3, 
			.byte 9, 0 ; offset to the next frame
			.word __vfx_puff2_0, __vfx_puff2_1, __vfx_puff2_2, __vfx_puff2_3, 
			.byte -1, $ff ; offset to the same last frame
			.word __vfx_puff3_0, __vfx_puff3_1, __vfx_puff3_2, __vfx_puff3_3, 
