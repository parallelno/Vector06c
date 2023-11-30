__RAM_DISK_S_SCORE = RAM_DISK_M | RAM_DISK_M_89

; TODO: check is there is all entities listened

; func_id = 1
game_score_monsters:
			.word 5		; monster_id = 0 - skeleton (tiledata = 1*16+0=16)
			.word 10	; monster_id = 1 - vampire (tiledata = 17)
			.word 12	; monster_id = 2 - burner (tiledata = 18)
			.word 8		; monster_id = 3 - knight horizontal walk (tiledata = 19)
			.word 7		; monster_id = 4 - knight vertical walk (tiledata = 20)
			.word 0		; monster_id = 5 - burner quest that runs to the right
			.word 0		; monster_id = 6 - burner quest that runs to up
			.word 0		; monster_id = 6 - knight quest horizontal walk
			.word 3		; monster_id = 7 - firepool

; func_id = 6
game_score_items:
			.word 0		; item_id = 0 - storytelling - an invisible tiledata to open a dialog window
			.word 30	; item_id = 1 - key 0
			.word 80	; item_id = 2 - key 1
			.word 100	; item_id = 3 - key 2
			.word 200	; item_id = 4 - key 3
			.word 300	; item_id = 5 - key 3
			.word 400	; item_id = 6 - key 3

; func_id = 7
game_score_resources:
			.word 1		; res_id = 0 - a coin (tiledata = 7*16+0 = 160)
			.word 3		; res_id = 1 - a health crystal
			.word 50	; res_id = 2 - a sword
			.word 5		; res_id = 3 - a snowflake
			.word 15	; res_id = 4 - a tnt
			.word 10	; res_id = 5 - a potion health
			.word 15	; res_id = 6 - a popsicle pie
			.word 2		; res_id = 7 - a clothes
			.word 1		; res_id = 8 - a cabbage
			.word 5		; res_id = 9 - a spoon			

; func_id = 10
__game_score_secrets:
			.word 1000	; entity_id = 0 - a home door trigger

; func_id = 11
__game_score_containers:
			.word 10	; container_id = 0 - a small chest. small money reward
			.word 30	; container_id = 1 - a big chest. big money reward
			.word 50	; container_id = 2 - a chest with a weapon 1
			.word 75	; container_id = 3 - a chest with a weapon 2
			.word 120	; container_id = 4 - a chest with a weapon 3
			.word 10	; container_id = 5 - a monster spawner chest. it spawns a chest monster when opened
			.word 50	; container_id = 6 - a crate with a teleport under it to a unique location

; func_id = 12
game_score_doors:
			.word 1		; door_id = 0 - a door 1a
			.word 1		; door_id = 1 - a door 1b
			.word 3		; door_id = 2 - a door 2a
			.word 3		; door_id = 3 - a door 2b
			.word 5		; door_id = 4 - a door 3a
			.word 5		; door_id = 5 - a door 3b
			.word 5		; door_id = 6 - a door 4a
			.word 5		; door_id = 7 - a door 4b

; func_id = 13
game_score_breakables:
			.word 1		; breakable_id 			= 0 - a barrel (tiledata = 13*16+0 = 208)
			.word 1		; breakable_id 			= 1 - a crate
			.word 1		; BREAKABLE_ID_CABBAGE	= 2 - cabbage (tiledata = $d2)

; pptr list to score points for each type of entity
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
			.word __game_score_secrets
			.word __game_score_containers
			.word game_score_doors
			.word game_score_breakables

; game stats shown when the game is over
__game_stats:
			.word 0			; monsters
			.word NULL_BYTE	; TODO: secret room
			.word NULL_BYTE ; TODO: deaths
			.word NULL_BYTE
			.word NULL_BYTE
			.word 0			; items
			.word 0			; resource: coins
			.word NULL_BYTE
			.word NULL_BYTE
			.word 0			; secrets (sometimes triggers)
			.word 0			; containers
			.word 0			; doors
			.word 0			; breakables
__game_stats_end:

; add score points to hero_res_score
; call ex. CALL_RAM_DISK_FUNC(__game_score_add, __RAM_DISK_S_SCORE)
; in:
; a - func_id
; e - entity_id
; ex: to add score points of a dead vampire, a = 1, c = 1
__game_score_add:
			; get the ptr to the partucular entity
			HL_TO_AX2_PLUS_INT16(__game_stats - WORD_LEN) ; because the list starts with func_id=1
			; increase the entity counter
			inr m
			jnz @score_add
			inx h
			inr m
@score_add:
			mov a, c
			; get the ptr to the scores of partucular entity
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
			; add it to hero_res_score
			lhld hero_res_score
			dad d
			shld hero_res_score
			ret

; init for in-game score data
; call ex. CALL_RAM_DISK_FUNC(__game_stats_init, __RAM_DISK_S_SCORE)
__game_stats_init:
			lxi h, __game_stats
			mvi a, <__game_stats_end
			clear_mem_short()
			ret

; read the game stats
; call ex. CALL_RAM_DISK_FUNC(__game_stats_get, __RAM_DISK_S_SCORE)
; in:
; c - stat_id (offset in __game_stats)
; out:
; de - the stat
__game_stats_get:
			mov a, c
			; get the ptr to the partucular entity
			HL_TO_AX2_PLUS_INT16(__game_stats - WORD_LEN) ; because the list starts with func_id=1
			; increase the entity counter
			mov e, m
			inx h
			mov d, m
			ret