RamDiskInit:
			; unpack utils to the ram-disk
			lxi d, toBank2addr8000
			lxi b, $8000
			mvi a, RAM_DISK_M2 | RAM_DISK_M_8F
			call dzx0RD

			; unpack music to the ram-disk
			lxi d, toBank1addrA000
			lxi b, $A000
			mvi a, RAM_DISK_M1 | RAM_DISK_M_8F
			call dzx0RD

			; unpack sprites to the ram-disk to $8000
			lxi d, toBank0addr0
			lxi b, SCR_ADDR
			mvi a, RAM_DISK_M0 | RAM_DISK_M_8F
			call dzx0RD
			; preshift sprites
			;call SpritesPreshift
			; copy sprites to the ram-disk to a proper addr
			lxi d, $0000
			lxi h, $8000
			lxi b, $4000
			mvi a, RAM_DISK_S0 | RAM_DISK_M0 | RAM_DISK_M_8F
			call CopyToRamDisk

			; unpack tiles and levels to the ram-disk
			lxi d, toBank0addr8000
			lxi b, $8000
			mvi a, RAM_DISK_M0 | RAM_DISK_M_8F
			call dzx0RD
			ret
			.closelabels