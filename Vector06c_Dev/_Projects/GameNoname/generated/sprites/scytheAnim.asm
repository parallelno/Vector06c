; source\sprites\scythe.json
SpriteGetScrAddr_scythe = SpriteGetScrAddr4

scythe_preshifted_sprites:
			.byte 4
scythe_anims:
			.word scythe_run, 0, 
scythe_run:
			.byte 9, 0 ; offset to the next frame
			.word __scythe_run0_0, __scythe_run0_1, __scythe_run0_2, __scythe_run0_3, 
			.byte 9, 0 ; offset to the next frame
			.word __scythe_run1_0, __scythe_run1_1, __scythe_run1_2, __scythe_run1_3, 
			.byte 9, 0 ; offset to the next frame
			.word __scythe_run2_0, __scythe_run2_1, __scythe_run2_2, __scythe_run2_3, 
			.byte -1, $ff ; offset to the first frame
			.word __scythe_run3_0, __scythe_run3_1, __scythe_run3_2, __scythe_run3_3, 
