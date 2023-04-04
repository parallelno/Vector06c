; source\sprites\vfx.json
vfx_anims:
			.word vfx_puff, vfx_reward, 0, 
vfx_puff:
			.byte 3, 0 ; offset to the next frame
			.word __vfx_puff0_0, 
			.byte 3, 0 ; offset to the next frame
			.word __vfx_puff0_0, 
			.byte 3, 0 ; offset to the next frame
			.word __vfx_puff1_0, 
			.byte 3, 0 ; offset to the next frame
			.word __vfx_puff2_0, 
			.byte -1, $ff ; offset to the same last frame
			.word __vfx_puff3_0, 
vfx_reward:
			.byte 3, 0 ; offset to the next frame
			.word __vfx_reward0_0, 
			.byte 3, 0 ; offset to the next frame
			.word __vfx_reward1_0, 
			.byte 3, 0 ; offset to the next frame
			.word __vfx_reward3_0, 
			.byte 3, 0 ; offset to the next frame
			.word __vfx_reward2_0, 
			.byte 3, 0 ; offset to the next frame
			.word __vfx_reward3_0, 
			.byte 3, 0 ; offset to the next frame
			.word __vfx_reward0_0, 
			.byte -1, $ff ; offset to the same last frame
			.word __vfx_reward3_0, 
