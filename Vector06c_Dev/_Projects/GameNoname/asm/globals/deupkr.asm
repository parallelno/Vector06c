;; upkr 8080 decoder by Ivan Gorodetsky
;; based on z80 version by Peter "Ped" Helcmanovsky (C) 2022, licensed same as upkr project ("unlicensed")
;; to assemble use The Telemark Assembler (TASM) 3.2
;;
;; v1 -  2022-10-24
;; v2 -  2022-10-29 (-2 bytes)
;; v3 -  2022-12-03 (-1 byte and slightly faster)
;; v4 -  2022-12-08 (-3 bytes and 2% faster with UPKR_UNPACK_SPEED)
;; v5 -  2022-12-13 (slightly faster with UPKR_UNPACK_SPEED)
;;
;; public API:
;;         HL = packed data, DE = destination
;;         call deupkr

;#DEFINE BACKWARDS_UNPACK         ; uncomment to build backwards depacker (write_ptr--, upkr_data_ptr--)
            ; initial HL points at last byte of compressed data
            ; initial DE points at last byte of unpacked data

;#DEFINE UPKR_UNPACK_SPEED        ; uncomment to get larger but faster unpack routine

;forward version - 224 bytes
;forward fast version - 251 bytes
;compress forward with <--z80> option

;backward version - 223 bytes
;backward fast version - 250 bytes
;compress backward with <--z80 -r> options

NUMBER_BITS     .equ     16+15       ; context-bits per offset/length (16+15 for 16bit offsets/pointers)
    ; numbers (offsets/lengths) are encoded like: 1a1b1c1d1e0 = 0000'0000'001e'dbca

; reserve space for probs array
; you can define UPKR_PROBS_ORIGIN to specific 256 byte aligned address for probs array (320 bytes),
#define UPKR_PROBS_ORIGIN 0FA00h
probs      .equ ((UPKR_PROBS_ORIGIN) + 255) & -$100     ; probs array aligned to 256
probs_real_c:    .equ 1 + 255 + 1 + (2*NUMBER_BITS)             ; real size of probs array
probs_c:         .equ (probs_real_c + 1) & -2                      ; padding to even size (required by init code)
probs_e:         .equ probs + probs_c

; IN: HL = compressed_data, DE = destination
deupkr:
		shld upkr_data_ptr+1
		push d
		lxi h,probs_c>>1
		lxi b,probs_e
		mvi a,80h
reset_probs:
		dcx b
		stax b
		dcx b
		stax b
		dcr l
		jnz reset_probs
		sta SetA_+1
decompress_data:
		mvi c,0
		call decode_bit
		jc copy_chunk
		inr c
decode_byte:
		call decode_bit
		mov a,c
		ral
		mov c,a
		jnc decode_byte
		xthl
		mov m,c
#IFNDEF BACKWARDS_UNPACK
		inx h
#ELSE
		dcx h
#ENDIF
		xthl
		mov d,b
		jmp decompress_data

copy_chunk:
		mov a,b
		inr b
		cmp d
		cnc decode_bit
		jnc keep_offset
		ora a
		call decode_number
		dcx d
		mov a,d
		ora e
		jz Exit
		xchg
		shld offset+1
		xchg
keep_offset:
		mvi c,(257 + NUMBER_BITS - 1)&255
		call decode_number
		xthl
		push b
		push d
#IFNDEF BACKWARDS_UNPACK
offset:
		lxi b,0
		mov a,l
		sub c
		mov c,a
		mov a,h
		sbb b
		mov b,a
ldir_loop:
		ldax b
		mov m,a
		inx b
		inx h
		dcx d
		mov a,e
		ora d
		jnz ldir_loop
#ELSE
		mov c,e
		mov b,d
		xchg
offset:
		lxi h,0
		dad d
lddr_loop:
		mov a,m
		stax d
		dcx h
		dcx d
		dcx b
		mov a,c
		ora b
		jnz lddr_loop
		xchg
#ENDIF
		pop d
		pop b
		xthl
		mov d,b
		dcr b
		jnz decompress_data
inc_c_decode_bit:
		inr c
decode_bit:
		push d
		xra a
		ora h
		jm state_b15_set
SetA_:
		mvi a,0
state_b15_zero:
		dad h
		add a
		jnz has_bit
		xchg
upkr_data_ptr:
		lxi h,0
		mov a,m
#IFNDEF BACKWARDS_UNPACK
		inx h
#ELSE
		dcx h
#ENDIF
		shld upkr_data_ptr+1
		xchg
		adc a
has_bit:
		jnc $+4
		inr l
		inr h
		dcr h
		jp state_b15_zero
		sta SetA_+1
state_b15_set:
		ldax b
		dcr a
		cmp l
		inr a
		push b
		mov c,l
		push psw
#IFNDEF UPKR_UNPACK_SPEED
		jnc bit_is_0
		cma
		inr a
bit_is_0:
		mov e,a
		xra a
		mov d,a
		mov l,a
		mov b,a
		cma
mulLoop:
		dad h
		jnc mul0
		dad d
mul0:
		add a
		jm mulLoop
#ELSE
		mvi d,0
		mov l,d
		mov b,d
		jnc bit_is_0
		cma
		adc d
bit_is_0:
		mov e,a
		dad h\ mov l,e
		dad h\ jnc $+4\ dad d
		dad h\ jnc $+4\ dad d
		dad h\ jnc $+4\ dad d
		dad h\ jnc $+4\ dad d
		dad h\ jnc $+4\ dad d
		dad h\ jnc $+4\ dad d
		dad h\ jnc $+4\ dad d
#ENDIF
		dad b
		pop psw
		jnc bit_is_0_2
		dcr d
		dad d
bit_is_0_2:
		rar
		ani 0FCh
		rar
		rar
		rar
		aci -16
		mov e,a
		pop b
		ldax b
		sub e
		stax b
		add d
Exit:
		pop d
		ret

decode_number:
		lxi d,0FFFFh
loop:
		cc inc_c_decode_bit
		mov a,d
		rar
		mov d,a
		mov a,e
		rar
		mov e,a
		call inc_c_decode_bit
		jc loop
fix_bit_pos:
		cmc
		mov a,d
		rar
		mov d,a
		mov a,e
		rar
		mov e,a
		jc fix_bit_pos
		ret
		
		.end
