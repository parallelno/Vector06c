__RAM_DISK_S_BACKBUFF = RAM_DISK_S3
__RAM_DISK_M_BACKBUFF = RAM_DISK_M3
__RAM_DISK_S_BACKBUFF2 = RAM_DISK_S1
__RAM_DISK_M_BACKBUFF2 = RAM_DISK_M1

ram_disk_init:
			;call clear_ram_disk
	;===============================================
	;		bank_id 3, addr $8000, chunk_id 0
	;===============================================
			; ['sprite_rd', 'draw_sprite_rd', 'draw_sprite_hit_rd', 'draw_sprite_invis_rd', 'utils_rd', 'sprite_preshift_rd']
			; unpack the chunk into the ram-disk
			lxi d, chunk_bank3_addr8000_0
			lxi b, __chunk_start_bank3_addr8000_0
			mvi a, RAM_DISK_M3 | RAM_DISK_M_8F
			call dzx0_rd

	;===============================================
	;		bank_id 2, addr $8000, chunk_id 0
	;===============================================
			; ['sound_rd', 'song01']
			; unpack the chunk into the ram-disk
			lxi d, chunk_bank2_addr8000_0
			lxi b, __chunk_start_bank2_addr8000_0
			mvi a, RAM_DISK_M2 | RAM_DISK_M_8F
			call dzx0_rd

	;===============================================
	;		bank_id 3, addr 0, chunk_id 0
	;===============================================
			; ['level01']
			; unpack the chunk into the ram-disk backbuffer2
			lxi d, chunk_bank3_addr0_0
			lxi b, BACK_BUFF2_ADDR
			mvi a, __RAM_DISK_M_BACKBUFF2 | RAM_DISK_M_8F
			call dzx0_rd

			; copy the chunk to the ram-disk
			lxi d, BACK_BUFF2_ADDR + (__chunk_end_bank3_addr0_0 - __chunk_start_bank3_addr0_0)
			lxi h, __chunk_end_bank3_addr0_0
			lxi b, (__chunk_end_bank3_addr0_0 - __chunk_start_bank3_addr0_0) / 2
			mvi a, RAM_DISK_S3 | __RAM_DISK_M_BACKBUFF2 | RAM_DISK_M_8F
			call copy_to_ram_disk

	;===============================================
	;		bank_id 0, addr 0, chunk_id 0
	;===============================================
			; ['hero_r']
			; unpack the chunk into the ram-disk back buffer
			lxi d, chunk_bank0_addr0_0
			lxi b, BACK_BUFF_ADDR
			mvi a, __RAM_DISK_M_BACKBUFF | RAM_DISK_M_8F
			call dzx0_rd

			; preshift hero_r sprites
			RAM_DISK_ON(__RAM_DISK_M_BACKBUFF | RAM_DISK_M_8F)
			lxi d, hero_r_preshifted_sprites
			LXI_H_TO_DIFF(SCR_BUFF1_ADDR - __chunk_start_bank0_addr0_0)
			call __sprite_dup_preshift
			RAM_DISK_OFF()

			; copy the chunk into the ram-disk
			lxi d, BACK_BUFF_ADDR + (__chunk_end_bank0_addr0_0 - __chunk_start_bank0_addr0_0)
			lxi h, __chunk_end_bank0_addr0_0
			lxi b, (__chunk_end_bank0_addr0_0 - __chunk_start_bank0_addr0_0) / 2
			mvi a, RAM_DISK_S0 | __RAM_DISK_M_BACKBUFF | RAM_DISK_M_8F
			call copy_to_ram_disk

	;===============================================
	;		bank_id 0, addr 0, chunk_id 1
	;===============================================
			; ['skeleton', 'scythe', 'bomb', 'vfx4', 'font']
			; unpack the chunk into the ram-disk back buffer
			lxi d, chunk_bank0_addr0_1
			lxi b, BACK_BUFF_ADDR
			mvi a, __RAM_DISK_M_BACKBUFF | RAM_DISK_M_8F
			call dzx0_rd

			; preshift skeleton sprites
			RAM_DISK_ON(__RAM_DISK_M_BACKBUFF | RAM_DISK_M_8F)
			lxi d, skeleton_preshifted_sprites
			LXI_H_TO_DIFF(SCR_BUFF1_ADDR - __chunk_start_bank0_addr0_1)
			call __sprite_dup_preshift
			RAM_DISK_OFF()

			; preshift scythe sprites
			RAM_DISK_ON(__RAM_DISK_M_BACKBUFF | RAM_DISK_M_8F)
			lxi d, scythe_preshifted_sprites
			LXI_H_TO_DIFF(SCR_BUFF1_ADDR - __chunk_start_bank0_addr0_1)
			call __sprite_dup_preshift
			RAM_DISK_OFF()

			; preshift bomb sprites
			RAM_DISK_ON(__RAM_DISK_M_BACKBUFF | RAM_DISK_M_8F)
			lxi d, bomb_preshifted_sprites
			LXI_H_TO_DIFF(SCR_BUFF1_ADDR - __chunk_start_bank0_addr0_1)
			call __sprite_dup_preshift
			RAM_DISK_OFF()

			; preshift vfx4 sprites
			RAM_DISK_ON(__RAM_DISK_M_BACKBUFF | RAM_DISK_M_8F)
			lxi d, vfx4_preshifted_sprites
			LXI_H_TO_DIFF(SCR_BUFF1_ADDR - __chunk_start_bank0_addr0_1)
			call __sprite_dup_preshift
			RAM_DISK_OFF()

			; copy the chunk into the ram-disk
			lxi d, BACK_BUFF_ADDR + (__chunk_end_bank0_addr0_1 - __chunk_start_bank0_addr0_1)
			lxi h, __chunk_end_bank0_addr0_1
			lxi b, (__chunk_end_bank0_addr0_1 - __chunk_start_bank0_addr0_1) / 2
			mvi a, RAM_DISK_S0 | __RAM_DISK_M_BACKBUFF | RAM_DISK_M_8F
			call copy_to_ram_disk

	;===============================================
	;		bank_id 0, addr $8000, chunk_id 0
	;===============================================
			; ['level01', 'backs', 'decals']
			; unpack the chunk into the ram-disk
			lxi d, chunk_bank0_addr8000_0
			lxi b, __chunk_start_bank0_addr8000_0
			mvi a, RAM_DISK_M0 | RAM_DISK_M_8F
			call dzx0_rd

	;===============================================
	;		bank_id 1, addr 0, chunk_id 0
	;===============================================
			; ['knight']
			; unpack the chunk into the ram-disk back buffer
			lxi d, chunk_bank1_addr0_0
			lxi b, BACK_BUFF_ADDR
			mvi a, __RAM_DISK_M_BACKBUFF | RAM_DISK_M_8F
			call dzx0_rd

			; preshift knight sprites
			RAM_DISK_ON(__RAM_DISK_M_BACKBUFF | RAM_DISK_M_8F)
			lxi d, knight_preshifted_sprites
			LXI_H_TO_DIFF(SCR_BUFF1_ADDR - __chunk_start_bank1_addr0_0)
			call __sprite_dup_preshift
			RAM_DISK_OFF()

			; copy the chunk into the ram-disk
			lxi d, BACK_BUFF_ADDR + (__chunk_end_bank1_addr0_0 - __chunk_start_bank1_addr0_0)
			lxi h, __chunk_end_bank1_addr0_0
			lxi b, (__chunk_end_bank1_addr0_0 - __chunk_start_bank1_addr0_0) / 2
			mvi a, RAM_DISK_S1 | __RAM_DISK_M_BACKBUFF | RAM_DISK_M_8F
			call copy_to_ram_disk

	;===============================================
	;		bank_id 1, addr 0, chunk_id 1
	;===============================================
			; ['burner']
			; unpack the chunk into the ram-disk back buffer
			lxi d, chunk_bank1_addr0_1
			lxi b, BACK_BUFF_ADDR
			mvi a, __RAM_DISK_M_BACKBUFF | RAM_DISK_M_8F
			call dzx0_rd

			; preshift burner sprites
			RAM_DISK_ON(__RAM_DISK_M_BACKBUFF | RAM_DISK_M_8F)
			lxi d, burner_preshifted_sprites
			LXI_H_TO_DIFF(SCR_BUFF1_ADDR - __chunk_start_bank1_addr0_1)
			call __sprite_dup_preshift
			RAM_DISK_OFF()

			; copy the chunk into the ram-disk
			lxi d, BACK_BUFF_ADDR + (__chunk_end_bank1_addr0_1 - __chunk_start_bank1_addr0_1)
			lxi h, __chunk_end_bank1_addr0_1
			lxi b, (__chunk_end_bank1_addr0_1 - __chunk_start_bank1_addr0_1) / 2
			mvi a, RAM_DISK_S1 | __RAM_DISK_M_BACKBUFF | RAM_DISK_M_8F
			call copy_to_ram_disk

	;===============================================
	;		bank_id 1, addr $8000, chunk_id 0
	;===============================================
			; ['hero_sword']
			; unpack the chunk into the ram-disk back buffer
			lxi d, chunk_bank1_addr8000_0
			lxi b, BACK_BUFF_ADDR
			mvi a, __RAM_DISK_M_BACKBUFF | RAM_DISK_M_8F
			call dzx0_rd

			; preshift hero_sword sprites
			RAM_DISK_ON(__RAM_DISK_M_BACKBUFF | RAM_DISK_M_8F)
			lxi d, hero_sword_preshifted_sprites
			LXI_H_TO_DIFF(SCR_BUFF1_ADDR - __chunk_start_bank1_addr8000_0)
			call __sprite_dup_preshift
			RAM_DISK_OFF()

			; copy the chunk into the ram-disk
			lxi d, BACK_BUFF_ADDR + (__chunk_end_bank1_addr8000_0 - __chunk_start_bank1_addr8000_0)
			lxi h, __chunk_end_bank1_addr8000_0
			lxi b, (__chunk_end_bank1_addr8000_0 - __chunk_start_bank1_addr8000_0) / 2
			mvi a, RAM_DISK_S1 | __RAM_DISK_M_BACKBUFF | RAM_DISK_M_8F
			call copy_to_ram_disk

	;===============================================
	;		bank_id 2, addr 0, chunk_id 0
	;===============================================
			; ['hero_l']
			; unpack the chunk into the ram-disk back buffer
			lxi d, chunk_bank2_addr0_0
			lxi b, BACK_BUFF_ADDR
			mvi a, __RAM_DISK_M_BACKBUFF | RAM_DISK_M_8F
			call dzx0_rd

			; preshift hero_l sprites
			RAM_DISK_ON(__RAM_DISK_M_BACKBUFF | RAM_DISK_M_8F)
			lxi d, hero_l_preshifted_sprites
			LXI_H_TO_DIFF(SCR_BUFF1_ADDR - __chunk_start_bank2_addr0_0)
			call __sprite_dup_preshift
			RAM_DISK_OFF()

			; copy the chunk into the ram-disk
			lxi d, BACK_BUFF_ADDR + (__chunk_end_bank2_addr0_0 - __chunk_start_bank2_addr0_0)
			lxi h, __chunk_end_bank2_addr0_0
			lxi b, (__chunk_end_bank2_addr0_0 - __chunk_start_bank2_addr0_0) / 2
			mvi a, RAM_DISK_S2 | __RAM_DISK_M_BACKBUFF | RAM_DISK_M_8F
			call copy_to_ram_disk

	;===============================================
	;		bank_id 2, addr 0, chunk_id 1
	;===============================================
			; ['vampire', 'vfx']
			; unpack the chunk into the ram-disk back buffer
			lxi d, chunk_bank2_addr0_1
			lxi b, BACK_BUFF_ADDR
			mvi a, __RAM_DISK_M_BACKBUFF | RAM_DISK_M_8F
			call dzx0_rd

			; preshift vampire sprites
			RAM_DISK_ON(__RAM_DISK_M_BACKBUFF | RAM_DISK_M_8F)
			lxi d, vampire_preshifted_sprites
			LXI_H_TO_DIFF(SCR_BUFF1_ADDR - __chunk_start_bank2_addr0_1)
			call __sprite_dup_preshift
			RAM_DISK_OFF()

			; copy the chunk into the ram-disk
			lxi d, BACK_BUFF_ADDR + (__chunk_end_bank2_addr0_1 - __chunk_start_bank2_addr0_1)
			lxi h, __chunk_end_bank2_addr0_1
			lxi b, (__chunk_end_bank2_addr0_1 - __chunk_start_bank2_addr0_1) / 2
			mvi a, RAM_DISK_S2 | __RAM_DISK_M_BACKBUFF | RAM_DISK_M_8F
			call copy_to_ram_disk

			ret
