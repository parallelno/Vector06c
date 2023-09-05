dialogs_init:
			jmp dialog_storytelling_init

DIALOG_EMPTY_CALLBACK:
			ret

DIALOG_EMPTY_CALLBACK_PTR:
			.word DIALOG_EMPTY_CALLBACK

; init dialog
; in:
; hl - callback_tbl addr (callback pptr)
.macro DIALOG_INIT(dialog_callbacks_ptr)
			lxi h, dialog_callbacks_ptr
			shld dialog_update + 1
.endmacro

; invoke a dialog callback func
; if the callback pptr == NULL_PTR, return
dialog_update:
			lhld DIALOG_EMPTY_CALLBACK_PTR
			pchl

; call when a dialog step routine is about to go the the next step
dialog_update_next_step:
			lhld dialog_update + 1
			INX_H(2)
			shld dialog_update + 1
			ret

dialog_draw_frame:
			DRAW_TILED_IMG(__RAM_DISK_S_TILED_IMAGES_GFX, __RAM_DISK_S_TILED_IMAGES_DATA, __tiled_images_frame_ingame_dialog, __TILED_IMAGES_FRAME_INGAME_DIALOG_COPY_LEN, __tiled_images_tile1)
			; draw an animated spacebar
			; dialog_press_key (tiledata = 162)
			mvi b, 162
			@pos_tiles_x = 14
			@pos_tiles_y = 0
			mvi c, @pos_tiles_x + @pos_tiles_y * TILE_HEIGHT
			; b - tiledata
			; c - tile_idx in the room_tiledata array.			
			jmp backs_spawn

; draw a text on the SCR_BUFF3
; use macro DIALOG_DRAW_TEXT or DIALOG_DRAW_TEXT_HL to call this func
dialog_draw_text:
			CALL_RAM_DISK_FUNC(__text_ex_rd_reset_spacing, __RAM_DISK_S_FONT | __RAM_DISK_M_TEXT_EX)
			; draw text
			lxi b, $102d
dialog_draw_text_ptr:
			lxi h, TEMP_ADDR
			CALL_RAM_DISK_FUNC(__text_ex_rd_scr3, __RAM_DISK_S_FONT | __RAM_DISK_M_TEXT_EX)
			ret
.macro DIALOG_DRAW_TEXT(text_ptr)
			lxi h, text_ptr
			shld dialog_draw_text_ptr + 1
			call dialog_draw_text
.endmacro
; it assumes that hl regs contains text_ptr
.macro DIALOG_DRAW_TEXT_HL()
			shld dialog_draw_text_ptr + 1
			call dialog_draw_text
.endmacro

;===========================================================================
; dialog when the hero looses all the health
dialog_init_hero_no_health:
			.word @init, @draw_text, @check_key, DIALOG_EMPTY_CALLBACK

@init:		
			; disable hero updates
			mvi a, ACTOR_STATUS_NO_UPDATE
			sta hero_status
			call dialog_draw_frame
			jmp dialog_update_next_step

@draw_text:	
			DIALOG_DRAW_TEXT(__text_no_health)
			jmp dialog_update_next_step
			 
@check_key:
			; check if a fire action is pressed
			lda action_code
			ani CONTROL_CODE_FIRE1 | CONTROL_CODE_KEY_SPACE
			rz
			; it's pressed
			
			; requesting a level loading
			A_TO_ZERO(LEVEL_FIRST)
			sta level_idx
			mvi a, GAME_REQ_LEVEL_INIT
			sta global_request
			; restore a hero health
			mvi a, HERO_HEALTH_MAX
			sta hero_health
			jmp dialog_update_next_step

;===========================================================================
; dialog when the hero knocked his home door. 
; The game ends after showing the dialog
dialog_init_hero_knocked_his_home_door:
			.word @init, @draw_text, @check_key, DIALOG_EMPTY_CALLBACK

@init:		
			; disable hero updates
			mvi a, GAME_REQ_PAUSE
			sta global_request
			call dialog_draw_frame
			jmp dialog_update_next_step

@draw_text:	
			DIALOG_DRAW_TEXT(__text_knocked_his_home_door)
			jmp dialog_update_next_step
			 
@check_key:
			; check if a fire action is pressed
			lda action_code
			ani CONTROL_CODE_FIRE1 | CONTROL_CODE_KEY_SPACE
			rz
			; it's pressed
			
			; requesting a level loading
			mvi a, GAME_REQ_END_HOME
			sta global_request
			jmp dialog_update_next_step

;===========================================================================
; dialog when the hero knocked his friend door
; A hero gets a key 0 to open he backyard
dialog_quest_message_init:
            lxi h, @ptr_to_3
			jmp dialog_quest_message
@ptr_to_3:
			.byte 3
;===========================================================================
; dialog when a hero picks up the global item called TILEDATA_STORYTELLING
; it pauses everything except backs and ui, it erases backs
; when this dialog closes, the game redraws the room, then continues
; the limitations: LEVEL_IDX_0 in a range of 0-3
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

dialog_storytelling_texts_ptrs:
			STORYTELLING_TEXT_ENTITY(LEVEL_IDX_0, ROOM_ID_0, __text_game_story_home)
			STORYTELLING_TEXT_ENTITY(LEVEL_IDX_0, ROOM_ID_1, __text_game_story_farm_fence)
			STORYTELLING_TEXT_ENTITY(LEVEL_IDX_0, ROOM_ID_2, __text_game_story_road_to_friends_home)
			STORYTELLING_TEXT_ENTITY(LEVEL_IDX_0, ROOM_ID_3, __text_game_story_friends_home)
			STORYTELLING_TEXT_ENTITY(LEVEL_IDX_3, ROOM_ID_3, __text_knocked_his_friend_door) ; this is a quest dialog when a hero knocks his friend's door
@end_data:
STORYTELLING_TEXT_COUNT = (@end_data - dialog_storytelling_texts_ptrs) / STORYTELLING_TEXT_ENTITY_LEN

; restores storytelling text statuses
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
dialog_storytelling:
			; get the text ptr based on the level_idx and room_id
			lxi h, level_idx 			
; in:
; hl - ptr to level_idx
dialog_quest_message:
			lda room_id
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

			mvi a, GAME_REQ_PAUSE
			sta global_request
			
			; mark erased the runtime back data
			call backs_init

			; draw a dialog
			call dialog_draw_frame

			; get the text ptr
			pop h
			inx h
			mov e, m
			inx h
			mov d, m
			xchg
			; hl - text pptr
			DIALOG_DRAW_TEXT_HL()

			DIALOG_INIT(dialog_storytelling_steps)
			ret

dialog_storytelling_steps:
			.word @check_key, DIALOG_EMPTY_CALLBACK

@check_key:
			; check if a fire action is pressed
			lda action_code
			ani CONTROL_CODE_FIRE1 | CONTROL_CODE_KEY_SPACE
			rz
			; it's pressed
			mvi a, GAME_REQ_ROOM_DRAW
			sta global_request
			; TODO: restore breakables the same configuraton they were created
			jmp dialog_update_next_step


