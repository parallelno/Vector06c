; input:
; hl - packed data addr
; de - unpacked data addr

; lz77 format:   chunk, chunk, ..., 0
; chunk:    dupMarker, chunkEndMarker, byte, byte, byte, dupMarker, %CCCPPPPP, byte, byte, ..., chunkEndMarker
; dupMarker - any unique number in the chunk. can't be 0
; chunkEndMarker - any unique number in the chunk. can't be 0
; %CCCPPPPP format:
; CCC - the length of the data to dup. dupLen = CCC + 3, 
;       dupLen in the range [3, 10], because the length less than three has no sence.
; PPPPP - a relative back pointer to the unpacked data to copy from.
;       copyFromPtr = currentPtr - backPtr. backPtr = PPPPP + dupLen
;       the backPtr in the range [3, 31+dupLen], backPtrMax= 41

; %CCCCPPPP format:
; CCCC - the length of the data to dup. dupLen = CCCC + 3, 
;     dupLen in the range [3, 18], because the length less than three has no sence
; PPPP - a relative back pointer to the unpacked data to copy from.
; copyFromPtr = currentPtr - backPtr. backPtr = PPPP + dupLen
;     the backPtr in the range [3, 15+dupLen], backPtrMax=33

LZ77_CODE_CCC_PPPPP = 0
LZ77_CODE_CCCC_PPPP = 1

LZ77_CODE_TYPE = LZ77_CODE_CCCC_PPPP

DLz77:
@nextChunk:
            ; get a dup marker
            mov a, m
            ; if it's zero, we are done
            ora a
            rz
            sta @checkDupMarker + 1
            inx h
            ; get an end marker
            mov a, m
            sta @checkChunkEndMarker + 1
            inx h
@loop:            
            mov a, m
            inx h
@checkDupMarker:
            cpi TEMP_BYTE
            jz @dupBytes
@checkChunkEndMarker:   
            cpi TEMP_BYTE
            jz @nextChunk
            ; save a byte as is
            stax d
            inx d
            jmp @loop

@dupBytes:   
            ; get a special code 
            mov a, m
            ; get a dups lenght
        .if LZ77_CODE_TYPE == LZ77_CODE_CCC_PPPPP
            rlc_(3)
            ani %00000111
        .endif 
        .if LZ77_CODE_TYPE == LZ77_CODE_CCCC_PPPP
            rlc_(4)
            ani %00001111        
        .endif
            ; the minimum dup length is 3
            adi 3
            sta @counter+1
            ; get a back pointer into HL
            ; backPtr = PPPPP + dupLen
            mov b, a
            mov a, m
        .if LZ77_CODE_TYPE == LZ77_CODE_CCC_PPPPP            
            ani %00011111
        .endif 
        .if LZ77_CODE_TYPE == LZ77_CODE_CCCC_PPPP            
            ani %00001111
        .endif        
            add b
            ; backPtr = -backPtr
            cma
            mov c, a
            mvi b, $ff
            inx b
            push h
            mov h, d
            mov l, e
            ; unpachedDataPtr += backPtr
            dad b
@counter:
            mvi b, TEMP_BYTE
            ; copy dups
@dupBytesLoop:            
            mov a, m
            stax d
            inx h
            inx d 
            dcr b
            jnz @dupBytesLoop
            pop h
            inx h
            jmp @loop
            .closelabels