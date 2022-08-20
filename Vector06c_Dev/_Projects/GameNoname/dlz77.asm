; 13 bytes saved with packing lz77

;hl - packed data addr,
;de - unpacked data addr

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
/*            
; hl - unpacked data addr
; de - original data addr
; bc - end original data addr
; return:
; fails - bc unchanged
; pass - bc = 0
Dlz77Check:
            ldax d
            cmp m
            rnz
            inx h
            inx d
            mov a, d
            cmp b
            jnz Dlz77Check
            mov a, e
            cmp c
            jnz Dlz77Check
            lxi b, 0
            ret
            .closelabels
*/          




/*
243, 
62, 
38, 
211, 
8, 
33, 
56, 
0, 
54, 
201, 
38, 
127, 
249, 
175, 
211, 
16, 
119, 
35, 
188, 
194, 
16, 
1, 
17, 
0, 
224, 
33, 
0, 
249, 
54, 
255, 
235, 
x, 
b, 
19, 
35, 
175, 
180, 
194, 
28, 
1, 
38, 
207, 
22, 
20, 
205, 
167, 
1, 
17, 
255, 
38, 
38, 
199, 
x, 
b, 
38, 
216, 
x, 
b, 
211, 
1, 
33, 
64, 
244, 
205, 
142, 
x, 
b, 
148, 
205, 
142, 
1, 
33, 
135, 
1, 
52, 
126, 
254, 
120, 
218, 
90, 
1, 
211, 
11, 
52, 
126, 
198, 
130, 
17, 
211, 
1, 
245, 
38, 
176, 
205, 
141, 
1, 
241, 
38, 
144, 
x, 
b, 
251, 
118, 
62, 
136, 
211, 
0, 
33, 
240, 
1, 
62, 
15, 
165, 
211, 
2, 
126, 
211, 
12, 
227, 
227, 
227, 
227, 
44, 
211, 
12, 
194, 
116, 
1, 
62, 
120, 
211, 
3, 
195, 
76, 
1, 
111, 
14, 
23, 
19, 
26, 
254, 
31, 
194, 
160, 
1, 
6, 
18, 
205, 
194, 
1, 
5, 
194, 
153, 
1, 
x, 
b, 
194, 
144, 
1, 
201, 
46, 
255, 
14, 
41, 
13, 
202, 
169, 
1, 
121, 
186, 
210, 
182, 
1, 
54, 
240, 
229, 
124, 
214, 
64, 
103, 
115, 
225, 
45, 
194, 
171, 
1, 

201, 
119, 
229, 
103, 
62, 
128, 
41, 
31, 
210, 
199, 
1, 
225, 
36, 
119, 
37, 
126, 
45, 
13, 
201, 
3, 
31, 
15, 
0, 
0, 
0, 
0, 
0, 
12, 
32, 
32, 
32, 
35, 
7, 
0, 
8, 
8, 
8, 
35, 
39, 
39, 
32, 
35, 
0, 
3, 
x, 
b,
155, 
104, 
255, 
0, 
31, 
x, 
b, 
255, 
x, 
b
*/