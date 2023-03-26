.include "asm\\globals\\sound_const.asm"

sfx_delay:
			.byte 0

SFX_TEST_DELAY	= 50 ; 1 sec

sfx_ay_song:
.incbin "C:\\Work\\Programming\\_Dev\\Vector06c_Dev\\_Projects\\GameNoname\\temp\\sfx\\noname006.afx"

AY_REG_VOL_CHSFX			= AY_REG_VOL_CHA
AY_REG_TONE_FDIV_CHSFX_L	= AY_REG_TONE_FDIV_CHA_L
AY_REG_TONE_FDIV_CHSFX_H	= AY_REG_TONE_FDIV_CHA_H
AY_REG_MIXER_T_CHSFX		= AY_REG_MIXER_T_CHA
AY_REG_MIXER_N_CHSFX		= AY_REG_MIXER_N_CHA

; sfx data format:
; .byte - a control byte NntTVVVV:
;		VVVV - master volume
;		T - mute tone
;		t - change tone
;		n - change noise
;		N - mute noise
; .word TONE_FDIV (optional)
;			if a bit "t" is set, two bytes follow a control byte. 
;			the first one is a tone frequency divider low, 
;			the second is a tone frequency divider high
; .byte NOISE_FDIV (optional)
;			if a bit "n" is set, NOISE_FDIV byte follows a control byte or two tone frequency divider bytes if a bit "t" is set
; ...
; .byte $D0, $20 ; EOF

SFX_DATA_EOF = $20

SFX_DATA_CTRL_VOL_MASK		= %00001111 ; master volume
SFX_DATA_CTRL_TD_MASK		= %00010000	; tone muted
SFX_DATA_CTRL_TC_MASK		= %00100000 ; tone change
SFX_DATA_CTRL_NC_MASK		= %01000000 ; noise change
SFX_DATA_CTRL_ND_MASK		= %10000000 ; noise muted

;===========================================
sfx_ay_update_test:
			; check delay
			lxi h, sfx_delay
			mov a, m
			ora a
			jz sfx_ay_update
			; decrement delay
			dcr m
			ret

sfx_ay_stop_test:
			; reset song
			lxi h, sfx_ay_song
			shld sfx_ay_song_ptr

			; set a delay
			mvi a, SFX_TEST_DELAY
			sta sfx_delay
			ret

sfx_ay_update:
			lxi h, sfx_ay_song
			
			; read a control byte
			mov c, m
			inx h
			; c - a control byte
			
			; set a master volume
			mvi a, AY_REG_VOL_CHSFX
			out AY_PORT_REG
			mvi a, SFX_DATA_CTRL_VOL_MASK
			ana c
			out AY_PORT_DATA

@checkTone:
			; check if a tone changes
			mvi a, SFX_DATA_CTRL_TC_MASK
			ana c
			jz @checkNoise
@setTone:
			; set a tone
			mvi a, AY_REG_TONE_FDIV_CHSFX_L
			out AY_PORT_REG
			mov a, m
			inx h
			out AY_PORT_DATA
			mvi a, AY_REG_TONE_FDIV_CHSFX_H
			out AY_PORT_REG
			mov a, m
			inx h
			out AY_PORT_DATA

@checkNoise:
			; check if a noise changes
			mvi a, SFX_DATA_CTRL_NC_MASK
			ana c
			jz @setMixer
			; check if it is EOF
			mov a, m
			cpi SFX_DATA_EOF
			jz sfx_ay_stop_test
@setNoise:
			; set a noise
			mvi a, AY_REG_NOISE_FDIV
			out AY_PORT_REG
			mov a, m
			inx h
			out AY_PORT_DATA

@checkMixer:
			; check if a tone muted
			mvi b, AY_REG_MIXER_T_CHSFX ; mixer reg data
			mvi a, SFX_DATA_CTRL_TD_MASK
			ana c
			jnz @muteTone
			; enable a tone
			mov b, a
@muteTone:
			; check if a noise muted
			mvi a, SFX_DATA_CTRL_ND_MASK
			ana c
			jz @skipMuteNoise
			; mute a noise
			mvi a, AY_REG_MIXER_N_CHSFX
			ora b
			mov b, a
@skipMuteNoise:
			; b - SFX mixer data
			; TODO: combine SFX mixer data with a gigachad player mixer data
@setMixer:
			; set a mixer
			mvi a, AY_REG_MIXER
			out AY_PORT_REG
			; TODO: test below
			; temporaly mute all other channels 
			; mixer data should be synced with gigachad
			;mvi a, ~(AY_REG_MIXER_T_CHSFX | AY_REG_MIXER_N_CHSFX)
			;ora b
			mvi a, 0
			out AY_PORT_DATA
			; store sfx pointer
			shld sfx_ay_update + 1
			ret

sfx_ay_song_ptr = sfx_ay_update + 1