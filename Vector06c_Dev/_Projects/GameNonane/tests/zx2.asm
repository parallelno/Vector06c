; https://github.com/ivagorRetrocomp/DeZX/blob/main/ZX2/8080/dzx2.asm
; -----------------------------------------------------------------------------
; ZX2 8080 decoder by Ivan Gorodetsky
; Based on ZX2 z80 decoder by Einar Saukas
;
; v1 (2021-03-18) - 68-79 bytes forward / 68-78 bytes backward
; v2 (2021-08-16) - 67-78 bytes forward / 67-77 bytes backward
; v3 (2021-08-19) - 66-78 bytes forward / 66-77 bytes backward (-1 byte with -y option)
; v4 (2021-08-20) - 66-78 bytes forward / 65-77 bytes backward (-1 byte with {-y and -b options})
; v5 (2022-05-06) - 66-78 bytes forward / 65-77 bytes backward (slightly faster with -y option)
;
; ZX2_X_SKIP_INCREMENT (compressor -x option) - -4 bytes
; ZX2_Y_LIMIT_LENGTH (compressor -y option) - -7 bytes
; ZX2_Z_IGNORE_DEFAULT (compressor -z option) - -1 byte
; BACKWARD (compressor -b option) - -1 byte
; -----------------------------------------------------------------------------
; Parameters (forward):
;   HL: source address (compressed data)
;   BC: destination address (decompressing)
;
; Parameters (backward):
;   HL: last source address (compressed data)
;   BC: last destination address (decompressing)
; -----------------------------------------------------------------------------

#define BACKWARD
#define ZX2_X_SKIP_INCREMENT
#define ZX2_Y_LIMIT_LENGTH
#define ZX2_Z_IGNORE_DEFAULT 

#ifdef BACKWARD
#define NEXT_HL dcx h
#define NEXT_BC dcx b
#else
#define NEXT_HL inx h
#define NEXT_BC inx b
#endif

dzx2:
#ifdef BACKWARD
#ifdef ZX2_Z_IGNORE_DEFAULT 
		mvi d,0
#else
		lxi d,1
#endif
#else
#ifdef ZX2_Z_IGNORE_DEFAULT 
		mvi d,0FFh
#else
		lxi d,0FFFFh
#endif
#endif
		push d
		mvi a,080h
dzx2n_literals:
		call dzx2n_elias
		call ldir
		jc dzx2n_new_offset
dzx2n_reuse:
		call dzx2n_elias
dzx2n_copy:
		xthl
		push h
		dad b
		call ldir
		pop h
		xthl
		jnc dzx2n_literals
dzx2n_new_offset:
		pop d
		mov e,m
		inr e
		rz
		NEXT_HL
		push d
#ifdef ZX2_X_SKIP_INCREMENT
		jmp dzx2n_reuse
#else
		call dzx2n_elias
#ifdef ZX2_Y_LIMIT_LENGTH
		inr d
#else
		inx d
#endif
		jmp dzx2n_copy
#endif
dzx2n_elias:
#ifdef ZX2_Y_LIMIT_LENGTH
#ifdef BACKWARD
		inr d							
#else
		mvi d,1
#endif
#else
#ifdef BACKWARD
		mvi e,1
#else
		lxi d,1
#endif
#endif
dzx2n_elias_loop:	
		add a
		jnz dzx2n_elias_skip
		mov a,m
		NEXT_HL
		ral
#ifdef ZX2_Y_LIMIT_LENGTH
dzx2n_elias_skip:
		mov e,a
		rnc
		xchg\ dad h\ xchg
		mov a,e
		jmp dzx2n_elias_loop
ldir:
		mov a,m
		stax b
		NEXT_HL
		NEXT_BC
		dcr d
		jnz ldir
		add a
#else		
dzx2n_elias_skip:
		rnc
		xchg\ dad h\ xchg
		add a
		jnc dzx2n_elias_loop
		inr e
		jmp dzx2n_elias_loop
ldir:
		push psw
ldir_loop:
		mov a,m
		stax b
		NEXT_HL
		NEXT_BC
		dcx d
		mov a,e
		ora d
		jnz ldir_loop
		pop psw
#endif
		add a
		ret

		.end