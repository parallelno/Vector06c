; sfx player for 580ВИ53 sound chip

TIMER_PORT		= $08
TIMER_INIT_CH0	= $36
TIMER_INIT_CH1	= $76
TIMER_INIT_CH2	= $B6
TIMER_PORT_CH0	= $0b
TIMER_PORT_CH1	= $0a
TIMER_PORT_CH2	= $09

SFX_DATA_EOF = 0

setting_sfx		.byte SETTING_ON

; TODO: use all 3 channels to simulate a volume change

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

__sfx_vampire_attack:
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

__sfx_bomb_attack: 
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

__sfx_hero_hit:
			.dword 50010<<16 | 57000,
			.dword 44700<<16 | 44700,
			.dword 33750<<16 | 33750,
			.dword 13500<<16 | 33100,
			.dword 11000<<16 | 11000,
			.dword 5450<<16 | 700,
			.dword 4340<<16 | 2750,
			.dword 11075<<16 | 6500,
			.word SFX_DATA_EOF

__sfx_song_hi_pitch: 
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

; send silence to the sound chip
sfx_reg_mute:
			; stop sound
			mvi a, TIMER_INIT_CH0
			out TIMER_PORT
			mvi a, TIMER_INIT_CH1
			out TIMER_PORT
			ret
sfx_stop:
			; stop sound
			call sfx_reg_mute
			mvi a, OPCODE_RET
			sta sfx_update_ptr			
			ret

__sfx_init:
			call sfx_stop
			mvi a, SETTING_ON
			sta setting_sfx
			ret

; start the next sfx to play
; ex. CALL_RAM_DISK_FUNC(__sfx_play, __RAM_DISK_M_SOUND | RAM_DISK_M_8F)
; in:
; hl - sfx pointer
__sfx_play:
			shld sfx_update_ptr + 1
			mvi a, OPCODE_LXI_H
			sta sfx_update_ptr
			ret

; uses:
; hl, a, c
__sfx_update:
@song_ptr:
			lxi h, TEMP_ADDR;__sfx_vampire_attack

			; return if muted
			lda setting_sfx
			cpi SETTING_ON
			rnz

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
			shld @song_ptr + 1		
			ret
sfx_update_ptr: = @song_ptr

; to mute the sfx player. It can continue the sfx after unmute
; to call from this module: call __sfx_mute
; to call outside: CALL_RAM_DISK_FUNC(__sfx_mute, __RAM_DISK_M_SOUND | RAM_DISK_M_8F)
__sfx_mute:
			call sfx_reg_mute
			; disable the updates
			mvi a, SETTING_OFF
			sta setting_sfx
			ret

; to unmute the sfx player after being muted. It continues the sfx from where it has been stopped
; to call from this module: call __sfx_unmute
; to call outside: CALL_RAM_DISK_FUNC(__sfx_unmute, __RAM_DISK_M_SOUND | RAM_DISK_M_8F)
__sfx_unmute:
			mvi a, SETTING_ON
			sta setting_sfx
			ret

; to flip mute/unmute
; to call from this module: call __sfx_flip_mute
; to call outside: CALL_RAM_DISK_FUNC(__sfx_flip_mute, __RAM_DISK_M_SOUND | RAM_DISK_M_8F)
__sfx_flip_mute:
			lxi h, setting_sfx
			mov a, m
			cma
			mov m, a
			cpi SETTING_OFF
			jz __sfx_mute
			jmp __sfx_unmute

; return setting_sfx value
; to call from this module: call __sfx_get_setting
; to call outside: CALL_RAM_DISK_FUNC(__sfx_get_setting, __RAM_DISK_M_SOUND | RAM_DISK_M_8F)
; out:
; c - setting_sfx value
__sfx_get_setting:
			lda setting_sfx
			mov c, a
			ret