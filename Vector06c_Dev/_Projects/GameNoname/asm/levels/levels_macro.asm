; a tiledata handler. 
; tiledata should be in the format: ffffDDDD
;		ffff is a func_id of a func handler in the func_table
;		DDDD is a func argument
; call a handler func with DDDD stored in a, bc passed in the func depends on the context
; input:
; hl - a pointer to a tiledata in a format ffffDDDD.
; keeps hl unchanged
; use:
; de, a
; bc - depends on the func in the func_table
.macro TILEDATA_HANDLING(func_table, skip_func_zero = false)
			mov a, m
			push h	
			; extract a function
			ani TILEDATA_FUNC_MASK
		.if skip_func_zero
			; if func_id == 0, that means it is a walkable (non-interactable) tile, we skip it.
			jz @funcReturnAddr
		.endif
			rrc_(2) ; to make a jmp table ptr with a 4 byte allignment
			mov e, a
			mvi d, 0
			; extract a func argument
			mov a, m
			ani TILEDATA_ARG_MASK
			lxi h, func_table
			dad d
			lxi d, @funcReturnAddr
			push d
			pchl
@funcReturnAddr:
			pop h
.endmacro

; a tiledata handler. 
; tiledata should be in the format: ffffDDDD
;		ffff is a func_id of a func handler in the func_table
;		DDDD is a func argument
; call a handler func with func_id=ffff, A = DDDD, C=tile_idx
; input:
; hl - ptr to the last tile_idx in the array room_get_tiledata_idxs
.macro TILEDATA_HANDLING2(width, height, actor_tile_func_table)
			; de - posXY 
			lxi b, (width-1)<<8 | height-1
			call room_get_tiledata
@loop:
			mov a, m
			cpi TILE_IDX_INVALID
			rz
			
			mov c, a
			; c - tile_idx
			mvi b, >room_tiledata
			ldax b
			mov b, a
			; b - tiledata
			ani TILEDATA_FUNC_MASK
			; a - func_id
			jz @skip

			push h
			; store return addr
			lxi h, @funcReturnAddr
			push h
			; to make a jmp table ptr with a 4 byte allignment
			rrc_(2)
			mov l, a
			mvi h, 0
			lxi d, actor_tile_func_table - JMP_4_LEN ; because we skip tiledata_func_id = 0
			dad d
			; b - tiledata
			mvi a, TILEDATA_ARG_MASK
			ana b
			pchl
@funcReturnAddr:
			pop h
@skip:
			dcx h
			jmp @loop
.endmacro

.macro ROOM_SPAWN_RATE_CHECK(rate_ptr, doNotSpawn)
			; check rooms_break_rate if it needs to spawn
			lda room_id
			adi <rate_ptr
			mov l, a
			mvi h, >rate_ptr

			mov e, m
			call random
			cmp e
			jc doNotSpawn
.endmacro			

.macro ROOM_SPAWN_RATE_UPDATE(rate, SPAWN_RATE_DELTA, SPAWN_RATE_MIN)
			; increase death_rate
			lda room_id
			adi <rate
			mov l, a
			mvi h, >rate

			mov a, m
			adi SPAWN_RATE_DELTA
			mov m, a
			jnc @next
			mvi m, SPAWN_RATE_MIN
@next:			
.endmacro

; look up a resource by its room_id, tile_idx
; if no success, it jumps to
; in:
; d - room_id
; l - resource_id
; c - tile_idx
; uses:
; hl, de, a
.macro FIND_INSTANCE(picked_up, instances_ptrs)
			; find a resource
			mvi h, >instances_ptrs
			; hl - ptr to instances_ptrs, ex. resources_inst_data_ptrs
			mov a, m
			inx h
			mov l, m
			; hl - ptr to the next resource_inst_data
			; (h<<8 + a) - ptr to resource_inst_data.
			; make instance counter
			sub l
			cma
			cmc ; make C flag = 0
			rar ; div by 2 because every instance data contains of a pair of bytes
			mov e, a
			; e = inst_counter - 1
			; d = room_id
			; find a resource in resource_inst_data	
			mov a, d
@search_loop:
			dcx h
			cmp m
			dcx h
			jz @room_match
@check_counter:
			dcr e
			jp @search_loop
			jmp picked_up ; resource is not found, means it is picked up
@room_match:
			; check tile_idx
			mov a, m
			cmp c
			mov a, d
			jnz @check_counter
.endmacro