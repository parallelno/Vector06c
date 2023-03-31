; source\sprites\fx.json
sprite_get_scr_addr_fx = sprite_get_scr_addr4

fx_preshifted_sprites:
			.byte 4
fx_anims:
			.word fx_puff, 0, 
fx_puff:
			.byte 9, 0 ; offset to the next frame
			.word __fx_puff0_0, __fx_puff0_1, __fx_puff0_2, __fx_puff0_3, 
			.byte 9, 0 ; offset to the next frame
			.word __fx_puff1_0, __fx_puff1_1, __fx_puff1_2, __fx_puff1_3, 
			.byte 9, 0 ; offset to the next frame
			.word __fx_puff2_0, __fx_puff2_1, __fx_puff2_2, __fx_puff2_3, 
			.byte -1, $ff ; offset to the first frame
			.word __fx_puff3_0, __fx_puff3_1, __fx_puff3_2, __fx_puff3_3, 
