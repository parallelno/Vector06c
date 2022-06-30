		.org 100h
		di
; ---
start:
		xra	a
		out	10h
		lxi	sp,100h
		mvi	a,0C3h
		sta	0
		lxi	h,Restart
		shld	1

		call	Cls
		mvi	a,0C9h
		sta	38h
		ei
		hlt
		lxi	h, colors+15
colorset:

		mvi	a, 88h
		out	0
		mvi	c, 15
colorset1:	mov	a, c
		out	2
		mov	a, m
		out	0Ch
		dcx	h
		out	0Ch
		out	0Ch
		dcr	c
		out	0Ch
		out	0Ch
		out	0Ch
		jp	colorset1
		mvi	a,255
		out	3


Restart:
		call	Cls

		call SetPixelModeOR
		
;рамка по краю		
		lxi h,00000h
		shld line_x0
		lxi h,00FFh
		shld line_x1
		call line
		lxi h,00000h
		shld line_x0
		lxi h,0FF00h
		shld line_x1
		call line
		
		lxi h,0FFFFh
		shld line_x0
		lxi h,00FFh
		shld line_x1
		call line
		lxi h,0FFFFh
		shld line_x0
		lxi h,0FF00h
		shld line_x1
		call line

;внутреняя рамка
		lxi h,01010h
		shld line_x0
		lxi h,010F0h
		shld line_x1
		call line
		lxi h,01010h
		shld line_x0
		lxi h,0F010h
		shld line_x1
		call line

		lxi h,0F0F0h
		shld line_x0
		lxi h,0F010h
		shld line_x1
		call line
		lxi h,0F0F0h
		shld line_x0
		lxi h,010F0h
		shld line_x1
		call line

;уголки		
		lxi h,00808h
		shld line_x0
		lxi h,00908h
		shld line_x1
		call line
		lxi h,00808h
		shld line_x0
		lxi h,00809h
		shld line_x1
		call line

		lxi h,0F8F8h
		shld line_x0
		lxi h,0F8F7h
		shld line_x1
		call line
		lxi h,0F8F8h
		shld line_x0
		lxi h,0F7F8h
		shld line_x1
		call line
		
		lxi h,008F8h
		shld line_x0
		lxi h,009F8h
		shld line_x1
		call line
		lxi h,008F8h
		shld line_x0
		lxi h,008F7h
		shld line_x1
		call line

		lxi h,0F808h
		shld line_x0
		lxi h,0F809h
		shld line_x1
		call line
		lxi h,0F808h
		shld line_x0
		lxi h,0F708h
		shld line_x1
		call line

;точки
		lxi h,02020h
		shld line_x0
		shld line_x1
		call line

		lxi h,0DF20h
		shld line_x0
		shld line_x1
		call line

		lxi h,020DFh
		shld line_x0
		shld line_x1
		call line

		lxi h,0DFDFh
		shld line_x0
		shld line_x1
		call line
		
		lxi h,circl
circloop:
		push h
		lxi h,8080h
		shld line_x0
		pop h
		mov a,m
		ora a
		jz benchmark
		sta line_x1
		inx h
		mov a,m
		sta line_y1
		inx h
		push h
		call line
		pop h
		jmp circloop

circl:
		.db 228,128
		.db 220,166
		.db 199,199
		.db 166,220
		.db 128,228
		.db 90,220
		.db 57,199
		.db 36,166
		.db 28,128
		.db 36,90
		.db 57,57
		.db 90,36
		.db 128,28
		.db 166,36
		.db 199,57
		.db 220,90
		.db 0

benchmark
		in 1
		rlc
		jnc benchmark_go
		rlc
		jnc benchmark_go
		rlc
		jc benchmark

benchmark_go
		call SetPixelModeXOR

		call rnd16
		shld line_tail
foreva:
		lhld line_tail
		shld line_x0

		call rnd16
		mov d, h
		mov e, l
		inx d
		mov a, d
		ora e
		jz foreva_nomoar
		shld line_x1
		shld line_tail

		call line
		jmp foreva
foreva_nomoar
		jmp Restart

line_tail:	.dw 0

		; аргументы line()
line_x0		.db 100
line_y0		.db 55
line_x1		.db 0
line_y1		.db 50 

		; эти четыре байта должны идти в таком порядке, а то
line_y		.db 0
line_x		.db 0
line_dx 	.db 0
line_dy		.db 0

SetPixelModeXOR:
		lxi h,0A9AEh		;A9 - xra c; AE - xra m
		jmp SetPixelModeOR1
		
SetPixelModeOR:
		lxi h,0B1B6h		;B1 - ora c; B6 - ora m
SetPixelModeOR1:
		mov a,l
		sta SetPixelMode_g3
		sta SetPixelMode_g4
		sta SetPixelMode_s3
		mov a,h
		sta SetPixelMode_g1
		sta SetPixelMode_g2
		sta SetPixelMode_s1
		sta SetPixelMode_s2
		ret
		
PixelMask:
		.db 10000000b
		.db 01000000b
		.db 00100000b
		.db 00010000b
		.db 00001000b
		.db 00000100b
		.db 00000010b
		.db 00000001b
line:		; вычислить line_dx, line_dy и приращение Y
		; line_dx >= 0, line_dy >= 0, line1_mod_yinc ? [-1,1]

		; вычисление расстояния по X (dx)
		; проверить, что x0 <= x1
		lda line_x0
		sta line_x
		mov b, a		;b = x0
		lda line_x1
		sub b			;a = x1 - x0
		jnc line_x_positive     ;если x0 <= x1, то переход

		;если x0 > x1, то пришли сюда
		cma
		inr a			; -(x1-x0)=x0-x1
		sta line_dx		; сохранили |dx|
		lhld line_x0
		xchg
		lhld line_x1
		shld line_x0
		mov a,l
		sta line_x
		xchg
		shld line_x1
		jmp line_calc_dy
		
line_x_positive:
		sta line_dx		; сохранили |dx|

		; вычисление расстояния по Y (dy)
line_calc_dy:
		; если y0 <= y1
		lda line_y0
		sta line_y
		mov b, a		;b = y0
		lda line_y1
		sub b			;a = y1 - y0
		jnc line_y_positive	;если y0 <= y1, то переход

		;если y0 > y1, то пришли сюда
		cma
		inr a			; -(y1-y0)= y0 - y1
		sta line_dy		; сохранили |dy|
		
		; приращение y = -1
		mvi a, 02Dh 		; dcr l
		jmp set_line1_mod_yinc

line_y_positive:
		sta line_dy	        ; y1 - y0
		mvi a, 02Ch 		; inr l
set_line1_mod_yinc:
		sta line1_mod_yinc_g
		sta line1_mod_yinc_s1
		sta line1_mod_yinc_s2

line_check_gs:
		; проверяем крутизну склона:
		; dy >= 0, dx >= 0
		;  	dy <= dx 	?	пологий
		;	dy > dx 	?	крутой
		lhld line_dx 	                ; l = dx, h = dy
		mov a, l 
		cmp h				;если dy<=dx
		jnc  line_gentle	        ;то склон пологий
		
		; крутой склон
		; начальное значение D
		; D = 2 * dx - dy
		lda line_dy
		cma
		mov e,a
		mvi d,0FFh
		inx d				; de = -dy

		lhld line_dx
		mvi h,0
		dad h
		shld line1_mod_dx_s+1		; сохранить 2*dx константой
		; сохранить 2*dx константой
		mov a,l
		sta line1_mod_dx_sLo+1		; сохранить 2*dx константой
		mov a,h
		sta line1_mod_dx_sHi+1		; сохранить 2*dx константой

		dad d				; hl = 2 * dx - dy
		push h				; поместить в стек значение D = 2 * dx - dy
		xchg				; hl = -dy
		
		dad h				; hl = -2*dy
line1_mod_dx_s:
		lxi d,0				; de = 2*dx
		dad d 				; hl = 2 * dx - 2 * dy
		; сохранить как конст
		mov a,l
		sta line1_mod_dxdy_sLo+1
		mov a,h
		sta line1_mod_dxdy_sHi+1

		lhld line_y	;h=x; l=y
		xchg		;d=x; e=y
		mvi a,111b
		ana d
		adi PixelMask&255
		mov l,a
		mvi a,PixelMask>>8
		aci 0
		mov h,a			; hl - адрес маски в PixelMask
		mov c,m 		; начальное значение маски пикселя
		
		mvi a,11111000b
		ana d
		rrc
		rrc 
		stc 
		rar 
		xchg 		        ; l=y
		mov h,a		        ; h=старший байт экранного адреса
		pop d			; de = 2 * dx - dy

		lda line_dy
		mov b,a

		;------ крутой цикл (s/steep) -----
line1_loop_s:	; <--- точка входа в крутой цикл --->
		mov a,m
SetPixelMode_s1:
		xra c
		mov m,a	 		; записать в память результат с измененным пикселем

		; if D > 0
		xra a
		ora d
		jp line1_then_s
line1_else_s: 	; else от if D > 0
line1_mod_yinc_s2:
		inr l			; y = y +/- 1
		mov a,m
SetPixelMode_s2:
		xra c
		mov m,a	 		; записать в память результат с измененным пикселем
		dcr b
		rz
line1_mod_dx_sLo:
		mvi a,0		        ; изменяемый код (2*dx) младший байт
		add e
		mov e,a
line1_mod_dx_sHi:
		mvi a,0		        ; изменяемый код (2*dx) старший байт
		adc d
		mov d,a
		;в итоге de = de + 2*dx
		jm line1_else_s

line1_then_s:
line1_mod_yinc_s1:
		inr l			; y = y +/- 1
		mov a,c
		rrc 			; xincLo
		mov c,a
		jnc $+4
		inr h			; xincHi
SetPixelMode_s3:
		xra m
		mov m,a	 		; записать в память результат с измененным пикселем
		dcr b
		rz
line1_mod_dxdy_sLo:
		mvi a,0			; изменяемый код: 2*(dx-dy) младший байт
		add e
		mov e,a
line1_mod_dxdy_sHi:
		mvi a,0			; изменяемый код: 2*(dx-dy) старший байт
		adc d
		mov d,a
		;в итоге de = de + 2*(dx-dy)
		jm line1_else_s
		jmp line1_then_s
		; --- конец тела крутого цикла ---

		
line_gentle:
		; склон пологий
		; начальное значение D
		; D = 2 * dy - dx
		lda line_dx
		cma
		mov e,a
		mvi d,0FFh
		inx d				; de = -dx

		lhld line_dy
		mvi h,0
		dad h
		shld line1_mod_dy_g+1		; сохранить 2*dy константой
		; сохранить 2*dy константой
		mov a,l
		sta line1_mod_dy_gLo+1
		mov a,h
		sta line1_mod_dy_gHi+1


		dad d				; hl = 2 * dy - dx
		push h				; поместить в стек значение D = 2 * dy - dx
		xchg				; hl = -dx
		
		dad h				; hl = -2*dx
line1_mod_dy_g:
		lxi d,0
		dad d 				; hl = 2 * dy - 2 * dx
		mov a,l
		sta line1_mod_dydx_gLo+1        ; сохранить как конст
		mov a,h
		sta line1_mod_dydx_gHi+1        ; сохранить как конст
		
		pop d				; de = 2 * dy - dx

		; основной цикл рисования линии
		; версия для пологого склона (_g)
		lhld line_x	;l=x h=dx
		mov c,l		;c=x
		mov b,h		;line_dx
		lda line_y	;a=y
		sta line_yx_g+1

		; подготовить начальное значение регистра c
		mvi a, 111b 		; сначала вычисляем смещение 
		ana c 			; пикселя в PixelMask (с = x)
		adi PixelMask&255
		mov l,a
		mvi a,PixelMask>>8
		aci 0
		mov h,a			; hl - адрес маски в PixelMask
		mvi a,11111000b
		ana c
		rrc
		rrc
		stc
		rar
		sta line_yx_g+2	; 0x80 | (x >> 3), l = y

		xra a
		cmp b		        ;dx=0?
		mov c,m			; маска
line_yx_g:
		lxi h, 0                ; hl указывает в экран
		jnz line1_loop_g	;если dx<>0, то переход на обычное рисование линии
;если dx=0, то ставим одну точку
		mov a,m
SetPixelMode_g2:
		xra c
		mov m,a 		; записать в память
		ret

		;------ пологий цикл (g/gentle) -----
line1_loop_g:	; <--- точка входа в пологий цикл --->
		mov a,m
SetPixelMode_g1:
		xra c
		mov m,a 		; записать в память

		; if D > 0
		xra a
		ora d
		jp line1_then_g
line1_else_g: 	; else от if D > 0
		mov a,c
		rrc 			; сдвинуть вправо (следующий X)
		mov c,a			; сохраняем текущее значение маски
		jnc $+4 		; если не провернулся через край
		inr h			;line_x += 1
SetPixelMode_g3:
		xra m
		mov m,a 		; записать в память
		dcr b			; dx -= 1
		rz

line1_mod_dy_gLo:
		mvi a,0		        ; изменяемый код (2*dy) младший байт
		add e
		mov e,a
line1_mod_dy_gHi:
		mvi a,0		        ; изменяемый код (2*dy) старший байт
		adc d
		mov d,a
		;в итоге de= de + 2*dy
		jm line1_else_g

line1_then_g:
line1_mod_yinc_g:
		inr l			; изменяемый код: line_y += yinc или line_y -= yinc
		mov a,c
		rrc 			; сдвинуть вправо (следующий X)
		mov c,a			; сохраняем текущее значение маски
		jnc $+4 		; если не провернулся через край
		inr h			;line_x += 1
SetPixelMode_g4:
		xra m
		mov m,a 		; записать в память
		dcr b			; dx -= 1
		rz
line1_mod_dydx_gLo:
		mvi a,0		        ; изменяемый код: 2*(dy-dx) младший байт
		add e
		mov e,a
line1_mod_dydx_gHi:
		mvi a,0		        ; изменяемый код: 2*(dy-dx) старший байт
		adc d
		mov d,a
		;в итоге de = de + 2*(dy-dx)
		jm line1_else_g
		jmp line1_then_g
		; --- конец тела пологого цикла ---

		; --- конец line() ---
		
Cls:
		lxi	h,08000h
		mvi	e,0
		xra	a
ClrScr:
		mov	m,e
		inx	h
		cmp	h
		jnz	ClrScr
		ret

		; выход:
		; HL - число от 1 до 65535
rnd16:
		lxi h,65535
		dad h
		shld rnd16+1
		rnc
		mvi a,00000001b ;перевернул 80h - 10000000b
		xra l
		mov l,a
		mvi a,01101000b	;перевернул 16h - 00010110b
		xra h
		mov h,a
		shld rnd16+1
		ret

colors:
		.db 00000000b,00001001b,00010010b,00011011b,00100100b,00101101b,00110110b,00111111b
		.db 11111111b,00001001b,00010010b,00011011b,00100100b,00101101b,00110110b,00111111b

		.end
