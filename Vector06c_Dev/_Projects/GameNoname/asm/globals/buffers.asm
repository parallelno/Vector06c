	; this line for VSCode proper formating
; TODO: move all global vars here
; TODO: rename buffers.asm to vars.asm

;=============================================================================
; this buffer contains of two bytes (room_id, tile_idx) for every instance of resources in rooms.
ROOMS_RESOURCES_UNIQUE_MAX		= 16
ROOMS_RESOURCES_INSTANCES_MAX	= 8
RESOURCE_STATUS_NOT_ACQUIRED	= $ff

; data format:
; .loop ROOMS_RESOURCES_UNIQUE_MAX
;	.loop ROOMS_RESOURCES_INSTANCES_MAX
;		.byte room_id ; if room_id = RESOURCE_STATUS_NOT_ACQUIRED, then this resource has not picked up yet
;		.byte tile_idx
;	.endloop
; .endloop

rooms_resources				= $7a00
rooms_resources_end			= rooms_resources + ROOMS_RESOURCES_UNIQUE_MAX * ROOMS_RESOURCES_INSTANCES_MAX * WORD_LEN

;=============================================================================
; rooms runtime data. each byte represents a spawn rate in a particular room.
; data format:
; .loop ROOMS_MAX
;	.byte - a spawn rate
; .endloop

rooms_runtime_data			= $7b00
rooms_spawn_rate_monsters	= rooms_runtime_data 					; 0 means 100% chance to spawn a monster. 255 means no spawn
rooms_spawn_rate_breakables = rooms_spawn_rate_monsters + ROOMS_MAX ; 0 means 100% chance to spawn a breakable item. 255 means no spawn
rooms_runtime_data_end		= rooms_spawn_rate_breakables + ROOMS_MAX ; $7b80

;=============================================================================
;
;	free space = $7b80 - $7c10
;

;=============================================================================
; contains a status for every global item.
ITEM_STATUS_NOT_ACQUIRED	= 0
ITEM_STATUS_ACQUIRED		= 1
ITEM_STATUS_USED			= 2
ITEMS_MAX					= 16

; data format:
; .loop ITEMS_MAX
;	.byte status for item_id = 0
; .endloop

global_items				= $7c10
global_items_end = global_items + ITEMS_MAX

;=============================================================================
; tile graphics pointer table.
room_tiles_gfx_ptrs			= $7c20
room_tiles_gfx_ptrs_size	= ROOM_WIDTH * ROOM_HEIGHT * ADDR_LEN
room_tiles_gfx_ptrs_end		= room_tiles_gfx_ptrs + room_tiles_gfx_ptrs_size

;=============================================================================
; tiledata buffer has to follow room_tiles_gfx_ptrs because they are unpacked altogether. see level_data.asm for tiledata format
room_tiledata		= $7e00
room_tiledata_size	= ROOM_WIDTH * ROOM_HEIGHT
room_tiledata_end	= room_tiledata + room_tiledata_size

BUFFERS_START_ADDR	= rooms_runtime_data
BUFFERS_END_ADDR	= room_tiledata_end

;=============================================================================
; check buffer overlapping
;

; TODO: update checkers after finalizing buffers layout
.if rooms_runtime_data_end > room_tiles_gfx_ptrs
	.error "rooms_runtime_data_end and room_tiles_gfx_ptrs overlap"
.endif

.if room_tiles_gfx_ptrs_end > room_tiledata
	.error "room_tiles_gfx_ptrs_end and room_tiledata overlap"
.endif

.if STACK_MIN_ADDR < BUFFERS_END_ADDR
	.error "game temp buffers and stack overlap"
.endif

