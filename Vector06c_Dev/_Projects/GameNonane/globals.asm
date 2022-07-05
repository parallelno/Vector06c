; prefixes
; ADDR - address
; INT - interruption
; SCR - screen
; MEM - memory
; LEN - length
; SEC - seconds
; RES - result

; global
PORT0_OUT_OUT			= $88

JMP_OPCODE				= $0C3

RESTART_ADDR 			= 0000
INT_ADDR	 			= $0038
STACK_ADDR				= $7F80
STACK_TEMP_ADDR			= $8000 ; is used for iterruption2

TEMP_ADDR				= $0000

SCR_BUFF_LEN			= $2000
SCR_MEM_LEN				= $8000

TEMP_BYTE               = $00
TEMP_WORD				= $0000
INT_TICKS_PER_SEC		= 50