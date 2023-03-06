;----------------------------------------------------------------
; draw a background sprite without an alpha (8xN, 16xN pixels)
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
; 1st screen buff : 1 -> 2
; 2nd screen buff : 4 <- 3
; 3rd screen buff : 6 <- 5
; 4rd screen buff : 8 <- 7
; y++
; 4rd screen buff : 7 -> 8
; 3nd screen buff : 10 <- 9
; 2st screen buff : 12 <- 11
; 1st screen buff : 14 <- 13
; y++
; repeat for the next lines of the art data

draw_back_v:
			; store sp
			lxi h, $0000
			dad sp
			shld @restoreSP + 1
			; sp = BC
			mov h, b
			mov l, c
			sphl
			xchg
			; b - offset_x
			; c - offset_y
			pop b
			dad b
			pop b
			mov d, c
			xra a
			cmp b
			jnz @drawWidth16
@drawWidth8:			
; TODO: support width = 8
			jmp @restoreSP

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

@nextLine:
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
			jz @restoreSP
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
			jnz @nextLine			

@restoreSP:		
			lxi sp, TEMP_ADDR
			ret