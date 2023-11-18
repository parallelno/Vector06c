ram_disk_init:
			;call clear_ram_disk
	;===============================================
	;		bank_id 3, addr $8000, chunk_id 0
	;===============================================
			; ['global_consts_rd', 'sprite_rd', 'draw_sprite_rd', 'draw_sprite_hit_rd', 'draw_sprite_invis_rd', 'utils_rd', 'sprite_preshift_rd', 'text_rd_data', 'text_ex_rd', 'game_score_data_rd']
			; unpack the chunk into the ram-disk
			lxi d, chunk_bank3_addr8000_0
			lxi b, __global_consts_rd_rd_data_start
			mvi a, RAM_DISK_M3 | RAM_DISK_M_8F
			call dzx0_rd

	;===============================================
	;		bank_id 2, addr $8000, chunk_id 0
	;===============================================
			; ['sound_rd', 'song01']
			; unpack the chunk into the ram-disk
			lxi d, chunk_bank2_addr8000_0
			lxi b, __sound_rd_rd_data_start
			mvi a, RAM_DISK_M2 | RAM_DISK_M_8F
			call dzx0_rd

	;===============================================
	;		bank_id 3, addr $0, chunk_id 0
	;===============================================
			; ['level00_gfx', 'level01_gfx']
			; unpack the chunk into the ram-disk backbuffer2
			lxi d, chunk_bank3_addr0_0
			lxi b, BACK_BUFF_ADDR
			mvi a, __RAM_DISK_M_BACKBUFF | RAM_DISK_M_8F
			call dzx0_rd

			; copy the chunk to the ram-disk
			lxi d, BACK_BUFF_ADDR + (__level01_gfx_rd_data_end - __level00_gfx_rd_data_start)
			lxi h, __level01_gfx_rd_data_end
			lxi b, (__level01_gfx_rd_data_end - __level00_gfx_rd_data_start) / 2
			mvi a, RAM_DISK_S3 | __RAM_DISK_M_BACKBUFF | RAM_DISK_M_8F
			call copy_to_ram_disk

	;===============================================
	;		bank_id 0, addr $0, chunk_id 0
	;===============================================
			; ['hero_r_sprites', 'skeleton_sprites']
			; unpack the chunk into the ram-disk back buffer
			lxi d, chunk_bank0_addr0_0
			lxi b, BACK_BUFF_ADDR
			mvi a, __RAM_DISK_M_BACKBUFF | RAM_DISK_M_8F
			call dzx0_rd

			; preshift hero_r_sprites
			RAM_DISK_ON_NO_RESTORE(__RAM_DISK_M_BACKBUFF | RAM_DISK_M_8F)
			lxi d, hero_r_preshifted_sprites
			lxi h, SCR_BUFF1_ADDR - __hero_r_sprites_rd_data_start
			call __sprite_dup_preshift
			RAM_DISK_OFF_NO_RESTORE()

			; preshift skeleton_sprites
			RAM_DISK_ON_NO_RESTORE(__RAM_DISK_M_BACKBUFF | RAM_DISK_M_8F)
			lxi d, skeleton_preshifted_sprites
			lxi h, SCR_BUFF1_ADDR - __hero_r_sprites_rd_data_start
			call __sprite_dup_preshift
			RAM_DISK_OFF_NO_RESTORE()

			; copy the chunk into the ram-disk
			lxi d, BACK_BUFF_ADDR + (__skeleton_sprites_rd_data_end - __hero_r_sprites_rd_data_start)
			lxi h, __skeleton_sprites_rd_data_end
			lxi b, (__skeleton_sprites_rd_data_end - __hero_r_sprites_rd_data_start) / 2
			mvi a, RAM_DISK_S0 | __RAM_DISK_M_BACKBUFF | RAM_DISK_M_8F
			call copy_to_ram_disk

	;===============================================
	;		bank_id 0, addr $0, chunk_id 1
	;===============================================
			; ['scythe_sprites', 'bomb_sprites', 'snowflake_sprites', 'font_gfx']
			; unpack the chunk into the ram-disk back buffer
			lxi d, chunk_bank0_addr0_1
			lxi b, BACK_BUFF_ADDR
			mvi a, __RAM_DISK_M_BACKBUFF | RAM_DISK_M_8F
			call dzx0_rd

			; preshift scythe_sprites
			RAM_DISK_ON_NO_RESTORE(__RAM_DISK_M_BACKBUFF | RAM_DISK_M_8F)
			lxi d, scythe_preshifted_sprites
			lxi h, SCR_BUFF1_ADDR - __scythe_sprites_rd_data_start
			call __sprite_dup_preshift
			RAM_DISK_OFF_NO_RESTORE()

			; preshift bomb_sprites
			RAM_DISK_ON_NO_RESTORE(__RAM_DISK_M_BACKBUFF | RAM_DISK_M_8F)
			lxi d, bomb_preshifted_sprites
			lxi h, SCR_BUFF1_ADDR - __scythe_sprites_rd_data_start
			call __sprite_dup_preshift
			RAM_DISK_OFF_NO_RESTORE()

			; preshift snowflake_sprites
			RAM_DISK_ON_NO_RESTORE(__RAM_DISK_M_BACKBUFF | RAM_DISK_M_8F)
			lxi d, snowflake_preshifted_sprites
			lxi h, SCR_BUFF1_ADDR - __scythe_sprites_rd_data_start
			call __sprite_dup_preshift
			RAM_DISK_OFF_NO_RESTORE()

			; copy the chunk into the ram-disk
			lxi d, BACK_BUFF_ADDR + (__font_gfx_rd_data_end - __scythe_sprites_rd_data_start)
			lxi h, __font_gfx_rd_data_end
			lxi b, (__font_gfx_rd_data_end - __scythe_sprites_rd_data_start) / 2
			mvi a, RAM_DISK_S0 | __RAM_DISK_M_BACKBUFF | RAM_DISK_M_8F
			call copy_to_ram_disk

	;===============================================
	;		bank_id 0, addr $8000, chunk_id 0
	;===============================================
			; ['level00_data', 'backs_sprites', 'decals_sprites', 'vfx4_sprites', 'level01_data', 'tiled_images_gfx', 'tiled_images_data']
			; unpack the chunk into the ram-disk back buffer
			lxi d, chunk_bank0_addr8000_0
			lxi b, BACK_BUFF_ADDR
			mvi a, __RAM_DISK_M_BACKBUFF | RAM_DISK_M_8F
			call dzx0_rd

			; preshift vfx4_sprites
			RAM_DISK_ON_NO_RESTORE(__RAM_DISK_M_BACKBUFF | RAM_DISK_M_8F)
			lxi d, vfx4_preshifted_sprites
			lxi h, SCR_BUFF1_ADDR - __level00_data_rd_data_start
			call __sprite_dup_preshift
			RAM_DISK_OFF_NO_RESTORE()

			; copy the chunk into the ram-disk
			lxi d, BACK_BUFF_ADDR + (__tiled_images_data_rd_data_end - __level00_data_rd_data_start)
			lxi h, __tiled_images_data_rd_data_end
			lxi b, (__tiled_images_data_rd_data_end - __level00_data_rd_data_start) / 2
			mvi a, RAM_DISK_S0 | __RAM_DISK_M_BACKBUFF | RAM_DISK_M_8F
			call copy_to_ram_disk

	;===============================================
	;		bank_id 1, addr $0, chunk_id 0
	;===============================================
			; ['knight_sprites']
			; unpack the chunk into the ram-disk back buffer
			lxi d, chunk_bank1_addr0_0
			lxi b, BACK_BUFF_ADDR
			mvi a, __RAM_DISK_M_BACKBUFF | RAM_DISK_M_8F
			call dzx0_rd

			; preshift knight_sprites
			RAM_DISK_ON_NO_RESTORE(__RAM_DISK_M_BACKBUFF | RAM_DISK_M_8F)
			lxi d, knight_preshifted_sprites
			lxi h, SCR_BUFF1_ADDR - __knight_sprites_rd_data_start
			call __sprite_dup_preshift
			RAM_DISK_OFF_NO_RESTORE()

			; copy the chunk into the ram-disk
			lxi d, BACK_BUFF_ADDR + (__knight_sprites_rd_data_end - __knight_sprites_rd_data_start)
			lxi h, __knight_sprites_rd_data_end
			lxi b, (__knight_sprites_rd_data_end - __knight_sprites_rd_data_start) / 2
			mvi a, RAM_DISK_S1 | __RAM_DISK_M_BACKBUFF | RAM_DISK_M_8F
			call copy_to_ram_disk

	;===============================================
	;		bank_id 1, addr $0, chunk_id 1
	;===============================================
			; ['burner_sprites']
			; unpack the chunk into the ram-disk back buffer
			lxi d, chunk_bank1_addr0_1
			lxi b, BACK_BUFF_ADDR
			mvi a, __RAM_DISK_M_BACKBUFF | RAM_DISK_M_8F
			call dzx0_rd

			; preshift burner_sprites
			RAM_DISK_ON_NO_RESTORE(__RAM_DISK_M_BACKBUFF | RAM_DISK_M_8F)
			lxi d, burner_preshifted_sprites
			lxi h, SCR_BUFF1_ADDR - __burner_sprites_rd_data_start
			call __sprite_dup_preshift
			RAM_DISK_OFF_NO_RESTORE()

			; copy the chunk into the ram-disk
			lxi d, BACK_BUFF_ADDR + (__burner_sprites_rd_data_end - __burner_sprites_rd_data_start)
			lxi h, __burner_sprites_rd_data_end
			lxi b, (__burner_sprites_rd_data_end - __burner_sprites_rd_data_start) / 2
			mvi a, RAM_DISK_S1 | __RAM_DISK_M_BACKBUFF | RAM_DISK_M_8F
			call copy_to_ram_disk

	;===============================================
	;		bank_id 1, addr $8000, chunk_id 0
	;===============================================
			; ['sword_sprites']
			; unpack the chunk into the ram-disk back buffer
			lxi d, chunk_bank1_addr8000_0
			lxi b, BACK_BUFF_ADDR
			mvi a, __RAM_DISK_M_BACKBUFF | RAM_DISK_M_8F
			call dzx0_rd

			; preshift sword_sprites
			RAM_DISK_ON_NO_RESTORE(__RAM_DISK_M_BACKBUFF | RAM_DISK_M_8F)
			lxi d, sword_preshifted_sprites
			lxi h, SCR_BUFF1_ADDR - __sword_sprites_rd_data_start
			call __sprite_dup_preshift
			RAM_DISK_OFF_NO_RESTORE()

			; copy the chunk into the ram-disk
			lxi d, BACK_BUFF_ADDR + (__sword_sprites_rd_data_end - __sword_sprites_rd_data_start)
			lxi h, __sword_sprites_rd_data_end
			lxi b, (__sword_sprites_rd_data_end - __sword_sprites_rd_data_start) / 2
			mvi a, RAM_DISK_S1 | __RAM_DISK_M_BACKBUFF | RAM_DISK_M_8F
			call copy_to_ram_disk

	;===============================================
	;		bank_id 2, addr $0, chunk_id 0
	;===============================================
			; ['hero_l_sprites', 'vampire_sprites', 'vfx_sprites']
			; unpack the chunk into the ram-disk back buffer
			lxi d, chunk_bank2_addr0_0
			lxi b, BACK_BUFF_ADDR
			mvi a, __RAM_DISK_M_BACKBUFF | RAM_DISK_M_8F
			call dzx0_rd

			; preshift hero_l_sprites
			RAM_DISK_ON_NO_RESTORE(__RAM_DISK_M_BACKBUFF | RAM_DISK_M_8F)
			lxi d, hero_l_preshifted_sprites
			lxi h, SCR_BUFF1_ADDR - __hero_l_sprites_rd_data_start
			call __sprite_dup_preshift
			RAM_DISK_OFF_NO_RESTORE()

			; preshift vampire_sprites
			RAM_DISK_ON_NO_RESTORE(__RAM_DISK_M_BACKBUFF | RAM_DISK_M_8F)
			lxi d, vampire_preshifted_sprites
			lxi h, SCR_BUFF1_ADDR - __hero_l_sprites_rd_data_start
			call __sprite_dup_preshift
			RAM_DISK_OFF_NO_RESTORE()

			; copy the chunk into the ram-disk
			lxi d, BACK_BUFF_ADDR + (__vfx_sprites_rd_data_end - __hero_l_sprites_rd_data_start)
			lxi h, __vfx_sprites_rd_data_end
			lxi b, (__vfx_sprites_rd_data_end - __hero_l_sprites_rd_data_start) / 2
			mvi a, RAM_DISK_S2 | __RAM_DISK_M_BACKBUFF | RAM_DISK_M_8F
			call copy_to_ram_disk

			ret
