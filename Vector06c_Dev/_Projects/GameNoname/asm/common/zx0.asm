; -----------------------------------------------------------------------------
; ZX0 8080 decoder by Ivan Gorodetsky - OLD FILE FORMAT v1
; Based on ZX0 z80 decoder by Einar Saukas
; -----------------------------------------------------------------------------
; compress forward with -c option (-c option for salvador)
; compress backward with -b -c options (-b -classic option for salvador)
; -----------------------------------------------------------------------------

; in:
; de - source address (compressed data)
; bc - destination address (decompressing)
dzx0:
			lxi h, $0FFFF
			push h
			inx h
			mvi a,$80
@literals:
			call @elias
			call @ldir
			jc @new_offset
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
@new_offset:
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
			cnc @elias_backtrack
			inx h
			jmp @copy
@elias:
			inr l
@elias_loop:
			add a
			jnz @elias_skip
			ldax d
			inx d
			ral
@elias_skip:
			rc
@elias_backtrack:
			dad h
			add a
			jnc @elias_loop
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
			

	; unpack to the ram-disk $8000-$FFFF
	; in:
	; de - compressed data addr
	; bc - uncompressed data addr
	; a - ram-disk activation command
	;
	; based on ZX0 i8080 decoder v7 by Ivan Gorodetsky -  OLD FILE FORMAT v1
	; which based on ZX0 z80 decoder by Einar Saukas

dzx0_rd:
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
@ldir_loop:
			ldax d
			sta @storeA+1
			; turn on the ram-disk
@ramDiskCmd1:
			mvi a, TEMP_BYTE
			RAM_DISK_ON_BANK_NO_RESTORE()
@storeA:
			mvi a, TEMP_BYTE
			stax b
			RAM_DISK_OFF_NO_RESTORE()

			inx d
			inx b
			dcx h
			mov a, h
			ora l
			jnz @ldir_loop

@restoreA1:
			mvi a, TEMP_BYTE		
			add a

			jc @new_offset
			call @elias
@copy:
			xchg
			xthl
			push h
			dad b
			xchg

@ldir_unpacked:
			sta @restoreA2+1
			; turn on the ram-disk
@ramDiskCmd2:
			mvi a, TEMP_BYTE
			RAM_DISK_ON_BANK_NO_RESTORE()
@ldirUnpackedLoop:
			ldax d
			stax b
			inx d
			inx b
			dcx h
			mov a, h
			ora l
			jnz @ldirUnpackedLoop
			RAM_DISK_OFF_NO_RESTORE()

@restoreA2:
			mvi a, TEMP_BYTE		
			add a

			xchg
			pop h
			xthl
			xchg
			jnc @literals
@new_offset:
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
			cnc @elias_backtrack
			inx h
			jmp @copy

@elias:
			inr l
@elias_loop:
			add a
			jnz @elias_skip
			ldax d
			inx d
			ral
@elias_skip:
			rc
@elias_backtrack:
			dad h
			add a
			jnc @elias_loop
			jmp @elias
			