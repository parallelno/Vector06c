; a newly inited room uses this list to call a monster Init func
; it's ordered by monster_id (see tiledata format in levels_data.asm)
monsters_inits:
			JMP_4( skeleton_init)
			JMP_4( vampire_init)
			JMP_4( burner_init)
			JMP_4( knight_init)
			JMP_4( knight_init)
			JMP_4( burner_init)
			JMP_4( burner_init)
			JMP_4( knight_init)

SKELETON_ID		= 0
VAMPIRE_ID		= 1
BURNER_ID		= 2
KNIGHT_HORIZ_ID	= 3
KNIGHT_VERT_ID	= 4
BURNER_RIGHT_ID	= 5
BURNER_UP_ID	= 6
KNIGHT_QUEST_ID = 7

; ptr to the first monster data in the sorted list
monster_runtime_data_sorted:
			.word monster_update_ptr

; a list of monster runtime data structs.
; TODO: optimization. consider using JMP_4 instead of func ptrs like monster_update_ptr
; TODO: move it over the buffers.asm
monsters_runtime_data:
monster_update_ptr:			.word TEMP_ADDR
monster_draw_ptr:			.word TEMP_ADDR
monster_impacted_ptr:		.word TEMP_WORD ; called by a hero's bullet, another monster, etc. to affect this monster
monster_id:					.byte TEMP_BYTE
monster_type:				.byte TEMP_BYTE
monster_health:				.byte TEMP_BYTE
monster_status:				.byte TEMP_BYTE
monster_status_timer:		.byte TEMP_BYTE
monster_anim_timer:			.byte TEMP_BYTE
monster_anim_ptr:			.word TEMP_ADDR
monster_erase_scr_addr:		.word TEMP_WORD
monster_erase_scr_addr_old:	.word TEMP_ADDR
monster_erase_wh:			.word TEMP_WORD
monster_erase_wh_old:		.word TEMP_WORD
monster_pos_x:				.word TEMP_WORD
monster_pos_y:				.word TEMP_WORD
monster_speed_x:			.word TEMP_WORD
monster_speed_y:			.word TEMP_WORD
monster_data_prev_pptr:		.word TEMP_WORD
monster_data_next_pptr:		.word TEMP_WORD
@end_data:

MONSTER_RUNTIME_DATA_LEN = @end_data - monsters_runtime_data

; the same structs for the rest of the monsters
.storage MONSTER_RUNTIME_DATA_LEN * (MONSTERS_MAX-1), 0
monsters_runtime_data_end_marker:	.word ACTOR_RUNTIME_DATA_END << 8
monsters_runtime_data_end: = monsters_runtime_data_end_marker + WORD_LEN