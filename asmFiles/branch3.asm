ORG 0x0000

#BNE taken

main1:
    ORI $2, $0, 7
    ORI $3, $0, 8

    BNE $2, $3, jump

    ORI $4, $0, 0xFF00 #error statement
    ORI $5, $0, 105
    SW $5, 0($4)

    HALT

jump:
    ORI $6, $0, 0xFF00 #success statement
    ORI $7, $0, 9
    SW $7, 4($6)

    HALT

ORG 0x200
HALT
