; source\sprites\heroL.json
__RAM_DISK_SPRITE_DATA_HEROL = RAM_DISK_BANK_ACTIVATION_CMD
__heroL_sprites:
			.byte 1,1  ; safety pair of bytes to support a stack renderer, and also (maskFlag, preshifting is done)
__heroL_idle0_0:
			.byte 0, 0; offsetY, offsetX
			.byte 15, 1; height, width
			.byte 240,6,131,56,131,0,240,0,131,68,240,9,248,5,3,196,3,0,248,0,3,56,248,2,248,3,7,112,7,0,248,0,7,136,248,4,224,31,1,254,1,112,224,2,1,0,224,1,192,8,1,4,1,112,192,1,1,138,192,62,128,120,1,74,1,180,128,7,1,0,128,48,0,96,3,96,3,96,0,1,3,252,0,254,24,228,7,56,7,208,24,3,7,208,24,67,48,7,7,224,7,224,48,7,7,24,48,203,240,8,3,4,3,240,240,7,3,232,240,7,224,3,1,88,1,96,224,3,1,6,224,24,192,32,0,1,0,254,192,31,0,0,192,0,224,3,1,240,1,0,224,0,1,14,224,28,248,4,7,8,7,240,248,3,7,0,248,0,252,0,15,0,15,0,252,0,15,240,252,3,

			.byte 0, 1 ; safety pair of bytes to support a stack renderer and also (copyFromBuffOffset, maskFlag)
__heroL_idle0_1:
			.byte 0, 0; offsetY, offsetX
			.byte 15, 2; height, width
			.byte 255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,

			.byte 0, 1 ; safety pair of bytes to support a stack renderer and also (copyFromBuffOffset, maskFlag)
__heroL_idle0_2:
			.byte 0, 0; offsetY, offsetX
			.byte 15, 2; height, width
			.byte 255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,

			.byte 0, 1 ; safety pair of bytes to support a stack renderer and also (copyFromBuffOffset, maskFlag)
__heroL_idle0_3:
			.byte 0, 0; offsetY, offsetX
			.byte 15, 2; height, width
			.byte 255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,

			.byte 1,1  ; safety pair of bytes to support a stack renderer, and also (maskFlag, preshifting is done)
__heroL_run0_0:
			.byte 0, 0; offsetY, offsetX
			.byte 15, 1; height, width
			.byte 252,0,7,224,7,0,252,0,7,24,252,3,248,6,7,136,7,0,248,0,7,112,248,1,248,3,7,112,7,0,248,0,7,136,248,4,224,31,1,254,1,112,224,2,1,0,224,1,192,8,1,4,1,112,192,1,1,138,192,62,128,120,1,74,1,180,128,7,1,0,128,48,0,96,3,96,3,96,0,1,3,252,0,254,24,228,7,56,7,208,24,3,7,208,24,67,48,7,7,224,7,224,48,7,7,24,48,203,240,8,3,4,3,240,240,7,3,232,240,7,224,3,1,88,1,96,224,3,1,6,224,24,192,32,0,1,0,254,192,31,0,0,192,0,224,3,1,240,1,0,224,0,1,14,224,28,248,4,7,8,7,240,248,3,7,0,248,0,252,0,15,0,15,0,252,0,15,240,252,3,

			.byte 0, 1 ; safety pair of bytes to support a stack renderer and also (copyFromBuffOffset, maskFlag)
__heroL_run0_1:
			.byte 0, 0; offsetY, offsetX
			.byte 15, 2; height, width
			.byte 255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,

			.byte 0, 1 ; safety pair of bytes to support a stack renderer and also (copyFromBuffOffset, maskFlag)
__heroL_run0_2:
			.byte 0, 0; offsetY, offsetX
			.byte 15, 2; height, width
			.byte 255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,

			.byte 0, 1 ; safety pair of bytes to support a stack renderer and also (copyFromBuffOffset, maskFlag)
__heroL_run0_3:
			.byte 0, 0; offsetY, offsetX
			.byte 15, 2; height, width
			.byte 255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,

			.byte 1,1  ; safety pair of bytes to support a stack renderer, and also (maskFlag, preshifting is done)
__heroL_run1_0:
			.byte 0, 0; offsetY, offsetX
			.byte 15, 1; height, width
			.byte 252,0,15,224,15,0,252,0,15,16,252,3,248,4,15,16,15,0,248,0,15,224,248,3,248,1,15,96,15,0,248,0,15,144,248,6,224,31,1,254,1,112,224,2,1,0,224,1,192,8,1,4,1,112,192,1,1,138,192,62,128,120,1,74,1,180,128,7,1,0,128,48,0,96,3,96,3,96,0,1,3,252,0,254,24,228,7,56,7,208,24,3,7,208,24,67,48,7,7,224,7,224,48,7,7,24,48,203,240,8,3,4,3,240,240,7,3,232,240,7,224,3,1,88,1,96,224,3,1,6,224,24,192,32,0,1,0,254,192,31,0,0,192,0,224,3,1,240,1,0,224,0,1,14,224,28,248,4,7,8,7,240,248,3,7,0,248,0,252,0,15,0,15,0,252,0,15,240,252,3,

			.byte 0, 1 ; safety pair of bytes to support a stack renderer and also (copyFromBuffOffset, maskFlag)
__heroL_run1_1:
			.byte 0, 0; offsetY, offsetX
			.byte 15, 2; height, width
			.byte 255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,

			.byte 0, 1 ; safety pair of bytes to support a stack renderer and also (copyFromBuffOffset, maskFlag)
__heroL_run1_2:
			.byte 0, 0; offsetY, offsetX
			.byte 15, 2; height, width
			.byte 255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,

			.byte 0, 1 ; safety pair of bytes to support a stack renderer and also (copyFromBuffOffset, maskFlag)
__heroL_run1_3:
			.byte 0, 0; offsetY, offsetX
			.byte 15, 2; height, width
			.byte 255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,

			.byte 1,1  ; safety pair of bytes to support a stack renderer, and also (maskFlag, preshifting is done)
__heroL_run2_0:
			.byte 0, 0; offsetY, offsetX
			.byte 15, 1; height, width
			.byte 252,0,193,28,193,0,252,0,193,34,252,3,240,13,1,226,1,0,240,0,1,28,240,2,240,7,3,120,3,0,240,0,3,132,240,8,224,31,1,254,1,112,224,2,1,0,224,1,192,8,1,4,1,112,192,1,1,138,192,62,128,120,1,74,1,180,128,7,1,0,128,48,0,96,3,96,3,96,0,1,3,252,0,254,24,228,7,56,7,208,24,3,7,208,24,67,48,7,7,224,7,224,48,7,7,24,48,203,240,8,3,4,3,240,240,7,3,232,240,7,224,3,1,88,1,96,224,3,1,6,224,24,192,32,0,1,0,254,192,31,0,0,192,0,224,3,1,240,1,0,224,0,1,14,224,28,248,4,7,8,7,240,248,3,7,0,248,0,252,0,15,0,15,0,252,0,15,240,252,3,

			.byte 0, 1 ; safety pair of bytes to support a stack renderer and also (copyFromBuffOffset, maskFlag)
__heroL_run2_1:
			.byte 0, 0; offsetY, offsetX
			.byte 15, 2; height, width
			.byte 255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,

			.byte 0, 1 ; safety pair of bytes to support a stack renderer and also (copyFromBuffOffset, maskFlag)
__heroL_run2_2:
			.byte 0, 0; offsetY, offsetX
			.byte 15, 2; height, width
			.byte 255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,

			.byte 0, 1 ; safety pair of bytes to support a stack renderer and also (copyFromBuffOffset, maskFlag)
__heroL_run2_3:
			.byte 0, 0; offsetY, offsetX
			.byte 15, 2; height, width
			.byte 255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,

			.byte 1,1  ; safety pair of bytes to support a stack renderer, and also (maskFlag, preshifting is done)
__heroL_run3_0:
			.byte 0, 0; offsetY, offsetX
			.byte 15, 1; height, width
			.byte 224,14,143,0,143,0,224,0,143,112,224,17,240,9,3,140,3,0,240,0,3,112,240,6,248,3,3,120,3,0,248,0,3,132,248,4,224,31,1,254,1,112,224,2,1,0,224,1,192,8,1,4,1,112,192,1,1,138,192,62,128,120,1,74,1,180,128,7,1,0,128,48,0,96,3,96,3,96,0,1,3,252,0,254,24,228,7,56,7,208,24,3,7,208,24,67,48,7,7,224,7,224,48,7,7,24,48,203,240,8,3,4,3,240,240,7,3,232,240,7,224,3,1,88,1,96,224,3,1,6,224,24,192,32,0,1,0,254,192,31,0,0,192,0,224,3,1,240,1,0,224,0,1,14,224,28,248,4,7,8,7,240,248,3,7,0,248,0,252,0,15,0,15,0,252,0,15,240,252,3,

			.byte 0, 1 ; safety pair of bytes to support a stack renderer and also (copyFromBuffOffset, maskFlag)
__heroL_run3_1:
			.byte 0, 0; offsetY, offsetX
			.byte 15, 2; height, width
			.byte 255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,

			.byte 0, 1 ; safety pair of bytes to support a stack renderer and also (copyFromBuffOffset, maskFlag)
__heroL_run3_2:
			.byte 0, 0; offsetY, offsetX
			.byte 15, 2; height, width
			.byte 255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,

			.byte 0, 1 ; safety pair of bytes to support a stack renderer and also (copyFromBuffOffset, maskFlag)
__heroL_run3_3:
			.byte 0, 0; offsetY, offsetX
			.byte 15, 2; height, width
			.byte 255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,

			.byte 1,1  ; safety pair of bytes to support a stack renderer, and also (maskFlag, preshifting is done)
__heroL_attk0_0:
			.byte 0, 0; offsetY, offsetX
			.byte 15, 1; height, width
			.byte 225,0,131,56,131,0,225,0,131,68,225,30,224,17,3,196,3,0,224,0,3,56,224,14,224,7,7,112,7,0,224,0,7,136,224,24,240,13,1,254,1,112,240,1,1,0,240,2,248,1,1,4,1,112,248,2,1,138,248,7,248,4,1,74,1,180,248,3,1,0,248,0,240,0,3,96,3,96,240,3,3,252,240,12,224,26,7,56,7,208,224,5,7,208,224,1,224,3,7,224,7,224,224,11,7,24,224,23,224,19,3,4,3,240,224,12,3,232,224,0,224,0,1,88,1,96,224,12,1,134,224,19,192,47,0,193,0,62,192,16,0,0,192,3,224,1,1,192,1,0,224,0,1,254,224,31,248,5,3,252,3,0,248,2,3,120,248,0,252,0,7,0,7,0,252,0,7,248,252,3,

			.byte 0, 1 ; safety pair of bytes to support a stack renderer and also (copyFromBuffOffset, maskFlag)
__heroL_attk0_1:
			.byte 0, 0; offsetY, offsetX
			.byte 15, 2; height, width
			.byte 255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,

			.byte 0, 1 ; safety pair of bytes to support a stack renderer and also (copyFromBuffOffset, maskFlag)
__heroL_attk0_2:
			.byte 0, 0; offsetY, offsetX
			.byte 15, 2; height, width
			.byte 255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,

			.byte 1, 1 ; safety pair of bytes to support a stack renderer and also (copyFromBuffOffset, maskFlag)
__heroL_attk0_3:
			.byte 0, 1; offsetY, offsetX
			.byte 15, 1; height, width
			.byte 255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,

			.byte 1,1  ; safety pair of bytes to support a stack renderer, and also (maskFlag, preshifting is done)
__heroL_attk1_0:
			.byte 0, 0; offsetY, offsetX
			.byte 15, 1; height, width
			.byte 224,14,131,56,131,0,224,0,131,68,224,17,224,25,3,204,3,0,224,0,3,48,224,6,240,7,7,112,7,0,240,0,7,136,240,8,240,15,1,254,1,224,240,4,1,0,240,2,240,0,1,4,1,224,240,2,1,26,240,13,240,0,3,132,3,120,240,15,3,0,240,0,240,0,7,192,7,192,240,6,7,248,240,9,240,8,15,112,15,160,240,7,15,160,240,7,224,15,15,192,15,192,224,15,15,48,224,22,224,16,7,8,7,224,224,15,7,208,224,15,192,6,3,176,3,192,192,6,3,12,192,48,128,64,1,2,1,252,128,63,1,0,128,0,192,7,3,224,3,0,192,0,3,28,192,56,240,8,15,16,15,224,240,7,15,0,240,0,248,0,31,0,31,0,248,0,31,224,248,7,

			.byte 0, 1 ; safety pair of bytes to support a stack renderer and also (copyFromBuffOffset, maskFlag)
__heroL_attk1_1:
			.byte 0, 0; offsetY, offsetX
			.byte 15, 2; height, width
			.byte 255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,

			.byte 0, 1 ; safety pair of bytes to support a stack renderer and also (copyFromBuffOffset, maskFlag)
__heroL_attk1_2:
			.byte 0, 0; offsetY, offsetX
			.byte 15, 2; height, width
			.byte 255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,

			.byte 0, 1 ; safety pair of bytes to support a stack renderer and also (copyFromBuffOffset, maskFlag)
__heroL_attk1_3:
			.byte 0, 0; offsetY, offsetX
			.byte 15, 2; height, width
			.byte 255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,
