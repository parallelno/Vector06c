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
; compress backward with <-b -c> options (<-b -classic> for salvador)
;
; Compile with The Telemark Assembler (TASM) 3.2
; -----------------------------------------------------------------------------
/*
dzx0:
		lxi h, $0FFFF
		push h
		inx h
		mvi a,$80
@literals:
		call @elias
		call @ldir
		jc @newOffset
		call @elias
@copy:
		xchg
		xthl
		push h
		dad b
		xchg
		call @ldir
		xchg
		pop h
		xthl
		xchg
		jnc @literals
@newOffset:
		call @elias
		mov h, a
		pop psw
		xra a
		sub l
		rz
		push h
		rar
        mov h, a
		ldax d
		rar
        mov l, a
		inx d
		xthl
		mov a, h
		lxi h,1
		cnc @eliasBacktrack
		inx h
		jmp @copy
@elias:
		inr l
@eliasLoop:
		add a
		jnz @eliasSkip
		ldax d
		inx d
		ral
@eliasSkip:
		rc
@eliasBacktrack:
		dad h
		add a
		jnc @eliasLoop
		jmp @elias

@ldir:
		push psw
@ldir1:
		ldax d
		stax b
		inx d
		inx b
		dcx h
		mov a, h
		ora l
		jnz @ldir1
		pop psw
		add a
		ret
		.closelabels
*/
; unpack to the ram-disk $8000-$FFFF
; in:
; de - compressed data addr
; bc - uncompressed data addr
; a - ram-disk activation command

dzx0RD:
		sta @ramDiskCmd1+1
		sta @ramDiskCmd2+1

		lxi h, $ffff
		push h
		inx h
		mvi a,$80
@literals:
		call @elias
@ldir:
		sta @restoreA1+1
@ldirLoop:
		ldax d
		sta @storeA+1
		; turn on the ram-disk
@ramDiskCmd1:
		mvi a, TEMP_BYTE
		out $10
@storeA:
		mvi a, TEMP_BYTE
		stax b
		; turn off the ram-disk
		xra a
		out $10

		inx d
		inx b
		dcx h
		mov a, h
		ora l
		jnz @ldirLoop

@restoreA1:
		mvi a, TEMP_BYTE		
		add a

		jc @newOffset
		call @elias
@copy:
		xchg
		xthl
		push h
		dad b
		xchg

@ldirUnpacked:
		sta @restoreA2+1
		; turn on the ram-disk
@ramDiskCmd2:
		mvi a, TEMP_BYTE
		out $10
@ldirUnpackedLoop:
		ldax d
		stax b
		inx d
		inx b
		dcx h
		mov a, h
		ora l
		jnz @ldirUnpackedLoop

		; turn off the ram-disk
		xra a
		out $10

@restoreA2:
		mvi a, TEMP_BYTE		
		add a

		xchg
		pop h
		xthl
		xchg
		jnc @literals
@newOffset:
		call @elias
		mov h, a
		pop psw
		xra a
		sub l
		rz
		push h
		rar
        mov h, a
		ldax d
		rar
        mov l, a
		inx d
		xthl
		mov a, h
		lxi h, 1
		cnc @eliasBacktrack
		inx h
		jmp @copy

@elias:
		inr l
@eliasLoop:
		add a
		jnz @eliasSkip
		ldax d
		inx d
		ral
@eliasSkip:
		rc
@eliasBacktrack:
		dad h
		add a
		jnc @eliasLoop
		jmp @elias
		.closelabels