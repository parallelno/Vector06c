; source\sprites\heroR.json
heroR_preshifted_sprites:
			.byte 4
heroR_anims:
			.word heroR_idle, heroR_run, heroR_attk, 0, 
heroR_idle:
			.byte 9, 0 ; offset to the next frame
			.word __heroR_idle0_0, __heroR_idle0_1, __heroR_idle0_2, __heroR_idle0_3, 
			.byte 9, 0 ; offset to the next frame
			.word __heroR_idle0_0, __heroR_idle0_1, __heroR_idle0_2, __heroR_idle0_3, 
			.byte 9, 0 ; offset to the next frame
			.word __heroR_idle0_0, __heroR_idle0_1, __heroR_idle0_2, __heroR_idle0_3, 
			.byte 225, $ff ; offset to the first frame
			.word __heroR_run2_0, __heroR_run2_1, __heroR_run2_2, __heroR_run2_3, 
heroR_run:
			.byte 9, 0 ; offset to the next frame
			.word __heroR_run0_0, __heroR_run0_1, __heroR_run0_2, __heroR_run0_3, 
			.byte 9, 0 ; offset to the next frame
			.word __heroR_run1_0, __heroR_run1_1, __heroR_run1_2, __heroR_run1_3, 
			.byte 9, 0 ; offset to the next frame
			.word __heroR_run2_0, __heroR_run2_1, __heroR_run2_2, __heroR_run2_3, 
			.byte 225, $ff ; offset to the first frame
			.word __heroR_run3_0, __heroR_run3_1, __heroR_run3_2, __heroR_run3_3, 
heroR_attk:
			.byte 9, 0 ; offset to the next frame
			.word __heroR_attk0_0, __heroR_attk0_1, __heroR_attk0_2, __heroR_attk0_3, 
			.byte 245, $ff ; offset to the first frame
			.word __heroR_attk1_0, __heroR_attk1_1, __heroR_attk1_2, __heroR_attk1_3, 
