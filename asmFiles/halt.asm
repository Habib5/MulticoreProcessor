ORG 0x0000

main:
    ORI $2, $0, 5

    HALT

    ORI $3, $0, 0xFF00 #error statement
    SW $2, 0($3)
    ORI $4, $0, 105
    SW $4, 0($3)

