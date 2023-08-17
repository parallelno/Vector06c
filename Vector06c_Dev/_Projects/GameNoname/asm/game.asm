.include "asm\\game_consts.asm"
.include "asm\\levels\\levels_consts.asm"
.include "asm\\levels\\levels_macro.asm"
.include "asm\\levels\\levels_data.asm"
.include "asm\\levels\\backs_consts.asm"

.include "asm\\globals\\actor_consts.asm"
.include "asm\\hero\\hero_consts.asm"
.include "asm\\monsters\\monsters_consts.asm"
.include "asm\\bullets\\bullets_consts.asm"

.include "asm\\globals\\buffers.asm"

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
.include "asm\\levels\\levels.asm"
.include "asm\\levels\\room.asm"
.include "asm\\levels\\backs.asm"
.include "asm\\ui\\ui.asm"

main_game:
			call levels_init
			call level_init
			
			call reset_game_updates_counter
@loop:
			call game_update
			call game_draw
			jmp	@loop

game_update:
			lxi h, game_update_counter
			inr m

@loop:
			CHECK_GAME_UPDATE_COUNTER(game_updates_counter)

			; check the pause
			lda global_request
			cpi GAME_REQ_PAUSE
			jz @pause

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



