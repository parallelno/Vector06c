; prefixes
; ADDR - address
; BUF - buffer
; INT - interruption
; SCR - screen buffer
; MEM - memory
; LEN - length
; SEC - second
; SEG - segment (a ram-disk is split into four 64K banks. each bank is split into two 32K segments.)
; RES - result
; PTR - pointer

; debug
SHOW_CPU_HIGHLOAD_ON_BORDER = false

; interuptions per sec
INTS_PER_SEC			= 50

; consts
PORT0_OUT_OUT			= $88
PORT0_OUT_IN			= $8a

RESTART_ADDR 			= $0000
INT_ADDR	 			= $0038
STACK_MIN_ADDR			= $7f00
STACK_MAIN_PROGRAM_ADDR	= $8000-2 ; because erase funcs can let interruption func erases $7ffe, @7fff bytes.
STACK_INTERRUPTION_ADDR	= $7F80 ; it is used for iterruption2 func
STACK_TMP_MAIN_PROGRAM_ADDR = $100

BYTE_LEN                = 1
WORD_LEN                = 2
ADDR_LEN                = 2

TEMP_BYTE				= $00
TEMP_WORD				= $0000
TEMP_ADDR				= $0000

; key codes
KEY_NO					= %11111111
KEY_LEFT				= %11101111
KEY_UP					= %11011111
KEY_RIGHT				= %10111111
KEY_DOWN				= %01111111
KEY_SPACE				= %01111111

; levels
TILE_WIDTH = 16
TILE_WIDTH_B = 2
TILE_HEIGHT = 16
ROOM_WIDTH = 16
ROOM_HEIGHT = 15

; screen buffer
SCR_ADDR				= $8000
SCR_BUFF0_ADDR			= $8000
SCR_BUFF1_ADDR			= $A000
SCR_BUFF2_ADDR			= $C000
SCR_BUFF3_ADDR			= $E000
SCR_BUFF_LEN            = $2000
BACK_BUFF_ADDR          = $8000
BACK_BUFF2_ADDR         = $8000

; sprite
SPRITE_X_SCR_ADDR		= >SCR_BUFF1_ADDR
SPRITE_SCR_BUFFS		= 3
SPRITE_W16				= 2
SPRITE_W24				= 3
SPRITE_W8_PACKED		= 0
SPRITE_W16_PACKED		= 1
SPRITE_W24_PACKED		= 2
SPRITE_W32_PACKED		= 3

; sprite preshift
SPRITE_PRESHIFT_H_MAX	= 24
SPRITES_PRESHIFTED_4	= 4
SPRITES_PRESHIFTED_8	= 8
; sprite copy to scr
SPRITE_COPY_TO_SCR_W_PACKED_MIN = SPRITE_W8_PACKED
SPRITE_COPY_TO_SCR_W_PACKED_MAX = SPRITE_W32_PACKED
SPRITE_COPY_TO_SCR_H_MIN = 5
SPRITE_COPY_TO_SCR_H_MAX = 20
; sprite min
SPRITE_W_PACKED_MIN		= SPRITE_COPY_TO_SCR_W_PACKED_MIN
SPRITE_H_MIN			= SPRITE_COPY_TO_SCR_H_MIN


; ram-disk
RAM_DISK_S0 = %00010000
RAM_DISK_S1 = %00010100
RAM_DISK_S2 = %00011000
RAM_DISK_S3 = %00011100

RAM_DISK_M0 = %00000000
RAM_DISK_M1 = %00000001
RAM_DISK_M2 = %00000010
RAM_DISK_M3 = %00000011

RAM_DISK_M_89 = %01000000
RAM_DISK_M_AD = %00100000
RAM_DISK_M_EF = %10000000
RAM_DISK_M_8F = RAM_DISK_M_89 | RAM_DISK_M_AD | RAM_DISK_M_EF

SEGMENT_0000_7F00_ADDR = 0x0000
SEGMENT_8000_0000_ADDR = 0x8000

SEGMENT_0000_7F00_SIZE_MAX = 2 ^ 31 - 256 ; because an interruption can corrupt the ram-disk memory from STACK_MIN_ADDR = $7f00 to STACK_TEMP_ADDR = $8000
SEGMENT_8000_0000_SIZE_MAX = 2 ^ 31

; to sort a list ob object to draw
DRAW_LIST_FIRST_DATA_MARKER = 0

; opcodes
OPCODE_NOP  = 0
OPCODE_XCHG = $eb
OPCODE_RET  = $c9
OPCODE_RC	= $d8
OPCODE_RNC  = $d0
OPCODE_JMP	= $C3
OPCODE_JC	= $DA
OPCODE_JNC	= $D2
OPCODE_MOV_E_M = $5e
OPCODE_MOV_E_A = $5f
OPCODE_MOV_D_B = $50
OPCODE_MOV_D_M = $56
OPCODE_MOV_D_A = $57
OPCODE_MOV_M_B = $70
OPCODE_MOV_M_A = $77
OPCODE_POP_B = $C1
OPCODE_STC	= $37
OPCODE_INX_D = $13