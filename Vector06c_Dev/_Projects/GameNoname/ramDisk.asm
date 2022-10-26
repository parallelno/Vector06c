RamDiskInit:
			;call ClearRamDisk
			
			; unpack utils to the ram-disk
			lxi d, toBank2addr8000
			lxi b, $8000
			mvi a, RAM_DISK_M2 | RAM_DISK_M_8F
			call dzx0RD

			; unpack music to the ram-disk
			lxi d, toBank1addr8000
			lxi b, $8000
			mvi a, RAM_DISK_M1 | RAM_DISK_M_8F
			call dzx0RD

			; unpack sprites chunk0 to $A000 in the ram-disk
			lxi d, toBank0addr0_0
			lxi b, SCR_BUFF1_ADDR
			mvi a, RAM_DISK_M2 | RAM_DISK_M_8F
			call dzx0RD
			; preshift sprites
			RAM_DISK_ON(RAM_DISK_M2 | RAM_DISK_M_8F)
			lxi d, hero_preshifted_sprites
			lxi h, SCR_BUFF1_ADDR
			call __SpriteDupPreshift
			RAM_DISK_OFF()
			; copy sprites to their designated space in the ram-disk
			lxi d, __splitB0_addr0_0 + SCR_BUFF1_ADDR
			lxi h, __splitB0_addr0_0
			lxi b, __splitB0_addr0_0 / 2
			mvi a, RAM_DISK_S0 | RAM_DISK_M2 | RAM_DISK_M_8F
			call CopyToRamDisk

			; unpack sprites chunk1 to $A000 in the ram-disk
			lxi d, toBank0addr0_1
			lxi b, SCR_BUFF1_ADDR
			mvi a, RAM_DISK_M2 | RAM_DISK_M_8F
			call dzx0RD
			; preshift sprites
			RAM_DISK_ON(RAM_DISK_M2 | RAM_DISK_M_8F)
			lxi d, skeleton_preshifted_sprites
			lxi h, SCR_BUFF1_ADDR - __splitB0_addr0_0
			call __SpriteDupPreshift
			RAM_DISK_OFF()
			; copy sprites chunk1 to their designated space in the ram-disk
			lxi d, __splitB0_addr0_1 - __splitB0_addr0_0 + SCR_BUFF1_ADDR
			lxi h, __splitB0_addr0_1
			lxi b, (__splitB0_addr0_1 - __splitB0_addr0_0) / 2
			mvi a, RAM_DISK_S0 | RAM_DISK_M2 | RAM_DISK_M_8F
			call CopyToRamDisk

			; unpack tiles and levels to the ram-disk
			lxi d, toBank0addr8000
			lxi b, $8000
			mvi a, RAM_DISK_M0 | RAM_DISK_M_8F
			call dzx0RD

			ret
			.closelabels