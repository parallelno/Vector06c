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

; ex. CALL_RAM_DISK_FUNC(__gcplayer_init, __RAM_DISK_M_GCPLAYER | RAM_DISK_M_8F)
__gcplayer_init:
			call gcplayer_mute
			call gcplayer_clear_buffers
			ret

; ex. CALL_RAM_DISK_FUNC(__gcplayer_start_repeat, __RAM_DISK_S_GCPLAYER | __RAM_DISK_M_GCPLAYER | RAM_DISK_M_8F)
__gcplayer_start_repeat:
			lda __gcplayer_update 
			ora a
			rz

			call gcplayer_tasks_init
			call gcplayer_scheduler_init

			; set bufferIdx GC_PLAYER_TASKS bytes prior to the init unpacking addr (0),
			; to let zx0 unpack data for GC_PLAYER_TASKS number of regs
			; that means the music will be GC_PLAYER_TASKS number of frames delayed
			mvi a, -GC_PLAYER_TASKS
			sta gcplayer_buffer_idx
			mvi a, -1
			sta gcplayer_task_id
			; turn on the updates
			xra a
			sta __gcplayer_update
			ret
			

; this function has to be called from an unterruption routine
; ex. CALL_RAM_DISK_FUNC_NO_RESTORE(__gcplayer_update, __RAM_DISK_S_GCPLAYER | __RAM_DISK_M_GCPLAYER | RAM_DISK_M_8F)
__gcplayer_update:
			; ret will be replaced with NOP when the player inited
			ret
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
			

; bufferN[bufferIdx] data will be send to AY for each register accordingly
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

			lxi sp, GCPlayerTaskStack13 + GC_PLAYER_STACK_SIZE
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
			; store the regData addr to a task stack
			xchg
			dcx h
			mov d, m
			dcx h
			mov e, m
			push d
			xchg
			; store taskSP to GCPlayerTaskSPs
			lxi h, GCPlayerTaskSPs
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
			lxi h, GCPlayerTaskSPs
			shld GCPlayerCurrentTaskSPp
			ret
			

; it clears the last 14 bytes of every buffer
; to prevent player to play gugbage data 
; when it repeats the current song or
; play a new one
gcplayer_clear_buffers:
			mvi h, >gcplayer_buffer00
			mvi a, (>gcplayer_buffer13) + 1
@nextBuff:
			mvi l, -GC_PLAYER_TASKS
@loop:
			mvi m, 0
			inr l
			jnz @loop
			inr h	
			cmp h
			jnz @nextBuff
			ret
			

; this func restores the context of the current task
; then calls GCPlayerUnpack to let it continue unpacking regData
; this code is performed during an interruption
gcplayer_scheduler_update:
			lxi h, 0
			dad sp
			shld GCPlayerSchedulerRestoreSp+1
			lhld GCPlayerCurrentTaskSPp
			mov e, m 
			inx h 
			mov d, m ; de = &GCPlayerTaskSPs[n]
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
			lhld GCPlayerCurrentTaskSPp
			mov m, e 
			inx h 
			mov m, d 
			inx h
			mvi a, <GCPlayerTaskSPsEnd
			cmp l
			jnz @storeNextTaskSp
			mvi a, >GCPlayerTaskSPsEnd
			cmp h
			jnz @storeNextTaskSp
			; (GCPlayerCurrentTaskSPp) = GCPlayerTaskSPs[0]
			lxi h, GCPlayerTaskSPs
@storeNextTaskSp:
			shld GCPlayerCurrentTaskSPp
GCPlayerSchedulerRestoreSp:
			lxi sp, TEMP_ADDR
			ret
			

; unpacks 16 bytes of regData for the current task
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

			jc @newOffset
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
@newOffset:
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
			cnc @eliasBacktrack
			inx h
			jmp @copy

@Elias:
			inr l
@eliasLoop:	
			add a
			jnz @eliasSkip
			ldax d
			inx d
			ral
@eliasSkip:
			rc
@eliasBacktrack:
			dad h
			add a
			jnc @eliasLoop
			jmp @Elias

@exit:
			; restore sp
			lhld GCPlayerSchedulerRestoreSp+1
			sphl
			; pop gcplayer_scheduler_update return addr 
			; to return right to the func that called __gcplayer_update
			pop psw
			; turn off the current music
			mvi a, OPCODE_RET
			sta __gcplayer_update
			; return to the func that called __gcplayer_update		
			ret
			
		
; send buffers data to AY regs
; this code is performed during an interruption
; input:
; hl = bufferIdx
; reg13 (envelope shape) data = $ff means don't send data to reg13
; AY-3-8910 ports
AY_PORT_REG		= $15
AY_PORT_DATA	= $14

gcplayer_ay_update:
			mvi e, GC_PLAYER_TASKS - 1
			mov c, m
			mvi b, (>gcplayer_buffer00) + GC_PLAYER_TASKS - 1
			ldax b
			cpi $ff
			jz @doNotSendData
@sendData:
			mov a, e
			out AY_PORT_REG
			ldax b
			out AY_PORT_DATA
@doNotSendData:
			dcr b
			dcr e
			jp @sendData
			ret
			

gcplayer_mute:
			mvi e, GC_PLAYER_TASKS - 1
@sendData:
			mov a, e
			out AY_PORT_REG
			mvi a, 0
			out AY_PORT_DATA
			dcr e
			jp @sendData
			ret
			