ORG 0x0000

main: 
    ORI $29, $0, 0xFFFC #initialized addr

    #constants
    ORI $5,  $0, 30   
    ORI $6,  $0, 365
    ORI $7,  $0, 2000

    #dates   
    ORI $8,  $0, 11 #currentday
    ORI $9,  $0, 1 #currentmonth   
    ORI $10, $0, 2023 #currentyear

    ORI $11, $0, 2023 #firstsum
    ORI $12, $0, 2023 #secondsum
    
    ADDI $9, $9, -1
    PUSH $9
    PUSH $5
    J mult

first:
    POP $11
    ADD $11, $11, $8

    ADDI $10, $10, -2000
    PUSH $10
    PUSH $6
    J mult2

second:
    POP $12
    ADD $12, $12, $11
    PUSH $12
    HALT

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
    J first

mult2:
    POP $2 #first operand
    POP $3 #second operand
    ORI $4, $0, 0 #sum, DESTINATION REGISTER

loop2:
    BEQ $3, $0, finish2
    ADD $4, $4, $2
    ADDI $3, $3, -1
    J loop2

finish2:
    PUSH $4 #push result to stack
    J second
    
ORG 0x200
HALT


