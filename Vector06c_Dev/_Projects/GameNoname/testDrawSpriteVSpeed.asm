.include "burnerV.dasm"
.include "knightV.dasm"
.include "vampireV.dasm"
.include "scythe.dasm"

TestDrawSpriteVSpeedAnimIdx:
;			.storage 32, -2
			.byte 0,2,4,6,
			.byte 0,2,4,6,
			.byte 0,2,4,6,
			.byte 0,2,4,6,
			.byte 0,2,4,6,
			.byte 0,2,4,6,
			.byte 0,2,4,6,
			.byte 0,2,4,6,

TestDrawSpriteVSpeed:
			mvi c, 32
			lxi h, TestDrawSpriteVSpeedAnimIdx
@incrAnimIdx:
			mov a, m	
			adi 2
			ani %111
			mov m, a
			inx h
			dcr c
			jnz @incrAnimIdx
/*
; drawSprite func test
; h=16 32224, h=15 30574, 79%

			DRAW_SPRITE_FUNC(hero_run_r0, $a0ff - 16*3, TestDrawSpriteVSpeedAnimIdx)
			DRAW_SPRITE_FUNC(skeleton_run_r0, $a3ff - 16*3, TestDrawSpriteVSpeedAnimIdx+1)
			DRAW_SPRITE_FUNC(burner_idle_r, $a6ff - 16*3, TestDrawSpriteVSpeedAnimIdx+2)
			DRAW_SPRITE_FUNC(knight_run_r0, $a9ff - 16*3, TestDrawSpriteVSpeedAnimIdx+3)
			DRAW_SPRITE_FUNC(vampire_run_r0, $acff - 16*3, TestDrawSpriteVSpeedAnimIdx+4)
			DRAW_SPRITE_FUNC(knight_run_r0, $afff - 16*3, TestDrawSpriteVSpeedAnimIdx+5)
			DRAW_SPRITE_FUNC(skeleton_run_r0, $b2ff - 16*3, TestDrawSpriteVSpeedAnimIdx+6)
*/
; drawSpriteV func test
; h=15 28836, 74%, burner h = 13 28427 75%
/*
			DRAW_SPRITE_V_FUNC(hero_run_r0, $a0ff - 16*4, TestDrawSpriteVSpeedAnimIdx)
			DRAW_SPRITE_V_FUNC(skeleton_run_r0, $a3ff - 16*4, TestDrawSpriteVSpeedAnimIdx+1)
			DRAW_SPRITE_V_FUNC(burnerV_idle_r, $a6ff - 16*4, TestDrawSpriteVSpeedAnimIdx+2, DrawSpriteV2)
			DRAW_SPRITE_V_FUNC(knightV_run_r0, $a9ff - 16*4, TestDrawSpriteVSpeedAnimIdx+3)
			DRAW_SPRITE_V_FUNC(vampireV_run_r0, $acff - 16*4, TestDrawSpriteVSpeedAnimIdx+4)
			DRAW_SPRITE_V_FUNC(knightV_run_r0, $afff - 16*4, TestDrawSpriteVSpeedAnimIdx+5)
			DRAW_SPRITE_V_FUNC(skeleton_run_r0, $b2ff - 16*4, TestDrawSpriteVSpeedAnimIdx+6)
*/
/*
; 68%
			DRAW_SPRITE_V_FUNC(burnerV_idle_r, $a0ff - 16*4, TestDrawSpriteVSpeedAnimIdx)
			DRAW_SPRITE_V_FUNC(burnerV_idle_r, $a3ff - 16*4, TestDrawSpriteVSpeedAnimIdx+1)
			DRAW_SPRITE_V_FUNC(burnerV_idle_r, $a6ff - 16*4, TestDrawSpriteVSpeedAnimIdx+2)
			DRAW_SPRITE_V_FUNC(burnerV_idle_r, $a9ff - 16*4, TestDrawSpriteVSpeedAnimIdx+3)
			DRAW_SPRITE_V_FUNC(burnerV_idle_r, $acff - 16*4, TestDrawSpriteVSpeedAnimIdx+4)
			DRAW_SPRITE_V_FUNC(burnerV_idle_r, $afff - 16*4, TestDrawSpriteVSpeedAnimIdx+5)
			DRAW_SPRITE_V_FUNC(burnerV_idle_r, $b2ff - 16*4, TestDrawSpriteVSpeedAnimIdx+6)
*/

; 75%, 68%
			DRAW_SPRITE_V_FUNC(burnerV_idle_r, $a0ff - 16*4, TestDrawSpriteVSpeedAnimIdx, DrawSpriteV2)
			DRAW_SPRITE_V_FUNC(burnerV_idle_r, $a3ff - 16*4, TestDrawSpriteVSpeedAnimIdx+1, DrawSpriteV2)
			DRAW_SPRITE_V_FUNC(burnerV_idle_r, $a6ff - 16*4, TestDrawSpriteVSpeedAnimIdx+2, DrawSpriteV2)
			DRAW_SPRITE_V_FUNC(burnerV_idle_r, $a9ff - 16*4, TestDrawSpriteVSpeedAnimIdx+3, DrawSpriteV2)
			DRAW_SPRITE_V_FUNC(burnerV_idle_r, $acff - 16*4, TestDrawSpriteVSpeedAnimIdx+4, DrawSpriteV2)
			DRAW_SPRITE_V_FUNC(burnerV_idle_r, $afff - 16*4, TestDrawSpriteVSpeedAnimIdx+5, DrawSpriteV2)
			DRAW_SPRITE_V_FUNC(burnerV_idle_r, $b2ff - 16*4, TestDrawSpriteVSpeedAnimIdx+6, DrawSpriteV2)

/*
; 88%, 78%
			DRAW_SPRITE_V_FUNC(scythe_run_rn, $a0ff - 16*5, TestDrawSpriteVSpeedAnimIdx, DrawSpriteV2)
			DRAW_SPRITE_V_FUNC(scythe_run_ln, $a3ff - 16*5, TestDrawSpriteVSpeedAnimIdx+1, DrawSpriteV2)
			DRAW_SPRITE_V_FUNC(scythe_run_un, $a6ff - 16*5, TestDrawSpriteVSpeedAnimIdx+2, DrawSpriteV2)
			DRAW_SPRITE_V_FUNC(scythe_run_dn, $a9ff - 16*5, TestDrawSpriteVSpeedAnimIdx+3, DrawSpriteV2)
			DRAW_SPRITE_V_FUNC(scythe_run_cl, $acff - 16*5, TestDrawSpriteVSpeedAnimIdx+4, DrawSpriteV2)
			DRAW_SPRITE_V_FUNC(scythe_run_cc, $afff - 16*5, TestDrawSpriteVSpeedAnimIdx+5, DrawSpriteV2)
			DRAW_SPRITE_V_FUNC(scythe_run_rf, $b2ff - 16*5, TestDrawSpriteVSpeedAnimIdx+6, DrawSpriteV2)
			DRAW_SPRITE_V_FUNC(scythe_run_lf, $b5ff - 16*5, TestDrawSpriteVSpeedAnimIdx+7, DrawSpriteV2)
			DRAW_SPRITE_V_FUNC(scythe_run_uf, $b8ff - 16*5, TestDrawSpriteVSpeedAnimIdx+8, DrawSpriteV2)
			DRAW_SPRITE_V_FUNC(scythe_run_df, $bbff - 16*5, TestDrawSpriteVSpeedAnimIdx+9, DrawSpriteV2)
			DRAW_SPRITE_V_FUNC(scythe_run_rn, $a0ff - 16*6, TestDrawSpriteVSpeedAnimIdx+10, DrawSpriteV2)
			DRAW_SPRITE_V_FUNC(scythe_run_ln, $a3ff - 16*6, TestDrawSpriteVSpeedAnimIdx+11, DrawSpriteV2)
			DRAW_SPRITE_V_FUNC(scythe_run_un, $a6ff - 16*6, TestDrawSpriteVSpeedAnimIdx+12, DrawSpriteV2)
			DRAW_SPRITE_V_FUNC(scythe_run_dn, $a9ff - 16*6, TestDrawSpriteVSpeedAnimIdx+13, DrawSpriteV2)
*/
			;hlt_(25)

			ret

.macro      DRAW_SPRITE_FUNC(animAddr, screenAddr, animIdxAddr)
			lda animIdxAddr
			mov c, a
			lxi h, animAddr
			lxi d, screenAddr
			call GetSpriteAddr
			ora a
			jnz * + 9
			call DrawSprite16x15
			jmp * + 6
			call DrawSprite24x15
.endmacro
			
.macro      DRAW_SPRITE_V_FUNC(animAddr, screenAddr, animIdxAddr, drawFuncAddr = DrawSpriteV)
			lda animIdxAddr
			mov c, a
			lxi h, animAddr
			lxi d, screenAddr
			call GetSpriteAddr
			call drawFuncAddr
.endmacro		