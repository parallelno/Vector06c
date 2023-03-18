			; this line is to make VS Code remember the text formatting.
;==================================================================================================
ROOM_TILES_GFX_PTRS_SIZE	= ROOM_WIDTH * ROOM_HEIGHT * ADDR_LEN
ROOM_TILEDATA_SIZE_ALIGNED	= $100
;==================================================================================================
BUFFERS_START_ADDR = STACK_MIN_ADDR - ROOM_TILEDATA_SIZE_ALIGNED - ROOM_TILES_GFX_PTRS_SIZE

; tile graphics pointer table. details in level_data.asm
room_tiles_gfx_ptrs = STACK_MIN_ADDR - ROOM_TILEDATA_SIZE_ALIGNED - ROOM_TILES_GFX_PTRS_SIZE

; tiledata buffer has to follow room_tiles_gfx_ptrs because they are unpacked together. details in level_data.asm
room_tiles_gfx_ptrs_end = room_tiles_gfx_ptrs + ROOM_TILES_GFX_PTRS_SIZE

room_tiledata	= STACK_MIN_ADDR - ROOM_TILEDATA_SIZE_ALIGNED
STACK_ADDR		= STACK_MIN_ADDR

