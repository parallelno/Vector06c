	; this line for VSCode proper formating
; TODO: move all global vars here
; TODO: rename buffers.asm to vars.asm
;=============================================================================
; tiled image indices buffer
tiled_img_idxs:	= $7714
TILED_IMG_IDXS_LEN = $100

;=============================================================================
; ptr to the first bullet data in the sorted list

; TODO: think of removing it if it's still unusable
bullet_runtime_data_sorted:	= $7814 ; .byte <bullet_update_ptr

; a list of bullet runtime data structs.
bullets_runtime_data:		= $7815
bullet_update_ptr:			= bullets_runtime_data 					;.word TEMP_ADDR
bullet_draw_ptr:			= bullet_update_ptr + WORD_LEN			;.word TEMP_ADDR
bullet_id:					= bullet_draw_ptr + WORD_LEN			;.byte TEMP_BYTE
bullet_status:				= bullet_id + BYTE_LEN					;.byte TEMP_BYTE
bullet_status_timer:		= bullet_status + BYTE_LEN 				;.byte TEMP_BYTE
bullet_anim_timer:			= bullet_status_timer + BYTE_LEN		;.byte TEMP_BYTE
bullet_anim_ptr:			= bullet_anim_timer + BYTE_LEN			;.word TEMP_ADDR
bullet_erase_scr_addr:		= bullet_anim_ptr + WORD_LEN			;.word TEMP_WORD
bullet_erase_scr_addr_old:	= bullet_erase_scr_addr + WORD_LEN		;.word TEMP_ADDR
bullet_erase_wh:			= bullet_erase_scr_addr_old + WORD_LEN	;.word TEMP_WORD
bullet_erase_wh_old:		= bullet_erase_wh + WORD_LEN			;.word TEMP_WORD
bullet_pos_x:				= bullet_erase_wh_old + WORD_LEN		;.word TEMP_WORD
bullet_pos_y:				= bullet_pos_x + WORD_LEN				;.word TEMP_WORD
bullet_speed_x:				= bullet_pos_y + WORD_LEN				;.word TEMP_WORD
bullet_speed_y:				= bullet_speed_x + WORD_LEN				;.word TEMP_WORD
bullet_runtime_data_end:	= bullet_speed_y + WORD_LEN

BULLET_RUNTIME_DATA_LEN = bullet_runtime_data_end - bullets_runtime_data ; $1a; bullet_runtime_data_end_addr-bullets_runtime_data

; the same structs for the rest of the bullets
bullets_runtime_data_end_marker: = bullets_runtime_data + BULLET_RUNTIME_DATA_LEN * BULLETS_MAX ; $78ff ; :		.word ACTOR_RUNTIME_DATA_END << 8
bullets_runtime_data_end: = bullets_runtime_data_end_marker + WORD_LEN

;=============================================================================
; statuses of container instances. each instance is represented by a pair of bytes (room_id, tile_idx)
; this data is aligned to $100, the length is <= $100
CONTAINERS_UNIQUE_MAX		= 16
CONTAINERS_LEN				= $100
CONTAINERS_STATUS_ACQUIRED	= $ff

; data format:
; containers_inst_data_ptrs:
; .loop CONTAINERS_UNIQUE_MAX
;	.byte - a low byte ptr to container_inst_data for particular container
; .endloop
; .byte - a low byte ptr to the next addr after the last container_NN_inst_data_ptr
; container_inst_data:
; .loop CONTAINERS_UNIQUE_MAX
;	container_inst_data:
;		.byte - tile_idx where this container is placed
;		.byte - room_id where this container is placed. 
;				if room_id == CONTAINERS_STATUS_ACQUIRED, a container is acquired
; .endloop

containers_inst_data_ptrs:	= $7900
;containers_inst_data:		= containers_inst_data_ptrs + used_unique_containers (can vary) + 1
containers_inst_data_end:	= containers_inst_data_ptrs + CONTAINERS_LEN

;=============================================================================
; statuses of resource instances placed in rooms. 
; each instance is represented by a pair of bytes (room_id, tile_idx)
; this data is aligned to $100, the length is <= $100
RESOURCES_UNIQUE_MAX		= 16
RESOURCES_LEN				= $100
RESOURCES_STATUS_ACQUIRED	= $ff

; data format:
; resources_inst_data_ptrs:
; .loop RESOURCES_UNIQUE_MAX
;	.byte - a low byte ptr to resources_inst_data for particular resource
; .endloop
; .byte - a low byte ptr to the next addr after the last resource_NN_inst_data_ptr
; resources_inst_data:
; .loop RESOURCES_UNIQUE_MAX
;	resource_inst_data:
;		.byte - tile_idx where this resource is placed
;		.byte - room_id where this resource is placed. 
;				if room_id == RESOURCES_STATUS_ACQUIRED, a resource is acquired
; .endloop

resources_inst_data_ptrs:	= $7a00
;resources_inst_data:		= resources_inst_data_ptrs + used_unique_resources (can vary) + 1
resources_inst_data_end:	= resources_inst_data_ptrs + RESOURCES_LEN

;=============================================================================
; rooms spawn rates. each byte represents a spawn rate in a particular room.
; data format:
; .loop ROOMS_MAX
;	.byte - a monster spawn rate in the room_id = N
; .endloop
; .loop ROOMS_MAX
;	.byte - a breakables spawn rate in the room_id = N
; .endloop
; ...

rooms_spawn_rates:				= $7b00
rooms_spawn_rate_monsters:		= rooms_spawn_rates 					; 0 means 100% chance to spawn a monster. 255 means no spawn
rooms_spawn_rate_breakables:	= rooms_spawn_rate_monsters + ROOMS_MAX ; 0 means 100% chance to spawn a breakable item. 255 means no spawn
rooms_spawn_rates_end:			= rooms_spawn_rate_breakables + ROOMS_MAX ; $7b80

;=============================================================================
; hero resources
; TODO: update RESOURCES_LEN when resources are finilized
HERO_RESOURCES_LEN	= 5

hero_resources:		= $7b80
hero_res_score_l:	= hero_resources + 0
hero_res_score_h:	= hero_resources + 1
hero_res_ammo:		= hero_resources + 2
hero_res_mana:		= hero_resources + 3
hero_resources_end:	= hero_resources + HERO_RESOURCES_LEN

;=============================================================================
; a list of back runtime data structs.
backs_runtime_data:		= $7b85
back_anim_ptr:			= backs_runtime_data 			;.word TEMP_ADDR ; also (back_anim_ptr+1) stores a marker of end of the data like ACTOR_RUNTIME_DATA_LAST
back_scr_addr:			= back_anim_ptr + ADDR_LEN		;.word TEMP_WORD
back_anim_timer:		= back_scr_addr + WORD_LEN		;.byte TEMP_BYTE
back_anim_timer_speed:	= back_anim_timer + BYTE_LEN	;.byte TEMP_BYTE
back_runtime_data_end: = back_anim_timer_speed + BYTE_LEN

BACK_RUNTIME_DATA_LEN = back_runtime_data_end - backs_runtime_data

; the same structs for the rest of the backs
backs_runtime_data_end_marker:	= back_runtime_data_end + BACK_RUNTIME_DATA_LEN * (BACKS_MAX-1) ;.word ACTOR_RUNTIME_DATA_END << 8
backs_runtime_data_end:			= backs_runtime_data_end_marker + WORD_LEN
BACKS_RUNTIME_DATA_LEN = backs_runtime_data_end - backs_runtime_data

;=============================================================================
; a current command that is handled by the level update func
global_request:			= $7bc3				; .byte
; the current level idx
level_idx:				= $7bc4				; .byte
; the current room idx of the current level
room_id:   				= $7bc5				; .byte TEMP_BYTE ; in the range [0, ROOMS_MAX-1]

;=============================================================================
; level init data ptr and ram-disk access commands
level_init_tbl:						= $7bc6
level_ram_disk_s_data:				= $7bc6 ; .byte __RAM_DISK_S_LEVEL00_DATA
level_ram_disk_m_data: 				= $7bc7 ; .byte __RAM_DISK_M_LEVEL00_DATA
level_ram_disk_s_gfx:				= $7bc8 ; .byte __RAM_DISK_S_LEVEL00_GFX
level_ram_disk_m_gfx:				= $7bc9 ; .byte __RAM_DISK_M_LEVEL00_GFX
level_palette_ptr:					= $7bca ; .word __level00_palette
level_resources_inst_data_pptr:		= $7bcc ; .word __level00_resources_inst_data_ptrs
level_containers_inst_data_pptr:	= $7bce ; .word __level00_containers_inst_data_ptrs
level_start_pos_ptr:				= $7bd0 ; .word __level00_start_pos
level_rooms_pptr:					= $7bd2 ; .word __level00_rooms_addr
level_tiles_pptr:					= $7bd4 ; .word __level00_tiles_addr
level_init_tbl_end:					= $7bd6
LEVEL_INIT_TBL_LEN = level_init_tbl_end - level_init_tbl
;=============================================================================
;
game_score = $7bd6 ; word
;==================================
; palette
palette = $7bd8 ; 16 bytes

;=============================================================================
; hero global statuses
; >0 - will NOT be rendered, copied to the screen, and erased in the back buffer
; 0 - the opposite
; TODO: use only a bit, then combine it with other hero global statuses.
hero_global_status_no_render = $7be8 ; byte

;=============================================================================
;
; settings
;


;=============================================================================
;
;	free space = $7be9 - $7c10
;

;=============================================================================
; contains global item statuses.
ITEM_STATUS_NOT_ACQUIRED	= 0
ITEM_STATUS_ACQUIRED		= 1
ITEM_STATUS_USED			= 2
ITEMS_MAX					= 16

; data format:
; .loop ITEMS_MAX
;	.byte - status of item_id = N
; .endloop

global_items:		= $7c10
global_items_end:	= global_items + ITEMS_MAX

;=============================================================================
; tile graphics pointer table.
ROOM_TILES_GFX_PTRS_LEN	= ROOM_WIDTH * ROOM_HEIGHT * ADDR_LEN

; data format:
; .loop ROOM_HEIGHT
;	.loop ROOM_WIDTH
;		.word - tile_gfx_addr
;	.endloop
; .endloop

room_tiles_gfx_ptrs:		= $7c20
room_tiles_gfx_ptrs_end:	= room_tiles_gfx_ptrs + ROOM_TILES_GFX_PTRS_LEN

;=============================================================================
; tiledata buffer has to follow room_tiles_gfx_ptrs because they are unpacked altogether. see level_data.asm for tiledata format
ROOM_TILEDATA_LEN	= ROOM_WIDTH * ROOM_HEIGHT

; data format:
; .loop ROOM_HEIGHT
;	.loop ROOM_WIDTH
;		.byte - tiledata
;	.endloop
; .endloop

room_tiledata:		= $7e00
room_tiledata_end:	= room_tiledata + ROOM_TILEDATA_LEN

;=============================================================================
; check buffer overlapping
;

BUFFERS_START_ADDR	= tiled_img_idxs
BUFFERS_END_ADDR	= room_tiledata_end


; TODO: update checkers after finalizing buffers layout
.if rooms_spawn_rates_end > room_tiles_gfx_ptrs
	.error "rooms_spawn_rates_end and room_tiles_gfx_ptrs overlap"
.endif

.if room_tiles_gfx_ptrs_end > room_tiledata
	.error "room_tiles_gfx_ptrs_end and room_tiledata overlap"
.endif

.if STACK_MIN_ADDR < BUFFERS_END_ADDR
	.error "game temp buffers and stack overlap"
.endif

