RamDiskInit:
			;call ClearRamDisk
	;===============================================
	;		code library, bank 2, addr $8000
	;===============================================
			; unpack code library to the ram-disk
			lxi d, ramDiskData_bank2_addr8000
			lxi b, $8000
			mvi a, RAM_DISK_M2 | RAM_DISK_M_8F
			call dzx0RD

	;===============================================
	;		music, bank 1, addr $8000
	;===============================================
			; unpack music to the ram-disk
			lxi d, ramDiskData_bank1_addr8000
			lxi b, $8000
			mvi a, RAM_DISK_M1 | RAM_DISK_M_8F
			call dzx0RD

	;===============================================
	;		sprites, bank 1, addr 0
	;===============================================
			; unpack chunk 0 ['knight', 'burner', 'vampire'] sprites into the ram-disk back buffer
			lxi d, ramDiskData_bank1_addr0_0
			lxi b, SCR_BUFF1_ADDR
			mvi a, RAM_DISK_M2 | RAM_DISK_M_8F
			call dzx0RD

			; preshift chunk 0 knight sprites
			RAM_DISK_ON(RAM_DISK_M2 | RAM_DISK_M_8F)
			lxi d, knight_preshifted_sprites
			lxi h, SCR_BUFF1_ADDR
			call __SpriteDupPreshift
			RAM_DISK_OFF()

			; preshift chunk 0 burner sprites
			RAM_DISK_ON(RAM_DISK_M2 | RAM_DISK_M_8F)
			lxi d, burner_preshifted_sprites
			lxi h, SCR_BUFF1_ADDR
			call __SpriteDupPreshift
			RAM_DISK_OFF()

			; preshift chunk 0 vampire sprites
			RAM_DISK_ON(RAM_DISK_M2 | RAM_DISK_M_8F)
			lxi d, vampire_preshifted_sprites
			lxi h, SCR_BUFF1_ADDR
			call __SpriteDupPreshift
			RAM_DISK_OFF()

			; copy chunk 0 ['knight', 'burner', 'vampire'] sprites to the ram-disk
			lxi d, SCR_BUFF1_ADDR + __chunkEnd_bank1_addr0_chunk0 - __chunkStart_bank1_addr0_chunk0
			lxi h, __chunkEnd_bank1_addr0_chunk0
			lxi b, (__chunkEnd_bank1_addr0_chunk0 - __chunkStart_bank1_addr0_chunk0) / 2
			mvi a, RAM_DISK_S1 | RAM_DISK_M2 | RAM_DISK_M_8F
			call CopyToRamDisk

	;===============================================
	;		levels, bank 0, addr $8000
	;===============================================
			; unpack levels to the ram-disk
			lxi d, ramDiskData_bank0_addr8000
			lxi b, $8000
			mvi a, RAM_DISK_M0 | RAM_DISK_M_8F
			call dzx0RD

	;===============================================
	;		sprites, bank 0, addr 0
	;===============================================
			; unpack chunk 0 ['hero'] sprites into the ram-disk back buffer
			lxi d, ramDiskData_bank0_addr0_0
			lxi b, SCR_BUFF1_ADDR
			mvi a, RAM_DISK_M2 | RAM_DISK_M_8F
			call dzx0RD

			; preshift chunk 0 hero sprites
			RAM_DISK_ON(RAM_DISK_M2 | RAM_DISK_M_8F)
			lxi d, hero_preshifted_sprites
			lxi h, SCR_BUFF1_ADDR
			call __SpriteDupPreshift
			RAM_DISK_OFF()

			; copy chunk 0 ['hero'] sprites to the ram-disk
			lxi d, SCR_BUFF1_ADDR + __chunkEnd_bank0_addr0_chunk0 - __chunkStart_bank0_addr0_chunk0
			lxi h, __chunkEnd_bank0_addr0_chunk0
			lxi b, (__chunkEnd_bank0_addr0_chunk0 - __chunkStart_bank0_addr0_chunk0) / 2
			mvi a, RAM_DISK_S0 | RAM_DISK_M2 | RAM_DISK_M_8F
			call CopyToRamDisk

			; unpack chunk 1 ['skeleton', 'scythe', 'hero_attack01'] sprites into the ram-disk back buffer
			lxi d, ramDiskData_bank0_addr0_1
			lxi b, SCR_BUFF1_ADDR
			mvi a, RAM_DISK_M2 | RAM_DISK_M_8F
			call dzx0RD

			; preshift chunk 1 skeleton sprites
			RAM_DISK_ON(RAM_DISK_M2 | RAM_DISK_M_8F)
			lxi d, skeleton_preshifted_sprites
			lxi h, SCR_BUFF1_ADDR - __chunkEnd_bank0_addr0_chunk0
			call __SpriteDupPreshift
			RAM_DISK_OFF()

			; preshift chunk 1 scythe sprites
			RAM_DISK_ON(RAM_DISK_M2 | RAM_DISK_M_8F)
			lxi d, scythe_preshifted_sprites
			lxi h, SCR_BUFF1_ADDR - __chunkEnd_bank0_addr0_chunk0
			call __SpriteDupPreshift
			RAM_DISK_OFF()

			; preshift chunk 1 hero_attack01 sprites
			RAM_DISK_ON(RAM_DISK_M2 | RAM_DISK_M_8F)
			lxi d, hero_attack01_preshifted_sprites
			lxi h, SCR_BUFF1_ADDR - __chunkEnd_bank0_addr0_chunk0
			call __SpriteDupPreshift
			RAM_DISK_OFF()

			; copy chunk 1 ['skeleton', 'scythe', 'hero_attack01'] sprites to the ram-disk
			lxi d, SCR_BUFF1_ADDR + __chunkEnd_bank0_addr0_chunk1 - __chunkEnd_bank0_addr0_chunk0
			lxi h, __chunkEnd_bank0_addr0_chunk1
			lxi b, (__chunkEnd_bank0_addr0_chunk1 - __chunkEnd_bank0_addr0_chunk0) / 2
			mvi a, RAM_DISK_S0 | RAM_DISK_M2 | RAM_DISK_M_8F
			call CopyToRamDisk

			ret
