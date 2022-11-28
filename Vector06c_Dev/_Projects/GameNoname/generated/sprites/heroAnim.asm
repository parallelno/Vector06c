; sources\sprites\hero.json
hero_preshifted_sprites:
			.byte 4
hero_anims:
			.word hero_idle_r, hero_idle_l, hero_run_r, hero_run_l, hero_attk_r, hero_attk_l, 0, 
hero_idle_r:
			.byte 9, 0 ; offset to the next frame
			.word __hero_idle_r0_0, __hero_idle_r0_1, __hero_idle_r0_2, __hero_idle_r0_3, 
			.byte 9, 0 ; offset to the next frame
			.word __hero_idle_r0_0, __hero_idle_r0_1, __hero_idle_r0_2, __hero_idle_r0_3, 
			.byte 9, 0 ; offset to the next frame
			.word __hero_idle_r0_0, __hero_idle_r0_1, __hero_idle_r0_2, __hero_idle_r0_3, 
			.byte 225, $ff ; offset to the first frame
			.word __hero_run_r2_0, __hero_run_r2_1, __hero_run_r2_2, __hero_run_r2_3, 
hero_idle_l:
			.byte 9, 0 ; offset to the next frame
			.word __hero_idle_l0_0, __hero_idle_l0_1, __hero_idle_l0_2, __hero_idle_l0_3, 
			.byte 9, 0 ; offset to the next frame
			.word __hero_idle_l0_0, __hero_idle_l0_1, __hero_idle_l0_2, __hero_idle_l0_3, 
			.byte 9, 0 ; offset to the next frame
			.word __hero_idle_l0_0, __hero_idle_l0_1, __hero_idle_l0_2, __hero_idle_l0_3, 
			.byte 225, $ff ; offset to the first frame
			.word __hero_run_l2_0, __hero_run_l2_1, __hero_run_l2_2, __hero_run_l2_3, 
hero_run_r:
			.byte 9, 0 ; offset to the next frame
			.word __hero_run_r0_0, __hero_run_r0_1, __hero_run_r0_2, __hero_run_r0_3, 
			.byte 9, 0 ; offset to the next frame
			.word __hero_run_r1_0, __hero_run_r1_1, __hero_run_r1_2, __hero_run_r1_3, 
			.byte 9, 0 ; offset to the next frame
			.word __hero_run_r2_0, __hero_run_r2_1, __hero_run_r2_2, __hero_run_r2_3, 
			.byte 225, $ff ; offset to the first frame
			.word __hero_run_r3_0, __hero_run_r3_1, __hero_run_r3_2, __hero_run_r3_3, 
hero_run_l:
			.byte 9, 0 ; offset to the next frame
			.word __hero_run_l0_0, __hero_run_l0_1, __hero_run_l0_2, __hero_run_l0_3, 
			.byte 9, 0 ; offset to the next frame
			.word __hero_run_l1_0, __hero_run_l1_1, __hero_run_l1_2, __hero_run_l1_3, 
			.byte 9, 0 ; offset to the next frame
			.word __hero_run_l2_0, __hero_run_l2_1, __hero_run_l2_2, __hero_run_l2_3, 
			.byte 225, $ff ; offset to the first frame
			.word __hero_run_l3_0, __hero_run_l3_1, __hero_run_l3_2, __hero_run_l3_3, 
hero_attk_r:
			.byte 9, 0 ; offset to the next frame
			.word __hero_attk_r0_0, __hero_attk_r0_1, __hero_attk_r0_2, __hero_attk_r0_3, 
			.byte 245, $ff ; offset to the first frame
			.word __hero_attk_r1_0, __hero_attk_r1_1, __hero_attk_r1_2, __hero_attk_r1_3, 
hero_attk_l:
			.byte 9, 0 ; offset to the next frame
			.word __hero_attk_l0_0, __hero_attk_l0_1, __hero_attk_l0_2, __hero_attk_l0_3, 
			.byte 245, $ff ; offset to the first frame
			.word __hero_attk_l1_0, __hero_attk_l1_1, __hero_attk_l1_2, __hero_attk_l1_3, 
