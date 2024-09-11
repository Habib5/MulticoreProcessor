org 0x0000

ORI $4, $0, 0xF0
ORI $5, $0, 0x0
ORI $6, $0, 0xF0

loop:
    ORI $7, $0, 0xDDDD
    ADDI $5, $5, 1

    nop
    nop
    nop

    LW $7, 0($6)
    
    nop
    nop

    BNE $5, $4, loop

halt

ORG 0x200
HALT
