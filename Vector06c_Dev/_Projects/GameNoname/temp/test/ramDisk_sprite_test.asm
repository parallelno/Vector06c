RamDiskInit_sprite_test:
			call RamDiskInit_sprite_test_clearScr
			; HERO
			RAM_DISK_ON(RAM_DISK_S0)
/*
			TEST_DRAW_SPRITE(hero_idle_r0_0, $a0f0 - 16)
			TEST_DRAW_SPRITE(hero_idle_r0_1, $a3f0 - 16)
			TEST_DRAW_SPRITE(hero_idle_r0_2, $a6f0 - 16)
			TEST_DRAW_SPRITE(hero_idle_r0_3, $a9f0 - 16)
			TEST_DRAW_SPRITE(hero_idle_r0_4, $acf0 - 16)
			TEST_DRAW_SPRITE(hero_idle_r0_5, $aff0 - 16)
			TEST_DRAW_SPRITE(hero_idle_r0_6, $b2f0 - 16)
			TEST_DRAW_SPRITE(hero_idle_r0_7, $b5f0 - 16)

			TEST_DRAW_SPRITE(hero_run_l0_0, $a0f0 - 16*2)
			TEST_DRAW_SPRITE(hero_run_l0_1, $a3f0 - 16*2)
			TEST_DRAW_SPRITE(hero_run_l0_2, $a6f0 - 16*2)
			TEST_DRAW_SPRITE(hero_run_l0_3, $a9f0 - 16*2)
			TEST_DRAW_SPRITE(hero_run_l0_4, $acf0 - 16*2)
			TEST_DRAW_SPRITE(hero_run_l0_5, $aff0 - 16*2)
			TEST_DRAW_SPRITE(hero_run_l0_6, $b2f0 - 16*2)
			TEST_DRAW_SPRITE(hero_run_l0_7, $b5f0 - 16*2)

			TEST_DRAW_SPRITE(hero_run_l1_0, $a0f0 - 16*3)
			TEST_DRAW_SPRITE(hero_run_l1_1, $a3f0 - 16*3)
			TEST_DRAW_SPRITE(hero_run_l1_2, $a6f0 - 16*3)
			TEST_DRAW_SPRITE(hero_run_l1_3, $a9f0 - 16*3)
			TEST_DRAW_SPRITE(hero_run_l1_4, $acf0 - 16*3)
			TEST_DRAW_SPRITE(hero_run_l1_5, $aff0 - 16*3)
			TEST_DRAW_SPRITE(hero_run_l1_6, $b2f0 - 16*3)
			TEST_DRAW_SPRITE(hero_run_l1_7, $b5f0 - 16*3)			
			
			TEST_DRAW_SPRITE(hero_run_l2_0, $a0f0 - 16*4)
			TEST_DRAW_SPRITE(hero_run_l2_1, $a3f0 - 16*4)
			TEST_DRAW_SPRITE(hero_run_l2_2, $a6f0 - 16*4)
			TEST_DRAW_SPRITE(hero_run_l2_3, $a9f0 - 16*4)
			TEST_DRAW_SPRITE(hero_run_l2_4, $acf0 - 16*4)
			TEST_DRAW_SPRITE(hero_run_l2_5, $aff0 - 16*4)
			TEST_DRAW_SPRITE(hero_run_l2_6, $b2f0 - 16*4)
			TEST_DRAW_SPRITE(hero_run_l2_7, $b5f0 - 16*4)
*/
			TEST_DRAW_SPRITE(hero_run_l3_0, $a0f0 - 16*5)
			TEST_DRAW_SPRITE(hero_run_l3_1, $a3f0 - 16*5)
			TEST_DRAW_SPRITE(hero_run_l3_2, $a6f0 - 16*5)
			TEST_DRAW_SPRITE(hero_run_l3_3, $a9f0 - 16*5)
			TEST_DRAW_SPRITE(hero_run_l3_4, $acf0 - 16*5)
			TEST_DRAW_SPRITE(hero_run_l3_5, $aff0 - 16*5)
			TEST_DRAW_SPRITE(hero_run_l3_6, $b2f0 - 16*5)
			TEST_DRAW_SPRITE(hero_run_l3_7, $b5f0 - 16*5)							



			TEST_DRAW_SPRITE(hero_attk_r0_0, $a0f0 - 16)
			TEST_DRAW_SPRITE(hero_attk_r0_1, $a3f0 - 16)
			TEST_DRAW_SPRITE(hero_attk_r0_2, $a6f0 - 16)
			TEST_DRAW_SPRITE(hero_attk_r0_3, $a9f0 - 16)
			TEST_DRAW_SPRITE(hero_attk_r0_4, $acf0 - 16)
			TEST_DRAW_SPRITE(hero_attk_r0_5, $aff0 - 16)
			TEST_DRAW_SPRITE(hero_attk_r0_6, $b2f0 - 16)
			TEST_DRAW_SPRITE(hero_attk_r0_7, $b5f0 - 16)

			TEST_DRAW_SPRITE(hero_attk_r1_0, $a0f0 - 16*2)
			TEST_DRAW_SPRITE(hero_attk_r1_1, $a3f0 - 16*2)
			TEST_DRAW_SPRITE(hero_attk_r1_2, $a6f0 - 16*2)
			TEST_DRAW_SPRITE(hero_attk_r1_3, $a9f0 - 16*2)
			TEST_DRAW_SPRITE(hero_attk_r1_4, $acf0 - 16*2)
			TEST_DRAW_SPRITE(hero_attk_r1_5, $aff0 - 16*2)
			TEST_DRAW_SPRITE(hero_attk_r1_6, $b2f0 - 16*2)
			TEST_DRAW_SPRITE(hero_attk_r1_7, $b5f0 - 16*2)

			TEST_DRAW_SPRITE(hero_attk_l0_0, $a0f0 - 16*3)
			TEST_DRAW_SPRITE(hero_attk_l0_1, $a3f0 - 16*3)
			TEST_DRAW_SPRITE(hero_attk_l0_2, $a6f0 - 16*3)
			TEST_DRAW_SPRITE(hero_attk_l0_3, $a9f0 - 16*3)
			TEST_DRAW_SPRITE(hero_attk_l0_4, $acf0 - 16*3)
			TEST_DRAW_SPRITE(hero_attk_l0_5, $aff0 - 16*3)
			TEST_DRAW_SPRITE(hero_attk_l0_6, $b2f0 - 16*3)
			TEST_DRAW_SPRITE(hero_attk_l0_7, $b5f0 - 16*3)

			TEST_DRAW_SPRITE(hero_attk_l1_0, $a0f0 - 16*4)
			TEST_DRAW_SPRITE(hero_attk_l1_1, $a3f0 - 16*4)
			TEST_DRAW_SPRITE(hero_attk_l1_2, $a6f0 - 16*4)
			TEST_DRAW_SPRITE(hero_attk_l1_3, $a9f0 - 16*4)
			TEST_DRAW_SPRITE(hero_attk_l1_4, $acf0 - 16*4)
			TEST_DRAW_SPRITE(hero_attk_l1_5, $aff0 - 16*4)
			TEST_DRAW_SPRITE(hero_attk_l1_6, $b2f0 - 16*4)
			TEST_DRAW_SPRITE(hero_attk_l1_7, $b5f0 - 16*4)	

			TEST_DRAW_SPRITE_M(hero_attack01_sword_r0_0, $a0f0 - 16*6)
			TEST_DRAW_SPRITE_M(hero_attack01_sword_r0_1, $a3f0 - 16*6)
			TEST_DRAW_SPRITE_M(hero_attack01_sword_r0_2, $a6f0 - 16*6)
			TEST_DRAW_SPRITE_M(hero_attack01_sword_r0_3, $a9f0 - 16*6)
			TEST_DRAW_SPRITE_M(hero_attack01_sword_r0_4, $acf0 - 16*6)
			TEST_DRAW_SPRITE_M(hero_attack01_sword_r0_5, $aff0 - 16*6)
			TEST_DRAW_SPRITE_M(hero_attack01_sword_r0_6, $b2f0 - 16*6)
			TEST_DRAW_SPRITE_M(hero_attack01_sword_r0_7, $b5f0 - 16*6)	

			TEST_DRAW_SPRITE_M(skeleton_idle_r0_0, $a080 - 16)
			TEST_DRAW_SPRITE_M(skeleton_idle_r0_1, $a380 - 16)
			TEST_DRAW_SPRITE_M(skeleton_idle_r0_2, $a680 - 16)
			TEST_DRAW_SPRITE_M(skeleton_idle_r0_3, $a980 - 16)

			TEST_DRAW_SPRITE_M(skeleton_idle_l0_0, $a080 - 16*2)
			TEST_DRAW_SPRITE_M(skeleton_idle_l0_1, $a380 - 16*2)
			TEST_DRAW_SPRITE_M(skeleton_idle_l0_2, $a680 - 16*2)
			TEST_DRAW_SPRITE_M(skeleton_idle_l0_3, $a980 - 16*2)

			TEST_DRAW_SPRITE_M(skeleton_run_r0_0, $a080 - 16*3)
			TEST_DRAW_SPRITE_M(skeleton_run_r0_1, $a380 - 16*3)
			TEST_DRAW_SPRITE_M(skeleton_run_r0_2, $a680 - 16*3)
			TEST_DRAW_SPRITE_M(skeleton_run_r0_3, $a980 - 16*3)

			TEST_DRAW_SPRITE_M(skeleton_run_r1_0, $a080 - 16*4)
			TEST_DRAW_SPRITE_M(skeleton_run_r1_1, $a380 - 16*4)
			TEST_DRAW_SPRITE_M(skeleton_run_r1_2, $a680 - 16*4)
			TEST_DRAW_SPRITE_M(skeleton_run_r1_3, $a980 - 16*4)
			
			TEST_DRAW_SPRITE_M(skeleton_run_r2_0, $a080 - 16*5)
			TEST_DRAW_SPRITE_M(skeleton_run_r2_1, $a380 - 16*5)
			TEST_DRAW_SPRITE_M(skeleton_run_r2_2, $a680 - 16*5)
			TEST_DRAW_SPRITE_M(skeleton_run_r2_3, $a980 - 16*5)
			
			TEST_DRAW_SPRITE_M(skeleton_run_r3_0, $a080 - 16*6)
			TEST_DRAW_SPRITE_M(skeleton_run_r3_1, $a380 - 16*6)
			TEST_DRAW_SPRITE_M(skeleton_run_r3_2, $a680 - 16*6)
			TEST_DRAW_SPRITE_M(skeleton_run_r3_3, $a980 - 16*6)

			RAM_DISK_OFF()
@loop:		jmp @loop
			ret

RamDiskInit_sprite_test_clearScr:
			lxi h, $A200
@column1:
			mvi m, 0
			inr l
			jnz @column1
			inr h
			rz
@column2:
			mvi m, 0
			inr l
			jnz @column2
			inr h
			rz
@column3:
			mvi m, 1
			inr l
			jnz @column3
			inr h
			jnz @column1
			ret

.macro TEST_DRAW_SPRITE(source, screen)
			lxi b, source
			lxi d, screen
			call DrawSpriteV
.endmacro
.macro TEST_DRAW_SPRITE_M(source, screen)
			lxi b, source
			lxi d, screen
			call DrawSpriteVM
.endmacro
			.closelabels

; sharetable chunk of code to restore SP and 
; return a couple of parameters within HL, C
DrawSpriteRet_ramDisk_:
drawSpriteRestoreSP_ramDisk_:
			lxi sp, TEMP_ADDR
drawSpriteScrAddr_ramDisk_:
			lxi b, TEMP_ADDR
drawSpriteWidthHeight_ramDisk_:
; d - width
;		00 - 8pxs,
;		01 - 16pxs,
;		10 - 24pxs,
;		11 - 32pxs,
; e - height
			lxi d, TEMP_WORD
			;RAM_DISK_OFF()
drawSpriteRestoreRet_ramDisk__:
			jmp TEMP_ADDR
			.closelabels
			
; =============================================
; Draw a sprite without a mask in three consiquence screen buffs with offsetX and offsetY
; width is 1-3 bytes
; height is 0-255
; offsetX in bytes
; offsetY in pixels
; it uses sp to read the sprite data

; input:
; bc	sprite data
; de	screen address
; use: a, hl, sp

; the sprite format:
; 0, 0 - safety bytes
; offsetY, offsetX
; height, width
	; width: 0 - one byte width, 1 - two bytes width, 2 - three bytes width

; art data:
; 1st screen buff : 1 -> 2
; 2nd screen buff : 4 <- 3
; 3rd screen buff : 6 <- 5
; y++
; 3rd screen buff : 7 -> 8
; 2nd screen buff : 10 <- 9
; 1st screen buff : 12 <- 11
; y++
; repeat for the next lines of the art data
.macro DrawSpriteV_B0()
			pop b
			mov m, c
.endmacro
.macro DrawSpriteV_B1()
			mov m, b
.endmacro
DrawSpriteV:
			; store ret addr
			pop h
			shld drawSpriteRestoreRet_ramDisk__ + 1
			; store SP
			lxi h, 0
			dad sp
			shld drawSpriteRestoreSP_ramDisk_ + 1
			; sp = BC
			mov	h, b
			mov	l, c
			sphl
			xchg
			; b - offsetX
			; c - offsetY
			pop b
			dad b
			; store a sprite screen addr to return it from this func
			shld drawSpriteScrAddr_ramDisk_+1

			; store sprite width and height
			; b - width, c - height
			pop b
			mov d, b
			mov e, c
			xchg
			shld drawSpriteWidthHeight_ramDisk_+1
			xchg
			mov a, b
			rrc
			jc @width16
			rrc
			jc @width24
			jmp @width8

;------------------------------------------------
@width16:
			; save the high screen byte to restore X
			rlc
			add h
			sta @w16oddScr1+1
			adi $20
			mov d, a
			adi $20
			sta @w16evenScr3+1

@w16evenScr1:
			DrawSpriteV_B0()
			inr h
			DrawSpriteV_B1()
@w16evenScr2:
			mov h, d
			DrawSpriteV_B0()
			dcr h
			DrawSpriteV_B1()
@w16evenScr3:
			mvi h, TEMP_BYTE
			DrawSpriteV_B0()
			dcr h
			DrawSpriteV_B1()
			inr l
			dcr e
			jz DrawSpriteRet_ramDisk_

@w16oddScr3:
			DrawSpriteV_B0()
			inr h
			DrawSpriteV_B1()
@w16oddScr2:
			mov h, d
			DrawSpriteV_B0()
			dcr h
			DrawSpriteV_B1()
@w16oddScr1:
			mvi h, TEMP_BYTE
			DrawSpriteV_B0()
			dcr h
			DrawSpriteV_B1()
			inr l
			dcr e
			jnz @w16evenScr1
			jmp DrawSpriteRet_ramDisk_
;-------------------------------------------------
@width24:
			; save the high screen byte to restore X
			mvi a, 2
			add h
			sta @w24oddScr1+1
			adi $20
			mov d, a
			adi $20
			sta @w24evenScr3+1

@w24evenScr1:
			DrawSpriteV_B0()
			inr h
			DrawSpriteV_B1()
			inr h
			DrawSpriteV_B0()

@w24evenScr2:
			mov h, d
			DrawSpriteV_B1()
			dcr h
			DrawSpriteV_B0()
			dcr h
			DrawSpriteV_B1()

@w24evenScr3:
			mvi h, TEMP_BYTE
			DrawSpriteV_B0()
			dcr h
			DrawSpriteV_B1()
			dcr h
			DrawSpriteV_B0()
			inr l
			dcr e
			jz DrawSpriteRet_ramDisk_

@w24oddScr3:
			DrawSpriteV_B1()
			inr h
			DrawSpriteV_B0()
			inr h
			DrawSpriteV_B1()
@w24oddScr2:
			mov h, d
			DrawSpriteV_B0()
			dcr h
			DrawSpriteV_B1()
			dcr h
			DrawSpriteV_B0()
@w24oddScr1:
			mvi h, TEMP_BYTE
			DrawSpriteV_B1()
			dcr h
			DrawSpriteV_B0()
			dcr h
			DrawSpriteV_B1()
			inr l
			dcr e
			jnz @w24evenScr1
			jmp DrawSpriteRet_ramDisk_
;------------------------------------------------------
@width8:
			; save the high screen byte to restore X
			mov a, h
			sta @w8oddScr1+1
			adi $20
			mov d, a
			adi $20
			sta @w8evenScr3+1

@w8evenScr1:
			DrawSpriteV_B0()
@w8evenScr2:
			mov h, d
			DrawSpriteV_B1()
@w8evenScr3:
			mvi h, TEMP_BYTE
			DrawSpriteV_B0()
			inr l
			dcr e
			jz DrawSpriteRet_ramDisk_
@w8oddScr3:
			DrawSpriteV_B1()
@w8oddScr2:
			mov h, d
			DrawSpriteV_B0()
@w8oddScr1:
			mvi h, TEMP_BYTE
			DrawSpriteV_B1()
			inr l
			dcr e
			jnz @w8evenScr1
			jmp DrawSpriteRet_ramDisk_
			.closelabels


; =============================================
; Draw a sprite with a mask in three consiquence screen buffs with offsetX and offsetY
; width is 1-3 bytes
; height is 0-255
; offsetX in bytes
; offsetY in pixels
; it uses sp to read the sprite data

; input:
; bc	sprite data
; de	screen address
; use: a, hl, sp

; the sprite format:
; 0, 0 - safety bytes
; offsetY, offsetX
; height, width
	; width: 0 - one byte width, 1 - two bytes width, 2 - three bytes width

; art data:
; 1st screen buff : 1 -> 2
; 2nd screen buff : 4 <- 3
; 3rd screen buff : 6 <- 5
; y++
; 3rd screen buff : 7 -> 8
; 2nd screen buff : 10 <- 9
; 1st screen buff : 12 <- 11
; y++
; repeat for the next lines of the art data
.macro DRAW_SPRITE_V_M()
			pop b
			mov a, m
			ana c
			ora b
			mov m, a
.endmacro

DrawSpriteVM:
			; store ret addr
			pop h
			shld drawSpriteRestoreRet_ramDisk__ + 1
			; store SP
			lxi h, 0
			dad sp
			shld drawSpriteRestoreSP_ramDisk_ + 1
			; sp = BC
			mov	h, b
			mov	l, c
			sphl
			xchg
			; b - offsetX
			; c - offsetY
			pop b
			dad b
			; store a sprite screen addr to return it from this func
			shld drawSpriteScrAddr_ramDisk_+1

			; store sprite width and height
			; b - width, c - height
			pop b
			mov d, b
			mov e, c
			xchg
			shld drawSpriteWidthHeight_ramDisk_+1
			xchg
			mov a, b
			rrc
			jc @width16
			rrc
			jc @width24
			jmp @width8


;------------------------------------------------
@width16:
			; save the high screen byte to restore X
			rlc
			add h
			sta @w16oddScr1+1
			adi $20
			mov d, a
			adi $20
			sta @w16evenScr3+1

@w16evenScr1:
			DRAW_SPRITE_V_M()
			inr h
			DRAW_SPRITE_V_M()
@w16evenScr2:
			mov h, d
			DRAW_SPRITE_V_M()
			dcr h
			DRAW_SPRITE_V_M()
@w16evenScr3:
			mvi h, TEMP_BYTE
			DRAW_SPRITE_V_M()
			dcr h
			DRAW_SPRITE_V_M()
			inr l
			dcr e
			jz DrawSpriteRet_ramDisk_

@w16oddScr3:
			DRAW_SPRITE_V_M()
			inr h
			DRAW_SPRITE_V_M()
@w16oddScr2:
			mov h, d
			DRAW_SPRITE_V_M()
			dcr h
			DRAW_SPRITE_V_M()
@w16oddScr1:
			mvi h, TEMP_BYTE
			DRAW_SPRITE_V_M()
			dcr h
			DRAW_SPRITE_V_M()
			inr l
			dcr e
			jnz @w16evenScr1
			jmp DrawSpriteRet_ramDisk_
;-------------------------------------------------
@width24:
			; save the high screen byte to restore X
			mvi a, 2
			add h
			sta @w24oddScr1+1
			adi $20
			mov d, a
			adi $20
			sta @w24evenScr3+1

@w24evenScr1:
			DRAW_SPRITE_V_M()
			inr h
			DRAW_SPRITE_V_M()
			inr h
			DRAW_SPRITE_V_M()

@w24evenScr2:
			mov h, d
			DRAW_SPRITE_V_M()
			dcr h
			DRAW_SPRITE_V_M()
			dcr h
			DRAW_SPRITE_V_M()

@w24evenScr3:
			mvi h, TEMP_BYTE
			DRAW_SPRITE_V_M()
			dcr h
			DRAW_SPRITE_V_M()
			dcr h
			DRAW_SPRITE_V_M()
			inr l
			dcr e
			jz DrawSpriteRet_ramDisk_

@w24oddScr3:
			DRAW_SPRITE_V_M()
			inr h
			DRAW_SPRITE_V_M()
			inr h
			DRAW_SPRITE_V_M()
@w24oddScr2:
			mov h, d
			DRAW_SPRITE_V_M()
			dcr h
			DRAW_SPRITE_V_M()
			dcr h
			DRAW_SPRITE_V_M()
@w24oddScr1:
			mvi h, TEMP_BYTE
			DRAW_SPRITE_V_M()
			dcr h
			DRAW_SPRITE_V_M()
			dcr h
			DRAW_SPRITE_V_M()
			inr l
			dcr e
			jnz @w24evenScr1
			jmp DrawSpriteRet_ramDisk_
;------------------------------------------------------
@width8:
			; save the high screen byte to restore X
			mov a, h
			sta @w8oddScr1+1
			adi $20
			mov d, a
			adi $20
			sta @w8evenScr3+1

@w8evenScr1:
			DRAW_SPRITE_V_M()
@w8evenScr2:
			mov h, d
			DRAW_SPRITE_V_M()
@w8evenScr3:
			mvi h, TEMP_BYTE
			DRAW_SPRITE_V_M()
			inr l
			dcr e
			jz DrawSpriteRet_ramDisk_
@w8oddScr3:
			DRAW_SPRITE_V_M()
@w8oddScr2:
			mov h, d
			DRAW_SPRITE_V_M()
@w8oddScr1:
			mvi h, TEMP_BYTE
			DRAW_SPRITE_V_M()
			inr l
			dcr e
			jnz @w8evenScr1
			jmp DrawSpriteRet_ramDisk_
			.closelabels
