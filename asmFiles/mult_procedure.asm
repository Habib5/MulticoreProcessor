ORG 0x0000

main: #test case, should be f in $4
    ORI $29, $0, 0xFFFC #initialized addr
    ORI $2, $0, 3   
    ORI $3, $0, 7
    ORI $4, $0, 5
    PUSH $2
    PUSH $3
    PUSH $4

setaddr:
    ORI $28, $0, 0xFFF8
    BEQ $29, $28, finishFINAL
    J mult

mult:
    POP $2 #first operand
    POP $3 #second operand
    ORI $4, $0, 0 #sum

loop:
    BEQ $3, $0, finish
    ADD $4, $4, $2
    ADDI $3, $3, -1
    J loop

finishFINAL:
    HALT

finish:
    PUSH $4
    J setaddr
