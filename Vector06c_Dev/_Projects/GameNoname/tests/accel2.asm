
;-------------------------- ������� �� �������  ����������� 2021
;-------------------------- ��������: acceleration v2 (���������)
;-------------------------- ������: 256 ����
;-------------------------- ������������ ������ - metamorpho
;-------------------------- ������������ ������ - ivagor

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
;================================================= ����� ���������
Progrm:
; ������ ���� �� �����
	lxi d,0e000h ; ���� � �����   
	lxi h, 0f900h ; ���� � ����� 
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
	mvi h,0cfh ; ���� � ����� - ����� ���� ��� ������ �� ������
	mvi d,14h ; ����� ������ D=20        ��� �������� � ����� E=0
	call barxan_12
	lxi d,26ffh  ;����� ������ D=38      ��� �������� � ����� E=255
	mvi h,0C7h    ;  ��� ����� ������ �����
	call barxan_12
	mvi h,0D8h    ; ��� ����� ������ ������
	call barxan_12
;=========================== ������ ������ 
	lxi d,mash-1 ; ������ ������ ������
	lxi h,0f440h
	call fmoitoras
	lxi h,09440h
	call fmoitoras
;=================== ������ ������      A000+8000=�������
next:  
	lxi h,SCROLL
	inr m
;-------------- ���������
	mov a,m
	cpi 120 
	jc zador ; ������� ���� ������ 120
	out 0Bh
	inr m
	mov a,m ; SCROOL
;---------------------
zador:
	adi 130	; scrollmash
	lxi d,mash-1 ; ������
	push psw
	mvi h,0b0h
	call fmoitoraszz 
	pop psw
	mvi h,090h
	call fmoitoraszz 
;====================== �������
zamor:
	ei
	HLT
;=================================== ��������� ����������
INIT:
	mvi A,88H
	out 00H
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
	mvi a,120	; ��������� ������������� ��������� ������.
	out 03
	jmp next 
;=============== ������������ ��������� ������ � �����������
fmoitoraszz:	
	mov l, a 
fmoitoras:
	mvi c,23 ;23 ����� ������
fmoitor:
	inx d
	ldax d
	cpi 31 ; ���� 31 �� ��������� 18 ���
	jnz fmoitor22
; -------- ����������
	mvi b,18 ; ������� ���
fmoitor33:
	call mirror 
	dcr b ; ������ 17 ���  � 18-� ����� � 	fmoitor22:
	jnz fmoitor33

fmoitor22:
	call mirror
	jnz fmoitor
	ret

;=== 21+29=50 ========================= ������������ ��������� �������� 
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
	jnc fioreds ; ���� ������ D
	mvi m,240 ; ���� ������ D
fioreds:  ; ������ ������ ������ ��� ������� �����
	push h
	mov a, h
	sui 40h ; ������ �� ��������� 08000h  ר����
	mov h, a
	mov m,e 
	pop h
hairom:
	dcr l
	jnz barxan_123
lama:
	ret
;============================================= �������� 
; �������� ���� ��������� � A
mirror:
	mov m,a ; �����
	push h
	mov h, a
	mvi a,80h
dora:
	dad h
	rar
	jnc dora
	pop h
; ����� �� ����� �����
	inr h
	mov m,a
	dcr h
	mov a,m
	dcr l
	dcr c
    ret

;==============================================================
; ================== ������
mash:	.db 3,31,15,0,0  ;========== ������� (������ ����)
		.db 0,0,0,12,32,32,32,35,7,0,8,8,8,35,39,39,32,35,0,3,0,0,0 ;========== ������

;===============================================
;======================
Color:  .DB 155           ;���� ���� (�����)
COLR1:  .DB 104          ; --W--E000-FFFF    -->> ��˨��� �������� �� �������
COLR2:  .DB 255      ; --W--C000-DFFF    -->> ����� ������ �������
COLR3:  .DB 0          ;---------E000-FFFF + C000-DFFF   -->> ר����
COLR4:  .DB 31        ;--W--A000-BFFF   -->> ������� ------ ������ 1-�
COLR5:  .DB 0         ;-------- A000-BFFF + E000-FFFF   -->> ר����
COLR6:  .DB 0          ; ------A000-BFFF + C000-DFFF   -->> ר����
COLR7:  .DB 0          ; ---------A000-BFFF + C000-DFFF + E000-FFFF   -->> ר����
COLR8:  .DB 0          ;--W--8000-9FFF   -->> ר���� - ����� ����� + ���� �����
COLR9:  .DB 0          ; ---W--------- 8000-9FFF + E000-FFFF      -->> ר���� c���� ������ 2-�
COLR10: .DB 255          ;-------------8000-9FFF + C000-DFFF    -->> ����� ������ �������
COLR11: .DB 0          ; ------------8000-9FFF + C000-DFFF + E000-FFFF   -->> ר����
COLR12: .DB 0          ;--W-----------8000-9FFF + A000-BFFFF      -->> ר���� c���� ������ 1-�
COLR13: .DB 0          ;--------------8000-9FFF + A000-BFFF + E000-FFFF    -->> ר����
COLR14: .DB 0           ;-----W---------8000-9FFF + A000-BFFF + C000-DFFF   -->> ר����
COLR15: .DB 0          ; ------------- 8000-9FFF + A000-9FFF + C000-DFFF + E000-FFFF   -->> ר����
;================
		.END
