; Registers usage:
; B - output buffer position
; H - input buffer position
; D - temporary storage for length
; E - temporary storage for offset

START:

			; Load input buffer position (0x3000)
			;LXI H, 0x3000

			; Load output buffer position (0x4000)
			;LXI B, 0x4000

; Main loop
MAIN_LOOP:

			; Read byte from input buffer
MOV A, M

; Increment input buffer position
INX H

; Check if it's a literal byte or part of a length-offset pair
ANI 0x80
JZ LITERAL_BYTE

; It's a length-offset pair
; Extract length (4 bits) and add the minimum match length
MOV D, A
ANI 0x0F
ADI 0x03

; Read the second byte from input buffer (12 bits for offset)
MOV E, M

; Increment input buffer position
INX H

; Shift the first byte's lower 4 bits to the left
CALL SWAP_UPPER_LOWER
MOV D, A

; Combine offset from both bytes
ORA E
MOV E, A

; Copy bytes from the output buffer
COPY_LOOP:
PUSH B
LXI D, -1
DAD D
MOV A, M
POP B
STAX B
INX B
DCR E
JNZ COPY_LOOP

JMP MAIN_LOOP

LITERAL_BYTE:

; Write byte to the output buffer
STAX B

; Increment output buffer position
INX B

JMP MAIN_LOOP

; Helper function to swap upper and lower nibbles of the A register
SWAP_UPPER_LOWER:
XCHG
ANI 0x0F
XCHG
RRC
RRC
RRC
RRC
XCHG
ORA A
RET