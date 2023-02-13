;.include "text.asm"

game_ui_init:
			call GameUIPanelDraw
			call game_ui_health_draw
			ret
/*
GameUIUpdate:
			ret
*/

GameUIPanelDraw:
			; hl - text addr
			; bc - screen addr
			lxi h, gameUIHealthBarText
			lxi b, $a4ff			
			call DrawText
			ret
gameUIHealthBarText:
			.byte $3a,$31,$30,0

game_ui_health_draw:
			lxi h, gameUIHealthBarText+1
			lda hero_health
			call HexToAskii

			; hl - text addr
			; bc - screen addr
			lxi h, gameUIHealthBarText+1
			lxi b, $a5ff		
			call DrawText
			ret




