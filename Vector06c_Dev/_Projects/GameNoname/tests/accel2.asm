
;-------------------------- сделано на конкурс  ДЕМОДУЛЯЦИЯ 2021
;-------------------------- название: acceleration v2 (ускорение)
;-------------------------- размер: 256 байт
;-------------------------- оригинальная версия - metamorpho
;-------------------------- доработанная версия - ivagor

	.ORG 100H 
STRINT:
	DI
	mvi a,00100110b
	out 08h
	lxi h,0038h
	mvi m,0C9h
	mvi h,7Fh
	sphl
	xra a
	out 10h
Cls:
	mov m,a
	inx h
	cmp h
	jnz Cls
;================================================= СТАРТ ПРОГРАММЫ
Progrm:
; зелёные поля по бокам
	lxi d,0e000h ; куда в экран   
	lxi h, 0f900h ; куда в экран 
barxan_1sds:
	mvi m,255 
	xchg
	mvi m,255
	xchg
	inx d
	inx h
	xra a
	ora h
	jnz barxan_1sds

;=========================== 
	mvi h,0cfh ; куда в экран - белый цвет для полосы по центру
	mvi d,14h ; длина полосы D=20        что рисовать в экран E=0
	call barxan_12
	lxi d,26ffh  ;длина полосы D=38      что рисовать в экран E=255
	mvi h,0C7h    ;  для белой полосы слева
	call barxan_12
	mvi h,0D8h    ; для белой полосы справа
	call barxan_12
;=========================== вторая машина 
	lxi d,mash-1 ; откуда данные машины
	lxi h,0f440h
	call fmoitoras
	lxi h,09440h
	call fmoitoras
;=================== рисуем машину      A000+8000=красная
next:  
	lxi h,SCROLL
	inr m
;-------------- ускорение
	mov a,m
	cpi 120 
	jc zador ; переход если меньше 120
	out 0Bh
	inr m
	mov a,m ; SCROOL
;---------------------
zador:
	adi 130	; scrollmash
	lxi d,mash-1 ; откуда
	push psw
	mvi h,0b0h
	call fmoitoraszz 
	pop psw
	mvi h,090h
	call fmoitoraszz 
;====================== скролим
zamor:
	ei
	HLT
;=================================== обработка прерываний
INIT:
	MVI A,88H
	OUT 00H
SetPal:
	lxi h,Color
SetPalLoop:
	mvi a,0Fh
	ana l
	out 2
	mov a,m
	out 0Ch
	xthl
	xthl
	xthl
	xthl
	inr l
	out 0Ch
	jnz SetPalLoop
;-----------------------------
SCROLL .equ $+1
	mvi a,120	; УСТАНОВКА ВЕРТИКАЛЬНОГО ПОЛОЖЕНИЯ ЭКРАНА.
	OUT 03
	jmp next 
;=============== подпрограмма рисования машины с распаковкой
fmoitoraszz:	
	mov l,a 
fmoitoras:
	mvi c,23 ;23 байта высота
fmoitor:
	inx d
	ldax d
	cpi 31 ; если 31 то повторить 18 раз
	jnz fmoitor22
; -------- распаковка
	mvi b,18 ; сколько раз
fmoitor33:
	call mirror 
	dcr b ; отсчёт 17 раз  а 18-й далее в 	fmoitor22:
	jnz fmoitor33

fmoitor22:
	call mirror
	jnz fmoitor
	ret

;=== 21+29=50 ========================= подпрограмма рисования столбцов 
barxan_12:
	mvi l, 0ffh
	mvi c,41
barxan_123:
	dcr c
	jz $-3
direrow:
	mov a,c
karov:
	cmp d  ; 
	jnc fioreds ; если больше D
	mvi m,240 ; если меньше D
fioreds:  ; рисуем чёрные полосы для боковых линий
	push h
	mov a,h
	sui 40h ; уходим на плоскость 08000h  ЧЁРНЫЙ
	mov h,a
	mov m,e 
	pop h
hairom:
	dcr l
	jnz barxan_123
lama:
	ret
;============================================= ЗЕРКАЛИМ 
; Исходный байт находится в A
mirror:
	mov m,a ; экран
	push h
	mov h,a
	mvi a,80h
dora:
	dad h
	rar
	jnc dora
	pop h
; вывод на экран байта
	inr h
	mov m,a
	dcr h
	mov a,m
	dcr l
	dcr c
    ret

;==============================================================
; ================== МАШИНА
mash:	.db 3,31,15,0,0  ;========== красный (сверху вниз)
		.db 0,0,0,12,32,32,32,35,7,0,8,8,8,35,39,39,32,35,0,3,0,0,0 ;========== чёрный

;===============================================
;======================
Color:  .DB 155           ;Цвет фона (СЕРЫЙ)
COLR1:  .DB 104          ; --W--E000-FFFF    -->> ЗЕЛЁНЫЙ боковины за дорогой
COLR2:  .DB 255      ; --W--C000-DFFF    -->> БЕЛЫЙ полосы пунктир
COLR3:  .DB 0          ;---------E000-FFFF + C000-DFFF   -->> ЧЁРНЫЙ
COLR4:  .DB 31        ;--W--A000-BFFF   -->> КРАСНЫЙ ------ машина 1-я
COLR5:  .DB 0         ;-------- A000-BFFF + E000-FFFF   -->> ЧЁРНЫЙ
COLR6:  .DB 0          ; ------A000-BFFF + C000-DFFF   -->> ЧЁРНЫЙ
COLR7:  .DB 0          ; ---------A000-BFFF + C000-DFFF + E000-FFFF   -->> ЧЁРНЫЙ
COLR8:  .DB 0          ;--W--8000-9FFF   -->> ЧЁРНЫЙ - колёса машин + тень полос
COLR9:  .DB 0          ; ---W--------- 8000-9FFF + E000-FFFF      -->> ЧЁРНЫЙ cтёкла машины 2-й
COLR10: .DB 255          ;-------------8000-9FFF + C000-DFFF    -->> БЕЛЫЙ полосы пунктир
COLR11: .DB 0          ; ------------8000-9FFF + C000-DFFF + E000-FFFF   -->> ЧЁРНЫЙ
COLR12: .DB 0          ;--W-----------8000-9FFF + A000-BFFFF      -->> ЧЁРНЫЙ cтёкла машины 1-й
COLR13: .DB 0          ;--------------8000-9FFF + A000-BFFF + E000-FFFF    -->> ЧЁРНЫЙ
COLR14: .DB 0           ;-----W---------8000-9FFF + A000-BFFF + C000-DFFF   -->> ЧЁРНЫЙ
COLR15: .DB 0          ; ------------- 8000-9FFF + A000-9FFF + C000-DFFF + E000-FFFF   -->> ЧЁРНЫЙ
;================
		.END
