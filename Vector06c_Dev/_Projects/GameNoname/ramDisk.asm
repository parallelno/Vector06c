RamDiskInit:
			
			; copy music to the ram-disk. do it first
			; because it is stored at the end of the 
			; game-rom and will be destroyed the fist 
			; unpacking process like unpack sprites below
			lxi d, toBank1addrA000 + MUSIC_BIN_LEN
			lxi h, $A000 + MUSIC_BIN_LEN
			lxi b, MUSIC_BIN_LEN / 2
			mvi a, RAM_DISK0_B1_STACK
			call CopyToRamDisk

			; unpack sprites to the ram-disk
			lxi b, $8000
			lxi h, $8000
			lxi d, toBank0addr0
			mvi a, RAM_DISK0_B0_STACK
			call UnpackToRamDisk

			; unpack tiles and levels to the ram-disk
			lxi b, $8000
			lxi h, $0000
			lxi d, toBank0addr8000
			mvi a, RAM_DISK0_B0_STACK
			call UnpackToRamDisk		
			
			; unpack utils to the ram-disk
			lxi b, $8000
			lxi h, $0000
			lxi d, toBank2addr8000
			mvi a, RAM_DISK0_B2_STACK
			call UnpackToRamDisk

			ret
			.closelabels