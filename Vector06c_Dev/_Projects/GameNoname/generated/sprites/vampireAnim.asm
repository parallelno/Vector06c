; source\sprites\vampire.json
SpriteGetScrAddr_vampire = SpriteGetScrAddr4

vampire_preshifted_sprites:
			.byte 4
vampire_anims:
			.word vampire_idle_r, vampire_idle_l, vampire_run_r, vampire_run_l, 0, 
vampire_idle_r:
			.byte 255, $ff ; offset to the first frame
			.word __vampire_idle_r0_0, __vampire_idle_r0_1, __vampire_idle_r0_2, __vampire_idle_r0_3, 
vampire_idle_l:
			.byte 255, $ff ; offset to the first frame
			.word __vampire_idle_l0_0, __vampire_idle_l0_1, __vampire_idle_l0_2, __vampire_idle_l0_3, 
vampire_run_r:
			.byte 9, 0 ; offset to the next frame
			.word __vampire_run_r0_0, __vampire_run_r0_1, __vampire_run_r0_2, __vampire_run_r0_3, 
			.byte 9, 0 ; offset to the next frame
			.word __vampire_run_r1_0, __vampire_run_r1_1, __vampire_run_r1_2, __vampire_run_r1_3, 
			.byte 9, 0 ; offset to the next frame
			.word __vampire_run_r2_0, __vampire_run_r2_1, __vampire_run_r2_2, __vampire_run_r2_3, 
			.byte 225, $ff ; offset to the first frame
			.word __vampire_run_r3_0, __vampire_run_r3_1, __vampire_run_r3_2, __vampire_run_r3_3, 
vampire_run_l:
			.byte 9, 0 ; offset to the next frame
			.word __vampire_run_l0_0, __vampire_run_l0_1, __vampire_run_l0_2, __vampire_run_l0_3, 
			.byte 9, 0 ; offset to the next frame
			.word __vampire_run_l1_0, __vampire_run_l1_1, __vampire_run_l1_2, __vampire_run_l1_3, 
			.byte 9, 0 ; offset to the next frame
			.word __vampire_run_l2_0, __vampire_run_l2_1, __vampire_run_l2_2, __vampire_run_l2_3, 
			.byte 225, $ff ; offset to the first frame
			.word __vampire_run_l3_0, __vampire_run_l3_1, __vampire_run_l3_2, __vampire_run_l3_3, 
