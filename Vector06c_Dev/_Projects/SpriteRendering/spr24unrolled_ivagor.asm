;развернутая версия процедуры вывода спрайта
;ширина спрайта 24 точки
;на входе
;bc адрес спрайта
;de aдрес на экране 
;E-Y D-X 

spr24:
	lxi h,0
	dad sp
	shld spr24sp+1
	mov h,b
	mov l,c
	mov c,m
	inx h
	mov b,m
	inx h
	sphl
	
	xchg
	mov d,h
	mvi a,20h
	add d
	mov e,a
	mvi a,20h
	add e
	inr h\ inr h
spr24loop:
;1я строка
	mov m,c\ dcr h\ mov m,b\ dcr h\ pop b\ mov m,c
	mov h,e\ mov m,b\ inr h\ pop b\ mov m,c\ inr h\ mov m,b
	mov h,a\ pop b\ mov m,c\ inr h\ mov m,b\ inr h\ pop b\ mov m,c
	dcr l
;2я строка
	mov m,b\ dcr h\ pop b\ mov m,c\ dcr h\ mov m,b
	mov h,e\ pop b\ mov m,c\ inr h\ mov m,b\ inr h\ pop b\ mov m,c
	mov h,d\ mov m,b\ inr h\ pop b\ mov m,c\ inr h\ mov m,b
	dcr l

;3я строка
	pop b\ mov m,c\ dcr h\ mov m,b\ dcr h\ pop b\ mov m,c
	mov h,e\ mov m,b\ inr h\ pop b\ mov m,c\ inr h\ mov m,b
	mov h,a\ pop b\ mov m,c\ inr h\ mov m,b\ inr h\ pop b\ mov m,c
	dcr l
;4я строка
	mov m,b\ dcr h\ pop b\ mov m,c\ dcr h\ mov m,b
	mov h,e\ pop b\ mov m,c\ inr h\ mov m,b\ inr h\ pop b\ mov m,c
	mov h,d\ mov m,b\ inr h\ pop b\ mov m,c\ inr h\ mov m,b
	dcr l

;5я строка
	pop b\ mov m,c\ dcr h\ mov m,b\ dcr h\ pop b\ mov m,c
	mov h,e\ mov m,b\ inr h\ pop b\ mov m,c\ inr h\ mov m,b
	mov h,a\ pop b\ mov m,c\ inr h\ mov m,b\ inr h\ pop b\ mov m,c
	dcr l
;6я строка
	mov m,b\ dcr h\ pop b\ mov m,c\ dcr h\ mov m,b
	mov h,e\ pop b\ mov m,c\ inr h\ mov m,b\ inr h\ pop b\ mov m,c
	mov h,d\ mov m,b\ inr h\ pop b\ mov m,c\ inr h\ mov m,b
	dcr l	

;7я строка
	pop b\ mov m,c\ dcr h\ mov m,b\ dcr h\ pop b\ mov m,c
	mov h,e\ mov m,b\ inr h\ pop b\ mov m,c\ inr h\ mov m,b
	mov h,a\ pop b\ mov m,c\ inr h\ mov m,b\ inr h\ pop b\ mov m,c
	dcr l
;8я строка
	mov m,b\ dcr h\ pop b\ mov m,c\ dcr h\ mov m,b
	mov h,e\ pop b\ mov m,c\ inr h\ mov m,b\ inr h\ pop b\ mov m,c
	mov h,d\ mov m,b\ inr h\ pop b\ mov m,c\ inr h\ mov m,b
	dcr l	

;9я строка
	pop b\ mov m,c\ dcr h\ mov m,b\ dcr h\ pop b\ mov m,c
	mov h,e\ mov m,b\ inr h\ pop b\ mov m,c\ inr h\ mov m,b
	mov h,a\ pop b\ mov m,c\ inr h\ mov m,b\ inr h\ pop b\ mov m,c
	dcr l
;10я строка
	mov m,b\ dcr h\ pop b\ mov m,c\ dcr h\ mov m,b
	mov h,e\ pop b\ mov m,c\ inr h\ mov m,b\ inr h\ pop b\ mov m,c
	mov h,d\ mov m,b\ inr h\ pop b\ mov m,c\ inr h\ mov m,b
	dcr l	

;11я строка
	pop b\ mov m,c\ dcr h\ mov m,b\ dcr h\ pop b\ mov m,c
	mov h,e\ mov m,b\ inr h\ pop b\ mov m,c\ inr h\ mov m,b
	mov h,a\ pop b\ mov m,c\ inr h\ mov m,b\ inr h\ pop b\ mov m,c
	dcr l
;12я строка
	mov m,b\ dcr h\ pop b\ mov m,c\ dcr h\ mov m,b
	mov h,e\ pop b\ mov m,c\ inr h\ mov m,b\ inr h\ pop b\ mov m,c
	mov h,d\ mov m,b\ inr h\ pop b\ mov m,c\ inr h\ mov m,b
	dcr l	

;13я строка
	pop b\ mov m,c\ dcr h\ mov m,b\ dcr h\ pop b\ mov m,c
	mov h,e\ mov m,b\ inr h\ pop b\ mov m,c\ inr h\ mov m,b
	mov h,a\ pop b\ mov m,c\ inr h\ mov m,b\ inr h\ pop b\ mov m,c
	dcr l
;14я строка
	mov m,b\ dcr h\ pop b\ mov m,c\ dcr h\ mov m,b
	mov h,e\ pop b\ mov m,c\ inr h\ mov m,b\ inr h\ pop b\ mov m,c
	mov h,d\ mov m,b\ inr h\ pop b\ mov m,c\ inr h\ mov m,b
	dcr l	

;15я строка
	pop b\ mov m,c\ dcr h\ mov m,b\ dcr h\ pop b\ mov m,c
	mov h,e\ mov m,b\ inr h\ pop b\ mov m,c\ inr h\ mov m,b
	mov h,a\ pop b\ mov m,c\ inr h\ mov m,b\ inr h\ pop b\ mov m,c
	dcr l
;16я строка
	mov m,b\ dcr h\ pop b\ mov m,c\ dcr h\ mov m,b
	mov h,e\ pop b\ mov m,c\ inr h\ mov m,b\ inr h\ pop b\ mov m,c
	mov h,d\ mov m,b\ inr h\ pop b\ mov m,c\ inr h\ mov m,b
	dcr l	

;17я строка
	pop b\ mov m,c\ dcr h\ mov m,b\ dcr h\ pop b\ mov m,c
	mov h,e\ mov m,b\ inr h\ pop b\ mov m,c\ inr h\ mov m,b
	mov h,a\ pop b\ mov m,c\ inr h\ mov m,b\ inr h\ pop b\ mov m,c
	dcr l
;18я строка
	mov m,b\ dcr h\ pop b\ mov m,c\ dcr h\ mov m,b
	mov h,e\ pop b\ mov m,c\ inr h\ mov m,b\ inr h\ pop b\ mov m,c
	mov h,d\ mov m,b\ inr h\ pop b\ mov m,c\ inr h\ mov m,b
	dcr l	

;19я строка
	pop b\ mov m,c\ dcr h\ mov m,b\ dcr h\ pop b\ mov m,c
	mov h,e\ mov m,b\ inr h\ pop b\ mov m,c\ inr h\ mov m,b
	mov h,a\ pop b\ mov m,c\ inr h\ mov m,b\ inr h\ pop b\ mov m,c
	dcr l
;20я строка
	mov m,b\ dcr h\ pop b\ mov m,c\ dcr h\ mov m,b
	mov h,e\ pop b\ mov m,c\ inr h\ mov m,b\ inr h\ pop b\ mov m,c
	mov h,d\ mov m,b\ inr h\ pop b\ mov m,c\ inr h\ mov m,b
	dcr l	

;21я строка
	pop b\ mov m,c\ dcr h\ mov m,b\ dcr h\ pop b\ mov m,c
	mov h,e\ mov m,b\ inr h\ pop b\ mov m,c\ inr h\ mov m,b
	mov h,a\ pop b\ mov m,c\ inr h\ mov m,b\ inr h\ pop b\ mov m,c
	dcr l
;22я строка
	mov m,b\ dcr h\ pop b\ mov m,c\ dcr h\ mov m,b
	mov h,e\ pop b\ mov m,c\ inr h\ mov m,b\ inr h\ pop b\ mov m,c
	mov h,d\ mov m,b\ inr h\ pop b\ mov m,c\ inr h\ mov m,b
	dcr l	

;23я строка
	pop b\ mov m,c\ dcr h\ mov m,b\ dcr h\ pop b\ mov m,c
	mov h,e\ mov m,b\ inr h\ pop b\ mov m,c\ inr h\ mov m,b
	mov h,a\ pop b\ mov m,c\ inr h\ mov m,b\ inr h\ pop b\ mov m,c
	dcr l
;24я строка
	mov m,b\ dcr h\ pop b\ mov m,c\ dcr h\ mov m,b
	mov h,e\ pop b\ mov m,c\ inr h\ mov m,b\ inr h\ pop b\ mov m,c
	mov h,d\ mov m,b\ inr h\ pop b\ mov m,c\ inr h\ mov m,b

spr24sp:
	lxi sp,0
	ret
	
	.end