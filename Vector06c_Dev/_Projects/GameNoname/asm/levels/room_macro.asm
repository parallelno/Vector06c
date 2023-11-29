; a tiledata handler.
; tiledata should be in the format: ffffDDDD
;		ffff is a func_id of a func handler in the func_table
;		DDDD is a func argument
; call a handler func with func_id=ffff, A=DDDD, C=tile_idx
; in:
; de - pos_xy
.macro TILEDATA_HANDLING(width, height, actor_tile_func_table)
			; de - pos_xy
			lxi b, (width-1)<<8 | height-1
			call room_get_tiledata
			; hl - ptr to the last tile_idx in the array room_get_tiledata_idxs			
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
			RRC_(2)
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

; check a spawn_rate which address is rate_ptr + room_id
; use:
; hl, e, a
; TODO: an issue that this macro does not check the level. 
; rooms_spawn_rates array does not contain a proper data for all levels
.macro ROOM_SPAWN_RATE_CHECK(rate_ptr, do_not_spawn)
			; check rooms_break_rate if it needs to spawn
			lda room_id
			adi <rate_ptr
			mov l, a
			mvi h, >rate_ptr

			mov e, m
			call random
			cmp e
			jc do_not_spawn
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
; l - res_id
; c - tile_idx
; out:
; if success:
; c = tile_idx
; hl ptr to tile_idx in instances_ptrs
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
			; make an instance counter
			; a - a low byte ptr to resources_inst_data for particular resource
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