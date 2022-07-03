;-------------------------------------------------
;|                                               |
;|     Sprite Rendering Speed Test		         |
;|     											 |
;|     Original ver. 2020						 |
;|     by KTSerg aka Sergey Cherkozianov		 |
;-------------------------------------------------

; MACROS
#DEFINE RRC4					RRC \ RRC \ RRC \ RRC

; prefixes
; ADDR - address
; INT - interruption
; SCR - screen
; MEM - memory
; LEN - length
; SEC - seconds
; RES - result

; global
#DEFINE PORT0_OUT_OUT			88H

#DEFINE	JMP_OPCODE				0C3H

#DEFINE	RESTART_ADDR			0000H
#DEFINE	INT_ADDR				0038H
#DEFINE	STACK_ADDR				8000H
#DEFINE TEMP_ADDR				0000H

#DEFINE	SCR_BUFF_LEN			2000H
#DEFINE	SCR_MEM_LEN				8000H

#DEFINE TEMP_WORD				0000H
#DEFINE	INT_TICKS_PER_SEC		50

; local
#DEFINE	TIMER_SEC				10
#DEFINE	TIMER_COUNTER_ADDR		9F10H
#DEFINE	TIMER_STOP_FLAG_ADDR	9F18H
#DEFINE	TIMER_STOP_FLAG_INIT	0FFH

#DEFINE	SPRITE_COUNTER_ADDR		9FF4H
#DEFINE	SPRITE_SCR_ADDR			8EE0H
#DEFINE	STACK_TEMP_ADDR			9F80H
#DEFINE	RES_SCR_ADDR_0			80D0H
#DEFINE	RES_SCR_ADDR_1			80B0H
#DEFINE	RES_SCR_ADDR_2			8080H
#DEFINE	RES_SCR_ADDR_3			8060H
#DEFINE	RES_SCR_ADDR_4			8030H
#DEFINE	RES_SCR_ADDR_5			8010H

#DEFINE	SPRITE_SCR_ADDR_		8F00H
#DEFINE	SPRITE_SCR_ADDR_0 		SPRITE_SCR_ADDR_ + 0D0H
#DEFINE	SPRITE_SCR_ADDR_1 		SPRITE_SCR_ADDR_ + 0B0H
#DEFINE	SPRITE_SCR_ADDR_2 		SPRITE_SCR_ADDR_ + 80H
#DEFINE	SPRITE_SCR_ADDR_3 		SPRITE_SCR_ADDR_ + 60H
#DEFINE	SPRITE_SCR_ADDR_4 		SPRITE_SCR_ADDR_ + 30H + 23
#DEFINE	SPRITE_SCR_ADDR_5 		SPRITE_SCR_ADDR_ + 10H + 23

			.org	$0100
Start:
			DI
			; dismount a quasi-disk
			XRA		A
			out		10H
			; set entry points of a restart, and an interruption
			MVI		A, JMP_OPCODE
			STA		RESTART_ADDR
			STA		INT_ADDR
			LXI		H, Start
			SHLD 	RESTART_ADDR + 1
			LXI		H, Interruption2
			SHLD	INT_ADDR + 1
			; stack init
			LXI		SP, STACK_ADDR

			; clear the screen
			LXI		B, 0000H
			LXI     D, SCR_MEM_LEN / 32
			CALL	MemReset

			EI
			HLT
			CALL	SetPalette

;----------------------------------------------------------------
; The list of the sprite rendering subroutines to measure the render speed.
; The result is an amount of sprites rendered during TIMER_SEC seconds

			CALL	InitTimer
			LXI		H, SPRITE_SCR_ADDR_4
			SHLD	testDrawScrAddr
			LXI		H, DrawSprite_ivagor
			SHLD	testDrawSub
			LXI		H, RES_SCR_ADDR_4
			SHLD	testDrawResScrAddr
			CALL	TestDraw

			LXI		H, SPRITE_SCR_ADDR_5
			SHLD	testDrawScrAddr
			LXI		H, DrawSprite_parallelno
			SHLD	testDrawSub
			LXI		H, RES_SCR_ADDR_5
			SHLD	testDrawResScrAddr
			CALL	InitTimer
			CALL	TestDraw			

			LXI		H, SPRITE_SCR_ADDR_0
			SHLD	testDrawScrAddr
			LXI		H, DrawSprite_Jerri_orig
			SHLD	testDrawSub
			LXI		H, RES_SCR_ADDR_0
			SHLD	testDrawResScrAddr
			CALL	InitTimer
			CALL	TestDraw

			LXI		H, SPRITE_SCR_ADDR_1
			SHLD	testDrawScrAddr
			LXI		H, DrawSprite_Jerri_unrolled
			SHLD	testDrawSub
			LXI		H, RES_SCR_ADDR_1
			SHLD	testDrawResScrAddr
			CALL	InitTimer
			CALL	TestDraw

			LXI		H, SPRITE_SCR_ADDR_2
			SHLD	testDrawScrAddr
			LXI		H, DrawSprite_Serg_orig
			SHLD	testDrawSub
			LXI		H, RES_SCR_ADDR_2
			SHLD	testDrawResScrAddr
			CALL	InitTimer
			CALL	TestDraw

			LXI		H, SPRITE_SCR_ADDR_3
			SHLD	testDrawScrAddr
			LXI		H, DrawSprite_Serg_unrolled
			SHLD	testDrawSub
			LXI		H, RES_SCR_ADDR_3
			SHLD	testDrawResScrAddr
			CALL	InitTimer
			CALL	TestDraw	

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
				
TestDraw:	.MODULE TestDraw
			LHLD	SPRITE_COUNTER_ADDR

_loop:		LXI		B, spriteData01
testDrawScrAddr:.EQU $+1
			LXI		D, TEMP_ADDR
			PUSH	H
testDrawSub:.EQU	$+1
			CALL	TEMP_ADDR
			POP		H
			INX		H
			LDA		TIMER_STOP_FLAG_ADDR
			ORA		A
			JNZ		_loop
			SHLD	SPRITE_COUNTER_ADDR

testDrawResScrAddr: .EQU $+1
			LXI		D, TEMP_ADDR
			CALL	DrawResult
			RET

;----------------------------------------------------------------
; Draw a Test Result (HEX)
; in: DE	result screen address
; use: A, HL, DE,

DrawResult:
			LDA		SPRITE_COUNTER_ADDR + 1
			RRC4
			CALL	GetSpriteAddr
			PUSH	D
			CALL	DrawSprite_Jerri_orig
			POP		D
			INR		D
			INR		D
			INR		D

			LDA		SPRITE_COUNTER_ADDR + 1
			CALL	GetSpriteAddr
			PUSH	D
			CALL	DrawSprite_Jerri_orig
			POP		D
			INR		D
			INR		D
			INR		D

			LDA		SPRITE_COUNTER_ADDR
			RRC4
			CALL	GetSpriteAddr
			PUSH	D
			CALL	DrawSprite_Jerri_orig
			POP		D
			INR		D
			INR		D
			INR		D

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
			ANI		0FH				; (8)
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
; The interruption sub with a stack protection.
; It supports stack manipulations in the main program.
;
; When stack manupulations take place BC has to keep stack data that
; is corrupted when an interruption happens and PUSH
			.MODULE Int2
Interruption2:
			; restore the Stack
			XTHL
			SHLD	_return + 1
			POP		H
			SHLD	_restoreHL + 1
			LXI		H, 0
			DAD		SP
			SHLD	_restoreSP + 1
			PUSH	B
			
			LXI		SP, STACK_TEMP_ADDR
			PUSH	PSW
			PUSH	B
			PUSH	D

			; common interruption logic
			LHLD	TIMER_COUNTER_ADDR
			DCX		H
			SHLD	TIMER_COUNTER_ADDR
			MOV		A, H
			ORA		L
			JNZ		_doNotStopTimer

			STA	TIMER_STOP_FLAG_ADDR	; запись 00 в фдаг остановки вывода спрайтов

_doNotStopTimer:
			POP		D
			POP		B
			POP		PSW
_restoreHL:	LXI		H, TEMP_ADDR
_restoreSP:	LXI		SP, TEMP_ADDR
			EI
_return:	JMP		TEMP_ADDR


;----------------------------------------------------------------
; The common interruption sub
;
			.MODULE Interruption1
Interruption1:
			PUSH	PSW
			PUSH	B
			PUSH	D
			PUSH	H

			; common interruption logic
			LHLD	TIMER_COUNTER_ADDR
			DCX		H
			SHLD	TIMER_COUNTER_ADDR
			MOV		A, H
			ORA		L
			JNZ	_doNotStopTimer
			; set the flag to 0
			STA	TIMER_STOP_FLAG_ADDR

_doNotStopTimer:
			POP		H
			POP		D
			POP		B
			POP		PSW
			EI
			RET

;========================================================
;вывод спрайта в системе битпланов Вектор 06
;ширина спрайта -24
;на входе
;bc адрес спрайта
;de aдрес на экране 
;E-Y D-X 
			.MODULE DS_Jerri_orig
DrawSprite_Jerri_orig:
			; store SP
			LXI		H, 0
			DAD		SP
			SHLD	_restoreSP+1
			
			MVI		A, 12
			MOV		H, B
			MOV		L, C
			MOV		C, M
			INX		H
			MOV		B, M
			INX		H
			SPHL
		;задаем Y в L
			MOV		L, E
		;задаем высоту спрайта в E
			MOV		E, A
		;задаем X в A
			MOV		A, D
		;переход между битпланами
			MVI		D, 20H
_loop:
			MOV		H, A
		;рисуем на первом плане
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
		;выбираем следующую пару байтов для цикла рисования
			POP		B

		;возвращаемся на первый план	
			SUI	$40
			MOV	h,a
		;переходим на следующую строку
			INR	l	
		;проверяем на завершение цикла 
			DCR	e
			JNZ	_loop	
_restoreSP:
			LXI		SP, TEMP_ADDR
			RET
;
;========================================
; выводим по 4 строки спрайта
;на входе
;bc адрес спрайта
;de aдрес на экране 
;E-Y D-X 
;=================================================================
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
	.DB	$80,$88		; адрес на экране для вывода спрайта

;----------------------------------------------------------------
; draw a sprite (24x24 pixels)
; author: Serg
; description: выводим по колонке, слева на право

; in:
; BC	sprite data
; DE	screen address (x,y)
			.MODULE DrawSprite_Serg_unrolled
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

	LXI B,2000h
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
PLAST:	.DB	0
pozic_y:
	.DB	0
pozic_xP1
	.DB	0


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
		.MODULE DS_ivagor
DrawSprite_ivagor:
		; store SP
		LXI		H,0				; (12)
		DAD		SP				; (12)
		SHLD	_restoreSP+1	; (20)
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
		MVI		A, 20h			; (8)
		ADD		D
		MOV		E, A
		; A = third screen X
		MVI		A, 20h			; (8)
		ADD		E				; (4)
		; X += 2
		INR		H				; (8)
		INR		H				; (8)

; HL = screen address (X + 2, Y)
; SP = data + 2

#DEFINE 	DRAW_BACKWARD_LINE_IVAGOR	\
#DEFCONT \	POP B\ MOV M,C\ DCR H\ MOV M,B\ DCR H\ POP B\ MOV M,C
#DEFCONT \	MOV H,E\ MOV M,B\ INR H\ POP B\ MOV M,C\ INR H\ MOV M,B
#DEFCONT \	MOV h,a\ POP B\ MOV M,C\ INR H\ MOV M,B\ INR H\ POP B\ MOV M,C
#DEFCONT \	DCR L

#DEFINE 	DRAW_FORWARD_LINE_IVAGOR	\
#DEFCONT \	MOV M,B\ DCR H\ POP B\ MOV M,C\ DCR H\ MOV M,B
#DEFCONT \	MOV H,E\ POP B\ MOV M,C\ INR H\ MOV M,B\ INR H\ POP B\ MOV M,C
#DEFCONT \	MOV H,D\ MOV M,B\ INR H\ POP B\ MOV M,C\ INR H\ MOV M,B
#DEFCONT \	DCR L

			; first line
			MOV M,C\ DCR H\ MOV M,B\ DCR H\ POP B\ MOV M,C
			MOV H,E\ MOV M,B\ INR H\ POP B\ MOV M,C\ INR H\ MOV M,B
			MOV h,a\ POP B\ MOV M,C\ INR H\ MOV M,B\ INR H\ POP B\ MOV M,C
			DCR L

			DRAW_FORWARD_LINE_IVAGOR
			DRAW_BACKWARD_LINE_IVAGOR
			DRAW_FORWARD_LINE_IVAGOR
			DRAW_BACKWARD_LINE_IVAGOR
			DRAW_FORWARD_LINE_IVAGOR
			DRAW_BACKWARD_LINE_IVAGOR
			DRAW_FORWARD_LINE_IVAGOR	
			DRAW_BACKWARD_LINE_IVAGOR
			DRAW_FORWARD_LINE_IVAGOR
			DRAW_BACKWARD_LINE_IVAGOR
			DRAW_FORWARD_LINE_IVAGOR
			DRAW_BACKWARD_LINE_IVAGOR
			DRAW_FORWARD_LINE_IVAGOR	
			DRAW_BACKWARD_LINE_IVAGOR
			DRAW_FORWARD_LINE_IVAGOR
			DRAW_BACKWARD_LINE_IVAGOR
			DRAW_FORWARD_LINE_IVAGOR
			DRAW_BACKWARD_LINE_IVAGOR
			DRAW_FORWARD_LINE_IVAGOR
			DRAW_BACKWARD_LINE_IVAGOR
			DRAW_FORWARD_LINE_IVAGOR
			DRAW_BACKWARD_LINE_IVAGOR
			; 24th line
			MOV M,B\ DCR H\ POP B\ MOV M,C\ DCR H\ MOV M,B
			MOV H,E\ POP B\ MOV M,C\ INR H\ MOV M,B\ INR H\ POP B\ MOV M,C
			MOV H,D\ MOV M,B\ INR H\ POP B\ MOV M,C\ INR H\ MOV M,B

_restoreSP:	LXI		SP, TEMP_ADDR	; restore SP (12)
			RET

;----------------------------------------------------------------
; draw a sprite (24x24 pixels)
; author: parallelno
; method: zig-zag
; in:
; BC	sprite data
; DE	screen address (x,y)

			.MODULE DS_parallelno
DrawSprite_parallelno:
			; store SP
			LXI		H, 0			; (12)
			DAD		SP				; (12)
			SHLD	_restoreSP + 1	; (20)
			; SP = BC
			MOV		H, B			; (8)
			MOV		L, C			; (8)
			SPHL					; (8)
			; calculate a line start X for 1st, 2nd, 3rd screen buffs
			XCHG					; (4)
			MOV		D, H			; (8)
			MVI		A, 20h			; (8)
			ADD 	D				; (4)
			MOV 	E, A			; (8)
			ADI 	20H				; (8)

			INR 	D
			INR 	D

			; HL - screen address
			; SP - sprite data
			; D - 1st screen buff X + 2
			; E - 2nd screen buff X
			; A - 3rd screen buff X			

; screen format
; DRAW_FORWARD_LINE_PARALLELNO1
; 1st screen buff : 1 -> 2 -> 3
; 2nd screen buff : 4 -> 5 -> 6
; 3rd screen buff : 7 -> 8 -> 9
; y--
; DRAW_BACKWARD_LINE_PARALLELNO1
; 1st screen buff : 12 <- 11 <- 10
; 2nd screen buff : 13 -> 14 -> 15
; 3rd screen buff : 18 <- 17 <- 16
; y--
; repeat

#DEFINE 	DRAW_FORWARD_LINE_PARALLELNO1	\
#DEFCONT \	POP B\ MOV M,C\ INR H\ MOV M,B\ INR H\ POP B\ MOV M,C
#DEFCONT \	MOV H,E\ MOV M,B\ INR H\ POP B\ MOV M,C\ INR H\ MOV M,B
#DEFCONT \	MOV H,A\ POP B\ MOV M,C\ INR H\ MOV M,B\ INR H\ POP B\ MOV M,C

#DEFINE 	DRAW_BACKWARD_LINE_PARALLELNO1	\
#DEFCONT \	MOV M,B\ DCR H\ POP B\ MOV M,C\ DCR H\ MOV M,B
#DEFCONT \	MOV H,E\ POP B\ MOV M,C\ INR H\ MOV M,B\ INR H\ POP B\ MOV M,C
#DEFCONT \	MOV H,D\ MOV M,B\ DCR H\ POP B\ MOV M,C\ DCR H\ MOV M,B

			DRAW_FORWARD_LINE_PARALLELNO1	\ DCR L
			DRAW_BACKWARD_LINE_PARALLELNO1	\ DCR L
			DRAW_FORWARD_LINE_PARALLELNO1	\ DCR L
			DRAW_BACKWARD_LINE_PARALLELNO1	\ DCR L
			DRAW_FORWARD_LINE_PARALLELNO1	\ DCR L
			DRAW_BACKWARD_LINE_PARALLELNO1	\ DCR L
			DRAW_FORWARD_LINE_PARALLELNO1	\ DCR L
			DRAW_BACKWARD_LINE_PARALLELNO1	\ DCR L
			DRAW_FORWARD_LINE_PARALLELNO1	\ DCR L
			DRAW_BACKWARD_LINE_PARALLELNO1	\ DCR L
			DRAW_FORWARD_LINE_PARALLELNO1	\ DCR L
			DRAW_BACKWARD_LINE_PARALLELNO1	\ DCR L
			DRAW_FORWARD_LINE_PARALLELNO1	\ DCR L
			DRAW_BACKWARD_LINE_PARALLELNO1	\ DCR L
			DRAW_FORWARD_LINE_PARALLELNO1	\ DCR L
			DRAW_BACKWARD_LINE_PARALLELNO1	\ DCR L
			DRAW_FORWARD_LINE_PARALLELNO1	\ DCR L
			DRAW_BACKWARD_LINE_PARALLELNO1	\ DCR L
			DRAW_FORWARD_LINE_PARALLELNO1	\ DCR L
			DRAW_BACKWARD_LINE_PARALLELNO1	\ DCR L
			DRAW_FORWARD_LINE_PARALLELNO1	\ DCR L
			DRAW_BACKWARD_LINE_PARALLELNO1	\ DCR L
			DRAW_FORWARD_LINE_PARALLELNO1	\ DCR L
			DRAW_BACKWARD_LINE_PARALLELNO1

_restoreSP:	LXI		SP, TEMP_ADDR	; restore SP (12)
			RET

;----------------------------------------------------------------
; Memory Reset
; in:
; BC	buffer last byte + 1
; DE	counter (buffer length / 32)
; use: HL

MemReset:	.MODULE MemsetM
			LXI		H, 0			; (12)
			DAD		SP				; (12)
			SHLD	_restoreSP+1	; (20)

			MOV		H, B			; (8)
			MOV		L, C			; (8)
			SPHL					; (8)
			LXI		B, 0000H		; (12)

_loop:		PUSH	B				; (16)
			PUSH	B
			PUSH	B
			PUSH	B

			PUSH	B				; (16)
			PUSH	B
			PUSH	B
			PUSH	B

			PUSH	B				; (16)
			PUSH	B
			PUSH	B
			PUSH	B

			PUSH	B				; (16)
			PUSH	B
			PUSH	B
			PUSH	B

			DCR		E				; (8)
			JNZ		_loop			; (12)
			DCR		D				; (8)
			JNZ		_loop			; (12)
_restoreSP:	
			LXI		SP, TEMP_ADDR	; restore SP (12)
			RET

;----------------------------------------------------------------
; Set Palette
; in: none
; use: A, HL, BC

#DEFINE INIT_COLOR_IDX 			0FH

SetPalette:	.MODULE SetPaletteM
			PUSH	PSW			; (16)
			PUSH	B
			PUSH	H
					
			LXI		H, colorTable + INIT_COLOR_IDX
			MVI		B, INIT_COLOR_IDX

_loop:		MOV		A, B		; (8)
			OUT		2			; (12)
			MOV		A,M			; (8)
			OUT		0CH			; (12)
			INR		B			; (8) delay
			OUT		0CH			; (12)
			DCX		H			; (8)
			OUT		0CH			; (12)
			DCR		B			; (8) delay
			DCR		B			; (8)
			OUT		0CH			; (12)
								; (108) total
			JP		_loop

			MVI		A, PORT0_OUT_OUT
			OUT		0
			LDA  	borderColorIdx ; (16)			
			OUT		2
			LDA		vScroll
			OUT		3

			POP		H			; (12)
			POP		B
			POP		PSW
			RET

vScroll:	.DB 0FFH
			.DB 0
borderColorIdx:
			.DB 0
colorTable:	.DB	01011011b, $03, 01100010b, $14, 
			.DB 10101101b, $55, 11111110b, $80,
			.DB 11111000b, $F0, 00010010b, $2D,
			.DB $2D, $2D, $2D, $07

spriteTable:.dw	spriteData00, spriteData01, spriteData02, spriteData03
			.dw	spriteData04, spriteData05, spriteData06, spriteData07
			.dw	spriteData08, spriteData09, spriteData10, spriteData11
			.dw	spriteData12, spriteData13, spriteData14, spriteData15

spriteDataSafetyBytes:
			.DB	0,0
spriteData00:
			.DB	$7f,$ff,$fe,$00,$00,$00,$7f,$ff,$fe
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$7e,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$81,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$81,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$81,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$81,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$81,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$7e,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$7f,$ff,$fe,$00,$00,$00,$7f,$ff,$fe
			.DB	0,0

spriteData01:
			.DB	$7f,$ff,$fe,$00,$00,$00,$7f,$ff,$fe
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$ff,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$18,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$18,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$18,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$18,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$18,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$18,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$7f,$ff,$fe,$00,$00,$00,$7f,$ff,$fe
			.DB	0,0

spriteData02:
			.DB	$7f,$ff,$fe,$00,$00,$00,$7f,$ff,$fe
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$ff,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$80,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$80,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$ff,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$01,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$01,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$ff,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$7f,$ff,$fe,$00,$00,$00,$7f,$ff,$fe
			.DB	0,0

spriteData03:
			.DB	$7f,$ff,$fe,$00,$00,$00,$7f,$ff,$fe
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$7e,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$81,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$01,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$3e,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$01,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$81,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$7e,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$7f,$ff,$fe,$00,$00,$00,$7f,$ff,$fe
			.DB	0,0

spriteData04:	
			.DB	$7f,$ff,$fe,$00,$00,$00,$7f,$ff,$fe
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$01,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$01,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$01,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$ff,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$81,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$81,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$81,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$7f,$ff,$fe,$00,$00,$00,$7f,$ff,$fe
			.DB	0,0

spriteData05:
			.DB	$7f,$ff,$fe,$00,$00,$00,$7f,$ff,$fe
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$7e,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$81,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$01,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$fe,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$80,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$80,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$ff,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$7f,$ff,$fe,$00,$00,$00,$7f,$ff,$fe
			.DB	0,0

spriteData06:
			.DB	$7f,$ff,$fe,$00,$00,$00,$7f,$ff,$fe
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$7e,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$81,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$81,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$fe,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$80,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$81,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$7e,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$7f,$ff,$fe,$00,$00,$00,$7f,$ff,$fe
			.DB	0,0

spriteData07:
			.DB	$7f,$ff,$fe,$00,$00,$00,$7f,$ff,$fe
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$08,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$04,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$02,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$01,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$01,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$01,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$ff,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$7f,$ff,$fe,$00,$00,$00,$7f,$ff,$fe
			.DB	0,0

spriteData08:	
			.DB	$7f,$ff,$fe,$00,$00,$00,$7f,$ff,$fe
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$7e,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$81,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$81,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$7e,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$81,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$81,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$7e,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$7f,$ff,$fe,$00,$00,$00,$7f,$ff,$fe
			.DB	0,0

spriteData09:	
			.DB	$7f,$ff,$fe,$00,$00,$00,$7f,$ff,$fe
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$7e,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$81,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$08,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$7f,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$81,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$81,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$7e,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$7f,$ff,$fe,$00,$00,$00,$7f,$ff,$fe
			.DB	0,0

spriteData10:	
			.DB	$7f,$ff,$fe,$00,$00,$00,$7f,$ff,$fe
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$81,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$81,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$81,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$ff,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$42,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$24,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$18,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$7f,$ff,$fe,$00,$00,$00,$7f,$ff,$fe
			.DB	0,0

spriteData11:
			.DB	$7f,$ff,$fe,$00,$00,$00,$7f,$ff,$fe
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$fe,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$81,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$81,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$fe,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$81,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$81,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$fe,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$7f,$ff,$fe,$00,$00,$00,$7f,$ff,$fe
			.DB	0,0

spriteData12:
			.DB	$7f,$ff,$fe,$00,$00,$00,$7f,$ff,$fe
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$7e,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$81,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$80,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$80,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$80,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$81,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$7e,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$7f,$ff,$fe,$00,$00,$00,$7f,$ff,$fe
			.DB	0,0

spriteData13:
			.DB	$7f,$ff,$fe,$00,$00,$00,$7f,$ff,$fe
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$fe,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$81,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$81,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$81,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$81,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$81,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$fe,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$7f,$ff,$fe,$00,$00,$00,$7f,$ff,$fe
			.DB	0,0

spriteData14:
			.DB	$7f,$ff,$fe,$00,$00,$00,$7f,$ff,$fe
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$ff,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$80,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$80,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$fc,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$80,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$80,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$ff,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$7f,$ff,$fe,$00,$00,$00,$7f,$ff,$fe
			.DB	0,0

spriteData15:
			.DB	$7f,$ff,$fe,$00,$00,$00,$7f,$ff,$fe
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$80,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$80,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$80,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$fc,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$80,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$80,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$ff,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$80,$00,$01,$00,$00,$00,$ff,$ff,$ff
			.DB	$7f,$ff,$fe,$00,$00,$00,$7f,$ff,$fe
			; .DB	0,0

;================================================================
			.END