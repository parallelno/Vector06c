__RAM_DISK_S_BACKBUFF = RAM_DISK_S3
__RAM_DISK_M_BACKBUFF = RAM_DISK_M3
__RAM_DISK_S_BACKBUFF2 = RAM_DISK_S1
__RAM_DISK_M_BACKBUFF2 = RAM_DISK_M1

ram_disk_init:
			;call clear_ram_disk
	;===============================================
	;		code library, bank 3, addr $8000
	;===============================================
			; unpack code library to the ram-disk
			lxi d, ram_disk_data_bank3_addr8000
			lxi b, $8000
			mvi a, RAM_DISK_M3 | RAM_DISK_M_8F
			call dzx0RD

	;===============================================
	;		levels, bank 3, addr 0
	;===============================================
			; unpack levels into the ram-disk backbuffer2
			lxi d, ram_disk_data_bank3_addr0
			lxi b, SCR_BUFF0_ADDR
			mvi a, __RAM_DISK_M_BACKBUFF2 | RAM_DISK_M_8F
			call dzx0RD

			; copy levels to the ram-disk
			lxi d, SCR_BUFF0_ADDR + (__chunk_end_bank3_addr0_0 - __chunk_start_bank3_addr0_0)
			lxi h, __chunk_end_bank3_addr0_0
			lxi b, (__chunk_end_bank3_addr0_0 - __chunk_start_bank3_addr0_0) / 2
			mvi a, RAM_DISK_S3 | __RAM_DISK_M_BACKBUFF2 | RAM_DISK_M_8F
			call copy_to_ram_disk

	;===============================================
	;		music, bank 2, addr $8000
	;===============================================
			; unpack music to the ram-disk
			lxi d, ram_disk_data_bank2_addr8000
			lxi b, $8000
			mvi a, RAM_DISK_M2 | RAM_DISK_M_8F
			call dzx0RD

	;===============================================
	;		sprites, bank 2, addr 0
	;===============================================
			; unpack chunk 0 ['hero_l', 'vampire'] sprites into the ram-disk back buffer
			lxi d, ram_disk_data_bank2_addr0
			lxi b, SCR_BUFF1_ADDR
			mvi a, __RAM_DISK_M_BACKBUFF | RAM_DISK_M_8F
			call dzx0RD

			; preshift chunk 0 hero_l sprites
			RAM_DISK_ON(__RAM_DISK_M_BACKBUFF | RAM_DISK_M_8F)
			lxi d, hero_l_preshifted_sprites
			lxi h, SCR_BUFF1_ADDR
			call __SpriteDupPreshift
			RAM_DISK_OFF()

			; preshift chunk 0 vampire sprites
			RAM_DISK_ON(__RAM_DISK_M_BACKBUFF | RAM_DISK_M_8F)
			lxi d, vampire_preshifted_sprites
			lxi h, SCR_BUFF1_ADDR
			call __SpriteDupPreshift
			RAM_DISK_OFF()

			; copy chunk 0 ['hero_l', 'vampire'] sprites to the ram-disk
			lxi d, SCR_BUFF1_ADDR + (__chunk_end_bank2_addr0_0 - __chunk_start_bank2_addr0_0)
			lxi h, __chunk_end_bank2_addr0_0
			lxi b, (__chunk_end_bank2_addr0_0 - __chunk_start_bank2_addr0_0) / 2
			mvi a, RAM_DISK_S2 | __RAM_DISK_M_BACKBUFF | RAM_DISK_M_8F
			call copy_to_ram_disk

	;===============================================
	;		sprites, bank 1, addr 0
	;===============================================
			; unpack chunk 0 ['knight'] sprites into the ram-disk back buffer
			lxi d, ram_disk_data_bank1_addr0_0
			lxi b, SCR_BUFF1_ADDR
			mvi a, __RAM_DISK_M_BACKBUFF | RAM_DISK_M_8F
			call dzx0RD

			; preshift chunk 0 knight sprites
			RAM_DISK_ON(__RAM_DISK_M_BACKBUFF | RAM_DISK_M_8F)
			lxi d, knight_preshifted_sprites
			lxi h, SCR_BUFF1_ADDR
			call __SpriteDupPreshift
			RAM_DISK_OFF()

			; copy chunk 0 ['knight'] sprites to the ram-disk
			lxi d, SCR_BUFF1_ADDR + (__chunk_end_bank1_addr0_0 - __chunk_start_bank1_addr0_0)
			lxi h, __chunk_end_bank1_addr0_0
			lxi b, (__chunk_end_bank1_addr0_0 - __chunk_start_bank1_addr0_0) / 2
			mvi a, RAM_DISK_S1 | __RAM_DISK_M_BACKBUFF | RAM_DISK_M_8F
			call copy_to_ram_disk

			; unpack chunk 1 ['burner', 'bomb_slow'] sprites into the ram-disk back buffer
			lxi d, ram_disk_data_bank1_addr0_1
			lxi b, SCR_BUFF1_ADDR
			mvi a, __RAM_DISK_M_BACKBUFF | RAM_DISK_M_8F
			call dzx0RD

			; preshift chunk 1 burner sprites
			RAM_DISK_ON(__RAM_DISK_M_BACKBUFF | RAM_DISK_M_8F)
			lxi d, burner_preshifted_sprites
			lxi h, SCR_BUFF1_ADDR - __chunk_end_bank1_addr0_0
			call __SpriteDupPreshift
			RAM_DISK_OFF()

			; preshift chunk 1 bomb_slow sprites
			RAM_DISK_ON(__RAM_DISK_M_BACKBUFF | RAM_DISK_M_8F)
			lxi d, bomb_slow_preshifted_sprites
			lxi h, SCR_BUFF1_ADDR - __chunk_end_bank1_addr0_0
			call __SpriteDupPreshift
			RAM_DISK_OFF()

			; copy chunk 1 ['burner', 'bomb_slow'] sprites to the ram-disk
			lxi d, SCR_BUFF1_ADDR + (__chunk_end_bank1_addr0_1 - __chunk_end_bank1_addr0_0)
			lxi h, __chunk_end_bank1_addr0_1
			lxi b, (__chunk_end_bank1_addr0_1 - __chunk_end_bank1_addr0_0) / 2
			mvi a, RAM_DISK_S1 | __RAM_DISK_M_BACKBUFF | RAM_DISK_M_8F
			call copy_to_ram_disk

	;===============================================
	;		sprites, bank 0, addr 0
	;===============================================
			; unpack chunk 0 ['hero_r'] sprites into the ram-disk back buffer
			lxi d, ram_disk_data_bank0_addr0_0
			lxi b, SCR_BUFF1_ADDR
			mvi a, __RAM_DISK_M_BACKBUFF | RAM_DISK_M_8F
			call dzx0RD

			; preshift chunk 0 hero_r sprites
			RAM_DISK_ON(__RAM_DISK_M_BACKBUFF | RAM_DISK_M_8F)
			lxi d, hero_r_preshifted_sprites
			lxi h, SCR_BUFF1_ADDR
			call __SpriteDupPreshift
			RAM_DISK_OFF()

			; copy chunk 0 ['hero_r'] sprites to the ram-disk
			lxi d, SCR_BUFF1_ADDR + (__chunk_end_bank0_addr0_0 - __chunk_start_bank0_addr0_0)
			lxi h, __chunk_end_bank0_addr0_0
			lxi b, (__chunk_end_bank0_addr0_0 - __chunk_start_bank0_addr0_0) / 2
			mvi a, RAM_DISK_S0 | __RAM_DISK_M_BACKBUFF | RAM_DISK_M_8F
			call copy_to_ram_disk

			; unpack chunk 1 ['skeleton', 'scythe', 'hero_attack01'] sprites into the ram-disk back buffer
			lxi d, ram_disk_data_bank0_addr0_1
			lxi b, SCR_BUFF1_ADDR
			mvi a, __RAM_DISK_M_BACKBUFF | RAM_DISK_M_8F
			call dzx0RD

			; preshift chunk 1 skeleton sprites
			RAM_DISK_ON(__RAM_DISK_M_BACKBUFF | RAM_DISK_M_8F)
			lxi d, skeleton_preshifted_sprites
			lxi h, SCR_BUFF1_ADDR - __chunk_end_bank0_addr0_0
			call __SpriteDupPreshift
			RAM_DISK_OFF()

			; preshift chunk 1 scythe sprites
			RAM_DISK_ON(__RAM_DISK_M_BACKBUFF | RAM_DISK_M_8F)
			lxi d, scythe_preshifted_sprites
			lxi h, SCR_BUFF1_ADDR - __chunk_end_bank0_addr0_0
			call __SpriteDupPreshift
			RAM_DISK_OFF()

			; preshift chunk 1 hero_attack01 sprites
			RAM_DISK_ON(__RAM_DISK_M_BACKBUFF | RAM_DISK_M_8F)
			lxi d, hero_attack01_preshifted_sprites
			lxi h, SCR_BUFF1_ADDR - __chunk_end_bank0_addr0_0
			call __SpriteDupPreshift
			RAM_DISK_OFF()

			; copy chunk 1 ['skeleton', 'scythe', 'hero_attack01'] sprites to the ram-disk
			lxi d, SCR_BUFF1_ADDR + (__chunk_end_bank0_addr0_1 - __chunk_end_bank0_addr0_0)
			lxi h, __chunk_end_bank0_addr0_1
			lxi b, (__chunk_end_bank0_addr0_1 - __chunk_end_bank0_addr0_0) / 2
			mvi a, RAM_DISK_S0 | __RAM_DISK_M_BACKBUFF | RAM_DISK_M_8F
			call copy_to_ram_disk

			ret
