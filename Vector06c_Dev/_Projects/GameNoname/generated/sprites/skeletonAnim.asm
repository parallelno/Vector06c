; sources\sprites\skeleton.json
skeleton_preshifted_sprites:
			.byte 4
skeleton_anims:
			.word skeleton_idle_r, skeleton_idle_l, skeleton_run_r, skeleton_run_l, 0, 
skeleton_idle_r:
			.byte 255, $ff ; offset to the first frame
			.word skeleton_idle_r0_0, skeleton_idle_r0_1, skeleton_idle_r0_2, skeleton_idle_r0_3, 
skeleton_idle_l:
			.byte 255, $ff ; offset to the first frame
			.word skeleton_idle_l0_0, skeleton_idle_l0_1, skeleton_idle_l0_2, skeleton_idle_l0_3, 
skeleton_run_r:
			.byte 9, 0 ; offset to the next frame
			.word skeleton_run_r0_0, skeleton_run_r0_1, skeleton_run_r0_2, skeleton_run_r0_3, 
			.byte 9, 0 ; offset to the next frame
			.word skeleton_run_r1_0, skeleton_run_r1_1, skeleton_run_r1_2, skeleton_run_r1_3, 
			.byte 9, 0 ; offset to the next frame
			.word skeleton_run_r2_0, skeleton_run_r2_1, skeleton_run_r2_2, skeleton_run_r2_3, 
			.byte 225, $ff ; offset to the first frame
			.word skeleton_run_r3_0, skeleton_run_r3_1, skeleton_run_r3_2, skeleton_run_r3_3, 
skeleton_run_l:
			.byte 9, 0 ; offset to the next frame
			.word skeleton_run_l0_0, skeleton_run_l0_1, skeleton_run_l0_2, skeleton_run_l0_3, 
			.byte 9, 0 ; offset to the next frame
			.word skeleton_run_l1_0, skeleton_run_l1_1, skeleton_run_l1_2, skeleton_run_l1_3, 
			.byte 9, 0 ; offset to the next frame
			.word skeleton_run_l2_0, skeleton_run_l2_1, skeleton_run_l2_2, skeleton_run_l2_3, 
			.byte 225, $ff ; offset to the first frame
			.word skeleton_run_l3_0, skeleton_run_l3_1, skeleton_run_l3_2, skeleton_run_l3_3, 
