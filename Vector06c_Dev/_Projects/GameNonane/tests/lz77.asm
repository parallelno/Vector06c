; 13 bytes saved with packing lz77

;hl - packed data addr,
;de - unpack data addr

; struct:   .db checkDupMarker, checkChunkEndMarker, byte, byte, byte, checkDupMarker, %CCCPPPPP, checkChunkEndMarker, 0

TEMP_BYTE = 0
nextChunk:
            ; get a dup marker in B
            mov a, m
            ; if it's zero, we are done
            cmp a
            rz
            sta checkDupMarker + 1
            inx h
            ; get an end marker
            mov a, m
            sta checkChunkEndMarker + 1
            inx h
loop:            
            mov a, m
            inx h
checkDupMarker:
            cmp TEMP_BYTE
            jz dupBytes
checkChunkEndMarker:   
            cmp TEMP_BYTE
            jz nextChunk
            ; save a byte as is
            stax d
            inx d
            jmp loop ; 29

dupBytes:   
            ; get a special code %CCCPPPPP, PPPPP - pointer where a dup, CCC - how long it is
            mov a, m
            inx h
            push h
            push psw
            ; get a back pointer into HL
            ani %00011111
            ; the closest possible dup is 4 bytes ahead.
            add 4
            cma
            mov c, a
            mvi b, $ff
            inx b
            dad b
            pop psw
            ; get a counter into B
            rlc
            rlc
            rlc
            ani %00000111
            ; increase by 3, becasue the minimum length of dups is 3
            inr a
            inr a
            inr a
            mov b, a
            ; copy dups
dupBytesLoop:            
            mov a, m
            inx h
            stax d
            inx d   ; 57
            dcr b
            jnz dupBytesLoop
            pop h
            jmp loop    ; 65

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