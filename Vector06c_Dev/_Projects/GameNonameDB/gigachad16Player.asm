; gigachad16 player
; info/credits:
; music has to be compressed into 14 buffers each for every register
; this player decompresses and plays 14 parallel streams.
; Only one task is executed each frame that decompresses 16 bytes for one of the ay registers.
; cpu load: 5-20 of 312 scanlines per a frame
; original player code was written by svofski 2022
; original zx0 decompression code was written by ivagor 2022

GCPlayerInit:
			call GCPlayerMute
			call GCPlayerClearBuffers
			ret

GCPlayerStartRepeat:
			lda GCPlayerUpdate
			ora a
			rz

			call GCPlayerTasksInit
			call GCPlayerSchedulerInit

			; set bufferIdx GC_PLAYER_TASKS bytes prior to the init unpacking addr (0),
			; to let zx0 unpack data for GC_PLAYER_TASKS number of regs
			; that means the music will be GC_PLAYER_TASKS number of frames delayed
			mvi a, -GC_PLAYER_TASKS
			sta GCPlayerBufferIdx
			mvi a, -1
			sta GCPlayerTaskId
			; turn on the updates
			xra a
			sta GCPlayerUpdate
			ret
			.closelabels

; this function has to be called from an unterruption routine
GCPlayerUpdate:
			; ret will be replaced with NOP when the player inited
			ret
			; handle the current task
			lxi h, GCPlayerTaskId
			mov a, m
			inr a
			ani $f
			mov m, a
			; if the task idx is higher GC_PLAYER_TASKS number, skip it
			cpi GC_PLAYER_TASKS
			jnc @skip
			call GCPlayerSchedulerUpdate
@skip:
			lxi h, GCPlayerBufferIdx
			inr m
			call GCPlayerAYUpdate
			ret
			.closelabels

; bufferN[bufferIdx] data will be send to AY for each register accordingly
GCPlayerBufferIdx:
			.byte TEMP_BYTE
GCPlayerTaskId:
			.byte TEMP_BYTE
			.closelabels

;==========================================
; create a GCPlayerUnpack tasks
;
GCPlayerTasksInit:
			di
			lxi h, 0
			dad sp
			shld @restoreSp+1
			; no need to restore because "di" above
			RAM_DISK_ON_NO_RESTORE(RAM_DISK0_B1_STACK_RAM)

			lxi sp, GCPlayerTaskStack13 + GC_PLAYER_STACK_SIZE
			lxi d, GCPlayerAyRegDataPtrs + GC_PLAYER_TASKS * WORD_LEN
			; b = 0, c = a task counter * 2
			lxi b, (GC_PLAYER_TASKS - 1) * WORD_LEN
@loop:
			; store zx0 entry point to a task stack
			lxi h, GCPlayerUnpack
			push h
			; store the buffer addr to a task stack
			mov a, c
			rrc
			adi >GCPlayerBuffer00
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
			lxi h, $ffff - WORD_LEN * 2 + 1
			dad sp
@storeTaskSP:
			shld TEMP_ADDR
			; move SP to the previous task stack end
			lxi h, $ffff - GC_PLAYER_STACK_SIZE + WORD_LEN * 3 + 1
			dad sp

			sphl
			dcr c
			dcr c
			jp @loop
@restoreSp: lxi sp, TEMP_ADDR
			RAM_DISK_OFF_NO_RESTORE()
			ei 
			ret
			.closelabels

; Set the current task stack pointer to the first task stack pointer
GCPlayerSchedulerInit:
			RAM_DISK_ON(RAM_DISK0_B1_RAM)
			lxi h, GCPlayerTaskSPs
			shld GCPlayerCurrentTaskSPp
			RAM_DISK_OFF()
			ret
			.closelabels

; clear the last 14 bytes of every buffer
; to prevent player to play gugbage data 
; when it repeats the current song or
; play a new one
GCPlayerClearBuffers:
			RAM_DISK_ON(RAM_DISK0_B1_RAM)
			mvi h, >GCPlayerBuffer00
			mvi a, (>GCPlayerBuffer13) + 1
@nextBuff:
			mvi l, -GC_PLAYER_TASKS
@loop:
			mvi m, 0
			inr l
			jnz @loop
			inr h	
			cmp h
			jnz @nextBuff
			RAM_DISK_OFF()			
			ret
			.closelabels

; this func restores the context of the current task
; then calls GCPlayerUnpack to let it continue unpacking regData
; this code is performed during an interruption
GCPlayerSchedulerUpdate:
			lxi h, 0
			dad sp
			shld GCPlayerSchedulerRestoreSp+1
			RAM_DISK_ON_NO_RESTORE(RAM_DISK0_B1_STACK_RAM)
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
GCPlayerSchedulerStoreTaskContext:
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
			RAM_DISK_OFF_NO_RESTORE()
			ret
			.closelabels

; unpacks 16 bytes of regData for the current task
; this function is called during an interruption
; Parameters (forward):
; DE: source address (compressed data)
; BC: destination address (decompressing)
; unpack every 16 bytes into a current task circular buffer, 
; then call GCPlayerSchedulerStoreTaskContext
GCPlayerUnpack:
		lxi h, $ffff
		push h
		inx h
		mvi a, $80
@dzx0literals:
		call @dzx0Elias
		push psw
@dzx0Ldir1:
		ldax d
		stax b
		inx d					
		inr c 		; to stay inside the circular buffer
		; check if it's time to
		mvi a, $0f
		ana c
		cz GCPlayerSchedulerStoreTaskContext 

		dcx h
		mov a, h
		ora l
		jnz @dzx0Ldir1
		pop psw
		add a

		jc @dzx0newOffset
		call @dzx0Elias
@dzx0copy:
		xchg
		xthl
		push h
		dad b
		mov h, b ; to stay inside the circular buffer
		xchg

@dzx0ldirFromBuff:
		push psw
@dzx0ldirFromBuff1:
		ldax d
		stax b
		inr e		; to stay inside the circular buffer				
		inr c 		; to stay inside the circular buffer
		; check if it's time to
		mvi a, $0f
		ana c
		cz GCPlayerSchedulerStoreTaskContext 

		dcx h
		mov a, h
		ora l
		jnz @dzx0ldirFromBuff1
		mvi h, 0	; ----------- ???
		pop psw
		add a

		xchg
		pop h
		xthl
		xchg
		jnc @dzx0literals
@dzx0newOffset:
		call @dzx0Elias
		mov h, a
		pop psw
		xra a
		sub l
		jz @dzx0exit
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
		cnc @dzx0eliasBacktrack
		inx h
		jmp @dzx0copy

@dzx0Elias:
		inr l
@dzx0eliasLoop:	
		add a
		jnz @dzx0eliasSkip
		ldax d
		inx d
		ral
@dzx0eliasSkip:
		rc
@dzx0eliasBacktrack:
		dad h
		add a
		jnc @dzx0eliasLoop
		jmp @dzx0Elias

@dzx0exit:
		; restore sp
		lhld GCPlayerSchedulerRestoreSp+1
		sphl
		; pop GCPlayerSchedulerUpdate return addr 
		; to return right to the func that called GCPlayerUpdate
		pop psw
		; turn off the current music
		mvi a, OPCODE_RET
		sta GCPlayerUpdate
		RAM_DISK_OFF_NO_RESTORE()
		; return to the func that called GCPlayerUpdate		
		ret
		.closelabels
		
; send buffers data to AY regs
; this code is performed during an interruption
; input:
; hl = bufferIdx
; reg13 (envelope shape) data = $ff means don't send data to reg13
; AY-3-8910 ports
AY_PORT_REG		= $15
AY_PORT_DATA	= $14

GCPlayerAYUpdate:
			RAM_DISK_ON_NO_RESTORE(RAM_DISK0_B1_RAM)
			mvi e, GC_PLAYER_TASKS - 1
			mov c, m
			mvi b, (>GCPlayerBuffer00) + GC_PLAYER_TASKS - 1
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
			RAM_DISK_OFF_NO_RESTORE()
			ret
			.closelabels

GCPlayerMute:
			mvi e, GC_PLAYER_TASKS - 1
@sendData:
			mov a, e
			out AY_PORT_REG
			mvi a, 0
			out AY_PORT_DATA
			dcr e
			jp @sendData
			ret
			.closelabels