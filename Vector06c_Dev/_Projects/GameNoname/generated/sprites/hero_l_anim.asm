; source\sprites\hero_l.json
SpriteGetScrAddr_hero_l = SpriteGetScrAddr8

hero_l_preshifted_sprites:
			.byte 8
hero_l_anims:
			.word hero_l_idle, hero_l_run, hero_l_attk, 0, 
hero_l_idle:
			.byte 17, 0 ; offset to the next frame
			.word __hero_l_idle0_0, __hero_l_idle0_1, __hero_l_idle0_2, __hero_l_idle0_3, __hero_l_idle0_4, __hero_l_idle0_5, __hero_l_idle0_6, __hero_l_idle0_7, 
			.byte 17, 0 ; offset to the next frame
			.word __hero_l_idle0_0, __hero_l_idle0_1, __hero_l_idle0_2, __hero_l_idle0_3, __hero_l_idle0_4, __hero_l_idle0_5, __hero_l_idle0_6, __hero_l_idle0_7, 
			.byte 17, 0 ; offset to the next frame
			.word __hero_l_idle0_0, __hero_l_idle0_1, __hero_l_idle0_2, __hero_l_idle0_3, __hero_l_idle0_4, __hero_l_idle0_5, __hero_l_idle0_6, __hero_l_idle0_7, 
			.byte 201, $ff ; offset to the first frame
			.word __hero_l_run2_0, __hero_l_run2_1, __hero_l_run2_2, __hero_l_run2_3, __hero_l_run2_4, __hero_l_run2_5, __hero_l_run2_6, __hero_l_run2_7, 
hero_l_run:
			.byte 17, 0 ; offset to the next frame
			.word __hero_l_run0_0, __hero_l_run0_1, __hero_l_run0_2, __hero_l_run0_3, __hero_l_run0_4, __hero_l_run0_5, __hero_l_run0_6, __hero_l_run0_7, 
			.byte 17, 0 ; offset to the next frame
			.word __hero_l_run1_0, __hero_l_run1_1, __hero_l_run1_2, __hero_l_run1_3, __hero_l_run1_4, __hero_l_run1_5, __hero_l_run1_6, __hero_l_run1_7, 
			.byte 17, 0 ; offset to the next frame
			.word __hero_l_run2_0, __hero_l_run2_1, __hero_l_run2_2, __hero_l_run2_3, __hero_l_run2_4, __hero_l_run2_5, __hero_l_run2_6, __hero_l_run2_7, 
			.byte 201, $ff ; offset to the first frame
			.word __hero_l_run3_0, __hero_l_run3_1, __hero_l_run3_2, __hero_l_run3_3, __hero_l_run3_4, __hero_l_run3_5, __hero_l_run3_6, __hero_l_run3_7, 
hero_l_attk:
			.byte 17, 0 ; offset to the next frame
			.word __hero_l_attk0_0, __hero_l_attk0_1, __hero_l_attk0_2, __hero_l_attk0_3, __hero_l_attk0_4, __hero_l_attk0_5, __hero_l_attk0_6, __hero_l_attk0_7, 
			.byte -1, $ff ; offset to the first frame
			.word __hero_l_attk1_0, __hero_l_attk1_1, __hero_l_attk1_2, __hero_l_attk1_3, __hero_l_attk1_4, __hero_l_attk1_5, __hero_l_attk1_6, __hero_l_attk1_7, 
