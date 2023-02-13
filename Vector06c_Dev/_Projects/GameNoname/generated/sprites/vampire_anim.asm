; source\sprites\vampire.json
sprite_get_scr_addr_vampire = sprite_get_scr_addr4

vampire_preshifted_sprites:
			.byte 4
vampire_anims:
			.word vampire_idle, vampire_run_r, vampire_run_l, vampire_cast, 0, 
vampire_idle:
			.byte 9, 0 ; offset to the next frame
			.word __vampire_run_r0_0, __vampire_run_r0_1, __vampire_run_r0_2, __vampire_run_r0_3, 
			.byte 9, 0 ; offset to the next frame
			.word __vampire_run_r1_0, __vampire_run_r1_1, __vampire_run_r1_2, __vampire_run_r1_3, 
			.byte 9, 0 ; offset to the next frame
			.word __vampire_run_r2_0, __vampire_run_r2_1, __vampire_run_r2_2, __vampire_run_r2_3, 
			.byte 9, 0 ; offset to the next frame
			.word __vampire_run_r3_0, __vampire_run_r3_1, __vampire_run_r3_2, __vampire_run_r3_3, 
			.byte 9, 0 ; offset to the next frame
			.word __vampire_run_l0_0, __vampire_run_l0_1, __vampire_run_l0_2, __vampire_run_l0_3, 
			.byte 9, 0 ; offset to the next frame
			.word __vampire_run_l1_0, __vampire_run_l1_1, __vampire_run_l1_2, __vampire_run_l1_3, 
			.byte 9, 0 ; offset to the next frame
			.word __vampire_run_l2_0, __vampire_run_l2_1, __vampire_run_l2_2, __vampire_run_l2_3, 
			.byte 185, $ff ; offset to the first frame
			.word __vampire_run_l3_0, __vampire_run_l3_1, __vampire_run_l3_2, __vampire_run_l3_3, 
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
vampire_cast:
			.byte 255, $ff ; offset to the first frame
			.word __vampire_cast_0_0, __vampire_cast_0_1, __vampire_cast_0_2, __vampire_cast_0_3, 
