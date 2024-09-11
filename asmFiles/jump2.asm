ORG 0x0000
#JR and JAL test

main:
    JAL jumpjal

    ORI $6, $0, 0xFF00 #success statement
    ORI $7, $0, 9
    SW $7, 4($6)

    HALT

#error JAL if $3 is not 9

jumpjal:
    ORI $3, $0, 9
    JR $31

    ORI $4, $0, 0xFF00 #error JR statement
    ORI $5, $0, 105
    SW $5, 0($4)

    HALT
    
