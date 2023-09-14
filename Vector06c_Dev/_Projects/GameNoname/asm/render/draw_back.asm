;----------------------------------------------------------------
; draw a background sprite without an alpha channel (8xN, 16xN pixels)
; input:
; bc - back sprite data addr
; de - screen addr, d=[$80, $9f]
; use: a, hl, sp

; data format:
; .word - two safety bytes to prevent a data corruption by the interruption  func
; .byte - height
; .byte - width
; 		0 - one byte width, 
;		1 - two bytes width, 
; pixel format:
; odd_line:
; 1st screen buff : 1 -> 2
; 2nd screen buff : 4 <- 3
; 3rd screen buff : 6 <- 5
; 4rd screen buff : 8 <- 7
; y++
; even_line:
; 4rd screen buff : 9 -> 10
; 3nd screen buff : 12 <- 11
; 2st screen buff : 14 <- 13
; 1st screen buff : 16 <- 15
; y++
; repeat for the next lines of the art data

draw_back_v:
			; store sp
			lxi h, $0000
			dad sp
			shld @restore_sp + 1
			; bc - decal sprite data addr			
			mov h, b
			mov l, c
			sphl
			xchg
			pop b
			; b - offset_x
			; c - offset_y
			; hl - scr addr					
			dad b
			pop b

			mov d, c
			A_TO_ZERO(NULL_BYTE)
			cmp b
			jnz @drawWidth16
@drawWidth8:			
; TODO: support width = 8
			jmp @restore_sp

; hl - scr addr
; sp - pixel data
; d - height

@width16 = 2
@drawWidth16:
			mov a, h
			adi @width16-1
			sta @scr82 + 1
			adi $20
			sta @scrA + 1
			sta @scrA2 + 1
			adi $20
			mov e, a
			adi $20

@odd_line:
@scr8:
			pop b					
			mov m, c				
			inr h					
			mov m, b				
@scrA:		mvi h, TEMP_BYTE		

			pop b					
			mov m, c				
			dcr h					
			mov m, b				
@scrC:		mov h, e				

			pop b					
			mov m, c				
			dcr h					
			mov m, b				
@scrE:		mov h, a				

			pop b					
			mov m, c				
			dcr h					
			mov m, b				
			
			inr l
			dcr d
			jz @restore_sp

@even_line:
@scrE2:
			pop b					
			mov m, c				
			inr h					
			mov m, b				
@scrC2:		mov h, e				

			pop b					
			mov m, c				
			dcr h					
			mov m, b				
@scrA2:		mvi h, TEMP_BYTE		

			pop b					
			mov m, c				
			dcr h					
			mov m, b				
@scr82:		mvi h, TEMP_BYTE		

			pop b					
			mov m, c				
			dcr h					
			mov m, b			
			
			inr l
			dcr d
			jnz @odd_line			

@restore_sp:		
			lxi sp, TEMP_ADDR
			ret