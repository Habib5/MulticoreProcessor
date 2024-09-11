ORG 0x0000

main: #test case, should be f in $4
    ORI $29, $0, 0xFFFC #initialized addr
    ORI $2, $0, 3
    ORI $3, $0, 4
    PUSH $2
    PUSH $3

mult:
    POP $2 #first operand
    POP $3 #second operand
    ORI $4, $0, 0 #sum, DESTINATION REGISTER

loop:
    BEQ $3, $0, finish
    ADD $4, $4, $2
    ADDI $3, $3, -1
    J loop

finish:
    PUSH $4 #push result to stack
    HALT
    



