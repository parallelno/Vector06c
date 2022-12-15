; source\sprites\bomb_slow.json
SpriteGetScrAddr_bomb_slow = SpriteGetScrAddr4

bomb_slow_preshifted_sprites:
			.byte 4
bomb_slow_anims:
			.word bomb_slow_run, 0, 
bomb_slow_run:
			.byte 9, 0 ; offset to the next frame
			.word __bomb_slow_run0_0, __bomb_slow_run0_1, __bomb_slow_run0_2, __bomb_slow_run0_3, 
			.byte 245, $ff ; offset to the first frame
			.word __bomb_slow_run1_0, __bomb_slow_run1_1, __bomb_slow_run1_2, __bomb_slow_run1_3, 
