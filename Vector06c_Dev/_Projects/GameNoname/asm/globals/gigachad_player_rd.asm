.include "asm\\globals\\ay_consts.asm"

; gigachad16 player
; info/credits:
; music has to be compressed into 14 buffers each for every register
; this player decompresses and plays 14 parallel streams.
; Only one task is executed each frame that decompresses 16 bytes for one of the ay registers.
; cpu load: 5-20 of 312 scanlines per a frame
; original player code was written by svofski 2022
; original zx0 decompression code was written by ivagor 2022

__RAM_DISK_S_GCPLAYER = RAM_DISK_S
__RAM_DISK_M_GCPLAYER = RAM_DISK_M

setting_music	.byte SETTING_ON

; ex. CALL_RAM_DISK_FUNC(__gcplayer_init, __RAM_DISK_M_GCPLAYER | RAM_DISK_M_8F)
__gcplayer_init:
			call __gcplayer_mute
			call gcplayer_clear_buffers
			call __gcplayer_start
			ret

; uses to start a new song or to repeat a finished song
; ex. CALL_RAM_DISK_FUNC(__gcplayer_start_repeat, __RAM_DISK_S_GCPLAYER | __RAM_DISK_M_GCPLAYER | RAM_DISK_M_8F)
__gcplayer_start:
			call gcplayer_tasks_init
			call gcplayer_scheduler_init

			; set buffer_idx GC_PLAYER_TASKS bytes prior to the init unpacking addr (0),
			; to let zx0 unpack data for GC_PLAYER_TASKS number of regs
			; that means the music will be GC_PLAYER_TASKS number of frames delayed
			mvi a, -GC_PLAYER_TASKS
			sta gcplayer_buffer_idx
			mvi a, -1
			sta gcplayer_task_id

			call __gcplayer_unmute
			ret
			

; called by the unterruption routine
; ex. CALL_RAM_DISK_FUNC_NO_RESTORE(__gcplayer_update, __RAM_DISK_S_GCPLAYER | __RAM_DISK_M_GCPLAYER | RAM_DISK_M_8F)
__gcplayer_update:
			; return if muted
			lda setting_music
			cpi SETTING_ON
			rnz

			; handle the current task
			lxi h, gcplayer_task_id
			mov a, m
			inr a
			ani $f
			mov m, a
			; if the task idx is higher GC_PLAYER_TASKS number, skip it
			cpi GC_PLAYER_TASKS
			jnc @skip
			call gcplayer_scheduler_update
@skip:
			lxi h, gcplayer_buffer_idx
			inr m
			call gcplayer_ay_update
			ret
			

; bufferN[buffer_idx] data will be send to AY for each register accordingly
gcplayer_buffer_idx:
			.byte TEMP_BYTE
gcplayer_task_id:
			.byte TEMP_BYTE
			

;==========================================
; create a GCPlayerUnpack tasks
;
gcplayer_tasks_init:
			di
			lxi h, 0
			dad sp
			shld @restoreSP+1

			lxi sp, gsplayer_task_stack13 + GC_PLAYER_STACK_SIZE
			lxi d, GCPlayerAyRegDataPtrs + GC_PLAYER_TASKS * ADDR_LEN
			; b = 0, c = a task counter * 2
			lxi b, (GC_PLAYER_TASKS - 1) * ADDR_LEN
@loop:
			; store zx0 entry point to a task stack
			lxi h, GCPlayerUnpack
			push h
			; store the buffer addr to a task stack
			mov a, c
			rrc
			adi >gcplayer_buffer00
			mov h, a
			mov l, b
			push h
			; store the reg_data addr to a task stack
			xchg
			dcx h
			mov d, m
			dcx h
			mov e, m
			push d
			xchg
			; store taskSP to gsplayer_task_sps
			lxi h, gsplayer_task_sps
			dad b
			shld @storeTaskSP+1
			; move sp back 4 bytes to skip storing HL, PSW because zx0 doesnt use them to init
			LXI_H_NEG(WORD_LEN * 2)
			dad sp
@storeTaskSP:
			shld TEMP_ADDR
			; move SP to the previous task stack end
			LXI_H_NEG(GC_PLAYER_STACK_SIZE - WORD_LEN * 3)
			dad sp

			sphl
			dcr c
			dcr c
			jp @loop
@restoreSP: lxi sp, TEMP_ADDR
			ei 
			ret
			

; Set the current task stack pointer to the first task stack pointer
gcplayer_scheduler_init:
			lxi h, gsplayer_task_sps
			shld gsplayer_current_task_spp
			ret
			

; it clears the last 14 bytes of every buffer
; to prevent player to play gugbage data 
; when it repeats the current song or
; play a new one
gcplayer_clear_buffers:
			mvi h, >gcplayer_buffer00
			mvi a, (>gcplayer_buffer13) + 1
@next_buff:
			mvi l, -GC_PLAYER_TASKS
@loop:
			mvi m, 0
			inr l
			jnz @loop
			inr h	
			cmp h
			jnz @next_buff
			ret
			

; this func restores the context of the current task
; then calls GCPlayerUnpack to let it continue unpacking reg_data
; this code is performed during an interruption
gcplayer_scheduler_update:
			lxi h, 0
			dad sp
			shld GCPlayerSchedulerRestoreSp+1
			lhld gsplayer_current_task_spp
			mov e, m 
			inx h 
			mov d, m ; de = &gsplayer_task_sps[n]
			xchg
			sphl
			; restore a task context and return into it
			pop psw
			pop h
			pop d
			pop b
			; go to GCPlayerUnpack
			ret

; GCPlayerUnpack task calls this after unpacking 16 bytes.
; it stores all the registers of the current task
gcplayer_scheduler_store_task_context:
			push b
			push d
			push h
			push psw

			lxi h, 0 
			dad sp
			xchg
			lhld gsplayer_current_task_spp
			mov m, e 
			inx h 
			mov m, d 
			inx h
			mvi a, <gsplayer_task_sps_end
			cmp l
			jnz @storeNextTaskSp
			mvi a, >gsplayer_task_sps_end
			cmp h
			jnz @storeNextTaskSp
			; (gsplayer_current_task_spp) = gsplayer_task_sps[0]
			lxi h, gsplayer_task_sps
@storeNextTaskSp:
			shld gsplayer_current_task_spp
GCPlayerSchedulerRestoreSp:
			lxi sp, TEMP_ADDR
			ret
			

; unpacks 16 bytes of reg_data for the current task
; this function is called during an interruption
; Parameters (forward):
; DE: source address (compressed data)
; BC: destination address (decompressing)
; unpack every 16 bytes into a current task circular buffer, 
; then call gcplayer_scheduler_store_task_context
GCPlayerUnpack:
			lxi h, $ffff
			push h
			inx h
			mvi a, $80
@literals:
			call @Elias
			push psw
@Ldir1:
			ldax d
			stax b
			inx d					
			inr c 		; to stay inside the circular buffer
			; check if it's time to have a break
			mvi a, $0f
			ana c
			cz gcplayer_scheduler_store_task_context 

			dcx h
			mov a, h
			ora l
			jnz @Ldir1
			pop psw
			add a

			jc @new_offset
			call @Elias
@copy:
			xchg
			xthl
			push h
			dad b
			mov h, b ; to stay inside the circular buffer
			xchg

@ldirFromBuff:
			push psw
@ldirFromBuff1:
			ldax d
			stax b
			inr e		; to stay inside the circular buffer				
			inr c 		; to stay inside the circular buffer
			; check if it's time to have a break
			mvi a, $0f
			ana c
			cz gcplayer_scheduler_store_task_context 

			dcx h
			mov a, h
			ora l
			jnz @ldirFromBuff1
			mvi h, 0	; ----------- ???
			pop psw
			add a

			xchg
			pop h
			xthl
			xchg
			jnc @literals
@new_offset:
			call @Elias
			mov h, a
			pop psw
			xra a
			sub l
			jz @exit
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

@Elias:
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
			jmp @Elias

@exit:
			; the sond ended
			; restore sp
			lhld GCPlayerSchedulerRestoreSp+1
			sphl
			; restart the music
			call __gcplayer_start

			; pop gcplayer_scheduler_update return addr
			; to return right to the func that called __gcplayer_update
			pop psw			
			; return to the func that called __gcplayer_update
			ret
			
.macro CG_PLAYER_AY_UPDATE_REG(do_dcr = true)
			mov a, e
			out AY_PORT_REG

			ldax b
			out AY_PORT_DATA
		.if do_dcr
			dcr b
			dcr e
		.endif
.endmacro

; send buffers data to AY regs
; input:
; hl = buffer_idx
; if envelope shape reg13 data = $ff, then don't send data to reg13
; AY-3-8910 ports

gcplayer_ay_update:
			mvi e, GC_PLAYER_TASKS - 1
			mov c, m
			mvi b, (>gcplayer_buffer00) + GC_PLAYER_TASKS - 1
			ldax b
			cpi $ff
			jz @doNotSendEnvData
			CG_PLAYER_AY_UPDATE_REG(false) ; reg 13 (Envelope)
@doNotSendEnvData:
			dcr b
			dcr e
			CG_PLAYER_AY_UPDATE_REG() ; reg 12 (envelope FDIV H)
			CG_PLAYER_AY_UPDATE_REG() ; reg 11 (envelope FDIV L)
			CG_PLAYER_AY_UPDATE_REG() ; reg 10 (Vol C)
			CG_PLAYER_AY_UPDATE_REG() ; reg 9  (Vol B)
			CG_PLAYER_AY_UPDATE_REG() ; reg 8  (Vol A)
			CG_PLAYER_AY_UPDATE_REG() ; reg 7 (Mixer)
			CG_PLAYER_AY_UPDATE_REG() ; reg 6 (Noise FDIV)
			CG_PLAYER_AY_UPDATE_REG() ; reg 5 (Tone FDIV CHC H)
			CG_PLAYER_AY_UPDATE_REG() ; reg 4 (Tone FDIV CHC L)
			CG_PLAYER_AY_UPDATE_REG() ; reg 3 (Tone FDIV CHB H)
			CG_PLAYER_AY_UPDATE_REG() ; reg 2 (Tone FDIV CHB L)
			CG_PLAYER_AY_UPDATE_REG() ; reg 1 (Tone FDIV CHA H)
			CG_PLAYER_AY_UPDATE_REG() ; reg 0 (Tone FDIV CHA L)

@doNotSendData:						
			ret
			
; to mute the player. It can continue the song after unmute
; to call from this module: call __gcplayer_mute
; to call outside: CALL_RAM_DISK_FUNC(__gcplayer_mute, __RAM_DISK_S_GCPLAYER | __RAM_DISK_M_GCPLAYER | RAM_DISK_M_8F)
__gcplayer_mute:
			; disable the updates
			mvi a, SETTING_OFF
			sta setting_music
			; set zeros to AY regs to mute it
			mvi e, GC_PLAYER_TASKS - 1
@send_data:
			mov a, e
			out AY_PORT_REG
			xra a
			out AY_PORT_DATA
			dcr e
			jp @send_data
			ret
			
; to unmute the player after being muted. It continues the song from where it has been stopped
; to call from this module: call __gcplayer_unmute
; to call outside: CALL_RAM_DISK_FUNC(__gcplayer_unmute, __RAM_DISK_S_GCPLAYER | __RAM_DISK_M_GCPLAYER | RAM_DISK_M_8F)
__gcplayer_unmute:
			mvi a, SETTING_ON
			sta setting_music
			ret

; to flip mute/unmute
; to call from this module: call __gcplayer_flip_mute
; to call outside: CALL_RAM_DISK_FUNC(__gcplayer_flip_mute, __RAM_DISK_S_GCPLAYER | __RAM_DISK_M_GCPLAYER | RAM_DISK_M_8F)
__gcplayer_flip_mute:
			lxi h, setting_music
			mov a, m
			cma
			mov m, a
			cpi SETTING_OFF
			jz __gcplayer_mute
			jmp __gcplayer_unmute

; return setting_music value
; to call from this module: call __gcplayer_get_setting
; to call outside: CALL_RAM_DISK_FUNC(__gcplayer_get_setting, __RAM_DISK_S_GCPLAYER | __RAM_DISK_M_GCPLAYER | RAM_DISK_M_8F)
; out:
; c - setting_music value
__gcplayer_get_setting:
			lda setting_music
			mov c, a
			ret