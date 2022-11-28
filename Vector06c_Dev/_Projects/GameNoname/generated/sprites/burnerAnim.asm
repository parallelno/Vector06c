; sources\sprites\burner.json
burner_preshifted_sprites:
			.byte 4
burner_anims:
			.word burner_idle_r, burner_idle_l, burner_run_r, burner_run_l, 0, 
burner_idle_r:
			.byte 255, $ff ; offset to the first frame
			.word __burner_idle_r0_0, __burner_idle_r0_1, __burner_idle_r0_2, __burner_idle_r0_3, 
burner_idle_l:
			.byte 255, $ff ; offset to the first frame
			.word __burner_idle_l0_0, __burner_idle_l0_1, __burner_idle_l0_2, __burner_idle_l0_3, 
burner_run_r:
			.byte 9, 0 ; offset to the next frame
			.word __burner_run_r0_0, __burner_run_r0_1, __burner_run_r0_2, __burner_run_r0_3, 
			.byte 9, 0 ; offset to the next frame
			.word __burner_run_r1_0, __burner_run_r1_1, __burner_run_r1_2, __burner_run_r1_3, 
			.byte 9, 0 ; offset to the next frame
			.word __burner_run_r2_0, __burner_run_r2_1, __burner_run_r2_2, __burner_run_r2_3, 
			.byte 225, $ff ; offset to the first frame
			.word __burner_run_r3_0, __burner_run_r3_1, __burner_run_r3_2, __burner_run_r3_3, 
burner_run_l:
			.byte 9, 0 ; offset to the next frame
			.word __burner_run_l0_0, __burner_run_l0_1, __burner_run_l0_2, __burner_run_l0_3, 
			.byte 9, 0 ; offset to the next frame
			.word __burner_run_l1_0, __burner_run_l1_1, __burner_run_l1_2, __burner_run_l1_3, 
			.byte 9, 0 ; offset to the next frame
			.word __burner_run_l2_0, __burner_run_l2_1, __burner_run_l2_2, __burner_run_l2_3, 
			.byte 225, $ff ; offset to the first frame
			.word __burner_run_l3_0, __burner_run_l3_1, __burner_run_l3_2, __burner_run_l3_3, 
