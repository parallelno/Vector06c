; source\sprites\bomb.json
sprite_get_scr_addr_bomb = sprite_get_scr_addr4

bomb_preshifted_sprites:
			.byte 4
bomb_anims:
			.word bomb_run, bomb_dmg, 0, 
bomb_run:
			.byte 9, 0 ; offset to the next frame
			.word __bomb_run0_0, __bomb_run0_1, __bomb_run0_2, __bomb_run0_3, 
			.byte 245, $ff ; offset to the first frame
			.word __bomb_run1_0, __bomb_run1_1, __bomb_run1_2, __bomb_run1_3, 
bomb_dmg:
			.byte 9, 0 ; offset to the next frame
			.word __bomb_dmg0_0, __bomb_dmg0_1, __bomb_dmg0_2, __bomb_dmg0_3, 
			.byte 245, $ff ; offset to the first frame
			.word __bomb_dmg1_0, __bomb_dmg1_1, __bomb_dmg1_2, __bomb_dmg1_3, 
