; sfx player for 580ВИ53 sound chip

TIMER_PORT		= $08
TIMER_INIT_CH0	= $36
TIMER_INIT_CH1	= $76
TIMER_INIT_CH2	= $B6
TIMER_PORT_CH0	= $0b
TIMER_PORT_CH1	= $0a
TIMER_PORT_CH2	= $09

SFX_CMD_MUTE			= OPCODE_RET
SFX_CMD_PLAY			= OPCODE_LXI_H

SFX_DATA_EOF = 0

; sfx data format:
; .word - frequency divider for channel0, freq = 1500000 / freq_div
; .word - frequency divider for channel1, 
; .word - frequency divider for channel0,  
; .word - frequency divider for channel1, 
; ...
; .word $0 ; SFX_DATA_EOF

; TODO: move sfx data to the ram-disk
/*
			; light short vibrant sound. choosing an option in the menu
sfx_song_menu_enter: 
			.word 300, 100, 175, 80, 200, 100, 200, 130, 90, 0
			.word 300, 100, 175, 80, 200, 100, 200, 130, 90
*/
/*
			; menu sound light
sfx_song_menu_light: 
			.word 300, 200, 375, 280, 300, 300, 200, 330, 290, 0
			.word 1220, 340, 1100, 275, 500, 350, 300, 400, 340
*/
/*
			; menu sound medium
sfx_song_menu_med: 
			.word 710, 810, 950, 1670, 2571, 2027, 1427, 711, 1065, 0
			.word 700, 800, 952, 1675, 2572, 2020, 1417, 712, 1067
*/

/*
			; resemble a false use
sfx_song_false: 
			.word 1700, 2700, 2750, 1100, 6500, 3700, 7100, 1750, 5500, 0
			.word 1700, 2700, 2750, 1100, 6500, 3700, 7100, 1750, 5000, 0
*/

sfx_vampire_attack:
			.dword 0710<<16 | 0700, 
			.dword 0700<<16 | 0700, 
			.dword 1750<<16 | 1750,
			.dword 1000<<16 | 1100,
			.dword 1100<<16 | 1100,
			.dword 1700<<16 | 1700,
			.dword 2100<<16 | 2100,
			.dword 4750<<16 | 4750,
			.dword 5750<<16 | 5750,
			.word SFX_DATA_EOF

sfx_bomb_attack: 
			.dword 50010<<16 | 57000,
			.dword 44700<<16 | 44700,
			.dword 33750<<16 | 33750,
			.dword 13500<<16 | 33100,
			.dword 11000<<16 | 11000,
			.dword 1700<<16 | 1100,
			.dword 2100<<16 | 6500,
			.dword 4750<<16 | 700,
			.dword 5450<<16 | 700,
			.dword 1220<<16 | 42700,
			.dword 4340<<16 | 2750,
			.dword 1100<<16 | 1100,
			.dword 11075<<16 | 6500,
			.word SFX_DATA_EOF

sfx_hero_hit:
			.dword 50010<<16 | 57000,
			.dword 44700<<16 | 44700,
			.dword 33750<<16 | 33750,
			.dword 13500<<16 | 33100,
			.dword 11000<<16 | 11000,
			.dword 5450<<16 | 700,
			.dword 4340<<16 | 2750,
			.dword 11075<<16 | 6500,
			.word SFX_DATA_EOF

sfx_song_hi_pitch: 
			.dword 242<<16 | 226,
			.dword 132<<16 | 153,
			.dword 17<<16 | 152,
			.dword 125<<16 | 99,
			.dword 85<<16 | 52,
			.dword 1<<16 | 30,
			.dword 164<<16 | 16,
			.dword 13<<16 | 5,
			.dword 175<<16 | 1,
			.word SFX_DATA_EOF

; in:
; hl - sfx pointer
.macro SFX_PLAY(sfx_song_addr)
			lxi h, sfx_song_addr
			shld sfx_songPtr+1
			lxi h, sfx_update
			mvi m, SFX_CMD_PLAY
.endmacro

sfx_stop:
			; stop sound
			mvi a, TIMER_INIT_CH0
			out TIMER_PORT
			mvi a, TIMER_INIT_CH1
			out TIMER_PORT
			mvi a, OPCODE_RET
			sta sfx_update
			ret

; called by the interuption routine
; uses:
; hl, a, c
sfx_update:
sfx_songPtr:
		lxi h, sfx_vampire_attack
		; check the end of the song
		mov c, m
		inx h
		mov a, m
		ora c
		jz sfx_stop
@play:
		; set freq_div to ch0
		mvi a, TIMER_INIT_CH0
		out TIMER_PORT
		mov a, c
		out TIMER_PORT_CH0
		mov a, m
		inx h
		out TIMER_PORT_CH0

		; set freq_div to ch1
		mvi a, TIMER_INIT_CH1
		out TIMER_PORT
		mov a, m
		inx h
		out TIMER_PORT_CH1
		mov a, m
		inx h
		out TIMER_PORT_CH1
		; store the current song ptr ch0		
		shld sfx_songPtr+1		
		ret
sfx_end: