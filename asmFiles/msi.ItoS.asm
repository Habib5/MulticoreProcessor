org 0x0000 #M to I

ori $2, $0, 0x04
ori $3, $0, 0x69

sw $3, 40($2)

halt

org 0x0200

nop
nop
nop
nop
nop

ori $2, $0, 0x04
ori $3, $0, 0x69

sw $3, 40($2)

halt


















