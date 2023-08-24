				; format

timer0		= 11
timer1		= 10
timer2		= 9
tmode 		= 8
init0		= 0x36 ; 00_11_011_0 - канал 0, два байта, режим 3, двоичный
init1		= 0x76 ; 01_11_011_0 - канал 1, два байта, режим 3, двоичный
init2		= 0xa0 ; 10_10_000_0 - канал 2, старший байт, режим 0, двоичный

cha_l		= 0
cha_h		= 1
chb_l		= 2
chb_h		= 3
chc_l		= 4
chc_h		= 5
noise		= 6
mixer		= 7
vol_a		= 8
vol_b		= 9
vol_c		= 10
ay_dat		= 0x14
ay_reg		= 0x15

; NES music player. It utilizes 3 AY channels, plus one Timer channel
; made by Segaboy
; https://zx-pk.ru/threads/35240-ay-vi-muzyka-na-vektor-06ts.html
music_player_segaboy_init:
			; init AY and Timer
			mvi a, init0
			out tmode
			mvi a, init1
			out tmode
			mvi a, init2
			out tmode

			mvi a, mixer
			out ay_reg
			mvi a, %0010_1010
			out ay_dat

			mvi a, vol_a
			out ay_reg
			xra a
			out ay_dat

			mvi a, vol_b
			out ay_reg
			xra a
			out ay_dat

			mvi a, vol_c
			out ay_reg
			xra a
			out ay_dat

			; init a context
			; a = 0
			sta music_player_segaboy_c

			lxi h, music
			shld music_player_segaboy_track_ptr + 1

			; start music
			mvi a, OPCODE_NOP
			sta music_player_segaboy_loop
			ret

music_player_segaboy_loop:
			ret					; mutable. do not change

			lxi h, music_player_segaboy_c
			dcr m
			rp

music_player_segaboy_track_ptr:
			lxi h, TEMP_ADDR	; mutable. do not change

			mov a, m
			inx h

			ora a
			jp note1
			ani %01111111
			jmp return

note1:
			rrc
			jnc note2

			mov b, a
			mov a, m
			inx h
			lxi d, table_note1
			add a
			jnc *+4
			inr d
			add e
			mov e, a
			jnc *+4
			inr d
			mvi a, cha_l
			out ay_reg
			ldax d
			out ay_dat
			inx d
			mvi a, cha_h
			out ay_reg
			ldax d
			out ay_dat
			mov a, b

note2:
			rrc
			jnc volume

			mov b, a
			mov a, m
			inx h
			lxi d, table_note2
			add a
			jnc *+4
			inr d
			add e
			mov e, a
			jnc *+4
			inr d
			mvi a, chc_l
			out ay_reg
			ldax d
			out ay_dat
			inx d
			mvi a, chc_h
			out ay_reg
			ldax d
			out ay_dat
			mov a, b

volume:
			rrc
			jnc note3

			mov b, a
			mvi a, vol_a
			out ay_reg
			mov a, m
			inx h
			mov c, a
			ani %00001111
			jz vol_1
			dcr a
			lxi d, table_vol1
			add e
			mov e, a
			jnc *+4
			inr d
			ldax d
vol_1:
			out ay_dat
			mvi a, vol_c
			out ay_reg
			mov a, c
			rrc
			rrc
			rrc
			rrc
			ani %00001111
			jz vol_2
			dcr a
			lxi d, table_vol2
			add e
			mov e, a
			jnc *+4
			inr d
			ldax d
vol_2:
			out ay_dat
			mov a, b

note3:
			rrc
			jnc off3

			mov b, a
			mov a, m
			inx h
			lxi d, table_note3
			add a
			jnc *+4
			inr d
			add e
			mov e, a
			jnc *+4
			inr d
			ldax d
			out timer0
			inx d
			ldax d
			out timer0
			mov a, b

off3:
			rrc
			jnc note4

			mov b, a
			mvi a, init0
			out tmode
			mov a, b

note4:
			rrc
			jnc check_end

			mov b, a
			mov a, m
			inx h
			mov c, a
			ani %00001111
			lxi d, table_noise
			add e
			mov e, a
			jnc *+4
			inr d
			mvi a, noise
			out ay_reg
			ldax d
			out ay_dat
			mvi a, vol_b
			out ay_reg
			mov a, c
			rrc
			rrc
			rrc
			rrc
			ani %00001111
			jz vol_3
			dcr a
			lxi d, table_vol3
			add e
			mov e, a
			jnc *+4
			inr d
			ldax d
vol_3:
			out ay_dat


check_end:
			mvi a, >end_of_music
			cmp h
			jnz reset_counter
			mvi a, <end_of_music
			cmp l
			jnz reset_counter
			lxi h, repeat

reset_counter:
			A_TO_ZERO(NULL_BYTE)
return:
			; store the context
			shld music_player_segaboy_track_ptr + 1
			sta music_player_segaboy_c
			ret

music_player_segaboy_c:
			.byte TEMP_BYTE


;.include "asm\\music_robocop_3_trk_01.asm"
.include "asm\\music_chip_and_dale.asm" ;(trk_08)_(zone_j)