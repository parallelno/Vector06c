; this mob is absolutly the same as a skeleton.asm
; but it is spawns only if the her has a res_spoon


;========================================================
; called to spawn this monster
; in:
; c - tile_idx in the room_tiledata array.
; a - monster_id * 4
; out:
; a = 0
skeleton_quest_init:
			mov b, a
			lda hero_res_spoon
			CPI_WITH_ZERO(0)
			mvi a, TILEDATA_RESTORE_TILE
			rz
			mov a, b
			jmp skeleton_init