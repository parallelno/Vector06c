; sources\sprites\knight.json
knight_preshifted_sprites:
			.byte 4
knight_anims:
			.word knight_idle_r, knight_idle_l, knight_run_r, knight_run_l, 0, 
knight_idle_r:
			.byte 255, $ff ; offset to the first frame
			.word __knight_idle_r0_0, __knight_idle_r0_1, __knight_idle_r0_2, __knight_idle_r0_3, 
knight_idle_l:
			.byte 255, $ff ; offset to the first frame
			.word __knight_idle_l0_0, __knight_idle_l0_1, __knight_idle_l0_2, __knight_idle_l0_3, 
knight_run_r:
			.byte 9, 0 ; offset to the next frame
			.word __knight_run_r0_0, __knight_run_r0_1, __knight_run_r0_2, __knight_run_r0_3, 
			.byte 9, 0 ; offset to the next frame
			.word __knight_run_r1_0, __knight_run_r1_1, __knight_run_r1_2, __knight_run_r1_3, 
			.byte 9, 0 ; offset to the next frame
			.word __knight_run_r2_0, __knight_run_r2_1, __knight_run_r2_2, __knight_run_r2_3, 
			.byte 225, $ff ; offset to the first frame
			.word __knight_run_r3_0, __knight_run_r3_1, __knight_run_r3_2, __knight_run_r3_3, 
knight_run_l:
			.byte 9, 0 ; offset to the next frame
			.word __knight_run_l0_0, __knight_run_l0_1, __knight_run_l0_2, __knight_run_l0_3, 
			.byte 9, 0 ; offset to the next frame
			.word __knight_run_l1_0, __knight_run_l1_1, __knight_run_l1_2, __knight_run_l1_3, 
			.byte 9, 0 ; offset to the next frame
			.word __knight_run_l2_0, __knight_run_l2_1, __knight_run_l2_2, __knight_run_l2_3, 
			.byte 225, $ff ; offset to the first frame
			.word __knight_run_l3_0, __knight_run_l3_1, __knight_run_l3_2, __knight_run_l3_3, 
