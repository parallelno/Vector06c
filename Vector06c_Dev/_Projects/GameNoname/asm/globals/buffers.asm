	; this line for VSCode proper formating
;=============================================================================
; buffers
;


; rooms runtime data
; TODO: replace dad with adi <ADDR in the pointer calc routines
rooms_runtime_data			= $7b00
rooms_spawn_rate_monsters	= rooms_runtime_data 					; 0 means 100% chance to spawn a monster. 255 means no spawn
rooms_spawn_rate_breakables = rooms_spawn_rate_monsters + ROOMS_MAX ; 0 means 100% chance to spawn a breakable item. 255 means no spawn
rooms_runtime_data_end		= rooms_spawn_rate_breakables + ROOMS_MAX ; $7b80

;
;master_music_mute				= $7b80 ; value = 0 means no mute (max volume), value >= 15 means mute
;master_sfx_mute					= $7b81 ; value = 0 means no mute (max volume), value >= 15 means mute
;	free space = $7b82 - $7c10
;

global_items				= $7c10
	global_item0 = global_items	; key blue
	global_item1 = global_items+1	; key red
	global_item2 = global_items+2	; key green
	global_item3 = global_items+3	; key magma
	global_item4 = global_items+4	; 
	global_item5 = global_items+5	; 
	global_item6 = global_items+6	; 
	global_item7 = global_items+7	; 
	global_item8 = global_items+8	; 
	global_item9 = global_items+9	; 
	global_itemA = global_items+10	; 
	global_itemB = global_items+11	; 
	global_itemC = global_items+12	; 
	global_itemD = global_items+13	; 
	global_itemE = global_items+14	; 
	global_itemF = global_items+15	;
global_items_end = global_items+16

; tile graphics pointer table.
room_tiles_gfx_ptrs			= $7c20
room_tiles_gfx_ptrs_size	= ROOM_WIDTH * ROOM_HEIGHT * ADDR_LEN
room_tiles_gfx_ptrs_end		= room_tiles_gfx_ptrs + room_tiles_gfx_ptrs_size

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

