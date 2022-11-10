; sources\sprites\scythe.json
scythe_sprites:
			.byte 1,1  ; safety pair of bytes to support a stack renderer, and also (maskFlag, preshifting is done)
scythe_run_rn0_0:
			.byte 4, 0; offsetY, offsetX
			.byte 5, 1; height, width
			.byte 31,0,255,64,255,0,31,0,255,128,31,0,255,4,255,64,255,0,255,0,255,32,255,0,255,0,255,48,255,0,255,4,255,192,255,11,255,248,255,0,255,192,255,7,255,48,255,0,255,0,255,16,255,0,255,120,255,32,255,128,

			.byte 0, 1 ; safety pair of bytes to support a stack renderer and also (copyFromBuffOffset, maskFlag)
scythe_run_rn0_1:
			.byte 4, 0; offsetY, offsetX
			.byte 5, 1; height, width
			.byte 255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,

			.byte 0, 1 ; safety pair of bytes to support a stack renderer and also (copyFromBuffOffset, maskFlag)
scythe_run_rn0_2:
			.byte 4, 0; offsetY, offsetX
			.byte 5, 1; height, width
			.byte 255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,

			.byte 0, 1 ; safety pair of bytes to support a stack renderer and also (copyFromBuffOffset, maskFlag)
scythe_run_rn0_3:
			.byte 4, 0; offsetY, offsetX
			.byte 5, 2; height, width
			.byte 255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,

			.byte 1,1  ; safety pair of bytes to support a stack renderer, and also (maskFlag, preshifting is done)
scythe_run_ln0_0:
			.byte 4, 0; offsetY, offsetX
			.byte 5, 1; height, width
			.byte 31,48,255,0,255,0,31,0,255,0,31,16,255,34,255,0,255,0,255,0,255,0,255,96,255,192,255,0,255,0,255,2,255,0,255,125,255,65,255,240,255,0,255,62,255,0,255,192,255,128,255,0,255,224,255,1,255,16,255,64,

			.byte 0, 1 ; safety pair of bytes to support a stack renderer and also (copyFromBuffOffset, maskFlag)
scythe_run_ln0_1:
			.byte 4, 0; offsetY, offsetX
			.byte 5, 1; height, width
			.byte 255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,

			.byte 0, 1 ; safety pair of bytes to support a stack renderer and also (copyFromBuffOffset, maskFlag)
scythe_run_ln0_2:
			.byte 4, 0; offsetY, offsetX
			.byte 5, 1; height, width
			.byte 255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,

			.byte 0, 1 ; safety pair of bytes to support a stack renderer and also (copyFromBuffOffset, maskFlag)
scythe_run_ln0_3:
			.byte 4, 0; offsetY, offsetX
			.byte 5, 2; height, width
			.byte 255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,

			.byte 1,1  ; safety pair of bytes to support a stack renderer, and also (maskFlag, preshifting is done)
scythe_run_lf0_0:
			.byte 4, 0; offsetY, offsetX
			.byte 5, 1; height, width
			.byte 31,128,255,0,255,224,31,1,255,16,31,126,255,1,255,0,255,0,255,62,255,0,255,192,255,192,255,0,255,0,255,2,255,0,255,33,255,32,255,0,255,0,255,0,255,0,255,64,255,32,255,0,255,0,255,0,255,0,255,0,

			.byte 0, 1 ; safety pair of bytes to support a stack renderer and also (copyFromBuffOffset, maskFlag)
scythe_run_lf0_1:
			.byte 4, 0; offsetY, offsetX
			.byte 5, 1; height, width
			.byte 255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,

			.byte 0, 1 ; safety pair of bytes to support a stack renderer and also (copyFromBuffOffset, maskFlag)
scythe_run_lf0_2:
			.byte 4, 0; offsetY, offsetX
			.byte 5, 1; height, width
			.byte 255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,

			.byte 0, 1 ; safety pair of bytes to support a stack renderer and also (copyFromBuffOffset, maskFlag)
scythe_run_lf0_3:
			.byte 4, 0; offsetY, offsetX
			.byte 5, 2; height, width
			.byte 255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,

			.byte 1,1  ; safety pair of bytes to support a stack renderer, and also (maskFlag, preshifting is done)
scythe_run_rf0_0:
			.byte 4, 0; offsetY, offsetX
			.byte 5, 1; height, width
			.byte 31,0,255,16,255,0,31,120,255,224,31,135,255,0,255,0,255,192,255,7,255,48,255,0,255,0,255,48,255,0,255,4,255,0,255,2,255,0,255,64,255,0,255,0,255,32,255,0,255,0,255,64,255,0,255,0,255,0,255,0,

			.byte 0, 1 ; safety pair of bytes to support a stack renderer and also (copyFromBuffOffset, maskFlag)
scythe_run_rf0_1:
			.byte 4, 0; offsetY, offsetX
			.byte 5, 1; height, width
			.byte 255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,

			.byte 0, 1 ; safety pair of bytes to support a stack renderer and also (copyFromBuffOffset, maskFlag)
scythe_run_rf0_2:
			.byte 4, 0; offsetY, offsetX
			.byte 5, 1; height, width
			.byte 255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,

			.byte 0, 1 ; safety pair of bytes to support a stack renderer and also (copyFromBuffOffset, maskFlag)
scythe_run_rf0_3:
			.byte 4, 0; offsetY, offsetX
			.byte 5, 2; height, width
			.byte 255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,

			.byte 1,1  ; safety pair of bytes to support a stack renderer, and also (maskFlag, preshifting is done)
scythe_run_un0_0:
			.byte 0, 0; offsetY, offsetX
			.byte 12, 0; height, width
			.byte 31,192,31,0,31,0,143,0,143,128,143,64,159,64,159,128,159,0,159,0,159,128,159,64,151,96,151,128,151,0,135,0,135,96,135,16,15,32,15,64,15,0,31,0,31,64,31,32,255,40,255,64,255,0,255,8,255,64,255,48,255,128,255,0,255,112,255,224,255,0,255,0,

			.byte 0, 1 ; safety pair of bytes to support a stack renderer and also (copyFromBuffOffset, maskFlag)
scythe_run_un0_1:
			.byte 0, 0; offsetY, offsetX
			.byte 12, 0; height, width
			.byte 255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,

			.byte 0, 1 ; safety pair of bytes to support a stack renderer and also (copyFromBuffOffset, maskFlag)
scythe_run_un0_2:
			.byte 0, 0; offsetY, offsetX
			.byte 12, 1; height, width
			.byte 255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,

			.byte 0, 1 ; safety pair of bytes to support a stack renderer and also (copyFromBuffOffset, maskFlag)
scythe_run_un0_3:
			.byte 0, 0; offsetY, offsetX
			.byte 12, 1; height, width
			.byte 255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,

			.byte 1,1  ; safety pair of bytes to support a stack renderer, and also (maskFlag, preshifting is done)
scythe_run_uf0_0:
			.byte 0, 0; offsetY, offsetX
			.byte 12, 0; height, width
			.byte 31,0,31,0,31,0,143,0,143,0,143,0,159,0,159,0,159,0,159,0,159,0,159,0,151,0,151,0,151,0,135,0,135,0,135,0,15,0,15,0,15,0,31,0,31,0,31,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,

			.byte 1, 1 ; safety pair of bytes to support a stack renderer and also (copyFromBuffOffset, maskFlag)
scythe_run_uf0_1:
			.byte 0, 1; offsetY, offsetX
			.byte 12, -1; height, width
			.byte 

			.byte 1, 1 ; safety pair of bytes to support a stack renderer and also (copyFromBuffOffset, maskFlag)
scythe_run_uf0_2:
			.byte 0, 1; offsetY, offsetX
			.byte 12, -1; height, width
			.byte 

			.byte 1, 1 ; safety pair of bytes to support a stack renderer and also (copyFromBuffOffset, maskFlag)
scythe_run_uf0_3:
			.byte 0, 1; offsetY, offsetX
			.byte 12, -1; height, width
			.byte 

			.byte 1,1  ; safety pair of bytes to support a stack renderer, and also (maskFlag, preshifting is done)
scythe_run_dn0_0:
			.byte 0, 0; offsetY, offsetX
			.byte 12, 0; height, width
			.byte 31,56,31,0,31,0,143,56,143,0,143,64,159,136,159,0,159,112,159,128,159,16,159,8,151,8,151,16,151,0,135,0,135,16,135,8,15,40,15,16,15,0,31,0,31,48,31,8,255,4,255,8,255,0,255,0,255,8,255,4,255,4,255,8,255,0,255,0,255,8,255,4,

			.byte 0, 1 ; safety pair of bytes to support a stack renderer and also (copyFromBuffOffset, maskFlag)
scythe_run_dn0_1:
			.byte 0, 0; offsetY, offsetX
			.byte 12, 0; height, width
			.byte 255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,

			.byte 0, 1 ; safety pair of bytes to support a stack renderer and also (copyFromBuffOffset, maskFlag)
scythe_run_dn0_2:
			.byte 0, 0; offsetY, offsetX
			.byte 12, 1; height, width
			.byte 255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,

			.byte 0, 1 ; safety pair of bytes to support a stack renderer and also (copyFromBuffOffset, maskFlag)
scythe_run_dn0_3:
			.byte 0, 0; offsetY, offsetX
			.byte 12, 1; height, width
			.byte 255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,

			.byte 1,1  ; safety pair of bytes to support a stack renderer, and also (maskFlag, preshifting is done)
scythe_run_df0_0:
			.byte 0, 0; offsetY, offsetX
			.byte 12, 0; height, width
			.byte 31,0,31,0,31,0,143,0,143,0,143,0,159,0,159,0,159,0,159,0,159,0,159,0,151,0,151,0,151,0,135,0,135,0,135,0,15,0,15,0,15,0,31,0,31,0,31,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,

			.byte 1, 1 ; safety pair of bytes to support a stack renderer and also (copyFromBuffOffset, maskFlag)
scythe_run_df0_1:
			.byte 0, 1; offsetY, offsetX
			.byte 12, -1; height, width
			.byte 

			.byte 1, 1 ; safety pair of bytes to support a stack renderer and also (copyFromBuffOffset, maskFlag)
scythe_run_df0_2:
			.byte 0, 1; offsetY, offsetX
			.byte 12, -1; height, width
			.byte 

			.byte 1, 1 ; safety pair of bytes to support a stack renderer and also (copyFromBuffOffset, maskFlag)
scythe_run_df0_3:
			.byte 0, 1; offsetY, offsetX
			.byte 12, -1; height, width
			.byte 
