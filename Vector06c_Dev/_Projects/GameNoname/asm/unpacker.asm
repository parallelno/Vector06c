.setting "Debug", true
			.org	$100

.include "asm\\globals\\macro.asm"
.include "asm\\globals\\global_consts.asm"
; main_init must be the first code inclusion
;.include "asm\\globals\\main_init.asm"
			di
			RAM_DISK_OFF_NO_RESTORE()
			mvi a, OPCODE_JMP
			sta RESTART_ADDR
			sta INT_ADDR
			lxi h, main_start
			shld RESTART_ADDR + 1
			lxi sp, STACK_TMP_MAIN_PROGRAM_ADDR			
			jmp main_start

; TODO: split it to no used game data
//.include "asm\\globals\\global_vars.asm"
/*
.include "asm\\levels\\room_consts.asm" ; moved from a game.asm over here because of sone compilers issues. it was not able to find some consts


.include "asm\\globals\\controls.asm"
.include "asm\\globals\\interruptions.asm"
*/
; TODO: split it to no using palette
.include "asm\\globals\\utils_unpacker.asm"	; TODO: think of not including that codeagain in the main programm
.include "generated\\code\\ram_disk_init.asm"

//	.include "asm\\globals\\buffers.asm"
/*
.include "asm\\game_utils.asm"
.include "asm\\screens\\screen_utils.asm"
.include "asm\\screens\\main_menu.asm"
.include "asm\\screens\\credits.asm"
.include "asm\\screens\\scores.asm"
.include "asm\\screens\\settings.asm"
.include "asm\\screens\\stats.asm"
.include "asm\\game.asm"
.include "asm\\main_data.asm"
*/

COPY_MEM_FUNC_ADDR	= $80
MAIN_START		= $100
MAIN_LEN_MAX	= 32 * 1024

main_start:
			; preshift and copy data to the ram-disk
			call ram_disk_init

			; unpack the main programm to the scr buff			
			lxi d, main_asm
			lxi b, SCR_BUFF0_ADDR
			call dzx0

			; copy the copy_mem func to COPY_MEM_FUNC_ADDR
			lxi h, copy_mem
			lxi d, COPY_MEM_FUNC_ADDR
			lxi b, copy_mem_end - copy_mem
			call copy_mem

			; update loop addr
			lxi h, COPY_MEM_FUNC_ADDR
			shld COPY_MEM_FUNC_ADDR + copy_mem_loop_addr - copy_mem + 1
			; replace ret with nop to let the copy func start the game
			mvi a, OPCODE_JMP
			sta COPY_MEM_FUNC_ADDR + copy_mem_ret - copy_mem
			lxi h, SCR_BUFF0_ADDR
			lxi d, MAIN_START
			lxi b, MAIN_LEN_MAX
			call COPY_MEM_FUNC_ADDR
			

; copy a memory buffer
; input:
; hl - source
; de - destination
; bc - length
; use:
; a
copy_mem:
			mov a, m
			stax d
			inx h
			inx d
			dcx b

			mov a, c
			ora b
copy_mem_loop_addr:
			jnz copy_mem
copy_mem_ret:
			ret
			.word MAIN_START
copy_mem_end:

main_asm:
.incbin "generated\\bin\\main_asm.bin.zx0"

; TODO: remove that fake link
ram_disk_mode:
sprite_get_scr_addr8:
sprite_get_scr_addr4:

; the ram disk data below will be moved into the ram-disk before the game starts. 
; that means if it is stored at the end of the program, everything that goes
; to the ram-disk can overlap the screen addrs.
.include "generated\\code\\ram_disk_data_labels.asm"
.include "generated\\code\\ram_data.asm"
.include "generated\\code\\ram_disk_data.asm"

.end