;-------------------------------------------------
;|                                               |
;|     Sprite Rendering Speed Test		         |
;|     											 |
;|     Original ver. 2020						 |
;|     by KTSerg aka Sergey Cherkozianov		 |
;-------------------------------------------------

; local
TIMER_SEC				= 10
TIMER_COUNTER_ADDR		= $9F10
TIMER_STOP_FLAG_ADDR	= $9F18
TIMER_STOP_FLAG_INIT	= $0FF

SPRITE_COUNTER_ADDR		= $9FF4
SPRITE_SCR_ADDR			= $8EE0
RES_SCR_ADDR_0			= $80D0
RES_SCR_ADDR_1			= $80B0
RES_SCR_ADDR_2			= $8080
RES_SCR_ADDR_3			= $8060
RES_SCR_ADDR_4			= $8030
RES_SCR_ADDR_5			= $8010

SPRITE_SCR_ADDR_		= $8F00
SPRITE_SCR_ADDR_0 		= SPRITE_SCR_ADDR_ + $0D0
SPRITE_SCR_ADDR_1 		= SPRITE_SCR_ADDR_ + $0B0
SPRITE_SCR_ADDR_2 		= SPRITE_SCR_ADDR_ + $80
SPRITE_SCR_ADDR_3 		= SPRITE_SCR_ADDR_ + $60
SPRITE_SCR_ADDR_4 		= SPRITE_SCR_ADDR_ + $30 + 23
SPRITE_SCR_ADDR_5 		= SPRITE_SCR_ADDR_ + $10 + 23

.include "init.asm"
.include "macro.asm"
; subs
.include "utils.asm"
.include "interruptions.asm"

Start:
;----------------------------------------------------------------
; The list of the sprite rendering subroutines to measure the render speed.
; The result is an amount of sprites rendered during TIMER_SEC seconds

			CALL	InitTimer
			TestDraw (spriteData01, SPRITE_SCR_ADDR_4, DrawSprite_ivagor, RES_SCR_ADDR_4 )
			
			CALL	InitTimer
			TestDraw (spriteData01, SPRITE_SCR_ADDR_5, DrawSprite_parallelno2, RES_SCR_ADDR_5)
			
			CALL	InitTimer
			TestDraw (spriteData01, SPRITE_SCR_ADDR_0, DrawSprite_Jerri_orig, RES_SCR_ADDR_0)

			CALL	InitTimer
			TestDraw (spriteData01, SPRITE_SCR_ADDR_1, DrawSprite_Jerri_unrolled, RES_SCR_ADDR_1)

			CALL	InitTimer
			TestDraw (spriteData01, SPRITE_SCR_ADDR_2, DrawSprite_Serg_orig, RES_SCR_ADDR_2)

			CALL	InitTimer
			TestDraw (spriteData01, SPRITE_SCR_ADDR_3, DrawSprite_Serg_unrolled, RES_SCR_ADDR_3)

;----------------------------------------------------------------
			MVI		A, 4
			STA		borderColorIdx
			HLT		
			CALL	SetPalette
infLoop:	JMP		infLoop


;================================================================
; SUBROUTINES
;================================================================


;----------------------------------------------------------------
; Timer Initialization
; in: none
; use: A, HL

InitTimer:	DI
			; timer checks interruption ticks
			LXI		H, TIMER_SEC * INT_TICKS_PER_SEC
			SHLD	TIMER_COUNTER_ADDR
			MVI		A, TIMER_STOP_FLAG_INIT
			STA		TIMER_STOP_FLAG_ADDR
			LXI		H, 0
			SHLD	SPRITE_COUNTER_ADDR
			EI
			HLT
			RET

;----------------------------------------------------------------
; Test Drawing a Sprite (24x24 pixels)
				
			.macro TestDraw(_spriteData, _scrAddr, _drawSub, _resultScrAddr)
			LHLD	SPRITE_COUNTER_ADDR

@loop:		LXI		B, _spriteData
			LXI		D, _scrAddr
			PUSH	H
			CALL	_drawSub
			POP		H
			INX		H
			LDA		TIMER_STOP_FLAG_ADDR
			ORA		A
			JNZ		@loop
			SHLD	SPRITE_COUNTER_ADDR
			LXI		D, _resultScrAddr
			CALL	DrawResult
			.endmacro

;----------------------------------------------------------------
; Draw a Test Result (HEX)
; in: DE	result screen address
; use: A, HL, DE,

DrawResult:
			LDA		SPRITE_COUNTER_ADDR + 1
			RRC_(4)
			CALL	GetSpriteAddr
			PUSH	D
			CALL	DrawSprite_Jerri_orig
			POP		D
			INR_D(3)

			LDA		SPRITE_COUNTER_ADDR + 1
			CALL	GetSpriteAddr
			PUSH	D
			CALL	DrawSprite_Jerri_orig
			POP		D
			INR_D(3)

			LDA		SPRITE_COUNTER_ADDR
			RRC_(4)
			CALL	GetSpriteAddr
			PUSH	D
			CALL	DrawSprite_Jerri_orig
			POP		D
			INR_D(3)

			LDA		SPRITE_COUNTER_ADDR
			CALL	GetSpriteAddr
			CALL	DrawSprite_Jerri_orig

			RET

;----------------------------------------------------------------
; Get an address by a sprite index
; in: A		sprite index
; out: BC	sprite address
; use: HL

GetSpriteAddr:
			; BC = (A % 16) * 2 + spriteTable
			ANI		$0F				; (8)
			ADD		A				; (4)
			MOV		C, A			; (8)
			MVI		B, 0			; (8)
			LXI		H, spriteTable	; (12)
			DAD		B				; (12)
			MOV		C, M			; (8)
			INX		H				; (8)
			MOV		B, M			; (8)
			RET						; (12)
									; (88) total, 14 bytes

;----------------------------------------------------------------
; draw a sprite (24x24 pixels)
; author jerri
; method:

; in:
; BC	sprite data
; DE	screen address (x,y)

			.function DS_Jerri_orig
DrawSprite_Jerri_orig:
			; store SP
			LXI		H, 0
			DAD		SP
			SHLD	@restoreSP+1
			
			MVI		A, 12	; this loop draws two line at once, so the counter = spriteDY / 2
			MOV		H, B
			MOV		L, C
			MOV		C, M
			INX		H
			MOV		B, M
			INX		H
			SPHL
			MOV		L, E				;задаем Y в L
			MOV		E, A				;задаем высоту спрайта в E
			MOV		A, D				;задаем X в A
			MVI		D, $20				;переход между битпланами
@loop:
			;рисуем на первом плане
			MOV		H, A
			MOV		M, C
			INR		H
			MOV		M, B
			INR		H
			POP		B
			MOV		M, C

		;переход на второй битплан
			ADD		D
			MOV		H, A
		;рисуем на втором плане
			MOV		M, B
			INR		H
			POP		B
			MOV		M, C
			INR		H
			MOV		M, B
			POP		B

		;переход на третий битплан
			ADD		D
			MOV		H, A
		;рисуем на третьем плане
			MOV		M, C
			INR		H
			MOV		M, B
			INR		H
			POP		B
			MOV		M, C

		;возвращаемся на первый план	
			SUI		$40
			MOV		h,a
		;переходим на следующую строку
			INR	l	

		;повторяем цикл рисования
			MOV		M, B
			INR		H
			POP		B
			MOV		M, C
			INR		H
			MOV		M, B
			POP		B
		;переход на второй битплан
			ADD	d

			MOV	h,a
		;рисуем на втором плане
			MOV		M, C
			INR		H
			MOV		M, B
			INR		H
			POP		B
			MOV		M, C
		;переход на третий битплан
			ADD	d

			MOV	h,a
		;рисуем на третьем плане
			MOV		M, B
			INR		H
			POP		B
			MOV		M, C
			INR		H
			MOV		M, B
			POP		B

		;возвращаемся на первый план	
			SUI	$40
			MOV	h,a
		;переходим на следующую строку
			INR	l	
		;проверяем на завершение цикла 
			DCR	e
			JNZ	@loop	
@restoreSP:
			LXI		SP, TEMP_ADDR
			RET
			.endfunction


;----------------------------------------------------------------
; draw a sprite (24x24 pixels)
; author TKSerg
; method: выводим по колонке, слева на право

; in:
; BC	sprite data
; DE	screen address (x,y)

DrawSprite_Serg_orig:
	LXI	h,0
	DAD	sp	; в hl - указатель стека
	SHLD	sp_rd+1	; сохраним указатель стека для восстановления
	MOV	h,b
	MOV	l,c
	SPHL	; hl -> sp  - указатель стека на начало указанного спрайта
	XCHG		; обмен hl<->de
	SHLD	spr_ekran	; адрес спрайта на экране
;
; вывод спрайта
	MVI	e,6	; количество повторов вывода 4 строк спрайта
	LHLD	spr_ekran	; получение адреса спрайта на экране
	MVI	d,$20		 ; смещение на след. экранную плоскость
spr_c6:	MOV	a,h	; сохранить адрес колонки на первой экр. плоскости
;
	POP		B	; прочитать два байта спрайта
	MOV		M, C	; вывод байта на экран
	INR	l	 ; строка вверх на экране
	MOV		M, B	; вывод байта на экран
	INR		H	 ; следующая колонка
	POP		B	; прочитать два байта спрайта
	MOV		M, C	; вывод байта на экран
	DCR	l	 ; строка вниз на экране
	MOV		M, B	; вывод байта на экран
	INR		H	 ; следующая колонка
	POP		B	; прочитать два байта спрайта
	MOV		M, C	; вывод байта на экран
	INR	l	 ; строка вверх на экране
	MOV		M, B	; вывод байта на экран
;
	ADD	d	; след. экранная плоскость
	MOV	h,a
;
	POP		B	; прочитать два байта спрайта
	MOV		M, C	; вывод байта на экран
	DCR	l	 ; строка вниз на экране
	MOV		M, B	; вывод байта на экран
	INR		H	 ; следующая колонка
	POP		B	; прочитать два байта спрайта
	MOV		M, C	; вывод байта на экран
	INR	l	 ; строка вверх на экране
	MOV		M, B	; вывод байта на экран
	INR		H	 ; следующая колонка
	POP		B	; прочитать два байта спрайта
	MOV		M, C	; вывод байта на экран
	DCR	l	 ; строка вниз на экране
	MOV		M, B	; вывод байта на экран
;
	ADD	d	; след. экранная плоскость
	MOV	h,a
;
	POP		B	; прочитать два байта спрайта
	MOV		M, C	; вывод байта на экран
	INR	l	 ; строка вверх на экране
	MOV		M, B	; вывод байта на экран
	INR		H	 ; следующая колонка
	POP		B	; прочитать два байта спрайта
	MOV		M, C	; вывод байта на экран
	DCR	l	 ; строка вниз на экране
	MOV		M, B	; вывод байта на экран
	INR		H	 ; следующая колонка
	POP		B	; прочитать два байта спрайта
	MOV		M, C	; вывод байта на экран
	INR	l	 ; строка вверх на экране
	MOV		M, B	; вывод байта на экран
;
	INR	l	 ; строка вверх на экране - правая колонка, 3-я строка
	SUI	$40
	MOV	h,a	; первая экранная плоскость
;
	POP		B	; прочитать два байта спрайта
	MOV		M, C	; вывод байта на экран
	INR	l	 ; строка вверх на экране
	MOV		M, B	; вывод байта на экран
	INR		H	 ; следующая колонка
	POP		B	; прочитать два байта спрайта
	MOV		M, C	; вывод байта на экран
	DCR	l	 ; строка вниз на экране
	MOV		M, B	; вывод байта на экран
	INR		H	 ; следующая колонка
	POP		B	; прочитать два байта спрайта
	MOV		M, C	; вывод байта на экран
	INR	l	 ; строка вверх на экране
	MOV		M, B	; вывод байта на экран
;
	ADD	d	; след. экранная плоскость
	MOV	h,a
;
	POP		B	; прочитать два байта спрайта
	MOV		M, C	; вывод байта на экран
	DCR	l	 ; строка вниз на экране
	MOV		M, B	; вывод байта на экран
	INR		H	 ; следующая колонка
	POP		B	; прочитать два байта спрайта
	MOV		M, C	; вывод байта на экран
	INR	l	 ; строка вверх на экране
	MOV		M, B	; вывод байта на экран
	INR		H	 ; следующая колонка
	POP		B	; прочитать два байта спрайта
	MOV		M, C	; вывод байта на экран
	DCR	l	 ; строка вниз на экране
	MOV		M, B	; вывод байта на экран
;
	ADD	d	; след. экранная плоскость
	MOV	h,a
;
	POP		B	; прочитать два байта спрайта
	MOV		M, C	; вывод байта на экран
	INR	l	 ; строка вверх на экране
	MOV		M, B	; вывод байта на экран
	INR		H	 ; следующая колонка
	POP		B	; прочитать два байта спрайта
	MOV		M, C	; вывод байта на экран
	DCR	l	 ; строка вниз на экране
	MOV		M, B	; вывод байта на экран
	INR		H	 ; следующая колонка
	POP		B	; прочитать два байта спрайта
	MOV		M, C	; вывод байта на экран
	INR	l	 ; строка вверх на экране
	MOV		M, B	; вывод байта на экран
;
	INR	l	 ; строка вверх на экране - правая колонка, 3-я строка
	SUI	$40
	MOV	h,a	; первая экранная плоскость
;
	DCR	e
	JNZ	spr_c6
;
	POP		B	; пустое чтение
;
sp_rd:	LXI	sp,0	; восстановление стека после вывода спрайта
;
	RET	; вЫход из подпрограммы вывода спрайта на экран
;
spr_ekran:
	.byte	$80,$88		; адрес на экране для вывода спрайта

;----------------------------------------------------------------
; draw a sprite (24x24 pixels)
; author: Serg
; method: выводим по колонке, слева на право

; in:
; BC	sprite data
; DE	screen address (x,y)

			.function DrawSprite_Serg_unrolledF
DrawSprite_Serg_unrolled:
			LXI		H, 0
			DAD		SP			; в hl - указатель стека
			SHLD	spr2rd+1	; сохраним указатель стека для восстановления
			MOV	h,b
			MOV	l,c
			SPHL	; hl -> sp  - указатель стека на начало указанного спрайта
			XCHG		; обмен hl<->de

			SHLD	spr_ekran	; адрес спрайта на экране
			MVI	a,3	; количество повторов вывода колонок
			STA	spr2k+1	; сохраним в алгоритм
			MOV	a,l	 ; строка для вывода спрайта Y
			STA	spr2l+1	 ; сохраним Y
			MOV	a,h
			ADI	$20
			MOV	d,a	; вторая плоскость
			ADI	$20
			MOV	e,a	; третья плоскость
		;	MOV	a,h	; первая плоскость
;
; вывод спрайта
spr2c6:
	MOV	a,h	; первая плоскость
; строки 1 и 2
	POP		B	; прочитать два байта спрайта
	MOV		M, C	; вывод байта на экран
	MOV		h, d	 ; вторая плоскость
	MOV		M, B	; вывод байта на экран
	MOV	h,e	 ; третья плоскость
	POP		B	; прочитать два байта спрайта
	MOV		M, C	; вывод байта на экран
	INR	l	 ; строка вверх на экране
	MOV		M, B	; вывод байта на экран
	MOV	h,d	 ; вторая плоскость
	POP		B	; прочитать два байта спрайта
	MOV		M, C	; вывод байта на экран
	MOV	h,a	; первая плоскость
	MOV		M, B	; вывод байта на экран
; строки 3 и 4
	INR	l	 ; строка вверх на экране

	POP		B	; прочитать два байта спрайта
	MOV		M, C	; вывод байта на экран
	MOV	h,d	 ; вторая плоскость
	MOV		M, B	; вывод байта на экран
	MOV	h,e	 ; третья плоскость
	POP		B	; прочитать два байта спрайта
	MOV		M, C	; вывод байта на экран
	INR	l	 ; строка вверх на экране
	MOV		M, B	; вывод байта на экран
	MOV	h,d	 ; вторая плоскость
	POP		B	; прочитать два байта спрайта
	MOV		M, C	; вывод байта на экран
	MOV	h,a	; первая плоскость
	MOV		M, B	; вывод байта на экран
; строки 5 и 6
	INR	l	 ; строка вверх на экране

	POP		B	; прочитать два байта спрайта
	MOV		M, C	; вывод байта на экран
	MOV	h,d	 ; вторая плоскость
	MOV		M, B	; вывод байта на экран
	MOV	h,e	 ; третья плоскость
	POP		B	; прочитать два байта спрайта
	MOV		M, C	; вывод байта на экран
	INR	l	 ; строка вверх на экране
	MOV		M, B	; вывод байта на экран
	MOV	h,d	 ; вторая плоскость
	POP		B	; прочитать два байта спрайта
	MOV		M, C	; вывод байта на экран
	MOV	h,a	; первая плоскость
	MOV		M, B	; вывод байта на экран
; строки 7 и 8
	INR	l	 ; строка вверх на экране

	POP		B	; прочитать два байта спрайта
	MOV		M, C	; вывод байта на экран
	MOV	h,d	 ; вторая плоскость
	MOV		M, B	; вывод байта на экран
	MOV	h,e	 ; третья плоскость
	POP		B	; прочитать два байта спрайта
	MOV		M, C	; вывод байта на экран
	INR	l	 ; строка вверх на экране
	MOV		M, B	; вывод байта на экран
	MOV	h,d	 ; вторая плоскость
	POP		B	; прочитать два байта спрайта
	MOV		M, C	; вывод байта на экран
	MOV	h,a	; первая плоскость
	MOV		M, B	; вывод байта на экран
; строки 9 и 10
	INR	l	 ; строка вверх на экране

	POP		B	; прочитать два байта спрайта
	MOV		M, C	; вывод байта на экран
	MOV	h,d	 ; вторая плоскость
	MOV		M, B	; вывод байта на экран
	MOV	h,e	 ; третья плоскость
	POP		B	; прочитать два байта спрайта
	MOV		M, C	; вывод байта на экран
	INR	l	 ; строка вверх на экране
	MOV		M, B	; вывод байта на экран
	MOV	h,d	 ; вторая плоскость
	POP		B	; прочитать два байта спрайта
	MOV		M, C	; вывод байта на экран
	MOV	h,a	; первая плоскость
	MOV		M, B	; вывод байта на экран
; строки 11 и 12
	INR	l	 ; строка вверх на экране

	POP		B	; прочитать два байта спрайта
	MOV		M, C	; вывод байта на экран
	MOV	h,d	 ; вторая плоскость
	MOV		M, B	; вывод байта на экран
	MOV	h,e	 ; третья плоскость
	POP		B	; прочитать два байта спрайта
	MOV		M, C	; вывод байта на экран
	INR	l	 ; строка вверх на экране
	MOV		M, B	; вывод байта на экран
	MOV	h,d	 ; вторая плоскость
	POP		B	; прочитать два байта спрайта
	MOV		M, C	; вывод байта на экран
	MOV	h,a	; первая плоскость
	MOV		M, B	; вывод байта на экран
; строки 13 и 14
	INR	l	 ; строка вверх на экране

	POP		B	; прочитать два байта спрайта
	MOV		M, C	; вывод байта на экран
	MOV	h,d	 ; вторая плоскость
	MOV		M, B	; вывод байта на экран
	MOV	h,e	 ; третья плоскость
	POP		B	; прочитать два байта спрайта
	MOV		M, C	; вывод байта на экран
	INR	l	 ; строка вверх на экране
	MOV		M, B	; вывод байта на экран
	MOV	h,d	 ; вторая плоскость
	POP		B	; прочитать два байта спрайта
	MOV		M, C	; вывод байта на экран
	MOV	h,a	; первая плоскость
	MOV		M, B	; вывод байта на экран
; строки 15 и 16
	INR	l	 ; строка вверх на экране
	POP		B	; прочитать два байта спрайта
	MOV		M, C	; вывод байта на экран
	MOV	h,d	 ; вторая плоскость
	MOV		M, B	; вывод байта на экран
	MOV	h,e	 ; третья плоскость
	POP		B	; прочитать два байта спрайта
	MOV		M, C	; вывод байта на экран
	INR	l	 ; строка вверх на экране
	MOV		M, B	; вывод байта на экран
	MOV	h,d	 ; вторая плоскость
	POP		B	; прочитать два байта спрайта
	MOV		M, C	; вывод байта на экран
	MOV	h,a	; первая плоскость
	MOV		M, B	; вывод байта на экран
; строки 17 и 18
	INR	l	 ; строка вверх на экране
	POP		B	; прочитать два байта спрайта
	MOV		M, C	; вывод байта на экран
	MOV	h,d	 ; вторая плоскость
	MOV		M, B	; вывод байта на экран
	MOV	h,e	 ; третья плоскость
	POP		B	; прочитать два байта спрайта
	MOV		M, C	; вывод байта на экран
	INR	l	 ; строка вверх на экране
	MOV		M, B	; вывод байта на экран
	MOV	h,d	 ; вторая плоскость
	POP		B	; прочитать два байта спрайта
	MOV		M, C	; вывод байта на экран
	MOV	h,a	; первая плоскость
	MOV		M, B	; вывод байта на экран
; строки 19 и 20
	INR	l	 ; строка вверх на экране
	POP		B	; прочитать два байта спрайта
	MOV		M, C	; вывод байта на экран
	MOV	h,d	 ; вторая плоскость
	MOV		M, B	; вывод байта на экран
	MOV	h,e	 ; третья плоскость
	POP		B	; прочитать два байта спрайта
	MOV		M, C	; вывод байта на экран
	INR	l	 ; строка вверх на экране
	MOV		M, B	; вывод байта на экран
	MOV	h,d	 ; вторая плоскость
	POP		B	; прочитать два байта спрайта
	MOV		M, C	; вывод байта на экран
	MOV	h,a	; первая плоскость
	MOV		M, B	; вывод байта на экран
; строки 21 и 22
	INR	l	 ; строка вверх на экране
	POP		B	; прочитать два байта спрайта
	MOV		M, C	; вывод байта на экран
	MOV	h,d	 ; вторая плоскость
	MOV		M, B	; вывод байта на экран
	MOV	h,e	 ; третья плоскость
	POP		B	; прочитать два байта спрайта
	MOV		M, C	; вывод байта на экран
	INR	l	 ; строка вверх на экране
	MOV		M, B	; вывод байта на экран
	MOV	h,d	 ; вторая плоскость
	POP		B	; прочитать два байта спрайта
	MOV		M, C	; вывод байта на экран
	MOV	h,a	; первая плоскость
	MOV		M, B	; вывод байта на экран
; строки 23 и 24
	INR	l	 ; строка вверх на экране
	POP		B	; прочитать два байта спрайта
	MOV		M, C	; вывод байта на экран
	MOV	h,d	 ; вторая плоскость
	MOV		M, B	; вывод байта на экран
	MOV	h,e	 ; третья плоскость
	POP		B	; прочитать два байта спрайта
	MOV		M, C	; вывод байта на экран
	INR	l	 ; строка вверх на экране
	MOV		M, B	; вывод байта на экран
	MOV	h,d	 ; вторая плоскость
	POP		B	; прочитать два байта спрайта
	MOV		M, C	; вывод байта на экран
	MOV	h,a	; первая плоскость
	MOV		M, B	; вывод байта на экран
;
	INR	d
	INR	e
	INR	a
	MOV	h,a
spr2l:	MVI	l,0
;
spr2k:	MVI	a,3
	DCR	a
	STA	spr2k+1
	JNZ	spr2c6
;
	POP		B	; пустое чтение
;
spr2rd:	LXI	sp,0	; восстановление стека после вывода спрайта
			RET	; вЫход из подпрограммы вывода спрайта на экран
			.endfunction


;==========================================================
;Вывод квадратика 24x24 точки в сразу в три плоскости для статичных объектов
;стар вход HL - куда на экран выводить DE - адрес графики
;нов вход de - куда на экран выводить bc - адрес графики
DrawSprite_metamorpho1:
	MOV H,D
	MOV l,e
	MOV d,b
	MOV e,c

	MOV A,h ; сохраняем начало столбик X плоскость (1) куда выводим графику
	STA pozic_xP1
	MOV A,l
	STA pozic_y; сохраняем начало строки Y куда выводим графику
	MVI a,3
	STA PLAST

	LXI B, $2000
;====================== строка 1
fumbingo:
	LDAX D ; загружаем акумулятор А содержимым графики
	MOV M,A ; выводим в экран по адресу "HL" байт графики
	INX D ; DE=DE+1 увеличиваем адрес откуда брать графику
	DAD B ; адрес плоскости 2
	LDAX D
	MOV M,A
	INX D
	DAD B ; адрес плоскости 3
	LDAX D
	MOV M,A
	INX D

	DCR L ; ==================== строка 2
	LDA pozic_xP1
	MOV H,A ; адрес плоскости 1
	LDAX D
	MOV M,A
	INX D
	DAD B ; адрес плоскости 2
	LDAX D
	MOV M,A
	INX D
	DAD B ; адрес плоскости 3
	LDAX D
	MOV M,A
	INX D

	DCR L ; ==================== строка 3
	LDA pozic_xP1
	MOV H,A ; адрес плоскости 1
	LDAX D
	MOV M,A
	INX D
	DAD B ; адрес плоскости 2
	LDAX D
	MOV M,A
	INX D
	DAD B ; адрес плоскости 3
	LDAX D
	MOV M,A 	
	INX D

	DCR L ; ==================== строка 4
	LDA pozic_xP1
	MOV H,A ; адрес плоскости 1
	LDAX D
	MOV M,A
	INX D
	DAD B ; адрес плоскости 2
	LDAX D
	MOV M,A
	INX D
	DAD B ; адрес плоскости 3
	LDAX D
	MOV M,A
	INX D

	DCR L ; ==================== строка 5
	LDA pozic_xP1
	MOV H,A ; адрес плоскости 1
	LDAX D
	MOV M,A
	INX D
	DAD B ; адрес плоскости 2
	LDAX D
	MOV M,A
	INX D
	DAD B ; адрес плоскости 3
	LDAX D
	MOV M,A
	INX D

	DCR L ; ==================== строка 6
	LDA pozic_xP1
	MOV H,A ; адрес плоскости 1
	LDAX D
	MOV M,A
	INX D
	DAD B ; адрес плоскости 2
	LDAX D
	MOV M,A
	INX D
	DAD B ; адрес плоскости 3
	LDAX D
	MOV M,A
	INX D

	DCR L ; ==================== строка 7
	LDA pozic_xP1
	MOV H,A ; адрес плоскости 1
	LDAX D
	MOV M,A
	INX D
	DAD B ; адрес плоскости 2
	LDAX D
	MOV M,A
	INX D
	DAD B ; адрес плоскости 3
	LDAX D
	MOV M,A
	INX D

	DCR L ; ==================== строка 8
	LDA pozic_xP1
	MOV H,A ; адрес плоскости 1
	LDAX D
	MOV M,A
	INX D
	DAD B ; адрес плоскости 2
	LDAX D
	MOV M,A
	INX D
	DAD B ; адрес плоскости 3
	LDAX D
	MOV M,A
	INX D

	DCR L ; ==================== строка 9
	LDA pozic_xP1
	MOV H,A ; адрес плоскости 1
	LDAX D
	MOV M,A
	INX D
	DAD B ; адрес плоскости 2
	LDAX D
	MOV M,A
	INX D
	DAD B ; адрес плоскости 3
	LDAX D
	MOV M,A
	INX D

	DCR L ; ==================== строка 10
	LDA pozic_xP1
	MOV H,A ; адрес плоскости 1
	LDAX D
	MOV M,A
	INX D
	DAD B ; адрес плоскости 2
	LDAX D
	MOV M,A
	INX D
	DAD B ; адрес плоскости 3
	LDAX D
	MOV M,A
	INX D

	DCR L ; ==================== строка 11
	LDA pozic_xP1
	MOV H,A ; адрес плоскости 1
	LDAX D
	MOV M,A
	INX D
	DAD B ; адрес плоскости 2
	LDAX D
	MOV M,A
	INX D
	DAD B ; адрес плоскости 3
	LDAX D
	MOV M,A
	INX D

	DCR L ; ==================== строка 12
	LDA pozic_xP1
	MOV H,A ; адрес плоскости 1
	LDAX D
	MOV M,A
	INX D
	DAD B ; адрес плоскости 2
	LDAX D  	
	MOV M,A
	INX D
	DAD B ; адрес плоскости 3
	LDAX D
	MOV M,A
	INX D

	DCR L ; ==================== строка 13
	LDA pozic_xP1
	MOV H,A ; адрес плоскости 1
	LDAX D
	MOV M,A
	INX D
	DAD B ; адрес плоскости 2
	LDAX D
	MOV M,A
	INX D
	DAD B ; адрес плоскости 3
	LDAX D
	MOV M,A
	INX D

	DCR L ; ==================== строка 14
	LDA pozic_xP1
	MOV H,A ; адрес плоскости 1
	LDAX D
	MOV M,A
	INX D
	DAD B ; адрес плоскости 2
	LDAX D
	MOV M,A
	INX D
	DAD B ; адрес плоскости 3
	LDAX D
	MOV M,A
	INX D

	DCR L ; ==================== строка 15
	LDA pozic_xP1
	MOV H,A ; адрес плоскости 1
	LDAX D
	MOV M,A
	INX D
	DAD B ; адрес плоскости 2
	LDAX D
	MOV M,A
	INX D
	DAD B ; адрес плоскости 3
	LDAX D
	MOV M,A
	INX D

	DCR L ; ==================== строка 16
	LDA pozic_xP1
	MOV H,A ; адрес плоскости 1
	LDAX D
	MOV M,A
	INX D
	DAD B ; адрес плоскости 2
	LDAX D
	MOV M,A
	INX D
	DAD B ; адрес плоскости 3
	LDAX D
	MOV M,A
	INX D

	DCR L ; ==================== строка 17
	LDA pozic_xP1
	MOV H,A ; адрес плоскости 1
	LDAX D
	MOV M,A
	INX D
	DAD B ; адрес плоскости 2
	LDAX D
	MOV M,A
	INX D
	DAD B ; адрес плоскости 3
	LDAX D
	MOV M,A
	INX D

	DCR L ; ==================== строка 18
	LDA pozic_xP1
	MOV H,A ; адрес плоскости 1
	LDAX D
	MOV M,A
	INX D
	DAD B ; адрес плоскости 2
	LDAX D
	MOV M,A
	INX D
	DAD B ; адрес плоскости 3
	LDAX D
	MOV M,A
	INX D

	DCR L ; ==================== строка 19
	LDA pozic_xP1
	MOV H,A ; адрес плоскости 1
	LDAX D
	MOV M,A
	INX D
	DAD B ; адрес плоскости 2
	LDAX D
	MOV M,A
	INX D
	DAD B ; адрес плоскости 3
	LDAX D
	MOV M,A
	INX D

	DCR L ; ==================== строка 20
	LDA pozic_xP1
	MOV H,A ; адрес плоскости 1
	LDAX D
	MOV M,A
	INX D
	DAD B ; адрес плоскости 2
	LDAX D
	MOV M,A
	INX D
	DAD B ; адрес плоскости 3
	LDAX D
	MOV M,A
	INX D

	DCR L ; ==================== строка 21
	LDA pozic_xP1
	MOV H,A ; адрес плоскости 1
	LDAX D
	MOV M,A
	INX D
	DAD B ; адрес плоскости 2
	LDAX D
	MOV M,A
	INX D
	DAD B ; адрес плоскости 3
	LDAX D
	MOV M,A
	INX D

	DCR L ; ==================== строка 22
	LDA pozic_xP1
	MOV H,A ; адрес плоскости 1
	LDAX D
	MOV M,A
	INX D
	DAD B ; адрес плоскости 2
	LDAX D
	MOV M,A
	INX D
	DAD B ; адрес плоскости 3
	LDAX D
	MOV M,A
	INX D

	DCR L ; ==================== строка 23
	LDA pozic_xP1
	MOV H,A ; адрес плоскости 1
	LDAX D
	MOV M,A
	INX D
	DAD B ; адрес плоскости 2
	LDAX D
	MOV M,A
	INX D
	DAD B ; адрес плоскости 3
	LDAX D
	MOV M,A
	INX D

	DCR L ; ==================== строка 24
	LDA pozic_xP1
	MOV H,A ; адрес плоскости 1
	LDAX D
	MOV M,A
	INX D
	DAD B ; адрес плоскости 2
	LDAX D
	MOV M,A
	INX D
	DAD B ; адрес плоскости 3
	LDAX D
	MOV M,A
	INX D

	LDA PLAST ; счётчик столбиков (всего 3)
	DCR a
	jz rimikoq ; если все три столбика нарисованы выходим из подпрограммы
	
	STA PLAST
	; следующий столбец X
	LXI H,pozic_xP1
	INR M
	MOV H,M
	LDA pozic_y
	MOV L,A ; восстанавливаем Y
	JMP fumbingo
	
rimikoq:
;=============
;
	RET ;иначе - выйти из п/п вывода квадратиков
;
PLAST:	.byte	0
pozic_y:
	.byte	0
pozic_xP1
	.byte	0


;----------------------------------------------------------------
; draw a sprite (24x24 pixels)
; author: jerri
; method:
; in:
; BC	sprite data
; DE	screen address (x,y)

DrawSprite_Jerri_unrolled:
			LXI		H, 0
			DAD		SP
			SHLD	sprite_sp0_2 + 1
			MOV		H, B
			MOV		L, C
			MOV		C, M
			INX		H
			MOV		B, M
			INX		H
			SPHL
	
			;задаем Y в L
			MOV		L, E	;			(8)
			;задаем X в A
			MOV		A, D	;битплан1	(8)
			ADI		$20		;			(8)
			MOV		E, A	;битплан2	(8)
			ADI		$20		;битплан3	(8)
							;			(40) total


	MOV	h,d
;рисуем на первом плане
	MOV		M, C
	INR		H
	MOV		M, B
	INR		H
	POP		B
	MOV		M, C
;переход на второй битплан
	MOV	h,e
;рисуем на втором плане
	MOV		M, B
	INR		H
	POP		B
	MOV		M, C
	INR		H
	MOV		M, B
	POP		B
;переход на третий битплан
	MOV	h,a
;рисуем на третьем плане
	MOV		M, C
	INR		H
	MOV		M, B
	INR		H
	POP		B
	MOV		M, C
;переходим на следующую строку
	INR	l	
;возвращаемся на первый план	
	MOV	h,d
;повторяем цикл рисования
	MOV		M, B
	INR		H
	POP		B
	MOV		M, C
	INR		H
	MOV		M, B
	POP		B
;переход на второй битплан
	MOV	h,e
;рисуем на втором плане
	MOV		M, C
	INR		H
	MOV		M, B
	INR		H
	POP		B
	MOV		M, C
;переход на третий битплан
	MOV	h,a
;рисуем на третьем плане
	MOV		M, B
	INR		H
	POP		B
	MOV		M, C
	INR		H
	MOV		M, B
;выбираем следующую пару байтов для цикла рисования
	INR	l	
	POP		B
;	
	MOV	h,d
;рисуем на первом плане
	MOV		M, C
	INR		H
	MOV		M, B
	INR		H
	POP		B
	MOV		M, C
;переход на второй битплан
	MOV	h,e
;рисуем на втором плане
	MOV		M, B
	INR		H
	POP		B
	MOV		M, C
	INR		H
	MOV		M, B
	POP		B
;переход на третий битплан
	MOV	h,a
;рисуем на третьем плане
	MOV		M, C
	INR		H
	MOV		M, B
	INR		H
	POP		B
	MOV		M, C
;переходим на следующую строку
	INR	l	
;возвращаемся на первый план	
	MOV	h,d
;повторяем цикл рисования
	MOV		M, B
	INR		H
	POP		B
	MOV		M, C
	INR		H
	MOV		M, B
	POP		B
;переход на второй битплан
	MOV	h,e
;рисуем на втором плане
	MOV		M, C
	INR		H
	MOV		M, B
	INR		H
	POP		B
	MOV		M, C
;переход на третий битплан
	MOV	h,a
;рисуем на третьем плане
	MOV		M, B
	INR		H
	POP		B
	MOV		M, C
	INR		H
	MOV		M, B
;выбираем следующую пару байтов для цикла рисования
	INR	l	
	POP		B
;	
	MOV	h,d
;рисуем на первом плане
	MOV		M, C
	INR		H
	MOV		M, B
	INR		H
	POP		B
	MOV		M, C
;переход на второй битплан
	MOV	h,e
;рисуем на втором плане
	MOV		M, B
	INR		H
	POP		B
	MOV		M, C
	INR		H
	MOV		M, B
	POP		B
;переход на третий битплан
	MOV	h,a
;рисуем на третьем плане
	MOV		M, C
	INR		H
	MOV		M, B
	INR		H
	POP		B
	MOV		M, C
;переходим на следующую строку
	INR	l	
;возвращаемся на первый план	
	MOV	h,d
;повторяем цикл рисования
	MOV		M, B
	INR		H
	POP		B
	MOV		M, C
	INR		H
	MOV		M, B
	POP		B
;переход на второй битплан
	MOV	h,e
;рисуем на втором плане
	MOV		M, C
	INR		H
	MOV		M, B
	INR		H
	POP		B
	MOV		M, C
;переход на третий битплан
	MOV	h,a
;рисуем на третьем плане
	MOV		M, B
	INR		H
	POP		B
	MOV		M, C
	INR		H
	MOV		M, B
;выбираем следующую пару байтов для цикла рисования
	INR	l	
	POP		B
;	
	MOV	h,d
;рисуем на первом плане
	MOV		M, C
	INR		H
	MOV		M, B
	INR		H
	POP		B
	MOV		M, C
;переход на второй битплан
	MOV	h,e
;рисуем на втором плане
	MOV		M, B
	INR		H
	POP		B
	MOV		M, C
	INR		H
	MOV		M, B
	POP		B
;переход на третий битплан
	MOV	h,a
;рисуем на третьем плане
	MOV		M, C
	INR		H
	MOV		M, B
	INR		H
	POP		B
	MOV		M, C
;переходим на следующую строку
	INR	l	
;возвращаемся на первый план	
	MOV	h,d
;повторяем цикл рисования
	MOV		M, B
	INR		H
	POP		B
	MOV		M, C
	INR		H
	MOV		M, B
	POP		B
;переход на второй битплан
	MOV	h,e
;рисуем на втором плане
	MOV		M, C
	INR		H
	MOV		M, B
	INR		H
	POP		B
	MOV		M, C
;переход на третий битплан
	MOV	h,a
;рисуем на третьем плане
	MOV		M, B
	INR		H
	POP		B
	MOV		M, C
	INR		H
	MOV		M, B
;выбираем следующую пару байтов для цикла рисования
	INR	l	
	POP		B
;	
	MOV	h,d
;рисуем на первом плане
	MOV		M, C
	INR		H
	MOV		M, B
	INR		H
	POP		B
	MOV		M, C
;переход на второй битплан
	MOV	h,e
;рисуем на втором плане
	MOV		M, B
	INR		H
	POP		B
	MOV		M, C
	INR		H
	MOV		M, B
	POP		B
;переход на третий битплан
	MOV	h,a
;рисуем на третьем плане
	MOV		M, C
	INR		H
	MOV		M, B
	INR		H
	POP		B
	MOV		M, C
;переходим на следующую строку
	INR	l	
;возвращаемся на первый план	
	MOV	h,d
;повторяем цикл рисования
	MOV		M, B
	INR		H
	POP		B
	MOV		M, C
	INR		H
	MOV		M, B
	POP		B
;переход на второй битплан
	MOV	h,e
;рисуем на втором плане
	MOV		M, C
	INR		H
	MOV		M, B
	INR		H
	POP		B
	MOV		M, C
;переход на третий битплан
	MOV	h,a
;рисуем на третьем плане
	MOV		M, B
	INR		H
	POP		B
	MOV		M, C
	INR		H
	MOV		M, B
;выбираем следующую пару байтов для цикла рисования
	INR	l	
	POP		B
;	
	MOV	h,d
;рисуем на первом плане
	MOV		M, C
	INR		H
	MOV		M, B
	INR		H
	POP		B
	MOV		M, C
;переход на второй битплан
	MOV	h,e
;рисуем на втором плане
	MOV		M, B
	INR		H
	POP		B
	MOV		M, C
	INR		H
	MOV		M, B
	POP		B
;переход на третий битплан
	MOV	h,a
;рисуем на третьем плане
	MOV		M, C
	INR		H
	MOV		M, B
	INR		H
	POP		B
	MOV		M, C
;переходим на следующую строку
	INR	l	
;возвращаемся на первый план	
	MOV	h,d
;повторяем цикл рисования
	MOV		M, B
	INR		H
	POP		B
	MOV		M, C
	INR		H
	MOV		M, B
	POP		B
;переход на второй битплан
	MOV	h,e
;рисуем на втором плане
	MOV		M, C
	INR		H
	MOV		M, B
	INR		H
	POP		B
	MOV		M, C
;переход на третий битплан
	MOV	h,a
;рисуем на третьем плане
	MOV		M, B
	INR		H
	POP		B
	MOV		M, C
	INR		H
	MOV		M, B
;выбираем следующую пару байтов для цикла рисования
	INR	l	
	POP		B
;	
	MOV	h,d
;рисуем на первом плане
	MOV		M, C
	INR		H
	MOV		M, B
	INR		H
	POP		B
	MOV		M, C
;переход на второй битплан
	MOV	h,e
;рисуем на втором плане
	MOV		M, B
	INR		H
	POP		B
	MOV		M, C
	INR		H
	MOV		M, B
	POP		B
;переход на третий битплан
	MOV	h,a
;рисуем на третьем плане
	MOV		M, C
	INR		H
	MOV		M, B
	INR		H
	POP		B
	MOV		M, C
;переходим на следующую строку
	INR	l	
;возвращаемся на первый план	
	MOV	h,d
;повторяем цикл рисования
	MOV		M, B
	INR		H
	POP		B
	MOV		M, C
	INR		H
	MOV		M, B
	POP		B
;переход на второй битплан
	MOV	h,e
;рисуем на втором плане
	MOV		M, C
	INR		H
	MOV		M, B
	INR		H
	POP		B
	MOV		M, C
;переход на третий битплан
	MOV	h,a
;рисуем на третьем плане
	MOV		M, B
	INR		H
	POP		B
	MOV		M, C
	INR		H
	MOV		M, B
;выбираем следующую пару байтов для цикла рисования
	INR	l	
	POP		B
;	
	MOV	h,d
;рисуем на первом плане
	MOV		M, C
	INR		H
	MOV		M, B
	INR		H
	POP		B
	MOV		M, C
;переход на второй битплан
	MOV	h,e
;рисуем на втором плане
	MOV		M, B
	INR		H
	POP		B
	MOV		M, C
	INR		H
	MOV		M, B
	POP		B
;переход на третий битплан
	MOV	h,a
;рисуем на третьем плане
	MOV		M, C
	INR		H
	MOV		M, B
	INR		H
	POP		B
	MOV		M, C
;переходим на следующую строку
	INR	l	
;возвращаемся на первый план	
	MOV	h,d
;повторяем цикл рисования
	MOV		M, B
	INR		H
	POP		B
	MOV		M, C
	INR		H
	MOV		M, B
	POP		B
;переход на второй битплан
	MOV	h,e
;рисуем на втором плане
	MOV		M, C
	INR		H
	MOV		M, B
	INR		H
	POP		B
	MOV		M, C
;переход на третий битплан
	MOV	h,a
;рисуем на третьем плане
	MOV		M, B
	INR		H
	POP		B
	MOV		M, C
	INR		H
	MOV		M, B
;выбираем следующую пару байтов для цикла рисования
	INR	l	
	POP		B
;	
	MOV	h,d
;рисуем на первом плане
	MOV		M, C
	INR		H
	MOV		M, B
	INR		H
	POP		B
	MOV		M, C
;переход на второй битплан
	MOV	h,e
;рисуем на втором плане
	MOV		M, B
	INR		H
	POP		B
	MOV		M, C
	INR		H
	MOV		M, B
	POP		B
;переход на третий битплан
	MOV	h,a
;рисуем на третьем плане
	MOV		M, C
	INR		H
	MOV		M, B
	INR		H
	POP		B
	MOV		M, C
;переходим на следующую строку
	INR	l	
;возвращаемся на первый план	
	MOV	h,d
;повторяем цикл рисования
	MOV		M, B
	INR		H
	POP		B
	MOV		M, C
	INR		H
	MOV		M, B
	POP		B
;переход на второй битплан
	MOV	h,e
;рисуем на втором плане
	MOV		M, C
	INR		H
	MOV		M, B
	INR		H
	POP		B
	MOV		M, C
;переход на третий битплан
	MOV	h,a
;рисуем на третьем плане
	MOV		M, B
	INR		H
	POP		B
	MOV		M, C
	INR		H
	MOV		M, B
;выбираем следующую пару байтов для цикла рисования
	INR	l	
	POP		B
;	
	MOV	h,d
;рисуем на первом плане
	MOV		M, C
	INR		H
	MOV		M, B
	INR		H
	POP		B
	MOV		M, C
;переход на второй битплан
	MOV	h,e
;рисуем на втором плане
	MOV		M, B
	INR		H
	POP		B
	MOV		M, C
	INR		H
	MOV		M, B
	POP		B
;переход на третий битплан
	MOV	h,a
;рисуем на третьем плане
	MOV		M, C
	INR		H
	MOV		M, B
	INR		H
	POP		B
	MOV		M, C
;переходим на следующую строку
	INR	l	
;возвращаемся на первый план	
	MOV	h,d
;повторяем цикл рисования
	MOV		M, B
	INR		H
	POP		B
	MOV		M, C
	INR		H
	MOV		M, B
	POP		B
;переход на второй битплан
	MOV	h,e
;рисуем на втором плане
	MOV		M, C
	INR		H
	MOV		M, B
	INR		H
	POP		B
	MOV		M, C
;переход на третий битплан
	MOV	h,a
;рисуем на третьем плане
	MOV		M, B
	INR		H
	POP		B
	MOV		M, C
	INR		H
	MOV		M, B
;выбираем следующую пару байтов для цикла рисования
	INR	l	
	POP		B
;	
	MOV	h,d
;рисуем на первом плане
	MOV		M, C
	INR		H
	MOV		M, B
	INR		H
	POP		B
	MOV		M, C
;переход на второй битплан
	MOV	h,e
;рисуем на втором плане
	MOV		M, B
	INR		H
	POP		B
	MOV		M, C
	INR		H
	MOV		M, B
	POP		B
;переход на третий битплан
	MOV	h,a
;рисуем на третьем плане
	MOV		M, C
	INR		H
	MOV		M, B
	INR		H
	POP		B
	MOV		M, C
;переходим на следующую строку
	INR	l	
;возвращаемся на первый план	
	MOV	h,d
;повторяем цикл рисования
	MOV		M, B
	INR		H
	POP		B
	MOV		M, C
	INR		H
	MOV		M, B
	POP		B
;переход на второй битплан
	MOV	h,e
;рисуем на втором плане
	MOV		M, C
	INR		H
	MOV		M, B
	INR		H
	POP		B
	MOV		M, C
;переход на третий битплан
	MOV	h,a
;рисуем на третьем плане
	MOV		M, B
	INR		H
	POP		B
	MOV		M, C
	INR		H
	MOV		M, B
;выбираем следующую пару байтов для цикла рисования
	INR	l	
	POP		B
;	
	MOV	h,d
;рисуем на первом плане
	MOV		M, C
	INR		H
	MOV		M, B
	INR		H
	POP		B
	MOV		M, C
;переход на второй битплан
	MOV	h,e
;рисуем на втором плане
	MOV		M, B
	INR		H
	POP		B
	MOV		M, C
	INR		H
	MOV		M, B
	POP		B
;переход на третий битплан
	MOV	h,a
;рисуем на третьем плане
	MOV		M, C
	INR		H
	MOV		M, B
	INR		H
	POP		B
	MOV		M, C
;переходим на следующую строку
	INR	l	
;возвращаемся на первый план	
	MOV	h,d
;повторяем цикл рисования
	MOV		M, B
	INR		H
	POP		B
	MOV		M, C
	INR		H
	MOV		M, B
	POP		B
;переход на второй битплан
	MOV	h,e
;рисуем на втором плане
	MOV		M, C
	INR		H
	MOV		M, B
	INR		H
	POP		B
	MOV		M, C
;переход на третий битплан
	MOV	h,a
;рисуем на третьем плане
	MOV		M, B
	INR		H
	POP		B
	MOV		M, C
	INR		H
	MOV		M, B
;выбираем следующую пару байтов для цикла рисования
	INR	l	
	POP		B
;	
sprite_sp0_2:
	LXI	sp,$3131
	RET

;----------------------------------------------------------------
; draw a sprite (24x24 pixels)
; author ivagor
; method: zig-zag, unrolled

; in:
; BC	sprite data
; DE	screen address (x,y)

			.macro DRAW_EVEN_LINE_IVAGOR()
			POP B
			MOV M,C
			DCR H
			MOV M,B
			DCR H
			POP B
			MOV M,C
			MOV H,E
			MOV M,B
			INR H
			POP B
			MOV M,C
			INR H
			MOV M,B
			MOV h,a
			POP B
			MOV M,C
			INR H
			MOV M,B
			INR H
			POP B
			MOV M,C
			DCR L
			.endmacro

			
			.macro DRAW_ODD_LINE_IVAGOR()
			MOV M,B
			DCR H
			POP B
			MOV M,C
			DCR H
			MOV M,B
			MOV H,E
			POP B
			MOV M,C
			INR H
			MOV M,B
			INR H
			POP B
			MOV M,C
			MOV H,D
			MOV M,B
			INR H
			POP B
			MOV M,C
			INR H
			MOV M,B
			DCR L
			.endmacro

			.function DS_ivagor
DrawSprite_ivagor:
			; store SP
			LXI		H,0				; (12)
			DAD		SP				; (12)
			SHLD	@restoreSP+1	; (20)
			; HL = BC
			MOV		H, B			; (8)
			MOV		L, C			; (8)
			; BC = (HL), HL +=2
			MOV		C, M			; (8)
			INX		H				; (8)
			MOV		B, M			; (8)
			INX		H				; (8)
			; SP = HL
			SPHL					; (8)
			
			; HL = DE
			XCHG					; (4)
			; D = screen X
			MOV		D, H			; (8)
			; E = second screen X
			MVI		A, $20			; (8)
			ADD		D				; (4)
			MOV		E, A			; (8)
			; A = third screen X
			MVI		A, $20			; (8)
			ADD		E				; (4)
			; X += 2
			INR		H				; (8)
			INR		H				; (8)
									; (160)
; screen format
; DRAW_EVEN_LINE_IVAGOR
; 1st screen buff : 3 <- 2 <- (1)
; 2nd screen buff : (4) -> 5 -> 6
; 3rd screen buff : (7) -> 8 -> 9
; y--
; DRAW_ODD_LINE_IVAGOR
; 3nd screen buff : 12 <- 11 <- 10
; 2nd screen buff : (13) -> 14 -> 15
; 1st screen buff : (16) -> 17 -> 18
; y--
; repeat

; HL = screen address (X + 2, Y)
; SP = sprite data + 2
; D - 1st screen buff X
; E - 2nd screen buff X
; A - 3rd screen buff X

			; first line
			MOV M,C
			DCR H
			MOV M,B
			DCR H
			POP B
			MOV M,C
			MOV H,E
			MOV M,B
			INR H
			POP B
			MOV M,C
			INR H
			MOV M,B
			MOV h,a
			POP B
			MOV M,C
			INR H
			MOV M,B
			INR H
			POP B
			MOV M,C
			DCR L

			DRAW_ODD_LINE_IVAGOR()
			DRAW_EVEN_LINE_IVAGOR()
			DRAW_ODD_LINE_IVAGOR()
			DRAW_EVEN_LINE_IVAGOR()
			DRAW_ODD_LINE_IVAGOR()
			DRAW_EVEN_LINE_IVAGOR()
			DRAW_ODD_LINE_IVAGOR()	
			DRAW_EVEN_LINE_IVAGOR()
			DRAW_ODD_LINE_IVAGOR()
			DRAW_EVEN_LINE_IVAGOR()
			DRAW_ODD_LINE_IVAGOR()
			DRAW_EVEN_LINE_IVAGOR()
			DRAW_ODD_LINE_IVAGOR()	
			DRAW_EVEN_LINE_IVAGOR()
			DRAW_ODD_LINE_IVAGOR()
			DRAW_EVEN_LINE_IVAGOR()
			DRAW_ODD_LINE_IVAGOR()
			DRAW_EVEN_LINE_IVAGOR()
			DRAW_ODD_LINE_IVAGOR()
			DRAW_EVEN_LINE_IVAGOR()
			DRAW_ODD_LINE_IVAGOR()
			DRAW_EVEN_LINE_IVAGOR()
			; 24th line
			MOV M,B
			DCR H
			POP B
			MOV M,C
			DCR H
			MOV M,B
			MOV H,E
			POP B
			MOV M,C
			INR H
			MOV M,B
			INR H
			POP B
			MOV M,C
			MOV H,D
			MOV M,B
			INR H
			POP B
			MOV M,C
			INR H
			MOV M,B

@restoreSP:	LXI		SP, TEMP_ADDR	; restore SP (12)
			RET
			.endfunction

;----------------------------------------------------------------
; draw a sprite (24x24 pixels)
; author: parallelno
; method: zig-zag
; in:
; BC	sprite data
; DE	screen address (x,y)
			.macro DRAW_EVEN_LINE_PARALLELNO2(_moveOneLineDown = true)
			POP B		; 1st screen space 
			MOV M,C
			INR H
			MOV M,B
			INR H
			POP B
			MOV M,C
			MOV H,E		; 2nd screen space 
			MOV M,B
			DCR H
			POP B
			MOV M,C
			DCR H
			MOV M,B
			MOV H,A		; 3rd screen space 
			POP B
			MOV M,C
			DCR H
			MOV M,B
			DCR H
			POP B
			MOV M,C
			.if _moveOneLineDown == true
			DCR	L
			.endif
			.endmacro

			.macro DRAW_ODD_LINE_PARALLELNO2(_moveOneLineDown = true)
			MOV M,B		; 3rd screen space 
			INR H
			POP B
			MOV M,C
			INR H
			MOV M,B
			MOV H,E		; 2nd screen space 
			POP B
			MOV M,C
			DCR H
			MOV M,B
			DCR H
			POP B
			MOV M,C
			MOV H,D		; 1st screen space 
			MOV M,B
			DCR H
			POP B
			MOV M,C
			DCR H
			MOV M,B
			.if _moveOneLineDown == true
			DCR	L
			.endif			
			.endmacro

			.function DS_parallelno2
DrawSprite_parallelno2:
			; store SP
			LXI		H, 0			; (12)
			DAD		SP				; (12)
			SHLD	@restoreSP + 1	; (20)
			; SP = BC
			MOV		H, B			; (8)
			MOV		L, C			; (8)
			SPHL					; (8)
			; D, E, A are initial X for 
			; the 1st, the 2nd, the 3rd screen buffs
			XCHG					; (4)
			MVI		A, 2			; (8)
			ADD 	H				; (4)
			MOV 	D, A			; (8)
			ADI     $20             ; (8)
			MOV     E, A            ; (8)
			ADI 	$20				; (8)
									; (108) total
; screen format
; DRAW_EVEN_LINE_PARALLELNO2()
; 1st screen buff : 1 -> 2 -> 3
; 2nd screen buff : 4 <- 5 <- (6)
; 3rd screen buff : 7 <- 8 <- (9)
; y--
; DRAW_ODD_LINE_PARALLELNO2()
; 3nd screen buff : 12 -> 11 -> 10
; 2nd screen buff : 13 <- 14 <- (15)
; 1st screen buff : 18 <- 17 <- (16)
; y--
; repeat

; HL - 1st screen buff XY
; SP - sprite data
; D - 1st screen buff X + 2
; E - 2nd screen buff X + 2
; A - 3rd screen buff X + 2

			DRAW_EVEN_LINE_PARALLELNO2()	
			DRAW_ODD_LINE_PARALLELNO2()	
			DRAW_EVEN_LINE_PARALLELNO2()	
			DRAW_ODD_LINE_PARALLELNO2()	
			DRAW_EVEN_LINE_PARALLELNO2()	
			DRAW_ODD_LINE_PARALLELNO2()	
			DRAW_EVEN_LINE_PARALLELNO2()	
			DRAW_ODD_LINE_PARALLELNO2()	
			DRAW_EVEN_LINE_PARALLELNO2()	
			DRAW_ODD_LINE_PARALLELNO2()	
			DRAW_EVEN_LINE_PARALLELNO2()	
			DRAW_ODD_LINE_PARALLELNO2()	
			DRAW_EVEN_LINE_PARALLELNO2()	
			DRAW_ODD_LINE_PARALLELNO2()	
			DRAW_EVEN_LINE_PARALLELNO2()	
			DRAW_ODD_LINE_PARALLELNO2()	
			DRAW_EVEN_LINE_PARALLELNO2()	
			DRAW_ODD_LINE_PARALLELNO2()	
			DRAW_EVEN_LINE_PARALLELNO2()	
			DRAW_ODD_LINE_PARALLELNO2()	
			DRAW_EVEN_LINE_PARALLELNO2()	
			DRAW_ODD_LINE_PARALLELNO2()	
			DRAW_EVEN_LINE_PARALLELNO2()	
			DRAW_ODD_LINE_PARALLELNO2( false)

@restoreSP:	LXI		SP, TEMP_ADDR	; restore SP (12)
			RET
			.endfunction


.include "sprites.asm"

;================================================================
			.END