org 0x0000 #S to I

ori $2, $0, 0x04
ori $3, $0, 0x69

sw $3, 0($2)

halt

org 0x0200 #S to M

nop
nop
nop
nop
nop

ori $2, $0, 0x08
ori $3, $0, 0x69

lw $3, 0($2)
sw $3, 0($2)

halt
