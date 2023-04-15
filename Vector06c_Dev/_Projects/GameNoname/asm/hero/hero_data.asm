; hero runtime data
; this's a struct. do not change the layout
hero_update_ptr:			.word hero_update
hero_draw_ptr:				.word hero_draw
hero_impacted_ptr:			.word hero_impacted ; called by a monster's bullet, a monster, etc. to affect a hero
hero_type:					.byte MONSTER_TYPE_ALLY
hero_health:				.byte HERO_HEALTH_MAX
hero_status:				.byte HERO_STATUS_IDLE ; a status describes what set of animations and behavior is active
hero_status_timer:			.byte 0	; a duration of the status. ticks every update
hero_anim_timer:			.byte TEMP_BYTE ; it triggers an anim frame switching when it overflows
hero_anim_addr:				.word TEMP_ADDR ; holds the current frame ptr
hero_dir_x:					.byte 1 		; 1-right, 0-left
hero_erase_scr_addr:		.word TEMP_ADDR
hero_erase_scr_addr_old:	.word TEMP_ADDR
hero_erase_wh:				.word TEMP_WORD
hero_erase_wh_old:			.word TEMP_WORD
hero_pos_x:					.word TEMP_WORD
hero_pos_y:					.word TEMP_WORD
hero_speed_x:				.word TEMP_WORD
hero_speed_y:				.word TEMP_WORD
hero_data_prev_pptr:		.word DRAW_LIST_FIRST_DATA_MARKER
hero_data_next_pptr:		.word monster_data_next_pptr
;
hero_collision_func_table:
			; bit layout:
			; 0, 0, (bottom-left), (bottom-right), (top_right), (top-left), 0, 0
			JMP_4( hero_no_collision)
			JMP_4( hero_check_collision_top_left)
			JMP_4( hero_check_collision_top_right)
			JMP_4( hero_move_horizontally)
			JMP_4( hero_check_collision_bottom_right)
			JMP_4( hero_check_tiledata)
			JMP_4( hero_move_vertically)
			JMP_4( hero_check_tiledata)
			JMP_4( hero_check_collision_bottom_left)
			JMP_4( hero_move_vertically)
			JMP_4( hero_check_tiledata)
			JMP_4( hero_check_tiledata)
			JMP_4( hero_move_horizontally)
			JMP_4( hero_check_tiledata)
			JMP_4( hero_check_tiledata)
			JMP_4( hero_check_tiledata)

; funcs to handle the tiledata. more info is in level_data.asm->room_tiledata
hero_tile_func_tbl:
			RET_4()							; func_id == 1
			JMP_4( hero_tile_func_teleport)	; func_id == 2
			RET_4()							; func_id == 3
			RET_4()							; func_id == 4
			RET_4()							; func_id == 5
			JMP_4( hero_tile_func_item)		; func_id == 6
			JMP_4( hero_tile_func_resource)	; func_id == 7
			RET_4()							; func_id == 8
			RET_4()							; func_id == 9
			RET_4()							; func_id == 10
			RET_4()							; func_id == 11
			RET_4()							; func_id == 12
			RET_4()							; func_id == 13
			RET_4()							; func_id == 14
			RET_4()							; func_id == 15 (collision) called only when a hero is stuck into collision tiles

; funcs to handle the resource pick up process. more info is in level_data.asm->room_tiledata
hero_res_func_tbl:
			JMP_4( hero_res_func_coin)			; resource_id == 1
			JMP_4( hero_res_func_potion_blue)	; resource_id == 2
			JMP_4( hero_res_func_potion_red)	; resource_id == 3
			RET_4()								; resource_id == 4
			RET_4()								; resource_id == 5
			RET_4()								; resource_id == 6
			RET_4()								; resource_id == 7
			RET_4()								; resource_id == 8
			RET_4()								; resource_id == 9
			RET_4()								; resource_id == 10
			RET_4()								; resource_id == 11
			RET_4()								; resource_id == 12
			RET_4()								; resource_id == 13
			RET_4()								; resource_id == 14
			RET_4()								; resource_id == 15 (collision) called only when a hero is stuck into collision tiles

; funcs to handle the container pick up process. more info is in level_data.asm->room_tiledata
hero_cont_func_tbl:
			JMP_4( hero_cont_func_chest_small)	; resource_id == 1
			JMP_4( hero_cont_func_chest_big)	; resource_id == 2
			JMP_4( hero_cont_func_chest_weapon0); resource_id == 3
			RET_4()								; resource_id == 4
			RET_4()								; resource_id == 5
			RET_4()								; resource_id == 6
			RET_4()								; resource_id == 7
			RET_4()								; resource_id == 8
			RET_4()								; resource_id == 9
			RET_4()								; resource_id == 10
			RET_4()								; resource_id == 11
			RET_4()								; resource_id == 12
			RET_4()								; resource_id == 13
			RET_4()								; resource_id == 14
			RET_4()								; resource_id == 15 (collision) called only when a hero is stuck into collision tiles