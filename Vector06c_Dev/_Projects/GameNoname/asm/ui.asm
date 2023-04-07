.include "text.asm"
.include "text2.asm"

game_ui_init:
			call game_ui_panel_draw
			lda hero_health
			call game_ui_health_draw
			ret
/*
GameUIUpdate:
			ret
*/

game_ui_panel_draw:
			; hl - text addr
			; bc - screen addr
			lxi h, game_ui_health_bar_text
			lxi b, $a4ff			
			call draw_text
			ret
game_ui_health_bar_text:
			.byte $3a,$31,$30,0

; in:
; a - hero_health
game_ui_health_draw:
			lxi h, game_ui_health_bar_text+1
			call hex_to_askii

			; hl - text addr
			; bc - screen addr
			lxi h, game_ui_health_bar_text+1
			lxi b, $a5ff		
			call draw_text
			ret




