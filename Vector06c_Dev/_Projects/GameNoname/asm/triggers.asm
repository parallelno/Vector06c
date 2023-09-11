;===========================================================================
; when the hero looses all the health
trigger_hero_no_health:
			; disable hero updates
			mvi a, ACTOR_STATUS_NO_UPDATE
			sta hero_status

			lxi h, @callback
			lxi d, __text_no_health
			A_TO_ZERO(GLOBAL_REQ_NONE)
			jmp dialog_init

@callback:
			; requesting a level loading
			A_TO_ZERO(LEVEL_FIRST)
			sta level_idx
			mvi a, GAME_REQ_LEVEL_INIT
			sta global_request
			; restore a hero health
			mvi a, HERO_HEALTH_MAX
			sta hero_health
			ret

;===========================================================================
; when the hero knocks his home door.
; The game ends after showing the dialog
trigger_hero_knocks_his_home_door:
			mvi a, GAME_REQ_PAUSE
			lxi h, @callback
			lxi d, __text_knocked_his_home_door
			jmp dialog_init

@callback:
			mvi a, GAME_REQ_END_HOME
			sta global_request
			ret

;===========================================================================
; when the hero knocks his friend door
; A hero gets a key 0 to open he backyard
trigger_hero_knocks_his_friend_door:
			; fix for multiple calls this function when a hero hits several trigger tiledatas
			call dialog_is_inited
			rz

			lxi h, global_items + ITEM_ID_KEY_0 - 1 ; because the first item_id = 1
			; check the key 0 status
			A_TO_ZERO(ITEM_STATUS_NOT_ACQUIRED)
			cmp m
			jnz @check_clothes; if it is acquired or used, check clothes item

			; if a key_0 isn't acquired, set key_0 status = ITEM_STATUS_ACQUIRED
			mvi m, ITEM_STATUS_ACQUIRED
			; init a dialog
			mvi a, GAME_REQ_PAUSE
			lxi h, dialog_callback_room_redraw
			lxi d, __text_knocked_his_friend_door
			jmp dialog_init

@check_clothes:
			; key_0 is acquired
			; check if clothes are acquired
			lxi h, hero_res_clothes
			A_TO_ZERO(0)
			cmp m
			jnz @clothes_acquired
@clothes_not_acquired:
			; the hero returns without clothes
			mvi a, GAME_REQ_PAUSE
			lxi h, dialog_callback_room_redraw
			lxi d, __text_knocked_his_friend_door_no_clothes
			jmp dialog_init

@clothes_acquired:
			; a hero returns with clothes
			; remove the clothes item
			; a = 0
			mov m, a
			; TODO: add score points
			; init a dialog
			mvi a, GAME_REQ_PAUSE
			lxi h, dialog_callback_room_redraw
			lxi d, __text_knocked_his_friend_door_clothes_returns
			jmp dialog_init





