.include "asm\\game_consts.asm"
.include "asm\\levels\\room_macro.asm"
.include "asm\\levels\\levels_data.asm"
.include "asm\\levels\\backs_consts.asm"

.include "asm\\globals\\actor_consts.asm"
.include "asm\\hero\\hero_consts.asm"
.include "asm\\monsters\\monsters_consts.asm"
.include "asm\\bullets\\bullets_consts.asm"

.include "asm\\globals\\runtime_data.asm"

.include "asm\\render\\draw_tile.asm"
.include "asm\\render\\draw_back.asm"
.include "asm\\render\\draw_decal.asm"
.include "asm\\render\\draw_tiled_img.asm"
.include "asm\\render\\sprite.asm"
.include "asm\\globals\\actor_macro.asm"
.include "asm\\globals\\actor.asm"
.include "asm\\hero\\hero.asm"
.include "asm\\monsters\\monsters.asm"
.include "asm\\bullets\\bullets.asm"
.include "asm\\levels\\breakables.asm"
.include "asm\\levels\\levels.asm"
.include "asm\\levels\\room.asm"
.include "asm\\levels\\backs.asm"
.include "asm\\ui\\ui.asm"
.include "asm\\triggers.asm"

main_game:
			call game_init
			call reset_game_updates_required_counter
@loop:
			call game_update
			call game_draw
			jmp	@loop

game_init:
			CALL_RAM_DISK_FUNC(__game_stats_init, __RAM_DISK_S_SCORE)
			call hero_game_init
			call levels_init
			call dialogs_init
			call game_ui_init
			ret

game_update:
			lxi h, game_update_counter
			inr m

@loop:
			CHECK_GAME_UPDATE_COUNTER(game_updates_required)

			; check the pause
			lda global_request
			cpi GAME_REQ_PAUSE			
			jz @pause
			cpi GAME_REQ_END_HOME
			jz @end

			call hero_update
			call monsters_update
			call bullets_update
			call level_update
@pause:			
			call backs_update
			call game_ui_update

			; to check repeated key-pressing
			lda action_code
			sta action_code_old
			jmp @loop
@end:		
			mvi a, GLOBAL_REQ_END_HOME
			sta global_request
			POP_H(1) ; to return into main_start loop
			ret

game_draw:
			; update counter to calc fps
			lhld game_draws_counter
			inx h
			shld game_draws_counter
			
			; draw funcs
			call backs_draw

			; return if the game paused
			lda global_request
			cpi GAME_REQ_PAUSE
			rz

			call hero_draw
			call monsters_draw
			call bullets_draw

			call hero_copy_to_scr
			call monsters_copy_to_scr
			call bullets_copy_to_scr

			call hero_erase
			call monsters_erase
			call bullets_erase
			ret



