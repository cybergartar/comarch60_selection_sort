    AREA myData, DATA, READWRITE
    ; an array to sort and it's length
array   DCD 24, 10, 56, 62, 50, 43, 21, 17, 35, 55
len		EQU 10

    AREA myCode, CODE
        ENTRY
        EXPORT main
            
main
    NOP
    ; store array address in [r0]
    LDR		r0, =array

    ; let [r1] contains limit of array's index 
    ; (this is lim variable in sort function)
    MOV     r1, #len
    SUB     r1, r1, #1

    ; let r2 be 1st parameter of sort function
    MOV     r2, #0

    ; call sort function
    BL      sort
    NOP

stop
    ; finish selection sort
    B		stop

;=================== END main() =================;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;               function sort()                  ;
; do a selection sort from index 0 to index [r1] ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

sort
    ; store return address and stage in stack
    SUB     sp, sp, #8
    STR     lr, [sp, #0]
    STR     r2, [sp, #4]

    ; if (stage == lim) then return
    CMP     r2, r1
    BEQ     ret_sort

    ; call findmin with parameters
    ; cmp = stage = [r2]

    ; now + 1 = [r3]
    ADD     r3, r2, #1
    ; stop = [r4] = [r1] (9)
    MOV     r4, r1
    BL      find_min

    ; store min_indx in [r3]
    MOV     r3, r2
    ; recall original [r2] (stage)
    ; from stack
    LDR     r2, [sp, #4]
    ; swap array[min_indx] and array[stage]
    ;              [r3]              [r2]
    BL      swap

    ; call sort(stage + 1, lim)
    ; stage + 1 = [r2] + 1
    ADD     r2, r2, #1
    BL      sort

    ; sort function's return
ret_sort
    ; recall lr back from stack
    LDR     lr, [sp, #0]
    ; free stack
    ADD     sp, sp, #8
    ; return
    MOV     pc, lr
;=================== END sort() =================;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                function find_min               ;
; find an index of array that contains smallest  ;
; number in range stage to lim                   ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
find_min
    ; store return address in stack
    SUB     sp, sp, #4
    STR     lr, [sp, #0]

    ; now = r3
    ; cmp = r2
    ; stop = r4

    ; variable this_is_min will be stored in [r2]

    ; if (array[now] < array[cmp])
if_ary_now_less_than_ary_cmp
    LDR     r5, [r0, r3, LSL #2]
    LDR     r6, [r0, r2, LSL #2]
    CMP     r5, r6
    BGE     endif_ary_now_less_than_ary_cmp
    ; this_is_min = now [r3]
    MOV     r2, r3

endif_ary_now_less_than_ary_cmp
    ; if jump to this directly, 
    ; this_is_min = cmp = [r2]
    NOP

    ; if (now == stop)
if_now_equal_to_stop
    CMP     r3, r4
    ; then return
    BEQ     ret_find_min

    ; else call find_min with parameters
    ; cmp = this_is_min = [r2]
    ; now = now + 1 = [r3] + 1
    ; stop = [r4]
    ADD     r3, r3, #1
    BL      find_min

    ; find_min's function reuturn
ret_find_min
    ; recall lr back from stack
    LDR     lr, [sp, #0]
    ; free stack
    ADD     sp, sp, #4
    ; return
    MOV     pc, lr
;================ END find_min() ===============;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; function swap                                  ;
; swap value in array index [r2] and [r3]        ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
swap
    LDR     r4, [r0, r2, LSL #2]
    LDR     r5, [r0, r3, LSL #2]
    STR     r4, [r0, r3, LSL #2]
    STR     r5, [r0, r2, LSL #2]
    MOV     pc, lr
;=================== END swap() =================;

    END