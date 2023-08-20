; func_id = 1
game_score_monsters:
			.word 5		; entity_id == 0 - skeleton (tiledata = 1*16+0=16)
			.word 10	; entity_id == 1 - vampire (tiledata = 17)
			.word 12	; entity_id == 2 - burner (tiledata = 18)
			.word 8		; entity_id == 3 - knight horizontal walk (tiledata = 19)
			.word 7		; entity_id == 4 - knight vertical walk (tiledata = 20)
			.word 30	; entity_id == 5 - monster chest (tiledata = 21)

; func_id = 6
game_score_items:
			.word 30	; entity_id = 0 - storytelling - an invisible tiledata to open a dialog window
			.word 100	; entity_id = 1 - key blue
			.word 200	; entity_id = 2 - key red
			.word 300	; entity_id = 3 - key green
			.word 500	; entity_id = 4 - key magma

; func_id = 7
game_score_resources:
			.word 1		; entity_id == 0 - a coin (tiledata = 7*16+0 = 160)
			.word 6		; entity_id == 1 - a potion blue
			.word 9		; entity_id == 2 - a potion red

; func_id = 11
__game_score_containers:
			.word 10	; entity_id == 0 - a small chest. small money reward
			.word 30	; entity_id == 1 - a big chest. big money reward
			.word 50	; entity_id == 2 - a chest with a weapon 1
			.word 75	; entity_id == 3 - a chest with a weapon 2
			.word 120	; entity_id == 4 - a chest with a weapon 3
			.word 10	; entity_id == 5 - a monster spawner chest. it spawns a chest monster when opened
			.word 50	; entity_id == 6 - a crate with a teleport under it to a unique location

; func_id = 12
game_score_doors:
			.word 1		; entity_id == 0 - a door 1a
			.word 1		; entity_id == 1 - a door 1b
			.word 3		; entity_id == 2 - a door 2a
			.word 3		; entity_id == 3 - a door 2b
			.word 5		; entity_id == 4 - a door 3a
			.word 5		; entity_id == 5 - a door 3b
			.word 10	; entity_id == 6 - a door 4a
			.word 10	; entity_id == 7 - a door 4b

; func_id = 13
game_score_breakables:
			.word 1		; entity_id == 0 - a barrel (tiledata = 13*16+0 = 208)
			.word 1		; entity_id == 1 - a crate

__game_score_lists_ptrs:
			.word game_score_monsters
			.word NULL_PTR
			.word NULL_PTR
			.word NULL_PTR
			.word NULL_PTR
			.word game_score_items
			.word game_score_resources
			.word NULL_PTR
			.word NULL_PTR
			.word NULL_PTR
			.word __game_score_containers
			.word game_score_doors
			.word game_score_breakables

; add score points to game_score
; call ex. 
; in:
; c - func_id
; e - entity_id
; ex: to add score points of a dead vampire, a = 1, c = 1
__game_score_add:
			mov a, c
			HL_TO_AX2_PLUS_INT16(__game_score_lists_ptrs - WORD_LEN) ; because the list starts with func_id=1
			; get a score list ptr
			mov c, m
			inx h
			mov b, m
			; bc - ptr to a list of scores
			; get an entity score ptr
			mvi d, 0
			xchg
			dad h ; entity_id * 2 because score points takes two bytes
			dad b
			; get an entity score
			mov e, m
			inx h
			mov d, m
			; add it to game_score
			lhld game_score
			dad d
			shld game_score
			ret