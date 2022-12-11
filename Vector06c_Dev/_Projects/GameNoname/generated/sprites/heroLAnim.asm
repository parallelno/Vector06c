; source\sprites\heroL.json
SpriteGetScrAddr_heroL = SpriteGetScrAddr8

heroL_preshifted_sprites:
			.byte 8
heroL_anims:
			.word heroL_idle, heroL_run, heroL_attk, 0, 
heroL_idle:
			.byte 17, 0 ; offset to the next frame
			.word __heroL_idle0_0, __heroL_idle0_1, __heroL_idle0_2, __heroL_idle0_3, __heroL_idle0_4, __heroL_idle0_5, __heroL_idle0_6, __heroL_idle0_7, 
			.byte 17, 0 ; offset to the next frame
			.word __heroL_idle0_0, __heroL_idle0_1, __heroL_idle0_2, __heroL_idle0_3, __heroL_idle0_4, __heroL_idle0_5, __heroL_idle0_6, __heroL_idle0_7, 
			.byte 17, 0 ; offset to the next frame
			.word __heroL_idle0_0, __heroL_idle0_1, __heroL_idle0_2, __heroL_idle0_3, __heroL_idle0_4, __heroL_idle0_5, __heroL_idle0_6, __heroL_idle0_7, 
			.byte 201, $ff ; offset to the first frame
			.word __heroL_run2_0, __heroL_run2_1, __heroL_run2_2, __heroL_run2_3, __heroL_run2_4, __heroL_run2_5, __heroL_run2_6, __heroL_run2_7, 
heroL_run:
			.byte 17, 0 ; offset to the next frame
			.word __heroL_run0_0, __heroL_run0_1, __heroL_run0_2, __heroL_run0_3, __heroL_run0_4, __heroL_run0_5, __heroL_run0_6, __heroL_run0_7, 
			.byte 17, 0 ; offset to the next frame
			.word __heroL_run1_0, __heroL_run1_1, __heroL_run1_2, __heroL_run1_3, __heroL_run1_4, __heroL_run1_5, __heroL_run1_6, __heroL_run1_7, 
			.byte 17, 0 ; offset to the next frame
			.word __heroL_run2_0, __heroL_run2_1, __heroL_run2_2, __heroL_run2_3, __heroL_run2_4, __heroL_run2_5, __heroL_run2_6, __heroL_run2_7, 
			.byte 201, $ff ; offset to the first frame
			.word __heroL_run3_0, __heroL_run3_1, __heroL_run3_2, __heroL_run3_3, __heroL_run3_4, __heroL_run3_5, __heroL_run3_6, __heroL_run3_7, 
heroL_attk:
			.byte 17, 0 ; offset to the next frame
			.word __heroL_attk0_0, __heroL_attk0_1, __heroL_attk0_2, __heroL_attk0_3, __heroL_attk0_4, __heroL_attk0_5, __heroL_attk0_6, __heroL_attk0_7, 
			.byte -1, $ff ; offset to the first frame
			.word __heroL_attk1_0, __heroL_attk1_1, __heroL_attk1_2, __heroL_attk1_3, __heroL_attk1_4, __heroL_attk1_5, __heroL_attk1_6, __heroL_attk1_7, 
