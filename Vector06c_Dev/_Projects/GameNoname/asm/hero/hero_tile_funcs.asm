; handler func for items
; in:
; a - item_id
; c - tile_idx
hero_tile_func_item:
			; update global item status
			mvi h, >global_items
			adi <global_items
			mov l, a
			mvi m, <ITEM_STATUS_ACQUIRED

			; erase item_id from tiledata
			mvi b, >room_tiledata
			mvi a, TILEDATA_RESTORE_TILE
			stax b
			; calc tile gfx ptr
			mov l, c
			mvi h, 0
			lxi d, room_tiles_gfx_ptrs
			dad h
			dad d
			mov d, c
			; d - tile_idx
			; read a tile gfx ptr
			mov c, m
			inx h
			mov b, m

			; calc tile scr addr
			; d - tile_idx
			mvi a, %11110000
			ana d
			mov e, a
			; e - scr Y
			mvi a, %00001111
			ana d
			rlc
			adi >SCR_BUFF0_ADDR
			mov d, a

			; bc - a tile gfx ptr
			; de - screen addr
			push d	; for vfx

			push b
			push d
			; draw a tile on the screen
			lda level_ram_disk_s_gfx
			CALL_RAM_DISK_FUNC_BANK(draw_tile_16x16)			
			pop d
			pop b
			push b
			push d
			; draw a tile in the back buffer
			lda level_ram_disk_s_gfx
			ori __RAM_DISK_M_BACKBUFF | RAM_DISK_M_AF
			CALL_RAM_DISK_FUNC_BANK(draw_tile_16x16)
			pop d
			pop b
			; draw a tile in the back buffer2
			lda level_ram_disk_s_gfx
			ori __RAM_DISK_M_BACKBUFF2 | RAM_DISK_M_AF
			CALL_RAM_DISK_FUNC_BANK(draw_tile_16x16)

			; draw vfx
			pop b
			lxi d, vfx_reward
			call vfx_init

			ROOM_SPAWN_RATE_UPDATE(rooms_spawn_rate_breakables, BREAKABLE_SPAWN_RATE_DELTA, BREAKABLE_SPAWN_RATE_MAX)
			ret

; handler func for resources
; in:
; a - resource_id
; c - tile_idx
hero_tile_func_resource:
			sta @restore_resource_id+1
			; find a resource
			lxi h, room_id
			mov d, m
			mov l, a
			FIND_INSTANCE(@no_resource_found, resources_inst_data_ptrs)
			; c = tile_idx
			; hl ptr to tile_idx
			; remove this resource from resources_inst_data
			inx h
			mvi m, <RESOURCES_STATUS_ACQUIRED

@no_resource_found:
			; erase item_id from tiledata
			mvi b, >room_tiledata
			mvi a, TILEDATA_RESTORE_TILE
			stax b
			; calc tile gfx ptr
			mov l, c
			mvi h, 0
			lxi d, room_tiles_gfx_ptrs
			dad h
			dad d
			mov d, c
			; d - tile_idx
			; read a tile gfx ptr
			mov c, m
			inx h
			mov b, m

			; calc tile scr addr
			; d - tile_idx
			mvi a, %11110000
			ana d
			mov e, a
			; e - scr Y
			mvi a, %00001111
			ana d
			rlc
			adi >SCR_BUFF0_ADDR
			mov d, a

			; bc - a tile gfx ptr
			; de - screen addr
			push d ; for vfx

			push b
			push d
			; draw a tile on the screen
			lda level_ram_disk_s_gfx
			CALL_RAM_DISK_FUNC_BANK(draw_tile_16x16)
			pop d
			pop b
			push b
			push d
			; draw a tile in the back buffer
			lda level_ram_disk_s_gfx
			ori __RAM_DISK_M_BACKBUFF | RAM_DISK_M_AF
			CALL_RAM_DISK_FUNC_BANK(draw_tile_16x16)
			pop d
			pop b
			; draw a tile in the back buffer2
			lda level_ram_disk_s_gfx
			ori __RAM_DISK_M_BACKBUFF2 | RAM_DISK_M_AF
			CALL_RAM_DISK_FUNC_BANK(draw_tile_16x16)
			
			; draw vfx
			pop b
			lxi d, vfx_reward
			call vfx_init

			; update a hero resource
			lxi h, hero_res_func_tbl
@restore_resource_id:			
			mvi a, TEMP_BYTE
			ADD_A(2) ; resource_id to JMP_4 ptr
			mov c, a
			mvi b, 0
			dad b
			pchl ; run a resource handler

; load a new room with room_id, move the hero to an
; appropriate position based on his current posXY
; input:
; a - room_id
hero_tile_func_teleport:
			; we don't need to handle the rest of the collided tiles because the hero is teleporting.
			; so, we remove hl from a stack stored there in the hero_check_tiledata routine
			; as well as the return addr
			pop h
			pop h

			; update a room_id to teleport there
			sta room_id
			; requesting room loading
			mvi a, GAME_REQ_ROOM_INIT
			sta global_request

			; check if the teleport on the left or right side
			lda hero_pos_x+1
			cpi (ROOM_WIDTH - 1 ) * TILE_WIDTH - HERO_COLLISION_WIDTH
			jnc @teleportRightToLeft
			cpi TILE_WIDTH
			jc @teleportLeftToRight
			; check if the teleport on the top or bottom side
			lda hero_pos_y+1
			cpi (ROOM_HEIGHT - 1 ) * TILE_HEIGHT - HERO_COLLISION_HEIGHT
			jnc @teleportTopToBottom
			cpi TILE_HEIGHT
			jc @teleportBottomToTop
			; teleport keeping the same pos
			ret

@teleportRightToLeft:
			mvi a, TILE_WIDTH
			sta hero_pos_x+1
			ret

@teleportLeftToRight:
			mvi a, (ROOM_WIDTH - 1 ) * TILE_WIDTH - HERO_COLLISION_WIDTH
			sta hero_pos_x+1
			ret

@teleportTopToBottom:
			mvi a, TILE_HEIGHT
			sta hero_pos_y+1
			ret
@teleportBottomToTop:
			mvi a, (ROOM_HEIGHT - 1 ) * TILE_HEIGHT - HERO_COLLISION_HEIGHT
			sta hero_pos_y+1
			ret


hero_res_func_coin:
			lhld hero_res_score_l
			lxi d, RESOURCE_COIN_VAL
			dad d
			CLAMP_HL()
			shld hero_res_score_l
			ret

hero_res_func_potion_blue:
			lxi h, hero_res_mana
			mov a, m
			adi RESOURCE_POTION_BLUE_VAL
			CLAMP_A()
			mov m, a
			ret

hero_res_func_potion_red:
			lxi h, hero_health
			mov a, m
			adi RESOURCE_POTION_RED_VAL
			; TODO: ERROR: clamp does not work
			CLAMP_A(HERO_HEALTH_MAX)
			mov m, a
			call game_ui_draw_health
			ret

hero_cont_func_chest_small:
hero_cont_func_chest_big:
hero_cont_func_chest_weapon0:
			ret