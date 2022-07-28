; https://github.com/svofski/bazis-bbstro/tree/master/zx7mini
dzx7mini:
		mvi a,80h
copyby:
		mov c,m
		xchg
		mov m,c
		xchg
		inx d
mainlo:
		inx h
		add a
		cz getbitn
		jnc copyby
		mvi c,1
lenval:
		add a
		cz getbitn
		mov b,a
		mov a,c
		ral
		mov c,a
		rc
		mov a,b
		add a
		cz getbitn
		jnc lenval
		mov b,a
		push h
		mov a,e
		sbb m
		mov l,a
		mov a,d
		sbi 0           ; 42
		mov h,a
ldir:
		mov a,m
		stax d
		inx h
		inx d
		dcr c
		jnz ldir
		pop h
		mov a,b
		jmp mainlo
getbitn:
		mov a,m
		inx h
		adc a
		ret             ; 60