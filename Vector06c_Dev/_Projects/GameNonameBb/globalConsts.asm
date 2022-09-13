; prefixes
; ADDR - address
; INT - interruption
; SCR - screen
; MEM - memory
; LEN - length
; SEC - seconds
; RES - result

; debug
SHOW_CPU_HIGHLOAD_ON_BORDER = false


; interuptions per sec
INTS_PER_SEC			= 50

; consts
PORT0_OUT_OUT			= $88
PORT0_OUT_IN			= $8a

RESTART_ADDR 			= $0000
INT_ADDR	 			= $0038
STACK_MIN_ADDR          = $7f00
STACK_MAIN_PROGRAM_ADDR	= $8000-2 ; because erease funcs can let interruption func erases $7ffe, @7fff bytes.
STACK_INTERRUPTION_ADDR	= $7F80 ; it is used for iterruption2 func

BYTE_LEN                = 1
WORD_LEN                = 2

TEMP_ADDR				= $0000
TEMP_BYTE				= $00
TEMP_WORD				= $0000

; key codes
KEY_LEFT				= %11101111
KEY_LEFT_UP				= %11001111
KEY_LEFT_DOWN			= %01101111
KEY_UP					= %11011111
KEY_RIGHT				= %10111111
KEY_RIGHT_UP			= %10011111
KEY_RIGHT_DOWN			= %00111111
KEY_DOWN				= %01111111

; levels
TILE_WIDTH = 16
TILE_WIDTH_B = 2
TILE_HEIGHT = 16
ROOM_WIDTH = 16
ROOM_HEIGHT = 15
ROOM_X = 0
ROOM_Y = $FF - ROOM_HEIGHT
ROOM_SCR_ADDR = $80 + ROOM_X + ROOM_Y

; sprite
ROT_TIMER_0p125 = %0000_0001 ; that timer is rotated to the right.
ROT_TIMER_0p25	= %0001_0001 ; it will trigger something when the lowest bit is 1
ROT_TIMER_0p5	= %0101_0101 ; this value means that something will happen every second frame
ROT_TIMER_0p75	= %1101_1101
ROT_TIMER_1p0	= %1111_1111
;ROT_TIMER_ONCE	= %0000_0011 ; draw just once. useful for idle anims
;ROT_TIMER_NOP	= %0000_0000 ; no draw

; to support monster two-interations rendering.
; the first interation draws sprites with Y>MONSTER_DRAW_Y_THRESHOLD
; the second one draws sprites with Y<=MONSTER_DRAW_Y_THRESHOLD
; that is to avoid tearing happens when a screen ray catchs up the place where a sprite is being rendering.
MONSTER_DRAW_Y_THRESHOLD = 160 

SPRITE_X_SCR_ADDR = $a0

RAM_DISK0_B0_STACK  = %00011100
RAM_DISK0_B1_STACK  = %00011000
RAM_DISK0_B2_STACK  = %00010100
RAM_DISK0_B3_STACK  = %00010000
RAM_DISK0_B0_RAM = %00100011
RAM_DISK0_B1_RAM = %00100010
RAM_DISK0_B2_RAM = %00100001
RAM_DISK0_B3_RAM = %00100000
; to copy music to ram-disk, to play music
RAM_DISK0_B1_STACK_RAM = %00111010
; to render sprites back buff
RAM_DISK0_B0_STACK_B2_AF_RAM = %10111101
; to erase sprites
RAM_DISK0_B2_STACK_B2_AF_RAM = %10110101

SEGMENT_0000_7F00_ADDR = 0x0000
SEGMENT_8000_0000_ADDR = 0x8000

SEGMENT_0000_7F00_SIZE_MAX = 2 ^ 31 - 256 ; because an interruption can corrupt the ram-disk memory from STACK_MIN_ADDR = $7f00 to STACK_TEMP_ADDR = $8000
SEGMENT_8000_0000_SIZE_MAX = 2 ^ 31

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
OPCODE_POP_B = $C1
OPCODE_STC	= $37

HERO_DRAW_TOP = OPCODE_RNC
HERO_DRAW_BOTTOM = OPCODE_RC
