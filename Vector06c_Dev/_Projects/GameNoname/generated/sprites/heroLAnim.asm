; source\sprites\heroL.json
heroL_preshifted_sprites:
			.byte 4
heroL_anims:
			.word heroL_idle, heroL_run, heroL_attk, 0, 
heroL_idle:
			.byte 9, 0 ; offset to the next frame
			.word __heroL_idle0_0, __heroL_idle0_1, __heroL_idle0_2, __heroL_idle0_3, 
			.byte 9, 0 ; offset to the next frame
			.word __heroL_idle0_0, __heroL_idle0_1, __heroL_idle0_2, __heroL_idle0_3, 
			.byte 9, 0 ; offset to the next frame
			.word __heroL_idle0_0, __heroL_idle0_1, __heroL_idle0_2, __heroL_idle0_3, 
			.byte 225, $ff ; offset to the first frame
			.word __heroL_run2_0, __heroL_run2_1, __heroL_run2_2, __heroL_run2_3, 
heroL_run:
			.byte 9, 0 ; offset to the next frame
			.word __heroL_run0_0, __heroL_run0_1, __heroL_run0_2, __heroL_run0_3, 
			.byte 9, 0 ; offset to the next frame
			.word __heroL_run1_0, __heroL_run1_1, __heroL_run1_2, __heroL_run1_3, 
			.byte 9, 0 ; offset to the next frame
			.word __heroL_run2_0, __heroL_run2_1, __heroL_run2_2, __heroL_run2_3, 
			.byte 225, $ff ; offset to the first frame
			.word __heroL_run3_0, __heroL_run3_1, __heroL_run3_2, __heroL_run3_3, 
heroL_attk:
			.byte 9, 0 ; offset to the next frame
			.word __heroL_attk0_0, __heroL_attk0_1, __heroL_attk0_2, __heroL_attk0_3, 
			.byte 245, $ff ; offset to the first frame
			.word __heroL_attk1_0, __heroL_attk1_1, __heroL_attk1_2, __heroL_attk1_3, 
