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

; runtime data moved over buffers.asm