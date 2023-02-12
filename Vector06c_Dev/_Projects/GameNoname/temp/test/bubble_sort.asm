			.org 100h
			di
			jmp start

			.org 200h
array:
			.db 2, 1, 4, 0, 9
length 		.equ 5

start:
			mvi b, length - 1

outer_loop:
			lxi h, array
			mov c, b
inner_loop:
			mov a, m
			inx h
			mov e, m
			cmp e
			jnc skip
swap:
			mov m, a
			dcx h
			mov m, e
			inx h

skip:
			dcr c
			jnz inner_loop
			
			dcr b
			jnz outer_loop

end:
			jmp end
			.end
