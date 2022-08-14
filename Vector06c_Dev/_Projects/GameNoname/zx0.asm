; -----------------------------------------------------------------------------
; ZX0 8080 decoder by Ivan Gorodetsky - OLD FILE FORMAT v1 
; Based on ZX0 z80 decoder by Einar Saukas
; v1 (2021-02-15) - 103 bytes forward / 100 bytes backward
; v2 (2021-02-17) - 101 bytes forward / 100 bytes backward
; v3 (2021-02-22) - 99 bytes forward / 98 bytes backward
; v4 (2021-02-23) - 98 bytes forward / 97 bytes backward
; v5 (2021-08-16) - 94 bytes forward and backward (slightly faster)
; v6 (2021-08-17) - 92 bytes forward / 94 bytes backward (forward version slightly faster)
; v7 (2022-04-30) - 92 bytes forward / 94 bytes backward (source address now in DE, slightly faster)
; -----------------------------------------------------------------------------
; Parameters (forward):
;   DE: source address (compressed data)
;   BC: destination address (decompressing)
; -----------------------------------------------------------------------------
; compress forward with <-c> option (<-classic> for salvador)
;
; Compile with The Telemark Assembler (TASM) 3.2
; -----------------------------------------------------------------------------

dzx0:
		lxi h, $0FFFF
		push h
		inx h
		mvi a,$080
dzx0_literals:
		call dzx0_elias
		call dzx0_ldir
		jc dzx0_new_offset
		call dzx0_elias
dzx0_copy:
		xchg	; 20
		xthl
		push h
		dad b
		xchg
		call dzx0_ldir
		xchg
		pop h
		xthl
		xchg
		jnc dzx0_literals
dzx0_new_offset:
		call dzx0_elias
		mov h, a
		pop psw
		xra a
		sub l
		rz
		push h
		rar			; 44
        mov h, a
		ldax d
		rar
        mov l, a
		inx d
		xthl
		mov a, h
		lxi h,1
		cnc dzx0_elias_backtrack
		inx h
		jmp dzx0_copy
dzx0_elias:
		inr l		; 60
dzx0_elias_loop:	
		add a
		jnz dzx0_elias_skip
		ldax d
		inx d
		ral
dzx0_elias_skip:
		rc
dzx0_elias_backtrack:
		dad h
		add a
		jnc dzx0_elias_loop
		jmp dzx0_elias

dzx0_ldir:
		push psw
dzx0_ldir1:
		ldax d
		stax b
		inx d			; 80
		inx b
		dcx h
		mov a, h
		ora l
		jnz dzx0_ldir1
		pop psw
		add a
		ret				; 90
		