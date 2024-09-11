org 0x0000

ori $2, $0, 0x04
ori $3, $0, 0x08

ori $4, $0, 0x6969
ori $5, $0, 0x0404

sw $4, 200($2) #fix this so that an offset is not necessary
sw $5, 200($3)

nop
nop
nop
nop
nop

lw $6, 200($2)
lw $7, 200($3)

nop
nop
nop
nop
nop

halt

ORG 0x200
HALT
