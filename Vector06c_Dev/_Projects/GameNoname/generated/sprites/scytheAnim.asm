; sources\sprites\scythe.json
scythe_preshifted_sprites:
			.byte 4
scythe_anims:
			.word scythe_run_rn, scythe_run_ln, scythe_run_un, scythe_run_dn, scythe_run_cl, scythe_run_cc, scythe_run_rf, scythe_run_lf, scythe_run_uf, scythe_run_df, 0, 
scythe_run_rn:
			.byte 255, $ff ; offset to the first frame
			.word scythe_run_rn0_0, scythe_run_rn0_1, scythe_run_rn0_2, scythe_run_rn0_3, 
scythe_run_ln:
			.byte 255, $ff ; offset to the first frame
			.word scythe_run_ln0_0, scythe_run_ln0_1, scythe_run_ln0_2, scythe_run_ln0_3, 
scythe_run_un:
			.byte 255, $ff ; offset to the first frame
			.word scythe_run_un0_0, scythe_run_un0_1, scythe_run_un0_2, scythe_run_un0_3, 
scythe_run_dn:
			.byte 255, $ff ; offset to the first frame
			.word scythe_run_dn0_0, scythe_run_dn0_1, scythe_run_dn0_2, scythe_run_dn0_3, 
scythe_run_cl:
			.byte 255, $ff ; offset to the first frame
			.word scythe_run_un0_0, scythe_run_un0_1, scythe_run_un0_2, scythe_run_un0_3, 
scythe_run_cc:
			.byte 255, $ff ; offset to the first frame
			.word scythe_run_uf0_0, scythe_run_uf0_1, scythe_run_uf0_2, scythe_run_uf0_3, 
scythe_run_rf:
			.byte 255, $ff ; offset to the first frame
			.word scythe_run_rf0_0, scythe_run_rf0_1, scythe_run_rf0_2, scythe_run_rf0_3, 
scythe_run_lf:
			.byte 255, $ff ; offset to the first frame
			.word scythe_run_lf0_0, scythe_run_lf0_1, scythe_run_lf0_2, scythe_run_lf0_3, 
scythe_run_uf:
			.byte 255, $ff ; offset to the first frame
			.word scythe_run_uf0_0, scythe_run_uf0_1, scythe_run_uf0_2, scythe_run_uf0_3, 
scythe_run_df:
			.byte 255, $ff ; offset to the first frame
			.word scythe_run_df0_0, scythe_run_df0_1, scythe_run_df0_2, scythe_run_df0_3, 
