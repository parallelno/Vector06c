; a newly inited room uses this list to call a monster Init func
; it's ordered by monster_id (see tile data format in levelsData.asm)
monstersInits:
monstersInit0:JMP_4(skeleton_init)
monstersInit1:JMP_4(vampire_init)
monstersInit2:JMP_4(burner_init)
monstersInit3:JMP_4(KnightInit)
monstersInit4:JMP_4(KnightInit)

SKELETON_ID = (monstersInit0-monstersInits) / JMP_4_LEN
VAMPIRE_ID = (monstersInit1-monstersInits) / JMP_4_LEN
BURNER_ID = (monstersInit2-monstersInits) / JMP_4_LEN
KNIGHT_HORIZ_ID = (monstersInit3-monstersInits) / JMP_4_LEN
KNIGHT_VERT_ID = (monstersInit4-monstersInits) / JMP_4_LEN

; ptr to the first monster data in the sorted list
monster_runtime_data_sorted:
			.word monster_update_ptr

; a list of monster runtime data structs.
; TODO: optimization. consider using jmp_4 instead of func ptrs like monster_update_ptr
monsters_runtime_data:
monster_update_ptr:			.word TEMP_ADDR
monster_draw_ptr:			.word TEMP_ADDR
monster_impact_ptr:			.word TEMP_WORD ; called by hero bullet, another monster, etc. to affect this monster
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
monster_runtime_data_end_addr:

MONSTER_RUNTIME_DATA_LEN = monster_runtime_data_end_addr - monsters_runtime_data

; the same structs for the rest of the monsters
.storage MONSTER_RUNTIME_DATA_LEN * (MONSTERS_MAX-1), 0
monsters_runtime_data_end_addr:	.word MONSTER_RUNTIME_DATA_END << 8