    AREA myCode, CODE
        ENTRY
        EXPORT __main
            
__main

init	
    ; array = [24, 10, 56, 62, 50, 43, 21, 17, 35, 55]
    ; initial array
    ; copy pre defined array into RAM (READWRITE area)
    ADR		r0, pre_sort
    LDR		r2, =array
    ADR		r3, end_pre_sort
    MOV		r4, #0                  ; array length counter
    
init_array
    LDR		r1, [r0]
    STRB	r1, [r2], #4
    ADD		r0, r0, #4
    ADD		r4, r4, #1
    CMP		r0, r3
    BLT		init_array
    NOP
    
    ; store array address in r0
    LDR		r0, =array
    
    ; init variable
    MOV		r1, r4                  ; array len (n)
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
    B		stop                        ; finish selection sort

;	pre defined data
pre_sort        DCD	24, 10, 56, 62, 50, 43, 21, 17, 35, 55
end_pre_sort    DCD 0


    AREA myData, DATA, READWRITE
array			DCD 0

    END