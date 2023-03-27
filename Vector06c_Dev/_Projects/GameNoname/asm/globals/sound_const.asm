	; this line for VSCode proper formating
; AY-3-8910 sound chip consts
; ports
AY_PORT_REG		= $15
AY_PORT_DATA	= $14
; regs
AY_REG_TONE_FDIV_CHA_L	= 0 ; LLLLLLLL, channel A tone frequency divider low, FDIV = HHHH * 256 + LLLLLLLL, frq = 1.7734MHz / 16 / FDIV
AY_REG_TONE_FDIV_CHA_H	= 1 ; ----HHHH, channel A tone frequency divider high 
AY_REG_TONE_FDIV_CHB_L	= 2 ; LLLLLLLL, channel B tone frequency divider low 
AY_REG_TONE_FDIV_CHB_H	= 3 ; ----HHHH, channel B tone frequency divider high 
AY_REG_TONE_FDIV_CHC_L	= 4 ; LLLLLLLL, channel C tone frequency divider low 
AY_REG_TONE_FDIV_CHC_H	= 5 ; ----HHHH, channel C tone frequency divider high 
AY_REG_NOISE_FDIV		= 6 ; ---NNNNN, noise frequency divider, FDIV = NNNNN, frq = 1.7734MHz / 16 / FDIV
AY_REG_MIXER			= 7 ; --CBAcba, cba - to mute tone channels, CBA - to mute noise channels, (1 = muted)
AY_REG_VOL_CHA			= 8 ; ---EVVVV, E - envelope (1=enabled), VVVV - master volune
AY_REG_VOL_CHB			= 9 ; ---EVVVV, E - envelope (1=enabled), VVVV - master volune
AY_REG_VOL_CHC			= 10; ---EVVVV, E - envelope (1=enabled), VVVV - master volune
AY_REG_ENV_FDIV_L		= 11; LLLLLLLL, envelope period low, to set the envelope lifetime. the larger the number, the longer the envelope
AY_REG_ENV_FDIV_H		= 12; HHHHHHHH, envelope period high, FDIV = FDIV_H * 256 + FDIV_L
AY_REG_ENV				= 13; ----EEEH, envelope type = EEE, H = 1 means hold
;							envelope type = 0: \_____________, single decay then off
;							envelope type = 1: /|____________, single attack then off
;							envelope type = 2: \|------------, single decay then hold
;							envelope type = 3: /-------------, single attack then hold
;							envelope type = 4: \|\|\|\|\|\|\|, repeated decay
;							envelope type = 5: /|/|/|/|/|/|/|, repeated attack
;							envelope type = 6: /\/\/\/\/\/\/\, repeated attack-decay
;							envelope type = 7: \/\/\/\/\/\/\/, repeated decay-attack 
; mixer masks
AY_REG_MIXER_T_MUTE_CHA = %00000001 ; to mute tone channel A
AY_REG_MIXER_T_MUTE_CHB = %00000010 ; to mute tone channel B
AY_REG_MIXER_T_MUTE_CHC = %00000100 ; to mute tone channel C
AY_REG_MIXER_N_MUTE_CHA = %00001000 ; to mute noise channel A
AY_REG_MIXER_N_MUTE_CHB = %00010000 ; to mute noise channel B
AY_REG_MIXER_N_MUTE_CHC = %00100000 ; to mute noise channel C
; master volume masks
AY_REG_VOL_MASK			= %00001111
AY_REG_VOL_ENV_MASK		= %00010000
			