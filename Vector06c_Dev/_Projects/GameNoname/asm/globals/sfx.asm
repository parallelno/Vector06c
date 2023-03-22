
			; sword attack
;sfx_song_01_ch0: 
			.word 12000, 33800, 4400, 32000, 41800, 300, 0
;sfx_song_01_ch1:			
			.word 58100, 21750, 59000, 5500, 150, 900

			; light short vibrant sound. choosing an option in the menu
sfx_song_01_ch0:
			.word 300, 100, 175, 80, 200, 100, 200, 130, 90, 0
sfx_song_01_ch1:
			.word 1220, 340, 1100, 175, 500, 350, 100, 200, 140, 0

			; something light, but broken
			.word 480, 150, 200, 90, 190, 400, 430, 250, 190, 100, 260, 130
			; resemble a false use
			.word 700, 8100, 11750, 2000, 1500, 0

sfx_song_ch0_ptr:
			.word sfx_song_01_ch0
sfx_song_ch1_ptr:
			.word sfx_song_01_ch1
sfx_song_ch2_ptr:
			;.word sfx_song_01_ch2

sfx_delay:
			.byte 0

SFX_TEST_DELAY = 50 ; 1 sec

sfx_play:
		; check delay
		lxi h, sfx_delay
		mov a, m
		ora a
		jz @update
		; decrement delay
		dcr m
		ret

@update:
		lhld sfx_song_ch0_ptr
		; read a freq_div ch0
		mov c, m
		inx h
		mov b, m
		inx h
		; check the end of the song
		mov a, b
		ora c
		jz @stop
@play:
		; set freq_div to ch0
		mvi a, $36
		out $08
		mov a, c
		out $0b
		mov a, b
		out $0b
		; store the current song ptr ch0
		shld sfx_song_ch0_ptr
		; read a freq_div ch1
		lhld sfx_song_ch1_ptr
		mov c, m
		inx h
		mov b, m
		inx h
		; set freq_div to ch1
		mvi a, $76
		out $08
		mov a, c
		out $0a
		mov a, b
		out $0a	
		; store the current song ptr ch1
		shld sfx_song_ch1_ptr

		ret
@stop:
		; stop sound
		mvi a, $36
		out 08
		mvi a, $76
		out 08
		; reset song
		lxi h, sfx_song_01_ch0
		shld sfx_song_ch0_ptr
		lxi h, sfx_song_01_ch1
		shld sfx_song_ch1_ptr

		; set delay
		mvi a, SFX_TEST_DELAY
		sta sfx_delay
		ret