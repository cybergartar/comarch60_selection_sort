        AREA myData, DATA, READWRITE
array   DCD 24, 10, 56, 62, 50, 43, 21, 17, 35, 55
len		EQU 10
	
	AREA myCode, CODE
		ENTRY
        EXPORT main
            
main
    NOP
    ; store array address in r0
    LDR		r0, =array
    
    ; init variable
    MOV		r1, #len                ; array len (n)
    SUB		r2, r1, #1              ; array len - 1 (n-1)
    MOV		r3, #0                  ; i
    MOV		r4, #0                  ; j
    MOV		r5, #0                  ; min_idx
    
    NOP
    
loop_i
    MOV		r5, r3                  ; min_idx = i
    ADD		r4, r3, #1              ; j = i + 1
    
loop_j
    LDR		r6, [r0, r4, LSL #2]    ; array[j]
    LDR		r7, [r0, r5, LSL #2]    ; array[min_idx]
    CMP		r6, r7                  ; if (array[j] < array[min_idx])
    
    BGE		finish_cmp
    
    MOV		r5, r4                  ; min_idx = j

finish_cmp
    ADD		r4, r4, #1              ; j++
    CMP		r4, r1                  ; j < n?
    BLT		loop_j                  ; if less, continue do loop_j
    
    LDR		r6, [r0, r5, LSL #2]    ; r6 = array[min_idx]
    LDR		r7, [r0, r3, LSL #2]    ; r7 = array[i]
    STR		r6, [r0, r3, LSL #2]    ; SWAP: array[i] = r6
    STR		r7, [r0, r5, LSL #2]    ; array[min_idx] = r7
    
    ADD		r3, r3, #1              ; i++
    CMP		r3, r2                  ; i < n-1 ?
    BLT		loop_i                  ; if less, continue do loop_i
    
    NOP

stop	
    B		stop                    ; finish selection sort

    END