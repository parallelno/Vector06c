; this mob is absolutly the same as a skeleton.asm
; but it spawns only if the hero has the res_spoon


;========================================================
; spawn and init a monster
; in:
; c - tile_idx in the room_tiledata array.
; a - monster_id * 4
; out:
; a = TILEDATA_RESTORE_TILE
skeleton_quest_init:
			mov b, a
			lda hero_res_spoon
			CPI_WITH_ZERO(0)
			jz @return
			mov a, b
			jmp skeleton_init
@return:
			mvi a, TILEDATA_RESTORE_TILE
			ret			