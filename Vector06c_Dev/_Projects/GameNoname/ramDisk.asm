RamDiskInit:
			; unpack utils to the ram-disk
			lxi d, toBank2addr8000
			lxi b, $8000
			mvi a, RAM_DISK0_B2_8AF_RAM
			call dzx0RD

			; unpack music to the ram-disk
			lxi d, toBank1addrA000
			lxi b, $A000
			mvi a, RAM_DISK0_B1_8AF_RAM
			call dzx0RD

			; unpack sprites to the ram-disk
			lxi d, toBank0addr0
			lxi b, SCR_ADDR
			mvi a, RAM_DISK0_B0_8AF_RAM
			call dzx0RD
			; preshift sprites
			;call SpritesPreshift
			; copy sprites to the ram-disk
			lxi d, $0000
			lxi h, $8000
			lxi b, $4000
			mvi a, RAM_DISK0_B0_STACK_B0_8AF_RAM
			call CopyToRamDisk

			; unpack tiles and levels to the ram-disk
			lxi d, toBank0addr8000
			lxi b, $8000
			mvi a, RAM_DISK0_B0_8AF_RAM
			call dzx0RD

			ret
			.closelabels