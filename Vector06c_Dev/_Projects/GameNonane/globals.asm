; prefixes
; ADDR - address
; INT - interruption
; SCR - screen
; MEM - memory
; LEN - length
; SEC - seconds
; RES - result

; consts
PORT0_OUT_OUT			= $88
PORT0_OUT_IN			= $8a

JMP_OPCODE				= $0C3

RESTART_ADDR 			= 0000
INT_ADDR	 			= $0038
STACK_ADDR				= $7F80
STACK_TEMP_ADDR			= $8000 ; is used for iterruption2

TEMP_ADDR				= $0000
TEMP_BYTE				= $00
TEMP_WORD				= $0000

; key codes
KEY_LEFT				= %11101111
KEY_UP					= %11011111
KEY_RIGHT				= %10111111
KEY_DOWN				= %01111111

