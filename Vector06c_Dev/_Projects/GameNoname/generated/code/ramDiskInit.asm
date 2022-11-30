__RAM_DISK_S_BACKBUFF = RAM_DISK_S3
__RAM_DISK_M_BACKBUFF = RAM_DISK_M3
__RAM_DISK_S_BACKBUFF2 = RAM_DISK_S1
__RAM_DISK_M_BACKBUFF2 = RAM_DISK_M1

RamDiskInit:
			;call ClearRamDisk
	;===============================================
	;		code library, bank 3, addr $8000
	;===============================================
			; unpack code library to the ram-disk
			lxi d, ramDiskData_bank3_addr8000
			lxi b, $8000
			mvi a, RAM_DISK_M3 | RAM_DISK_M_8F
			call dzx0RD

	;===============================================
	;		levels, bank 3, addr 0
	;===============================================
			; unpack levels into the ram-disk backbuffer2
			lxi d, ramDiskData_bank3_addr0
			lxi b, SCR_BUFF0_ADDR
			mvi a, __RAM_DISK_M_BACKBUFF2 | RAM_DISK_M_8F
			call dzx0RD

			; copy levels to the ram-disk
			lxi d, SCR_BUFF0_ADDR + (__chunkEnd_bank3_addr0_chunk0 - __chunkStart_bank3_addr0_chunk0)
			lxi h, __chunkEnd_bank3_addr0_chunk0
			lxi b, (__chunkEnd_bank3_addr0_chunk0 - __chunkStart_bank3_addr0_chunk0) / 2
			mvi a, RAM_DISK_S3 | __RAM_DISK_M_BACKBUFF2 | RAM_DISK_M_8F
			call CopyToRamDisk

	;===============================================
	;		music, bank 2, addr $8000
	;===============================================
			; unpack music to the ram-disk
			lxi d, ramDiskData_bank2_addr8000
			lxi b, $8000
			mvi a, RAM_DISK_M2 | RAM_DISK_M_8F
			call dzx0RD

	;===============================================
	;		sprites, bank 2, addr 0
	;===============================================
			; unpack chunk 0 ['heroL'] sprites into the ram-disk back buffer
			lxi d, ramDiskData_bank2_addr0
			lxi b, SCR_BUFF1_ADDR
			mvi a, __RAM_DISK_M_BACKBUFF | RAM_DISK_M_8F
			call dzx0RD

			; preshift chunk 0 heroL sprites
			RAM_DISK_ON(__RAM_DISK_M_BACKBUFF | RAM_DISK_M_8F)
			lxi d, heroL_preshifted_sprites
			lxi h, SCR_BUFF1_ADDR
			call __SpriteDupPreshift
			RAM_DISK_OFF()

			; copy chunk 0 ['heroL'] sprites to the ram-disk
			lxi d, SCR_BUFF1_ADDR + (__chunkEnd_bank2_addr0_chunk0 - __chunkStart_bank2_addr0_chunk0)
			lxi h, __chunkEnd_bank2_addr0_chunk0
			lxi b, (__chunkEnd_bank2_addr0_chunk0 - __chunkStart_bank2_addr0_chunk0) / 2
			mvi a, RAM_DISK_S2 | __RAM_DISK_M_BACKBUFF | RAM_DISK_M_8F
			call CopyToRamDisk

	;===============================================
	;		sprites, bank 1, addr 0
	;===============================================
			; unpack chunk 0 ['knight', 'burner'] sprites into the ram-disk back buffer
			lxi d, ramDiskData_bank1_addr0_0
			lxi b, SCR_BUFF1_ADDR
			mvi a, __RAM_DISK_M_BACKBUFF | RAM_DISK_M_8F
			call dzx0RD

			; preshift chunk 0 knight sprites
			RAM_DISK_ON(__RAM_DISK_M_BACKBUFF | RAM_DISK_M_8F)
			lxi d, knight_preshifted_sprites
			lxi h, SCR_BUFF1_ADDR
			call __SpriteDupPreshift
			RAM_DISK_OFF()

			; preshift chunk 0 burner sprites
			RAM_DISK_ON(__RAM_DISK_M_BACKBUFF | RAM_DISK_M_8F)
			lxi d, burner_preshifted_sprites
			lxi h, SCR_BUFF1_ADDR
			call __SpriteDupPreshift
			RAM_DISK_OFF()

			; copy chunk 0 ['knight', 'burner'] sprites to the ram-disk
			lxi d, SCR_BUFF1_ADDR + (__chunkEnd_bank1_addr0_chunk0 - __chunkStart_bank1_addr0_chunk0)
			lxi h, __chunkEnd_bank1_addr0_chunk0
			lxi b, (__chunkEnd_bank1_addr0_chunk0 - __chunkStart_bank1_addr0_chunk0) / 2
			mvi a, RAM_DISK_S1 | __RAM_DISK_M_BACKBUFF | RAM_DISK_M_8F
			call CopyToRamDisk

			; unpack chunk 1 ['vampire'] sprites into the ram-disk back buffer
			lxi d, ramDiskData_bank1_addr0_1
			lxi b, SCR_BUFF1_ADDR
			mvi a, __RAM_DISK_M_BACKBUFF | RAM_DISK_M_8F
			call dzx0RD

			; preshift chunk 1 vampire sprites
			RAM_DISK_ON(__RAM_DISK_M_BACKBUFF | RAM_DISK_M_8F)
			lxi d, vampire_preshifted_sprites
			lxi h, SCR_BUFF1_ADDR - __chunkEnd_bank1_addr0_chunk0
			call __SpriteDupPreshift
			RAM_DISK_OFF()

			; copy chunk 1 ['vampire'] sprites to the ram-disk
			lxi d, SCR_BUFF1_ADDR + (__chunkEnd_bank1_addr0_chunk1 - __chunkEnd_bank1_addr0_chunk0)
			lxi h, __chunkEnd_bank1_addr0_chunk1
			lxi b, (__chunkEnd_bank1_addr0_chunk1 - __chunkEnd_bank1_addr0_chunk0) / 2
			mvi a, RAM_DISK_S1 | __RAM_DISK_M_BACKBUFF | RAM_DISK_M_8F
			call CopyToRamDisk

	;===============================================
	;		sprites, bank 0, addr 0
	;===============================================
			; unpack chunk 0 ['heroR'] sprites into the ram-disk back buffer
			lxi d, ramDiskData_bank0_addr0_0
			lxi b, SCR_BUFF1_ADDR
			mvi a, __RAM_DISK_M_BACKBUFF | RAM_DISK_M_8F
			call dzx0RD

			; preshift chunk 0 heroR sprites
			RAM_DISK_ON(__RAM_DISK_M_BACKBUFF | RAM_DISK_M_8F)
			lxi d, heroR_preshifted_sprites
			lxi h, SCR_BUFF1_ADDR
			call __SpriteDupPreshift
			RAM_DISK_OFF()

			; copy chunk 0 ['heroR'] sprites to the ram-disk
			lxi d, SCR_BUFF1_ADDR + (__chunkEnd_bank0_addr0_chunk0 - __chunkStart_bank0_addr0_chunk0)
			lxi h, __chunkEnd_bank0_addr0_chunk0
			lxi b, (__chunkEnd_bank0_addr0_chunk0 - __chunkStart_bank0_addr0_chunk0) / 2
			mvi a, RAM_DISK_S0 | __RAM_DISK_M_BACKBUFF | RAM_DISK_M_8F
			call CopyToRamDisk

			; unpack chunk 1 ['skeleton', 'scythe', 'hero_attack01'] sprites into the ram-disk back buffer
			lxi d, ramDiskData_bank0_addr0_1
			lxi b, SCR_BUFF1_ADDR
			mvi a, __RAM_DISK_M_BACKBUFF | RAM_DISK_M_8F
			call dzx0RD

			; preshift chunk 1 skeleton sprites
			RAM_DISK_ON(__RAM_DISK_M_BACKBUFF | RAM_DISK_M_8F)
			lxi d, skeleton_preshifted_sprites
			lxi h, SCR_BUFF1_ADDR - __chunkEnd_bank0_addr0_chunk0
			call __SpriteDupPreshift
			RAM_DISK_OFF()

			; preshift chunk 1 scythe sprites
			RAM_DISK_ON(__RAM_DISK_M_BACKBUFF | RAM_DISK_M_8F)
			lxi d, scythe_preshifted_sprites
			lxi h, SCR_BUFF1_ADDR - __chunkEnd_bank0_addr0_chunk0
			call __SpriteDupPreshift
			RAM_DISK_OFF()

			; preshift chunk 1 hero_attack01 sprites
			RAM_DISK_ON(__RAM_DISK_M_BACKBUFF | RAM_DISK_M_8F)
			lxi d, hero_attack01_preshifted_sprites
			lxi h, SCR_BUFF1_ADDR - __chunkEnd_bank0_addr0_chunk0
			call __SpriteDupPreshift
			RAM_DISK_OFF()

			; copy chunk 1 ['skeleton', 'scythe', 'hero_attack01'] sprites to the ram-disk
			lxi d, SCR_BUFF1_ADDR + (__chunkEnd_bank0_addr0_chunk1 - __chunkEnd_bank0_addr0_chunk0)
			lxi h, __chunkEnd_bank0_addr0_chunk1
			lxi b, (__chunkEnd_bank0_addr0_chunk1 - __chunkEnd_bank0_addr0_chunk0) / 2
			mvi a, RAM_DISK_S0 | __RAM_DISK_M_BACKBUFF | RAM_DISK_M_8F
			call CopyToRamDisk

			ret
