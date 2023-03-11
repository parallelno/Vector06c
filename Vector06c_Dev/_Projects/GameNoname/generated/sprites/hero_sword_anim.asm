; source\sprites\hero_sword.json
sprite_get_scr_addr_hero_sword = sprite_get_scr_addr8

hero_sword_preshifted_sprites:
			.byte 8
hero_sword_anims:
			.word hero_sword_delay, hero_sword_attk_r, hero_sword_attk_l, 0, 
hero_sword_delay:
			.byte -1, $ff ; offset to the first frame
			.word __hero_sword_sword_delay_0, __hero_sword_sword_delay_1, __hero_sword_sword_delay_2, __hero_sword_sword_delay_3, __hero_sword_sword_delay_4, __hero_sword_sword_delay_5, __hero_sword_sword_delay_6, __hero_sword_sword_delay_7, 
hero_sword_attk_r:
			.byte 17, 0 ; offset to the next frame
			.word __hero_sword_sword_r0_0, __hero_sword_sword_r0_1, __hero_sword_sword_r0_2, __hero_sword_sword_r0_3, __hero_sword_sword_r0_4, __hero_sword_sword_r0_5, __hero_sword_sword_r0_6, __hero_sword_sword_r0_7, 
			.byte -1, $ff ; offset to the first frame
			.word __hero_sword_sword_r1_0, __hero_sword_sword_r1_1, __hero_sword_sword_r1_2, __hero_sword_sword_r1_3, __hero_sword_sword_r1_4, __hero_sword_sword_r1_5, __hero_sword_sword_r1_6, __hero_sword_sword_r1_7, 
hero_sword_attk_l:
			.byte 17, 0 ; offset to the next frame
			.word __hero_sword_sword_l0_0, __hero_sword_sword_l0_1, __hero_sword_sword_l0_2, __hero_sword_sword_l0_3, __hero_sword_sword_l0_4, __hero_sword_sword_l0_5, __hero_sword_sword_l0_6, __hero_sword_sword_l0_7, 
			.byte -1, $ff ; offset to the first frame
			.word __hero_sword_sword_l1_0, __hero_sword_sword_l1_1, __hero_sword_sword_l1_2, __hero_sword_sword_l1_3, __hero_sword_sword_l1_4, __hero_sword_sword_l1_5, __hero_sword_sword_l1_6, __hero_sword_sword_l1_7, 
