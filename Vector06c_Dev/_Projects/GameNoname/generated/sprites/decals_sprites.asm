; source\sprites\decals.json
__RAM_DISK_S_DECALS = RAM_DISK_S
__RAM_DISK_M_DECALS = RAM_DISK_M

			.byte 0,0  ; safety pair of bytes to support a stack renderer
__decals_walkable_sprite_ptrs: .word __decals_bones, 0, __decals_skull, 

			.byte 0,0  ; safety pair of bytes to support a stack renderer
__decals_collision_sprite_ptrs: .word __decals_web1, 0, 

__decals_sprites:
			.byte 0,0  ; safety pair of bytes to support a stack renderer
__decals_bones:
			.byte 0, 0; offset_y, offset_x
			.byte 12, 1; height, width
			.byte 255,239,0,0,0,0,0,0,16,0,255,199,0,40,0,0,16,0,0,0,255,131,0,0,32,0,24,0,68,0,254,7,1,152,32,0,64,0,0,0,252,31,0,0,0,0,192,1,32,2,246,63,9,64,128,0,0,0,0,0,227,127,0,0,0,8,0,0,128,20,193,255,34,0,0,24,0,4,0,0,224,127,0,0,0,2,0,4,128,25,248,63,4,64,128,2,0,1,0,0,252,127,0,0,0,0,0,1,128,2,254,255,1,0,0,0,0,0,0,0,


			.byte 0,0  ; safety pair of bytes to support a stack renderer
__decals_skull:
			.byte 0, 0; offset_y, offset_x
			.byte 14, 1; height, width
			.byte 253,255,0,0,0,0,0,0,0,2,248,255,5,0,0,0,0,2,0,0,240,127,0,0,0,6,0,1,128,8,192,255,51,0,0,0,0,12,0,0,131,255,0,0,0,16,0,40,0,68,199,255,40,0,0,16,0,0,0,0,238,159,0,0,0,0,0,0,96,17,252,7,2,152,32,1,64,0,0,0,252,3,0,0,224,3,24,0,4,0,252,3,3,116,8,0,128,0,0,0,253,51,0,0,128,0,8,0,68,2,252,3,0,4,48,2,200,1,0,0,252,7,0,0,0,1,240,0,8,2,254,15,1,240,0,0,0,0,0,0,


			.byte 0,0  ; safety pair of bytes to support a stack renderer
__decals_web1:
			.byte 0, 0; offset_y, offset_x
			.byte 14, 1; height, width
			.byte 247,255,0,0,0,0,0,0,0,8,227,255,20,0,0,0,0,8,0,0,199,159,0,0,0,16,0,0,96,40,193,15,46,208,64,8,32,16,64,8,128,31,6,0,128,32,0,6,96,95,136,63,118,64,0,32,128,1,0,32,141,15,50,0,64,0,0,50,176,114,0,7,255,104,96,78,144,0,96,78,16,15,66,0,0,9,0,66,240,230,0,255,251,0,0,80,0,4,0,80,3,255,40,0,0,0,0,40,0,252,7,255,248,0,0,80,0,0,0,80,15,255,96,0,0,0,0,96,0,240,31,255,224,0,0,64,0,0,0,64,

