; source\sprites\bomb_slow.json
__RAM_DISK_S_BOMB_SLOW = RAM_DISK_S
; source\sprites\bomb_slow.json
__RAM_DISK_M_BOMB_SLOW = RAM_DISK_M
__bomb_slow_sprites:
			.byte 1,1  ; safety pair of bytes to support a stack renderer, and also (maskFlag, preshifting is done)
__bomb_slow_run0_0:
			.byte 4, 0; offsetY, offsetX
			.byte 6, 0; height, width
			.byte 207,0,207,0,207,48,135,72,135,48,135,48,3,120,3,120,3,132,3,132,3,120,3,120,135,48,135,48,135,72,207,48,207,0,207,0,

			.byte -1, 1 ; safety pair of bytes to support a stack renderer and also (copyFromBuffOffset, maskFlag)
__bomb_slow_run0_1:
			.byte 4, 0; offsetY, offsetX
			.byte 6, 0; height, width
			.byte 255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,

			.byte 0, 1 ; safety pair of bytes to support a stack renderer and also (copyFromBuffOffset, maskFlag)
__bomb_slow_run0_2:
			.byte 4, 0; offsetY, offsetX
			.byte 6, 1; height, width
			.byte 255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,

			.byte 0, 1 ; safety pair of bytes to support a stack renderer and also (copyFromBuffOffset, maskFlag)
__bomb_slow_run0_3:
			.byte 4, 0; offsetY, offsetX
			.byte 6, 1; height, width
			.byte 255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,

			.byte 1,1  ; safety pair of bytes to support a stack renderer, and also (maskFlag, preshifting is done)
__bomb_slow_run1_0:
			.byte 4, 0; offsetY, offsetX
			.byte 6, 0; height, width
			.byte 207,0,207,0,207,48,135,72,135,48,135,0,3,0,3,120,3,132,3,132,3,120,3,0,135,0,135,48,135,72,207,48,207,0,207,0,

			.byte -1, 1 ; safety pair of bytes to support a stack renderer and also (copyFromBuffOffset, maskFlag)
__bomb_slow_run1_1:
			.byte 4, 0; offsetY, offsetX
			.byte 6, 0; height, width
			.byte 255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,

			.byte 0, 1 ; safety pair of bytes to support a stack renderer and also (copyFromBuffOffset, maskFlag)
__bomb_slow_run1_2:
			.byte 4, 0; offsetY, offsetX
			.byte 6, 1; height, width
			.byte 255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,

			.byte 0, 1 ; safety pair of bytes to support a stack renderer and also (copyFromBuffOffset, maskFlag)
__bomb_slow_run1_3:
			.byte 4, 0; offsetY, offsetX
			.byte 6, 1; height, width
			.byte 255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,

			.byte 1,1  ; safety pair of bytes to support a stack renderer, and also (maskFlag, preshifting is done)
__bomb_slow_dmg0_0:
			.byte 4, 0; offsetY, offsetX
			.byte 6, 0; height, width
			.byte 207,0,207,0,207,48,135,120,135,48,135,48,3,120,3,120,3,252,3,252,3,120,3,120,135,48,135,48,135,120,207,48,207,0,207,0,

			.byte -1, 1 ; safety pair of bytes to support a stack renderer and also (copyFromBuffOffset, maskFlag)
__bomb_slow_dmg0_1:
			.byte 4, 0; offsetY, offsetX
			.byte 6, 0; height, width
			.byte 255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,

			.byte 0, 1 ; safety pair of bytes to support a stack renderer and also (copyFromBuffOffset, maskFlag)
__bomb_slow_dmg0_2:
			.byte 4, 0; offsetY, offsetX
			.byte 6, 1; height, width
			.byte 255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,

			.byte 0, 1 ; safety pair of bytes to support a stack renderer and also (copyFromBuffOffset, maskFlag)
__bomb_slow_dmg0_3:
			.byte 4, 0; offsetY, offsetX
			.byte 6, 1; height, width
			.byte 255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,

			.byte 1,1  ; safety pair of bytes to support a stack renderer, and also (maskFlag, preshifting is done)
__bomb_slow_dmg1_0:
			.byte 4, 0; offsetY, offsetX
			.byte 6, 0; height, width
			.byte 207,48,207,48,207,48,135,120,135,72,135,72,3,132,3,132,3,252,3,252,3,132,3,132,135,72,135,72,135,120,207,48,207,48,207,48,

			.byte -1, 1 ; safety pair of bytes to support a stack renderer and also (copyFromBuffOffset, maskFlag)
__bomb_slow_dmg1_1:
			.byte 4, 0; offsetY, offsetX
			.byte 6, 0; height, width
			.byte 255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,

			.byte 0, 1 ; safety pair of bytes to support a stack renderer and also (copyFromBuffOffset, maskFlag)
__bomb_slow_dmg1_2:
			.byte 4, 0; offsetY, offsetX
			.byte 6, 1; height, width
			.byte 255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,

			.byte 0, 1 ; safety pair of bytes to support a stack renderer and also (copyFromBuffOffset, maskFlag)
__bomb_slow_dmg1_3:
			.byte 4, 0; offsetY, offsetX
			.byte 6, 1; height, width
			.byte 255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,
