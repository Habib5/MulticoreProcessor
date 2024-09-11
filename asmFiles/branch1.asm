ORG 0x000

#BEQ taken

main1:
    ORI $2, $0, 5
    ORI $3, $0, 5

    BEQ $2, $3, jump

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
