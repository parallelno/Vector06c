
breakables_init:
			lxi h, breakables_status_buffer_available_ptr
			mvi m, <breakables_status_buffers ; ptr to the first available buffer
			inx h ; advance hl to breakables_status_buffer_ptrs
			mvi a, <breakables_statuses_end
			jmp clear_mem_short

; init the bleakables status buffer for the current room
; it requires room_tiledata_backup executed upfront this func
breakables_room_status_init:
			; get the pptr to the bleakables status buffer for the current room
			call breakables_get_room_status_buff_pptr
			; hl - the pptr to the bleakables status buffer for the current room
			; check if ptr is inited
			mov a, m
			CPI_WITH_ZERO(NULL_PTR)
			jnz breakables_room_status_restore; return if ptr != 0, means non need to init
			; the bleakables status buffer for the current room wasn't inited

			; count the amount of breakables in the room
			lxi d, room_tiledata_backup
			; hl - the pptr to the bleakables status buffer for the current room
			; de - the ptr to the original statuses

			mvi c, 0
			mvi b, ROOM_TILEDATA_BACKUP_LEN
@loop_count_breakabls:
			ldax d
			ani TILEDATA_FUNC_MASK
			cpi TILEDATA_FUNC_ID_BREAKABLES<<4
			jnz @non_breakables
			inr c
@non_breakables:
			inx d
			dcr b
			jnz @loop_count_breakabls
			; c - breakables amount in the current room

			; get the reminder of division by 8
			mvi a, %111
			ana c
			jz @no_reminder
			mvi b, 1
@no_reminder:
			; divide breakables amount by 8 because one byte stores 8 breakable statuses
			mov a, c
			RRC_(3)
			ani %0001_1111
			add b ; add a reminder to round up
			mov c, a
			; c - the amount of bytes need to store breakables statuses in the room
			; store it
			lda breakables_status_buffer_available_ptr
			; hl - the pptr to the bleakables status buffer for the current room
			mov m, a ; store the ptr to the current room bleakables status buffer
			; update breakables_status_buffer_available_ptr
			add c
			sta breakables_status_buffer_available_ptr
			ret

; restore breakables statuses
; this func should called before room_handle_room_tiledata,
; and after room_unpack and backup_tiledata
; in:
; hl - the pptr to the bleakables status buffer for the current room
breakables_room_status_restore:
			mov l, m
			lxi d, room_tiledata
			xchg
			; de - the ptr to the bleakables status buffer for the current room
			; hl - the ptr to the original statuses

			; restore the breakables statuses
			mvi c, 1 ; the mask to get a status bit
			mvi b, ROOM_TILEDATA_BACKUP_LEN
@loop:
			; get the original breakable status
			mov a, m
			; check if it is breakable
			ani TILEDATA_FUNC_MASK
			cpi TILEDATA_FUNC_ID_BREAKABLES<<4
			jnz @non_breakables
			; check its status
			ldax d
			ana c
			jz @no_status_update
			; breakable is broken, update the status
			mvi m, TILEDATA_RESTORE_TILE
@no_status_update:
			; advance de
			mov a, c
			rlc
			mov c, a
			jnc @no_de_advance
			inx d
@no_de_advance:
@non_breakables:
			inx h
			dcr b
			jnz @loop
			ret


; update the bleakables status buffer for the current room
breakables_room_status_store:
			; get the pptr to the bleakables status buffer for the current room
			call breakables_get_room_status_buff_pptr
			; hl - the pptr to the bleakables status buffer for the current room
			; check if ptr is inited
			mov a, m
			CPI_WITH_ZERO(NULL_PTR)
			rz ; return if ptr == 0, means uninited

			mov l, m
			lxi d, room_tiledata_backup
			; hl - the ptr to the bleakables status buffer for the current room
			; de - the ptr to the room room_tiledata_backup

			; store the breakables statuses
			mvi c, 1 ; the mask to get a status bit
			mvi b, ROOM_TILEDATA_BACKUP_LEN
@loop:
			; get the original breakable status
			ldax d
			; check if it is breakable
			ani TILEDATA_FUNC_MASK
			cpi TILEDATA_FUNC_ID_BREAKABLES<<4
			jnz @non_breakables

			; check its status
			mvi d, >room_tiledata
			ldax d
			cpi TILEDATA_RESTORE_TILE
			; restore the ptr to an original statuses
			mvi d, >room_tiledata_backup
			jnz @no_status_update
			; breakable is broken, update the status
			mov a, m
			ora c
			mov m, a

@no_status_update:
			; advance hl
			mov a, c
			rlc
			mov c, a
			jnc @no_hl_advance
			inx h
@no_hl_advance:
@non_breakables:
			inx d
			dcr b
			jnz @loop
			ret



; return the pptr to the bleakables status buffer for the current room
; out
; hl - the pptr to the bleakables status buffer for the current room
breakables_get_room_status_buff_pptr:
			lhld room_id
			; h - level_id
			; l - room_id
			mov a, h
			RRC_(2)
			add l
			inr a ; because <breakables_status_buffer_ptrs == 1
			mov l, a
			mvi h, >breakables_status_buffer_ptrs
			ret