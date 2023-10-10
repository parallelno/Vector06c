; source\sprites\snowflake.json
sprite_get_scr_addr_snowflake = sprite_get_scr_addr4

snowflake_preshifted_sprites:
			.byte 4
snowflake_anims:
			.word snowflake_run, 0, 
snowflake_run:
			.byte 9, 0 ; offset to the next frame
			.word __snowflake_run0_0, __snowflake_run0_1, __snowflake_run0_2, __snowflake_run0_3, 
			.byte 9, 0 ; offset to the next frame
			.word __snowflake_run1_0, __snowflake_run1_1, __snowflake_run1_2, __snowflake_run1_3, 
			.byte 9, 0 ; offset to the next frame
			.word __snowflake_run2_0, __snowflake_run2_1, __snowflake_run2_2, __snowflake_run2_3, 
			.byte 225, $ff ; offset to the first frame
			.word __snowflake_run1_0, __snowflake_run1_1, __snowflake_run1_2, __snowflake_run1_3, 
