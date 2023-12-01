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
			RET_4()								; res_id == 1
			RET_4()								; res_id == 2
			RET_4()								; res_id == 3
			RET_4()								; res_id == 4
			RET_4()								; res_id == 5
			JMP_4( hero_res_func_potion_health)	; res_id == 6
			JMP_4( hero_res_func_potion_mana)	; res_id == 7
			JMP_4( hero_res_func_clothes)		; res_id == 8
			RET_4()								; res_id == 9
			RET_4()								; res_id == 10
			RET_4()								; res_id == 11
			RET_4()								; res_id == 12
			RET_4()								; res_id == 13
			RET_4()								; res_id == 14
			RET_4()								; res_id == 15

; funcs to handle the container pick up process. more info is in level_data.asm->room_tiledata
hero_cont_func_tbl:
			JMP_4( hero_cont_func_chest_sword)	; container_id == 1
			JMP_4( hero_cont_func_chest_spoon)	; container_id == 2
			JMP_4( hero_cont_func_chest_weapon0); container_id == 3
			RET_4()								; container_id == 4
			RET_4()								; container_id == 5
			RET_4()								; container_id == 6
			RET_4()								; container_id == 7
			RET_4()								; container_id == 8
			RET_4()								; container_id == 9
			RET_4()								; container_id == 10
			RET_4()								; container_id == 11
			RET_4()								; container_id == 12
			RET_4()								; container_id == 13
			RET_4()								; container_id == 14
			RET_4()								; container_id == 15