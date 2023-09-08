dialogs_init:
			jmp dialog_storytelling_init

; init a callback, draw a frame, a text
; hl - callback_tbl addr (callback pptr)
; de - text ptr
; a - global_request
dialog_init:
			sta global_request

			call dialog_is_inited
			rz ; if it is NOP, that means a dialog is already initiated

			A_TO_ZERO(OPCODE_NOP)
			sta dialog_update

			; store a callback ptr
			shld dialog_update_callback + 1
			xchg
			; hl - text_ptr
			jmp dialog_draw_frame_text

; check if dialog is already inited
; it is used to prevent multiple dialog_init calls when a hero
; hits several trigger tiledatas
; out:
; z flag = 1 if a dialog is already initiated
dialog_is_inited:
			lda dialog_update
			ora a ; check if it is NOP
			ret

; invoke a dialog callback func
; if the callback pptr == NULL_PTR, return
dialog_update:
			ret ; do not change, it is mutable

			; check if a fire action is pressed
			lda action_code
			ani CONTROL_CODE_FIRE1 | CONTROL_CODE_KEY_SPACE
			rz
			xra a
			sta action_code

			; dialog_update_stop
			mvi a, OPCODE_RET
			sta dialog_update
dialog_update_callback:
			; call a callback
			jmp dialog_update_callback


; draw a frame and a text on the SCR_BUFF3
; in:
; hl - text ptr
dialog_draw_frame_text:
			push h
			; mark erased the runtime back data
			call backs_init
			; draw a frame
			DRAW_TILED_IMG(__RAM_DISK_S_TILED_IMAGES_GFX, __RAM_DISK_S_TILED_IMAGES_DATA, __tiled_images_frame_ingame_dialog, __TILED_IMAGES_FRAME_INGAME_DIALOG_COPY_LEN, __tiled_images_tile1)
			; draw an animated spacebar
			; dialog_press_key (tiledata = 162)
			mvi b, 162
			@pos_tiles_x = 14
			@pos_tiles_y = 0
			mvi c, @pos_tiles_x + @pos_tiles_y * TILE_HEIGHT
			; b - tiledata
			; c - tile_idx in the room_tiledata array.			
			call backs_spawn

			CALL_RAM_DISK_FUNC(__text_ex_rd_reset_spacing, __RAM_DISK_S_FONT | __RAM_DISK_M_TEXT_EX)
			lxi b, $102d	; text pos
			pop h
			; hl - text ptr
			CALL_RAM_DISK_FUNC(__text_ex_rd_scr3, __RAM_DISK_S_FONT | __RAM_DISK_M_TEXT_EX)

			; pause to prevent closing a dialog right after opening
			PAUSE(65000, true)


;===========================================================================
; dialog when a hero picks up the global item called TILEDATA_STORYTELLING
; it proceeds only if the dialog wasn't shown before
; it pauses everything except backs and ui, it erases backs
; when this dialog closes, the game redraws the room, then continues
; the limitations: LEVEL_IDX_0 in a range of 0-3
; one dialog per room
STORYTELLING_TEXT_STATUS_NEW = 0
STORYTELLING_TEXT_STATUS_OLD = 1
STORYTELLING_TEXT_ENTITY_LEN = 4
.macro STORYTELLING_TEXT_ENTITY(level_id = TEMP_BYTE, room_id = TEMP_BYTE, text_ptr = NULL_PTR)
			; RRRR_RRLL
			; 	RRRRRR - room_id, 
			;	LL - level_idx
			.byte room_id<<2 | level_id
			.byte STORYTELLING_TEXT_STATUS_NEW
			.word text_ptr
.endmacro

; this array contains all dialogs statues (shown, not shown) and text ptrs
dialog_storytelling_texts_ptrs:
			STORYTELLING_TEXT_ENTITY(LEVEL_IDX_0, ROOM_ID_0, __text_game_story_home)
			STORYTELLING_TEXT_ENTITY(LEVEL_IDX_0, ROOM_ID_1, __text_game_story_farm_fence)
			STORYTELLING_TEXT_ENTITY(LEVEL_IDX_0, ROOM_ID_2, __text_game_story_road_to_friends_home)
			STORYTELLING_TEXT_ENTITY(LEVEL_IDX_0, ROOM_ID_3, __text_game_story_friends_home)
			STORYTELLING_TEXT_ENTITY(LEVEL_IDX_0, ROOM_ID_4, __text_game_story_friends_backyard)
			STORYTELLING_TEXT_ENTITY(LEVEL_IDX_0, ROOM_ID_5, __text_game_story_friends_secret_place)
			STORYTELLING_TEXT_ENTITY(LEVEL_IDX_0, ROOM_ID_6, __text_game_story_crossroad)
			STORYTELLING_TEXT_ENTITY(LEVEL_IDX_0, ROOM_ID_9, __text_game_story_loop)
			STORYTELLING_TEXT_ENTITY(LEVEL_IDX_0, ROOM_ID_12, __text_game_story_lost_coins)
@end_data:
STORYTELLING_TEXT_COUNT = (@end_data - dialog_storytelling_texts_ptrs) / STORYTELLING_TEXT_ENTITY_LEN

; restores storytelling dialog statuses
dialog_storytelling_init:
			lxi h, dialog_storytelling_texts_ptrs+1 ; status offset = 1 byte
			lxi d, STORYTELLING_TEXT_ENTITY_LEN
			mvi c, STORYTELLING_TEXT_COUNT
@loop:
			mvi m, STORYTELLING_TEXT_STATUS_NEW
			dad d
			dcr c
			jnz @loop
			ret

; called to handle TILEDATA_STORYTELLING
; level_id and room_id define what dialog to show
dialog_storytelling:
			; get the text ptr based on the level_idx and room_id
			lxi h, level_idx
			lda room_id
			; look up the dialog
			RLC_(2)
			ora m
			mov b, a
			; b - RRRR_RRLL: RRRRR - room_id, L - level_idx
			lxi h, dialog_storytelling_texts_ptrs
			lxi d, STORYTELLING_TEXT_ENTITY_LEN
			mvi c, STORYTELLING_TEXT_COUNT
@loop:
			mov a, m
			; a - RRRR_RRLL: RRRRRR - room_id, LL - level_idx
			cmp b
			jz @check_status
			dad d
			dcr c
			jnz @loop
			ret
@check_status:
            inx h
			A_TO_ZERO(STORYTELLING_TEXT_STATUS_NEW)
			cmp m
			rnz
			mvi m, STORYTELLING_TEXT_STATUS_OLD
			push h

			; get the text ptr
			pop h
			inx h
			mov e, m
			inx h
			mov d, m

			; de - text pptr
			lxi h, dialog_callback_room_redraw
			mvi a, GAME_REQ_PAUSE
			jmp dialog_init

dialog_callback_room_redraw:
			mvi a, GAME_REQ_ROOM_DRAW
			sta global_request
			; TODO: restore breakables the same configuraton they were created
			ret


