.include "asm\\game_const.asm"
.include "asm\\levels\\levels_const.asm"
.include "asm\\levels\\levels_macro.asm"
.include "asm\\levels\\levels_data.asm"

.include "asm\\bullets\\bullets_consts.asm"
.include "asm\\render\\draw_tile.asm"
.include "asm\\render\\draw_back.asm"
.include "asm\\render\\draw_decal.asm"
.include "asm\\render\\sprite.asm"
.include "asm\\render\\actor_macro.asm"
.include "asm\\render\\actor.asm"
.include "asm\\hero.asm"
.include "asm\\monsters\\monsters.asm"
.include "asm\\bullets\\bullets.asm"
.include "asm\\levels\\levels.asm"
.include "asm\\levels\\room.asm"
.include "asm\\levels\\backs.asm"
.include "asm\\render\\text.asm"
.include "asm\\ui.asm"

game_init:
			call levels_init
			call level_init
			call room_init
			call game_ui_init

			xra a
			sta update_request_counter
			hlt
@gameLoop:
			CALL_RAM_DISK_FUNC(__gcplayer_start_repeat, __RAM_DISK_S_GCPLAYER | __RAM_DISK_M_GCPLAYER | RAM_DISK_M_8F)
			call game_update
			call game_draw
			jmp	 @gameLoop

game_update:
			lxi h, game_update_counter
			inr m

			; check if an interuption happened
			lda update_request_counter
			ora a
			rz
@updateLoop:
			call hero_update
			call monsters_update
			call bullets_update
			call level_update
			call backs_update

			; to check repeated key-pressing
			lhld key_code
			shld key_code_old

			lxi h, update_request_counter
			dcr m
			jnz @updateLoop
			ret

game_draw:
			lxi h, game_draws_counter
			inr m

			call backs_draw

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



