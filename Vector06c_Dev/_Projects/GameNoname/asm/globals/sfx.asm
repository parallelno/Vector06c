

sfx_song_01_ch0: 
			.word 710, 700, 1750, 1000, 1100, 1700, 2100, 4750, 5500, 0
sfx_song_01_ch1:			
			.word 700, 700, 1750, 1100, 1100, 1700, 2100, 4750, 5500, 0
/*
			; bomb attack
sfx_song_01_ch0: 
			.byte 242, 132, 17, 125, 85, 1, 164, 13, 175, 0
sfx_song_01_ch1:			
			.byte 226, 163, 152, 99, 52, 30, 16, 5, 1,
*/
/*
			; light short vibrant sound. choosing an option in the menu
sfx_song_01_ch0: 
			.word 300, 100, 175, 80, 200, 100, 200, 130, 90, 0
sfx_song_01_ch1:			
			.word 300, 100, 175, 80, 200, 100, 200, 130, 90, 0
*/			
/*
			; menu sound light
sfx_song_01_ch0: 
			.word 300, 200, 375, 280, 300, 300, 200, 330, 290, 0
sfx_song_01_ch1:			
			.word 1220, 340, 1100, 275, 500, 350, 300, 400, 340
*/
/*
			; menu sound medium
sfx_song_01_ch0: 
			.word 710, 810, 950, 1670, 2571, 2027, 1427, 711, 1065, 0
sfx_song_01_ch1:			
			.word 700, 800, 952, 1675, 2572, 2020, 1417, 712, 1067
*/

/*
			; resemble a false use
sfx_song_01_ch0: 
			.word 1700, 2700, 2750, 1100, 6500, 3700, 7100, 1750, 5500, 0
sfx_song_01_ch1:			
			.word 1700, 2700, 2750, 1100, 6500, 3700, 7100, 1750, 5000, 0
*/
/*
			; vampire attack
sfx_song_01_ch0: 
			.word 710, 700, 1750, 1000, 1100, 1700, 2100, 4750, 5500, 0
sfx_song_01_ch1:			
			.word 700, 700, 1750, 1100, 1100, 1700, 2100, 4750, 5500, 0
*/

/*
			; bomb attack
sfx_song_01_ch0: 
			.word 50010, 44700, 33750, 13500, 11000, 1700, 2100, 4750, 5450, 1220, 4340, 1100, 11075, 0
sfx_song_01_ch1:			
			.word 57000, 44700, 33750, 33100, 11000, 1100, 6500, 700, 7100, 42700, 2750, 1100, 6500
*/

sfx_delay:
			.byte 0

SFX_TEST_DELAY	= 50 ; 1 sec
SFX_PORT_INIT			= $08
SFX_PORT_INIT_VALUE_CH0	= $36
SFX_PORT_INIT_VALUE_CH1	= $76
SFX_PORT_INIT_VALUE_CH2	= $B6
SFX_PORT_CH0			= $0b
SFX_PORT_CH1			= $0a
SFX_PORT_CH2			= $09

sfx_stop:
		; stop sound
		mvi a, SFX_PORT_INIT_VALUE_CH0
		out SFX_PORT_INIT
		mvi a, SFX_PORT_INIT_VALUE_CH1
		out SFX_PORT_INIT
		; reset song
		lxi h, sfx_song_01_ch0
		shld sfx_songPtr+1

		; set a delay
		mvi a, SFX_TEST_DELAY
		sta sfx_delay
		ret

sfx_update:
		; check delay
		lxi h, sfx_delay
		mov a, m
		ora a
		jz sfx_songPtr
		; decrement delay
		dcr m
		ret
		; send data to a sound chip
sfx_songPtr:
		lxi h, sfx_song_01_ch0
		; check the end of the song
		mov a, m
		ora a
		jz sfx_stop
@play:
		; set freq_div to ch0
		mvi a, SFX_PORT_INIT_VALUE_CH0
		out SFX_PORT_INIT
		mov a, m
		inx h
		out SFX_PORT_CH0
		mov a, m
		inx h
		out SFX_PORT_CH0
		; store the current song ptr ch0		
		shld sfx_songPtr+1

		lxi d, sfx_song_01_ch1 - sfx_song_01_ch0 - 2
		dad d
		; set freq_div to ch1
		mvi a, SFX_PORT_INIT_VALUE_CH1
		out SFX_PORT_INIT
		mov a, m
		inx h
		out SFX_PORT_CH1
		mov a, m
		out SFX_PORT_CH1
		ret