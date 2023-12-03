.include "asm\\bullets\\bullets_macro.asm"
.include "asm\\bullets\\vfx_consts.asm"
.include "asm\\bullets\\sword.asm"
.include "asm\\bullets\\snowflake.asm"
.include "asm\\bullets\\scythe.asm"
.include "asm\\bullets\\bomb.asm"
.include "asm\\bullets\\sparker.asm"
.include "asm\\bullets\\fart.asm"
.include "asm\\bullets\\vfx.asm"
.include "asm\\bullets\\cursor.asm"

bullets_init:
			mvi a, <bullets_runtime_data
			sta bullet_runtime_data_sorted
			; set the last marker byte of runtime_data
			mvi a, ACTOR_RUNTIME_DATA_END
			sta bullets_runtime_data_end_marker + 1
			; erase runtime_data
			ACTOR_ERASE_RUNTIME_DATA(bullet_update_ptr)
			ret


; bullet initialization
; ex. BULLET_INIT(snowflake_update, snowflake_draw, ACTOR_STATUS_BIT_INVIS, SNOWFLAKE_STATUS_INVIS_TIME, snowflake_run, snowflake_init_speed)
; in:
; bc - caster pos
.macro BULLET_INIT(BULLET_UPDATE_PTR, BULLET_DRAW_PTR, BULLET_STATUS, BULLET_STATUS_TIMER, BULLET_ANIM_PTR, BULLET_SPEED_INIT)
			lxi d, @init_data
			jmp bullet_init

			.word TEMP_WORD  ; safety word because "call actor_get_empty_data_ptr"
			.word TEMP_WORD  ; safety word because an interruption can call
@init_data:
			.word BULLET_UPDATE_PTR, BULLET_DRAW_PTR, BULLET_STATUS | BULLET_STATUS_TIMER<<8, BULLET_ANIM_PTR, BULLET_SPEED_INIT
.endmacro

; bullet initialization
; this func calls bullet_speed_init code to define a unique bullet behavior. in for this code
; in:
; de - ptr to bullet_data: .word BULLET_UPDATE_PTR, BULLET_DRAW_PTR, BULLET_STATUS | BULLET_STATUS_TIMER<<8, BULLET_ANIM_PTR, BULLET_SPEED_INIT
; bc - caster pos
; when it calls BULLET_SPEED_INIT code
; in:
; de - ptr to bullet_speed_x
; cc 876
bullet_init:
			lxi h, 0
			dad	sp
			shld @restore_sp + 1
			xchg
			sphl

			mov l, c
			mov h, b
			shld @caster_pos + 1

			lxi h, bullet_update_ptr+1
			mvi e, BULLET_RUNTIME_DATA_LEN
			call actor_get_empty_data_ptr
			rnz ; return when it's too many objects

			; hl - ptr to bullet_update_ptr+1
			; advance hl to bullet_update_ptr
			dcx h
			pop b ; using bc to read from the stack is requirenment
			mov m, c
			inx h
			mov m, b
			; advance hl to bullet_draw_ptr
			inx h
			pop b
			mov m, c
			inx h
			mov m, b
			; advance hl to bullet_status
			inx h
			pop b
			mov m, c
			; advance hl to bullet_status_timer
			inx h
			mov m, b
			; advance hl to bullet_anim_timer
			inx h
			mvi m, 0
			; advance hl to bullet_anim_ptr
			inx h
			pop b
			mov m, c
			inx h
			mov m, b
@caster_pos:
			lxi b, TEMP_WORD
			; bc - scr pos
			mov a, b
			; a - pos_x
			; scr_x = pos_x/8 + SPRITE_X_SCR_ADDR
			RRC_(3)
			ani %00011111
			adi SPRITE_X_SCR_ADDR
			mvi e, 0
			; a = scr_x
			; b = pos_x
			; c = pos_y
			; e = 0 and SPRITE_W_PACKED_MIN

			; advance hl to bullet_erase_scr_addr
			inx h
			mov m, c
			inx h
			mov m, a
			; advance hl to bullet_erase_scr_addr_old
			inx h
			mov m, c
			inx h
			mov m, a
			; advance hl to bullet_erase_wh
			inx h
			mvi m, SPRITE_H_MIN
			inx h
			mov m, e
			; advance hl to bullet_erase_wh_old
			inx h
			mvi m, SPRITE_H_MIN
			inx h
			mov m, e
			; advance hl to bullet_pos_x
			inx h
			mov m, e
			inx h
			mov m, b
			; advance hl to bullet_pos_y
			inx h
			mov m, e
			inx h
			mov m, c
			; advance hl to bullet_speed_x
			inx h

			pop b
			; bc - ptr to init_speed func
@restore_sp:
			lxi sp, TEMP_ADDR
			RAM_DISK_OFF()

			xchg
			; de - ptr to bullet_speed_x
			lxi h, @ret
			push h
			mov l, c
			mov h, b
			pchl
@ret:
			; return TILEDATA_RESTORE_TILE to make the tile where a monster spawned walkable and restorable
			mvi a, TILEDATA_RESTORE_TILE
			ret

bullets_update:
			ACTORS_INVOKE_IF_ALIVE(bullet_update_ptr, bullet_update_ptr, BULLET_RUNTIME_DATA_LEN, true)

bullets_draw:
			ACTORS_INVOKE_IF_ALIVE(bullet_draw_ptr, bullet_update_ptr, BULLET_RUNTIME_DATA_LEN, true)

bullets_copy_to_scr:
			ACTORS_CALL_IF_ALIVE(bullet_copy_to_scr, bullet_update_ptr, BULLET_RUNTIME_DATA_LEN, true)

bullets_erase:
			ACTORS_CALL_IF_ALIVE(bullet_erase, bullet_update_ptr, BULLET_RUNTIME_DATA_LEN, true)

; copy sprites from a backbuffer to a scr
; in:
; hl - ptr to bullet_update_ptr+1 
bullet_copy_to_scr:
			; advance to bullet_status
			HL_ADVANCE(bullet_update_ptr+1, bullet_status, BY_DE)
			jmp actor_copy_to_scr
			
; erase a sprite or restore the background behind a sprite
; in:
; hl - ptr to bullet_update_ptr+1
; a - BULLET_RUNTIME_DATA_* status
bullet_erase:
			LXI_D_TO_DIFF(bullet_update_ptr+1, bullet_status)
			jmp actor_erase