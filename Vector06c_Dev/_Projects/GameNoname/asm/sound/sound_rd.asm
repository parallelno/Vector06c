
.include "asm\\common\\macro.asm"

.include "asm\\sound\\music_player_gigachad_buffers_rd.asm" ; it's included first because it contains aligned buffers.
.include "asm\\sound\\music_player_gigachad_rd.asm"
.include "asm\\sound\\sfx_rd.asm"

__RAM_DISK_S_SOUND = RAM_DISK_S
__RAM_DISK_M_SOUND = RAM_DISK_M

; init sound
; ex. CALL_RAM_DISK_FUNC(__sound_init, __RAM_DISK_S_SOUND | RAM_DISK_M_8F)
; ex. CALL_RAM_DISK_FUNC(__sound_init, __RAM_DISK_M_GCPLAYER | RAM_DISK_M_8F)
__sound_init:
			call __sfx_init
			call __gcplayer_init
			ret

; play music and sfx
; called by the unterruption routine
; ex. CALL_RAM_DISK_FUNC_NO_RESTORE(__sound_update, __RAM_DISK_M_SOUND | __RAM_DISK_S_SOUND | RAM_DISK_M_8F)
__sound_update:
			call __gcplayer_update
			call __sfx_update
			ret