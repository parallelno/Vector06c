; handler func for items
; in:
; a - item_id
; c - tile_idx
hero_tile_func_item:
			mov e, a ; tmp item_id to e
			; get a global item status ptr
			mvi h, >global_items
			adi <global_items - 1 ; because the first item_id = 1
			mov l, a

			; erase item_id from tiledata
			mvi b, >room_tiledata
			mvi a, TILEDATA_RESTORE_TILE
			stax b

			; hl - a global item status ptr
			; return if the global item has already being acquired
			mvi a, ITEM_STATUS_ACQUIRED
			cmp m
			rz

			; check if the item is storytelling
			; e - item_id
			A_TO_ZERO(TILEDATA_STORYTELLING)
			ora e
			jz dialog_storytelling

			; if not acquired, set status to acquired
			mvi m, ITEM_STATUS_ACQUIRED

			; add score points
			push b
			mvi a, TILEDATA_FUNC_ID_ITEMS
			CALL_RAM_DISK_FUNC(__game_score_add, __RAM_DISK_S_SCORE)
			call game_ui_draw_score_text
			pop b
			
			; c - tile_idx
			call draw_tile_16x16_buffs
			; draw vfx
			; bc - tile screen addr			
			lxi d, vfx_reward
			jmp vfx_init

; handler func for resources
; in:
; a - res_id
; c - tile_idx
hero_tile_func_resource:
			sta @restore_res_id+1
			; find a resource
			lxi h, room_id
			mov d, m
			mov l, a
			FIND_INSTANCE(@no_resource_found, resources_inst_data_ptrs)
			; c = tile_idx
			; hl ptr to tile_idx in resources_inst_data_ptrs
			
			; remove this resource from resources_inst_data
			inx h
			mvi m, <RESOURCES_STATUS_ACQUIRED

@no_resource_found:
			; erase item_id from tiledata
			mvi b, >room_tiledata
			mvi a, TILEDATA_RESTORE_TILE
			stax b

			; c - tile_idx
			call draw_tile_16x16_buffs
			; draw vfx
			; bc - tile screen addr			
			lxi d, vfx_reward
			call vfx_init

			; update a hero resource
@restore_res_id:
			mvi a, TEMP_BYTE

			; add score points
			push psw
			mov e, a
			mvi a, TILEDATA_FUNC_ID_RESOURCES
			CALL_RAM_DISK_FUNC(__game_score_add, __RAM_DISK_S_SCORE)
			call game_ui_draw_score_text
			pop psw

			HL_TO_AX4_PLUS_INT16(hero_res_func_tbl)
			pchl ; run a resource handler

; load a new room with room_id, move the hero to an
; appropriate position based on his current pos_xy
; input:
; a - room_id
hero_tile_func_teleport:
			; we don't need to handle the rest of the collided tiles because the hero is teleporting.
			; so, we remove hl from a stack stored there in the hero_check_tiledata routine
			; as well as the return addr
			pop h
			pop h

			; update a room_id to teleport there
			; a - room_id
			lhld room_id
			mov l, a
			mvi a, GAME_REQ_ROOM_INIT
			call room_teleport

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
			; align the hero pos to the nearest tile
			; a = hero pos x
			adi TILE_HEIGHT / 2
			ani %1111_0000
			mov h, a
			mvi l, 0
			shld hero_pos_y
			lda hero_pos_x+1
			adi TILE_WIDTH / 2
			ani %1111_0000
			mov h, a
			mvi l, 0
			shld hero_pos_x
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

hero_res_func_potion_mana:
			lxi h, hero_res_popsicle_pie
			inr m
			CLAMP_M(RES_POPSICLE_PIE_MAX)
			jmp game_ui_res_select_and_draw

hero_res_func_potion_health:
			lxi h, hero_res_potion_health
			inr m
			CLAMP_M(RES_POTION_HEALTH_MAX)
			jmp game_ui_res_select_and_draw

/*
hero_res_func_health:
			lxi h, hero_res_health
			add m
			CLAMP_A(RES_HEALTH_MAX)
			mov m, a
			jmp game_ui_draw_health_text
*/
hero_res_func_clothes:
			lxi h, hero_res_clothes
			inr m
			CLAMP_M(RES_CLOTHS_MAX)
			jmp game_ui_res_select_and_draw

hero_cont_func_chest_sword:
            ; acquiring a sword
			lxi h, hero_res_sword
			mvi m, RES_SWORD_MAX
			call game_ui_res_select_and_draw

			; init a dialog
			mvi a, GAME_REQ_PAUSE
			lxi h, dialog_callback_room_redraw
			lxi d, __text_hero_gets_sword
			jmp dialog_init

hero_cont_func_chest_spoon:
	        ; acquiring a spoon
			lxi h, hero_res_spoon
			mvi m, RES_SPOON_MAX
			call game_ui_res_select_and_draw
	
			mvi a, TILEDATA_FUNC_ID_RESOURCES
			mvi e, RES_ID_SPOON
			CALL_RAM_DISK_FUNC(__game_score_add, __RAM_DISK_S_SCORE)
			call game_ui_draw_score_text

			; init a dialog
			mvi a, GAME_REQ_PAUSE
			lxi h, @callback
			lxi d, __text_hero_gets_spoon
			jmp dialog_init
@callback:
			call dialog_callback_room_redraw
			
			; reset the room spawn rate
			lda room_id
			adi <rooms_spawn_rate_monsters
			mov l, a
			mvi h, >rooms_spawn_rate_monsters
			mvi m, 0

			; spawn skeletons
			@tile_x1 = 6
			@tile_y1 = 9
			mvi c, @tile_x1 + @tile_y1*16	; tile_idx in the room_tiledata array.
			mvi a, SKELETON_ID * 4 		; monster_id = 0 - skeleton (tiledata = 1*16+0=16)			
			call skeleton_init

			@tile_x2 = 7
			@tile_y2 = 7
			mvi c, @tile_x2 + @tile_y2*16	; tile_idx in the room_tiledata array.
			mvi a, SKELETON_ID * 4 		; monster_id = 0 - skeleton (tiledata = 1*16+0=16)			
			call skeleton_init	

			@tile_x3 = 12
			@tile_y3 = 7
			mvi c, @tile_x3 + @tile_y3*16	; tile_idx in the room_tiledata array.
			mvi a, SKELETON_ID * 4 		; monster_id = 0 - skeleton (tiledata = 1*16+0=16)			
			jmp skeleton_init					

hero_cont_func_chest_weapon0:
			ret