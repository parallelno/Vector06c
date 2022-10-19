; ram-disk data has to keep the range from STACK_MIN_ADDR to STACK_MAIN_PROGRAM_ADDR-1 not used. 
; because it can be corrupted by the subroutines which manipulate the stack

toBank0addr0:
.incbin "generated\\bin\\ramDiskBank0_addr0.bin.zx0"


toBank2addr8000:
.incbin "generated\\bin\\ramDiskBank2_addr8000.bin.zx0"
toBank1addr0:
.incbin "generated\\bin\\ramDiskBank1_addr0.bin.zx0"
toBank1addrA000:
.incbin "generated\\bin\\ramDiskBank1_addr8000.bin.zx0"
toBank0addr8000:
.incbin "generated\\bin\\ramDiskBank0_addr8000.bin.zx0"

; ram-disk data layout
; ramDiskBank0_0000 - sprites
; ramDiskBank0_8000 - tiles
; ramDiskBank1_0000 - sprites
; ramDiskBank1_8000 - $8000 music
; ramDiskBank2_0000 - 
; ramDiskBank2_8000 - $8000 code, A000-FFFF back buffer
