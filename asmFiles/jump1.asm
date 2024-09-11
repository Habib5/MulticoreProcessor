ORG 0x0000
# J test

main:
    J jump

    ORI $4, $0, 0xFF00 #error statement
    ORI $5, $0, 105

    SW $5, 0($4)

    HALT

jump: 
    ORI $6, $0, 0xFF00 #success statement
    ORI $7, $0, 9
    SW $7, 4($6)

    HALT

