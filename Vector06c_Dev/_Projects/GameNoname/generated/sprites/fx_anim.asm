; source\sprites\fx.json
fx_anims:
			.word fx_puff, 0, 
fx_puff:
			.byte 3, 0 ; offset to the next frame
			.word __fx_puff0_0, 
			.byte 3, 0 ; offset to the next frame
			.word __fx_puff1_0, 
			.byte 3, 0 ; offset to the next frame
			.word __fx_puff2_0, 
			.byte -1, $ff ; offset to the same last frame
			.word __fx_puff3_0, 
